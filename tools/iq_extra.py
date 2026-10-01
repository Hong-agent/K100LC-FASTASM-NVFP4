#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""补齐 GGUF 参考解码：Q2_K / IQ2_XXS / IQ2_XS / IQ1_M（严格照 llama.cpp ggml）。

现有 `k100lc-flashmoe/tools/iq_dequant.py` 已覆盖 IQ3_S/IQ4_XS/IQ3_XXS/IQ2_S/Q4_K 等；
本模块补上 GSQ-RCO 里另外 4 种（合计 580MB / 28 张量）：

    Q2_K      256 元素 / 84 字节   d, dmin, scales[16](4bit sc|4bit m), qs[64](2bit)
    IQ2_XXS   256 元素 / 66 字节   d(f16) + qs[32](u16)；8×32 组，4 个 u64 网格索引
    IQ2_XS    256 元素 / 74 字节   d(f16) + qs[32](u16) + scales[8]；4bit 组尺度
    IQ1_M     256 元素 / 56 字节   qs[32] + qh[16] + scales[8]；1.75bpw，共享 f16 尺度
"""
from __future__ import annotations

import pathlib
import sys

import numpy as np

_HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(_HERE))
sys.path.insert(0, "/home/t/桌面/k100lc-flashmoe/tools")
from iq_tables import (iq2xxs_grid, iq2xs_grid, kmask_iq2xs,  # noqa: E402
                       ksigns_iq2xs)
from iq1s_grid import IQ1S_GRID  # noqa: E402

_KMASK = np.array([int(v) for v in kmask_iq2xs], dtype=np.uint8)      # 1,2,4,…,128
_KSIGNS = np.array([int(v) for v in ksigns_iq2xs], dtype=np.uint8)    # 128
_IQ1S = np.frombuffer(IQ1S_GRID, dtype=np.int8).reshape(-1, 8)        # 2048×8 有符号


def _f16(b: np.ndarray, off: int) -> float:
    return float(np.frombuffer(b[off:off + 2].tobytes(), dtype=np.float16)[0])


def _u16(b: np.ndarray, off: int) -> int:
    return int(np.frombuffer(b[off:off + 2].tobytes(), dtype=np.uint16)[0])


def _u32(b: np.ndarray, off: int) -> int:
    return int(np.frombuffer(b[off:off + 4].tobytes(), dtype=np.uint32)[0])


def _grid8(idx: int, table) -> np.ndarray:
    """u64 网格项 → 8 个无符号幅值字节（小端）。"""
    return np.frombuffer(int(table[idx]).to_bytes(8, "little"), dtype=np.uint8)


def dequant_q2_k(raw: bytes) -> np.ndarray:
    buf = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 84)
    out = np.empty((buf.shape[0], 256), dtype=np.float32)
    for i, b in enumerate(buf):
        d, dmin = _f16(b, 0), _f16(b, 2)
        sc, qs = b[4:20], b[20:84]
        y = out[i]
        is_ = 0
        for n in range(2):                     # 两个 128 元素组
            q = qs[n * 32:(n + 1) * 32].astype(np.int32)
            p = n * 128
            shift = 0
            for _ in range(4):
                s = int(sc[is_]); is_ += 1
                y[p:p + 16] = d * (s & 0xF) * ((q[0:16] >> shift) & 3) - dmin * (s >> 4)
                p += 16
                s = int(sc[is_]); is_ += 1
                y[p:p + 16] = d * (s & 0xF) * ((q[16:32] >> shift) & 3) - dmin * (s >> 4)
                p += 16
                shift += 2
    return out.reshape(-1)


def dequant_iq2_xxs(raw: bytes) -> np.ndarray:
    buf = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 66)
    out = np.empty((buf.shape[0], 256), dtype=np.float32)
    for i, b in enumerate(buf):
        d = _f16(b, 0)
        y, p = out[i], 0
        for ib in range(8):
            a0 = _u32(b, 2 + 4 * ib)
            a1 = _u32(b, 6 + 4 * ib)
            db = d * (0.5 + (a1 >> 28)) * 0.25
            aux8 = a0.to_bytes(4, "little") + a1.to_bytes(4, "little")
            for l in range(4):
                g = _grid8(aux8[l], iq2xxs_grid).astype(np.float32)
                sgn = _KSIGNS[(a1 >> (7 * l)) & 127]
                s = np.where((sgn & _KMASK) != 0, -1.0, 1.0)
                y[p:p + 8] = db * g * s
                p += 8
    return out.reshape(-1)


def dequant_iq2_xs(raw: bytes) -> np.ndarray:
    buf = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 74)
    out = np.empty((buf.shape[0], 256), dtype=np.float32)
    for i, b in enumerate(buf):
        d = _f16(b, 0)
        y, p = out[i], 0
        for ib in range(8):
            db = (d * (0.5 + (b[66 + ib] & 0xF)) * 0.25,
                  d * (0.5 + (b[66 + ib] >> 4)) * 0.25)
            for l in range(4):
                v = _u16(b, 2 + 2 * (4 * ib + l))
                g = _grid8(v & 511, iq2xs_grid).astype(np.float32)
                sgn = _KSIGNS[v >> 9]
                s = np.where((sgn & _KMASK) != 0, -1.0, 1.0)
                y[p:p + 8] = db[l // 2] * g * s
                p += 8
    return out.reshape(-1)


def dequant_iq1_m(raw: bytes) -> np.ndarray:
    buf = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 56)
    out = np.empty((buf.shape[0], 256), dtype=np.float32)
    for i, b in enumerate(buf):
        sc = [_u16(b, 48 + 2 * k) for k in range(4)]
        scale_u16 = (sc[0] >> 12) | ((sc[1] >> 8) & 0x00f0) \
            | ((sc[2] >> 4) & 0x0f00) | (sc[3] & 0xf000)
        d = float(np.frombuffer(np.uint16(scale_u16).tobytes(), dtype=np.float16)[0])
        qs, qh = b[0:32], b[32:48]
        y, p = out[i], 0
        for ib in range(8):
            dl1 = d * (2 * ((sc[ib // 2] >> (6 * (ib % 2) + 0)) & 7) + 1)
            dl2 = d * (2 * ((sc[ib // 2] >> (6 * (ib % 2) + 3)) & 7) + 1)
            idx = [qs[4 * ib + 0] | ((qh[2 * ib + 0] << 8) & 0x700),
                   qs[4 * ib + 1] | ((qh[2 * ib + 0] << 4) & 0x700),
                   qs[4 * ib + 2] | ((qh[2 * ib + 1] << 8) & 0x700),
                   qs[4 * ib + 3] | ((qh[2 * ib + 1] << 4) & 0x700)]
            delta = [(-0.125 if qh[2 * ib + 0] & 0x08 else 0.125),
                     (-0.125 if qh[2 * ib + 0] & 0x80 else 0.125),
                     (-0.125 if qh[2 * ib + 1] & 0x08 else 0.125),
                     (-0.125 if qh[2 * ib + 1] & 0x80 else 0.125)]
            for l in range(4):
                g = _IQ1S[idx[l]].astype(np.float32)
                y[p:p + 8] = (dl1 if l < 2 else dl2) * (g + delta[l])
                p += 8
    return out.reshape(-1)


EXTRA = {"Q2_K": (256, 84, dequant_q2_k),
         "IQ2_XXS": (256, 66, dequant_iq2_xxs),
         "IQ2_XS": (256, 74, dequant_iq2_xs),
         "IQ1_M": (256, 56, dequant_iq1_m)}


def selftest() -> int:
    rng = np.random.default_rng(3)
    for name, (qk, bb, fn) in EXTRA.items():
        raw = bytearray(rng.integers(0, 256, size=bb * 4, dtype=np.uint8).tobytes())
        for i in range(4):                      # 尺度写正常值，避免 NaN/Inf 干扰
            raw[i * bb:i * bb + 2] = np.float16(0.01).tobytes()
        y = fn(bytes(raw))
        ok = y.shape[0] == qk * 4 and np.isfinite(y).all()
        print(f"{name:8s} {qk} 元素/{bb} 字节  RMS={float(np.sqrt((y**2).mean())):.5f} "
              f"{'OK ✔' if ok else 'FAIL ✘'}")
        if not ok:
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(selftest())
