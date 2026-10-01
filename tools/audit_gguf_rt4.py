#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""对账：GGUF 原始字节（参考解码器） vs 转换后的 RT4 文件（引擎读法）。

    python3 tools/audit_gguf_rt4.py --gguf <file.gguf> --rt4 build/qwen38_gsq.rt4 \
            [--rows 8] [--ref models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4]

第 1 组相关性 gguf↔rt4 应当 ~0.99（只差 int4 重量化误差）：低 = 转换错了。
第 2 组 gguf↔ref 是「两份 checkpoint 的权重差多少」，与转换正确性无关。
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

from gguf_probe import GGUFHeader  # noqa: E402
from iq_dequant import dequantize  # noqa: E402
from k100lc_kernels.rt4 import RT4File  # noqa: E402

from gguf_to_rt4 import TYPES, GEOM, gguf_to_hf  # noqa: E402


def corr(a: np.ndarray, b: np.ndarray) -> float:
    a = a.astype(np.float64).ravel()
    b = b.astype(np.float64).ravel()
    a -= a.mean()
    b -= b.mean()
    d = np.linalg.norm(a) * np.linalg.norm(b)
    return float(a @ b / d) if d else float("nan")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gguf", required=True)
    ap.add_argument("--rt4", required=True)
    ap.add_argument("--ref", default="")
    ap.add_argument("--rows", type=int, default=8)
    ap.add_argument("--names", default="",
                    help="逗号分隔的 GGUF 名；默认抽样几种量化类型")
    args = ap.parse_args()

    h = GGUFHeader(args.gguf)
    by_name = {t.name: t for t in h.tensors}
    f = RT4File(args.rt4)
    ref = RT4File(args.ref) if args.ref else None

    if args.names:
        names = [n for n in args.names.split(",") if n]
    else:
        seen, names = set(), []
        for t in h.tensors:
            if t.name.startswith("blk.") and t.type_name not in seen:
                seen.add(t.type_name)
                names.append(t.name)
        for extra in ("token_embd.weight", "output.weight"):
            if extra in by_name:
                names.append(extra)

    print(f"{'gguf type':<10} {'name':<44} {'gguf↔rt4':>9} {'gguf↔ref':>9}")
    with open(args.gguf, "rb") as fg:
        for name in names:
            g = by_name[name]
            hf = gguf_to_hf(name)
            if hf is None or hf not in f.names():
                print(f"{g.type_name:<10} {name:<44} {'(未映射)':>9}")
                continue
            rows = 1 if len(g.shape) == 1 else int(g.shape[1])
            cols = int(g.shape[0])
            nr = min(args.rows, rows)
            qk, bb = GEOM[TYPES[g.type_name]]
            assert cols % qk == 0, (name, cols, qk)
            bbrow = cols // qk * bb
            fg.seek(h.data_start + g.offset)
            raw = fg.read(nr * bbrow)
            A = np.asarray(dequantize(raw, g.type_name), dtype=np.float32).reshape(nr, cols)

            t = f.tensor(hf)
            if t.kind != "i4":
                print(f"{g.type_name:<10} {name:<44} {'(非 i4 张量)':>9}")
                continue
            B = f.dequant(t, rows=nr)
            c1 = corr(A, B[:, :t.cols]) if B.shape[1] >= cols else corr(A, B)
            c2 = float("nan")
            if ref is not None and hf in ref.names():
                R = ref.dequant(ref.tensor(hf), rows=nr)
                c2 = corr(A, R) if R.shape == A.shape else float("nan")
            print(f"{g.type_name:<10} {name:<44} {c1:>9.4f} {c2:>9.4f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
