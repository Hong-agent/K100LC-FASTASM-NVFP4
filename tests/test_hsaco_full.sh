#!/bin/bash
# End-to-end test: fully generated metadata/symbols/hashes/descriptor -> HSA.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/asm.py" "$ROOT/examples/custom_fill.s" -o "$TMP/custom_fill.bin"
python3 "$ROOT/tools/make_hsaco_full.py" "$TMP/custom_fill.bin" "$TMP/fill_k.hsaco" \
  --name _Z6fill_kPffx \
  --args "$ROOT/examples/fill_args.json" \
  --kernarg-size 280 --kernarg-align 8 \
  --sgpr-count 15 --vgpr-count 7

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

out="$(HSA_LOADER_VALUE=3.25 HSA_LOADER_EXPECT=1.0 \
  "$TMP/hsa_min_loader" "$TMP/fill_k.hsaco" _Z6fill_kPffx 2>&1)"
echo "$out"
grep -q 'out\[0\]=1.000' <<<"$out"
grep -q 'bad=0' <<<"$out"
echo "fully generated HSACO ok"
