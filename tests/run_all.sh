#!/bin/bash
# 跑一遍全部自检。除了最后的引擎测试需要权重，其余都只需要 Python + gcc + /opt/hyhal。
#
#   bash tests/run_all.sh
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/scripts/env.sh"
cd "$ROOT"
fail=0

run() {
  local name="$1"; shift
  printf '%-26s ' "$name"
  if "$@" >/tmp/k100lc_test.log 2>&1; then
    echo OK
  else
    echo FAIL
    sed -n '1,20p' /tmp/k100lc_test.log
    fail=1
  fi
}

echo "== 汇编器与 HSACO（不需要 DTK）=="
run test_asm              python3 tests/test_asm.py
if command -v node >/dev/null 2>&1; then
  run test_markdown       node tests/test_markdown.js
else
  printf '%-26s %s\n' test_markdown "跳过（没有 node）"
fi
run test_hsa_pipeline     bash tests/test_hsa_pipeline.sh
run test_hsaco_scratch    bash tests/test_hsaco_scratch.sh
run test_hsaco_full       bash tests/test_hsaco_full.sh
run test_hsaco_multi      bash tests/test_hsaco_multi.sh
run test_merge_hsacos     bash tests/test_merge_hsacos.sh
run test_scale_mul        bash tests/test_scale_mul.sh
run test_reloc_manifest   bash tests/test_reloc_manifest.sh
run test_all_kernels      bash tests/test_all_kernels_hsaco.sh

echo "== HSA 运行时（需要 DCU）=="
run test_hsa_runtime      python3 tests/test_hsa_runtime.py
run test_grid_dims        python3 tests/test_grid_dims.py

echo "== 端到端引擎（需要权重）=="
run test_engine           python3 tests/test_engine.py
run test_kv_reuse         env PYTHONPATH="$RT_PY_DEPS${PYTHONPATH:+:$PYTHONPATH}" \
                              "$RT_PYTHON" tests/test_kv_reuse.py
run test_serve_kv         env PYTHONPATH="$RT_PY_DEPS${PYTHONPATH:+:$PYTHONPATH}" \
                              RT_PYTHON="$RT_PYTHON" "$RT_PYTHON" tests/test_serve_kv.py

echo
if [ "$fail" = 0 ]; then echo "全部通过 ✓"; else echo "有失败项 ✗"; fi
exit "$fail"
