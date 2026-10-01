#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""转换对账：GGUF 原始字节（参考解码器） ↔ RT4 文件（引擎读法），带 v-head 置换。

    python3 tools/audit_convert.py --gguf <f.gguf> --rt4 build/qwen38_gsq.rt4 \
            [--chunks 6] [--rows 4] [--min 0.98]

in_proj_qkv（只 v 段）与 in_proj_z 在 RT4 里已经是 HF 顺序，所以比对时要把 GGUF 的
行按 P 换算过去；其余张量逐行对齐。相关系数 ~0.99 表示转换无损。
"""
from __future__ import annotations

import argparse
import json
import pathlib
import sys

import numpy as np

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, "/home/t/桌面/k100lc-flashmoe/tools")
sys.path.insert(0, "/home/t/桌面/K100LC-kernels/python")

from iq_dequant import dequantize as dq_base      # noqa: E402
from iq_extra import (dequant_q2_k, dequant_iq2_xxs,  # noqa: E402
                      dequant_iq2_xs, dequant_iq1_m)
from k100lc_kernels.rt4 import RT4File            # noqa: E402

from gguf_to_rt4 import TYPES                      # noqa: E402
from gguf_vhead_perm import N_VHEAD, QKV_V_ROW, P   # noqa: E402

EXTRA = {"Q2_K": dequant_q2_k, "IQ2_XXS": dequant_iq2_xxs,
         "IQ2_XS": dequant_iq2_xs, "IQ1_M": dequant_iq1_m}
ID2NAME = {v: k for k, v in TYPES.items()}


def dequant(raw: bytes, tname: str) -> np.ndarray:
    return EXTRA[tname](raw) if tname in EXTRA else dq_base(raw, tname)


def rt4_rows(f: RT4File, t, row0: int, n: int) -> np.ndarray:
    rows, cols, g = t.shape[0], t.shape[1], t.group
    q = np.frombuffer(f._mm[t.q_off:t.q_off + t.q_bytes],
                      dtype=np.uint8).reshape(rows, cols // 2)[row0:row0 + n]
    lo = (q & 0xF).astype(np.int8)
    hi = (q >> 4).astype(np.int8)
    v = np.empty((n, cols), dtype=np.float32)
    v[:, 0::2] = np.where(lo > 7, lo - 16, lo)
    v[:, 1::2] = np.where(hi > 7, hi - 16, hi)
    s = np.frombuffer(f._mm[t.s_off:t.s_off + t.s_bytes],
                      dtype=np.float16).astype(np.float32).reshape(rows, cols // g)
    return (v.reshape(n, cols // g, g) * s[row0:row0 + n, :, None]).reshape(n, cols)


def corr(x: np.ndarray, y: np.ndarray) -> float:
    x = x.ravel().astype(np.float64)
    y = y.ravel().astype(np.float64)
    x -= x.mean()
    y -= y.mean()
    d = np.linalg.norm(x) * np.linalg.norm(y)
    return float(x @ y / d) if d else float("nan")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gguf", required=True)
    ap.add_argument("--rt4", required=True)
    ap.add_argument("--plan", default=str(ROOT / "build/gguf_to_rt4.plan.tsv"))
    ap.add_argument("--chunks", type=int, default=6)
    ap.add_argument("--rows", type=int, default=4)
    ap.add_argument("--min", type=float, default=0.98)
    ap.add_argument("--tsv", default="")
    args = ap.parse_args()

    plan = [l.split("\t") for l in
            pathlib.Path(args.plan).read_text().strip().split("\n")]
    man = json.loads(pathlib.Path(args.rt4 + ".json").read_text())["tensors"]
    assert len(plan) == len(man), (len(plan), len(man))
    f = RT4File(args.rt4)
    out, bad = [], []
    with open(args.gguf, "rb") as fg:
        for line, ent in zip(plan, man):
            if ent["kind"] != "i4":
                continue
            rows, cols = int(line[2]), int(line[3])
            goff, bbrow = int(line[4]), int(line[7])
            tname = ID2NAME[int(line[9])]
            name = ent["name"]
            perm = None
            if name.endswith("in_proj_qkv.weight"):
                perm = (QKV_V_ROW, cols // 2)
            elif name.endswith("in_proj_z.weight"):
                perm = (0, cols // 2)
            t = f.tensor(name)
            def rt_row(abs_row: int) -> int:
                """GGUF 的绝对行号 → 它在 RT4 文件里的行号（v-head 段要换算）。"""
                if perm is None:
                    return abs_row
                base = perm[0]
                if abs_row < base:
                    return abs_row
                i = (abs_row - base) // 128
                return base + int(P[i]) * 128 + (abs_row - base) % 128

            xs, ys = [], []
            for k in range(args.chunks):
                o = (k * rows) // args.chunks
                n = min(args.rows, rows - o)
                if n <= 0:
                    continue
                fg.seek(goff + o * bbrow)
                A = np.asarray(dequant(fg.read(n * bbrow), tname),
                               dtype=np.float32).reshape(n, cols)
                B = np.stack([rt4_rows(f, t, rt_row(o + r), 1)[0] for r in range(n)])
                xs.append(A)
                ys.append(B)
            c = corr(np.concatenate(xs), np.concatenate(ys))
            out.append((c, name, tname))
            if c < args.min:
                bad.append((c, name, tname))
    out.sort()
    print(f"i4 张量 {len(out)} 个，corr<{args.min} 的 {len(bad)} 个；最差 10 个：")
    for c, n, t in out[:10]:
        print(f"   {c:.4f}  {t:<9} {n}")
    import collections
    print("低分分布：", collections.Counter(t for _, _, t in bad).most_common())
    if args.tsv:
        pathlib.Path(args.tsv).write_text(
            "\n".join(f"{c:.6f}\t{t}\t{n}" for c, n, t in out) + "\n")
        print("→", args.tsv)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
