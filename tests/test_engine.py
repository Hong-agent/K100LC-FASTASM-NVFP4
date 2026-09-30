#!/usr/bin/env python3
"""引擎冒烟测试：用固定 token id 跑一次贪心解码，检查能出 token、结果可复现。

    python3 tests/test_engine.py            # 需要 build/rt 与已接好的权重

不依赖 tokenizer、不依赖网络：直接走引擎的 stdin 协议
（PREFILL <ids> / GEN <n> <temp> <top_p> <top_k> <seed>）。
"""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ENGINE = os.environ.get("RT_ENGINE_BIN", str(ROOT / "build" / "rt"))
MODEL = os.environ.get("RT_RT4", str(ROOT / "models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4"))
PROMPT = [104177, 104110, 3837, 374]


def decode(n: int = 16) -> list[int]:
    p = subprocess.Popen([ENGINE, "--engine", "--model", MODEL, "--json", MODEL + ".json",
                          "--ctx", "8192"],
                         stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True, bufsize=1)
    while True:
        line = p.stdout.readline()
        if not line:
            raise SystemExit("引擎启动失败")
        if line.startswith("READY"):
            break
    p.stdin.write("PREFILL " + ",".join(map(str, PROMPT)) + "\n")
    p.stdin.flush()
    p.stdout.readline()                     # PREFILL 完成行
    p.stdin.write(f"GEN {n} 0 1.0 0 1234\n")  # 贪心（temp=0）
    p.stdin.flush()
    out = []
    while True:
        line = p.stdout.readline()
        if line.startswith("TOK "):
            out.append(int(line[4:]))
        elif line.startswith("END "):
            break
        elif not line:
            raise SystemExit("引擎中途退出")
    p.stdin.write("QUIT\n")
    p.wait(timeout=300)
    return out


def main() -> int:
    if not os.path.exists(ENGINE):
        print(f"跳过：没有引擎 {ENGINE}（先跑 bash build.sh）")
        return 0
    rp4 = os.environ.get("RT_RP4") or str(ROOT / "models/Qwen3.8-27B-INT4/model.rp4")
    if not Path(MODEL).exists() and not Path(rp4).exists():
        print("跳过：没有接好权重（先跑 bash scripts/setup_models.sh）")
        return 0

    a = decode()
    b = decode()
    print(f"tokens: {a}")
    if not a:
        print("FAIL：没有产出 token")
        return 1
    if a != b:
        print("FAIL：同 seed 两次贪心结果不一致")
        return 1
    print(f"engine ok: {len(a)} tokens, 可复现")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
