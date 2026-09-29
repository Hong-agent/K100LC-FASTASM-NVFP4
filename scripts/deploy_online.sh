#!/bin/bash
# **联网从零部署**一条龙：检查环境 → 装依赖 → 下模型 → 转换 → 打包权重 →
#
#   bash scripts/deploy_online.sh              # 全流程（已完成的步骤自动跳过）
#   bash scripts/deploy_online.sh --check      # 只看环境与产物，不下载、不编译
#   bash scripts/deploy_online.sh --no-deps    # 不动系统 Python（依赖自己装）
#   SKIP_TORCH=1 bash scripts/deploy_online.sh  # 兼容旧参数（本项目不需要 torch）
#
# 目标机器：海光 K100_LC（gfx926）+ DCU 驱动（`/opt/hyhal/bin/hy-smi` 能看到卡）。
# 只需要联网 + 主机 g++/python3；**不需要 DTK，也不需要 Docker**。
#
# 每一步都能单独重跑（幂等）：
#   驱动    见 driver/INSTALL.md（或 driver/installer/*.aio.run）
#   依赖    python3 -m pip install -r requirements.txt
#   模型    bash scripts/fetch_model.sh
#   转换    bash scripts/convert_weights.sh   （RT4 格式，主机 gcc，约 4.5 分钟）
#   权重    bash scripts/pack_weights.sh      （合成单文件 model.rp4，约 15.8 GB）
#   引擎    bash build.sh                     （自研汇编器 + g++ 编出 build/rt）
#   运行    bash serve.sh / bash run.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
source "$ROOT/scripts/env.sh"

CHECK_ONLY=0
NO_DEPS=0
for a in "$@"; do
  case "$a" in
    --check)   CHECK_ONLY=1 ;;
    --no-deps) NO_DEPS=1 ;;
    -h|--help) sed -n '2,25p' "$0"; exit 0 ;;
    *) echo "未知参数：$a" >&2; exit 1 ;;
  esac
done

hr() { printf '\n===== %s =====\n' "$1"; }

hr "0/6 环境检查"
ok=1
for t in g++ gcc python3 curl; do
  if command -v "$t" >/dev/null; then echo "  OK   $t  $(command -v "$t")"
  else echo "  MISS $t（apt install build-essential python3 curl）"; ok=0; fi
done
if [ -d /opt/hyhal/lib ] && [ -d /opt/hyhal/include ]; then
  echo "  OK   /opt/hyhal（DCU 驱动自带的 HSA 运行时）"
else
  echo "  MISS /opt/hyhal —— 先装 DCU 驱动：sudo bash driver/installer/rock-*.aio.run"
  ok=0
fi
if [ -x /opt/hyhal/bin/hy-smi ] && /opt/hyhal/bin/hy-smi >/dev/null 2>&1; then
  echo "  OK   hy-smi 能看到 DCU"
fi
[ "$ok" = 1 ] || { echo; echo "环境不完整（--check 只做检查，不自动装包）" >&2; exit 1; }

DEPS_MISSING=0
python3 - <<'PY' || DEPS_MISSING=1
import importlib, sys
need = ['fastapi', 'uvicorn', 'tokenizers', 'jinja2', 'numpy']
miss = [m for m in need if importlib.util.find_spec(m) is None]
print('  OK   Python 依赖齐全' if not miss else '  MISS Python 依赖：' + ' '.join(miss))
sys.exit(1 if miss else 0)
PY

if [ "$CHECK_ONLY" = 1 ]; then
  hr "产物检查"
  for f in models/Qwen3.8-27B-NVFP4/model.safetensors \
           models/Qwen3.8-27B-NVFP4/rt4/qwen38_27b.rt4 \
           models/Qwen3.8-27B-NVFP4/model.rp4 build/rt build/k100lc_all.hsaco; do
    [ -e "$f" ] && echo "  OK   $f" || echo "  MISS $f"
  done
  exit 0
fi

if [ "$NO_DEPS" = 0 ] && [ "$DEPS_MISSING" = 1 ]; then
  hr "1/6 安装 Python 依赖（requirements.txt）"
  python3 -m pip install --user -r requirements.txt
else
  hr "1/6 Python 依赖（跳过）"
fi

hr "2/6 下载源模型（unsloth/Qwen3.8-27B-NVFP4）"
if [ -s models/Qwen3.8-27B-NVFP4/model.safetensors ] &&
   [ -s models/Qwen3.8-27B-NVFP4/model_mtp.safetensors ]; then
  echo "  已存在，跳过（要重新校验：bash scripts/fetch_model.sh --check）"
else
  bash scripts/fetch_model.sh
fi

hr "3/6 接入权重目录（软链接）"
bash scripts/setup_models.sh

hr "4/6 转换 RT4 权重（主机 gcc，约 4.5 分钟）"
bash scripts/convert_weights.sh

hr "5/6 合成单文件 model.rp4（约 15.8 GB）"
bash scripts/pack_weights.sh

hr "6/6 构建引擎（自研汇编器 + g++）"
bash build.sh

hr "完成"
echo "起网页控制台：  bash serve.sh"
echo "命令行对话：    bash run.sh --prompt 你好 --n 64"
echo "（maxtoken 默认 40960，上下文默认 40960；PORT=8080 bash serve.sh）"
