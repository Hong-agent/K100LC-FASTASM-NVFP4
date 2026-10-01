#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 mmproj（CLIP 视觉塔）GGUF 转成本项目运行时能直接读的 RT4。

    python3 tools/mmproj_to_rt4.py <mmproj.gguf> <out.rt4>

命名对齐 src/vision.h 里的 model.visual.*：
  v.patch_embd.weight / .1  -> patch_embed.proj.weight（两块 temporal 拼成 [1152,1536] f16）
  v.position_embd.weight    -> pos_embed.weight（f32）
  v.blk.N.attn_qkv / attn_out -> blocks.N.attn.qkv / proj（f16）
  v.blk.N.ffn_up / ffn_down -> blocks.N.mlp.linear_fc1 / fc2（f16，N 补 64、K 补 32）
  v.blk.N.ln1 / ln2         -> blocks.N.norm1 / norm2（f32）
  mm.0 / mm.2               -> merger.linear_fc1 / fc2（f16）
  v.post_ln                 -> merger.norm（f32）
"""
from __future__ import annotations

import argparse
import json
import os
import struct

import numpy as np


class Gguf:
    def __init__(self, path):
        self.f = open(path, 'rb')
        self.tensors = {}
        self._parse()

    def _u32(self):
        return struct.unpack('<I', self.f.read(4))[0]

    def _u64(self):
        return struct.unpack('<Q', self.f.read(8))[0]

    def _str(self):
        n = self._u64()
        return self.f.read(n).decode('utf-8', 'replace')

    def _parse(self):
        f = self.f
        assert f.read(4) == b'GGUF'
        self._u32()                     # version
        ntensor = self._u64()
        nkv = self._u64()
        for _ in range(nkv):
            self._str()
            t = self._u32()
            if t == 8:
                self._str()
            elif t == 9:
                et = self._u32()
                n = self._u64()
                if et == 8:
                    for _ in range(n):
                        self.f.seek(self._u64(), 1)
                else:
                    sz = {0: 1, 1: 1, 2: 2, 3: 2, 4: 4, 5: 4, 6: 4, 7: 1}.get(et, 8)
                    self.f.seek(n * sz, 1)
            else:
                sz = {0: 1, 1: 1, 2: 2, 3: 2, 4: 4, 5: 4, 6: 4, 7: 1}.get(t, 8)
                self.f.seek(sz, 1)
        for _ in range(ntensor):
            name = self._str()
            nd = self._u32()
            dims = [self._u64() for _ in range(nd)]
            ttype = self._u32()
            off = self._u64()
            self.tensors[name] = (ttype, dims, off)
        self.data_start = (self.f.tell() + 31) // 32 * 32

    def raw(self, name):
        """GGUF 张量 -> numpy，形状按 dims 反转（ne0 连续 = 最后一维）"""
        ttype, dims, off = self.tensors[name]
        n = int(np.prod(dims))
        nbytes = n * (2 if ttype in (1, 30) else 4)
        self.f.seek(self.data_start + off)
        b = self.f.read(nbytes)
        if ttype == 1:
            a = np.frombuffer(b, dtype=np.float16).astype(np.float32)
        elif ttype == 30:
            a = (np.frombuffer(b, dtype=np.uint16).astype(np.uint32) << 16).view(np.float32)
        else:
            a = np.frombuffer(b, dtype=np.float32)
        return a.reshape(dims[::-1]).copy()


def pad(w, n_align, k_align):
    N, K = w.shape
    Np = (N + n_align - 1) // n_align * n_align
    Kp = (K + k_align - 1) // k_align * k_align
    if (Np, Kp) == (N, K):
        return w
    out = np.zeros((Np, Kp), dtype=np.float32)
    out[:N, :K] = w
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('source')
    ap.add_argument('out')
    args = ap.parse_args()
    g = Gguf(args.source)
    entries = []
    with open(args.out, 'wb') as fo:
        def put(name, arr, kind):
            data = (arr.astype(np.float16) if kind == 'f16'
                    else arr.astype(np.float32)).tobytes()
            off = fo.tell()
            padn = (256 - (off & 255)) & 255
            if padn:
                fo.write(b'\0' * padn)
                off += padn
            fo.write(data)
            entries.append({'name': name, 'kind': kind,
                            'shape': [int(x) for x in arr.shape], 'group': 0,
                            'q_off': off, 's_off': 0, 'nbytes': len(data),
                            'relerr': 0.0, 'src_rms': 0.0})

        # patch_embed：两块 temporal（ggml 顺序 kw,kh,c,out）→ (out, c, ph, pw) 再拼 t
        h0 = g.raw('v.patch_embd.weight')
        h1 = g.raw('v.patch_embd.weight.1')
        w = np.stack([h0, h1], axis=2).reshape(h0.shape[0], 3 * 2 * 16 * 16)
        put('model.visual.patch_embed.proj.weight', pad(w, 64, 32), 'f16')
        put('model.visual.patch_embed.proj.bias', g.raw('v.patch_embd.bias'), 'f32')
        put('model.visual.pos_embed.weight', g.raw('v.position_embd.weight'), 'f32')
        for il in range(27):
            b, p = f'v.blk.{il}.', f'model.visual.blocks.{il}.'
            put(p + 'attn.qkv.weight', pad(g.raw(b + 'attn_qkv.weight'), 64, 32), 'f16')
            put(p + 'attn.qkv.bias', g.raw(b + 'attn_qkv.bias'), 'f32')
            put(p + 'attn.proj.weight', pad(g.raw(b + 'attn_out.weight'), 64, 32), 'f16')
            put(p + 'attn.proj.bias', g.raw(b + 'attn_out.bias'), 'f32')
            put(p + 'mlp.linear_fc1.weight', pad(g.raw(b + 'ffn_up.weight'), 64, 32), 'f16')
            put(p + 'mlp.linear_fc1.bias', g.raw(b + 'ffn_up.bias'), 'f32')
            put(p + 'mlp.linear_fc2.weight', pad(g.raw(b + 'ffn_down.weight'), 64, 32), 'f16')
            put(p + 'mlp.linear_fc2.bias', g.raw(b + 'ffn_down.bias'), 'f32')
            put(p + 'norm1.weight', g.raw(b + 'ln1.weight'), 'f32')
            put(p + 'norm1.bias', g.raw(b + 'ln1.bias'), 'f32')
            put(p + 'norm2.weight', g.raw(b + 'ln2.weight'), 'f32')
            put(p + 'norm2.bias', g.raw(b + 'ln2.bias'), 'f32')
        put('model.visual.merger.linear_fc1.weight', pad(g.raw('mm.0.weight'), 64, 32), 'f16')
        put('model.visual.merger.linear_fc1.bias', g.raw('mm.0.bias'), 'f32')
        put('model.visual.merger.linear_fc2.weight', pad(g.raw('mm.2.weight'), 64, 32), 'f16')
        put('model.visual.merger.linear_fc2.bias', g.raw('mm.2.bias'), 'f32')
        put('model.visual.merger.norm.weight', g.raw('v.post_ln.weight'), 'f32')
        put('model.visual.merger.norm.bias', g.raw('v.post_ln.bias'), 'f32')
    with open(args.out + '.json', 'w', encoding='utf-8') as fj:
        json.dump({'format': 'RT4-v1', 'group': 128, 'weight_file': args.out,
                   'tensors': entries}, fj, ensure_ascii=False, indent=1)
    print(f'写出 {args.out}: {len(entries)} 张量，{os.path.getsize(args.out)/1e9:.3f} GB')


if __name__ == '__main__':
    main()
