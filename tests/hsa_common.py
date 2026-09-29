#!/usr/bin/env python3
"""测试公用：自研 HSACO 路径与确定性伪随机数（不需要 DTK 产物）。"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ALL_HSACO = ROOT / "build/k100lc_all.hsaco"


def rnd(count: int, seed: int, lo: float = -2.0, hi: float = 2.0) -> list[float]:
    state, out = seed, []
    for _ in range(count):
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        out.append(lo + (hi - lo) * (state / 0x7FFFFFFF))
    return out


def rnd_int(count: int, seed: int, lo: int = 0, hi: int = 2 ** 31 - 1) -> list[int]:
    span = hi - lo + 1
    state, out = seed, []
    for _ in range(count):
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        out.append(lo + state % span)
    return out
