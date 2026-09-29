#!/usr/bin/env python3
"""Resolve an asm_reloc.py manifest and emit patched text/data binaries."""

from __future__ import annotations

import argparse
import json
import struct
from pathlib import Path


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("manifest", type=Path)
    ap.add_argument("--text-vaddr", type=lambda x: int(x, 0), default=0x1000)
    ap.add_argument("--data-vaddr", type=lambda x: int(x, 0), default=0x20000)
    ap.add_argument("--text-out", type=Path, required=True)
    ap.add_argument("--data-out", type=Path, required=True)
    args = ap.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    text = bytearray(bytes.fromhex(manifest["text_hex"]))
    data = bytearray(bytes.fromhex(manifest["data_hex"]))
    symaddr = {}
    for name, sym in manifest["symbols"].items():
        base = args.text_vaddr if sym["section"] == "text" else args.data_vaddr
        symaddr[name] = base + sym["offset"]
    for rel in manifest["relocations"]:
        addr = symaddr[rel["symbol"]]
        target = text if rel["section"] == "text" else data
        off = rel["offset"]
        if rel["type"] == "abs32_lo":
            struct.pack_into("<I", target, off, addr & 0xFFFFFFFF)
        elif rel["type"] == "abs32_hi":
            struct.pack_into("<I", target, off, (addr >> 32) & 0xFFFFFFFF)
        elif rel["type"] == "abs32":
            struct.pack_into("<I", target, off, addr & 0xFFFFFFFF)
        elif rel["type"] == "abs64":
            struct.pack_into("<Q", target, off, addr)
        elif rel["type"] == "rel32":
            value = addr - (args.text_vaddr + (off - 4))
            struct.pack_into("<I", target, off, value & 0xFFFFFFFF)
        else:
            raise SystemExit(f"unknown relocation type {rel['type']}")
    args.text_out.write_bytes(text)
    args.data_out.write_bytes(data)
    print(f"linked text={len(text)} data={len(data)} relocs={len(manifest['relocations'])}")


if __name__ == "__main__":
    main()
