#!/usr/bin/env python3
"""P0-4 崩溃自愈的离线测试：用假引擎进程（实现同一 stdin/stdout 协议）验证
chat.Engine 的 ensure/epoch/restarts/crash-loop。不依赖 GPU / 模型权重。"""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'scripts'))

FAKE = '/tmp/fake_engine.py'
with open(FAKE, 'w') as f:
    f.write('''
import os, sys
print('READY fake', flush=True)
for line in sys.stdin:
    line = line.strip()
    if line.startswith('PREFILL'):
        print('OK prefill total=8 computed=8 reused=0 mode=none ms=1.0 tps=8.0', flush=True)
    elif line.startswith('GEN'):
        print('TOK 123', flush=True)
        print('TOK 456', flush=True)
        print('END 2 5.0', flush=True)
    elif line == 'QUIT':
        break
''')

import types  # noqa: E402
sys.modules['tok'] = types.SimpleNamespace()      # chat.Engine 不用分词器，stub 掉
import chat  # noqa: E402

fails = []


def check(name, cond):
    print(('ok  ' if cond else 'FAIL') + '  ' + name)
    if not cond:
        fails.append(name)


# 1) 正常启动
eng = chat.Engine(cmd=[sys.executable, FAKE], log=False)
check('启动后 alive', eng.alive())
check('初始 epoch=0', eng.epoch == 0)
check('初始 restarts=0', eng.restarts == 0)

# 2) 正常 prefill/gen
st = eng.prefill([1, 2, 3])
check('prefill OK', st.startswith('OK prefill'))
toks, end = eng.gen(8)
check('gen 正常', toks == [123, 456] and end.startswith('END'))

# 3) kill -9 后 ensure 自愈，epoch+1，功能恢复
eng.p.kill(); eng.p.wait()
check('kill 后 not alive', not eng.alive())
ep = eng.ensure()
check('ensure 重启 epoch=1', ep == 1 and eng.epoch == 1)
check('ensure 后 alive', eng.alive())
check('重启后 prefill 恢复', eng.prefill([1]).startswith('OK prefill'))
toks, end = eng.gen(4)
check('重启后 gen 恢复', toks == [123, 456])

# 4) 引擎活着时 ensure 是 no-op（epoch/restarts 不变）
check('活着时 ensure no-op', eng.ensure() == 1 and eng.restarts == 1)

# 5) crash-loop 保护：60s 窗口内（含用例 3 的重启）最多 3 次重启，第 4 次拒绝
for i in range(2):
    eng.p.kill(); eng.p.wait()
    eng.ensure(window=60.0)
check('3 次重启后 restarts=3', eng.restarts == 3)
eng.p.kill(); eng.p.wait()
try:
    eng.ensure(window=60.0)
    check('crash-loop 第 4 次拒绝', False)
except RuntimeError as e:
    check('crash-loop 第 4 次拒绝', '停止自动重启' in str(e))

# 6) gen 中途引擎死掉 → RuntimeError（serve 层捕获后 ensure + 503）
eng2 = chat.Engine(cmd=[sys.executable, FAKE], log=False)
eng2.prefill([1])
eng2.p.kill(); eng2.p.wait()
try:
    eng2.gen(4)
    check('gen 死掉抛 RuntimeError', False)
except RuntimeError as e:
    check('gen 死掉抛 RuntimeError', '引擎' in str(e))
eng2.close()

eng.close()
print()
print('PASS' if not fails else f'FAILED: {fails}')
sys.exit(0 if not fails else 1)
