#!/usr/bin/env python3
"""把 MTP 头打成 int8（W8A8）权重文件。

来源：K100LC-RT4 的 tools/mtp_w8_pack.py（同一作者、Apache-2.0），本项目照搬，
因为运行时的 load_mtp 已经认识这个格式（见 src/model.cpp 的 mtp.w8）。

原理：gfx926 只有 int4/int8 点积，没有 int8×int8 宽点积。沿用 k_gemm_i4_a8 的
「拆成两个 int4 数字各跑一遍再相加」技巧，把 int8 权重量化码 w8 拆成

    w8 = 16*wh + wl,   wh, wl ∈ [-8, 7]

hi/lo 两张量共用同一个 int8 组尺度 s；hi 的尺度预乘 16，于是运行时
「跑两遍 int4 linear 再相加」= s*(16*wh + wl)·a，等价 int8 权重 × int8 激活。
运行时靠「没有 mtp.fc.weight、只有 mtp.fc.weight.hi」自动识别这个格式。

用法：python3 tools/mtp_w8_pack.py <src.safetensors> <src.rt4.json> <out_prefix>
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np


GROUP = 128


def read_safetensors(path: Path) -> dict:
    with path.open("rb") as fh:
        n = int.from_bytes(fh.read(8), "little")
        header = json.loads(fh.read(n).decode())
        base = fh.tell()
        out = {}
        for name, meta in header.items():
            if name == "__metadata__":
                continue
            start, end = meta["data_offsets"]
            fh.seek(base + start)
            buf = np.frombuffer(fh.read(end - start), dtype=np.uint8)
            dt = {"F16": np.float16, "BF16": None, "F32": np.float32}[meta["dtype"]]
            if meta["dtype"] == "BF16":
                u = buf.view(np.uint16).astype(np.uint32) << 16
                arr = u.view(np.float32)
            else:
                arr = buf.view(dt)
            out[name] = arr.reshape(meta["shape"])
        return out


def quant_int8_splits(w: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """w[N,K] fp16 → (wh, wl, scale)；scale 是每个 K/128 组的 int8 组尺度。"""
    w = w.astype(np.float32)
    N, K = w.shape
    assert K % GROUP == 0, (N, K)
    g = w.reshape(N, K // GROUP, GROUP)
    amax = np.abs(g).max(axis=2)
    scale = np.where(amax > 0, amax / 119.0, 1.0)          # 留出 int4 高位不溢出
    q8 = np.clip(np.rint(g / scale[:, :, None]), -120, 119).astype(np.int32)
    wh = np.floor((q8 + 8) / 16).astype(np.int32)           # ∈ [-8,7]
    wl = q8 - 16 * wh                                       # ∈ [-8,7]
    return (wh.reshape(N, K), wl.reshape(N, K), scale.astype(np.float32))


def pack_int4(codes: np.ndarray) -> bytes:
    """低半字节 = 偶数 k（与现役内核的 lo/hi 约定一致），二进制补码 int4。"""
    N, K = codes.shape
    c = (codes.astype(np.int32) & 0xF).astype(np.uint8).reshape(N, K // 2, 2)
    packed = c[:, :, 0] | (c[:, :, 1] << 4)
    return packed.astype(np.uint8).tobytes()


def main() -> int:
    if len(sys.argv) != 4:
        print(__doc__.strip().splitlines()[-1], file=sys.stderr)
        return 2
    src, src_json, out_prefix = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
    sd = read_safetensors(src)
    spec = json.loads(src_json.read_text())
    tensors = spec["tensors"]
    orig_rt4 = (src_json.parent / spec.get("weight_file", "")).resolve()
    if not orig_rt4.exists():
        orig_rt4 = src_json.with_suffix("")
    orig_blob = orig_rt4.read_bytes()

    blob = bytearray()
    new_tensors = []
    tot_err4 = tot_err8 = 0.0
    nq = 0
    for t in tensors:
        name = t["name"]
        w = sd[name]
        if t["kind"] != "i4":
            # 非 int4 张量（f32/f16 的 norm 等）原样搬过来，保持字节与 kind 不变
            off = len(blob)
            n = int(t["nbytes"])
            blob += orig_blob[int(t["q_off"]):int(t["q_off"]) + n]
            new_tensors.append({**t, "q_off": off, "s_off": 0,
                                "nbytes": len(blob) - off})
            continue
        wh, wl, scale = quant_int8_splits(w)
        recon = scale[:, :, None] * (16 * wh.reshape(w.shape[0], -1, GROUP)
                                     + wl.reshape(w.shape[0], -1, GROUP))
        err8 = np.sqrt(((recon.reshape(w.shape) - w.astype(np.float32)) ** 2).mean()) / (
            np.sqrt((w.astype(np.float32) ** 2).mean()) + 1e-12)
        tot_err8 += float(err8)
        tot_err4 += float(t.get("relerr", 0.0))
        nq += 1
        for tag, codes, sc in (("hi", wh, scale * 16.0), ("lo", wl, scale)):
            q_off = len(blob)
            packed = pack_int4(codes)
            blob += packed
            s_off = len(blob)
            blob += sc.astype(np.float16).tobytes()
            new_tensors.append({
                "name": f"{name}.{tag}", "kind": "i4", "shape": list(w.shape),
                "group": GROUP, "q_off": q_off, "s_off": s_off,
                "nbytes": len(blob) - q_off, "relerr": 0.0, "src_rms": 0.0,
            })
        print(f"  {name}: int4 relerr={t.get('relerr', 0):.4f} -> W8 relerr={err8:.4f}")

    out_rt4 = Path(str(out_prefix) + ".rt4")
    out_json = Path(str(out_prefix) + ".rt4.json")
    out_rt4.write_bytes(bytes(blob))
    out_json.write_text(json.dumps({
        "format": "RT4-v1-w8split", "group": GROUP,
        "weight_file": out_rt4.name, "tensors": new_tensors,
    }, indent=1, ensure_ascii=False) + "\n")
    print(f"wrote {out_rt4} ({len(blob)} bytes), {len(new_tensors)} tensors")
    print(f"平均 int4 relerr={tot_err4 / nq:.4f}  →  W8 relerr≈{tot_err8 / nq:.4f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
