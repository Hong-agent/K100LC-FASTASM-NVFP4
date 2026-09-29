#!/bin/bash
# 把本机已有的权重接到项目里（不下载、不复制大文件，一律软链接）。
#
#   bash scripts/setup_models.sh
#   MODEL_SRC=/path/to/Qwen3.8-27B-NVFP4 \
#   RT4_DIR=/path/to/already/converted/rt4 \
#   RP4=/path/to/model.rp4 bash scripts/setup_models.sh
#
# 默认从项目的同级目录（本机就是桌面）找：
#   原始 safetensors : ../Qwen3.8-27B-NVFP4
#   已转换的 RT4 权重 : ../K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4
#   NVFP4 单文件      : ../k100lc-fast-nvfp4/build/model.rp4
#
# 转换本身不需要 DTK（tools/convert.c 用主机 gcc 编译），见 scripts/convert_weights.sh。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MODEL_SRC="${MODEL_SRC:-$(cd "$ROOT/.." && pwd)/Qwen3.8-27B-NVFP4}"
MODEL_DIR="$ROOT/models/Qwen3.8-27B-NVFP4"
RT4_DIR="${RT4_DIR:-}"
RP4="${RP4:-}"

[ -d "$MODEL_SRC" ] || { echo "找不到原始权重目录 $MODEL_SRC（用 MODEL_SRC= 指定）" >&2; exit 1; }

# 已转换的 rt4 目录：优先用显式给的，其次看隔壁 K100LC-RT4，最后就地转换。
if [ -z "$RT4_DIR" ]; then
  if [ -d "$ROOT/models/Qwen3.8-27B-NVFP4/rt4" ] &&
     [ -n "$(ls -A "$ROOT/models/Qwen3.8-27B-NVFP4/rt4" 2>/dev/null)" ]; then
    RT4_DIR=""
  elif [ -d "$ROOT/../K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4" ]; then
    RT4_DIR="$ROOT/../K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4"
  fi
fi

if [ -z "$RP4" ]; then
  for cand in "$ROOT/models/Qwen3.8-27B-NVFP4/model.rp4" \
              "$ROOT/../k100lc-fast-nvfp4/build/model.rp4"; do
    [ -r "$cand" ] && { RP4="$cand"; break; }
  done
fi

mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"
for f in config.json generation_config.json tokenizer.json vocab.json chat_template.jinja \
         model.safetensors model_mtp.safetensors model.safetensors.index.json; do
  [ -e "$MODEL_SRC/$f" ] || continue
  ln -sfn "$MODEL_SRC/$f" "$f"
done

if [ -n "$RT4_DIR" ]; then
  ln -sfn "$(cd "$RT4_DIR" && pwd)" rt4
  echo "rt4  : $RT4_DIR"
elif [ -d rt4 ]; then
  echo "rt4  : 已就位（$MODEL_DIR/rt4）"
else
  echo "rt4  : 缺失 —— 跑一次转换：bash scripts/convert_weights.sh" >&2
fi

if [ -n "$RP4" ]; then
  ln -sfn "$RP4" model.rp4
  echo "rp4  : $RP4"
else
  echo "rp4  : 未提供（运行时会退回「清单 + safetensors」直读，见 docs/RP4-FORMAT.md）"
fi

echo
ls -l "$MODEL_DIR"
