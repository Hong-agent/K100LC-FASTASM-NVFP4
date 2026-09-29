#!/usr/bin/env python3
"""逐步定位：把第 0 层的 x / g / u / a / y 与 NumPy 参考逐个对照，
找出端到端那点差异到底出在哪一步。

    python3 tools/check_stage.py <model.safetensors> <manifest.tsv> <aux.tsv> <stage.bin> [--token N]
"""
import os
import sys
import struct
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nvfp4_ref import E2M1, E4M3, unpack_codes
from check_chain import read_manifest, read_aux, bf16_at, dequant, quant16


def cmp(tag, ref, got):
    rms = float(np.sqrt((ref.astype(np.float64) ** 2).mean()))
    d = np.abs(got.astype(np.float64) - ref.astype(np.float64))
    rs = float(np.sqrt((d ** 2).mean()))
    print("  %-2s  RMS=%.6g   max|Δ|=%.3e   RMS(Δ)=%.3e   RMS(Δ)/RMS=%.2e"
          % (tag, rms, d.max(), rs, rs / (rms + 1e-30)))
    return rs / (rms + 1e-30)


def main():
    if len(sys.argv) < 5:
        print(__doc__)
        return 1
    st, mp, ap, sp = sys.argv[1:5]
    token = 1234
    if '--token' in sys.argv:
        token = int(sys.argv[sys.argv.index('--token') + 1])

    mani, aux = read_manifest(mp), read_aux(ap)
    with open(sp, 'rb') as f:
        H, Hg, I, Ia, Hy = struct.unpack('<5i', f.read(20))
        x = np.frombuffer(f.read(4 * H), dtype=np.float32)
        g = np.frombuffer(f.read(4 * I), dtype=np.float32)
        u = np.frombuffer(f.read(4 * I), dtype=np.float32)
        a = np.frombuffer(f.read(4 * I), dtype=np.float32)
        y = np.frombuffer(f.read(4 * Hy), dtype=np.float32)

    with open(st, 'rb') as fh:
        h = bf16_at(fh, aux['model.language_model.embed_tokens.weight']['off'] + token * H * 2, H)
        w = bf16_at(fh, aux['model.language_model.layers.0.post_attention_layernorm.weight']['off'], H)
        x_ref = h / np.sqrt((h ** 2).mean() + 1e-6) * w
        cmp('x', x_ref, x)
        xq = quant16(x_ref)
        g_ref = dequant(fh, mani['model.language_model.layers.0.mlp.gate_proj']) @ xq
        u_ref = dequant(fh, mani['model.language_model.layers.0.mlp.up_proj']) @ xq
        cmp('g', g_ref, g)
        cmp('u', u_ref, u)
        a_ref = (g_ref / (1.0 + np.exp(-g_ref))) * u_ref
        cmp('a', a_ref, a)
        y_ref = dequant(fh, mani['model.language_model.layers.0.mlp.down_proj']) @ quant16(a_ref)
        cmp('y', y_ref, y)

        # ---- 用「理想算法」再算一遍 g：整数点积按 int64 精确算，尺度用 float64 ----
        # 这正好是内核定义的数学，但不含任何 float32 累加，用来分辨
        # 「内核浮点累加误差」和「我的参考实现有偏差」。
        e = mani['model.language_model.layers.0.mlp.gate_proj']
        fh.seek(e['poff'])
        packed = np.frombuffer(fh.read(e['pbytes']), dtype=np.uint8).reshape(e['N'], e['K'] // 2)
        fh.seek(e['soff'])
        ws = np.frombuffer(fh.read(e['sbytes']), dtype=np.uint8).reshape(e['N'], e['K'] // 16)
        codes = unpack_codes(packed)
        I = np.rint(E2M1[codes].astype(np.float64) * 2).astype(np.int64)      # 2xE2M1，精确整数
        sq = np.clip(np.rint(x_ref.reshape(-1, 16) / np.where(
            np.abs(x_ref.reshape(-1, 16)).max(1) > 0,
            np.abs(x_ref.reshape(-1, 16)).max(1) / 127.0, 1.0)[:, None]), -128, 127).astype(np.int64)
        Sa = np.where(np.abs(x_ref.reshape(-1, 16)).max(1) > 0,
                      np.abs(x_ref.reshape(-1, 16)).max(1) / 127.0, 1.0)
        Sw = E4M3[ws].astype(np.float64) * 0.5 / float(e['gscale'])
        d = (I.reshape(e['N'], -1, 16) * sq.reshape(-1, 16)[None]).sum(axis=2)   # int64 精确
        g_ideal = (d * Sw * Sa[None, :]).sum(axis=1)
        cmp('g*', g_ideal, g)

        # 量化步数是不是同一批？差了多少个元素？
        q1 = np.rint(x_ref.reshape(-1, 16) / np.where(
            np.abs(x_ref.reshape(-1, 16)).max(1) > 0,
            np.abs(x_ref.reshape(-1, 16)).max(1) / 127.0, 1.0)[:, None])
        q2 = np.rint(x.astype(np.float64).reshape(-1, 16) / np.where(
            np.abs(x.astype(np.float64).reshape(-1, 16)).max(1) > 0,
            np.abs(x.astype(np.float64).reshape(-1, 16)).max(1) / 127.0, 1.0)[:, None])
        print("  x 的 int8 量化：%d/%d 个元素不同" % ((q1 != q2).sum(), q1.size))
        qa1 = np.rint(a_ref.reshape(-1, 16) / np.where(
            np.abs(a_ref.reshape(-1, 16)).max(1) > 0,
            np.abs(a_ref.reshape(-1, 16)).max(1) / 127.0, 1.0)[:, None])
        qa2 = np.rint(a.astype(np.float64).reshape(-1, 16) / np.where(
            np.abs(a.astype(np.float64).reshape(-1, 16)).max(1) > 0,
            np.abs(a.astype(np.float64).reshape(-1, 16)).max(1) / 127.0, 1.0)[:, None])
        print("  a 的 int8 量化：%d/%d 个元素不同" % ((qa1 != qa2).sum(), qa1.size))
    return 0


if __name__ == '__main__':
    sys.exit(main())
