#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""llama.cpp GGUF ↔ HF/RT4 的 **v-head 顺序** 换算（Qwen3.5 GDN 线性注意力）。

GGUF 里 48 个 value head 的排布是 `(v, g)`：v∈[0,3) 外层、g∈[0,16) 内层，
即 gguf 下标 `i = g + 16*v`；HF/引擎是 `(g, v)`：`j = g*3 + v`。

    j = P(i) = (i % 16) * 3 + i // 16

受影响的是「按 v-head 索引」的每一处，必须**同时**换算，否则隐藏状态对不上：

    ssm_a → A_log、ssm_dt.bias            (48)
    ssm_alpha/beta.weight → in_proj_a/b   ([48, K] 的行)
    attn_gate.weight      → in_proj_z     ([6144, K] 的 128 行一块)
    ssm_out.weight        → out_proj      ([N, 6144] 的 128 列一块)
    ssm_conv1d.weight     → conv1d        (v 段通道，128 通道一块)
    attn_qkv.weight       → in_proj_qkv   (v 段 128 行一块；q/k 段原样)

用法（就地把 GGUF 顺序改成 HF 顺序）：

    python3 tools/gguf_vhead_perm.py --rt4 build/qwen38_gsq.rt4 --fix
    python3 tools/gguf_vhead_perm.py --rt4 build/qwen38_gsq.rt4 --check
"""
from __future__ import annotations

import argparse
import json
import pathlib
import sys

import numpy as np

N_KHEAD = 16          # ssm.group_count
N_VPER = 3            # ssm.time_step_rank / N_KHEAD
N_VHEAD = N_KHEAD * N_VPER      # 48
HD = 128              # ssm.state_size
QKV_V_ROW = N_KHEAD * HD * 2    # q/k 段各 16*128 行 → v 段起点 = 4096（K=5120 时）

# P: gguf 下标 → hf 下标；PINV: hf 下标 → gguf 下标
P = np.array([(i % N_KHEAD) * N_VPER + i // N_KHEAD for i in range(N_VHEAD)])
PINV = np.argsort(P)


def permute_rows(buf: np.ndarray, row0: int, nblocks: int, block: int,
                 map_new_from_old: np.ndarray) -> None:
    """把 buf[row0 + b*block ...] 这一串行块按 map_new_from_old 就地重排。"""
    src = buf[row0:row0 + nblocks * block].copy()
    new = np.empty_like(src)
    for j, i in enumerate(map_new_from_old):
        new[j * block:(j + 1) * block] = src[i * block:(i + 1) * block]
    buf[row0:row0 + nblocks * block] = new


class RT4RW:
    def __init__(self, path: str | pathlib.Path):
        self.path = pathlib.Path(path)
        self.man = json.loads(self.path.with_suffix(".rt4.json").read_text())
        self.by = {t["name"]: t for t in self.man["tensors"]}
        self.f = open(self.path, "r+b")

    def close(self) -> None:
        self.f.close()

    def read(self, ent: dict, off_key: str, nbytes: int) -> np.ndarray:
        self.f.seek(ent[off_key])
        return np.frombuffer(self.f.read(nbytes), dtype=np.uint8).copy()

    def write(self, ent: dict, off_key: str, buf: np.ndarray) -> None:
        self.f.seek(ent[off_key])
        self.f.write(buf.tobytes())


def fix_linear_attn(rw: RT4RW, layer: int, verbose: bool = True) -> None:
    """把某一层的 in_proj_z（全部行块）与 in_proj_qkv（v 段行块）改成 HF 顺序。"""
    pre = f"model.language_model.layers.{layer}.linear_attn."
    touched = []
    for suffix, row0 in (("in_proj_z.weight", 0), ("in_proj_qkv.weight", QKV_V_ROW)):
        name = pre + suffix
        ent = rw.by.get(name)
        if ent is None or ent["kind"] != "i4":
            continue
        rows, cols = ent["shape"]
        qrow = cols // 2                       # 一行的 int4 打包字节
        srow = (cols // ent.get("group", 128)) * 2
        q = rw.read(ent, "q_off", rows * qrow).reshape(rows, qrow)
        permute_rows(q, row0, N_VHEAD, HD, PINV)
        rw.write(ent, "q_off", q)
        s = rw.read(ent, "s_off", rows * srow).reshape(rows, srow)
        permute_rows(s, row0, N_VHEAD, HD, PINV)
        rw.write(ent, "s_off", s)
        touched.append(f"{suffix}@{row0}")
    if verbose:
        print(f"  layer {layer:<2} {', '.join(touched)}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rt4", required=True)
    ap.add_argument("--fix", action="store_true")
    ap.add_argument("--layers", default="", help="只改这些层（逗号分隔）；默认全部")
    args = ap.parse_args()
    rw = RT4RW(args.rt4)
    layers = [int(x) for x in args.layers.split(",") if x] if args.layers else \
        sorted({int(n.split(".")[3]) for n in rw.by
                if n.endswith("linear_attn.in_proj_z.weight")})
    print(f"{len(layers)} 个线性注意力层：{'改写' if args.fix else '（未给 --fix，仅列出）'}")
    if args.fix:
        for il in layers:
            fix_linear_attn(rw, il)
        rw.f.flush()
    rw.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
