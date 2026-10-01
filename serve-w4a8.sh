#!/bin/bash
# 兼容别名：全 W4A8 现在是**项目默认**，配置写在 scripts/env.sh，
# `serve.sh` 与 `serve-w4a8.sh` 完全等价。
#
#   bash serve.sh            # 推荐入口（默认全 W4A8，监听 80）
#   bash serve-w4a8.sh       # 同一个东西
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$HERE/serve.sh" "$@"
