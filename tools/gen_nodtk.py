#!/usr/bin/env python3
"""生成「无 DTK」构建需要的两样东西：

1. `build/nodtk/nodtk_kernels.h` —— 内核参数表：每个 kernel 的 mangled 名、
   源码里的写法（查表用）、每个显式参数的 (offset, size)、隐藏参数类型、
   kernarg/group/private 段大小。**全部从自研 HSACO 自己的 metadata 读出来**。

2. `build/nodtk/*.cpp` —— 把 RT4 的 `src/*.hip`（以及 `prefetch.h`）改写成
   纯 host 代码：剥掉设备函数、把 `kernel<<<g,b[,smem]>>>(args)` 换成
   `hsart_launch("kernel", g, b, smem, 0, args)`。这样它们就能用 g++ 编译，
   内核交给自研汇编器产出的 HSACO 执行。

用法：python3 tools/gen_nodtk.py [--root .] [--hsaco build/k100lc_all.hsaco]

合并后的项目里 `src/`（模型与内核启动代码）、`kernels/rt4`、`kernels/nvfp4`、
`include/nvfp4` 都在本仓库内，默认 `--root .` 即可，不再依赖 K100LC-RT4。
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "tools"))
from amdgpu_meta import read_metadata  # noqa: E402


HID = {
    "hidden_block_count_x": 1, "hidden_block_count_y": 2, "hidden_block_count_z": 3,
    "hidden_group_size_x": 4, "hidden_group_size_y": 5, "hidden_group_size_z": 6,
    "hidden_remainder_x": 7, "hidden_remainder_y": 8, "hidden_remainder_z": 9,
    "hidden_global_offset_x": 10, "hidden_global_offset_y": 11,
    "hidden_global_offset_z": 12, "hidden_grid_dims": 13,
}

# 需要改写的文件：RT4 的运行时源码（.hip 里既有设备函数也有 host 包装）
SOURCES = ["k_new.hip", "k_fa.hip", "k_gemv.hip", "k_gemm.hip", "k_vision.hip",
           "k_nvfp4.hip", "model.cpp", "prefetch.h"]

# 设备头文件：里面既有常量/macro（host 侧也要用），也有设备函数。剥掉设备部分，
# 保留常量，输出到 build/nodtk/kernels/，include 路径同时改写过去。
# 合并后的项目里这些头都在本目录下：kernels/rt4（内核共用常量）、kernels/nvfp4
# （NVFP4 内核）与 include/nvfp4（NVFP4 解码原语）。
def device_headers(root: Path) -> list:
    return [
        (root / "kernels/kv_pack.h", "kv_pack.h"),
        (root / "kernels/flash_attn_core.h", "flash_attn_core.h"),
        (root / "kernels/gemv_w4a4_core.h", "gemv_w4a4_core.h"),
        (root / "kernels/gemv_w4a8_core.h", "gemv_w4a8_core.h"),
        (root / "kernels/gemm_core.h", "gemm_core.h"),
        (root / "kernels/nvfp4/nvfp4_gemv_kernel.h", "nvfp4_gemv_kernel.h"),
        (root / "kernels/nvfp4/nvfp4_gemm_kernel.h", "nvfp4_gemm_kernel.h"),
        (root / "include/nvfp4/nvfp4_decode.h", "nvfp4_decode.h"),
    ]


def demangled_base(symbol: str) -> str:
    """mangled 名 → 源码里的写法（如 gemv_w4a8<1, true, 1>）。"""
    out = subprocess.run(["c++filt", symbol], capture_output=True, text=True, check=True).stdout.strip()
    m = re.match(r"^_Z(\d+)", symbol)
    if not m:
        return out
    start = 2 + len(m.group(1))                    # _Z<十进制长度><名字>，长度从下标 2 开始
    base = symbol[start:start + int(m.group(1))]
    i = out.find(base)
    if i < 0:
        return base
    j = i + len(base)
    if j < len(out) and out[j] == "<":            # 模板实参
        depth, k = 0, j
        while k < len(out):
            if out[k] == "<":
                depth += 1
            elif out[k] == ">":
                depth -= 1
                if depth == 0:
                    k += 1
                    break
            k += 1
        return out[i:k]
    return out[i:j]


def norm(s: str) -> str:
    return re.sub(r"\s+", "", s)


def split_template(expr: str):
    """'foo<1, bar>' → ('foo', ['1', 'bar'])；没有模板实参返回 (expr, None)。"""
    i = expr.find("<")
    if i < 0 or not expr.endswith(">"):
        return expr, None
    return expr[:i], split_top(expr[i + 1:-1])


def is_literal(arg: str) -> bool:
    return bool(re.fullmatch(r"-?\d+", arg) or arg in ("true", "false"))


def build_table(hsaco: Path) -> tuple[str, dict]:
    meta = read_metadata(hsaco.read_bytes())
    kernels = meta.get("amdhsa.kernels", [])
    entries, by_lookup = [], {}
    for k in sorted(kernels, key=lambda x: x[".name"]):
        args = []
        for a in k.get(".args", []):
            vk = str(a.get(".value_kind", "by_value"))
            kind = 0 if vk in ("by_value", "global_buffer") else HID.get(vk)
            if kind is None:
                raise SystemExit(f"{k['.name']}: 不认识的参数类型 {vk}")
            args.append((int(a[".offset"]), int(a[".size"]), kind))
        name = k[".name"]
        lookup = norm(demangled_base(name))
        if lookup in by_lookup:
            raise SystemExit(f"内核名撞车：{lookup}（{name} 与 {by_lookup[lookup]}）")
        idx = len(entries)
        by_lookup[lookup] = name
        entries.append({
            "name": name, "lookup": lookup, "args": args,
            "kernarg_size": int(k.get(".kernarg_segment_size", 0)),
            "group_size": int(k.get(".group_segment_fixed_size", 0)),
            "private_size": int(k.get(".private_segment_fixed_size", 0)),
        })
    lines = ["// 自动生成：tools/gen_nodtk.py（数据来自自研 HSACO 的 metadata）",
             "#pragma once", "#include <cstdint>", "",
             "#define MAX_KERNARG 1024",
             "struct RtArg { uint32_t off; uint32_t size; uint8_t kind; };",
             "struct RtKernel {",
             "    const char* name;      // mangled 名（HSACO 里的符号）",
             "    const char* lookup;    // 源码里的写法（已去掉空白）",
             "    uint32_t nargs;        // 参数个数（含隐藏）",
             "    const RtArg* args;",
             "    uint32_t kernarg_size, group_size, private_size;",
             "};", ""]
    for i, e in enumerate(entries):
        lines.append(f"static const RtArg k_args_{i}[] = {{")
        for (off, size, kind) in e["args"]:
            lines.append(f"    {{{off}u, {size}u, {kind}}},   // {'by_value/global' if kind == 0 else [n for n, v in HID.items() if v == kind][0]}")
        lines.append("};")
    lines.append("")
    lines.append("static const RtKernel k_table[] = {")
    for i, e in enumerate(entries):
        lines.append(f'    {{"{e["name"]}", "{e["lookup"]}", {len(e["args"])}u, k_args_{i}, '
                     f'{e["kernarg_size"]}u, {e["group_size"]}u, {e["private_size"]}u}},')
    lines.append("};")
    lines.append(f"static const int k_table_n = {len(entries)};")
    return "\n".join(lines) + "\n", by_lookup


def strip_device_code(text: str, path: str) -> str:
    """删掉 __global__ / __device__ 的定义（含它们的 template<> 头）。"""
    out, lines, i = [], text.split("\n"), 0
    dev_re = re.compile(r"^\s*(?:static\s+)?(?:inline\s+)?(?:__global__|__device__|__constant__)\b")
    tmpl_re = re.compile(r"^\s*template\s*<")
    while i < len(lines):
        line = lines[i]
        pick = i
        if dev_re.match(line):
            start = i
        elif tmpl_re.match(line) and i + 1 < len(lines) and dev_re.match(lines[i + 1]):
            start = i
        else:
            out.append(line)
            i += 1
            continue
        # 从 start 往后找第一个 '{' 或 ';'（可能在后面几行的函数签名里）
        j, depth, brace = start, 0, None
        while j < len(lines):
            for ch in lines[j]:
                if ch == "{":
                    brace = "{" if brace is None else brace
                    depth += 1
                elif ch == "}":
                    depth -= 1
                elif ch == ";" and depth == 0:
                    brace = ";"
                    break
            if brace == ";" or depth == 0 and brace == "{":
                break
            j += 1
        if j >= len(lines):
            raise SystemExit(f"{path}: 设备代码块没找到结尾（第 {start + 1} 行起）")
        out.append(f"// [nodtk] 略过设备函数：{lines[start].strip()[:70]} …（第 {start + 1}-{j + 1} 行）")
        i = j + 1
    return "\n".join(out)


def split_top(s: str) -> list[str]:
    """按顶层逗号切分（忽略括号内的逗号）。"""
    parts, depth, cur = [], 0, ""
    for ch in s:
        if ch in "([{":
            depth += 1
        elif ch in ")]}":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())
    return parts


def rewrite_launches(text: str, path: str, by_lookup: dict) -> tuple[str, set]:
    """kernel<<<cfg>>>(args) → hsart_launch("kernel", cfg…, 0, args)。"""
    used, out, pos = set(), [], 0
    while True:
        m = re.search(r"<<<", text[pos:])
        if not m:
            out.append(text[pos:])
            break
        kstart = pos + m.start()
        # 往前取内核表达式：<标识符>（可选 <模板实参>，可能嵌套）
        e = kstart
        while e > 0 and text[e - 1] in " \t":
            e -= 1
        end = e
        if e > 0 and text[e - 1] == ">":
            depth, j = 0, e
            while j > 0:
                j -= 1
                if text[j] == ">":
                    depth += 1
                elif text[j] == "<":
                    depth -= 1
                    if depth == 0:
                        break
            e = j
        s = e
        while s > 0 and (text[s - 1].isalnum() or text[s - 1] == "_"):
            s -= 1
        expr = text[s:end]
        if not expr:
            raise SystemExit(f"{path}: 找不到 <<< 前面的内核名")
        # 配置段：<<< ... >>>
        i = kstart + 3
        depth, j = 0, i
        while j < len(text):
            ch = text[j]
            if ch in "([{":
                depth += 1
            elif ch in ")]}":
                depth -= 1
            elif depth == 0 and text[j:j + 3] == ">>>":
                break
            j += 1
        cfg = split_top(text[i:j])
        # 参数段：( ... )
        k = j + 3
        while k < len(text) and text[k] in " \t\n\r":
            k += 1
        if k >= len(text) or text[k] != "(":
            raise SystemExit(f"{path}: <<<>>> 后面不是参数表")
        depth, j2 = 0, k
        while j2 < len(text):
            ch = text[j2]
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    break
            j2 += 1
        args = text[k + 1:j2]
        smem = cfg[2] if len(cfg) > 2 else "0"
        if len(cfg) > 4:
            raise SystemExit(f"{path}: <<<>>> 里超过 4 个字段：{' '.join(cfg)}")
        name = norm(expr)
        runtime_name = None
        if name not in by_lookup:
            base, targs = split_template(name)
            cand = [k for k in by_lookup if k.startswith(base + "<")] if targs is not None else []
            if targs is None and base in by_lookup:
                name = base                     # 不带模板实参的普通内核
            elif targs is not None and all(is_literal(t) for t in targs) and len(cand) == 1:
                name = cand[0]                  # 实参是宏/表达式，但整表里只有一种形状
            elif targs is not None:
                # 实参里带运行期变量（宏里的 CASE(NR)、M 等）：运行期拼名字再查表。
                fmt, vals = [], []
                for t in targs:
                    if is_literal(t):
                        fmt.append(t)
                    else:
                        fmt.append("%d")
                        vals.append(f"(int)({t})")
                runtime_name = (base + "<" + ", ".join(fmt) + ">", vals)
            else:
                raise SystemExit(f"{path}: 内核 {expr} 在自研 HSACO 的表里找不到")
        out.append(text[pos:s])
        tail = (f", {cfg[0]}, {cfg[1]}, {smem}, 0"
                + (", " + args if args.strip() else "") + ")")
        nxt = j2 + 1                                   # 吃掉源码里语句末尾的 ';'，
        while nxt < len(text) and text[nxt] in " \t\r\n":   # 否则块语句后面会多一个 ';'
            nxt += 1                                        # 把 if(...){} / else 拆坏
        semi = ""
        if nxt < len(text) and text[nxt] == ";":
            semi = ";"
            nxt += 1
        if runtime_name is None:
            used.add(name)
            out.append(f'hsart_launch("{name}"{tail}{semi}')
        else:
            fmt, vals = runtime_name
            used.add("_runtime_:" + fmt)         # 运行期拼名字，静态只记一下格式串
            out.append('{ char _nm[96]; snprintf(_nm, sizeof(_nm), "' + fmt + '"'
                       + ("".join(", " + v for v in vals)) + '); '
                       + f'hsart_launch(_nm{tail}; }}')
        pos = nxt
    return "".join(out), used


def fix_includes(line: str) -> str:
    """把设备头/hip 头替换成无 DTK 版本，路径摊平到 build/nodtk/。"""
    if "#include <hip/hip_runtime.h>" in line:
        return '#include "hsa_rt.h"        // [nodtk] 自研 HSA 垫片'
    if "#include <hip/hip_fp16.h>" in line:
        return "// [nodtk] 略过 <hip/hip_fp16.h>（__half 由 hsa_rt.h 提供）"
    m = re.match(r'^(\s*)#include\s+"(\.\./(?:kernels|include/nvfp4)/[^"]+|nvfp4_[a-z_]+\.h)"', line)
    if m:
        name = m.group(2).split("/")[-1]
        return f'{m.group(1)}#include "kernels/{name}"'
    return line


def transform(text: str, path: str, by_lookup: dict) -> tuple[str, set]:
    lines = []
    lines.append('// [nodtk] 自动生成（tools/gen_nodtk.py）：设备代码已剥离，内核走自研 HSACO')
    lines.append('#include "hsa_rt.h"')
    for line in text.split("\n"):
        lines.append(fix_includes(line))
    text = strip_device_code("\n".join(lines), path)
    return rewrite_launches(text, path, by_lookup)


def transform_header(text: str, path: str, out_dir: Path, name: str, by_lookup: dict) -> None:
    lines = [fix_includes(line) for line in text.split("\n")]
    stripped = strip_device_code("\n".join(lines), path)
    stripped, _used = rewrite_launches(stripped, path, by_lookup)
    (out_dir / name).write_text(stripped, encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(ROOT))
    ap.add_argument("--hsaco", default=str(ROOT / "build/k100lc_all.hsaco"))
    ap.add_argument("--out", default=str(ROOT / "build/nodtk"))
    args = ap.parse_args()
    root, out = Path(args.root), Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    table, by_lookup = build_table(Path(args.hsaco))
    (out / "nodtk_kernels.h").write_text(table, encoding="utf-8")
    print(f"[gen_nodtk] 内核表：{len(by_lookup)} 个 kernel（来自 {args.hsaco}）")

    hdir = out / "kernels"
    hdir.mkdir(parents=True, exist_ok=True)
    for src, name in device_headers(root):
        if not src.exists():
            print(f"[gen_nodtk] 缺设备头 {src}")
            return 1
        transform_header(src.read_text(encoding="utf-8"), str(src), hdir, name, by_lookup)
    print(f"[gen_nodtk] 设备头 {len(device_headers(root))} 个 → build/nodtk/kernels/（只留常量）")

    all_used = set()
    for name in SOURCES:
        src = root / "src" / name
        text, used = transform(src.read_text(encoding="utf-8"), name, by_lookup)
        out_name = name[:-4] + ".cpp" if name.endswith(".hip") else name   # .hip → .cpp
        (out / out_name).write_text(text, encoding="utf-8")
        all_used |= used
        print(f"[gen_nodtk] {name} → {out_name}: 改写 {len(used)} 个不同的内核启动")
    missing = sorted(x for x in all_used if not x.startswith("_runtime_:") and x not in by_lookup)
    if missing:
        print("[gen_nodtk] 这些启动在内核表里找不到（HSACO 缺符号）：")
        for x in missing:
            print("   ", x)
        return 1
    print(f"[gen_nodtk] 用到的内核 {len(all_used)} 个，全部在自研 HSACO 里 ✓")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
