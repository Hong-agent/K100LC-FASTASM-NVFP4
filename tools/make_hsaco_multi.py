#!/usr/bin/env python3
"""Generate one gfx926 HSACO containing multiple kernels and symbols."""

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


def load_kernels(spec_path: Path) -> list[dict]:
    spec = json.loads(spec_path.read_text(encoding="utf-8"))
    kernels = []
    for item in spec:
        code_path = Path(item["code"])
        if not code_path.is_absolute():
            code_path = spec_path.parent / code_path
        args = item.get("args", [])
        if isinstance(args, str):
            args_path = Path(args)
            if not args_path.is_absolute():
                args_path = spec_path.parent / args_path
            args = json.loads(args_path.read_text(encoding="utf-8"))
        kernels.append({
            "name": item["name"],
            "code": code_path.read_bytes(),
            "args": args,
            "kernarg_size": int(item.get("kernarg_size", 0)),
            "kernarg_align": int(item.get("kernarg_align", 4)),
            "sgpr_count": int(item.get("sgpr_count", 4)),
            "vgpr_count": int(item.get("vgpr_count", 0)),
            "group_segment": int(item.get("group_segment", 0)),
            "private_segment": int(item.get("private_segment", 0)),
            "rsrc1": item.get("rsrc1"),
            "rsrc2": item.get("rsrc2"),
            "props": item.get("props"),
        })
    return kernels


def build_metadata(kernels: list[dict]) -> bytes:
    kernel_meta = []
    for k in kernels:
        kernel_meta.append({
            ".args": k["args"],
            ".fp64_status": 0,
            ".group_segment_fixed_size": k["group_segment"],
            ".kernarg_segment_align": k["kernarg_align"],
            ".kernarg_segment_size": k["kernarg_size"],
            ".language": "OpenCL C",
            ".language_version": [2, 0],
            ".max_flat_workgroup_size": 256,
            ".name": k["name"],
            ".private_segment_fixed_size": k["private_segment"],
            ".sgpr_count": k["sgpr_count"],
            ".sgpr_spill_count": 0,
            ".symbol": k["name"] + ".kd",
            ".uniform_work_group_size": 1,
            ".uses_dynamic_stack": False,
            ".vgpr_count": k["vgpr_count"],
            ".vgpr_spill_count": 0,
            ".wavefront_size": 64,
        })
    return msgpack({
        "amdhsa.kernels": kernel_meta,
        "amdhsa.target": "amdgcn-amd-amdhsa--gfx926:sramecc+",
        "amdhsa.version": [1, 2],
    })


def build_elf(kernels: list[dict]) -> bytes:
    metadata = build_metadata(kernels)
    note = struct.pack("<III", 7, len(metadata), 0x20) + b"AMDGPU\0"
    note += b"\0" * ((-len(note)) % 4)
    note += metadata
    note += b"\0" * ((-len(note)) % 4)

    names = []
    dynstr = bytearray(b"\0")
    name_offsets = {}
    for k in kernels:
        for name in (k["name"], k["name"] + ".kd"):
            name_offsets[name] = len(dynstr)
            dynstr.extend(name.encode() + b"\0")
            names.append(name)
    gnu_hash_data, sysv_hash_data = build_hashes(names)

    text_offsets = []
    off = 0
    for k in kernels:
        text_offsets.append(off)
        off = align(off + len(k["code"]), 256)
    text_size = off

    note_off = 0x200
    dynsym_off = align(note_off + len(note), 8)
    gnu_off = align(dynsym_off + 24 * (1 + 2 * len(kernels)), 8)
    hash_off = align(gnu_off + len(gnu_hash_data), 4)
    dynstr_off = align(hash_off + len(sysv_hash_data), 1)
    rodata_off = align(dynstr_off + len(dynstr), 64)
    rodata_vaddr = rodata_off
    # Keep the text segment above the descriptors so the (signed) kernel code
    # entry offsets stored in each descriptor stay positive.  The kernel
    # descriptor's entry field is only meaningful as a small positive delta.
    text_off = align(rodata_off + 64 * len(kernels), 0x1000)
    text_vaddr = text_off
    dynamic_off = align(text_off + text_size, 0x1000)
    dynamic_vaddr = dynamic_off

    dynsym = bytearray(b"\0" * 24)
    for i, k in enumerate(kernels):
        entry = text_vaddr + text_offsets[i]
        desc = rodata_vaddr + i * 64
        dynsym += struct.pack("<IBBHQQ", name_offsets[k["name"]], 0x12, 3, 7, entry, len(k["code"]))
        dynsym += struct.pack("<IBBHQQ", name_offsets[k["name"] + ".kd"], 0x11, 3, 6, desc, 64)

    rodata = bytearray()
    for i, k in enumerate(kernels):
        entry = text_vaddr + text_offsets[i]
        rodata += build_descriptor(entry - (rodata_vaddr + i * 64),
                                   k["kernarg_size"], k["sgpr_count"], k["vgpr_count"],
                                   k["group_segment"], k["private_segment"],
                                   k.get("rsrc1"), k.get("rsrc2"), k.get("props"))
    text = bytearray()
    for i, k in enumerate(kernels):
        if len(text) < text_offsets[i]:
            text.extend(b"\0" * (text_offsets[i] - len(text)))
        text.extend(k["code"])

    dyn_entries = [
        (6, dynsym_off), (0x0B, 24), (5, dynstr_off), (0x0A, len(dynstr)),
        (0x6FFFFEF5, gnu_off), (4, hash_off),
    ]
    dynamic = b"".join(struct.pack("<qQ", t, v) for t, v in dyn_entries) + b"\0" * 16
    comment = b"k100lc-asm multi-kernel HSACO\0"

    # .symtab + .strtab
    strtab = bytearray(b"\0")
    symname = {}
    for k in kernels:
        for name in (k["name"], k["name"] + ".kd"):
            symname[name] = len(strtab)
            strtab.extend(name.encode() + b"\0")
    symtab = bytearray(b"\0" * 24)
    for i, k in enumerate(kernels):
        entry = text_vaddr + text_offsets[i]
        desc = rodata_vaddr + i * 64
        symtab += struct.pack("<IBBHQQ", symname[k["name"]], 0x12, 3, 7, entry, len(k["code"]))
        symtab += struct.pack("<IBBHQQ", symname[k["name"] + ".kd"], 0x11, 3, 6, desc, 64)

    comment_off = dynamic_off + len(dynamic)
    symtab_off = align(comment_off + len(comment), 8)
    strtab_off = symtab_off + len(symtab)
    shstrtab_off = strtab_off + len(strtab)
    shstrtab = b"\0.note\0.dynsym\0.gnu.hash\0.hash\0.dynstr\0.rodata\0.text\0.dynamic\0.comment\0.symtab\0.shstrtab\0.strtab\0"
    shoff = align(shstrtab_off + len(shstrtab), 8)

    phdrs = [
        (6, 4, 0x40, 0x40, 0x40, 0x1C0, 0x1C0, 8),
        (1, 4, 0, 0, 0, rodata_off + 64 * len(kernels), rodata_off + 64 * len(kernels), 0x1000),
        (1, 5, text_off, text_vaddr, text_vaddr, text_size, text_size, 0x1000),
        (1, 6, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 0x1000),
        (2, 6, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 8),
        (0x6474E552, 4, dynamic_off, dynamic_vaddr, dynamic_vaddr, len(dynamic), len(dynamic), 1),
        (0x6474E551, 6, 0, 0, 0, 0, 0, 0),
        (4, 4, note_off, note_off, note_off, len(note), len(note), 4),
    ]

    def sh(name_off, typ, flags, addr, off_, size, link=0, info=0, al=1, entsize=0):
        return {"name_off": name_off, "type": typ, "flags": flags, "addr": addr,
                "offset": off_, "size": size, "link": link, "info": info,
                "align": al, "entsize": entsize}

    section_names = [".note", ".dynsym", ".gnu.hash", ".hash", ".dynstr", ".rodata",
                     ".text", ".dynamic", ".comment", ".symtab", ".shstrtab", ".strtab"]
    name_off = {}
    pos = 1
    for n in section_names:
        name_off[n] = pos
        pos += len(n) + 1
    sections = [
        sh(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        sh(name_off[".note"], 7, 2, note_off, note_off, len(note), 0, 0, 4, 0),
        sh(name_off[".dynsym"], 11, 2, dynsym_off, dynsym_off, len(dynsym), 5, 1, 8, 24),
        sh(name_off[".gnu.hash"], 0x6FFFFFF6, 2, gnu_off, gnu_off, len(gnu_hash_data), 2, 0, 8, 0),
        sh(name_off[".hash"], 5, 2, hash_off, hash_off, len(sysv_hash_data), 2, 0, 4, 4),
        sh(name_off[".dynstr"], 3, 2, dynstr_off, dynstr_off, len(dynstr), 0, 0, 1, 0),
        sh(name_off[".rodata"], 1, 2, rodata_vaddr, rodata_off, len(rodata), 0, 0, 64, 0),
        sh(name_off[".text"], 1, 6, text_vaddr, text_off, text_size, 0, 0, 256, 0),
        sh(name_off[".dynamic"], 6, 3, dynamic_vaddr, dynamic_off, len(dynamic), 5, 0, 8, 16),
        sh(name_off[".comment"], 1, 0x30, 0, comment_off, len(comment), 0, 0, 1, 1),
        sh(name_off[".symtab"], 2, 0, 0, symtab_off, len(symtab), 12, 2, 8, 24),
        sh(name_off[".shstrtab"], 3, 0, 0, shstrtab_off, len(shstrtab), 0, 0, 1, 0),
        sh(name_off[".strtab"], 3, 0, 0, strtab_off, len(strtab), 0, 0, 1, 0),
    ]

    data = bytearray()
    data.extend(ELF_HEADER.pack(
        b"\x7fELF\x02\x01\x01\x40\x03" + b"\0" * 7,
        3, 0xE0, 1, 0, 0x40, shoff, 0xD81, 0x40, 0x38, len(phdrs),
        0x40, len(sections), 11))
    for ph in phdrs:
        data.extend(PROGRAM_HEADER.pack(*ph))
    pieces = [
        (note_off, note), (dynsym_off, bytes(dynsym)), (gnu_off, gnu_hash_data),
        (hash_off, sysv_hash_data), (dynstr_off, bytes(dynstr)), (rodata_off, bytes(rodata)),
        (text_off, bytes(text)), (dynamic_off, dynamic), (comment_off, comment),
        (symtab_off, bytes(symtab)), (strtab_off, bytes(strtab)), (shstrtab_off, shstrtab),
    ]
    for off_, blob in pieces:
        if len(data) < off_:
            data.extend(b"\0" * (off_ - len(data)))
        end = off_ + len(blob)
        if len(data) < end:
            data.extend(b"\0" * (end - len(data)))
        data[off_:end] = blob
    if len(data) < shoff:
        data.extend(b"\0" * (shoff - len(data)))
    for sec in sections:
        data.extend(SECTION_HEADER.pack(
            sec["name_off"], sec["type"], sec["flags"], sec["addr"], sec["offset"],
            sec["size"], sec["link"], sec["info"], sec["align"], sec["entsize"]))
    return bytes(data)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("spec", type=Path)
    ap.add_argument("output", type=Path)
    args = ap.parse_args()
    kernels = load_kernels(args.spec)
    elf = build_elf(kernels)
    args.output.write_bytes(elf)
    print(f"wrote {args.output}: {len(elf)} bytes, "
          f"sha256={hashlib.sha256(elf).hexdigest()}")
    for i, k in enumerate(kernels):
        print(f"  [{i}] {k['name']}: text={len(k['code'])} kernarg={k['kernarg_size']}")


if __name__ == "__main__":
    main()
