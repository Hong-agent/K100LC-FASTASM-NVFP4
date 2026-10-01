#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""给 RT4 的 i4 权重注入指定相对 RMS 的噪声后重新量化（用于敏感度实验）。

    python3 tools/add_weight_noise.py --rt4 build/qwen38_refw.rt4 --sigma 0.117

同一套 int4/group128 格式：解码 → 加噪 → 用 amax/7 重新量化（与
tools/gguf_to_rt4.py 的 gguf_requant 完全一致的量化规则）。
"""
from __future__ import annotations

import argparse
import json
import pathlib

import numpy as np


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rt4", required=True)
    ap.add_argument("--sigma", type=float, default=0.117)
    ap.add_argument("--seed", type=int, default=1234)
    ap.add_argument("--rows", type=int, default=512, help="每次处理的行数")
    args = ap.parse_args()

    p = pathlib.Path(args.rt4)
    man = json.loads(p.with_suffix(".rt4.json").read_text())["tensors"]
    rng = np.random.default_rng(args.seed)
    n_done = 0
    with open(p, "r+b") as f:
        for t in man:
            if t["kind"] != "i4":
                continue
            rows, cols = t["shape"]
            g = int(t.get("group", 128))
            qrow, srow = cols // 2, (cols // g) * 2
            for r0 in range(0, rows, args.rows):
                nr = min(args.rows, rows - r0)
                f.seek(t["q_off"] + r0 * qrow)
                q = np.frombuffer(f.read(nr * qrow), dtype=np.uint8).reshape(nr, qrow)
                f.seek(t["s_off"] + r0 * srow)
                s = np.frombuffer(f.read(nr * srow), dtype=np.float16).astype(np.float32).reshape(nr, -1)
                lo = (q & 0xF).astype(np.int8)
                hi = (q >> 4).astype(np.int8)
                v = np.empty((nr, cols), dtype=np.float32)
                v[:, 0::2] = np.where(lo > 7, lo - 16, lo)
                v[:, 1::2] = np.where(hi > 7, hi - 16, hi)
                w = (v.reshape(nr, cols // g, g) * s[:, :, None]).reshape(nr, cols)
                w = w + rng.standard_normal(w.shape, dtype=np.float32) * (args.sigma * w.std())
                w = w.reshape(nr, cols // g, g)
                amax = np.abs(w).max(-1)
                sc = np.where(amax > 0, amax / 7.0, 1.0).astype(np.float32)
                code = np.rint(w / sc[:, :, None])
                code = np.clip(code, -8, 7).astype(np.int8)
                qb = ((code & 0xF).astype(np.uint8))
                packed = (qb[:, :, 0::2] | (qb[:, :, 1::2] << 4)).reshape(nr, qrow)
                f.seek(t["q_off"] + r0 * qrow)
                f.write(packed.tobytes())
                f.seek(t["s_off"] + r0 * srow)
                f.write(sc.astype(np.float16).tobytes())
            n_done += 1
        f.flush()
    print(f"注入 sigma={args.sigma} 的噪声：{n_done} 个 i4 张量")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
