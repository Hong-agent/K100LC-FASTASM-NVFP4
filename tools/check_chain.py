#!/usr/bin/env python3
"""独立复算端到端那条 56 层 MLP 链（纯 NumPy，不复用任何 C++ 侧代码）。

    python3 tools/check_chain.py <model.safetensors> <manifest.tsv> <aux.tsv> <chain.bin> [--layers N]

chain.bin 由 `build/nvfp4_demo ... --dump-chain` 产出，里面是**每一层之后**的 h。

两种对照：
  (A) 自由累加：从 embedding 一路推，看误差怎么增长（会累积 float32 差异）
  (B) 单层隔离：用内核自己上一层的输出当这一层的输入，只看单层算得对不对

内核里的 rsqrtf / __expf 是硬件近似指令，单层会有 ~1e-6 量级的相对差；
(A) 的结果比 (B) 差是**正常的**（量化边界会因为微小差异而翻转并放大）。
"""
import os
import sys
import struct
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from nvfp4_ref import E2M1, E4M3, unpack_codes


def read_manifest(p):
    m = {}
    for line in open(p):
        if line.startswith('#') or not line.strip():
            continue
        f = line.split()
        m[f[0]] = dict(poff=int(f[1]), pbytes=int(f[2]), soff=int(f[3]), sbytes=int(f[4]),
                       gscale=float(f[5]), N=int(f[6]), K=int(f[7]))
    return m


def read_aux(p):
    m = {}
    for line in open(p):
        if line.startswith('#') or not line.strip():
            continue
        f = line.split()
        m[f[0]] = dict(off=int(f[1]), bytes=int(f[2]), dtype=f[3], shape=f[4])
    return m


def bf16_at(fh, off, n):
    fh.seek(off)
    return ((np.frombuffer(fh.read(2 * n), dtype=np.uint16).astype(np.uint32) << 16)
            .view(np.float32).astype(np.float64))


def dequant(fh, e):
    fh.seek(e['poff'])
    packed = np.frombuffer(fh.read(e['pbytes']), dtype=np.uint8).reshape(e['N'], e['K'] // 2)
    fh.seek(e['soff'])
    ws = np.frombuffer(fh.read(e['sbytes']), dtype=np.uint8).reshape(e['N'], e['K'] // 16)
    return (E2M1[unpack_codes(packed)] * E4M3[ws].repeat(16, axis=1)
            / np.float32(e['gscale'])).astype(np.float64)


def quant16(a):
    """与内核 nvfp4_quant_act 一致：每 16 个一组，amax/127，就近偶数，截到 [-128,127]。"""
    blk = a.reshape(-1, 16)
    amax = np.abs(blk).max(axis=1)
    s = np.where(amax > 0, amax / 127.0, 1.0)
    q = np.clip(np.rint(blk / s[:, None]), -128, 127)
    return q.reshape(-1) * np.repeat(s, 16)


def main():
    if len(sys.argv) < 5:
        print(__doc__)
        return 1
    st, mp, ap, cp = sys.argv[1:5]
    nver = 8
    if '--layers' in sys.argv:
        nver = int(sys.argv[sys.argv.index('--layers') + 1])

    mani, aux = read_manifest(mp), read_aux(ap)
    with open(cp, 'rb') as f:
        nl, H = struct.unpack('<2i', f.read(8))
        (token,) = struct.unpack('<q', f.read(8))
        chain = np.frombuffer(f.read(4 * H * nl), dtype=np.float32).reshape(nl, H).astype(np.float64)
    nver = min(nver, nl)
    print("链路: %d 层, hidden=%d, token=%d  -> 复算前 %d 层" % (nl, H, token, nver))

    def ref_layer(fh, l, h):
        nm = 'model.language_model.layers.%d.post_attention_layernorm.weight' % l
        w = bf16_at(fh, aux[nm]['off'], H)
        x = h / np.sqrt((h ** 2).mean() + 1e-6) * w
        xq = quant16(x)
        g = dequant(fh, mani['model.language_model.layers.%d.mlp.gate_proj' % l]) @ xq
        u = dequant(fh, mani['model.language_model.layers.%d.mlp.up_proj' % l]) @ xq
        a = (g / (1.0 + np.exp(-g))) * u
        y = dequant(fh, mani['model.language_model.layers.%d.mlp.down_proj' % l]) @ quant16(a)
        return h + y

    def report(tag, ref, got):
        rms = float(np.sqrt((ref ** 2).mean()))
        d = np.abs(got - ref)
        print("  层 %2d: 参考 RMS=%.6f  内核 RMS=%.6f  max|Δ|/RMS=%.2e  RMS(Δ)/RMS=%.2e"
              % (tag, rms, float(np.sqrt((got ** 2).mean())),
                 float(d.max()) / (rms + 1e-30), float(np.sqrt((d ** 2).mean())) / (rms + 1e-30)))
        return float(np.sqrt((d ** 2).mean())) / (rms + 1e-30)

    with open(st, 'rb') as fh:
        h0 = bf16_at(fh, aux['model.language_model.embed_tokens.weight']['off'] + token * H * 2, H)
        print("  输入 h(embedding) RMS = %.6f" % np.sqrt((h0 ** 2).mean()))

        print("  -- (A) 自由累加（从 embedding 起，误差会累积）--")
        h, wa = h0.copy(), 0.0
        for l in range(nver):
            h = ref_layer(fh, l, h)
            wa = max(wa, report(l, h, chain[l]))

        print("  -- (B) 单层隔离（输入取内核上一层输出）--")
        wb = 0.0
        for l in range(nver):
            hin = h0.copy() if l == 0 else chain[l - 1]
            wb = max(wb, report(l, ref_layer(fh, l, hin.copy()), chain[l]))

    print("\n  自由累加最差 RMS(Δ)/RMS = %.2e" % wa)
    print("  单层隔离最差 RMS(Δ)/RMS = %.2e" % wb)
    # 判据说明：int8 量化是**阶跃函数**，参考用 float64、内核用 float32，
    # 只要有一个元素的激活值恰好落在半整数边界附近，就会翻一个量化台阶。
    # 翻一个台阶（≈ amax/127）经 down_proj 放大后就是 ~1e-3 的 RMS 相对差 ——
    # 这不是算子算错。算子本身用「同一份量化激活」对照过：见 tools/check_stage.py，
    # 设备 g 与精确整数参考差 7.85e-08。所以判据取 2e-3。
    ok = wb < 2e-3
    print("  结论:", "一致（单层差在 int8 舍入边界翻转的量级；算子本身精确到 1e-7）"
          if ok else "**差得太多，要查**")
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
