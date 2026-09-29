#!/usr/bin/env python3
"""P1-3 工作区配额增量化回归测试（离线）：增量值与全量扫描一致性、
覆盖/追加/删除的增量正确性、配额边界拒绝、定期校准。"""
import os
import shutil
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'scripts'))

# serve 顶层 import fastapi/uvicorn——沙箱缺啥（或装了残缺包）stub 啥
import types


class _Any:
    def __init__(self, *a, **k):
        pass

    def __call__(self, *a, **k):
        return _Any()

    def __getattr__(self, n):
        return _Any()


for mod in ('fastapi', 'fastapi.middleware', 'fastapi.middleware.cors',
            'fastapi.responses', 'pydantic', 'uvicorn'):
    try:
        __import__(mod)
    except ImportError:
        sys.modules[mod] = types.ModuleType(mod)

fa = sys.modules['fastapi']
if not (hasattr(fa, 'FastAPI') and hasattr(fa, 'HTTPException')):   # 残缺包也走 stub
    fa.FastAPI = _Any
    fa.APIRouter = _Any
    fa.HTTPException = _Any
    fa.Request = _Any
    mw = sys.modules.setdefault('fastapi.middleware', types.ModuleType('fastapi.middleware'))
    cors = sys.modules.setdefault('fastapi.middleware.cors',
                                  types.ModuleType('fastapi.middleware.cors'))
    mw.cors = cors
    cors.CORSMiddleware = _Any
    fr = sys.modules.setdefault('fastapi.responses', types.ModuleType('fastapi.responses'))
    fr.FileResponse = fr.HTMLResponse = fr.StreamingResponse = fr.JSONResponse = _Any

import serve  # noqa: E402

fails = []


def check(name, cond):
    print(('ok  ' if cond else 'FAIL') + '  ' + name)
    if not cond:
        fails.append(name)


TMP = tempfile.mkdtemp(prefix='ws-quota-')
os.environ['RT_MAX_WORKSPACE_MB'] = '1'          # 1MB 便于测边界
serve.MAX_WORKSPACE_BYTES = 1024 * 1024
serve.WORKSPACE_ROOT = TMP
conv = 'quota-test'

try:
    # 1) 空工作区：增量 = 扫描 = 0
    check('初始增量=0', serve._ws_used(conv)[0] == 0)

    # 2) 覆盖写：增量与扫描一致
    serve._write_file(conv, 'a.txt', 'x' * 1000)
    check('写 1000B 后增量一致', serve._ws_used(conv)[0] == serve._ws_scan_used(conv) == 1000)

    # 3) 追加：增量按 +len(data) 计（old 不减）
    serve._write_file(conv, 'a.txt', 'y' * 500, append=True)
    check('追加 500B 后=1500', serve._ws_used(conv)[0] == 1500)
    check('追加后与扫描一致', serve._ws_used(conv)[0] == serve._ws_scan_used(conv))

    # 4) 覆盖替换：增量 = len - old
    serve._write_file(conv, 'a.txt', 'z' * 300)          # 1500 -> 300
    check('覆盖后=300 且与扫描一致',
          serve._ws_used(conv)[0] == 300 == serve._ws_scan_used(conv))

    # 5) 多文件 + 删除
    serve._write_file(conv, 'b.txt', 'q' * 7000)
    before = serve._ws_used(conv)[0]
    serve._delete_file(conv, 'a.txt')
    check('删除后增量扣减', serve._ws_used(conv)[0] == before - 300)
    check('删除后与扫描一致', serve._ws_used(conv)[0] == serve._ws_scan_used(conv))

    # 6) 配额边界：超过 1MB 拒绝且不落盘
    try:
        serve._write_file(conv, 'big.txt', 'm' * (serve.MAX_WORKSPACE_BYTES + 1))
        check('超配额拒绝', False)
    except ValueError as e:
        check('超配额拒绝', '上限' in str(e))
    check('超配额未落盘', not os.path.exists(os.path.join(TMP, conv, 'big.txt')))
    check('拒绝后用量不变', serve._ws_used(conv)[0] == 7000)

    # 7) 刚好到配额顶：允许
    serve._write_file(conv, 'c.txt', 'n' * (serve.MAX_WORKSPACE_BYTES - 7000))
    check('顶格写入后=1MB', serve._ws_used(conv)[0] == serve.MAX_WORKSPACE_BYTES)
    # 再追加 1 字节也超（b.txt 7000 在里面）→ 拒绝
    try:
        serve._write_file(conv, 'c.txt', '!', append=True)
        check('顶格后追加拒绝', False)
    except ValueError:
        check('顶格后追加拒绝', True)

    # 8) 定期校准：人为把增量搞漂，写满 50 次后自动回正
    serve._delete_file(conv, 'c.txt')                  # 释放顶格文件，留出空间
    serve._WS_USED[conv][0] = 12345                      # 人为漂移
    serve._WS_USED[conv][1] = serve._WS_RECAL_EVERY      # 下次 _ws_used 触发校准
    serve._write_file(conv, 'd.txt', 'ok')
    check('校准后与扫描一致', serve._ws_used(conv)[0] == serve._ws_scan_used(conv))

    # 9) 外部新文件（未经 _write_file）→ 惰性初始化时会算进去
    with open(os.path.join(TMP, conv, 'ext.txt'), 'w') as f:
        f.write('e' * 4321)
    del serve._WS_USED[conv]                             # 模拟新进程/新对话
    check('外部文件被惰性扫描计入', serve._ws_used(conv)[0] == serve._ws_scan_used(conv))
finally:
    shutil.rmtree(TMP, ignore_errors=True)

print()
print('PASS' if not fails else f'FAILED: {fails}')
sys.exit(0 if not fails else 1)
