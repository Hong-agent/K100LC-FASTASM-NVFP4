#!/bin/bash
# 把运行时要用的全部权重合成一个自包含的单文件（默认 build/model-int4.rp4）。
#
#   bash scripts/pack_weights.sh                 # 默认布局（幂等；产物变了才重打）
#   MTP_W8=1 bash scripts/pack_weights.sh        # MTP 头用 int8（W8A8，默认是 int4/W4A8）
#   VISION_RP4=1 bash scripts/pack_weights.sh    # 把视觉塔也装进 .rp4（默认不装）
#   NVFP4_ALL=mlp bash scripts/pack_weights.sh   # 再让 168 个 MLP 走 NVFP4 直跑
#   NVFP4_ALL=all bash scripts/pack_weights.sh   # 401 个线性层全走 NVFP4 直跑
#   RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 RP4=build/model.rp4 bash scripts/pack_weights.sh
#                                                # 打 NVFP4 checkpoint 那一份（opt-in）
#
# 默认布局：
#   源模型  models/Qwen3.8-27B-INT4（RedHatAI 原生 int4 checkpoint，全项目默认）；
#   主模型  RT4 int4 权重（W4A8：int4 权重 × int8 激活），**不做 NVFP4 替换**；
#   MTP 头  int4（W4A8，与项目默认一致；MTP_W8=1 才切 int8/W8A8）；
#   视觉塔  不装进 .rp4，图片由 scripts/vision_cpu.py 在 CPU 上编码。
#
# 一个 .rp4 = 64 字节头 + 索引 + 载荷。运行时只打开这一个文件、顺序读载荷，
# 格式见 docs/RP4-FORMAT.md。纯 Python + 主机文件系统，不需要 DTK。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

SRC="${MODEL_SRC:-$RT_MODEL_DIR}"
RT4DIR="$RT_MODEL_DIR/rt4"
MANIFEST="$ROOT/build/nvfp4_manifest.tsv"
EXTRA="$ROOT/build/nvfp4_extra_blob.bin"
EXTRA_TSV="$ROOT/build/nvfp4_extra_manifest.tsv"
RP4="${RP4:-$ROOT/build/model-int4.rp4}"
mkdir -p "$ROOT/build"

# 把 .rp4 产物落成模型目录里的**真实文件**（项目里没有任何软链接）。
# 同一文件系统上用硬链接（不额外占空间，删掉源也不受影响），跨盘再退回复制。
install_file() {   # $1=源 $2=目标
  local src="$1" dst="$2"
  [ -r "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  if ln -f "$src" "$dst" 2>/dev/null; then return 0; fi
  cp --remove-destination -p "$src" "$dst"
}

# ---- 主模型：默认保持 RT4 int4（W4A8），NVFP4 直跑是显式 opt-in ----
# 兼容旧写法：NVFP4_ALL=0 → mlp，NVFP4_ALL=1 → all。
NVFP4_MODE="${NVFP4_ALL:-none}"
case "$NVFP4_MODE" in
  0) NVFP4_MODE="mlp" ;;
  1) NVFP4_MODE="all" ;;
  none|off|mlp|all) ;;
  *) echo "NVFP4_ALL 只能是 none / off / mlp / all（当前 $NVFP4_MODE）" >&2; exit 1 ;;
esac

# ---- MTP 头：默认 int4（W4A8，和全项目默认一致）----
MTP_RT4="$RT4DIR/qwen38_27b_mtp.rt4"
MTP_JSON="$RT4DIR/qwen38_27b_mtp.rt4.json"
if [ "${MTP_W8:-0}" != "0" ] && [ -s "$RT4DIR/qwen38_27b_mtp_w8.rt4" ] && \
   [ -s "$RT4DIR/qwen38_27b_mtp_w8.rt4.json" ]; then
  MTP_RT4="$RT4DIR/qwen38_27b_mtp_w8.rt4"
  MTP_JSON="$RT4DIR/qwen38_27b_mtp_w8.rt4.json"
fi

# ---- 视觉塔：默认不装进 .rp4（图片走 CPU 编码器）----
VISION_ARGS=()
VISION_TAG="novis"
if [ "${VISION_RP4:-0}" != "0" ]; then
  VISION_ARGS=(--vision "$RT4DIR/qwen38_27b_vision.rt4"
               --vision-json "$RT4DIR/qwen38_27b_vision.rt4.json")
  VISION_TAG="vis"
fi

echo "== 主模型：$([ "$NVFP4_MODE" = none ] && echo 'RT4 int4（W4A8），不做 NVFP4 替换' || echo "NVFP4 直跑（$NVFP4_MODE）") =="
echo "== MTP 头：$(basename "$MTP_RT4") =="
echo "== 视觉塔：$([ "$VISION_TAG" = vis ] && echo '装进 .rp4' || echo '不装进 .rp4（CPU 编码器读 rt4/qwen38_27b_vision.rt4）') =="

for f in "$SRC/model.safetensors" "$RT4DIR/qwen38_27b.rt4" \
         "$RT4DIR/qwen38_27b.rt4.json" "$MTP_RT4"; do
  [ -r "$f" ] || { echo "缺 $f（先跑 scripts/convert_weights.sh）" >&2; exit 1; }
done
if [ "${VISION_RP4:-0}" != "0" ]; then
  for f in "$RT4DIR/qwen38_27b_vision.rt4" "$RT4DIR/qwen38_27b_vision.rt4.json"; do
    [ -r "$f" ] || { echo "缺 $f（先跑 scripts/convert_weights.sh）" >&2; exit 1; }
  done
fi

NVFP4_ARGS=()
if [ "$NVFP4_MODE" != "none" ]; then
  echo "== 1/2 扫 NVFP4 张量偏移（$NVFP4_MODE）=="
  python3 "$ROOT/tools/nvfp4_layout.py" "$SRC/model.safetensors" "$MANIFEST"
  if [ "$NVFP4_MODE" = "mlp" ]; then
    echo "   mlp：只有 168 个 MLP 张量走 NVFP4，其余线性层留在 RT4 int4"
  elif [ -s "$EXTRA" ] && [ -s "$EXTRA_TSV" ] && [ "$EXTRA" -nt "$SRC/model.safetensors" ]; then
    echo "   $EXTRA 已是最新，跳过"
  else
    echo "== 1b/2 把 FP8 线性层重量化成 NVFP4（注意力/线性注意力投影、lm_head、56~63 层 MLP）=="
    python3 "$ROOT/tools/nvfp4_quant.py" --safetensors "$SRC/model.safetensors" \
        --out "$EXTRA" --tsv "$EXTRA_TSV"
  fi
  NVFP4_ARGS=(--nvfp4 "$SRC/model.safetensors" --nvfp4-tsv "$MANIFEST")
  if [ "$NVFP4_MODE" = "all" ]; then
    NVFP4_ARGS+=(--nvfp4-extra "$EXTRA" --nvfp4-extra-tsv "$EXTRA_TSV")
  fi
fi

if [ "${1:-}" = "--packed" ]; then
  echo "只更新清单，未重新打包。"
  exit 0
fi

# 「已是最新」把布局也算进去：NVFP4 覆盖范围 + MTP 精度 + 视觉塔在不在。
LAYOUT="$NVFP4_MODE"
if [ "$MTP_RT4" = "$RT4DIR/qwen38_27b_mtp_w8.rt4" ]; then LAYOUT="$LAYOUT+w8mtp"
else LAYOUT="$LAYOUT+i4mtp"; fi
LAYOUT="$LAYOUT+$VISION_TAG"
STAMP="$ROOT/build/.rp4_layout"
if [ -f "$RP4" ] && [ "$RP4" -nt "$MTP_RT4" ] && \
   { [ "$NVFP4_MODE" = "none" ] || [ "$RP4" -nt "$MANIFEST" ]; } && \
   { [ "$NVFP4_MODE" != "all" ] || [ "$RP4" -nt "$EXTRA" ]; } && \
   [ "$(cat "$STAMP" 2>/dev/null || echo none)" = "$LAYOUT" ]; then
  install_file "$RP4" "$RT_MODEL_DIR/model.rp4"
  echo "== 2/2 $RP4 已是最新（$LAYOUT），跳过 =="
  echo "   已就位：$RT_MODEL_DIR/model.rp4（项目内真实文件）"
  exit 0
fi

echo "== 2/2 合成单个 $(basename "$RP4")（几分钟）=="
python3 "$ROOT/tools/rp4_pack.py" \
    --main        "$RT4DIR/qwen38_27b.rt4"        --main-json        "$RT4DIR/qwen38_27b.rt4.json" \
    --mtp         "$MTP_RT4"                      --mtp-json         "$MTP_JSON" \
    "${VISION_ARGS[@]}" \
    "${NVFP4_ARGS[@]}" \
    --out         "$RP4"
echo "$LAYOUT" > "$STAMP"
# 运行时认 $RT_MODEL_DIR/model.rp4（离线包里就是这一个文件），这里把它落成项目内真实文件。
install_file "$RP4" "$RT_MODEL_DIR/model.rp4"
ls -lh "$RP4"
echo "   已就位：$RT_MODEL_DIR/model.rp4（项目内真实文件）"
