#!/usr/bin/env python3
"""Generate a gfx926 HSACO with .rela.text dynamic relocations."""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path

from make_hsaco_full import (
    ELF_HEADER, PROGRAM_HEADER, SECTION_HEADER, align, build_descriptor,
    build_hashes, msgpack,
)


R_AMDGPU_32_LOW = 1
R_AMDGPU_32_HIGH = 2


def build_metadata(name: str, args: list[dict], kernarg_size: int, kernarg_align: int,
                   sgpr: int, vgpr: int, group: int, private: int) -> bytes:
    kernel = {
        ".args": args,
        ".fp64_status": 0,
        ".group_segment_fixed_size": group,
        ".kernarg_segment_align": kernarg_align,
        ".kernarg_segment_size": kernarg_size,
        ".language": "OpenCL C",
        ".language_version": [2, 0],
        ".max_flat_workgroup_size": 256,
        ".name": name,
        ".private_segment_fixed_size": private,
        ".sgpr_count": sgpr,
        ".sgpr_spill_count": 0,
        ".symbol": name + ".kd",
        ".uniform_work_group_size": 1,
        ".uses_dynamic_stack": False,
        ".vgpr_count": vgpr,
        ".vgpr_spill_count": 0,
        ".wavefront_size": 64,
    }
    return msgpack({
        "amdhsa.kernels": [kernel],
        "amdhsa.target": "amdgcn-amd-amdhsa--gfx926:sramecc+",
        "amdhsa.version": [1, 2],
    })


def build_elf(manifest: dict, name: str, args: list[dict], kernarg_size: int,
              kernarg_align: int, sgpr: int, vgpr: int, group: int, private: int) -> bytes:
    metadata = build_metadata(name, args, kernarg_size, kernarg_align, sgpr, vgpr, group, private)
    note = struct.pack("<III", 7, len(metadata), 0x20) + b"AMDGPU\0"
    note += b"\0" * ((-len(note)) % 4)
    note += metadata
    note += b"\0" * ((-len(note)) % 4)

    text = bytes.fromhex(manifest["text_hex"])
    data = bytes.fromhex(manifest["data_hex"])
    symbols = manifest["symbols"]
    relocs = manifest["relocations"]

    data_off = 0x1000
    data_vaddr = 0x1000
    rela_off = align(data_off + len(data), 8)
    rela_vaddr = rela_off

    # Dynamic symbol table: kernel, kernel.kd, then data symbols.
    symbol_list = [(name, "FUNC", 7, 0, len(text)), (name + ".kd", "OBJECT", 6, 0, 64)]
    data_names = [n for n, s in symbols.items() if s["section"] == "data"]
    for n in data_names:
        symbol_list.append((n, "OBJECT", 13, symbols[n]["offset"], symbols[n].get("size", 0)))
    sym_index = {entry[0]: i + 1 for i, entry in enumerate(symbol_list)}

    dynstr = bytearray(b"\0")
    name_off = {}
    for sym_name, _kind, _shndx, _value, _size in symbol_list:
        name_off[sym_name] = len(dynstr)
        dynstr.extend(sym_name.encode() + b"\0")
    gnu_hash_data, sysv_hash_data = build_hashes([s[0] for s in symbol_list])

    note_off = 0x200
    dynsym_off = align(note_off + len(note), 8)
    dynsym_size = 24 * (1 + len(symbol_list))
    gnu_off = align(dynsym_off + dynsym_size, 8)
    hash_off = align(gnu_off + len(gnu_hash_data), 4)
    dynstr_off = align(hash_off + len(sysv_hash_data), 1)
    rodata_off = align(dynstr_off + len(dynstr), 64)
    rodata_vaddr = rodata_off
    text_off = 0x2000
    text_vaddr = 0x4000
    dynamic_off = align(text_off + len(text), 0x1000)
    dynamic_vaddr = 0x10000 + dynamic_off

    descriptor = build_descriptor(text_vaddr - rodata_vaddr, kernarg_size, sgpr, vgpr)

    dynsym = bytearray(b"\0" * 24)
    for sym_name, kind, shndx, value, size in symbol_list:
        if sym_name == name:
            st_value = text_vaddr
        elif sym_name == name + ".kd":
            st_value = rodata_vaddr
        else:
            st_value = data_vaddr + value
        st_info = 0x12 if kind == "FUNC" else 0x11
        dynsym += struct.pack("<IBBHQQ", name_off[sym_name], st_info, 3, shndx, st_value, size)

    rela = bytearray()
    for rel in relocs:
        if rel["section"] != "text":
            continue
        idx = sym_index[rel["symbol"]]
        rtype = R_AMDGPU_32_LOW if rel["type"] == "abs32_lo" else R_AMDGPU_32_HIGH
        r_info = (idx << 32) | rtype
        rela += struct.pack("<QQq", text_vaddr + rel["offset"], r_info, 0)

    dyn_entries = [
        (6, dynsym_off), (0x0B, 24), (5, dynstr_off), (0x0A, len(dynstr)),
        (0x6FFFFEF5, gnu_off), (4, hash_off),
        (7, rela_vaddr), (8, len(rela)), (9, 24),
    ]
    dynamic = b"".join(struct.pack("<qQ", t, v) for t, v in dyn_entries) + b"\0" * 16
    comment = b"k100lc-asm relocation HSACO\0"

    strtab = bytearray(b"\0")
    symtab = bytearray(b"\0" * 24)
    for sym_name, kind, shndx, value, size in symbol_list:
        if sym_name == name:
            st_value = text_vaddr
        elif sym_name == name + ".kd":
            st_value = rodata_vaddr
        else:
            st_value = data_vaddr + value
        off = len(strtab)
        strtab.extend(sym_name.encode() + b"\0")
        st_info = 0x12 if kind == "FUNC" else 0x11
        symtab += struct.pack("<IBBHQQ", off, st_info, 3, shndx, st_value, size)

    comment_off = dynamic_off + len(dynamic)
    symtab_off = align(comment_off + len(comment), 8)
    strtab_off = symtab_off + len(symtab)
    shstrtab_off = strtab_off + len(strtab)
    shstrtab = (b"\0.note\0.dynsym\0.gnu.hash\0.hash\0.dynstr\0.rodata\0.text\0"
                b".dynamic\0.comment\0.symtab\0.shstrtab\0.strtab\0.data\0.rela.text\0")
    shoff = align(shstrtab_off + len(shstrtab), 8)

    # Section indices: note=1 ... text=7, dynamic=8, comment=9, symtab=10,
    # shstrtab=11, strtab=12, data=13, rela.text=14.
    text_size = align(len(text), 4)
    phdrs = [
        (6, 4, 0x40, 0x40, 0x40, 0x1C0, 0x1C0, 8),
        (1, 4, 0, 0, 0, rela_off + len(rela), rela_off + len(rela), 0x1000),
        (1, 5, text_off, text_vaddr, text_vaddr, text_size, text_size, 0x1000),
        (1, 6, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 0x1000),
        (2, 6, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 8),
        (0x6474E552, 4, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 1),
        (0x6474E551, 6, 0, 0, 0, 0, 0, 0),
        (4, 4, note_off, note_off, note_off, len(note), len(note), 4),
    ]

    def sh(name_off, typ, flags, addr, off, size, link=0, info=0, al=1, entsize=0):
        return {"name_off": name_off, "type": typ, "flags": flags, "addr": addr,
                "offset": off, "size": size, "link": link, "info": info,
                "align": al, "entsize": entsize}

    sec_names = [".note", ".dynsym", ".gnu.hash", ".hash", ".dynstr", ".rodata",
                 ".text", ".dynamic", ".comment", ".symtab", ".shstrtab", ".strtab",
                 ".data", ".rela.text"]
    name_off_sec = {}
    pos = 1
    for n in sec_names:
        name_off_sec[n] = pos
        pos += len(n) + 1
    sections = [
        sh(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        sh(name_off_sec[".note"], 7, 2, note_off, note_off, len(note), 0, 0, 4, 0),
        sh(name_off_sec[".dynsym"], 11, 2, dynsym_off, dynsym_off, len(dynsym), 5, 1, 8, 24),
        sh(name_off_sec[".gnu.hash"], 0x6FFFFFF6, 2, gnu_off, gnu_off, len(gnu_hash_data), 2, 0, 8, 0),
        sh(name_off_sec[".hash"], 5, 2, hash_off, hash_off, len(sysv_hash_data), 2, 0, 4, 4),
        sh(name_off_sec[".dynstr"], 3, 2, dynstr_off, dynstr_off, len(dynstr), 0, 0, 1, 0),
        sh(name_off_sec[".rodata"], 1, 2, rodata_vaddr, rodata_off, 64, 0, 0, 64, 0),
        sh(name_off_sec[".text"], 1, 6, text_vaddr, text_off, text_size, 0, 0, 256, 0),
        sh(name_off_sec[".dynamic"], 6, 3, dynamic_vaddr, dynamic_off, len(dynamic), 5, 0, 8, 16),
        sh(name_off_sec[".comment"], 1, 0x30, 0, comment_off, len(comment), 0, 0, 1, 1),
        sh(name_off_sec[".symtab"], 2, 0, 0, symtab_off, len(symtab), 12, 2, 8, 24),
        sh(name_off_sec[".shstrtab"], 3, 0, 0, shstrtab_off, len(shstrtab), 0, 0, 1, 0),
        sh(name_off_sec[".strtab"], 3, 0, 0, strtab_off, len(strtab), 0, 0, 1, 0),
        sh(name_off_sec[".data"], 1, 2, data_vaddr, data_off, len(data), 0, 0, 8, 0),
        sh(name_off_sec[".rela.text"], 4, 2, rela_vaddr, rela_off, len(rela), 2, 7, 8, 24),
    ]

    out = bytearray()
    out.extend(ELF_HEADER.pack(
        b"\x7fELF\x02\x01\x01\x40\x03" + b"\0" * 7,
        3, 0xE0, 1, 0, 0x40, shoff, 0xD81, 0x40, 0x38, len(phdrs),
        0x40, len(sections), 11))
    for ph in phdrs:
        out.extend(PROGRAM_HEADER.pack(*ph))
    pieces = [
        (note_off, note), (dynsym_off, bytes(dynsym)), (gnu_off, gnu_hash_data),
        (hash_off, sysv_hash_data), (dynstr_off, bytes(dynstr)), (rodata_off, descriptor),
        (data_off, data), (rela_off, bytes(rela)), (text_off, text),
        (dynamic_off, dynamic), (comment_off, comment),
        (symtab_off, bytes(symtab)), (strtab_off, bytes(strtab)), (shstrtab_off, shstrtab),
    ]
    for off, blob in pieces:
        if len(out) < off:
            out.extend(b"\0" * (off - len(out)))
        end = off + len(blob)
        if len(out) < end:
            out.extend(b"\0" * (end - len(out)))
        out[off:end] = blob
    if len(out) < shoff:
        out.extend(b"\0" * (shoff - len(out)))
    for sec in sections:
        out.extend(SECTION_HEADER.pack(
            sec["name_off"], sec["type"], sec["flags"], sec["addr"], sec["offset"],
            sec["size"], sec["link"], sec["info"], sec["align"], sec["entsize"]))
    return bytes(out)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("manifest", type=Path)
    ap.add_argument("output", type=Path)
    ap.add_argument("--name", required=True)
    ap.add_argument("--args", type=Path)
    ap.add_argument("--kernarg-size", type=int, default=0)
    ap.add_argument("--kernarg-align", type=int, default=4)
    ap.add_argument("--sgpr-count", type=int, default=4)
    ap.add_argument("--vgpr-count", type=int, default=0)
    ap.add_argument("--group-segment", type=int, default=0)
    ap.add_argument("--private-segment", type=int, default=0)
    args = ap.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    arg_meta = json.loads(args.args.read_text(encoding="utf-8")) if args.args else []
    elf = build_elf(manifest, args.name, arg_meta, args.kernarg_size, args.kernarg_align,
                    args.sgpr_count, args.vgpr_count, args.group_segment, args.private_segment)
    args.output.write_bytes(elf)
    print(f"wrote {args.output}: {len(elf)} bytes, sha256={hashlib.sha256(elf).hexdigest()}")
    print(f"kernel={args.name} text={len(bytes.fromhex(manifest['text_hex']))} "
          f"data={len(bytes.fromhex(manifest['data_hex']))} relocs={len(manifest['relocations'])}")


if __name__ == "__main__":
    main()
