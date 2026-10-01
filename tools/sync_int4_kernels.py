#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 K100LC-kernels 包里的「原生 int4」内核同步进本项目的内核构建。

（只同步 int4 这两个；要同步包里的**全部**内核，用 tools/sync_kernels.py。）

同步的内核：

    int4_dot_k       compressed-tensors INT4（W4A16, group 128）原生解码 + 点积
    reduce_blocks_k  每行 nbpr 个 partial 求和（int4_dot_k 的配套归约）

来源是 `K100LC-kernels`（默认 /home/t/桌面/K100LC-kernels）里跑过
`bash tools/build_all.sh` / `tools/gen_int4_dot.py` 之后的产物：

    build/flashmoe_kernels/<name>.s             生成的 gfx926 汇编
    build/flashmoe_kernels/flashmoe.spec.json   参数表 / kernarg / SGPR-VGPR 计数

本脚本把 `.s` 复制到 `kernels/asm/k_new/`，并把 spec 条目（带 `asm` 字段）
插进 `kernels/kernel_spec.json`；重复执行是幂等的。

    python3 tools/sync_int4_kernels.py [--pkg /home/t/桌面/K100LC-kernels]
"""
from __future__ import annotations

import argparse
import json
import pathlib
import shutil
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
NAMES = ["int4_dot_k", "reduce_blocks_k"]
# spec 里要保留的字段（`asm` 由本脚本填；`code` 是包内的 .bin 路径，丢掉）
FIELDS = ["args", "kernarg_size", "kernarg_align", "sgpr_count", "vgpr_count",
          "group_segment", "private_segment"]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pkg", type=pathlib.Path, default=pathlib.Path("/home/t/桌面/K100LC-kernels"))
    args = ap.parse_args()

    spec_path = ROOT / "kernels" / "kernel_spec.json"
    asm_dir = ROOT / "kernels" / "asm" / "k_new"
    pkg_files = args.pkg / "build" / "flashmoe_kernels"
    pkg_spec = json.loads((pkg_files / "flashmoe.spec.json").read_text())
    by_name = {e["name"]: e for e in pkg_spec}

    src_spec = json.loads(spec_path.read_text())
    for name in NAMES:
        if name not in by_name:
            print(f"!! 包里的 flashmoe.spec.json 没有 {name}；先跑 "
                  f"`bash tools/build_all.sh` 或 `python3 tools/gen_int4_dot.py`",
                  file=sys.stderr)
            return 1
        src = pkg_files / f"{name}.s"
        if not src.is_file():
            print(f"!! 缺 {src}", file=sys.stderr)
            return 1
        shutil.copyfile(src, asm_dir / f"{name}.s")
        entry = {"name": name}
        for f in FIELDS:
            entry[f] = by_name[name][f]
        entry["kernarg_align"] = by_name[name].get("kernarg_align", 8)
        entry["asm"] = f"k_new/{name}.s"
        idx = next((i for i, e in enumerate(src_spec) if e["name"] == name), None)
        if idx is None:
            src_spec.append(entry)
            print(f"  + {name}（{len(entry['args'])} 个参数，kernarg={entry['kernarg_size']}）")
        else:
            src_spec[idx] = entry
            print(f"  ~ {name} 已更新")

    spec_path.write_text(json.dumps(src_spec, indent=1, ensure_ascii=False), encoding="utf-8")
    print(f"-> {spec_path}: {len(src_spec)} 个内核（含 {', '.join(NAMES)}）")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
