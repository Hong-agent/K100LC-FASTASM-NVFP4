#!/usr/bin/env python3
"""多维 grid 派发回归测试（AQL setup 维度字段）。

背景：HSA dispatch packet 的 `setup` 低 2 位是 **grid 维度数**（1/2/3）。
自研 HSA 运行时和 tools/hsa_job.py 一度把它写死成 1，于是 `grid_size_y/z`
被运行时合法地忽略，`workgroup_id_y` 恒为 0 —— 所有 2D/3D kernel 都只跑
y=0 平面。这个 bug 用 quant_act（grid=(K/GRP, rows)）做最小复现：
rows=3 时修复前只有 row 0 被写，row 1/2 保持初值。

  python3 tests/test_grid_dims.py
"""

from __future__ import annotations

import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tests"))
from hsa_job import run_job          # noqa: E402
from hsa_common import ALL_HSACO, rnd                     # noqa: E402


SENTINEL = -12345.0


def main() -> int:
    rows, K = 3, 128                      # K/GRP = 1 个 x-workgroup，rows 个 y-workgroup
    kernel = "_Z9quant_actPKfPaS1_PfPiii"
    case = {
        "kernel": kernel,
        "grid": (K // 128) * 32,          # 1 个 x block × 32 线程
        "grid_y": rows,
        "workgroup": 32,
        "args": [
            {"buffer": "a"}, {"buffer": "ae"}, {"buffer": "ao"},
            {"buffer": "asc"}, {"buffer": "asu"},
            {"scalar": {"dtype": "i32", "value": rows}},
            {"scalar": {"dtype": "i32", "value": K}},
        ],
        "buffers": {
            "a": {"dtype": "f32", "values": rnd(rows * K, 4242)},
            "ae": {"dtype": "i8", "values": [0] * (rows * K // 2)},
            "ao": {"dtype": "i8", "values": [0] * (rows * K // 2)},
            "asc": {"dtype": "f32", "values": [SENTINEL] * rows},
            "asu": {"dtype": "i32", "values": [int(SENTINEL)] * rows},
        },
    }
    kwargs = dict(kernel=kernel, args=case["args"], buffers=case["buffers"],
                  grid=case["grid"], workgroup=case["workgroup"], grid_y=rows)

    ours = run_job(ALL_HSACO, **kwargs)

    # 1) 每个 y 平面都必须真的被派发：3 行的 asc/asu 都不能还是初值。
    for name in ("asc", "asu"):
        vals = ours[name]
        if any(v == int(SENTINEL) if name == "asu" else v == SENTINEL for v in vals):
            print(f"FAIL: {name} 里有没被写到的行（2D grid 没有真正派发 y）：{vals}")
            return 1

    # 2) 逐行单独跑（grid_y=1）的结果，拼起来必须与一次性 3 行派发相同。
    #    这是不依赖任何 DTK 参照的自洽检查：y 维度没派发时第 2/3 行会留在初值。
    a_vals = case["buffers"]["a"]["values"]
    per_row = {"ae": [], "ao": [], "asc": [], "asu": []}
    for r in range(rows):
        row = {
            "kernel": kernel, "grid": case["grid"], "grid_y": 1,
            "workgroup": case["workgroup"],
            "args": case["args"],
            "buffers": {
                "a": {"dtype": "f32", "values": a_vals[r * K:(r + 1) * K]},
                "ae": {"dtype": "i8", "values": [0] * (K // 2)},
                "ao": {"dtype": "i8", "values": [0] * (K // 2)},
                "asc": {"dtype": "f32", "values": [SENTINEL]},
                "asu": {"dtype": "i32", "values": [int(SENTINEL)]},
            },
        }
        got = run_job(ALL_HSACO, **row)
        for name in per_row:
            per_row[name] += got[name]

    for name in ("ae", "ao", "asc", "asu"):
        if ours[name] != per_row[name]:
            print(f"FAIL: {name} 的 3 行派发结果与逐行派发不一致")
            print(f"      ours = {ours[name]}")
            print(f"      rows = {per_row[name]}")
            return 1

    print(f"grid dims ok: {rows} 个 y-workgroup 全部派发，且与逐行派发结果一致")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
