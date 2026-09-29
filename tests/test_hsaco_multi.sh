#!/bin/bash
# End-to-end test: multiple kernels in one fully generated HSACO.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/asm.py" "$ROOT/examples/nop_k.s" -o "$TMP/nop_k.bin"
python3 "$ROOT/asm.py" "$ROOT/examples/custom_fill.s" -o "$TMP/custom_fill.bin"

cat > "$TMP/spec.json" <<EOF
[
  {"name": "nop_k", "code": "$TMP/nop_k.bin",
   "kernarg_size": 0, "kernarg_align": 4, "sgpr_count": 4, "vgpr_count": 0},
  {"name": "_Z6fill_kPffx", "code": "$TMP/custom_fill.bin",
   "args": "$ROOT/examples/fill_args.json",
   "kernarg_size": 280, "kernarg_align": 8, "sgpr_count": 15, "vgpr_count": 7}
]
EOF

python3 "$ROOT/tools/make_hsaco_multi.py" "$TMP/spec.json" "$TMP/multi.hsaco"

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

nop_out="$("$TMP/hsa_min_loader" "$TMP/multi.hsaco" nop_k 2>&1)"
echo "$nop_out"
grep -q 'completed' <<<"$nop_out"

fill_out="$(HSA_LOADER_VALUE=3.25 HSA_LOADER_EXPECT=1.0 \
  "$TMP/hsa_min_loader" "$TMP/multi.hsaco" _Z6fill_kPffx 2>&1)"
echo "$fill_out"
grep -q 'out\[0\]=1.000' <<<"$fill_out"
grep -q 'bad=0' <<<"$fill_out"
echo "multi-kernel HSACO ok"
