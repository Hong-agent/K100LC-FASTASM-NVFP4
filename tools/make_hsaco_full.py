#!/usr/bin/env python3
"""Fully generate a minimal gfx926 HSACO: metadata, symbols, hashes, descriptor."""

from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

ELF_HEADER = struct.Struct("<16sHHIQQQIHHHHHH")
SECTION_HEADER = struct.Struct("<IIQQQQIIQQ")
PROGRAM_HEADER = struct.Struct("<IIQQQQQQ")


def align(v: int, a: int) -> int:
    return (v + a - 1) // a * a


def msgpack(obj) -> bytes:
    if obj is None:
        return b"\xc0"
    if obj is True:
        return b"\xc3"
    if obj is False:
        return b"\xc2"
    if isinstance(obj, int):
        if 0 <= obj < 128:
            return bytes([obj])
        if -32 <= obj < 0:
            return bytes([obj & 0xFF])
        if obj >= 0:
            if obj <= 0xFF:
                return b"\xcc" + bytes([obj])
            if obj <= 0xFFFF:
                return b"\xcd" + struct.pack(">H", obj)
            if obj <= 0xFFFFFFFF:
                return b"\xce" + struct.pack(">I", obj)
            return b"\xcf" + struct.pack(">Q", obj)
        if obj >= -128:
            return b"\xd0" + struct.pack(">b", obj)
        if obj >= -32768:
            return b"\xd1" + struct.pack(">h", obj)
        return b"\xd2" + struct.pack(">i", obj)
    if isinstance(obj, str):
        data = obj.encode()
        n = len(data)
        if n < 32:
            return bytes([0xA0 | n]) + data
        if n <= 0xFF:
            return b"\xd9" + bytes([n]) + data
        return b"\xda" + struct.pack(">H", n) + data
    if isinstance(obj, (list, tuple)):
        n = len(obj)
        out = bytes([0x90 | n]) if n < 16 else b"\xdc" + struct.pack(">H", n)
        return out + b"".join(msgpack(x) for x in obj)
    if isinstance(obj, dict):
        n = len(obj)
        out = bytes([0x80 | n]) if n < 16 else b"\xde" + struct.pack(">H", n)
        for k, v in obj.items():
            out += msgpack(k) + msgpack(v)
        return out
    raise TypeError(type(obj))


def sysv_hash(name: str) -> int:
    h = 0
    for c in name.encode():
        h = (h << 4) + c
        g = h & 0xF0000000
        if g:
            h ^= g >> 24
        h &= ~g
    return h & 0xFFFFFFFF


def gnu_hash(name: str) -> int:
    h = 5381
    for c in name.encode():
        h = ((h << 5) + h + c) & 0xFFFFFFFF
    return h


def build_metadata(name: str, symbol: str, args: list[dict], kernarg_size: int,
                   kernarg_align: int, sgpr: int, vgpr: int, group: int, private: int) -> bytes:
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
        ".symbol": symbol,
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


def build_descriptor(entry_offset: int, kernarg_size: int, sgpr: int, vgpr: int,
                     group_segment: int = 0, private_segment: int = 0,
                     rsrc1: int | None = None, rsrc2: int | None = None,
                     props: int | None = None) -> bytes:
    # gfx9 COMPUTE_PGM_RSRC1: VGPRS is in units of 4 (minus one), SGPRS in
    # units of 8 (minus one).  Using units of 8 under-allocates VGPRs and
    # corrupts kernels that use more than 8 registers.
    vgpr_gran = max(0, (vgpr + 3) // 4 - 1)
    sgpr_gran = max(0, (sgpr - 1) // 8)
    if rsrc1 is None:
        rsrc1 = 0x00AF0000 | (vgpr_gran & 0x3F) | ((sgpr_gran & 0xF) << 6)
    if rsrc2 is None:
        user_sgpr = 6 if kernarg_size else 4
        # bit 7: workgroup id x enabled (all shipped kernels use blockIdx.x)
        rsrc2 = 0x80 | ((user_sgpr & 0x1F) << 1)
    if props is None:
        # bit0 private segment buffer, bit3 kernarg pointer,
        # bit5 private segment size (only when a private segment exists)
        props = 0x9 | (0x20 if private_segment else 0)
    properties = props
    desc = bytearray(64)
    struct.pack_into("<I", desc, 0x00, group_segment)
    struct.pack_into("<I", desc, 0x04, private_segment)
    struct.pack_into("<Q", desc, 0x08, kernarg_size)
    struct.pack_into("<q", desc, 0x10, entry_offset)
    struct.pack_into("<I", desc, 0x30, rsrc1)
    struct.pack_into("<I", desc, 0x34, rsrc2)
    struct.pack_into("<I", desc, 0x38, properties)
    return bytes(desc)


def build_hashes(names: list[str]) -> tuple[bytes, bytes]:
    # SysV hash: one bucket keeps this simple and valid.
    nbucket, nchain = 3, len(names) + 1
    buckets = [0] * nbucket
    chains = [0] * nchain
    # Prepend new symbols; this matches the reference object's chain order.
    for i, name in enumerate(names, 1):
        b = sysv_hash(name) % nbucket
        if buckets[b] == 0:
            buckets[b] = i
        else:
            idx = buckets[b]
            buckets[b] = i
            chains[i] = idx
    sysv = struct.pack("<II", nbucket, nchain) + b"".join(struct.pack("<I", x) for x in buckets + chains)

    # GNU hash: one bucket.
    ghashes = [gnu_hash(n) for n in names]
    bloom = 0
    for h in ghashes:
        bloom |= 1 << (h % 64)
        bloom |= 1 << ((h >> 26) % 64)
    gnu = struct.pack("<IIII", 1, 1, 1, 26) + struct.pack("<Q", bloom)
    gnu += struct.pack("<I", 1)
    for i, h in enumerate(ghashes):
        chain = h & ~1
        if i == len(ghashes) - 1:
            chain |= 1
        gnu += struct.pack("<I", chain)
    return gnu, sysv


def build_elf(code: bytes, name: str, args: list[dict], kernarg_size: int,
              kernarg_align: int, sgpr: int, vgpr: int, group: int, private: int,
              data_bytes: bytes = b"", data_vaddr: int = 0x20000) -> bytes:
    symbol = name + ".kd"
    metadata = build_metadata(name, symbol, args, kernarg_size, kernarg_align, sgpr, vgpr, group, private)
    note = struct.pack("<III", 7, len(metadata), 0x20) + b"AMDGPU\0"
    note += b"\0" * ((-len(note)) % 4)
    note += metadata
    note += b"\0" * ((-len(note)) % 4)

    dynstr = b"\0" + name.encode() + b"\0" + symbol.encode() + b"\0"
    gnu_hash_data, sysv_hash_data = build_hashes([name, symbol])

    # Section indices: null=0, note=1, dynsym=2, gnu.hash=3, hash=4,
    # dynstr=5, rodata=6, text=7, dynamic=8, comment=9, symtab=10,
    # shstrtab=11, strtab=12.
    # Layout.
    note_off = 0x240 if data_bytes else 0x200
    dynsym_off = align(note_off + len(note), 8)
    gnu_off = align(dynsym_off + 72, 8)
    hash_off = align(gnu_off + len(gnu_hash_data), 4)
    dynstr_off = align(hash_off + len(sysv_hash_data), 1)
    rodata_off = align(dynstr_off + len(dynstr), 64)
    if data_bytes:
        data_off = 0x600
        data_vaddr = 0x600
        text_off = 0x1000
        text_vaddr = 0x2000
    else:
        data_off = 0
        data_vaddr = 0x20000
        text_off = align(rodata_off + 64, 0x1000)
        text_vaddr = 0x2000
    rodata_vaddr = rodata_off
    descriptor = build_descriptor(text_vaddr - rodata_vaddr, kernarg_size, sgpr, vgpr,
                                  group, private)

    dynsym = bytearray()
    dynsym += b"\0" * 24
    dynsym += struct.pack("<IBBHQQ", 1, 0x12, 3, 7, text_vaddr, len(code))
    dynsym += struct.pack("<IBBHQQ", 1 + len(name) + 1, 0x11, 3, 6, rodata_vaddr, 64)
    dynamic_off = align(text_off + len(code), 0x1000)
    dynamic_vaddr = 0x10000 + dynamic_off
    dynamic = struct.pack(
        "<qQQQQQQ",
        6, dynsym_off, 0, 0, 0, 0, 0)  # placeholder, rebuilt below with real addresses
    # Dynamic entries need section virtual addresses; sections use addr == offset
    # for the read-only load segment.
    dyn_entries = [
        (6, dynsym_off),        # DT_SYMTAB
        (0x0B, 24),             # DT_SYMENT
        (5, dynstr_off),        # DT_STRTAB
        (0x0A, len(dynstr)),    # DT_STRSZ
        (0x6FFFFEF5, gnu_off),  # DT_GNU_HASH
        (4, hash_off),          # DT_HASH
    ]
    dynamic = b"".join(struct.pack("<qQ", tag, val) for tag, val in dyn_entries) + b"\0" * 16
    comment = b"k100lc-asm from-scratch HSACO\0"

    # symtab/strtab are optional but useful for readelf.
    strtab = b"\0" + name.encode() + b"\0" + symbol.encode() + b"\0"
    symtab = b"\0" * 24
    symtab += struct.pack("<IBBHQQ", 1, 0x12, 3, 7, text_vaddr, len(code))
    symtab += struct.pack("<IBBHQQ", 1 + len(name) + 1, 0x11, 3, 6, rodata_vaddr, 64)
    comment_off = dynamic_off + len(dynamic)
    symtab_off = align(comment_off + len(comment), 8)
    strtab_off = symtab_off + len(symtab)
    shstrtab_off = strtab_off + len(strtab)
    shstrtab = b"\0.note\0.dynsym\0.gnu.hash\0.hash\0.dynstr\0.rodata\0.text\0.dynamic\0.comment\0.symtab\0.shstrtab\0.strtab\0.data\0"
    shoff = align(shstrtab_off + len(shstrtab), 8)

    # Program headers.
    text_size = align(len(code), 4)
    phdrs = [
        (6, 4, 0x40, 0x40, 0x40, 0x1C0, 0x1C0, 8),
        (1, 4, 0, 0, 0,
         (data_off + len(data_bytes)) if data_bytes else (rodata_off + len(descriptor)),
         (data_off + len(data_bytes)) if data_bytes else (rodata_off + len(descriptor)), 0x1000),
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

    # shstrtab offsets.
    names = [".note", ".dynsym", ".gnu.hash", ".hash", ".dynstr", ".rodata",
             ".text", ".dynamic", ".comment", ".symtab", ".shstrtab", ".strtab"]
    if data_bytes:
        names.append(".data")
    name_off = {}
    pos = 1
    for n in names:
        name_off[n] = pos
        pos += len(n) + 1
    sections = [
        sh(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        sh(name_off[".note"], 7, 2, note_off, note_off, len(note), 0, 0, 4, 0),
        sh(name_off[".dynsym"], 11, 2, dynsym_off, dynsym_off, len(dynsym), 5, 1, 8, 24),
        sh(name_off[".gnu.hash"], 0x6FFFFFF6, 2, gnu_off, gnu_off, len(gnu_hash_data), 2, 0, 8, 0),
        sh(name_off[".hash"], 5, 2, hash_off, hash_off, len(sysv_hash_data), 2, 0, 4, 4),
        sh(name_off[".dynstr"], 3, 2, dynstr_off, dynstr_off, len(dynstr), 0, 0, 1, 0),
        sh(name_off[".rodata"], 1, 2, rodata_vaddr, rodata_off, 64, 0, 0, 64, 0),
        sh(name_off[".text"], 1, 6, text_vaddr, text_off, text_size, 0, 0, 256, 0),
        sh(name_off[".dynamic"], 6, 3, dynamic_vaddr, dynamic_off, len(dynamic), 5, 0, 8, 16),
        sh(name_off[".comment"], 1, 0x30, 0, comment_off, len(comment), 0, 0, 1, 1),
        sh(name_off[".symtab"], 2, 0, 0, symtab_off, len(symtab), 12, 2, 8, 24),
        sh(name_off[".shstrtab"], 3, 0, 0, shstrtab_off, len(shstrtab), 0, 0, 1, 0),
        sh(name_off[".strtab"], 3, 0, 0, strtab_off, len(strtab), 0, 0, 1, 0),
    ]
    if data_bytes:
        sections.append(sh(name_off[".data"], 1, 3, data_vaddr, data_off,
                           len(data_bytes), 0, 0, 8, 0))

    data = bytearray()
    data.extend(ELF_HEADER.pack(
        b"\x7fELF\x02\x01\x01\x40\x03" + b"\0" * 7,
        3, 0xE0, 1, 0, 0x40, shoff, 0xD81, 0x40, 0x38, len(phdrs),
        0x40, len(sections), 11))
    for ph in phdrs:
        data.extend(PROGRAM_HEADER.pack(*ph))
    pieces = [
        (note_off, note), (dynsym_off, bytes(dynsym)), (gnu_off, gnu_hash_data),
        (hash_off, sysv_hash_data), (dynstr_off, dynstr), (rodata_off, descriptor),
        (text_off, code), (dynamic_off, dynamic), (comment_off, comment),
        (symtab_off, symtab), (strtab_off, strtab), (shstrtab_off, shstrtab),
    ]
    if data_bytes:
        pieces.append((data_off, data_bytes))
    for off, blob in pieces:
        if len(data) < off:
            data.extend(b"\0" * (off - len(data)))
        end = off + len(blob)
        if len(data) < end:
            data.extend(b"\0" * (end - len(data)))
        data[off:end] = blob
    if len(data) < shoff:
        data.extend(b"\0" * (shoff - len(data)))
    for sec in sections:
        data.extend(SECTION_HEADER.pack(
            sec["name_off"], sec["type"], sec["flags"], sec["addr"], sec["offset"],
            sec["size"], sec["link"], sec["info"], sec["align"], sec["entsize"]))
    return bytes(data)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path, help="assembled raw machine code")
    ap.add_argument("output", type=Path)
    ap.add_argument("--name", default="nop_k")
    ap.add_argument("--args", type=Path, help="JSON arg metadata")
    ap.add_argument("--kernarg-size", type=int, default=0)
    ap.add_argument("--kernarg-align", type=int, default=4)
    ap.add_argument("--sgpr-count", type=int, default=4)
    ap.add_argument("--vgpr-count", type=int, default=0)
    ap.add_argument("--group-segment", type=int, default=0)
    ap.add_argument("--private-segment", type=int, default=0)
    ap.add_argument("--data", type=Path, help="optional .data binary")
    ap.add_argument("--data-vaddr", type=lambda x: int(x, 0), default=0x20000)
    args = ap.parse_args()
    arg_meta = json.loads(args.args.read_text(encoding="utf-8")) if args.args else []
    elf = build_elf(args.input.read_bytes(), args.name, arg_meta, args.kernarg_size,
                    args.kernarg_align, args.sgpr_count, args.vgpr_count,
                    args.group_segment, args.private_segment,
                    data_bytes=args.data.read_bytes() if args.data else b"",
                    data_vaddr=args.data_vaddr)
    args.output.write_bytes(elf)
    print(f"wrote {args.output}: {len(elf)} bytes, sha256={hashlib.sha256(elf).hexdigest()}")
    print(f"kernel={args.name} symbol={args.name}.kd text={len(args.input.read_bytes())} bytes")


if __name__ == "__main__":
    main()
