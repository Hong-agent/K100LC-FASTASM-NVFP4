#!/usr/bin/env python3
"""从 gfx926 code object（HSACO/ELF）里读 AMDGPU msgpack 元数据。

build 期只需要这一个只读小工具：`tools/gen_nodtk.py` 用它从自研 HSACO 里
取出每个内核的参数表与 kernarg/段大小。纯 Python，不依赖 DTK。
"""

from __future__ import annotations

import struct

import msgpack


NT_AMDGPU_METADATA = 32


def elf_sections(data: bytes) -> dict:
    e_shoff = struct.unpack_from("<Q", data, 0x28)[0]
    e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 0x3A)
    sections = []
    for i in range(e_shnum):
        sh = struct.unpack_from("<IIQQQQIIQQ", data, e_shoff + i * e_shentsize)
        sections.append(sh)
    shstr = data[sections[e_shstrndx][4]:sections[e_shstrndx][4] + sections[e_shstrndx][5]]
    out = {}
    for sh in sections:
        end = shstr.find(b"\0", sh[0])
        name = shstr[sh[0]:end].decode()
        out[name] = sh
    return out


def read_metadata(data: bytes) -> dict:
    sh = elf_sections(data).get(".note")
    if sh is None:
        raise RuntimeError("no .note section")
    off, size = sh[4], sh[5]
    pos = off
    while pos < off + size:
        namesz, descsz, ntype = struct.unpack_from("<III", data, pos)
        pos += 12
        pos += (namesz + 3) & ~3
        desc = data[pos:pos + descsz]
        pos += (descsz + 3) & ~3
        if ntype == NT_AMDGPU_METADATA:
            return msgpack.unpackb(desc, raw=False, strict_map_key=False)
    raise RuntimeError("no AMDGPU metadata note")
