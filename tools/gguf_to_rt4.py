#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 GSQ-RCO GGUF（Qwen3.8-27B）转成引擎能直接跑的 RT4。

    python3 tools/gguf_to_rt4.py --gguf <IQ3_S.gguf> --out build/qwen38_gsq.rt4 \
            [--template models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4.json]

流程：GGUF 头 → 名称映射（llama.cpp 名 → 引擎 HF 名，用现有 RT4 清单做模板）
      → plan.tsv → build/gguf_requant（C，复用 ggml 解码）→ .rt4 + .rt4.json
"""
from __future__ import annotations

import argparse
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, "/home/t/桌面/k100lc-flashmoe/tools")
from gguf_probe import GGUFHeader  # noqa: E402

TYPES = {  # GGUF 类型名 → id（与 ggml 枚举一致）
    "F32": 0, "F16": 1, "Q4_0": 2, "Q4_1": 3, "Q5_0": 4, "Q5_1": 5, "Q8_0": 6,
    "Q2_K": 8, "Q3_K": 9, "Q4_K": 10, "Q5_K": 11, "Q6_K": 12,
    "IQ2_XXS": 14, "IQ2_XS": 15, "IQ3_XXS": 16, "IQ4_NL": 18, "IQ3_S": 19,
    "IQ2_S": 20, "IQ4_XS": 21, "IQ1_M": 27, "BF16": 28,
}
GEOM = {  # id → (每块元素, 每块字节)
    0: (1, 4), 1: (1, 2), 2: (32, 18), 3: (32, 20), 4: (32, 18), 5: (32, 20),
    6: (32, 34), 8: (256, 84), 9: (256, 110), 10: (256, 144), 11: (256, 176),
    12: (256, 210), 14: (256, 66), 15: (256, 74), 16: (256, 98), 18: (32, 18),
    19: (256, 110), 20: (256, 82), 21: (256, 136), 27: (256, 56), 28: (1, 2),
}

LINEAR_MAP = {
    "attn_qkv.weight": "linear_attn.in_proj_qkv.weight",
    "attn_gate.weight": "linear_attn.in_proj_z.weight",
    "ssm_out.weight": "linear_attn.out_proj.weight",
    "ssm_a": "linear_attn.A_log",
    "ssm_alpha.weight": "linear_attn.in_proj_a.weight",
    "ssm_beta.weight": "linear_attn.in_proj_b.weight",
    "ssm_conv1d.weight": "linear_attn.conv1d.weight",
    "ssm_dt.bias": "linear_attn.dt_bias",
    "ssm_norm.weight": "linear_attn.norm.weight",
}
FULL_MAP = {
    "attn_q.weight": "self_attn.q_proj.weight",
    "attn_k.weight": "self_attn.k_proj.weight",
    "attn_v.weight": "self_attn.v_proj.weight",
    "attn_output.weight": "self_attn.o_proj.weight",
    "attn_q_norm.weight": "self_attn.q_norm.weight",
    "attn_k_norm.weight": "self_attn.k_norm.weight",
}
COMMON_MAP = {
    "attn_norm.weight": "input_layernorm.weight",
    "post_attention_norm.weight": "post_attention_layernorm.weight",
    "ffn_gate.weight": "mlp.gate_proj.weight",
    "ffn_up.weight": "mlp.up_proj.weight",
    "ffn_down.weight": "mlp.down_proj.weight",
}


def gguf_to_hf(name: str) -> str | None:
    if name == "token_embd.weight":
        return "model.language_model.embed_tokens.weight"
    if name == "output.weight":
        return "lm_head.weight"
    if name == "output_norm.weight":
        return "model.language_model.norm.weight"
    if not name.startswith("blk."):
        return None
    _, idx, *rest = name.split(".")
    suf = ".".join(rest)
    for table in (LINEAR_MAP, FULL_MAP, COMMON_MAP):
        if suf in table:
            return f"model.language_model.layers.{idx}.{table[suf]}"
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--gguf", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--template", default=str(
        ROOT / "models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4.json"))
    ap.add_argument("--plan", default=str(ROOT / "build/gguf_to_rt4.plan.tsv"))
    ap.add_argument("--params-from", default="",
                    help="非量化小张量（f32/f16）从这份 RT4 复制（默认同模板同目录）")
    args = ap.parse_args()

    h = GGUFHeader(args.gguf)
    src = {}
    for t in h.tensors:
        hf = gguf_to_hf(t.name)
        if hf:
            src[hf] = t
    tmpl = json.loads(pathlib.Path(args.template).read_text())["tensors"]

    lines, out_tensors, off, missing = [], [], 0, []
    for t in tmpl:
        name, kind = t["name"], t["kind"]
        g = src.get(name)
        if g is None:
            missing.append(name)
            return 1
        tid = TYPES[g.type_name]
        qk, bb = GEOM[tid]
        rows = 1 if len(g.shape) == 1 else g.shape[1]
        cols = g.shape[0]
        if len(t["shape"]) >= 2 and kind == "i4":
            assert rows == t["shape"][0] and cols == t["shape"][1], (name, g.shape, t["shape"])
        bbrow = cols // qk * bb
        off = (off + 255) // 256 * 256
        q_off = off
        if kind == "i4":
            q_bytes = rows * cols // 2
            s_off = q_off + q_bytes
            s_bytes = rows * (cols // 128) * 2
        else:
            q_bytes = rows * cols * (2 if kind == "f16" else 4)
            s_off, s_bytes = 0, 0
        nbytes = q_bytes + s_bytes
        off = q_off + nbytes
        # 注意：gguf_probe 的 Tensor.offset 是相对「数据区起点」的，要加 data_start
        goff = h.data_start + g.offset
        lines.append(f"{g.name}\t{kind}\t{rows}\t{cols}\t{goff}\t{q_off}\t{s_off}"
                     f"\t{bbrow}\t{qk}\t{tid}")
        out_tensors.append({"name": name, "kind": kind, "shape": t["shape"],
                            "group": t.get("group", 128), "q_off": q_off, "s_off": s_off,
                            "nbytes": nbytes, "src_type": g.type_name})
    plan = pathlib.Path(args.plan)
    plan.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"plan: {len(lines)} 张量 → {plan}")

    out = pathlib.Path(args.out)
    with open(out, "wb") as f:
        f.truncate(off)
    r = subprocess.run([str(ROOT / "build/gguf_requant"), str(plan), args.gguf, str(out)],
                       stderr=sys.stderr)
    if r.returncode != 0:
        return r.returncode
    (out.with_suffix(".rt4.json")).write_text(json.dumps(
        {"format": "RT4-v1", "group": 128, "weight_file": str(out),
         "tensors": out_tensors}, ensure_ascii=False, indent=1), encoding="utf-8")
    # 小参数（norm/conv1d/A_log/dt_bias/in_proj_a,b 等）在 GGUF 与 HF 之间约定不同
    # （逐头参数的值集合都不一样），直接沿用引擎已对账过的 RT4 那份；只保留 GGUF 的
    # 量化大矩阵，从而既是「原字节」又不用反推 llama.cpp 的参数换算。
    ref = pathlib.Path(args.params_from) if args.params_from else \
        pathlib.Path(args.template).with_suffix("").with_suffix(".rt4")
    if ref.is_file():
        rtm = {x["name"]: x for x in json.loads(
            pathlib.Path(args.template).read_text())["tensors"]}
        n_copied = n_bytes = 0
        with open(ref, "rb") as fr, open(out, "r+b") as fo:
            for t in out_tensors:
                if t["kind"] == "i4":
                    continue
                r = rtm[t["name"]]
                fr.seek(r["q_off"]); fo.seek(t["q_off"])
                fo.write(fr.read(r["nbytes"]))
                n_copied += 1; n_bytes += r["nbytes"]
        print(f"  小参数沿用参考 RT4：{n_copied} 张量 / {n_bytes/2**20:.1f} MiB")
    print(f"-> {out} ({out.stat().st_size/2**30:.2f} GiB) + {out.with_suffix('.rt4.json')}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
