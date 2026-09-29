#!/usr/bin/env python3
"""Merge multiple k100lc-asm-generated HSACOs into one code object."""

from __future__ import annotations

import argparse
import struct
from pathlib import Path

import msgpack

from make_hsaco_multi import build_elf


SECTION_HEADER = struct.Struct("<IIQQQQIIQQ")


def parse_sections(data: bytes) -> dict[str, dict]:
    shoff = struct.unpack_from("<Q", data, 0x28)[0]
    entsize, shnum, shstrndx = struct.unpack_from("<HHH", data, 0x3A)
    sections = []
    for i in range(shnum):
        values = SECTION_HEADER.unpack_from(data, shoff + i * entsize)
        sections.append({
            "name_off": values[0], "type": values[1], "flags": values[2],
            "addr": values[3], "offset": values[4], "size": values[5],
            "link": values[6], "entsize": values[9],
        })
    shstr = sections[shstrndx]
    names = data[shstr["offset"]:shstr["offset"] + shstr["size"]]
    for sec in sections:
        end = names.find(b"\0", sec["name_off"])
        sec["name"] = names[sec["name_off"]:end].decode()
        sec["data"] = data[sec["offset"]:sec["offset"] + sec["size"]]
    return {sec["name"]: sec for sec in sections}


def parse_symbols(sections: dict[str, dict]) -> dict[str, dict]:
    dynsym = sections[".dynsym"]
    dynstr = sections[".dynstr"]["data"]
    out = {}
    for i in range(dynsym["size"] // dynsym["entsize"]):
        off = i * dynsym["entsize"]
        st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack_from(
            "<IBBHQQ", dynsym["data"], off)
        end = dynstr.find(b"\0", st_name)
        name = dynstr[st_name:end].decode()
        if name:
            out[name] = {"value": st_value, "size": st_size,
                         "shndx": st_shndx, "info": st_info}
    return out


def parse_kernels(path: Path) -> list[dict]:
    data = path.read_bytes()
    sections = parse_sections(data)
    symbols = parse_symbols(sections)
    note = sections[".note"]["data"]
    namesz, descsz, ntype = struct.unpack_from("<III", note, 0)
    start = 12 + ((namesz + 3) // 4) * 4
    meta = msgpack.unpackb(note[start:start + descsz], raw=False)
    text = sections[".text"]
    kernels = []
    for k in meta["amdhsa.kernels"]:
        name = k[".name"]
        sym = symbols[name]
        text_off = text["offset"] + (sym["value"] - text["addr"])
        code = data[text_off:text_off + sym["size"]]
        kernels.append({
            "name": name,
            "code": code,
            "args": k[".args"],
            "kernarg_size": k[".kernarg_segment_size"],
            "kernarg_align": k[".kernarg_segment_align"],
            "sgpr_count": k[".sgpr_count"],
            "vgpr_count": k[".vgpr_count"],
            "group_segment": k[".group_segment_fixed_size"],
            "private_segment": k[".private_segment_fixed_size"],
        })
    return kernels


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("inputs", nargs="+", type=Path)
    ap.add_argument("-o", "--output", type=Path, required=True)
    args = ap.parse_args()
    kernels = []
    for path in args.inputs:
        kernels.extend(parse_kernels(path))
    args.output.write_bytes(build_elf(kernels))
    print(f"wrote {args.output}: merged {len(kernels)} kernels")
    for k in kernels:
        print(f"  {k['name']}: text={len(k['code'])} kernarg={k['kernarg_size']}")


if __name__ == "__main__":
    main()
