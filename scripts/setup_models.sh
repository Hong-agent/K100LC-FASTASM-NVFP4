#!/bin/bash
# 把本机已有的权重接进项目里（不下载）。**项目内不留软链接**：
#   小文件直接复制；大于 1GB 的权重优先硬链接（同一文件系统、不额外占空间，
#   删掉项目外的源目录也不影响），跨盘时退回复制。
#
#   bash scripts/setup_models.sh
#   MODEL_SRC=/path/to/Qwen3.8-27B-INT4 \
#   RT4_DIR=/path/to/already/converted/rt4 \
#   RP4=/path/to/model-int4.rp4 bash scripts/setup_models.sh
#
# 默认接的是**全项目默认模型 int4**：
#   源权重        ../Qwen3.8-27B-INT4                     -> models/Qwen3.8-27B-INT4/
#   rt4 权重      就地转换的 models/Qwen3.8-27B-INT4/rt4（或 RT4_DIR= 指定）
#   单文件权重    build/model-int4.rp4                     -> models/Qwen3.8-27B-INT4/model.rp4
#
# NVFP4 checkpoint（opt-in 路线）也顺手接一遍，除非 SETUP_NVFP4=0：
#   源权重        ../Qwen3.8-27B-NVFP4                     -> models/Qwen3.8-27B-NVFP4/
#   rt4 权重      ../K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4（或 NVFP4_RT4_DIR= 指定）
#
# 转换本身不需要 DTK（tools/convert.c 用主机 gcc 编译），见 scripts/convert_weights.sh。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESKTOP="$(cd "$ROOT/.." && pwd)"

# 落成项目内真实文件：>1GB 优先硬链接（同盘不占额外空间），否则复制。
install_file() {   # $1=源 $2=目标
  local src="$1" dst="$2"
  [ -r "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  if [ "$(stat -L -c %s "$src")" -ge 1073741824 ]; then
    if ln -f "$src" "$dst" 2>/dev/null; then return 0; fi
  fi
  cp --remove-destination -p "$src" "$dst"
}

# 把一个源目录接成一个模型目录（目录里全是项目内真实文件，没有软链接）。
link_model() {   # $1=源目录 $2=目标模型目录 $3=rp4（可空） $4=rt4 目录（可空）
  local src="$1" dst="$2" rp4="$3" rt4_dir="$4" f
  mkdir -p "$dst"
  (
    cd "$dst"
    for f in config.json generation_config.json tokenizer.json tokenizer_config.json \
             processor_config.json recipe.yaml vocab.json chat_template.jinja \
             model.safetensors model_mtp.safetensors model.safetensors.index.json; do
      [ -e "$src/$f" ] || continue
      install_file "$src/$f" "$dst/$f"
    done
  )
  if [ -n "$rt4_dir" ] && [ -d "$rt4_dir" ]; then
    mkdir -p "$dst/rt4"
    for f in "$rt4_dir"/*; do
      [ -f "$f" ] || continue
      install_file "$f" "$dst/rt4/$(basename "$f")"
    done
    echo "  rt4 : $rt4_dir"
  elif [ -d "$dst/rt4" ]; then
    echo "  rt4 : 已就位（$dst/rt4）"
  else
    echo "  rt4 : 缺失 —— 跑一次转换：bash scripts/convert_weights.sh" >&2
  fi
  if [ -n "$rp4" ] && [ -r "$rp4" ]; then
    install_file "$(readlink -f "$rp4")" "$dst/model.rp4"
    echo "  rp4 : $(readlink -f "$rp4")"
  elif [ -r "$dst/model.rp4" ]; then
    echo "  rp4 : 已就位（$dst/model.rp4）"
  else
    echo "  rp4 : 未提供（运行时退回「NVFP4 清单 + safetensors」直读，见 docs/RP4-FORMAT.md）"
  fi
}

# ---------------- int4（默认模型） ----------------
MODEL_SRC="${MODEL_SRC:-$DESKTOP/Qwen3.8-27B-INT4}"
MODEL_DIR="${MODEL_DIR:-$ROOT/models/Qwen3.8-27B-INT4}"
RT4_DIR="${RT4_DIR:-}"
RP4="${RP4:-}"

echo "== int4（默认模型）=="
if [ -d "$MODEL_SRC" ]; then
  if [ -z "$RP4" ]; then
    for c in "$MODEL_DIR/model.rp4" "$ROOT/build/model-int4.rp4"; do
      [ -r "$c" ] && { RP4="$c"; break; }
    done
  fi
  link_model "$MODEL_SRC" "$MODEL_DIR" "$RP4" "$RT4_DIR"
else
  echo "  找不到 int4 源权重 $MODEL_SRC" >&2
  echo "  联网拉：bash scripts/fetch_model.sh（或 MODEL_SRC= 指向本机已有的一份）" >&2
fi

# ---------------- NVFP4 checkpoint（opt-in 路线） ----------------
if [ "${SETUP_NVFP4:-1}" != "0" ]; then
  NV_SRC="${NVFP4_SRC:-$DESKTOP/Qwen3.8-27B-NVFP4}"
  NV_DIR="${NVFP4_DIR:-$ROOT/models/Qwen3.8-27B-NVFP4}"
  if [ -d "$NV_SRC" ]; then
    echo
    echo "== NVFP4 checkpoint（opt-in）=="
    NV_RT4="${NVFP4_RT4_DIR:-}"
    if [ -z "$NV_RT4" ] && [ ! -d "$NV_DIR/rt4" ]; then
      for c in "$DESKTOP/K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4" \
               "$DESKTOP/k100lc资料/K100LC-RT4/models/Qwen3.8-27B-NVFP4/rt4"; do
        [ -d "$c" ] && { NV_RT4="$c"; break; }
      done
    fi
    NV_RP4="${NVFP4_RP4:-}"
    if [ -z "$NV_RP4" ]; then
      for c in "$NV_DIR/model.rp4" "$ROOT/build/model.rp4"; do
        [ -r "$c" ] && { NV_RP4="$c"; break; }
      done
    fi
    link_model "$NV_SRC" "$NV_DIR" "$NV_RP4" "$NV_RT4"
  fi
fi

echo
echo "== 结果 =="
ls -l "$MODEL_DIR" | sed 's/^/  /'
echo
echo "默认模型目录：$MODEL_DIR"
echo "起服务：bash serve.sh        （命令行：bash run.sh --prompt 你好 --n 64）"

[ -r "$MODEL_DIR/tokenizer.json" ] || { echo "缺 $MODEL_DIR/tokenizer.json（权重没接上）" >&2; exit 1; }
[ -r "$MODEL_DIR/model.rp4" ] || echo "提示：$MODEL_DIR/model.rp4 还没有，先跑 bash scripts/pack_weights.sh" >&2
