#!/usr/bin/env python3
"""跨请求 KV 复用（对话前缀）的正确性与收益。

同一条多轮对话跑两遍：
  A) RT_NO_KV_REUSE=1 —— 每轮整段重算（原来的行为）
  B) 默认             —— 每轮只补差量（复用已缓存的 KV）

两遍的逐轮回答必须**逐字节一致**；同时打印两边的「真正计算 token 数」与预填充耗时。
用 bundled python 跑（需要 tokenizers）：
    PYTHONPATH=runtime/py runtime/python/bin/python3.10 tests/test_kv_reuse.py
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import tok as T                                              # noqa: E402

ENGINE = os.environ.get('RT_ENGINE_BIN') or str(ROOT / 'build' / 'rt')
MODEL = os.environ.get('RT_RT4') or str(ROOT / 'models/Qwen3.8-27B-NVFP4/rt4/qwen38_27b.rt4')
CTX = os.environ.get('RT_TEST_CTX', '8192')

FILLER = ('这是一段用来把上下文撑长的背景资料，正文内容不重要，'
          '只是希望预填充的开销足够明显。') * 24

TURNS = [
    '先记一段资料：' + FILLER + ' 收到请回答“已记录”。',
    '第二个问题：上面那段资料里提到的是什么类型的内容？一句话回答。',
    '第三个问题：再把刚才的结论重复一遍，仍然一句话。',
]


def split_think(txt: str):
    i = txt.find('</think>')
    return (txt[:i], txt[i + len('</think>'):].strip()) if i >= 0 else ('', txt)


def run_conversation(no_reuse: bool):
    env = dict(os.environ)
    if no_reuse:
        env['RT_NO_KV_REUSE'] = '1'
    else:
        env.pop('RT_NO_KV_REUSE', None)
    p = subprocess.Popen([ENGINE, '--engine', '--model', MODEL, '--json', MODEL + '.json',
                          '--ctx', CTX],
                         stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True,
                         bufsize=1, env=env)
    while True:
        line = p.stdout.readline()
        if not line:
            raise SystemExit('引擎启动失败')
        if line.startswith('READY'):
            break

    msgs, answers, computed, reused, pre_ms = [], [], [], [], []
    for user in TURNS:
        msgs.append({'role': 'user', 'content': user})
        ids = T.encode(T.apply_chat(msgs, add_generation_prompt=True))
        p.stdin.write('PREFILL ' + ','.join(map(str, ids)) + '\n')
        p.stdin.flush()
        st = p.stdout.readline().strip()
        if not st.startswith('OK prefill'):
            raise SystemExit(f'prefill 失败：{st}')
        computed.append(int(re.search(r'computed=(\d+)', st).group(1)))
        reused.append(int(re.search(r'reused=(\d+)', st).group(1)))
        pre_ms.append(float(re.search(r'ms=([\d.]+)', st).group(1)))

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
        answers.append(answer)
        # 只把正文回传（和网页一致：思考段不回传）
        msgs.append({'role': 'assistant', 'content': answer})

    p.stdin.write('QUIT\n')
    p.wait(timeout=120)
    return answers, computed, reused, pre_ms


def main() -> int:
    if not Path(ENGINE).exists():
        print(f'跳过：没有引擎 {ENGINE}')
        return 0
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
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
