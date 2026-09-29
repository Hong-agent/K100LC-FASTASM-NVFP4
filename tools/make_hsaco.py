#!/usr/bin/env python3
"""Pack assembled gfx926 machine code into a loadable HSACO.

This first version uses a known-good gfx926 code object as a skeleton and
patches the machine-code bytes for the `_Z6fill_kPffx` kernel.  It does not
need DTK at run time; the skeleton is a checked-in build artifact.
"""

from __future__ import annotations

import argparse
import hashlib
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SKELETON = ROOT / "skeletons" / "fill_k_gfx926.hsaco"

# `.text` VMA 0xa500 -> file offset 0x9500; next symbol starts at 0xa600.
FNOP = bytes.fromhex("00 00 80 bf")


class ElfError(RuntimeError):
    pass


def parse_elf_symbol(data: bytes, wanted: str) -> tuple[int, int, str]:
    """Return (file_offset, size, section_name) for a dynamic symbol."""
    if data[:4] != b"\x7fELF" or data[4] != 2:
        raise ElfError("not an ELF64 file")
    e_shoff = struct.unpack_from("<Q", data, 0x28)[0]
    e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 0x3A)
    sections = []
    for i in range(e_shnum):
        off = e_shoff + i * e_shentsize
        sh = struct.unpack_from("<IIQQQQIIQQ", data, off)
        sections.append({
            "name_off": sh[0], "type": sh[1], "flags": sh[2],
            "addr": sh[3], "offset": sh[4], "size": sh[5],
            "link": sh[6], "entsize": sh[9],
        })
    shstr = sections[e_shstrndx]
    shstr_data = data[shstr["offset"]:shstr["offset"] + shstr["size"]]

    def section_name(sec: dict) -> str:
        start = sec["name_off"]
        end = shstr_data.find(b"\0", start)
        return shstr_data[start:end].decode("utf-8", "replace")

    for sec in sections:
        sec["name"] = section_name(sec)

    dynsym = next((s for s in sections if s["name"] == ".dynsym"), None)
    dynstr = next((s for s in sections if s["name"] == ".dynstr"), None)
    text = next((s for s in sections if s["name"] == ".text"), None)
    if not dynsym or not dynstr or not text:
        raise ElfError("missing .dynsym/.dynstr/.text")
    strings = data[dynstr["offset"]:dynstr["offset"] + dynstr["size"]]
    count = dynsym["size"] // dynsym["entsize"]
    for i in range(count):
        off = dynsym["offset"] + i * dynsym["entsize"]
        st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack_from("<IBBHQQ", data, off)
        end = strings.find(b"\0", st_name)
        name = strings[st_name:end].decode("utf-8", "replace")
        if name != wanted:
            continue
        if st_shndx != 7:
            raise ElfError(f"symbol {wanted} is not in .text (section {st_shndx})")
        file_off = text["offset"] + (st_value - text["addr"])
        return file_off, st_size, text["name"]
    raise ElfError(f"symbol not found: {wanted}")


def align_nops(data: bytes, size: int) -> bytes:
    if len(data) > size:
        raise SystemExit(f"kernel is {len(data)} bytes, skeleton slot is {size} bytes")
    if len(data) % 4:
        raise SystemExit("kernel size must be a multiple of 4 bytes")
    return data + FNOP * ((size - len(data)) // 4)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path, help="assembled raw machine code")
    ap.add_argument("output", type=Path)
    ap.add_argument("--symbol", default="_Z6fill_kPffx",
                    help="kernel symbol in the skeleton (default: fill_k)")
    ap.add_argument("--skeleton", type=Path, default=DEFAULT_SKELETON)
    ap.add_argument("--file-offset", type=lambda x: int(x, 0), default=None)
    ap.add_argument("--max-size", type=lambda x: int(x, 0), default=None)
    args = ap.parse_args()

    skeleton = bytearray(args.skeleton.read_bytes())
    code = args.input.read_bytes()
    if args.file_offset is not None or args.max_size is not None:
        if args.file_offset is None or args.max_size is None:
            raise SystemExit("--file-offset and --max-size must be used together")
        file_offset, max_size = args.file_offset, args.max_size
        section = ".text"
    else:
        file_offset, max_size, section = parse_elf_symbol(bytes(skeleton), args.symbol)
    patched = align_nops(code, max_size)
    end = file_offset + len(patched)
    if end > len(skeleton):
        raise SystemExit("patch extends beyond skeleton file")
    skeleton[file_offset:end] = patched
    args.output.write_bytes(skeleton)
    sha = hashlib.sha256(skeleton).hexdigest()
    print(f"wrote {args.output}: {len(skeleton)} bytes, sha256={sha}")
    print(f"patched {args.symbol} in {section}: file_offset=0x{file_offset:x}, "
          f"code={len(code)} bytes, slot={max_size} bytes")


if __name__ == "__main__":
    main()
