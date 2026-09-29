#!/usr/bin/env python3
"""C2 基准脚本的离线测试：假引擎实现同一 stdin/stdout/stderr 协议，端到端跑
bench.sh（drive + parse 两种模式）。不依赖 GPU / 模型权重 / 分词器。"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FAKE = '/tmp/fake_bench_engine.py'

with open(FAKE, 'w') as f:
    f.write('''#!/usr/bin/env python3
import os, sys
MTP = 3
PROF = os.environ.get('RT_PROF') == '1'
GEMV2 = os.environ.get('RT_MTPBENCH_GEMV') == '2'
print('READY 1.2', flush=True)
RUN_MS = {1: 27000.0, 2: 27270.0, 3: 26730.0}
run_no = 0
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    op, _, arg = line.partition(' ')
    if op == 'QUIT':
        break
    if op == 'RESET':
        print('OK reset', flush=True)
    elif op == 'MTP':
        MTP = int(arg)
        print(f'OK mtp {MTP}', flush=True)
    elif op == 'PREFILL':
        run_no += 1
        n = len(arg.split(',')) if arg else 0
        ms = RUN_MS.get(run_no, 27000.0)
        print(f'OK prefill total={n} computed={n} reused=0 mode=none ms={ms:.1f} '
              f'tps={n / ms * 1000:.1f} 100:0.300 200:0.200', flush=True)
        if PROF:
            print('PROF prefill: 3.30 ms/步（n=%d 步，合计 %.1f ms）' % (n, 3.3 * n), file=sys.stderr, flush=True)
            print('PROF   linear            2.10 ms   63.6%', file=sys.stderr, flush=True)
            print('PROF   attn              0.80 ms   24.2%', file=sys.stderr, flush=True)
    elif op == 'GEN':
        f = arg.split(' ')
        n = int(f[0])
        for i in range(n):
            print(f'TOK {1000 + i}', flush=True)
        ms = 12500.0 if MTP > 0 else 21000.0
        print(f'END {n} {ms:.1f}', flush=True)
        if MTP > 0:
            print('MTP 统计：轮数 250，草稿 750，接受 450（1.800 token/轮，60.0%）',
                  file=sys.stderr, flush=True)
            print('MTP 自适应：接受率 ema=0.72（RT_MTP_ADAPTIVE=0 可关）',
                  file=sys.stderr, flush=True)
        if PROF:
            print(f'PROF decode: {ms / n:.2f} ms/步（n={n} 步，合计 {ms:.1f} ms）',
                  file=sys.stderr, flush=True)
            print('PROF   linear            12.00 ms   48.0%', file=sys.stderr, flush=True)
            print('PROF   mtp                6.00 ms   24.0%', file=sys.stderr, flush=True)
    elif op == 'MTPBENCH':
        steps = int(arg) if arg else 30
        if GEMV2:
            mats = [('mtp.fc   [5120x10240]', '0.8300', '466', '0.026'),
                    ('q_proj   [12288x5120]', '1.9500', '382', '0.063'),
                    ('lm_head  [248320x5120]', '33.1000', '489', '0.637')]
            for name, m, g, gb in mats:
                print(f'MTPBENCH 单矩阵 {name}  {m} ms  {g} GB/s（{gb} GB）', flush=True)
        print(f'MTPBENCH steps={steps} head=1  7.200 ms/步  385 GB/s（0.468 GB/步，合计 216.0 ms）',
              flush=True)
        print(f'MTPBENCH 启动探针: {steps * 32} 个独立小 kernel（无依赖）  8.900 µs/kernel',
              flush=True)
        print(f'MTPBENCH 依赖链探针: {steps * 32} 个串行小 kernel（依赖前一个）  12.300 µs/kernel',
              flush=True)
        if PROF:
            print('PROF mtpbench: 7.20 ms/步（n=%d 步，合计 216.0 ms）' % steps, file=sys.stderr, flush=True)
            print('PROF   linear            7.10 ms   98.6%', file=sys.stderr, flush=True)
''')
os.chmod(FAKE, 0o755)

fails = []


def check(name, cond):
    print(('ok  ' if cond else 'FAIL') + '  ' + name)
    if not cond:
        fails.append(name)


env = dict(os.environ)
env['RT_ENGINE_BIN'] = FAKE
env['RT_RT4'] = '/nonexistent.rt4'          # 假引擎不看权重路径
env['RT_RT4_JSON'] = '/nonexistent.rt4.json'
env.pop('RT_MODEL_DIR', None)

LOG = '/tmp/BENCHLOG_test.md'
RAW = '/tmp/bench_raw_test.log'
ERR = '/tmp/bench_err_test.log'
for p in (LOG, RAW, ERR):
    if os.path.exists(p):
        os.remove(p)

# ---- 1) drive 模式（含 --prof），--no-append，自定义输出 ----
r = subprocess.run(
    ['bash', f'{ROOT}/scripts/bench.sh', '--prof', '--no-append', '--raw', RAW, '--out', LOG],
    capture_output=True, text=True, env=env, cwd=ROOT, timeout=120)
check('drive 退出码 0', r.returncode == 0)
md = r.stdout
if r.returncode != 0:
    print('--- stderr ---\\n' + r.stderr[-3000:])
    print('--- stdout ---\\n' + r.stdout[-3000:])

# P_prefill：三次 27000/27270/26730ms × 8192tok → tps 303.4/300.4/306.7，中位 303.4
check('P_prefill 中位 303.4', 'P_prefill' in md and '303.4' in md)
check('P_prefill 含各轮明细', '8192tok@27000ms=303.4' in md)
check('D_mtp3 = 40.0', 'D_mtp3' in md and '**40.0**' in md)
check('A_mtp = 1.800 / 60.0%', '1.800' in md and '60.0%' in md)
check('MTP 自适应 ema=0.72', 'ema' in md and '0.72' in md)
check('D_nomtp = 23.8', '23.8' in md)
check('MTP 加速 1.68×', '1.68×' in md)
check('MTPBENCH 单矩阵表', 'mtp.fc' in md and '466' in md and 'lm_head' in md)
check('MTPBENCH steps 行', 'steps=30' in md and '7.200 ms/步' in md and '385' in md)
check('探针行', '启动探针' in md and '8.90' in md and '依赖链探针' in md and '12.30' in md)
check('PROF decode 桶', 'PROF decode' in md and 'linear' in md and '48.0%' in md)
check('PROF prefill 桶', 'PROF prefill' in md and '63.6%' in md)
check('PROF mtpbench 桶', 'PROF mtpbench' in md and '98.6%' in md)
check('--no-append 不写文件', not os.path.exists(LOG))

raw = open(RAW, encoding='utf-8').read()
for phase in ('# phase prefill run=0 warmup=1', '# phase prefill run=3',
              '# phase gen_mtp3', '# phase gen_nomtp', '# phase mtpbench'):
    check(f'raw 含 {phase.split("=", 1)[0]}', phase in raw)
check('raw 含 warmup 的 OK prefill', raw.count('OK prefill') == 4)
check('raw 含 STDERR MTP 统计', 'STDERR MTP 统计' in raw)
check('raw 含 依赖链探针（终止行）', 'MTPBENCH 依赖链探针' in raw)

# ---- 2) 入档模式：追加两次 → 两个小节 ----
for _ in range(2):
    r2 = subprocess.run(['bash', f'{ROOT}/scripts/bench.sh', '--out', LOG],
                         capture_output=True, text=True, env=env, cwd=ROOT, timeout=120)
    check('入档运行退出码 0', r2.returncode == 0)
log_md = open(LOG, encoding='utf-8').read()
check('BENCHLOG 追加两个小节', log_md.count('## 20') == 2)
check('BENCHLOG 含 git 元信息', 'git ' in log_md)

# ---- 3) parse 模式：重解析与 drive 输出一致 ----
r3 = subprocess.run(['bash', f'{ROOT}/scripts/bench.sh', 'parse', RAW],
                    capture_output=True, text=True, env=env, cwd=ROOT, timeout=60)
check('parse 退出码 0', r3.returncode == 0)
check('parse 与 drive 同值', '303.4' in r3.stdout and '**40.0**' in r3.stdout
      and '1.800' in r3.stdout and '7.200 ms/步' in r3.stdout)

# ---- 4) parse 容错：缺指标的残缺转录不崩，输出占位 ----
with open('/tmp/bench_raw_min.log', 'w') as f:
    f.write('# bench raw v1\\n# phase prefill run=1\\nOK prefill total=10 computed=10 '
            'reused=0 mode=none ms=100.0 tps=100.0\\n')
r4 = subprocess.run(['bash', f'{ROOT}/scripts/bench.sh', 'parse', '/tmp/bench_raw_min.log'],
                    capture_output=True, text=True, env=env, cwd=ROOT, timeout=60)
check('残缺转录 parse 退出码 0', r4.returncode == 0)
check('残缺转录含占位', 'D_mtp3（贪心 tok/s） | —（无有效数据）' in r4.stdout)

# ---- 5) 引擎缺失时报错清晰 ----
env_bad = dict(env)
env_bad['RT_ENGINE_BIN'] = '/nonexistent/rt'
r5 = subprocess.run(['bash', f'{ROOT}/scripts/bench.sh'], capture_output=True,
                    text=True, env=env_bad, cwd=ROOT, timeout=60)
check('引擎缺失退出码非 0 且提示', r5.returncode != 0 and 'build.sh' in r5.stderr)

print()
print('PASS' if not fails else f'FAILED: {fails}')
sys.exit(0 if not fails else 1)
