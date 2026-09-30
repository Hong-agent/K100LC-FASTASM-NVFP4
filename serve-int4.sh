#!/bin/bash
# int4 现在是**全项目默认**（serve.sh / run.sh / deploy-*.sh / pack_weights.sh 都走它），
# 这个脚本保留下来只为兼容老命令：等价于 `PORT=8080 bash serve.sh`（默认 8080 端口）。
#
#   bash serve-int4.sh              # http://<本机IP>:8080/
#   PORT=8081 CTX=16384 bash serve-int4.sh
#   bash serve-int4.sh --stop
#
# 想要项目默认入口（监听 80、局域网不带端口号）就直接用：bash serve.sh。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PORT="${PORT:-8080}"
exec bash "$HERE/serve.sh" "$@"
