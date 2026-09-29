#!/usr/bin/env python3
"""性能基准（方案 0.2 节的四指标 + MTPBENCH 单矩阵表）。

  python3 scripts/bench_parse.py drive [--tokens 8192] [--gen 500] [--runs 3]
                                       [--prof] [--raw PATH] [--out docs/BENCHLOG.md]
                                       [--no-append]
  python3 scripts/bench_parse.py parse RAWLOG          # 只解析已有转录（离线可测）

drive 跑引擎（RT_ENGINE_BIN / RT_RT4 / RT_RT4_JSON 同 chat.py），把原始输出记进
raw 转录（build/bench/bench_raw_*.log），再把解析结果以 markdown 追加进 docs/BENCHLOG.md。
所有优化项的验收数据以本脚本输出为准。

raw 转录格式（行文本）：
  # bench raw v1                       版本
  # meta k=v ...                       元信息（date/git/engine/load_s/...）
  # phase prefill run=1 [warmup=1]     阶段标记；其后是引擎 stdout 原样行
  OK prefill total=...                 引擎协议行（见 src/model.cpp engine 模式）
  STDERR ...                           该阶段引擎 stderr 的新增行（MTP 统计 / PROF）
  # phase gen_mtp3 / gen_nomtp / mtpbench
"""
import argparse
import datetime
import os
import re
import statistics
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ---------------- 引擎协议行的正则（与 src/model.cpp 的 printf 格式一一对应） ----------------

RE_PREFILL = re.compile(
    r'^OK prefill total=(\d+) computed=(\d+) reused=(\d+) mode=(\S+) '
    r'ms=([\d.]+) tps=([\d.]+)')
RE_END = re.compile(r'^END (\d+) ([\d.]+)( stopped)?$')
RE_MTP_STAT = re.compile(
    r'^MTP 统计：轮数 (\d+)，草稿 (\d+)，接受 (\d+)（([\d.]+) token/轮，([\d.]+)%）')
RE_MTP_EMA = re.compile(r'^MTP 自适应：接受率 ema=([\d.]+)')
RE_MB_MAT = re.compile(
    r'^MTPBENCH 单矩阵 (.+?)\s+([\d.]+) ms\s+([\d.]+) GB/s（([\d.]+) GB）')
RE_MB_STEP = re.compile(
    r'^MTPBENCH steps=(\d+) head=(\d+)\s+([\d.]+) ms/步\s+([\d.]+) GB/s'
    r'（([\d.]+) GB/步，合计 ([\d.]+) ms）')
RE_MB_PROBE = re.compile(
    r'^MTPBENCH (启动探针|依赖链探针): (\d+) 个(?:独立|串行)小 kernel（[^）]*）\s+([\d.]+) µs/kernel')
RE_PROF_TOT = re.compile(r'^PROF (\S+): ([\d.]+) ms/步（n=(\d+) 步，合计 ([\d.]+) ms）')
RE_PROF_ROW = re.compile(r'^PROF\s+(\S+)\s+([\d.]+) ms\s+([\d.]+)%$')

GEN_PROMPT = ('请写一篇短文，介绍 GPU 汇编内核优化的一般方法：指令调度、寄存器压力、'
              '访存合并与 bank 冲突，并给出你自己的理解。')
PREFILL_PARA = ('性能基准段落。The quick brown fox jumps over the lazy dog. '
                '大规模语言模型推理的算力瓶颈集中在 GEMM 与注意力，权重经 NVFP4 量化后'
                '显存带宽成为第一约束，因此内核优化的核心是提升有效带宽利用率。')


# ================= 纯解析（离线可测，不碰引擎） =================

def _new_rep():
    return {'meta': {}, 'prefill_runs': [], 'gen': {}, 'mb_mats': [], 'mb_step': None,
            'mb_probe': {}, 'prof': {}}


def parse_raw(lines):
    """raw 转录（行序列）→ 报告 dict。容错：不认识的行忽略，缺指标时用 None。"""
    rep = _new_rep()
    phase = None
    cur_run = None
    prof_tag = None
    for raw in lines:
        line = raw.rstrip('\n')
        if line.startswith('# meta '):
            k, _, v = line[len('# meta '):].partition('=')
            rep['meta'][k.strip()] = v.strip()
            continue
        if line.startswith('# phase '):
            fields = line[len('# phase '):].split()
            phase = fields[0]
            cur_run = None
            if phase == 'prefill':
                kw = dict(f.split('=', 1) for f in fields[1:] if '=' in f)
                cur_run = {'run': int(kw.get('run', 0)), 'warmup': kw.get('warmup') == '1',
                           'line': None}
                rep['prefill_runs'].append(cur_run)
            prof_tag = None
            continue
        if line.startswith('STDERR '):
            body = line[len('STDERR '):]
            m = RE_MTP_STAT.match(body)
            if m:
                rep['gen'].setdefault(phase, {})['mtp_stat'] = {
                    'rounds': int(m.group(1)), 'draft': int(m.group(2)),
                    'acc': int(m.group(3)), 'per_round': float(m.group(4)),
                    'pct': float(m.group(5))}
                continue
            m = RE_MTP_EMA.match(body)
            if m:
                rep['gen'].setdefault(phase, {})['mtp_ema'] = float(m.group(1))
                continue
            m = RE_PROF_TOT.match(body)
            if m:
                prof_tag = m.group(1)
                rep['prof'][prof_tag] = {'ms_step': float(m.group(2)), 'n': int(m.group(3)),
                                         'rows': []}
                continue
            m = RE_PROF_ROW.match(body)
            if m and prof_tag and prof_tag in rep['prof']:
                rep['prof'][prof_tag]['rows'].append(
                    (m.group(1), float(m.group(2)), float(m.group(3))))
                continue
            continue
        # 引擎 stdout 行
        m = RE_PREFILL.match(line)
        if m and cur_run is not None:
            cur_run.update(total=int(m.group(1)), computed=int(m.group(2)),
                           reused=int(m.group(3)), mode=m.group(4),
                           ms=float(m.group(5)), tps=float(m.group(6)))
            continue
        m = RE_END.match(line)
        if m and phase and phase.startswith('gen'):
            rep['gen'].setdefault(phase, {})['end'] = {
                'produced': int(m.group(1)), 'ms': float(m.group(2)),
                'stopped': m.group(3) is not None}
            continue
        m = RE_MB_MAT.match(line)
        if m:
            rep['mb_mats'].append({'name': m.group(1), 'ms': float(m.group(2)),
                                   'gbs': float(m.group(3)), 'gb': float(m.group(4))})
            continue
        m = RE_MB_STEP.match(line)
        if m:
            rep['mb_step'] = {'steps': int(m.group(1)), 'head': int(m.group(2)),
                              'ms_step': float(m.group(3)), 'gbs': float(m.group(4)),
                              'gb_step': float(m.group(5)), 'ms_total': float(m.group(6))}
            continue
        m = RE_MB_PROBE.match(line)
        if m:
            rep['mb_probe'][m.group(1)] = {'n': int(m.group(2)), 'us_kernel': float(m.group(3))}
            continue
    return rep


def _tps_of_end(e):
    if not e or e['stopped'] or e['ms'] <= 0:
        return None
    return e['produced'] / e['ms'] * 1000.0


def to_markdown(rep):
    m = rep['meta']
    out = []
    title = m.get('date', '?')
    if m.get('git'):
        title += ' · git ' + m['git']
    out.append(f'## {title}')
    out.append('')

    rows = []
    runs = [r for r in rep['prefill_runs'] if not r.get('warmup') and r.get('tps')]
    if runs:
        best = max(runs, key=lambda r: r['tps'])
        med = statistics.median([r['tps'] for r in runs])
        det = ' / '.join(f"{r['computed']}tok@{r['ms']:.0f}ms={r['tps']:.1f}" for r in runs)
        rows.append(('P_prefill（tok/s）',
                     f"**{med:.1f}**（中位；最优 {best['tps']:.1f}；{det}）"))
    else:
        rows.append(('P_prefill（tok/s）', '—（无有效数据）'))

    g3 = rep['gen'].get('gen_mtp3', {})
    t3 = _tps_of_end(g3.get('end'))
    if t3 is not None:
        e = g3['end']
        rows.append(('D_mtp3（贪心 tok/s）', f"**{t3:.1f}**（{e['produced']} tok / {e['ms']:.0f} ms）"))
    else:
        rows.append(('D_mtp3（贪心 tok/s）', '—（无有效数据）'))

    st = g3.get('mtp_stat')
    if st:
        rows.append(('A_mtp（接受 token/轮）',
                     f"**{st['per_round']:.3f}**（{st['acc']}/{st['draft']}，{st['pct']:.1f}%，"
                     f"{st['rounds']} 轮）"))
    if 'mtp_ema' in g3:
        rows.append(('MTP 自适应 ema', f"{g3['mtp_ema']:.2f}"))

    g0 = rep['gen'].get('gen_nomtp', {})
    t0 = _tps_of_end(g0.get('end'))
    if t0 is not None:
        e = g0['end']
        sp = f"（MTP 加速 {t3 / t0:.2f}×）" if t3 else ''
        rows.append(('D_nomtp（参照 tok/s）', f"{t0:.1f}（{e['produced']} tok / {e['ms']:.0f} ms）{sp}"))

    for k, v in (('加载（s）', m.get('load_s')), ('引擎', m.get('engine')),
                 ('prompt 来源', m.get('prompt')), ('参数', m.get('args'))):
        if v:
            rows.append((k, str(v)))

    out.append('| 指标 | 值 |')
    out.append('|---|---|')
    out.extend(f'| {k} | {v} |' for k, v in rows)
    out.append('')

    if rep['mb_mats'] or rep['mb_step']:
        out.append('MTPBENCH（GEMV=2 单矩阵带宽）：')
        out.append('')
        out.append('| 矩阵 | ms | GB/s |')
        out.append('|---|---|---|')
        out.extend(f"| {r['name']} | {r['ms']:.4f} | {r['gbs']:.0f} |" for r in rep['mb_mats'])
        s = rep['mb_step']
        if s:
            out.append(f"| **合计（steps={s['steps']} head={s['head']}）** "
                       f"| {s['ms_step']:.3f} ms/步 | {s['gbs']:.0f} |")
        for k in ('启动探针', '依赖链探针'):
            p = rep['mb_probe'].get(k)
            if p:
                out.append(f"| {k}（{p['n']} kernel） | — | {p['us_kernel']:.2f} µs/kernel |")
        out.append('')

    for tag in ('prefill', 'decode', 'mtpbench'):
        pr = rep['prof'].get(tag)
        if pr and pr['rows']:
            out.append(f'PROF {tag}：{pr["ms_step"]:.2f} ms/步（n={pr["n"]}）')
            out.append('')
            out.append('| 阶段 | ms/步 | 占比 |')
            out.append('|---|---|---|')
            out.extend(f'| {n} | {ms:.2f} | {pct:.1f}% |' for n, ms, pct in pr['rows'])
            out.append('')
    return '\n'.join(out).rstrip() + '\n'


# ================= drive：跑引擎生成 raw 转录 =================

def _emit(out, s):
    out.write(s + '\n')
    out.flush()


class ErrTail:
    """引擎 stderr 落盘 + 按阶段读新增行。

    写句柄交给子进程（O_APPEND，只有子进程动它）；读句柄是父进程私开的另一个
    open（独立 offset，seek 不影响子进程的写入位置）。

    take() 先「等静默」（idle_s 内文件不再增长）再快照：引擎的 MTP 统计 / PROF
    行写在 stdout 的 END/OK 行之后，两条流没有先后保证，按固定 offset 截会把
    上一阶段尾巴截进下一阶段。所有 take() 都发生在 stdout 同步点（OK/END/探针
    行）之后，引擎此刻已空闲，静默即完整。
    """

    def __init__(self, path, idle_s=0.03, timeout_s=3.0):
        self.path = path
        self._w = open(path, 'ab')
        self._r = open(path, 'rb')
        self._pos = 0
        self.idle_s = idle_s
        self.timeout_s = timeout_s

    def fileno_w(self):
        return self._w

    def _size(self):
        return os.fstat(self._r.fileno()).st_size

    def take(self):
        t0 = last_change = time.monotonic()
        size = self._size()
        while time.monotonic() - t0 < self.timeout_s:
            cur = self._size()
            if cur != size:
                size = cur
                last_change = time.monotonic()
            elif time.monotonic() - last_change >= self.idle_s:
                break
            time.sleep(0.002)
        if size <= self._pos:
            return []
        self._r.seek(self._pos)
        txt = self._r.read(size - self._pos).decode('utf-8', 'replace')
        self._pos = size
        return [l for l in txt.splitlines() if l.strip()]

    def close(self):
        self._r.close()
        self._w.close()


def _make_ids(n, kind):
    """生成基准用 token 序列。优先真分词（固定文本，可复现）；分词器不可用则确定性合成。"""
    try:
        sys.path.insert(0, os.path.join(ROOT, 'tools'))
        import tok
        if kind == 'gen':
            ids = tok.chat_ids([{'role': 'user', 'content': GEN_PROMPT}])
        else:
            ids = []
            while len(ids) < n:
                ids.extend(tok.encode(PREFILL_PARA))
            ids = ids[:n]
        if ids:
            return ids, 'tokenizer'
    except Exception:
        pass
    if kind == 'gen':
        base = [151644, 872, 198, 1131, 151645, 198, 151644, 77091, 198]   # chat 模板骨架
        return base + [1000 + (i * 7919) % 99000 for i in range(300)], 'synthetic'
    return [1000 + (i * 7919) % 99000 for i in range(n)], 'synthetic'


def _reset(eng):
    with eng.lock:
        eng.cmd('RESET')
        ack = eng.p.stdout.readline().strip()
    if ack != 'OK reset':
        raise RuntimeError(f'RESET 应答异常：{ack}')


def _set_mtp(eng, k):
    with eng.lock:
        eng.cmd(f'MTP {k}')
        ack = eng.p.stdout.readline().strip()
    if not ack.startswith('OK mtp'):
        raise RuntimeError(f'MTP {k} 应答异常：{ack}')


def _bench_mtpbench(eng, out, err, steps, base_ids):
    # MTPBENCH 需要先 PREFILL 建立 MTP KV；它自己会把对话前缀作废（跑完不再 prefill）
    _set_mtp(eng, 3)
    eng.prefill(base_ids)
    err.take()                                  # 丢弃 setup 阶段的 stderr（PROF prefill 等）
    _emit(out, f'# phase mtpbench steps={steps}')
    with eng.lock:
        eng.cmd(f'MTPBENCH {steps}')
        while True:
            line = eng.p.stdout.readline()
            if not line:
                raise RuntimeError('引擎在 MTPBENCH 中退出')
            line = line.strip()
            _emit(out, line)
            if line.startswith('MTPBENCH 依赖链探针'):
                break
    for l in err.take():
        _emit(out, 'STDERR ' + l)


def drive(args):
    sys.path.insert(0, os.path.join(ROOT, 'scripts'))
    import chat

    bdir = os.path.join(ROOT, 'build', 'bench')
    os.makedirs(bdir, exist_ok=True)
    ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    raw_path = args.raw or os.path.join(bdir, f'bench_raw_{ts}.log')
    err_path = os.path.join(bdir, f'bench_err_{ts}.log')

    long_ids, psrc = _make_ids(args.tokens, 'prefill')
    gen_ids, gsrc = _make_ids(0, 'gen')

    env_extra = {'RT_MTPBENCH_GEMV': '2'}
    if args.prof:
        env_extra['RT_PROF'] = '1'

    err = ErrTail(err_path)
    out = open(raw_path, 'w', encoding='utf-8')
    t0 = time.time()
    eng = chat.Engine(env_extra=env_extra, stderr=err.fileno_w(), log=False)
    load_s = time.time() - t0
    try:
        _emit(out, '# bench raw v1')
        _emit(out, f'# meta date={datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}')
        try:
            rev = subprocess.run(['git', '-C', ROOT, 'rev-parse', '--short', 'HEAD'],
                                 capture_output=True, text=True, timeout=5).stdout.strip()
        except Exception:
            rev = 'nogit'
        _emit(out, f'# meta git={rev or "nogit"}')
        _emit(out, f'# meta engine={eng._cmd[0]}')
        _emit(out, f'# meta load_s={load_s:.1f}')
        _emit(out, f'# meta prompt=prefill:{psrc}/{len(long_ids)}tok gen:{gsrc}/{len(gen_ids)}tok')
        _emit(out, f"# meta args=tokens={args.tokens} gen={args.gen} runs={args.runs}"
                    f" prof={int(args.prof)}")

        # P_prefill：1 次热身 + runs 次计量，之间 RESET 保证整段重算（去掉 KV 复用）
        for run in range(args.runs + 1):
            warm = run == 0
            _emit(out, f'# phase prefill run={run}' + (' warmup=1' if warm else ''))
            line = eng.prefill(long_ids)
            _emit(out, line)
            if not warm:
                for l in err.take():
                    _emit(out, 'STDERR ' + l)
            _reset(eng)

        # D_mtp3 / A_mtp：同一上下文贪心生成，END 行 + stderr 的 MTP 统计
        for phase, k in (('gen_mtp3', 3), ('gen_nomtp', 0)):
            _set_mtp(eng, k)
            eng.prefill(gen_ids)                 # 第二次起命中 KV 前缀复用，开销可忽略
            err.take()                           # 丢弃 setup 阶段的 stderr
            _emit(out, f'# phase {phase} mtp={k} n={args.gen} prefill={len(gen_ids)}')
            _toks, end = eng.gen(args.gen, temp=0.0, stops=[])
            _emit(out, end)
            for l in err.take():
                _emit(out, 'STDERR ' + l)

        _bench_mtpbench(eng, out, err, args.mb_steps, gen_ids)
        eng.close()
    finally:
        try:
            eng.close()
        except Exception:
            pass
        out.close()
        err.close()

    md = to_markdown(parse_raw(open(raw_path, encoding='utf-8').readlines()))
    print(md)
    if not args.no_append:
        log = args.out
        os.makedirs(os.path.dirname(log), exist_ok=True)
        with open(log, 'a', encoding='utf-8') as f:
            f.write(md + '\n')
        print(f'---\n已追加到 {log}；raw 转录：{raw_path}', file=sys.stderr)
    return md


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('mode', nargs='?', default='drive', choices=['drive', 'parse'],
                    help='drive=跑引擎并入档（默认）；parse=只解析已有 raw 转录')
    ap.add_argument('rawlog', nargs='?', help='parse 模式的 raw 转录路径')
    ap.add_argument('--tokens', type=int, default=8192, help='P_prefill 的 prompt 长度（≥8000）')
    ap.add_argument('--gen', type=int, default=500, help='生成阶段的 token 数')
    ap.add_argument('--runs', type=int, default=3, help='P_prefill 计量次数（取中位）')
    ap.add_argument('--mb-steps', type=int, default=30, help='MTPBENCH 步数')
    ap.add_argument('--prof', action='store_true', help='RT_PROF=1（分阶段耗时，轻微开销）')
    ap.add_argument('--raw', help='drive 模式 raw 转录输出路径（默认 build/bench/ 下带时间戳）')
    ap.add_argument('--out', default=os.path.join(ROOT, 'docs', 'BENCHLOG.md'),
                    help='markdown 追加目标')
    ap.add_argument('--no-append', action='store_true', help='只打印不入档')
    args = ap.parse_args()

    if args.mode == 'parse':
        if not args.rawlog:
            ap.error('parse 模式需要 raw 转录路径')
        md = to_markdown(parse_raw(open(args.rawlog, encoding='utf-8').readlines()))
        print(md, end='')
        return
    drive(args)


if __name__ == '__main__':
    main()
