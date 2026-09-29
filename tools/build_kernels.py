#!/usr/bin/env python3
"""把自研汇编器产出的内核源码汇编成机器码，并生成 HSACO 用的 kernel 清单。

输入：
  kernels/kernel_spec.json     每个内核的元数据（参数表、kernarg/段大小、SGPR/VGPR 计数…）
                               + 对应的 .s 源文件（相对 kernels/asm/）
  kernels/asm/**/*.s           自研汇编器语法（asm.py）的内核源码

输出：
  build/kernels/<mangled>.bin  逐内核机器码（asm.py 汇编）
  build/all_kernels_spec.json  给 tools/make_hsaco_multi.py 用的清单（code 指向 .bin）

全程只需要 Python（asm.py 是纯 Python 自研汇编器）。DTK / llvm-mc / hipcc 都不参与。
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from concurrent.futures import ProcessPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import asm  # noqa: E402


def _assemble_one(job: tuple[dict, str]) -> tuple[dict, bytes]:
    """worker：汇编单个内核，返回 (spec 条目, 机器码)。"""
    item, asm_dir = job
    src = Path(asm_dir) / item["asm"]
    code, _insts, _labels = asm.assemble(src)
    return item, code


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec", default=str(ROOT / "kernels/kernel_spec.json"))
    ap.add_argument("--asm-dir", default=str(ROOT / "kernels/asm"))
    ap.add_argument("--out-dir", default=str(ROOT / "build"))
    ap.add_argument("--check-against", default="",
                    help="可选：把汇编结果与这个目录下同名 .bin 逐字节比较（验收用）")
    ap.add_argument("--jobs", type=int, default=min(8, os.cpu_count() or 1),
                    help="并行汇编进程数（1 = 串行回退，默认 min(8, CPU 数)）")
    args = ap.parse_args()

    spec = json.loads(Path(args.spec).read_text(encoding="utf-8"))
    asm_dir = Path(args.asm_dir)
    out = Path(args.out_dir)
    kdir = out / "kernels"
    kdir.mkdir(parents=True, exist_ok=True)
    ref_dir = Path(args.check_against) if args.check_against else None

    jobs = []
    for item in spec:
        src = asm_dir / item["asm"]
        if not src.is_file():
            raise SystemExit(f"缺少内核源码 {src}")
        jobs.append((item, str(asm_dir)))

    # 并行前先在主进程预热编码表缓存：Linux fork 模式下 worker 直接继承，
    # 每个 worker 都不用再解析一遍 encodings.json。
    if args.jobs != 1:
        asm.load_entries()
        with ProcessPoolExecutor(max_workers=args.jobs) as ex:
            results = list(ex.map(_assemble_one, jobs))
    else:
        results = [_assemble_one(j) for j in jobs]

    entries, total, checked, mismatch = [], 0, 0, []
    for item, code in results:
        dst = kdir / (item["name"] + ".bin")
        dst.write_bytes(code)
        total += len(code)

        if ref_dir is not None:
            ref = ref_dir / (item["name"] + ".bin")
            if ref.is_file():
                checked += 1
                if ref.read_bytes() != code:
                    mismatch.append(item["name"])

        e = {k: v for k, v in item.items() if k != "asm"}
        e["code"] = str(dst)
        entries.append(e)

    (out / "all_kernels_spec.json").write_text(
        json.dumps(entries, indent=1, ensure_ascii=False), encoding="utf-8")

    print(f"[build_kernels] 汇编 {len(entries)} 个内核（jobs={args.jobs}），共 {total} 字节 → {kdir}")
    print(f"[build_kernels] 清单 → {out / 'all_kernels_spec.json'}")
    if ref_dir is not None:
        print(f"[build_kernels] 与参考逐字节比较：{checked - len(mismatch)}/{checked} 一致")
        for n in mismatch:
            print(f"   differ: {n}")
        if mismatch:
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
