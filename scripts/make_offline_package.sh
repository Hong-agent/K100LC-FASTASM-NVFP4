#!/bin/bash
# 打「**解压即可离线部署**的整包」：源码 + 全 W4A8 权重 + 驱动 + 自带运行时 + 预编译引擎。
#
#   bash scripts/make_offline_package.sh
#   → dist/K100LC-FASTASM-NVFP4-离线部署-<日期>.zip  + .sha256   （约 14.8 GB）
#
# 包内（zip 根目录）：
#   K100LC-FASTASM-NVFP4/          整个项目：源码 + 内核 + 网页 + 工具 + 测试 + 文档
#     driver/                      DCU 驱动安装包（**不限内核版**）+ hyhal 快照 + 系统配置
#     runtime/python, runtime/py   自带 Python 3.10 + fastapi/uvicorn/tokenizers/...
#     prebuilt/rt, *.hsaco         预编译引擎（119 个内核，目标机不编译也能跑）
#     models/Qwen3.8-27B-INT4/     默认模型（全 W4A8）：
#         rt4/qwen38_27b.rt4        13.91 GB 主模型 int4
#         rt4/qwen38_27b_mtp.rt4     0.22 GB MTP int4
#         rt4/qwen38_27b_vision.rt4  0.25 GB 视觉塔 int4（GPU 上跑）
#         + 分词/模板/config 与各 .json 清单
#     deploy-offline.sh            离线部署一条龙（装驱动 → 起服务）
#   离线部署说明.md                目标机上的做法
#
# 目标机上：unzip → cd → bash deploy-offline.sh。不需要联网、不需要 pip、
# 不需要编译器（除非要重编驱动内核模块）。
#
#   MODEL_SRC=/path/to/Qwen3.8-27B-INT4 bash scripts/make_offline_package.sh
#   RP4_SRC=build/model-int4.rp4 bash scripts/make_offline_package.sh
#     # 额外把 .rp4 单文件也塞进包（+14.35 GB，给 RT_RP4=<path> 的老路线用）
#   OUT=/data/xx.zip bash scripts/make_offline_package.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="K100LC-FASTASM-NVFP4"
DATE="$(date +%Y%m%d)"
OUT="${OUT:-$ROOT/dist/$NAME-离线部署-$DATE.zip}"
MODEL_NAME="${MODEL_NAME:-Qwen3.8-27B-INT4}"
MODEL_SRC="${MODEL_SRC:-$ROOT/models/$MODEL_NAME}"
RP4_SRC="${RP4_SRC:-}"          # 空 = 不打包 .rp4（默认就是直读 rt4/）
RT4_DIR="${RT4_DIR:-$MODEL_SRC/rt4}"
# 全 W4A8 的三个权重文件（缺一不可）
RT4_FILES=(qwen38_27b.rt4 qwen38_27b.rt4.json \
           qwen38_27b_mtp.rt4 qwen38_27b_mtp.rt4.json \
           qwen38_27b_vision.rt4 qwen38_27b_vision.rt4.json)
for f in "${RT4_FILES[@]}"; do
  [ -r "$RT4_DIR/$f" ] || { echo "缺 $RT4_DIR/$f（先跑 bash scripts/convert_weights.sh）" >&2; exit 1; }
done
[ -z "$RP4_SRC" ] || [ -r "$RP4_SRC" ] || { echo "RP4_SRC=$RP4_SRC 不可读" >&2; exit 1; }

mkdir -p "$(dirname "$OUT")"
STAGE="$(mktemp -d "$ROOT/dist/.stage-off.XXXXXX")"
cleanup() {
  if [ "${KEEP_STAGE:-0}" = "1" ]; then echo "（KEEP_STAGE=1，保留 $STAGE）"; return; fi
  find "$STAGE" -mindepth 1 -delete 2>/dev/null || true; rmdir "$STAGE" 2>/dev/null || true
}
trap cleanup EXIT
mkdir -p "$STAGE/$NAME/models/$MODEL_NAME/rt4"

# 同一文件系统上用硬链接（几乎零成本、不占第二份空间）；跨设备退回拷贝。
link() {
  local s="$1" d="$2"
  [ -e "$s" ] || return 0
  ln "$(readlink -f "$s")" "$d" 2>/dev/null || cp -f "$s" "$d"
}

echo "== [1/4] 复制应用（源码 + 驱动 + 运行时 + 预编译引擎）=="
tar -C "$ROOT" -cf - \
  --exclude=./.git \
  --exclude=./build \
  --exclude=./dist \
  --exclude=./workspaces \
  --exclude=./models/Qwen3.8-27B-INT4 \
  --exclude=./models/Qwen3.8-27B-NVFP4 \
  --exclude='*/__pycache__' \
  --exclude='*.pyc' \
  --exclude=./SHA256SUMS.txt \
  --exclude=./.askpass.sh \
  . | tar -C "$STAGE/$NAME" -xf -

echo "== [2/4] 放模型（主模型/MTP/视觉 的 int4 RT4 + 分词/模板/config）=="
M="$STAGE/$NAME/models/$MODEL_NAME"
link "$RT4_DIR/qwen38_27b.rt4"        "$M/rt4/qwen38_27b.rt4"
link "$RT4_DIR/qwen38_27b_mtp.rt4"    "$M/rt4/qwen38_27b_mtp.rt4"
link "$RT4_DIR/qwen38_27b_vision.rt4" "$M/rt4/qwen38_27b_vision.rt4"
[ -z "$RP4_SRC" ] || link "$RP4_SRC" "$M/model.rp4"
for f in tokenizer.json vocab.json chat_template.jinja config.json generation_config.json; do
  link "$MODEL_SRC/$f" "$M/$f"
done
for f in "$RT4_DIR"/*.json; do
  [ -r "$f" ] && link "$f" "$M/rt4/$(basename "$f")"
done

echo "== [3/4] 放根目录说明 =="
cp -f "$ROOT/离线部署说明.md" "$STAGE/离线部署说明.md"
cat > "$STAGE/$NAME/models/$MODEL_NAME/README-离线.md" <<'EOF'
这个目录是离线包自带的运行时权重，**全 W4A8**（int4 权重 × int8 激活）：

  rt4/qwen38_27b.rt4         13.91 GB  主模型 int4（851 张量）
  rt4/qwen38_27b_mtp.rt4      0.22 GB  MTP 投机头 int4（15 张量）
  rt4/qwen38_27b_vision.rt4   0.25 GB  视觉塔 int4（333 张量，在 DCU 上跑）
  rt4/*.json                           各部分的 manifest
  tokenizer.json / vocab.json          分词
  chat_template.jinja                  chat 模板
  config.json / generation_config.json

注意：这里**没有** model.safetensors / model.rp4，运行时也不需要它们
（默认 RT_RP4=0，引擎直接打开 rt4/ 下的三个文件）。改内核、重编引擎都不会
动到这份权重；要重新转换请见项目根目录的 scripts/convert_weights.sh
（需要联网拉源权重）。
EOF

# 包内清单
( cd "$STAGE/$NAME" && \
  find . -type f ! -name SHA256SUMS.txt ! -name '*.rt4' ! -name model.rp4 -print0 | LC_ALL=C sort -z | \
  xargs -0 sha256sum > SHA256SUMS.txt )
( cd "$STAGE/$NAME" && sha256sum models/$MODEL_NAME/rt4/*.rt4 >> SHA256SUMS.txt )
[ -z "$RP4_SRC" ] || ( cd "$STAGE/$NAME" && sha256sum "models/$MODEL_NAME/model.rp4" >> SHA256SUMS.txt )

echo "== [4/4] 打包（应用 deflate，*.rt4 / model.rp4 直接存储）→ $OUT =="
# zip 是「更新」语义（已存在的归档里，上一版删掉的文件会留着），先删干净再打
[ -e "$OUT" ] && rm -f "$OUT"
( cd "$STAGE" && zip -q -r -9 "$OUT" "离线部署说明.md" "$NAME" \
    -x "$NAME/models/$MODEL_NAME/rt4/*.rt4" -x "$NAME/models/$MODEL_NAME/model.rp4" )
( cd "$STAGE" && zip -q -0 "$OUT" "$NAME/models/$MODEL_NAME/rt4/qwen38_27b.rt4" \
    "$NAME/models/$MODEL_NAME/rt4/qwen38_27b_mtp.rt4" \
    "$NAME/models/$MODEL_NAME/rt4/qwen38_27b_vision.rt4" )
[ -z "$RP4_SRC" ] || ( cd "$STAGE" && zip -q -0 "$OUT" "$NAME/models/$MODEL_NAME/model.rp4" )
sha256sum "$OUT" > "$OUT.sha256"

echo
echo "离线整包：$OUT"
ls -lh "$OUT" "$OUT.sha256"
du -sh --dereference "$STAGE/$NAME" | tail -1
