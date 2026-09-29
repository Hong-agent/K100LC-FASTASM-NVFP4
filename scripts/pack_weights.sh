#!/bin/bash
# 把运行时要用的全部权重合成一个自包含的 build/model.rp4。
#
#   bash scripts/pack_weights.sh          # 生成清单 + 打包（幂等，产物更新才重打）
#   bash scripts/pack_weights.sh --packed # 只重新生成 NVFP4 清单
#   NVFP4_ALL=0 bash scripts/pack_weights.sh
#                                         # 只让 MLP 走 NVFP4（其余线性层留在 RT4
#                                         # int4）：预填充更快（实测 +13%），权重精度略低
#
# 一个 .rp4 = 64 字节头 + 索引 + 载荷（主模型里被 NVFP4 取代的张量整段丢掉：168 个
# MLP 是 checkpoint 原生 NVFP4；注意力 / 线性注意力投影、lm_head、第 56~63 层 MLP
# 由 tools/nvfp4_quant.py 从 FP8 按同一规格重量化）。
# 运行时只打开这一个文件，顺序读载荷，格式见 docs/RP4-FORMAT.md。
# 纯 Python + 主机文件系统，不需要 DTK。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

SRC="${MODEL_SRC:-$ROOT/models/Qwen3.8-27B-NVFP4}"
RT4DIR="$RT_MODEL_DIR/rt4"
MANIFEST="$ROOT/build/nvfp4_manifest.tsv"
EXTRA="$ROOT/build/nvfp4_extra_blob.bin"
EXTRA_TSV="$ROOT/build/nvfp4_extra_manifest.tsv"
RP4="$ROOT/build/model.rp4"
mkdir -p "$ROOT/build"

for f in "$SRC/model.safetensors" "$RT4DIR/qwen38_27b.rt4" \
         "$RT4DIR/qwen38_27b_mtp.rt4" "$RT4DIR/qwen38_27b_vision.rt4"; do
  [ -r "$f" ] || { echo "缺 $f（先跑 scripts/convert_weights.sh）" >&2; exit 1; }
done

echo "== 1/2 扫 NVFP4 张量偏移 =="
python3 "$ROOT/tools/nvfp4_layout.py" "$SRC/model.safetensors" "$MANIFEST"

echo "== 1b/2 把 FP8 线性层重量化成 NVFP4（注意力/线性注意力投影、lm_head、56~63 层 MLP）=="
NVFP4_ALL="${NVFP4_ALL:-1}"
if [ "$NVFP4_ALL" = "0" ]; then
  echo "   NVFP4_ALL=0：跳过（这些层留在 RT4 int4）"
elif [ -s "$EXTRA" ] && [ -s "$EXTRA_TSV" ] && [ "$EXTRA" -nt "$SRC/model.safetensors" ]; then
  echo "   $EXTRA 已是最新，跳过"
else
  python3 "$ROOT/tools/nvfp4_quant.py" --safetensors "$SRC/model.safetensors" \
      --out "$EXTRA" --tsv "$EXTRA_TSV"
fi

if [ "${1:-}" = "--packed" ]; then
  echo "只更新清单，未重新打包。"
  exit 0
fi

# 「已是最新」也要看布局：all=全部线性层 NVFP4，mlp=只有 MLP 走 NVFP4
LAYOUT="all"; [ "$NVFP4_ALL" = "0" ] && LAYOUT="mlp"
STAMP="$ROOT/build/.rp4_layout"
if [ -f "$RP4" ] && [ "$RP4" -nt "$MANIFEST" ] && \
   { [ "$NVFP4_ALL" = "0" ] || [ "$RP4" -nt "$EXTRA" ]; } && \
   [ "$(cat "$STAMP" 2>/dev/null || echo none)" = "$LAYOUT" ]; then
  echo "== 2/2 $RP4 已是最新，跳过 =="
  exit 0
fi

echo "== 2/2 合成单个 model.rp4（约 15.8 GB，几分钟）=="
EXTRA_ARGS=()
[ "$NVFP4_ALL" = "0" ] || EXTRA_ARGS=(--nvfp4-extra "$EXTRA" --nvfp4-extra-tsv "$EXTRA_TSV")
python3 "$ROOT/tools/rp4_pack.py" \
    --main        "$RT4DIR/qwen38_27b.rt4"        --main-json        "$RT4DIR/qwen38_27b.rt4.json" \
    --mtp         "$RT4DIR/qwen38_27b_mtp.rt4"    --mtp-json         "$RT4DIR/qwen38_27b_mtp.rt4.json" \
    --vision      "$RT4DIR/qwen38_27b_vision.rt4" --vision-json      "$RT4DIR/qwen38_27b_vision.rt4.json" \
    --nvfp4       "$SRC/model.safetensors"        --nvfp4-tsv        "$MANIFEST" \
    "${EXTRA_ARGS[@]}" \
    --out         "$RP4"
echo "$LAYOUT" > "$STAMP"
ln -sfn "$RP4" "$RT_MODEL_DIR/model.rp4"
ls -lh "$RP4"
