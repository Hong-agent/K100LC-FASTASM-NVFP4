#!/bin/bash
# 从 GSQ-RCO GGUF 生成引擎可直跑的 RT4（int4/group128）。
#
#   bash tools/make_gsq_rt4.sh [GGUF路径] [输出前缀]
#
# 步骤：
#   1) GGUF → RT4：ggml 原生解码 → int4(group128) 重量化（build/gguf_requant）
#   2) 非量化小张量（norm/conv1d/A_log/dt_bias/in_proj_a,b…）沿用参考 RT4
#      —— GGUF 与 HF 对这些张量的约定不同（ssm_a=-exp(A_log)、v-head 顺序等）
#   3) v-head 顺序换算：GGUF 是 (v,g)，HF 是 (g,v)，必须把
#      in_proj_qkv 的 v 段 / in_proj_z 的行块按 P 重排，否则隐藏状态对不上
#   4) embed_tokens / lm_head / out_proj 用参考 RT4 的 int4 覆盖：
#      GGUF 这三处是 IQ2_S/Q4_K，重量化到 int4 后误差过大
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GGUF="${1:-/home/t/桌面/Qwen3.8-27B-GSQ-RCO-GGUF/Qwen3.8-27B-GSQ-RCO-IQ3_S-mtp.gguf}"
OUT="${2:-$HERE/build/qwen38_gsq.rt4}"
REF="$HERE/models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4"
cd "$HERE"

python3 tools/gguf_to_rt4.py --gguf "$GGUF" --out "$OUT" --params-from "$REF"
python3 tools/gguf_vhead_perm.py --rt4 "$OUT" --fix
python3 - "$OUT" "$REF" <<'PY'
import json, sys
out, ref = sys.argv[1], sys.argv[2]
keep = ("model.language_model.embed_tokens.weight", "lm_head.weight")
A = {t["name"]: t for t in json.load(open(out + ".json"))["tensors"]}
B = {t["name"]: t for t in json.load(open(ref.replace(".rt4", ".rt4.json")))["tensors"]}
sel = [n for n in A if n in keep or n.endswith("linear_attn.out_proj.weight")]
with open(out, "r+b") as fo, open(ref, "rb") as fr:
    for nm in sel:
        t, r = A[nm], B[nm]
        assert t["nbytes"] == r["nbytes"] and t["kind"] == r["kind"] == "i4", nm
        fr.seek(r["q_off"]); fo.seek(t["q_off"]); fo.write(fr.read(r["nbytes"]))
print(f"  参考 int4 覆盖 embed/lm_head/out_proj：{len(sel)} 张量")
PY
echo "完成：$OUT"
