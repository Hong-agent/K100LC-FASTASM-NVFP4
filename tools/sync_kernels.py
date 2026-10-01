#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 K100LC-kernels 包里的**全部内核**同步进本项目的内核构建。

包的权威清单有两份：

    <pkg>/kernels/kernel_spec.json                    81 基线 + 4 自研
                                                      （gemm_w4a4_flat / Q*_dequant）
    <pkg>/build/flashmoe_kernels/flashmoe.spec.json   34 自研
                                                      （int4 / quant / gemv / GGUF / MoE）

两份加起来 119 个（与包 README 的「119 个内核」一致）。项目里已经有的内核
**默认不覆盖**（避免用包里的版本盖掉项目自己的改动），只把缺的复制到
`kernels/asm/k_pkg/<name>.s`，并按项目 spec 的字段格式追加一条。

    python3 tools/sync_kernels.py [--pkg /home/t/桌面/K100LC-kernels] [--refresh] [--check]

`--refresh` 会顺带用包里的版本覆盖同名内核；`--check` 只报告差异，不写盘。
"""
from __future__ import annotations

import argparse
import json
import pathlib
import shutil
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
# spec 里要保留的字段（`asm` 由本脚本按项目内路径填；`code` 是包内的 .bin 路径，丢掉）
FIELDS = ["args", "kernarg_size", "kernarg_align", "sgpr_count", "vgpr_count",
          "group_segment", "private_segment"]
PKG_SPECS = ["kernels/kernel_spec.json",
             "build/flashmoe_kernels/flashmoe.spec.json"]


def pkg_entries(pkg: pathlib.Path) -> list[tuple[str, dict, pathlib.Path]]:
    """返回 [(来源 spec 相对路径, spec 条目, .s 源文件)]。"""
    out: list[tuple[str, dict, pathlib.Path]] = []
    for rel in PKG_SPECS:
        spec = json.loads((pkg / rel).read_text(encoding="utf-8"))
        for e in spec:
            if rel.startswith("kernels/"):
                src = pkg / "kernels" / "asm" / e["asm"]
            else:
                src = pkg / rel.rsplit("/", 1)[0] / f"{e['name']}.s"
            out.append((rel, e, src))
    return out


def entry_for(e: dict, asm_rel: str) -> dict:
    entry = {"name": e["name"]}
    for f in FIELDS:
        if f in e:
            entry[f] = e[f]
    entry["kernarg_align"] = e.get("kernarg_align", 8)
    entry["asm"] = asm_rel
    return entry


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pkg", type=pathlib.Path,
                    default=pathlib.Path("/home/t/桌面/K100LC-kernels"))
    ap.add_argument("--refresh", action="store_true",
                    help="同名内核也用包里的版本覆盖")
    ap.add_argument("--check", action="store_true", help="只报告差异，不写盘")
    args = ap.parse_args()
    if not (args.pkg / "kernels/kernel_spec.json").is_file():
        print(f"!! 找不到内核包 {args.pkg}（缺 kernels/kernel_spec.json）", file=sys.stderr)
        return 1

    spec_path = ROOT / "kernels" / "kernel_spec.json"
    asm_dir = ROOT / "kernels" / "asm" / "k_pkg"
    src_spec = json.loads(spec_path.read_text(encoding="utf-8"))
    have = {e["name"]: i for i, e in enumerate(src_spec)}

    added, refreshed, skipped, missing = [], [], [], []
    for rel, e, src in pkg_entries(args.pkg):
        name = e["name"]
        if not src.is_file():
            missing.append((name, str(src)))
            continue
        if name in have and not args.refresh:
            skipped.append(name)
            continue
        asm_rel = f"k_pkg/{name}.s"
        if args.check:
            (added if name not in have else refreshed).append(name)
            continue
        asm_dir.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, asm_dir / f"{name}.s")
        entry = entry_for(e, asm_rel)
        if name in have:
            src_spec[have[name]] = entry
            refreshed.append(name)
        else:
            have[name] = len(src_spec)
            src_spec.append(entry)
            added.append(name)

    if not args.check:
        spec_path.write_text(json.dumps(src_spec, indent=1, ensure_ascii=False),
                             encoding="utf-8")
    verb = "将新增" if args.check else "已新增"
    print(f"{verb} {len(added)} 个内核；刷新 {len(refreshed)} 个；项目已有 {len(skipped)} 个")
    if added:
        for n in added:
            print(f"  + {n}")
    if refreshed:
        for n in refreshed:
            print(f"  ~ {n}")
    if missing:
        for n, p in missing:
            print(f"  !! 缺源文件 {n}: {p}", file=sys.stderr)
        return 1
    print(f"-> {spec_path}: {len(src_spec)} 个内核")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
