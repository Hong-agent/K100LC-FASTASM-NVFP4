#!/bin/bash
# 命令行对话（引擎 + 分词 + chat 模板，等价于网页走的同一条链路）。
# **默认模型 = Qwen3.8-27B-INT4**（RT_MODEL_DIR / RT_RT4 可覆盖，见 scripts/env.sh）。
#
#   bash run.sh --prompt "你好" --n 64
#   bash run.sh --ids 104177,104110,3837,374 --n 16 --raw   # 不依赖 tokenizer
#   bash run.sh --engine-info                               # 只打印引擎启动信息
#
# 换成 NVFP4 checkpoint（opt-in）：RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 bash run.sh ...
#
# 所有参数原样转给 scripts/chat.py。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/scripts/env.sh"
cd "$RT_ROOT"

if [ ! -x "$RT_ENGINE_BIN" ]; then
  echo "缺少引擎 $RT_ENGINE_BIN，先跑：bash build.sh" >&2
  exit 1
fi

export PYTHONPATH="$RT_PY_DEPS${PYTHONPATH:+:$PYTHONPATH}"
exec "$RT_PYTHON" scripts/chat.py "$@"
