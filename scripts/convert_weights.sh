#!/bin/bash
# 把原始 safetensors 转成本项目运行时要用的 RT4 权重（**不需要 DTK，不需要 Docker**）。
#
#   bash scripts/convert_weights.sh            # 缺什么补什么（幂等）
#   bash scripts/convert_weights.sh --check    # 只校验已有产物
#
# 转换器是自研的 tools/convert.c（主机 gcc 编译）与 tools/convert_vision_rt4.py（纯 numpy）。
# 源权重默认取 RT_MODEL_DIR 那份（即 models/Qwen3.8-27B-INT4，全项目默认）；
# 用 MODEL_SRC= 或者 RT_MODEL_DIR= 可以换（例如换 NVFP4 checkpoint 走 opt-in 路线）。
#
# MTP 头默认只打 int4（W4A8，和全项目默认一致）；MTP_W8=1 额外再打一份
# int8（W8A8）权重 qwen38_27b_mtp_w8.rt4：int4 相对误差 ≈12.8%、接受率会低一些，
# int8 版 ≈0.9%，但要多 438 MB 与约 30 秒。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

SRC="${MODEL_SRC:-$RT_MODEL_DIR}"
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
  if [ "${MTP_W8:-0}" != "0" ] && ! need qwen38_27b_mtp_w8.rt4; then
    echo "== MTP 头转 int8（W8A8：int8 码拆成 hi/lo 两张 int4，两遍相加）=="
    python3 "$ROOT/tools/mtp_w8_pack.py" \
      "$SRC/model_mtp.safetensors" "$OUT/qwen38_27b_mtp.rt4.json" \
      "$OUT/qwen38_27b_mtp_w8"
  fi
  if ! need qwen38_27b_vision.rt4; then
    echo "== 转换视觉塔 =="
    python3 "$ROOT/tools/convert_vision_rt4.py" \
      "$SRC/model.safetensors" "$OUT/qwen38_27b_vision.rt4"
  fi
fi

echo "== 产物 =="
ls -lh "$OUT" | grep -E 'rt4|json' || true
REQ="qwen38_27b.rt4 qwen38_27b.rt4.json qwen38_27b_mtp.rt4 \
     qwen38_27b_mtp.rt4.json qwen38_27b_vision.rt4 qwen38_27b_vision.rt4.json"
[ "${MTP_W8:-0}" != "0" ] && REQ="$REQ qwen38_27b_mtp_w8.rt4 qwen38_27b_mtp_w8.rt4.json"
for f in $REQ; do
  if need "$f"; then echo "  OK   $f"; else echo "  MISS $f" >&2; fi
done
