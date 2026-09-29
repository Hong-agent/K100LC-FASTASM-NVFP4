#!/usr/bin/env python3
"""Regression tests for the standalone gfx926 assembler."""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


CASES = [
    ("examples/basic.s", "tests/expected/basic.bin"),
    ("examples/consts.s", "tests/expected/consts.bin"),
    ("examples/fill_k.s", "tests/expected/fill_k.bin"),
]


def main() -> int:
    failures = 0
    for src, expected in CASES:
        with tempfile.NamedTemporaryFile(suffix=".bin") as tmp:
            proc = subprocess.run(
                [sys.executable, str(ROOT / "asm.py"), str(ROOT / src), "-o", tmp.name],
                capture_output=True,
                text=True,
            )
            if proc.returncode != 0:
                print(f"FAIL {src}: assembler exited {proc.returncode}")
                print(proc.stderr)
                failures += 1
                continue
            got = Path(tmp.name).read_bytes()
            want = (ROOT / expected).read_bytes()
            if got != want:
                print(f"FAIL {src}: got {len(got)} bytes, want {len(want)} bytes")
                failures += 1
            else:
                print(f"ok   {src}: {len(got)} bytes")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
