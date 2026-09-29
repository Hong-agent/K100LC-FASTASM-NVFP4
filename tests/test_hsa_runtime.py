#!/usr/bin/env python3
"""Dispatch real model kernels from our own HSACO via the minimal HSA runner."""

from __future__ import annotations

import math
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "tools"))
from hsa_job import run_job  # noqa: E402


N = 64
HSACO = ROOT / "build/k100lc_all.hsaco"


def close(a: float, b: float, tol: float = 5e-3) -> bool:
    return abs(a - b) <= tol * max(1.0, abs(b))


def main() -> int:
    if not HSACO.exists():
        print(f"missing {HSACO}; run tools/extract_kernel_spec.py + make_hsaco_multi.py")
        return 1

    y = [1.5] * N
    x = [2.25] * N
    out = run_job(
        HSACO, "_Z13add_inplace_kPfPKfx",
        [{"buffer": "y"}, {"buffer": "x"}, {"scalar": {"dtype": "i64", "value": N}}],
        {"y": {"dtype": "f32", "values": y}, "x": {"dtype": "f32", "values": x}},
    )
    bad = sum(1 for got, exp in zip(out["y"], [a + b for a, b in zip(y, x)]) if not close(got, exp))
    print(f"add_inplace_k: y[0]={out['y'][0]:.4f} expect=3.7500 bad={bad}")
    if bad:
        return 1

    g = [0.5] * N
    u = [2.0] * N
    out = run_job(
        HSACO, "_Z10silu_mul_kPfPKfS1_x",
        [{"buffer": "y"}, {"buffer": "g"}, {"buffer": "u"},
         {"scalar": {"dtype": "i64", "value": N}}],
        {"y": {"dtype": "f32", "values": [0.0] * N},
         "g": {"dtype": "f32", "values": g}, "u": {"dtype": "f32", "values": u}},
    )
    expect = [(v / (1.0 + math.exp(-v))) * w for v, w in zip(g, u)]
    bad = sum(1 for got, exp in zip(out["y"], expect) if not close(got, exp))
    print(f"silu_mul_k: y[0]={out['y'][0]:.4f} expect={expect[0]:.4f} bad={bad}")
    if bad:
        return 1

    print("hsa runtime ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
