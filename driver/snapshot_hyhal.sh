#!/bin/bash
# 在已装好 DCU 驱动的机器上，把用户态运行时（/usr/local/hyhal，/opt/hyhal 指向它）
# 重新打成一份可移植的快照，放到 driver/hyhal/ 下。
#
#   bash driver/snapshot_hyhal.sh
#
# 目标机器上还原：
#   sudo tar -C /usr/local -xzf driver/hyhal/hyhal-prebuilt-<内核>.tar.gz
#   ln -sfn /usr/local/hyhal /opt/hyhal
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC="${HYHAL_SRC:-/usr/local/hyhal}"
[ -d "$SRC" ] || { echo "找不到 $SRC（先装 DCU 驱动）" >&2; exit 1; }
[ -x "$SRC/bin/hy-smi" ] || { echo "$SRC 不像完整的 hyhal 运行时" >&2; exit 1; }

OUT="$HERE/hyhal/hyhal-prebuilt-$(uname -r).tar.gz"
mkdir -p "$(dirname "$OUT")"
echo "打包 $SRC → $OUT"
tar -C "$(dirname "$SRC")" -czf "$OUT" "$(basename "$SRC")"
ls -lh "$OUT"
sha256sum "$OUT"
