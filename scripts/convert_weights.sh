#!/bin/bash
# 把原始 safetensors 转成本项目运行时要用的 RT4 权重（**不需要 DTK，不需要 Docker**）。
#
#   bash scripts/convert_weights.sh            # 缺什么补什么（幂等）
#   bash scripts/convert_weights.sh --check    # 只校验已有产物
#
# 转换器是自研的 tools/convert.c（主机 gcc 编译）与 tools/convert_vision_rt4.py（纯 numpy）。
# 源权重默认取桌面上那一份；用 MODEL_SRC= 可以换。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

SRC="${MODEL_SRC:-$ROOT/models/Qwen3.8-27B-NVFP4}"
OUT="$RT_MODEL_DIR/rt4"
CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

[ -r "$SRC/model.safetensors" ] || {
  echo "找不到源权重 $SRC/model.safetensors（用 MODEL_SRC= 指定）" >&2; exit 1; }
mkdir -p "$OUT"

need() { [ -s "$OUT/$1" ]; }

if [ "$CHECK_ONLY" = 0 ]; then
  gcc -O2 -o "$OUT/convert" "$ROOT/tools/convert.c" -lm
  if ! need qwen38_27b.rt4; then
    echo "== 转换主模型（约 4~5 分钟）=="
    ( cd "$SRC" && "$OUT/convert" model.safetensors "$OUT/qwen38_27b.rt4" )
  fi
  if ! need qwen38_27b_mtp.rt4; then
    echo "== 转换 MTP 头 =="
    ( cd "$SRC" && "$OUT/convert" model_mtp.safetensors "$OUT/qwen38_27b_mtp.rt4" )
  fi
  if ! need qwen38_27b_vision.rt4; then
    echo "== 转换视觉塔 =="
    python3 "$ROOT/tools/convert_vision_rt4.py" \
      "$SRC/model.safetensors" "$OUT/qwen38_27b_vision.rt4"
  fi
fi

echo "== 产物 =="
ls -lh "$OUT" | grep -E 'rt4|json' || true
for f in qwen38_27b.rt4 qwen38_27b.rt4.json qwen38_27b_mtp.rt4 \
         qwen38_27b_mtp.rt4.json qwen38_27b_vision.rt4 qwen38_27b_vision.rt4.json; do
  if need "$f"; then echo "  OK   $f"; else echo "  MISS $f" >&2; fi
done
