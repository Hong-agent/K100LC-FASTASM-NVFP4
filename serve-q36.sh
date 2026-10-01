#!/bin/bash
# 启动 Qwen3.6-35B-A3B（Q8_0 GGUF）网页控制台 + OpenAI 兼容接口。
#
#   bash serve-q36.sh                 # http://<本机IP>/
#   PORT=8081 bash serve-q36.sh
#   bash serve-q36.sh --stop
#
# 与 27B 那条路径共用同一个引擎二进制（build/rt 会按 .gguf 后缀切到 MoE 实现），
# 只是把模型换成 GGUF、并把 MTF/视觉暂时关掉。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 注意：要在 source env.sh 之前覆盖（env.sh 用 :- 只会填默认值）
export RT_MODEL_DIR="$HERE/models/Qwen3.6-35B-A3B"
export RT_RT4="$HERE/models/Qwen3.6-35B-A3B-q8/Qwen3.6-35B-A3B-Q8_0.gguf"
export RT_RT4_JSON="$RT_RT4.json"                     # 引擎不读，仅满足入口检查
export RT_SERVE_TAG="-q36"
export RT_VISION_DEVICE="${RT_VISION_DEVICE:-gpu}"
export RT_VISION_RT4="$HERE/models/Qwen3.6-35B-A3B/qwen36_vision.rt4"
export RT_VISION_OUT_H="${RT_VISION_OUT_H:-2048}"     # Qwen3.6 的视觉投影维度                            # 独立 pid/log，可与 27B 服务并存
source "$HERE/scripts/env.sh"

export RT_NVFP4=0 RT_RP4=0 RT_INT4_NATIVE=0
export RT_NO_MTP=1
export RT_SERVED_NAME="${RT_SERVED_NAME:-qwen36-35b-a3b-q8}"
# 默认生成上限（Q8 内核下单 token ~0.45s；40960 会让一次请求占住引擎几小时）
export RT_DEFAULT_MAX_TOKENS="${RT_DEFAULT_MAX_TOKENS:-1024}"
export PORT="${PORT:-80}"
exec bash "$HERE/serve.sh" "$@"
