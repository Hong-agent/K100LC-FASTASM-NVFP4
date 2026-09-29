#!/usr/bin/env python3
"""Assembler with a minimal relocation manifest for global data symbols."""

from __future__ import annotations

import argparse
import json
import re
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import asm  # noqa: E402


def emit_data_directives(line: str, data: bytearray, symbols: dict,
                         relocations: list, labels: dict) -> None:
    stripped = line.strip()
    if stripped.endswith(":"):
        labels[stripped[:-1].strip()] = len(data)
        return
    mnemonic, _, rest = stripped.partition(" ")
    operands = asm.split_operands(rest)
    if mnemonic == ".byte":
        data.extend(int(x, 0) & 0xFF for x in operands)
    elif mnemonic == ".long":
        for x in operands:
            if re.fullmatch(r"[A-Za-z_.$][\w.$]*", x):
                relocations.append({"section": "data", "offset": len(data),
                                    "type": "abs32", "symbol": x})
                data.extend(b"\0\0\0\0")
            else:
                data.extend((int(x, 0) & 0xFFFFFFFF).to_bytes(4, "little"))
    elif mnemonic == ".quad":
        for x in operands:
            if re.fullmatch(r"[A-Za-z_.$][\w.$]*", x):
                relocations.append({"section": "data", "offset": len(data),
                                    "type": "abs64", "symbol": x})
                data.extend(b"\0" * 8)
            else:
                data.extend((int(x, 0) & 0xFFFFFFFFFFFFFFFF).to_bytes(8, "little"))
    else:
        raise SystemExit(f"unsupported data directive: {line}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("source", type=Path)
    ap.add_argument("output", type=Path)
    args = ap.parse_args()

    section = "text"
    text_lines: list[str] = []
    text_relocs: list[tuple[int, str, str]] = []
    data = bytearray()
    data_labels: dict[str, int] = {}
    data_relocs: list[dict] = []

    for raw in args.source.read_text(encoding="utf-8").splitlines():
        line = raw.split(";", 1)[0].split("//", 1)[0].strip()
        if not line:
            continue
        if line in {".text", ".data", ".rodata"}:
            section = "text" if line == ".text" else "data"
            continue
        if section == "data":
            emit_data_directives(line, data, {}, data_relocs, data_labels)
            continue

        # text section: replace lo(sym)/hi(sym) with a literal placeholder.
        inst_index = len(text_lines)
        def repl(m: re.Match) -> str:
            text_relocs.append((inst_index, m.group(1), m.group(2)))
            return "0x10000"
        new_line = re.sub(r"\b(lo|hi|rel32)\(([A-Za-z_.$][\w.$]*)\)", repl, line)
        text_lines.append(new_line)

    with tempfile.TemporaryDirectory() as td:
        text_src = Path(td) / "text.s"
        text_src.write_text(".text\n" + "\n".join(text_lines) + "\n", encoding="utf-8")
        blob, instructions, labels = asm.assemble(text_src)

    # Map placeholder relocations to instruction addresses.  Each lo/hi
    # placeholder is the 32-bit literal word following an 8-byte s_mov_b32.
    relocs = []
    for inst_index, kind, symbol in text_relocs:
        if inst_index >= len(instructions):
            raise SystemExit(f"bad relocation index {inst_index}")
        inst = instructions[inst_index]
        rtype = {"lo": "abs32_lo", "hi": "abs32_hi", "rel32": "rel32"}[kind]
        relocs.append({"section": "text", "offset": inst.addr + 4,
                       "type": rtype,
                       "symbol": symbol})

    symbols = {}
    for name, offset in labels.items():
        symbols[name] = {"section": "text", "offset": offset, "size": 0}
    for name, offset in data_labels.items():
        symbols[name] = {"section": "data", "offset": offset, "size": 0}

    manifest = {
        "text_hex": blob.hex(),
        "data_hex": bytes(data).hex(),
        "symbols": symbols,
        "relocations": relocs + data_relocs,
    }
    args.output.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"wrote {args.output}: text={len(blob)} data={len(data)} "
          f"symbols={len(symbols)} relocs={len(manifest['relocations'])}")


if __name__ == "__main__":
    main()
