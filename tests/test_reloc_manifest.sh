#!/bin/bash
# Static relocation manifest test.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$ROOT/tools/asm_reloc.py" "$ROOT/examples/reloc_load.s" "$TMP/reloc.json"
python3 "$ROOT/tools/link_manifest.py" "$TMP/reloc.json" \
  --text-vaddr 0x4000 --data-vaddr 0x1000 \
  --text-out "$TMP/text.bin" --data-out "$TMP/data.bin"

python3 - "$TMP/text.bin" "$TMP/data.bin" <<'PY'
import struct, sys
text = open(sys.argv[1], 'rb').read()
data = open(sys.argv[2], 'rb').read()
assert struct.unpack_from('<I', text, 4)[0] == 0x1000
assert struct.unpack_from('<I', text, 12)[0] == 0
assert struct.unpack_from('<I', data, 0)[0] == 0x3f800000
print('relocation manifest ok')
PY
