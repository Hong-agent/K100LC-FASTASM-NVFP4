#!/bin/bash
# 端到端：自研汇编器把 kernels/asm 下全部内核汇编成一个无 DTK 的 HSACO，
# HSA 能解析全部符号并执行真实模型内核。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/tools/build_kernels.py" --spec "$ROOT/kernels/kernel_spec.json" \
  --asm-dir "$ROOT/kernels/asm" --out-dir "$TMP" >/dev/null
python3 "$ROOT/tools/make_hsaco_multi.py" "$TMP/all_kernels_spec.json" "$TMP/all.hsaco" >/dev/null

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

count=0
while read -r name; do
  [ -z "$name" ] && continue
  out="$(HSA_LOADER_RESOLVE_ONLY=1 "$TMP/hsa_min_loader" "$TMP/all.hsaco" "$name" 2>&1)"
  grep -q '^resolved$' <<<"$out" || { echo "resolve failed: $name"; echo "$out"; exit 1; }
  count=$((count + 1))
done < <(python3 -c 'import json,sys; print("\n".join(k["name"] for k in json.load(open(sys.argv[1]))))' "$TMP/all_kernels_spec.json")
echo "resolved $count kernels"
test "$count" -eq 80

scale_out="$(HSA_LOADER_PREFILL=2.0 HSA_LOADER_VALUE=3.0 HSA_LOADER_EXPECT=6.0 \
  "$TMP/hsa_min_loader" "$TMP/all.hsaco" _Z11scale_mul_kPffx 2>&1)"
grep -q 'out\[0\]=6.000' <<<"$scale_out"
grep -q 'bad=0' <<<"$scale_out"

fill_out="$(HSA_LOADER_VALUE=3.25 HSA_LOADER_EXPECT=3.25 \
  "$TMP/hsa_min_loader" "$TMP/all.hsaco" _Z6fill_kPffx 2>&1)"
grep -q 'out\[0\]=3.250' <<<"$fill_out"
grep -q 'bad=0' <<<"$fill_out"

echo "all-kernel HSACO ok"
