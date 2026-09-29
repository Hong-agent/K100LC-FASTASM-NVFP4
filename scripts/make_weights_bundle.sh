#!/bin/bash
# 把「跑起来需要的权重」打成一个离线包，配合源码 zip 就是完整的离线部署。
#
#   bash scripts/make_weights_bundle.sh                 # → dist/权重zip（约 16 GB）
#   OUT=/data/xx.zip bash scripts/make_weights_bundle.sh
#
# 只需要这三样东西（合计约 15.8 GB，比散读模式少 20 GB）：
#   model.rp4          主模型 + NVFP4 + MTP + 视觉塔，单文件
#   tokenizer/模板     分词与 chat 模板
#   rt4/*.json         各部分的 manifest（体积可忽略）
# 解压到项目根目录，就是 models/Qwen3.8-27B-NVFP4/ 下的散文件，随后
# `bash serve.sh` 直接可用（不需要 tokenizer 之外的任何下载）。
#
# 打包用 zip -0（存储不压缩）：权重是二进制，压缩几乎不省空间，只会白白耗时间。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SRC="${MODEL_SRC:-$ROOT/models/Qwen3.8-27B-NVFP4}"
RP4="${RT_RP4_SRC:-$SRC/model.rp4}"
RT4DIR="${RT4_DIR:-$SRC/rt4}"
OUT="${OUT:-$ROOT/dist/K100LC-FASTASM-NVFP4-权重-$(date +%Y%m%d).zip}"

[ -r "$RP4" ] || { echo "找不到 model.rp4：$RP4（用 RT_RP4_SRC= 指定）" >&2; exit 1; }
[ -d "$RT4DIR" ] || { echo "找不到 rt4 目录：$RT4DIR（用 RT4_DIR= 指定）" >&2; exit 1; }

STAGE="/tmp/k100lc_weights_stage.$$"
mkdir -p "$STAGE/models/Qwen3.8-27B-NVFP4/rt4"
mkdir -p "$(dirname "$OUT")"

# 硬链接省磁盘（同一文件系统时几乎零成本）；跨设备就退回拷贝。
link() {
  ln "$1" "$2" 2>/dev/null || { echo "   $(basename "$2") 跨设备，改用拷贝"; cp "$1" "$2"; }
}

echo "== 组装权重目录 =="
link "$(readlink -f "$RP4")" "$STAGE/models/Qwen3.8-27B-NVFP4/model.rp4"
for f in tokenizer.json vocab.json chat_template.jinja config.json generation_config.json; do
  [ -r "$SRC/$f" ] && link "$(readlink -f "$SRC/$f")" "$STAGE/models/Qwen3.8-27B-NVFP4/$f"
done
for f in "$RT4DIR"/*.json; do
  [ -r "$f" ] && link "$(readlink -f "$f")" "$STAGE/models/Qwen3.8-27B-NVFP4/rt4/$(basename "$f")"
done
du -sh --dereference "$STAGE" | tail -1

echo "== 打包（zip -0，不压缩）=> $OUT =="
( cd "$STAGE" && zip -0 -q -r "$OUT" models )
ls -lh "$OUT"

echo "== 清理临时目录 =="
find "$STAGE" -mindepth 1 -delete && rmdir "$STAGE"

echo
echo "解压方式（在项目根目录）："
echo "  unzip -o $(basename "$OUT")"
