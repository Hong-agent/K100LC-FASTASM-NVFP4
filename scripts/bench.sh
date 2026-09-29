#!/bin/bash
# 一键性能基准（方案 0.2 节四指标 + MTPBENCH 单矩阵表），markdown 追加进 docs/BENCHLOG.md。
#
#   bash scripts/bench.sh                    # 跑基准并入档（默认 tokens=8192 gen=500 runs=3）
#   bash scripts/bench.sh --prof             # 附带 RT_PROF=1 分阶段耗时桶
#   bash scripts/bench.sh --no-append        # 只打印不入档
#   bash scripts/bench.sh parse build/bench/bench_raw_*.log   # 只重新解析某次转录
#
# 环境同 run.sh / serve.sh（scripts/env.sh）：RT_ENGINE_BIN / RT_RT4 / RT_PYTHON。
# 所有优化项的验收数据以本脚本输出为准。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/env.sh"
cd "$RT_ROOT"

if [ "${1:-}" != "parse" ]; then
  if [ ! -x "$RT_ENGINE_BIN" ]; then
    echo "缺少引擎 $RT_ENGINE_BIN，先跑：bash build.sh" >&2
    exit 1
  fi
fi

export PYTHONPATH="$RT_PY_DEPS${PYTHONPATH:+:$PYTHONPATH}"
exec "$RT_PYTHON" scripts/bench_parse.py "$@"
