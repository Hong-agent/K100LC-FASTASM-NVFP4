#!/bin/bash
# 纯主机编译（不需要 GPU）：验证 C++ GGUF 解析与 Python 清单一致。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
g++ -O2 -std=c++17 -I "$ROOT/src" "$ROOT/tests/gguf_read_test.cpp" "$ROOT/src/gguf.cpp" \
    -o "${1:-/tmp/gguf_test}"
echo "已编译 ${1:-/tmp/gguf_test}"
