#!/bin/bash
# End-to-end test: self-developed assembler -> HSACO patch -> HSA execution.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/asm.py" "$ROOT/examples/custom_fill.s" -o "$TMP/custom_fill.bin"
python3 "$ROOT/tools/make_hsaco.py" "$TMP/custom_fill.bin" "$TMP/custom_fill.hsaco"

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

out="$(HSA_LOADER_VALUE=3.25 HSA_LOADER_EXPECT=1.0 \
  "$TMP/hsa_min_loader" "$TMP/custom_fill.hsaco" _Z6fill_kPffx 2>&1)"
echo "$out"
grep -q 'out\[0\]=1.000' <<<"$out"
grep -q 'bad=0' <<<"$out"
echo "HSA pipeline ok"
