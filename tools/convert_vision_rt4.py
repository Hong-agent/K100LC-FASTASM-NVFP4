#!/usr/bin/env python3
"""把 Qwen3.5 视觉塔转换成独立 RT4 文件。

两种精度：

* 默认 `--int4`：线性权重按 RT4 的 int4（每 128 个 K 一组 f16 尺度）量化，
  N 补到 64 的倍数、K 补到 128 的倍数，运行时直接复用文本侧的 W4A8 内核
  （GEMV 走 k_gemv_w4a8，预填充走 k_gemm_i4_a8）—— int4 权重 × int8 激活。
  norm / bias / pos_embed 仍然是 f32。
* `--f16`：线性权重存 f16（旧行为，精度更高、体积和带宽都是 int4 的 4 倍）。

  python3 tools/convert_vision_rt4.py <model.safetensors> <out.rt4> [--f16]
"""
import argparse
import json
import math
import os
import struct

import numpy as np


GRP = 128


def read_header(path):
    with open(path, 'rb') as f:
        hlen = struct.unpack('<Q', f.read(8))[0]
        header = json.loads(f.read(hlen))
        base = 8 + hlen
    return header, base


def read_tensor(f, base, ent):
    f.seek(base + ent['data_offsets'][0])
    raw = f.read(ent['data_offsets'][1] - ent['data_offsets'][0])
    dt = {'BF16': np.uint16, 'F16': np.float16, 'F32': np.float32}[ent['dtype']]
    arr = np.frombuffer(raw, dtype=dt).copy().reshape(ent['shape'])
    if ent['dtype'] == 'BF16':
        u = arr.astype(np.uint32) << 16
        arr = u.view(np.float32)
    return arr.astype(np.float32, copy=False)


def pad_weight(w, n_align, k_align):
    N, K = w.shape
    Np = (N + n_align - 1) // n_align * n_align
    Kp = (K + k_align - 1) // k_align * k_align
    if Np == N and Kp == K:
        return w
    out = np.zeros((Np, Kp), dtype=np.float32)
    out[:N, :K] = w
    return out


def quant_int4(w, grp=GRP):
    """行内 int4 量化（与 tools/convert.c 的 i4 分支一致）。

    返回 (packed [Np,Kp/2] u8, scale [Np,Kp/grp] f16, dequant [Np,Kp] f32)。
    低半字节 = 偶数 k。
    """
    wp = pad_weight(w, 64, grp)
    Np, Kp = wp.shape
    ng = Kp // grp
    blk = wp.reshape(Np * ng, grp)
    amax = np.abs(blk).max(axis=1)
    scale = np.where(amax > 0, amax / 7.0, 1.0).astype(np.float32)
    q = np.rint(blk / scale[:, None])
    np.clip(q, -8, 7, out=q)
    qi = q.astype(np.int8).reshape(Np, Kp)
    s16 = scale.astype(np.float16)
    wd = (qi.astype(np.float32).reshape(Np * ng, grp) *
          s16.astype(np.float32)[:, None]).reshape(Np, Kp)
    low = qi[:, 0::2].astype(np.uint8) & 0xF
    high = (qi[:, 1::2].astype(np.uint8) & 0xF) << 4
    packed = (low | high).astype(np.uint8)
    return packed, s16, wd


def write_bytes(f, data, align=256):
    off = f.tell()
    f.write(data)
    pad = (align - (f.tell() & (align - 1))) & (align - 1)
    if pad:
        f.write(b'\0' * pad)
    return off


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('source')
    ap.add_argument('out')
    ap.add_argument('--f16', action='store_true',
                    help='线性权重存 f16（默认 int4/W4A8）')
    args = ap.parse_args()
    header, base = read_header(args.source)
    prefix = 'model.visual.'
    keys = [k for k in header if k.startswith(prefix)]
    if not keys:
        raise SystemExit('源权重里没有 model.visual.*')

    manifest = []
    with open(args.source, 'rb') as src, open(args.out, 'wb') as out:
        for i, name in enumerate(keys, 1):
            ent = header[name]
            arr = read_tensor(src, base, ent)
            is_linear = (name.endswith('.weight') and arr.ndim >= 2 and
                         name != 'model.visual.pos_embed.weight')
            if not is_linear:
                data = arr.astype(np.float32, copy=False).tobytes(order='C')
                q_off = write_bytes(out, data)
                manifest.append({
                    'name': name, 'kind': 'f32', 'shape': [int(x) for x in arr.shape],
                    'group': 0, 'q_off': q_off, 's_off': 0, 'nbytes': len(data),
                    'relerr': 0.0,
                    'src_rms': float(np.sqrt(np.mean(arr.astype(np.float64) ** 2))),
                })
            else:
                # 5D patch_embed conv [out,in,t,ph,pw] 展平成 [out,in*t*ph*pw]
                logical = arr.reshape(arr.shape[0], -1).astype(np.float32)
                if args.f16:
                    w = pad_weight(logical, 64, 32)
                    qb = w.astype(np.float16).tobytes(order='C')
                    q_off = write_bytes(out, qb)
                    d = logical.astype(np.float64) - \
                        w[:logical.shape[0], :logical.shape[1]].astype(np.float64)
                    kind, group = 'f16', 0
                    shape = [int(w.shape[0]), int(w.shape[1])]
                    nbytes = int(w.size * 2)
                    s_off = 0
                else:
                    packed, s16, wd = quant_int4(logical)
                    q_off = write_bytes(out, packed.tobytes(order='C'))
                    s_off = write_bytes(out, s16.tobytes(order='C'))
                    d = logical.astype(np.float64) - \
                        wd[:logical.shape[0], :logical.shape[1]].astype(np.float64)
                    kind, group = 'i4', GRP
                    shape = [int(wd.shape[0]), int(wd.shape[1])]
                    nbytes = int(s_off + s16.size * 2 - q_off)
                relerr = math.sqrt(float(np.sum(d * d)) /
                                   float(np.sum(logical.astype(np.float64) ** 2)))
                manifest.append({
                    'name': name, 'kind': kind, 'shape': shape, 'group': group,
                    'q_off': q_off, 's_off': s_off, 'nbytes': nbytes,
                    'relerr': round(relerr, 5),
                    'src_rms': float(np.sqrt(np.mean(logical.astype(np.float64) ** 2))),
                })
            if i % 50 == 0 or i == len(keys):
                print(f'  视觉张量 {i}/{len(keys)}', flush=True)

    mpath = args.out + '.json'
    with open(mpath, 'w', encoding='utf-8') as f:
        json.dump({'format': 'RT4-v1', 'group': GRP, 'weight_file': args.out,
                   'tensors': manifest}, f, ensure_ascii=False, indent=1)
    mode = 'f16' if args.f16 else 'int4/W4A8'
    print(f'写出 {args.out}: {len(manifest)} 张量（{mode}）, '
          f'{os.path.getsize(args.out) / 1e9:.2f} GB')


if __name__ == '__main__':
    main()
