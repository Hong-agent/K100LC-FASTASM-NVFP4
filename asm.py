#!/usr/bin/env python3
"""Small standalone assembler for the K100_LC / gfx926 subset.

The encoding table (`encodings.json`) is generated once by DTK's llvm-mc via
`tools/derive_encodings.py`.  This assembler itself has no DTK dependency.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent
ENCODINGS = ROOT / "encodings.json"

FLOAT_CONST = {
    "0.5": 0xF0,
    "-0.5": 0xF1,
    "1.0": 0xF2,
    "-1.0": 0xF3,
    "2.0": 0xF4,
    "-2.0": 0xF5,
    "4.0": 0xF6,
    "-4.0": 0xF7,
}


@dataclass
class Entry:
    mnemonic: str
    asm: str
    domain: dict[str, str]
    width: int
    fixed: int
    fields: dict[str, dict]
    pattern: list[str]
    pattern_args: list[tuple[int, str]]


@dataclass
class Instruction:
    mnemonic: str
    operands: list[str]
    line_no: int
    raw: str = ""
    entry: Entry | None = None
    addr: int = 0
    size: int = 0


def split_operands(text: str) -> list[str]:
    return [part.strip() for part in text.split(",") if part.strip()]


def compile_entry(raw: dict) -> Entry:
    asm = raw["asm"]
    mnemonic, _, rest = asm.partition(" ")
    pattern = split_operands(rest)
    pattern_args: list[tuple[int, str]] = []
    for idx, part in enumerate(pattern):
        for name in re.findall(r"\{([a-zA-Z_][a-zA-Z0-9_]*)\}", part):
            pattern_args.append((idx, name))
    return Entry(
        mnemonic=mnemonic,
        asm=asm,
        domain=raw["domain"],
        width=int(raw["width"]),
        fixed=int(raw["fixed"]),
        fields=raw["fields"],
        pattern=pattern,
        pattern_args=pattern_args,
    )


# encodings.json 的解析结果做模块级缓存：assemble() 每个内核调用一次，
# 80 个内核 = 80 次重复读盘 + 重建全部 Entry（实测占掉构建耗时的大头）。
# 调用方（match/assemble）对返回的 dict 只读不写，缓存是安全的。
_entry_cache: dict[str, list[Entry]] | None = None


def load_entries() -> dict[str, list[Entry]]:
    global _entry_cache
    if _entry_cache is None:
        data = json.loads(ENCODINGS.read_text(encoding="utf-8"))
        by_mnemonic: dict[str, list[Entry]] = {}
        for raw in data:
            entry = compile_entry(raw)
            by_mnemonic.setdefault(entry.mnemonic, []).append(entry)
        _entry_cache = by_mnemonic
    return _entry_cache


def parse_domain(domain: str, text: str) -> int | str:
    text = text.strip()
    if domain == "vsrc0":
        if text.startswith("v"):
            return int(parse_domain("vreg", text)) | 0x100
        if text.startswith("s"):
            return parse_domain("sreg", text)
        if text in FLOAT_CONST:
            return FLOAT_CONST[text]
        return encode_inline_const(int(text, 0))
    if domain == "ssrc":
        if text.startswith("s"):
            return parse_domain("sreg", text)
        return encode_inline_const(int(text, 0))
    if domain == "ssrc_pair":
        if text.lower() == "exec":
            return 126
        if text.lower() == "vcc":
            return 106
        if text.startswith("s["):
            return parse_domain("spair", text)
        return encode_inline_const(int(text, 0))
    if domain == "vreg":
        m = re.fullmatch(r"v(\d+)", text)
        if not m or int(m.group(1)) > 255:
            raise ValueError(f"not a VGPR: {text}")
        return int(m.group(1))
    if domain == "vpair":
        m = re.fullmatch(r"v\[(\d+):(\d+)\]", text)
        if not m:
            raise ValueError(f"not a VGPR pair: {text}")
        a, b = int(m.group(1)), int(m.group(2))
        if b != a + 1:
            raise ValueError(f"not a VGPR pair: {text}")
        return a
    if domain == "vquad":
        m = re.fullmatch(r"v\[(\d+):(\d+)\]", text)
        if not m:
            raise ValueError(f"not a VGPR quad: {text}")
        a, b = int(m.group(1)), int(m.group(2))
        if b != a + 3:
            raise ValueError(f"not a VGPR quad: {text}")
        return a
    if domain == "vtriple":
        m = re.fullmatch(r"v\[(\d+):(\d+)\]", text)
        if not m:
            raise ValueError(f"not a VGPR triple: {text}")
        a, b = int(m.group(1)), int(m.group(2))
        if b != a + 2:
            raise ValueError(f"not a VGPR triple: {text}")
        return a
    if domain == "sreg":
        m = re.fullmatch(r"s(\d+)", text)
        if m and int(m.group(1)) <= 127:
            return int(m.group(1))
        try:
            return encode_inline_const(int(text, 0))
        except ValueError as exc:
            raise ValueError(f"not an SGPR or constant: {text}") from exc
    if domain == "spair":
        if text.lower() == "exec":
            return 126
        if text.lower() == "vcc":
            return 106
        m = re.fullmatch(r"s\[(\d+):(\d+)\]", text)
        if m:
            a, b = int(m.group(1)), int(m.group(2))
            if b != a + 1:
                raise ValueError(f"not an SGPR pair: {text}")
            return a
        try:
            return encode_inline_const(int(text, 0))
        except ValueError as exc:
            raise ValueError(f"not an SGPR pair or constant: {text}") from exc
    if domain == "squad":
        m = re.fullmatch(r"s\[(\d+):(\d+)\]", text)
        if not m:
            raise ValueError(f"not an SGPR quad: {text}")
        a, b = int(m.group(1)), int(m.group(2))
        if b != a + 3:
            raise ValueError(f"not an SGPR quad: {text}")
        return a
    if domain in {"soct", "shex"}:
        width = 8 if domain == "soct" else 16
        m = re.fullmatch(r"s\[(\d+):(\d+)\]", text)
        if not m:
            raise ValueError(f"not an SGPR block: {text}")
        a, b = int(m.group(1)), int(m.group(2))
        if b != a + width - 1:
            raise ValueError(f"not an SGPR block: {text}")
        return a
    if domain in {"imm8", "imm13", "imm16", "imm21", "imm32", "imm_inline"}:
        if re.fullmatch(r"[A-Za-z_.$][A-Za-z0-9_.$]*", text):
            return text
        if domain == "imm_inline":
            return inline_field_value(int(text, 0))
        return int(text, 0)
    raise ValueError(f"unknown domain {domain}")


def encode_inline_const(value: int) -> int:
    if 0 <= value <= 64:
        return 0x80 + value
    if -16 <= value <= -1:
        return 0xC0 + (-value)
    return 0xFF


def inline_field_value(value: int) -> int:
    """Field bits (below the constant 0x80 marker) for an inline constant."""
    if 0 <= value <= 64:
        return value
    if -16 <= value <= -1:
        return 0x40 + (-value)
    raise ValueError(f"value {value} is not an inline constant")


def literal_of(domain: str, text: str) -> int | None:
    if domain not in {"sreg", "vsrc0", "ssrc", "ssrc_pair", "spair"}:
        return None
    if text.strip() in FLOAT_CONST:
        return None
    try:
        value = int(text.strip(), 0)
    except ValueError:
        return None
    if 0 <= value <= 64 or -16 <= value <= -1:
        return None
    return value & 0xFFFFFFFF


def instruction_literals(entry: Entry, operands: list[str]) -> list[int]:
    matched = match_entry([entry], operands)  # type: ignore[arg-type]
    if not matched:
        return []
    _entry, captures = matched
    literals = []
    for name, text in captures.items():
        lit = literal_of(entry.domain[name], text)
        if lit is not None:
            literals.append(lit)
    if len(literals) > 1:
        raise SyntaxError("multiple literal constants in one instruction are not supported")
    return literals


def match_entry(entries: list[Entry], operands: list[str]) -> tuple[Entry, dict[str, str]] | None:
    for entry in entries:
        if len(entry.pattern) != len(operands):
            continue
        captures: dict[str, str] = {}
        ok = True
        for pat, actual in zip(entry.pattern, operands):
            if "{" not in pat:
                if pat.lower() != actual.lower():
                    ok = False
                    break
                continue
            # Literal prefix/suffix around one or more {placeholders}.
            regex = "^" + re.escape(pat) + "$"
            for name in re.findall(r"\{([a-zA-Z_][a-zA-Z0-9_]*)\}", pat):
                regex = regex.replace(re.escape("{" + name + "}"), f"(?P<{name}>.+?)")
            m = re.fullmatch(regex, actual)
            if not m:
                ok = False
                break
            for name, value in m.groupdict().items():
                captures[name] = value
        if not ok:
            continue
        try:
            for name, value in captures.items():
                parsed = parse_domain(entry.domain[name], value)
                if isinstance(parsed, str) and not (
                    entry.mnemonic.startswith("s_branch") or entry.mnemonic.startswith("s_cbranch_")
                ):
                    ok = False
                    break
            if not ok:
                continue
        except ValueError:
            continue
        return entry, captures
    return None


def encode_values(entry: Entry, values: dict[str, int]) -> bytes:
    word = entry.fixed
    for name, field in entry.fields.items():
        value = values[name]
        scale = int(field.get("scale", 1))
        value //= scale
        if "shift" in field:
            word |= (value << int(field["shift"])) & int(field["mask"])
        else:
            for bit, pos in enumerate(field.get("bits", [])):
                if (value >> bit) & 1:
                    word |= 1 << int(pos)
    return word.to_bytes(entry.width, "little")


def parse_source(path: Path) -> list[object]:
    items: list[object] = []
    for line_no, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.split(";", 1)[0].split("//", 1)[0]
        line = line.strip()
        if not line:
            continue
        if line.endswith(":"):
            items.append(("label", line[:-1].strip(), line_no))
            continue
        mnemonic, _, rest = line.partition(" ")
        operands = split_operands(rest) if rest.strip() else []
        items.append(Instruction(mnemonic, operands, line_no, raw=line))
    return items


SDWA_SEL = {
    "BYTE_0": 0, "BYTE_1": 1, "BYTE_2": 2, "BYTE_3": 3,
    "WORD_0": 4, "WORD_1": 5, "DWORD": 6,
}
SDWA_UNUSED = {"UNUSED_PAD": 0, "UNUSED_SEXT": 1, "UNUSED_PRESERVE": 2}


def encode_sdwa(inst: Instruction, by_mnemonic: dict[str, list[Entry]]) -> bytes:
    mods = {}
    for key in ("dst_sel", "dst_unused", "src0_sel", "src1_sel"):
        m = re.search(rf"\b{key}:([A-Za-z0-9_]+)", inst.raw)
        if not m:
            raise SyntaxError(f"line {inst.line_no}: missing {key}")
        mods[key] = m.group(1)
    reg_text = re.sub(r"\s+\b(?:dst_sel|dst_unused|src0_sel|src1_sel):[A-Za-z0-9_]+", "", inst.raw)
    _, _, rest = reg_text.partition(" ")
    regs = split_operands(rest)
    if len(regs) != 3:
        raise SyntaxError(f"line {inst.line_no}: bad SDWA operands")
    vdst = regs[0]
    src0_text, sext0 = (regs[1], False)
    m = re.fullmatch(r"sext\((v\d+|s\d+)\)", regs[1])
    if m:
        src0_text, sext0 = m.group(1), True
    src1_text, sext1 = (regs[2], False)
    m = re.fullmatch(r"sext\((v\d+|s\d+)\)", regs[2])
    if m:
        src1_text, sext1 = m.group(1), True
    entries = by_mnemonic.get(inst.mnemonic)
    if not entries:
        raise SyntaxError(f"line {inst.line_no}: no SDWA base entry for {inst.mnemonic}")
    entry = entries[0]
    field_names = list(entry.fields)
    if len(field_names) != 3:
        raise SyntaxError(f"line {inst.line_no}: bad SDWA field map")
    values = {
        field_names[0]: parse_domain("vreg", vdst),
        field_names[1]: (parse_domain("vreg", src0_text) if src0_text.startswith("v")
                         else parse_domain("sreg", src0_text)),
        field_names[2]: (parse_domain("vreg", src1_text) if src1_text.startswith("v")
                         else parse_domain("sreg", src1_text)),
    }
    word = bytearray(encode_values(entry, values))  # type: ignore[arg-type]
    word[5] = SDWA_SEL[mods["dst_sel"]] | (SDWA_UNUSED[mods["dst_unused"]] << 3)
    word[6] = SDWA_SEL[mods["src0_sel"]] | (0x08 if sext0 else 0)
    word[7] = SDWA_SEL[mods["src1_sel"]] | (0x08 if sext1 else 0)
    if src0_text.startswith("s"):
        word[6] |= 0x80
    if src1_text.startswith("s"):
        word[7] |= 0x80
    if src1_text.startswith("v") and int(src1_text[1:]) >= 128:
        word[2] |= 0x01
    return bytes(word)


def match(by_mnemonic: dict[str, list[Entry]], inst: Instruction) -> Entry:
    entries = by_mnemonic.get(inst.mnemonic)
    if not entries:
        raise SyntaxError(f"line {inst.line_no}: unsupported mnemonic {inst.mnemonic}")
    matched = match_entry(entries, inst.operands)
    if not matched:
        raise SyntaxError(f"line {inst.line_no}: no encoding form for {inst.mnemonic} {' , '.join(inst.operands)}")
    return matched[0]


def assemble(path: Path) -> tuple[bytes, list[Instruction], dict[str, int]]:
    by_mnemonic = load_entries()
    items = parse_source(path)

    labels: dict[str, int] = {}
    pc = 0
    for item in items:
        if isinstance(item, tuple) and item[0] == "label":
            labels[item[1]] = pc
            continue
        if isinstance(item, Instruction):
            item.addr = pc
            if item.mnemonic == ".align":
                align = int(item.operands[0], 0)
                pc = (pc + align - 1) // align * align
                item.size = 0
                continue
            if item.mnemonic == ".byte":
                item.size = len(item.operands)
                pc += item.size
                continue
            if item.mnemonic == ".long":
                item.size = 4 * len(item.operands)
                pc += item.size
                continue
            if item.mnemonic in {".text", ".globl", ".type", ".size"}:
                item.size = 0
                continue
            if item.mnemonic.endswith("_sdwa"):
                item.size = 8
                pc += item.size
                continue
            entry = match(by_mnemonic, item)
            item.entry = entry
            item.size = entry.width + 4 * len(instruction_literals(entry, item.operands))
            pc += item.size

    out = bytearray()
    pc = 0
    for item in items:
        if isinstance(item, tuple) and item[0] == "label":
            continue
        if isinstance(item, Instruction):
            if item.mnemonic == ".align":
                align = int(item.operands[0], 0)
                out.extend(b"\x00" * ((-len(out)) % align))
                pc = len(out)
                continue
            if item.mnemonic == ".byte":
                out.extend(int(x, 0) & 0xFF for x in item.operands)
                pc = len(out)
                continue
            if item.mnemonic == ".long":
                for x in item.operands:
                    out.extend((int(x, 0) & 0xFFFFFFFF).to_bytes(4, "little"))
                pc = len(out)
                continue
            if item.mnemonic in {".text", ".globl", ".type", ".size"}:
                continue
            if item.mnemonic.endswith("_sdwa"):
                out.extend(encode_sdwa(item, by_mnemonic))
                pc = len(out)
                continue
            entry = item.entry
            assert entry is not None
            _entry, captures = match_entry([entry], item.operands)  # type: ignore[arg-type]
            values: dict[str, int] = {}
            branch = item.mnemonic.startswith("s_branch") or item.mnemonic.startswith("s_cbranch_")
            for name, text in captures.items():
                domain = entry.domain[name]
                parsed = parse_domain(domain, text)
                if isinstance(parsed, str):
                    if not branch:
                        raise SyntaxError(f"line {item.line_no}: label {parsed} only valid in branch")
                    if parsed not in labels:
                        raise SyntaxError(f"line {item.line_no}: unknown label {parsed}")
                    disp = (labels[parsed] - (pc + 4)) // 4
                    if disp < -32768 or disp > 32767:
                        raise SyntaxError(f"line {item.line_no}: branch out of range")
                    parsed = disp & 0xFFFF
                values[name] = parsed
            encoded = encode_values(entry, values)
            out.extend(encoded)
            for literal in instruction_literals(entry, item.operands):
                out.extend(literal.to_bytes(4, "little"))
            pc = len(out)

    return bytes(out), [x for x in items if isinstance(x, Instruction)], labels


def main() -> None:
    parser = argparse.ArgumentParser(description="K100_LC gfx926 assembler")
    parser.add_argument("source", type=Path)
    parser.add_argument("-o", "--output", type=Path)
    parser.add_argument("--hex", action="store_true", help="write hex text instead of binary")
    parser.add_argument("--list", action="store_true", help="print instruction boundaries")
    args = parser.parse_args()

    blob, instructions, labels = assemble(args.source)
    if args.list:
        pc = 0
        for item in instructions:
            print(f"{pc:08x}: {item.size:2d}  {item.mnemonic} {' '.join(item.operands)}")
            pc += item.size
        if labels:
            print("labels:")
            for name, addr in sorted(labels.items(), key=lambda kv: kv[1]):
                print(f"  {addr:08x} {name}")
    if args.output:
        if args.hex:
            args.output.write_text(" ".join(f"{b:02x}" for b in blob) + "\n", encoding="utf-8")
        else:
            args.output.write_bytes(blob)
        print(f"wrote {args.output}: {len(blob)} bytes")
    else:
        print(" ".join(f"{b:02x}" for b in blob))


if __name__ == "__main__":
    main()
