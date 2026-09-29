#!/bin/bash
# 联网把源模型 unsloth/Qwen3.8-27B-NVFP4 拉到 models/Qwen3.8-27B-NVFP4/。
#
#   bash scripts/fetch_model.sh              # 缺什么补什么（幂等、断点续传）
#   bash scripts/fetch_model.sh --check      # 只校验已下载的文件，不联网
#   SOURCE=ms|hf bash scripts/fetch_model.sh # 换下载源（默认 ms = 魔搭镜像）
#
# 只需要三样东西就能把项目跑起来（其余都是权重转换的中间产物）：
#   model.safetensors        22.57 GB   主模型（FP8 + NVFP4 混合精度）
#   model_mtp.safetensors     0.85 GB   MTP 投机头
#   tokenizer/模板/config             分词、chat 模板、结构
#
# 大文件用 tools/fetch_par2.py：16 连接 + HTTP Range 断点续传。模搭单连接实测
# 只有 200KB/s，直连 HF 会被 302 到被墙的 CDN。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MODEL_DIR="${MODEL_DIR:-$ROOT/models/Qwen3.8-27B-NVFP4}"
SOURCE="${SOURCE:-ms}"
CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

HF_REPO="${HF_REPO:-unsloth/Qwen3.8-27B-NVFP4}"
MS_BASE="${MS_BASE:-https://modelscope.cn/api/v1/models/$HF_REPO/repo?Revision=master&FilePath=}"
HF_BASE="${HF_BASE:-https://huggingface.co/$HF_REPO/resolve/main/}"

# 源权重指纹（改源快照时同步更新）
SHA256_MAIN=c473512c70eace07e2256fe9fd76596ac03e3295bee7d54cfb72676416afcc05
SIZE_MAIN=22568192096
SHA256_MTP=1d8268aa85ace093a561e3e7b63b9d390dac1cd55a90cd55b5ec509c3c9da9fe
SIZE_MTP=849400392

case "$SOURCE" in
  ms|modelscope) BASE="$MS_BASE" ;;
  hf|huggingface) BASE="$HF_BASE" ;;
  *) echo "SOURCE 只能是 ms 或 hf（当前 $SOURCE）" >&2; exit 1 ;;
esac

mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

small=(config.json generation_config.json model.safetensors.index.json \
       tokenizer.json vocab.json chat_template.jinja model_mtp.safetensors)

if [ "$CHECK_ONLY" = 0 ]; then
  for f in "${small[@]}"; do
    [ -s "$f" ] && continue
    echo "== 下载 $f =="
    curl -L -C - --retry 20 --retry-delay 4 --retry-all-errors -sS -o "$f" "$BASE$f" \
      || { echo "下载 $f 失败" >&2; exit 1; }
  done
  if [ ! -s model.safetensors ] || [ "$(stat -c%s model.safetensors)" != "$SIZE_MAIN" ]; then
    echo "== 并行下载 model.safetensors（22.57 GB，16 连接，可断点续传）=="
    PY="$(command -v python3)"
    "$PY" "$ROOT/tools/fetch_par2.py" "${BASE}model.safetensors" model.safetensors \
          "$SIZE_MAIN" 16 128 "$SHA256_MAIN"
  fi
fi

echo "== 校验 =="
check_one() {                       # $1=文件 $2=sha256 $3=字节数
  local f="$1" want="$2" size="$3" got sz
  [ -s "$f" ] || { echo "  MISS $f" >&2; return 1; }
  sz=$(stat -c%s "$f")
  got=$(sha256sum "$f" | cut -d' ' -f1)
  if [ "$got" = "$want" ] && [ "$sz" = "$size" ]; then
    echo "  OK   $f  $sz bytes"
  else
    echo "  FAIL $f  实得 $sz bytes / $got" >&2
    echo "       期望 $size bytes / $want" >&2
    return 1
  fi
}
rc=0
check_one model.safetensors "$SHA256_MAIN" "$SIZE_MAIN" || rc=1
check_one model_mtp.safetensors "$SHA256_MTP" "$SIZE_MTP" || rc=1
for f in config.json generation_config.json tokenizer.json vocab.json chat_template.jinja; do
  [ -s "$f" ] && echo "  OK   $f" || { echo "  MISS $f" >&2; rc=1; }
done

echo
echo "源模型就位：$MODEL_DIR"
echo "下一步：bash scripts/setup_models.sh && bash scripts/deploy_online.sh"
exit "$rc"
