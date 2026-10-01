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

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))

MODEL_DIR = os.environ.get('Q36_MODEL_DIR',
                           os.path.join(ROOT, 'models/Qwen3.6-35B-A3B/metadata'))
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

    cmd = [os.path.join(ROOT, 'build/rt'), '--gguf', args.gguf,
           '--ids', ','.join(str(i) for i in ids), '--gen', str(args.gen)]
    if args.max_layers > 0:
        cmd += ['--max-layers', str(args.max_layers)]
    env = dict(os.environ)
    env.setdefault('LD_LIBRARY_PATH', '/opt/hyhal/lib:/opt/hyhal/lib64')
    print('prompt=%r 输入 %d token: %s' % (args.prompt, len(ids), ids), file=sys.stderr)
    p = subprocess.run(cmd, cwd=ROOT, env=env, stdout=subprocess.PIPE, text=True)
    out_ids = [int(m.group(1)) for m in re.finditer(r'^TOKEN (\d+)$', p.stdout, re.M)]
    print('生成 %d token: %s' % (len(out_ids), out_ids), file=sys.stderr)
    if args.raw:
        print(','.join(str(i) for i in out_ids))
        return 0
    print(tok.tok().decode(out_ids, skip_special_tokens=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
