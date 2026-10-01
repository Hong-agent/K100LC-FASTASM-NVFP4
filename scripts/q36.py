#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Qwen3.6-35B-A3B(GGUF) 命令行对话：分词 → build/rt --gguf → 反解。

用法：
    python3 scripts/q36.py --prompt "你好，用一句话介绍你自己" -n 32
    python3 scripts/q36.py --ids 3837,374 -n 8 --raw

权重路径默认 models/Qwen3.6-35B-A3B-q8/Qwen3.6-35B-A3B-Q8_0.gguf，可用 RT_GGUF 覆盖。
"""
import argparse
import os
import re
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))

MODEL_DIR = os.environ.get('Q36_MODEL_DIR',
                           os.path.join(ROOT, 'models/Qwen3.6-35B-A3B'))
os.environ.setdefault('RT_MODEL_DIR', MODEL_DIR)          # tools/tok.py 用它找 tokenizer


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prompt', default='')
    ap.add_argument('--ids', default='')
    ap.add_argument('--raw', action='store_true', help='只输出 token id')
    ap.add_argument('-n', '--gen', type=int, default=32)
    ap.add_argument('--gguf', default=os.environ.get(
        'RT_GGUF', os.path.join(ROOT,
                                'models/Qwen3.6-35B-A3B-q8/Qwen3.6-35B-A3B-Q8_0.gguf')))
    ap.add_argument('--max-layers', type=int, default=-1)
    ap.add_argument('--spawn', action='store_true',
                    help='不管常驻引擎，每次新起进程（调试用）')
    ap.add_argument('--api', default=os.environ.get('RT_Q36_API', 'http://127.0.0.1:8082'),
                    help='已经在跑的 serve 地址（有就跑它，不再加载权重）')
    args = ap.parse_args()

    import tok
    ids = []
    if args.ids:
        ids = [int(x) for x in args.ids.split(',') if x.strip()]
    else:
        if not args.prompt:
            args.prompt = '你好'
        text = tok.apply_chat([{'role': 'user', 'content': args.prompt}])
        ids = tok.tok().encode(text).ids

    print('prompt=%r 输入 %d token: %s' % (args.prompt, len(ids), ids), file=sys.stderr)
    pid_file = os.path.join(ROOT, 'build/q36.engine.pid')
    alive = False
    if os.path.exists(pid_file):
        try:
            pid = int(open(pid_file).read().strip())
            os.kill(pid, 0)
            alive = True
        except Exception:
            alive = False
    if alive and not args.spawn:
        out_ids = ask_daemon(ids, args.gen)
    elif not args.spawn and api_alive(args.api):
        print('复用正在跑的 serve：%s' % args.api, file=sys.stderr)
        out_ids = ask_api(args.api, args.prompt or '', ids, args.gen)
    else:
        cmd = [os.path.join(ROOT, 'build/rt'), '--gguf', args.gguf,
               '--ids', ','.join(str(i) for i in ids), '--gen', str(args.gen)]
        if args.max_layers > 0:
            cmd += ['--max-layers', str(args.max_layers)]
        env = dict(os.environ)
        env.setdefault('LD_LIBRARY_PATH', '/opt/hyhal/lib:/opt/hyhal/lib64')
        p = subprocess.run(cmd, cwd=ROOT, env=env, stdout=subprocess.PIPE, text=True)
        out_ids = [int(m.group(1)) for m in re.finditer(r'^TOKEN (\d+)$', p.stdout, re.M)]
    print('生成 %d token: %s' % (len(out_ids), out_ids), file=sys.stderr)
    if args.raw:
        print(','.join(str(i) for i in out_ids))
        return 0
    print(tok.tok().decode(out_ids, skip_special_tokens=False))
    return 0


def api_alive(base):
    if not base:
        return False
    try:
        import urllib.request
        with urllib.request.urlopen(base.rstrip('/') + '/health', timeout=3) as r:
            return r.status == 200
    except Exception:
        return False


def ask_api(base, prompt, ids, gen, timeout=900.0):
    """把请求发给已经跑着的 HTTP 服务（模型已在显存里，不再加载）。"""
    import json
    import urllib.request
    import tok
    text = tok.tok().decode(ids)
    payload = {'model': os.environ.get('RT_SERVED_NAME', 'qwen36-35b-a3b-q8'),
               'messages': [{'role': 'user', 'content': text}],
               'max_tokens': max(gen, 1), 'temperature': 0}
    req = urllib.request.Request(base.rstrip('/') + '/v1/chat/completions',
                                 data=json.dumps(payload).encode(),
                                 headers={'Content-Type': 'application/json'}, method='POST')
    with urllib.request.urlopen(req, timeout=timeout) as r:
        out = json.loads(r.read().decode())
    msg = out['choices'][0]['message']
    text_out = (msg.get('content') or '') + (msg.get('reasoning_content') or msg.get('reasoning') or '')
    return tok.tok().encode(text_out).ids


def ask_daemon(ids, gen, timeout=600.0):
    """把请求发给常驻引擎（FIFO），权重不重新加载。"""
    fin = os.path.join(ROOT, 'build/q36.engine.in')
    fout = os.path.join(ROOT, 'build/q36.engine.out')
    import fcntl
    wr = os.open(fin, os.O_WRONLY)
    rd = os.open(fout, os.O_RDONLY | os.O_NONBLOCK)
    buf = b''

    def send(s):
        os.write(wr, (s + '\n').encode())

    def read_until(pred, deadline):
        nonlocal buf
        while time.time() < deadline:
            try:
                chunk = os.read(rd, 65536)
            except BlockingIOError:
                chunk = b''
            if chunk:
                buf += chunk
            while b'\n' in buf:
                line, buf = buf.split(b'\n', 1)
                text = line.decode('utf-8', 'replace').rstrip()
                if pred(text):
                    return text
            if not chunk:
                time.sleep(0.002)
        raise TimeoutError('常驻引擎无响应')

    dl = time.time() + timeout
    send('RESET')
    read_until(lambda t: t.startswith('OK reset') or t.startswith('ERR'), dl)
    send('PREFILL ' + ','.join(str(i) for i in ids))
    read_until(lambda t: t.startswith('OK prefill') or t.startswith('ERR'), dl)
    send('GEN %d 0 1 0 1' % gen)
    out = []
    while True:
        line = read_until(lambda t: t.startswith('TOK ') or t.startswith('END '), dl)
        if line.startswith('END '):
            break
        out.append(int(line[4:]))
    os.close(wr)
    os.close(rd)
    return out


if __name__ == '__main__':
    raise SystemExit(main())
