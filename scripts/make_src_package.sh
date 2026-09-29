#!/bin/bash
# 打「**联网从零部署**的源码包」。
#
#   bash scripts/make_src_package.sh
#   → dist/K100LC-FASTASM-NVFP4-源码-<日期>.zip  + .sha256
#
# 包里有什么：全部源码（自研汇编器 asm.py + 80 个内核的 .s + 内核规格 + 运行时 +
# 网页 + 工具 + 测试 + 文档）、预编译引擎 prebuilt/、驱动安装包 driver/installer/
# （**不限内核版**，装驱动要用）、以及联网部署脚本 scripts/deploy_online.sh 与
# scripts/fetch_model.sh。
#
# 包里没有（目标机联网自己取）：权重（models/*，~22.5GB）、备好的 RT4/RP4 产物、
# 编译产物 build/、自带的 Python 运行库 runtime/py、runtime/python、
# 会话工作区 workspaces/、离线权重包 dist/。
#
#   WITH_DRIVER=0 bash scripts/make_src_package.sh   # 不带驱动安装包（纯源码，~5MB）
#   OUT=/data/xx.zip bash scripts/make_src_package.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="K100LC-FASTASM-NVFP4"
DATE="$(date +%Y%m%d)"
OUT="${OUT:-$ROOT/dist/$NAME-源码-$DATE.zip}"
WITH_DRIVER="${WITH_DRIVER:-1}"

mkdir -p "$(dirname "$OUT")"
STAGE="$(mktemp -d "$ROOT/dist/.stage-src.XXXXXX")"
cleanup() { find "$STAGE" -mindepth 1 -delete 2>/dev/null || true; rmdir "$STAGE" 2>/dev/null || true; }
trap cleanup EXIT
mkdir -p "$STAGE/$NAME"

echo "== 收集源码 → $STAGE/$NAME =="
EXCLUDES=(
  --exclude=./.git
  --exclude=./build
  --exclude=./dist
  --exclude=./workspaces
  --exclude=./runtime/py
  --exclude=./runtime/python
  --exclude=./models/Qwen3.8-27B-NVFP4
  --exclude=./driver/hyhal
  --exclude='*/__pycache__'
  --exclude='*.pyc'
  --exclude=./.askpass.sh
)
if [ "$WITH_DRIVER" = "0" ]; then
  EXCLUDES+=(--exclude=./driver/installer)
else
  # 只带「不限内核」那份；内核 68 修正版留给有需要的机器（见 driver/INSTALL.md）
  EXCLUDES+=(--exclude='./driver/installer/*内核68修正*')
fi

tar -C "$ROOT" -cf - "${EXCLUDES[@]}" . | tar -C "$STAGE/$NAME" -xf -

# 包内清单（解压后可逐个核对，也方便对比两个包）
( cd "$STAGE/$NAME" && \
  find . -type f ! -name SHA256SUMS.txt -print0 | LC_ALL=C sort -z | \
  xargs -0 sha256sum > SHA256SUMS.txt )

echo "== 打包 → $OUT =="
# zip 是「更新」语义（已存在的归档里，上一版删掉的文件会留着），先删干净再打
[ -e "$OUT" ] && rm -f "$OUT"
( cd "$STAGE" && zip -q -r -9 "$OUT" "$NAME" )
sha256sum "$OUT" > "$OUT.sha256"

echo
echo "源码包：$OUT"
ls -lh "$OUT" "$OUT.sha256"
echo "内容概览："
( cd "$STAGE/$NAME" && find . -maxdepth 1 -mindepth 1 | LC_ALL=C sort | sed 's/^\./  /' )
