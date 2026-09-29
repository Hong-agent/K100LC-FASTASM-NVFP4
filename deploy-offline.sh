#!/bin/bash
# 离线整包解压后的**一条龙部署**（目标机不需要联网）。
#
#   cd K100LC-FASTASM-NVFP4
#   bash deploy-offline.sh                 # 检查 → （按需）装驱动 → 起服务
#   HY_INSTALL_DRIVER=1 bash deploy-offline.sh   # 没装驱动时自动装（需要 sudo）
#   PORT=8080 CTX=40960 bash deploy-offline.sh
#
# 只做三件事：确认 DCU 驱动在 → 确认模型/运行时都在 → 起网页控制台。
# 全程使用包内自带的 Python，不 pip、不联网、不编译。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

DRV="$(ls -1 driver/installer/rock-*.aio.run 2>/dev/null | head -1 || true)"

hr() { printf '\n===== %s =====\n' "$1"; }

hr "1/3 DCU 驱动"
need_driver=0
[ -e /dev/kfd ] || need_driver=1
if [ -x /opt/hyhal/bin/hy-smi ] && ! /opt/hyhal/bin/hy-smi >/dev/null 2>&1; then
  need_driver=1
fi

if [ "$need_driver" = 0 ]; then
  echo "  驱动就绪：$(/opt/hyhal/bin/hy-smi 2>/dev/null | grep -m1 '^0 ' || true)"
else
  echo "  没看到 /dev/kfd 或 hy-smi 读不到卡 —— 需要装驱动。"
  echo "  安装包：$DRV"
  echo "  （不限内核版本：在**当前这个内核**上现编，装完重启即可，不再锁 6.8）"
  if [ "${HY_INSTALL_DRIVER:-0}" = "1" ]; then
    [ -n "$DRV" ] || { echo "  driver/installer 下没有 .aio.run" >&2; exit 1; }
    echo "  == 运行驱动安装包 =="
    sudo bash "$DRV"
    echo
    echo "  驱动装完请 reboot，再重新跑一次 bash deploy-offline.sh"
    exit 0
  fi
  echo
  echo "  装：sudo bash \"$DRV\"  &&  sudo reboot"
  echo "  或：HY_INSTALL_DRIVER=1 bash deploy-offline.sh"
  exit 1
fi

hr "2/3 模型与运行时"
ok=1
for f in models/Qwen3.8-27B-NVFP4/model.rp4 \
         models/Qwen3.8-27B-NVFP4/tokenizer.json \
         prebuilt/rt prebuilt/k100lc_all.hsaco; do
  if [ -e "$f" ]; then echo "  OK   $f"; else echo "  MISS $f" >&2; ok=0; fi
done
if [ -x runtime/python/bin/python3.10 ] && [ -d runtime/py ]; then
  echo "  OK   自带运行时 runtime/python + runtime/py"
else
  echo "  MISS 自带运行时（缺 runtime/python 或 runtime/py）" >&2; ok=0
fi
[ "$ok" = 1 ] || exit 1

hr "3/3 起服务"
echo "  引擎：$( [ -x build/rt ] && echo build/rt || echo prebuilt/rt )（自研 HSACO + /opt/hyhal 的 HSA）"
echo "  模型：model.rp4（KV cache 走 int8，每 dword 4 个元素，尺度 amax/127）"
echo "  网页默认 maxtoken = 40960，上下文 CTX=${CTX:-40960}"
PORT="${PORT:-8080}" CTX="${CTX:-40960}" bash serve.sh

LAN_IP="$(ip -4 -o addr show scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | grep -v '^172\.17\.' | head -1)"
echo
echo "打开网页：http://${LAN_IP:-127.0.0.1}:${PORT:-8080}/"
echo "停止服务：bash serve.sh --stop"
