#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 K100LC-kernels 包里的**全部内核**同步进本项目的内核构建。

包的权威清单有三份：

    <pkg>/kernels/kernel_spec.json                    81 基线 + 4 自研
                                                      （gemm_w4a4_flat / Q*_dequant）
    <pkg>/build/flashmoe_kernels/flashmoe.spec.json   34 自研
                                                      （int4 / quant / gemv / GGUF / MoE）
    <pkg>/build/native_kernels/native_kernels.spec.json 52 自研
                                                      （Python 生成器产出的原生内核：
                                                       rmsnorm_fast_k / vt_scatter_v1_k /
                                                       flash_dec_part_k / gemv_f32_rows8_k…）

三份去重后就是包里的全部内核（v1.9.11 为 142 个，与包 README 一致）。项目里已经有的内核
**默认不覆盖**（避免用包里的版本盖掉项目自己的改动），只把缺的复制到
`kernels/asm/k_pkg/<name>.s`，并按项目 spec 的字段格式追加一条。

    python3 tools/sync_kernels.py [--pkg /home/t/桌面/K100LC-kernels] [--refresh] [--check]

`--refresh` 会顺带用包里的版本覆盖同名内核；`--check` 只报告差异，不写盘。
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import shutil
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
# spec 里要保留的字段（`asm` 由本脚本按项目内路径填；`code` 是包内的 .bin 路径，丢掉）
FIELDS = ["args", "kernarg_size", "kernarg_align", "sgpr_count", "vgpr_count",
          "group_segment", "private_segment"]
# 三组内核的清单。除 kernels/ 那组外，源 `.s` 都在对应 spec 的同级目录里。
PKG_SPECS = ["kernels/kernel_spec.json",
             "build/flashmoe_kernels/flashmoe.spec.json",
             "build/native_kernels/native_kernels.spec.json"]


def pkg_entries(pkg: pathlib.Path) -> list[tuple[str, dict, pathlib.Path]]:
    """返回 [(来源 spec 相对路径, spec 条目, .s 源文件)]。

    同一个内核名可能同时出现在多份清单里（flashmoe 与 native_kernels 有 31 个重名：
    gemv_f32_k / int4_dot_k / softmax_k…）。按 PKG_SPECS 的顺序**后者覆盖前者**，
    也就是以 `build/native_kernels/` 那份（生成器重新产出的版本）为准。
    """
    by_name: dict[str, tuple[str, dict, pathlib.Path]] = {}
    for rel in PKG_SPECS:
        spec = json.loads((pkg / rel).read_text(encoding="utf-8"))
        for e in spec:
            if rel.startswith("kernels/"):
                src = pkg / "kernels" / "asm" / e["asm"]
            else:
                src = pkg / rel.rsplit("/", 1)[0] / f"{e['name']}.s"
            by_name[e["name"]] = (rel, e, src)
    return list(by_name.values())


def entry_for(e: dict, asm_rel: str) -> dict:
    entry = {"name": e["name"]}
    for f in FIELDS:
        if f in e:
            entry[f] = e[f]
    entry["kernarg_align"] = e.get("kernarg_align", 8)
    entry["asm"] = asm_rel
    return entry


def base_name(sym: str) -> str:
    """mangled 名 → 内核基名（`_Z11split_qkv_kPfS_S_PKfiiii` → `split_qkv_k`）。"""
    m = re.match(r"^_Z(\d+)", sym)
    if not m:
        return sym
    st = 2 + len(m.group(1))
    return sym[st:st + int(m.group(1))]


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
    # 项目里已有同名内核时（包里的名字可能是 mangled 写法，如
    # `_Z11split_qkv_kPfS_S_PKfiiii`），两边只差 mangling 的话会在
    # tools/gen_nodtk.py 里撞成同一个源码写法，构建直接报「内核名撞车」。
    # 项目自己那份是模型在用的，遇到这种撞车就跳过包里的版本。
    have_base = {base_name(n) for n in have}

    added, refreshed, skipped, missing, collided = [], [], [], [], []
    for rel, e, src in pkg_entries(args.pkg):
        name = e["name"]
        if not src.is_file():
            missing.append((name, str(src)))
            continue
        if name in have and not args.refresh:
            skipped.append(name)
            continue
        if name not in have and name in have_base:
            collided.append(name)
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
    if collided:
        print(f"  跳过 {len(collided)} 个与项目内 mangled 内核同名的版本："
              + ", ".join(collided))
    if missing:
        for n, p in missing:
            print(f"  !! 缺源文件 {n}: {p}", file=sys.stderr)
        return 1
    print(f"-> {spec_path}: {len(src_spec)} 个内核")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
