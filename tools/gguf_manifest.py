#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""为「GGUF 直读」生成引擎侧的权重清单（不转换、不复制权重字节）。

    python3 tools/gguf_manifest.py --gguf <IQ3_S.gguf> -o build/gguf_direct.tsv

输出 TSV：hf_name  gguf_type_id  rows  cols  block_elems  block_bytes  file_offset  table
  * `hf_name`     = 引擎内部使用的张量名（与 RT4 清单一致）
  * `table`       = 需要码本表的编码：grid32=IQ3_S、grid32s=IQ3_XXS、grid64=IQ2_S、空
  * 文件偏移是**绝对**的（已加 GGUF data_start）
引擎拿到这张表后：按 (文件, 偏移) 原地 pread → 显存，`linear()` 按 type 分派到
对应 `*_dot_k`（解码）或 `*_dequant_k + gemv_f32`（M>1），全程不重量化。
"""
from __future__ import annotations

import argparse
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, "/home/t/桌面/k100lc-flashmoe/tools")
from gguf_probe import GGUFHeader  # noqa: E402
from gguf_to_rt4 import TYPES, GEOM, gguf_to_hf  # noqa: E402

TABLE = {16: "grid32s", 19: "grid32", 20: "grid64"}   # IQ3_XXS / IQ3_S / IQ2_S


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gguf", required=True)
    ap.add_argument("-o", "--out", default=str(ROOT / "build/gguf_direct.tsv"))
    args = ap.parse_args()
    h = GGUFHeader(args.gguf)
    rows_out, nt = [], 0
    for t in h.tensors:
        hf = gguf_to_hf(t.name)
        if hf is None:
            continue
        tid = TYPES.get(t.type_name)
        if tid is None:
            print(f"  ! 未知类型 {t.type_name}（{t.name}）", file=sys.stderr)
            continue
        qk, bb = GEOM[tid]
        rows = 1 if len(t.shape) == 1 else t.shape[1]
        cols = t.shape[0]
        rows_out.append(f"{hf}\t{tid}\t{rows}\t{cols}\t{qk}\t{bb}\t"
                        f"{h.data_start + t.offset}\t{TABLE.get(tid, '')}")
        nt += 1
    pathlib.Path(args.out).write_text("\n".join(rows_out) + "\n", encoding="utf-8")
    print(f"-> {args.out}：{nt} 张量（GGUF 直读清单，含绝对偏移与类型）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
