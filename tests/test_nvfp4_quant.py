#!/usr/bin/env python3
"""tools/nvfp4_quant.py 的离线单测（不需要 GPU / 不需要真实权重）。

造一个很小的「compressed-tensors float-quantized」safetensors（FP8 权重 + BF16 逐通道
尺度），用它跑一遍重量化，然后检查：

  1. 规格与 MLP 的原生 NVFP4 一致：gscale = 448*6/amax、每 16 个 k 一个 E4M3 尺度、
     每块最接近 6（顶满）、偶数 k 在低半字节；
  2. 解码回来（用 tools/nvfp4_ref.py 的真值表）与源 FP8 权重的相对 RMS 误差合理；
  3. 清单里的偏移/长度与 blob 的真实布局自洽。
"""
import json
import os
import struct
import subprocess
import sys
import tempfile

import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import nvfp4_ref as R                                            # noqa: E402
import nvfp4_quant as Q                                          # noqa: E402

N, K = 37, 512                                                  # K 必须是 16 的倍数


def write_fake_safetensors(path, w_f32):
    """w_f32 [N,K] → <stem>.weight F8_E4M3 + <stem>.weight_scale BF16[N,1]。"""
    # 逐通道尺度取「该行 amax/E4M3 最大值」，权重再量化成 FP8（模拟 checkpoint 的做法）
    row_amax = np.abs(w_f32).max(axis=1)
    s = np.where(row_amax > 0, row_amax / Q.E4M3_MAXV, 1.0).astype(np.float32)
    q = w_f32 / s[:, None]
    code = Q.e4m3_encode(np.abs(q).reshape(-1))
    fp8 = Q.E4M3_POS[code].reshape(N, K).astype(np.float32)
    fp8 = np.where(q < 0, -fp8, fp8)
    fp8_bytes = np.zeros((N, K), dtype=np.uint8)
    # 反查码：用二分找量值对应的 E4M3 码（k==0 时码也是 0）
    neg = fp8 < 0
    mag = np.abs(fp8).reshape(-1)
    idx = np.searchsorted(Q.E4M3_MID, mag, side='right')
    # 注意 astype(uint8)：uint8|int64 会提升成 int64，tobytes() 就变成 8 字节/元素
    fp8_bytes = (idx.astype(np.uint8) | (neg.reshape(-1) << 7)).astype(np.uint8)
    fp8_bytes = fp8_bytes.reshape(N, K)
    s_bf16 = (s.astype(np.float32).view(np.uint32) >> 16).astype(np.uint16)

    hdr, off = {}, 0
    parts = {}
    for name, arr in ((f'{STEM}.weight', fp8_bytes),
                      (f'{STEM}.weight_scale', s_bf16.reshape(-1, 1))):
        raw = arr.tobytes()
        hdr[name] = {'dtype': 'F8_E4M3' if arr is fp8_bytes else 'BF16',
                     'shape': list(arr.shape), 'data_offsets': [off, off + len(raw)]}
        parts[name] = raw
        off += len(raw)
    js = json.dumps(hdr).encode()
    with open(path, 'wb') as f:
        f.write(struct.pack('<Q', len(js)))
        f.write(js)
        for name in hdr:
            f.write(parts[name])
    return fp8 * s[:, None]                                      # 源（FP8 反量化后）


STEM = 'model.language_model.layers.0.self_attn.q_proj'
fails = []


def check(name, cond, extra=''):
    print(('ok   ' if cond else 'FAIL ') + name + (('  ' + extra) if extra else ''))
    if not cond:
        fails.append(name)


def main() -> int:
    rng = np.random.default_rng(1234)
    # 带离群点的权重（更接近真实：少量大值 + 大量小值）
    w = rng.standard_normal((N, K)).astype(np.float32) * 0.02
    w[rng.random((N, K)) < 0.02] *= 8.0
    with tempfile.TemporaryDirectory() as td:
        st = os.path.join(td, 'fake.safetensors')
        blob = os.path.join(td, 'blob.bin')
        tsv = os.path.join(td, 'blob.tsv')
        src = write_fake_safetensors(st, w)
        r = subprocess.run([sys.executable, os.path.join(ROOT, 'tools', 'nvfp4_quant.py'),
                            '--safetensors', st, '--out', blob, '--tsv', tsv],
                           capture_output=True, text=True)
        check('工具正常退出', r.returncode == 0, r.stderr[-300:])
        rows = [l.split() for l in open(tsv) if not l.startswith('#')]
        check('清单 1 行', len(rows) == 1)
        stem, poff, pbytes, soff, sbytes, gs, tN, tK = rows[0]
        poff, pbytes, soff, sbytes, gs = int(poff), int(pbytes), int(soff), int(sbytes), float(gs)
        tN, tK = int(tN), int(tK)
        check('N/K 正确', (tN, tK) == (N, K), f'{tN}x{tK}')
        check('打包/尺度字节数', (pbytes, sbytes) == (N * K // 2, N * K // 16))
        check('blob 大小 = 两段之和', os.path.getsize(blob) == pbytes + sbytes)

        # ---- 规格：gscale = 448*6/amax ----
        amax = float(np.abs(src).max())
        check('gscale = 448*6/amax', abs(gs - 448 * 6 / amax) < 1e-3 * gs, f'{gs:.4f}')

        raw = open(blob, 'rb').read()
        P = np.frombuffer(raw[:pbytes], dtype=np.uint8).reshape(N, K // 2).astype(np.int32)
        S = np.frombuffer(raw[pbytes:pbytes + sbytes], dtype=np.uint8).reshape(N, K // 16)
        # ---- 打包顺序：偶数 k 在低半字节 ----
        code = np.zeros((N, K), dtype=np.int32)
        code[:, 0::2] = P & 0xF
        code[:, 1::2] = (P >> 4) & 0xF
        dec = R.E2M1[code] * np.repeat(R.E4M3[S.astype(np.int32)], 16, axis=1) / gs
        top = np.abs(R.E2M1[code]).reshape(N, K // 16, 16).max(axis=2)
        check('每个块顶满 6', np.allclose(top, 6.0), f'min={top.min()} max={top.max()}')
        rel = float(np.sqrt(((dec - src) ** 2).sum() / (src ** 2).sum()))
        check('相对 RMS 误差 < 15%', rel < 0.15, f'{rel * 100:.2f}%')
        check('解码量级正确（std 差 < 5%）',
              abs(dec.std() - src.std()) / src.std() < 0.05,
              f'src={src.std():.5f} dec={dec.std():.5f}')
        unit = R.E4M3[S.astype(np.int32)] / gs
        mags = np.array([0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=np.float32)
        ratio = np.abs(dec) / np.repeat(np.maximum(unit, 1e-30), 16, axis=1)
        on_grid = np.isclose(ratio[..., None], mags, atol=1e-5).any(axis=-1)
        check('解码值都落在 E2M1 格点上', bool(on_grid.all()))

    print()
    if fails:
        print('有失败项（%d）' % len(fails))
        return 1
    print('全部通过（0 项失败）')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
