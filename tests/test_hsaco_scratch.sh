#!/bin/bash
# End-to-end test: assembler -> resized ELF/HSACO layout -> HSA execution.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/asm.py" "$ROOT/examples/nop_k.s" -o "$TMP/nop_k.bin"
python3 "$ROOT/tools/make_hsaco_from_scratch.py" "$TMP/nop_k.bin" "$TMP/nop_k.hsaco"

gcc -O2 -I/opt/hyhal/include \
  $ROOT/tools/hsa_min_loader.c \
  -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
  -o "$TMP/hsa_min_loader"

out="$("$TMP/hsa_min_loader" "$TMP/nop_k.hsaco" nop_k 2>&1)"
echo "$out"
grep -q 'completed' <<<"$out"
echo "HSACO from-scratch layout ok"
