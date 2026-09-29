#!/usr/bin/env python3
"""独立复算：拿内核落盘的 (激活, 输出)，用**纯 NumPy** 从原始 safetensors 字节
重新算一遍，核对内核结果。

    # 1) 内核侧落盘
    bash scripts/run.sh build/nvfp4_run build/nvfp4_manifest.tsv \\
         /models/Qwen3.8-27B-NVFP4/model.safetensors --wide \\
         --dump model.language_model.layers.0.mlp.gate_proj build/dump.bin
    # 2) Python 侧复算
    python3 tools/check_real.py models/Qwen3.8-27B-NVFP4/model.safetensors \\
         build/nvfp4_manifest.tsv model.language_model.layers.0.mlp.gate_proj build/dump.bin

这条路子刻意不复用 C++ 那份参考实现：格式解析、LUT、激活量化顺序都在这里重写一遍。
"""
import sys, struct
import numpy as np

from nvfp4_ref import E2M1, E4M3, unpack_codes, st_read_header


def load_manifest(path):
    m = {}
    for line in open(path):
        if line.startswith('#') or not line.strip():
            continue
        p = line.split()
        m[p[0]] = dict(poff=int(p[1]), pbytes=int(p[2]), soff=int(p[3]),
                       sbytes=int(p[4]), gscale=float(p[5]), N=int(p[6]), K=int(p[7]))
    return m


def quant_act_block16(a):
    """与内核 nnvfp4_quant_act 完全相同的量化：每 16 个一组，amax/127，就近偶数。"""
    n = a.size
    assert n % 16 == 0
    blk = a.reshape(-1, 16)
    amax = np.abs(blk).max(axis=1)
    s = np.where(amax > 0, amax / 127.0, 1.0).astype(np.float32)
    q = np.rint(blk / s[:, None]).astype(np.int32)
    q = np.clip(q, -128, 127)
    return q.reshape(-1), s, amax


def main():
    if len(sys.argv) < 5:
        print(__doc__)
        return 1
    st, mani, name, dump = sys.argv[1:5]
    e = load_manifest(mani)[name]
    N, K = e['N'], e['K']

    # ---- 内核落盘的内容 ----
    with open(dump, 'rb') as f:
        hN, hK = struct.unpack('<2i', f.read(8))
        assert (hN, hK) == (N, K), ('dump 形状不符', hN, hK, N, K)
        a = np.frombuffer(f.read(4 * K), dtype=np.float32).copy()
        y_dev = np.frombuffer(f.read(4 * N), dtype=np.float32).copy()

    # ---- 从原始字节反量化权重 ----
    with open(st, 'rb') as f:
        f.seek(e['poff'])
        packed = np.frombuffer(f.read(e['pbytes']), dtype=np.uint8).reshape(N, K // 2)
        f.seek(e['soff'])
        ws = np.frombuffer(f.read(e['sbytes']), dtype=np.uint8).reshape(N, K // 16)
    W = E2M1[unpack_codes(packed)] * E4M3[ws].repeat(16, axis=1) / np.float32(e['gscale'])

    # ---- 用同一种激活量化，float64 复算 ----
    q, s, amax = quant_act_block16(a)
    av = (q.astype(np.float64) * s.astype(np.float64).repeat(16))
    y_ref = W.astype(np.float64) @ av

    # ---- 对照 ----
    rms = float(np.sqrt(np.mean(y_ref.astype(np.float64) ** 2)))
    d = np.abs(y_dev.astype(np.float64) - y_ref)
    rel = d.max() / (rms + 1e-30)
    # 逐元素相对误差（排除接近 0 的输出）
    nz = np.abs(y_ref) > 0.01 * rms
    rel_el = (d[nz] / np.abs(y_ref[nz]))
    print("%s  N=%d K=%d gscale=%g" % (name, N, K, e['gscale']))
    print("  反量化权重: mean=%.6f std=%.6f amax=%.6f" % (W.mean(), W.std(), np.abs(W).max()))
    print("  参考 y:     RMS=%.5f   amax=%.5f" % (rms, np.abs(y_ref).max()))
    print("  内核 vs NumPy:  max|Δ|=%.3e   max|Δ|/RMS=%.3e   逐元素最大相对误差=%.3e"
          % (d.max(), rel, rel_el.max()))
    print("  抽查前 4 行:  ", ["%.6f/%.6f" % (y_dev[i], y_ref[i]) for i in range(4)])
    ok = rel < 1e-5
    print("  结论:", "一致（差异在 float32 舍入量级）" if ok else "**不一致**")
    return 0 if ok else 1


if __name__ == '__main__':
    sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
    sys.exit(main())
