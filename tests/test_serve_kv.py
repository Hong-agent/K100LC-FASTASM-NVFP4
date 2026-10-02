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
    content, tim, skills = chat_events(messages, conv, mt)
    return content, tim


def chat_events(messages, conv=CONV, mt=48):
    """同上，但把技能事件也带出来（判断这一轮有没有真的调技能）。"""
    body = {'model': 'qwen38-fastasm-int4', 'messages': messages, 'max_tokens': mt,
            'temperature': 0, 'stream': True, 'skills': True, 'conversation_id': conv,
            'reasoning_effort': 'low'}
    content, tim, skills = '', None, []
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
            if j.get('type') == 'skill':
                ev = j.get('skill') or {}
                skills.append((ev.get('name'), ev.get('ok')))
            if j.get('type') == 'round_reset':
                # 网页收到 round_reset 会清空气泡：这一轮其实是在调技能，
                # 那段文字不算回答（见 web/index.html 的 round_reset 处理）。
                skills.append(('round_reset', None))
                content = ''
            content += ((j.get('choices') or [{}])[0].get('delta') or {}).get('content') or ''
            if j.get('timings'):
                tim = j['timings']
    return content, tim, skills


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

        # 工具调用轮次：这一轮服务端内部会追加 assistant(工具调用)+tool 结果，
        # 客户端下一轮不会把它们带回来。提交前缀的 key 必须只用「客户端视角」，
        # 否则下一轮对不上 → 整段重算（修复前实测 1463 tok 全算）。
        sk_msgs = [{'role': 'user', 'content': '用 calc 技能算一下 12345 乘 6789 等于多少。'}]
        _ans, _t1, ev = chat_events(sk_msgs, conv='skill-kv')
        sk_msgs.append({'role': 'assistant', 'content': _ans})
        sk_msgs.append({'role': 'user', 'content': '那再加 1 呢？'})
        _ans2, t_tool, ev2 = chat_events(sk_msgs, conv='skill-kv')
        got_skill = bool(ev + ev2)          # 调了技能，或至少出现过一次技能调用轮
        print(f'  技能轮: 事件={ev + ev2}，第 2 轮计算 {t_tool["prefill_tokens"]} tok，'
              f'复用 {t_tool.get("prefill_reused", 0)} tok')

        bad = []
        if reused[1] <= 0 or reused[2] <= 0:
            bad.append('第 2/3 轮没有复用（应当完全命中）')
        if reused[1] < reused[0] + 100:
            bad.append('复用量太少')
        if tim_edit.get('prefill_reused', 0) != 0:
            bad.append('改写历史后仍在复用')
        if tim_new.get('prefill_reused', 0) != 0:
            bad.append('新会话仍在复用')
        # 技能轮之后的那一轮也该完全命中（只剩新问题那几个 token 要算）
        if got_skill and (t_tool.get('prefill_reused', 0) <= 0 or
                          t_tool['prefill_tokens'] > 60):
            bad.append(f'技能轮之后没有命中：计算 {t_tool["prefill_tokens"]} tok')
        if bad:
            for b in bad:
                print('FAIL:', b)
            return 1
        print('serve kv ok：第 2/3 轮与技能轮之后都完全命中，改历史/换会话正确回退')
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
