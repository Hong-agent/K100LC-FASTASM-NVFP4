#!/usr/bin/env python3
"""跨请求 KV 复用（对话前缀 + 全局槽池）的正确性与收益。

第一部分：同一条多轮对话跑两遍——
  A) RT_NO_KV_REUSE=1 —— 每轮整段重算（原来的行为）
  B) 默认             —— 每轮只补差量（复用已缓存的 KV）
两遍的逐轮回答必须**逐字节一致**。

第二部分：全局 KV 池 A→B→A 切对话——
  A) RT_KV_POOL=0 —— 无池（旧行为）：切走再回来，KV 被覆盖，整段重算
  B) RT_KV_POOL=4 —— 有池：A 泊进槽，回来整段恢复，只补新消息
两遍的逐轮回答必须逐字节一致，且有池时 A 第 3 轮的计算量大幅下降。

用 bundled python 跑（需要 tokenizers）：
    PYTHONPATH=runtime/py runtime/python/bin/python3.10 tests/test_kv_reuse.py
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import time
from collections import namedtuple
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import tok as T                                              # noqa: E402

ENGINE = os.environ.get('RT_ENGINE_BIN') or str(ROOT / 'build' / 'rt')
MODEL = os.environ.get('RT_RT4') or str(ROOT / 'models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4')
CTX = os.environ.get('RT_TEST_CTX', '8192')

FILLER = ('这是一段用来把上下文撑长的背景资料，正文内容不重要，'
          '只是希望预填充的开销足够明显。') * 24

TURNS = [
    '先记一段资料：' + FILLER + ' 收到请回答“已记录”。',
    '第二个问题：上面那段资料里提到的是什么类型的内容？一句话回答。',
    '第三个问题：再把刚才的结论重复一遍，仍然一句话。',
]
A_TURNS = TURNS + ['第四个问题：把前面三个问题的答案合并成一段总结。']
B_TURN = '换个话题：用一句话说明什么是斐波那契数列。'

Turn = namedtuple('Turn', 'answer total computed reused mode ms')


def split_think(txt: str):
    i = txt.find('</think>')
    return (txt[:i], txt[i + len('</think>'):].strip()) if i >= 0 else ('', txt)


def start_engine(env_extra: dict | None = None):
    env = dict(os.environ)
    env.pop('RT_NO_KV_REUSE', None)
    env.update(env_extra or {})
    p = subprocess.Popen([ENGINE, '--engine', '--model', MODEL, '--json', MODEL + '.json',
                          '--ctx', CTX],
                         stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True,
                         bufsize=1, env=env)
    while True:
        line = p.stdout.readline()
        if not line:
            raise SystemExit('引擎启动失败')
        if line.startswith('READY'):
            return p


def chat_turn(p, msgs: list, user: str) -> Turn:
    """跑一轮：PREFILL + GEN（贪心可复现）。回答只回传正文（和网页一致）。"""
    msgs.append({'role': 'user', 'content': user})
    ids = T.encode(T.apply_chat(msgs, add_generation_prompt=True))
    p.stdin.write('PREFILL ' + ','.join(map(str, ids)) + '\n')
    p.stdin.flush()
    st = p.stdout.readline().strip()
    if not st.startswith('OK prefill'):
        raise SystemExit(f'prefill 失败：{st}')
    num = lambda k: int(re.search(k + r'=(\d+)', st).group(1))    # noqa: E731

    p.stdin.write('GEN 24 0 1.0 0 1234\n')          # 贪心，可复现
    p.stdin.flush()
    toks = []
    while True:
        line = p.stdout.readline()
        if not line:
            raise SystemExit('引擎中途退出')
        line = line.strip()
        if line.startswith('TOK '):
            toks.append(int(line[4:]))
        elif line.startswith('END '):
            break
    _, answer = split_think(T.decode(toks))
    msgs.append({'role': 'assistant', 'content': answer})
    return Turn(answer, num('total'), num('computed'), num('reused'),
                re.search(r'mode=(\w+)', st).group(1),
                float(re.search(r'ms=([\d.]+)', st).group(1)))


def run_conversation(no_reuse: bool):
    p = start_engine({'RT_NO_KV_REUSE': '1'} if no_reuse else None)
    msgs: list = []
    turns = [chat_turn(p, msgs, user) for user in TURNS]
    p.stdin.write('QUIT\n')
    p.wait(timeout=120)
    return ([t.answer for t in turns], [t.computed for t in turns],
            [t.reused for t in turns], [t.ms for t in turns])


def run_interleaved(pool: bool):
    """A、A、B、A、A：B 插进来把活跃上下文顶掉，A 再回来。"""
    p = start_engine({'RT_KV_POOL': '4' if pool else '0'})
    a_msgs: list = []
    b_msgs: list = []
    out = []          # (对话标签, Turn)
    schedule = [('A', 0), ('A', 1), ('B', None), ('A', 2), ('A', 3)]
    for tag, ti in schedule:
        if tag == 'A':
            out.append((tag, chat_turn(p, a_msgs, A_TURNS[ti])))
        else:
            out.append((tag, chat_turn(p, b_msgs, B_TURN)))
    p.stdin.write('QUIT\n')
    p.wait(timeout=120)
    return out


def main() -> int:
    if not Path(ENGINE).exists():
        print(f'跳过：没有引擎 {ENGINE}')
        return 0

    # ---- 第一部分：单对话前缀复用 ----
    t0 = time.time()
    base_ans, base_c, base_r, base_ms = run_conversation(no_reuse=True)
    t_base = time.time() - t0
    t0 = time.time()
    re_ans, re_c, re_r, re_ms = run_conversation(no_reuse=False)
    t_re = time.time() - t0

    ok = True
    for i, (a, b) in enumerate(zip(base_ans, re_ans)):
        tag = 'ok ' if a == b else 'DIFF'
        if a != b:
            ok = False
        print(f'  第{i + 1}轮 {tag}  baseline={a[:34]!r}  reuse={b[:34]!r}')
    print()
    print(f'{"轮次":>4} {"整段重算":>22} {"只补差量":>22}')
    for i in range(len(TURNS)):
        print(f'{i + 1:>4} {base_c[i]:>8} tok {base_ms[i]:>9.0f} ms   '
              f'{re_c[i]:>8} tok {re_ms[i]:>9.0f} ms   (复用 {re_r[i]} tok)')
    print(f'{"合计":>4} {sum(base_c):>8} tok {sum(base_ms):>9.0f} ms   '
          f'{sum(re_c):>8} tok {sum(re_ms):>9.0f} ms')
    print(f'预填充总耗时：{sum(base_ms):.0f} ms → {sum(re_ms):.0f} ms '
          f'（快 {sum(base_ms) / max(1.0, sum(re_ms)):.1f}×）')
    print(f'整段流程墙钟：{t_base:.1f}s → {t_re:.1f}s')

    if not ok:
        print('FAIL：开复用后回答和整段重算不一致')
        return 1
    if sum(re_c) >= sum(base_c):
        print('FAIL：复用没有省下任何计算，说明前缀没命中')
        return 1
    print('kv reuse ok：复用不影响输出，且显著省掉预填充')

    # ---- 第二部分：全局 KV 池 A→B→A ----
    print()
    print('== 全局 KV 池：A→B→A 切对话 ==')
    nopr = run_interleaved(pool=False)
    withp = run_interleaved(pool=True)

    pool_ok = True
    for (t1, r1), (t2, r2) in zip(nopr, withp):
        tag = 'ok ' if r1.answer == r2.answer else 'DIFF'
        if r1.answer != r2.answer:
            pool_ok = False
        print(f'  {t1} 轮 {tag}  无池={r1.answer[:30]!r}  有池={r2.answer[:30]!r}')
    print()
    print(f'{"次序":>8} {"无池":>24} {"有池":>24}')
    labels = ['A 第1轮', 'A 第2轮', 'B 第1轮', 'A 第3轮', 'A 第4轮']
    for i, label in enumerate(labels):
        r0, r1 = nopr[i][1], withp[i][1]
        print(f'{label:>8} {r0.computed:>9} tok ({r0.mode:>6}) '
              f'{r1.computed:>9} tok ({r1.mode:>6})')
    a3_np, a3_p = nopr[3][1], withp[3][1]
    print(f'A 第3轮（切走再回来）：{a3_np.computed} tok ({a3_np.mode}) '
          f'→ {a3_p.computed} tok ({a3_p.mode})')

    if not pool_ok:
        print('FAIL：池恢复后回答和整段重算不一致')
        return 1
    if not (a3_p.computed * 2 < a3_np.computed):
        print('FAIL：有池时 A 第3轮没有从槽恢复（计算量没有大幅下降）')
        return 1
    print('kv pool ok：切对话不丢 KV，回来自动复用，输出保持一致')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
