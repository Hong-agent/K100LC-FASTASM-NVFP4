#!/usr/bin/env python3
"""新高效内核 rmsnorm_fast_k 与旧 rmsnorm_k 的逐元素对账。

引擎侧 src/k_new.hip 的 k_rmsnorm 在 `D % 64 == 0` 时改走
K100LC-kernels v1.9.10 的 `rmsnorm_fast_k`（load 4 个一批发）；零中心权重
（y = x̂*(1+w)）先被改写成 `w' = 1 + w` 再喂给它。这个测试直接从我方 HSACO
启动两颗内核，验证这套改写**数值一致**（非零中心 / 零中心两条路都覆盖）。

    python3 tests/test_rmsnorm_fast.py
"""

from __future__ import annotations

import math
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "tools"))
from hsa_common import rnd  # noqa: E402
from hsa_job import run_job  # noqa: E402

HSACO = ROOT / "build/k100lc_all.hsaco"
OLD = "_Z9rmsnorm_kPfPKfS1_ifi"          # 旧内核（HIP 版汇编）
NEW = "rmsnorm_fast_k"                   # 新内核（K100LC-kernels 生成器产出）
DIMS = (64, 128, 256, 320, 512, 5120)
ROWS = 3
EPS = 1e-6


def ref_rmsnorm(x: list[float], w: list[float], D: int, zc: bool) -> list[float]:
    out = []
    for r in range(len(x) // D):
        row = x[r * D:(r + 1) * D]
        ms = sum(float(v) * float(v) for v in row) / D
        inv = 1.0 / math.sqrt(ms + EPS)
        for i, v in enumerate(row):
            ww = (1.0 + w[i]) if zc else w[i]
            out.append(v * inv * ww)
    return out


def launch(kernel: str, x: list[float], w: list[float], D: int, zc: int, block: int):
    return run_job(
        HSACO, kernel,
        [{"buffer": "y"}, {"buffer": "x"}, {"buffer": "w"},
         {"scalar": {"dtype": "i32", "value": D}},
         {"scalar": {"dtype": "f32", "value": EPS}},
         *([{"scalar": {"dtype": "i32", "value": zc}}] if kernel == OLD else [])],
        {"y": {"dtype": "f32", "values": [0.0] * (ROWS * D)},
         "x": {"dtype": "f32", "values": x},
         "w": {"dtype": "f32", "values": w}},
        # 这颗 harness 的 grid 是**总 work-item 数**（HSA 的 grid_size_x），
        # 一颗内核一个 workgroup 处理一行 → grid = rows × workgroup。
        grid=ROWS * block, workgroup=block,
    )["y"]


def main() -> int:
    if not HSACO.exists():
        print(f"跳过：没有 {HSACO}（先跑 bash build.sh）")
        return 0
    worst = 0.0
    bad = 0
    for D in DIMS:
        n = ROWS * D
        x = rnd(n, seed=1000 + D, lo=-3.0, hi=3.0)
        w = rnd(D, seed=2000 + D, lo=-1.5, hi=1.5)
        for zc in (0, 1):
            if zc:
                w1 = [1.0 + v for v in w]
                got_new = launch(NEW, x, w1, D, 0, 64)
            else:
                got_new = launch(NEW, x, w, D, 0, 64)
            got_old = launch(OLD, x, w, D, zc, 256 if D >= 256 else 64)
            want = ref_rmsnorm(x, w, D, bool(zc))
            d_kernels = max(abs(a - b) for a, b in zip(got_new, got_old))
            d_ref = max(abs(a - b) for a, b in zip(got_new, want))
            worst = max(worst, d_kernels, d_ref)
            ok = d_kernels < 1e-5 and d_ref < 1e-5
            bad += 0 if ok else 1
            print(f"  D={D:<5} zc={zc}  新旧最大差 {d_kernels:.2e}  "
                  f"对 numpy 最大差 {d_ref:.2e}  {'OK' if ok else 'FAIL'}")
    print(f"rmsnorm_fast_k: 最大误差 {worst:.2e}，失败 {bad} 项")
    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
