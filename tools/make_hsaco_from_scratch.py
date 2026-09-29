#!/usr/bin/env python3
"""Generate a minimal gfx926 HSACO with a resized .text section.

This version rebuilds the ELF layout instead of patching a fixed function slot.
It reuses the known-good metadata/symbol/hash sections from the minimal
`nop_k` code object and supports arbitrarily sized no-argument kernels.
"""

from __future__ import annotations

import argparse
import hashlib
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_TEMPLATE = ROOT / "skeletons" / "nop_k_gfx926.hsaco"

ELF_HEADER = struct.Struct("<16sHHIQQQIHHHHHH")
SECTION_HEADER = struct.Struct("<IIQQQQIIQQ")
PROGRAM_HEADER = struct.Struct("<IIQQQQQQ")


def align(value: int, alignment: int) -> int:
    return (value + alignment - 1) // alignment * alignment


def parse_elf(data: bytes):
    if data[:4] != b"\x7fELF" or data[4] != 2:
        raise SystemExit("template is not ELF64")
    header = ELF_HEADER.unpack_from(data, 0)
    e_phoff, e_shoff = header[5], header[6]
    e_phentsize, e_phnum = header[9], header[10]
    e_shentsize, e_shnum, e_shstrndx = header[11], header[12], header[13]
    sections = []
    for i in range(e_shnum):
        off = e_shoff + i * e_shentsize
        values = SECTION_HEADER.unpack_from(data, off)
        sections.append({
            "name_off": values[0], "type": values[1], "flags": values[2],
            "addr": values[3], "offset": values[4], "size": values[5],
            "link": values[6], "info": values[7], "align": values[8], "entsize": values[9],
            "data": b"",
            "name": "",
        })
    shstr = sections[e_shstrndx]
    shstr_data = data[shstr["offset"]:shstr["offset"] + shstr["size"]]
    for sec in sections:
        start = sec["name_off"]
        end = shstr_data.find(b"\0", start)
        sec["name"] = shstr_data[start:end].decode("utf-8", "replace")
        sec["data"] = data[sec["offset"]:sec["offset"] + sec["size"]]
    program_headers = []
    for i in range(e_phnum):
        off = e_phoff + i * e_phentsize
        values = PROGRAM_HEADER.unpack_from(data, off)
        program_headers.append({
            "type": values[0], "flags": values[1], "offset": values[2],
            "vaddr": values[3], "paddr": values[4], "filesz": values[5],
            "memsz": values[6], "align": values[7],
        })
    return header, sections, program_headers


def build_section_header(sec: dict) -> bytes:
    return SECTION_HEADER.pack(
        sec["name_off"], sec["type"], sec["flags"], sec["addr"], sec["offset"],
        sec["size"], sec["link"], sec["info"], sec["align"], sec["entsize"])


def build_program_header(ph: dict) -> bytes:
    return PROGRAM_HEADER.pack(
        ph["type"], ph["flags"], ph["offset"], ph["vaddr"], ph["paddr"],
        ph["filesz"], ph["memsz"], ph["align"])


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path, help="assembled raw machine code for nop_k")
    ap.add_argument("output", type=Path)
    ap.add_argument("--template", type=Path, default=DEFAULT_TEMPLATE)
    args = ap.parse_args()

    template = args.template.read_bytes()
    header, sections, _phs = parse_elf(template)
    code = args.input.read_bytes()
    if len(code) % 4:
        raise SystemExit("code size must be a multiple of 4")

    by_name = {s["name"]: s for s in sections}
    text = by_name[".text"]
    rodata = by_name[".rodata"]
    dynamic = by_name[".dynamic"]
    comment = by_name[".comment"]
    symtab = by_name[".symtab"]
    shstrtab = by_name[".shstrtab"]
    strtab = by_name[".strtab"]
    note = by_name[".note"]

    # Program-header layout: keep the template's read-only area, then place a
    # variable-size code segment, then the dynamic section and string tables.
    text_file = 0x500
    text_vaddr = 0x1500
    text_size = align(len(code), 4)
    dynamic_file = align(text_file + text_size, 0x1000)
    dynamic_vaddr = 0x20000 + (dynamic_file & 0xFFF)
    dynamic_size = dynamic["size"]
    comment_file = dynamic_file + dynamic_size
    comment_size = comment["size"]
    symtab_file = align(comment_file + comment_size, 8)
    symtab_size = symtab["size"]
    strtab_file = symtab_file + symtab_size
    strtab_size = strtab["size"]
    shstrtab_file = strtab_file + strtab_size
    shstrtab_size = shstrtab["size"]
    shoff = align(shstrtab_file + shstrtab_size, 8)

    # Sections that stay at their template addresses.
    note["offset"], note["addr"] = 0x200, 0x200
    for name in (".dynsym", ".gnu.hash", ".hash", ".dynstr", ".rodata"):
        by_name[name]["offset"] = by_name[name]["addr"]
    text["offset"], text["addr"], text["size"], text["data"] = text_file, text_vaddr, text_size, code
    dynamic["offset"], dynamic["addr"], dynamic["size"], dynamic["data"] = (
        dynamic_file, dynamic_vaddr, dynamic_size, dynamic["data"])
    comment["offset"], comment["addr"] = comment_file, 0
    symtab["offset"], symtab["addr"] = symtab_file, 0
    strtab["offset"], strtab["addr"] = strtab_file, 0
    shstrtab["offset"], shstrtab["addr"] = shstrtab_file, 0

    # Program headers: same shape as the nop code object, adjusted for .text.
    phdrs = []
    phdrs.append({"type": 6, "flags": 4, "offset": 0x40, "vaddr": 0x40, "paddr": 0x40,
                  "filesz": 0x1C0, "memsz": 0x1C0, "align": 8})
    phdrs.append({"type": 1, "flags": 4, "offset": 0, "vaddr": 0, "paddr": 0,
                  "filesz": 0x4C0, "memsz": 0x4C0, "align": 0x1000})
    phdrs.append({"type": 1, "flags": 5, "offset": text_file, "vaddr": text_vaddr,
                  "paddr": text_vaddr, "filesz": text_size, "memsz": text_size, "align": 0x1000})
    phdrs.append({"type": 1, "flags": 6, "offset": dynamic_file, "vaddr": dynamic_vaddr,
                  "paddr": dynamic_vaddr, "filesz": dynamic_size, "memsz": dynamic_size, "align": 0x1000})
    phdrs.append({"type": 2, "flags": 6, "offset": dynamic_file, "vaddr": dynamic_vaddr,
                  "paddr": dynamic_vaddr, "filesz": dynamic_size, "memsz": dynamic_size, "align": 8})
    phdrs.append({"type": 0x6474E552, "flags": 4, "offset": dynamic_file, "vaddr": dynamic_vaddr,
                  "paddr": dynamic_vaddr, "filesz": dynamic_size, "memsz": dynamic_size, "align": 1})
    phdrs.append({"type": 0x6474E551, "flags": 6, "offset": 0, "vaddr": 0, "paddr": 0,
                  "filesz": 0, "memsz": 0, "align": 0})
    phdrs.append({"type": 7, "flags": 4, "offset": note["offset"], "vaddr": note["addr"],
                  "paddr": note["addr"], "filesz": note["size"], "memsz": note["size"], "align": 4})

    # ELF header: same identity as the template, new section-header offset.
    e_ident = header[0]
    elf = bytearray()
    elf.extend(ELF_HEADER.pack(
        e_ident, header[1], header[2], header[3], header[4], 0x40, shoff,
        header[7], header[8], 0x38, len(phdrs), 0x40, len(sections), header[13]))
    for ph in phdrs:
        elf.extend(build_program_header(ph))
    elf.extend(b"\0" * (0x200 - len(elf)))

    def put(sec: dict, data: bytes) -> None:
        if len(elf) < sec["offset"]:
            elf.extend(b"\0" * (sec["offset"] - len(elf)))
        end = sec["offset"] + len(data)
        if len(elf) < end:
            elf.extend(b"\0" * (end - len(elf)))
        elf[sec["offset"]:end] = data

    for name in (".note", ".dynsym", ".gnu.hash", ".hash", ".dynstr", ".rodata"):
        put(by_name[name], by_name[name]["data"])
    put(text, code)
    put(dynamic, dynamic["data"])
    put(comment, comment["data"])
    put(symtab, symtab["data"])
    put(strtab, strtab["data"])
    put(shstrtab, shstrtab["data"])
    if len(elf) < shoff:
        elf.extend(b"\0" * (shoff - len(elf)))
    for sec in sections:
        elf.extend(build_section_header(sec))

    args.output.write_bytes(elf)
    sha = hashlib.sha256(elf).hexdigest()
    print(f"wrote {args.output}: {len(elf)} bytes, sha256={sha}")
    print(f"text: vaddr=0x{text_vaddr:x} offset=0x{text_file:x} size={text_size}")


if __name__ == "__main__":
    main()
