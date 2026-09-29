#!/bin/bash
# End-to-end test: assemble the real scale_mul_k kernel and execute it.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/asm.py" "$ROOT/examples/scale_mul.s" -o "$TMP/scale_mul.bin"
python3 "$ROOT/tools/make_hsaco_full.py" "$TMP/scale_mul.bin" "$TMP/scale_mul.hsaco" \
  --name _Z11scale_mul_kPffx \
  --args "$ROOT/examples/fill_args.json" \
  --kernarg-size 280 --kernarg-align 8 \
  --sgpr-count 11 --vgpr-count 3

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

out="$(HSA_LOADER_PREFILL=2.0 HSA_LOADER_VALUE=3.0 HSA_LOADER_EXPECT=6.0 \
  "$TMP/hsa_min_loader" "$TMP/scale_mul.hsaco" _Z11scale_mul_kPffx 2>&1)"
echo "$out"
grep -q 'out\[0\]=6.000' <<<"$out"
grep -q 'bad=0' <<<"$out"
echo "scale_mul_k ok"
