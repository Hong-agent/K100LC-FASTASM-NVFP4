#!/bin/bash
# 重新生成项目根目录的 SHA256SUMS.txt（源码树校验清单）。
#
#   bash scripts/make_sha256sums.sh
#
# 收录：源码、内核 .s、网页、工具、测试、文档、预编译引擎、驱动安装包与快照、
#       自带的 Python 运行库（runtime/python、runtime/py）。
# 不收录：权重（models/Qwen3.8-27B-NVFP4）、编译产物 build/、离线包 dist/、
#         会话工作区 workspaces/、明文口令 .askpass.sh、__pycache__。
# 解压源码包后可以这样校验：sha256sum -c SHA256SUMS.txt --ignore-missing
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

find . \
  -path ./build -prune -o \
  -path ./dist -prune -o \
  -path ./workspaces -prune -o \
  -path ./models/Qwen3.8-27B-NVFP4 -prune -o \
  -name '__pycache__' -prune -o \
  -name '*.pyc' -prune -o \
  -name '.askpass.sh' -prune -o \
  -name 'SHA256SUMS.txt' -prune -o \
  -type f -printf '%P\0' | LC_ALL=C sort -z | xargs -0 sha256sum > SHA256SUMS.txt

wc -l SHA256SUMS.txt
echo "已生成 $ROOT/SHA256SUMS.txt"
