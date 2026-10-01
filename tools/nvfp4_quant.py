#!/usr/bin/env python3
"""把 checkpoint 里的 **FP8（float-quantized，逐通道）** 线性层重量化成 NVFP4，
产出「打包字节 + 清单」，格式与 MLP 的原生 NVFP4 完全一致，供 rp4_pack.py 直接
拼进 .rp4、运行时 k_nvfp4_* 内核原样直跑。

为什么：checkpoint 只给了 MLP 的原生 NVFP4；注意力投影 / 线性注意力投影 / lm_head /
第 56~63 层 MLP 是 FP8 逐通道。它们现在走 RT4 的 int4/128（有损），而且预填充时
W4A8 要把 int8 激活拆成 hi/lo 跑两遍 int4 GEMM（2 倍权重读取 + 2 倍 dot）。
换成 NVFP4 后：权重按 16 一组给尺度（比 per-128 精细），一条通路吃 int8 激活，
预填充 GEMM 只跑一遍。

规格（与 MLP 的原生 NVFP4 逐位对齐，已用真实权重核对）：

    w[n,k] = e2m1(code) * e4m3(scale[n, k//16]) / gscale
    gscale      = 448 * 6 / amax(W)                  （逐张量，F32）
    scale[n,b]  = e4m3(block_amax / 6 * gscale)      （每 16 个 k 一组，E4M3）
    code        = 最接近 E2M1 格点的整数码（|·| ∈ {0,.5,1,1.5,2,3,4,6}）
    打包        偶数 k 在低半字节、奇数 k 在高半字节

源侧：`<stem>.weight` F8_E4M3 [N,K] + `<stem>.weight_scale` BF16 [N,1]（逐输出通道）
      → 反量化 w = fp8(code) * scale[n]

    python3 tools/nvfp4_quant.py                       # 全部 FP8 线性层
    python3 tools/nvfp4_quant.py --stats               # 打印量化误差
    python3 tools/nvfp4_quant.py --only 'layers.0.'
"""
import argparse
import json
import os
import struct
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import nvfp4_ref as R                                    # E2M1 / E4M3 真值表

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_ST = os.path.join(ROOT, 'models/Qwen3.8-27B-NVFP4/model.safetensors')
GROUP = 16
E2M1_MAG = np.array([0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=np.float32)
# 相邻格点的中点：|q| 落在哪一段就取哪个码（0.25 是 0 与 0.5 的中点）
E2M1_MID = np.array([0.25, 0.75, 1.25, 1.75, 2.5, 3.5, 5.0], dtype=np.float32)


def build_e4m3_positive():
    """E4M3 的 127 个有限正值（升序），以及用于就近取整的中点。"""
    vals = []
    for e in range(16):
        for m in range(8):
            if e == 0:
                v = (m / 8.0) * 2.0 ** -6
            elif e == 15 and m == 7:
                continue                                  # NaN
            else:
                v = (1.0 + m / 8.0) * 2.0 ** (e - 7)
            vals.append(v)
    vals = np.array(sorted(set(vals)), dtype=np.float32)
    mid = (vals[:-1] + vals[1:]) / 2.0
    return vals, mid


E4M3_POS, E4M3_MID = build_e4m3_positive()
E4M3_MAXV = float(E4M3_POS[-1])                            # 448


def e4m3_encode(x):
    """正数就近取整到 E4M3，返回码字节（符号位恒 0）。0 与溢出都夹住。"""
    idx = np.searchsorted(E4M3_MID, x, side='right')
    idx = np.clip(idx, 0, len(E4M3_POS) - 1)
    return idx.astype(np.uint8)                            # 值 = E4M3_POS[idx]


def e2m1_encode(q):
    """q（已除以块尺度）→ E2M1 码。返回 uint8 码，含符号位。"""
    a = np.abs(q)
    mag = np.searchsorted(E2M1_MID, a, side='right').astype(np.uint8)   # 0..7
    neg = q < 0
    return np.where(neg, mag | 0x8, mag).astype(np.uint8)


def read_header(path):
    with open(path, 'rb') as f:
        n = struct.unpack('<Q', f.read(8))[0]
        hdr = json.loads(f.read(n))
    return hdr, 8 + n


def bf16_to_f32(buf):
    u = np.frombuffer(buf, dtype=np.uint16).astype(np.uint32) << 16
    return u.view(np.float32)


def targets(hdr, only=None):
    """所有「FP8 权重 + BF16 逐通道尺度」的线性层。"""
    out = []
    for name, v in hdr.items():
        if name == '__metadata__' or not name.endswith('.weight'):
            continue
        if v['dtype'] != 'F8_E4M3':
            continue
        sc = hdr.get(name[:-len('.weight')] + '.weight_scale')
        if sc is None or sc['dtype'] != 'BF16':
            continue
        if only and only not in name:
            continue
        out.append((name, v, sc))
    out.sort()
    return out


def quantize_tensor(f, base, name, v, sc, rows_at_a_time=8192, want_stats=True):
    """读一个 FP8 张量 → 返回 (packed bytes[N,K/2], scale bytes[N,K/16], gscale,
    N, K, sumsq_src, sumsq_err)。"""
    N, K = v['shape']
    assert K % GROUP == 0, f'{name}: K={K} 不是 {GROUP} 的倍数'
    f.seek(base + v['data_offsets'][0])
    wq_all = np.frombuffer(f.read(v['data_offsets'][1] - v['data_offsets'][0]),
                           dtype=np.uint8)
    f.seek(base + sc['data_offsets'][0])
    s_all = bf16_to_f32(f.read(sc['data_offsets'][1] - sc['data_offsets'][0]))

    # 第一遍只求 amax。E4M3 的量值随码单调（次正规码 0..7、正规码 8..126），
    # 所以「每行量值最大」＝「每行 (byte & 0x7F) 最大」，只需一次 uint8 归约，
    # 不必真的把 FP8 解码成 f32（这个解码在 100 亿元素上是主要开销）。
    amax = 0.0
    for n0 in range(0, N, rows_at_a_time):
        n1 = min(N, n0 + rows_at_a_time)
        cmax = (wq_all[n0 * K:n1 * K] & 0x7F).reshape(n1 - n0, K).max(axis=1)
        cmax = np.minimum(cmax, len(E4M3_POS) - 1)         # 127 = NaN，按最大量值算
        amax = max(amax, float((E4M3_POS[cmax] * s_all[n0:n1]).max()))
    gscale = (E4M3_MAXV * 6.0 / amax) if amax > 0 else 1.0

    packed = np.empty((N, K // 2), dtype=np.uint8)
    scales = np.empty((N, K // GROUP), dtype=np.uint8)
    sumsq_src = sumsq_err = 0.0
    for n0 in range(0, N, rows_at_a_time):
        n1 = min(N, n0 + rows_at_a_time)
        w = R.E4M3[wq_all[n0 * K:n1 * K].astype(np.int32)].reshape(n1 - n0, K // GROUP,
                                                                  GROUP)
        w = w * s_all[n0:n1, None, None]
        bmax = np.abs(w).max(axis=2)                       # [n, K/16]
        scode = e4m3_encode(bmax / 6.0 * gscale)           # 存成 E4M3
        sval = E4M3_POS[scode]                             # 解码用的同一把尺度
        denom = np.maximum(sval / gscale, 1e-30)[:, :, None]
        q = w / denom
        code = e2m1_encode(np.clip(q, -6.0, 6.0))
        if want_stats:
            dec = R.E2M1[code] * denom
            sumsq_src += float(np.sum(w.astype(np.float64) ** 2))
            sumsq_err += float(np.sum((dec - w).astype(np.float64) ** 2))
        scales[n0:n1] = scode
        # code 形状是 [n][K/16][16]：偶/奇 k 在**最后一个轴**上，
        # 一个字节 = 同块内相邻两个 k（偶 k 低半字节、奇 k 高半字节）。
        lo = code[..., 0::2]                               # [n][K/16][8]
        hi = code[..., 1::2]
        packed[n0:n1] = ((lo & 0xF) | ((hi & 0xF) << 4)).reshape(n1 - n0, -1)
    return packed.tobytes(), scales.tobytes(), gscale, N, K, sumsq_src, sumsq_err


def family(name):
    if '.mlp.' in name:
        return 'mlp (FP8 层)'
    if '.self_attn.' in name:
        return 'self_attn'
    if '.linear_attn.' in name:
        return 'linear_attn'
    return 'lm_head' if name.startswith('lm_head') else 'other'


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--safetensors', default=DEFAULT_ST)
    ap.add_argument('--out', default=os.path.join(ROOT, 'build', 'nvfp4_extra_blob.bin'))
    ap.add_argument('--tsv', default=os.path.join(ROOT, 'build',
                                                  'nvfp4_extra_manifest.tsv'))
    ap.add_argument('--only', help='只处理名字里含该子串的张量（调试用）')
    ap.add_argument('--stats', action='store_true', help='打印每个张量的量化误差')
    a = ap.parse_args()

    hdr, base = read_header(a.safetensors)
    tgt = targets(hdr, a.only)
    if not tgt:
        sys.exit('没找到任何 FP8 线性层')
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    agg = {}
    tot_p = tot_s = 0
    t0 = time.time()
    with open(a.safetensors, 'rb') as f, open(a.out, 'wb') as out, \
            open(a.tsv, 'w') as tsv:
        tsv.write('# name\tpacked_off\tpacked_bytes\tscale_off\tscale_bytes\t'
                  'gscale\tN\tK\n')
        for i, (name, v, sc) in enumerate(tgt, 1):
            packed, scales, gs, N, K, s_src, s_err = quantize_tensor(f, base, name, v, sc)
            poff = out.tell()
            out.write(packed)
            soff = out.tell()
            out.write(scales)
            tsv.write('%s\t%d\t%d\t%d\t%d\t%.9g\t%d\t%d\n'
                      % (name[:-len('.weight')], poff, len(packed), soff, len(scales),
                         gs, N, K))
            tot_p += len(packed)
            tot_s += len(scales)
            k = family(name)
            a_src, a_err = agg.get(k, (0.0, 0.0))
            agg[k] = (a_src + s_src, a_err + s_err)
            if a.stats:
                rel = (s_err / s_src) ** 0.5 if s_src else 0.0
                print('  %-72s %dx%-6d relerr=%.4f%%' % (name, N, K, rel * 100))
            if i % 20 == 0 or i == len(tgt):
                print('  %d/%d  %.2f GB  %.0f s' % (i, len(tgt), (tot_p + tot_s) / 1e9,
                                                    time.time() - t0), flush=True)
    dt = time.time() - t0
    print('NVFP4 重量化：%d 个张量 → %s' % (len(tgt), a.out))
    print('  打包权重 %.3f GB + 块尺度 %.3f GB = %.3f GB（%.0f s，%.2f GB/s）'
          % (tot_p / 1e9, tot_s / 1e9, (tot_p + tot_s) / 1e9, dt,
             (tot_p + tot_s) / dt / 1e9))
    print('  清单 → %s' % a.tsv)
    print('  量化误差（相对 RMS，越大越差）：')
    src_all = err_all = 0.0
    for k in sorted(agg):
        s_src, s_err = agg[k]
        src_all += s_src
        err_all += s_err
        print('    %-16s %.4f%%' % (k, (s_err / s_src) ** 0.5 * 100 if s_src else 0.0))
    print('    %-16s %.4f%%' % ('合计', (err_all / src_all) ** 0.5 * 100))
    return 0


if __name__ == '__main__':
    sys.exit(main())
