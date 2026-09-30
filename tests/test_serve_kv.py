#!/usr/bin/env python3
"""服务层「完全命中」端到端测试。

模拟网页的做法（流式 + skills 打开 + 固定 conversation_id）：把上一轮收到的正文原样
带回去，第 2 轮起应当只补「新用户那句话 + 生成提示」的十几个 token，而不是整段历史。

    PYTHONPATH=runtime/py runtime/python/bin/python3.10 tests/test_serve_kv.py
"""

from __future__ import annotations

import json
import os
import socket
import subprocess
import sys
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PORT = int(os.environ.get('RT_TEST_PORT', '8099'))
CONV = 'k100lc-serve-kv-test'


def free_port():
    s = socket.socket()
    s.bind(('127.0.0.1', 0))
    p = s.getsockname()[1]
    s.close()
    return p


def post(path, body, timeout=600):
    req = urllib.request.Request('http://127.0.0.1:%d%s' % (PORT, path),
                                 data=json.dumps(body).encode(),
                                 headers={'Content-Type': 'application/json'})
    return urllib.request.urlopen(req, timeout=timeout)


def chat(messages, conv=CONV, mt=48):
    body = {'model': 'qwen38-fastasm-int4', 'messages': messages, 'max_tokens': mt,
            'temperature': 0, 'stream': True, 'skills': True, 'conversation_id': conv,
            'reasoning_effort': 'low'}
    content, tim = '', None
    with post('/v1/chat/completions', body) as r:
        for raw in r:
            line = raw.decode('utf-8', 'replace').strip()
            if not line.startswith('data: '):
                continue
            d = line[6:]
            if d == '[DONE]':
                break
            try:
                j = json.loads(d)
            except ValueError:
                continue
            content += ((j.get('choices') or [{}])[0].get('delta') or {}).get('content') or ''
            if j.get('timings'):
                tim = j['timings']
    return content, tim


def main() -> int:
    global PORT
    if not (ROOT / 'build' / 'rt').exists() and not (ROOT / 'prebuilt' / 'rt').exists():
        print('跳过：还没有引擎（先跑 bash build.sh）')
        return 0
    if not (ROOT / 'models/Qwen3.8-27B-INT4').exists():
        print('跳过：还没有接权重（先跑 bash scripts/setup_models.sh）')
        return 0
    PORT = int(os.environ.get('RT_TEST_PORT') or free_port())

    env = dict(os.environ)
    env.setdefault('RT_PYTHON', sys.executable)
    env['PYTHONPATH'] = str(ROOT / 'runtime/py') + (':' + env['PYTHONPATH'] if env.get('PYTHONPATH') else '')
    log = open('/tmp/k100lc_serve_kv.log', 'w')
    srv = subprocess.Popen([sys.executable, str(ROOT / 'scripts' / 'serve.py'),
                            '--port', str(PORT), '--ctx', '8192', '--mtp-n', '3'],
                           cwd=str(ROOT), stdout=log, stderr=subprocess.STDOUT, env=env)
    try:
        for _ in range(240):
            time.sleep(0.5)
            try:
                with urllib.request.urlopen('http://127.0.0.1:%d/health' % PORT, timeout=3) as r:
                    if json.load(r).get('ok'):
                        break
            except Exception:                            # noqa: BLE001
                if srv.poll() is not None:
                    raise SystemExit('服务启动失败，见 /tmp/k100lc_serve_kv.log')
        else:
            raise SystemExit('服务启动超时')

        msgs = [{'role': 'user', 'content': '用一句话说明 int4 推理为什么访存受限。'}]
        reused = []
        for i in range(3):
            ans, tim = chat(msgs)
            if tim is None:
                raise SystemExit('没有拿到 timings')
            reused.append(tim.get('prefill_reused', 0))
            print(f'  轮 {i + 1}: prompt {(tim["prefill_tokens"] + reused[-1]):>5} → '
                  f'计算 {tim["prefill_tokens"]:>4} tok / {tim["prefill_ms"]:>6.0f} ms，'
                  f'复用 {reused[-1]:>5} tok')
            msgs += [{'role': 'assistant', 'content': ans},
                     {'role': 'user', 'content': '再换一句话说一遍。'}]

        # 改掉历史里上一条助手回答：必须回退成整段重算，不能拿旧序列顶替
        msgs[-2]['content'] = '（手动改写）'
        _, tim_edit = chat(msgs)
        print(f'  改历史: 计算 {tim_edit["prefill_tokens"]} tok，复用 {tim_edit.get("prefill_reused", 0)} tok')
        # 换一条会话：同样不该复用
        _, tim_new = chat([{'role': 'user', 'content': '你好，一句话回答。'}], conv='other')
        print(f'  新会话: 计算 {tim_new["prefill_tokens"]} tok，复用 {tim_new.get("prefill_reused", 0)} tok')

        bad = []
        if reused[1] <= 0 or reused[2] <= 0:
            bad.append('第 2/3 轮没有复用（应当完全命中）')
        if reused[1] < reused[0] + 100:
            bad.append('复用量太少')
        if tim_edit.get('prefill_reused', 0) != 0:
            bad.append('改写历史后仍在复用')
        if tim_new.get('prefill_reused', 0) != 0:
            bad.append('新会话仍在复用')
        if bad:
            for b in bad:
                print('FAIL:', b)
            return 1
        print('serve kv ok：第 2/3 轮完全命中，改历史/换会话正确回退')
        return 0
    finally:
        srv.terminate()
        try:
            srv.wait(timeout=15)
        except subprocess.TimeoutExpired:
            srv.kill()
        log.close()


if __name__ == '__main__':
    raise SystemExit(main())
