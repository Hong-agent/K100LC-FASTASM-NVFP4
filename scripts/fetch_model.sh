#!/bin/bash
# 联网把源模型拉到 models/ 下（默认拉**全项目默认的 int4** checkpoint）。
#
#   bash scripts/fetch_model.sh                # RedHatAI/Qwen3.8-27B-INT4 → models/Qwen3.8-27B-INT4/
#   VARIANT=nvfp4 bash scripts/fetch_model.sh  # opt-in：unsloth/Qwen3.8-27B-NVFP4 → models/Qwen3.8-27B-NVFP4/
#   bash scripts/fetch_model.sh --check        # 只校验已下载的文件，不联网
#   SOURCE=ms|hf bash scripts/fetch_model.sh   # 换下载源（默认 ms = 魔搭镜像）
#
# 默认（int4）只需要三样东西就能把项目跑起来（其余都是转换的中间产物）：
#   model.safetensors        18.60 GB   主模型（compressed-tensors pack-quantized int4）
#   model_mtp.safetensors     0.85 GB   MTP 投机头（与 NVFP4 checkpoint 逐字节相同）
#   tokenizer/模板/config              分词、chat 模板、结构
#
# 大文件用 tools/fetch_par2.py：16 连接 + HTTP Range 断点续传。模搭单连接实测
# 只有 200KB/s，直连 HF 会被 302 到被墙的 CDN。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VARIANT="${VARIANT:-int4}"
SOURCE="${SOURCE:-ms}"
CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

case "$VARIANT" in
  int4)
    HF_REPO="${HF_REPO:-RedHatAI/Qwen3.8-27B-INT4}"
    MODEL_DIR="${MODEL_DIR:-$ROOT/models/Qwen3.8-27B-INT4}"
    SHA256_MAIN=fd5c287e3a03f30b0e53fd5fe66ec90ab5fdd94807f7f8df699cca3ae9534910
    SIZE_MAIN=18603387656
    SHA256_MTP=1d8268aa85ace093a561e3e7b63b9d390dac1cd55a90cd55b5ec509c3c9da9fe
    SIZE_MTP=849400392
    # int4 仓库里不一定带 MTP 头；没有就从 NVFP4 checkpoint 补（两份逐字节相同）。
    MTP_REPO="${MTP_REPO:-unsloth/Qwen3.8-27B-NVFP4}"
    SMALL=(config.json generation_config.json model.safetensors.index.json tokenizer.json \
           tokenizer_config.json processor_config.json recipe.yaml chat_template.jinja)
    ;;
  nvfp4)
    HF_REPO="${HF_REPO:-unsloth/Qwen3.8-27B-NVFP4}"
    MODEL_DIR="${MODEL_DIR:-$ROOT/models/Qwen3.8-27B-NVFP4}"
    SHA256_MAIN=c473512c70eace07e2256fe9fd76596ac03e3295bee7d54cfb72676416afcc05
    SIZE_MAIN=22568192096
    SHA256_MTP=1d8268aa85ace093a561e3e7b63b9d390dac1cd55a90cd55b5ec509c3c9da9fe
    SIZE_MTP=849400392
    MTP_REPO="$HF_REPO"
    SMALL=(config.json generation_config.json model.safetensors.index.json \
           tokenizer.json vocab.json chat_template.jinja)
    ;;
  *) echo "VARIANT 只能是 int4 / nvfp4（当前 $VARIANT）" >&2; exit 1 ;;
esac

base_for() {                       # $1=仓库名 → 下载前缀
  case "$SOURCE" in
    ms|modelscope)  printf 'https://modelscope.cn/api/v1/models/%s/repo?Revision=master&FilePath=' "$1" ;;
    hf|huggingface) printf 'https://huggingface.co/%s/resolve/main/' "$1" ;;
    *) echo "SOURCE 只能是 ms 或 hf（当前 $SOURCE）" >&2; exit 1 ;;
  esac
}
BASE="$(base_for "$HF_REPO")"
MTP_BASE="$(base_for "$MTP_REPO")"

# -f：HTTP 404 之类直接失败，别把错误页写进权重文件。
get() {                            # $1=base $2=文件名
  curl -L -C - --retry 20 --retry-delay 4 --retry-all-errors -fsS -o "$2" "$1$2"
}

mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

if [ "$CHECK_ONLY" = 0 ]; then
  for f in "${SMALL[@]}"; do
    [ -s "$f" ] && continue
    echo "== 下载 $f =="
    get "$BASE" "$f" || { echo "下载 $f 失败" >&2; exit 1; }
  done
  if [ ! -s model_mtp.safetensors ] || [ "$(stat -c%s model_mtp.safetensors)" != "$SIZE_MTP" ]; then
    echo "== 下载 model_mtp.safetensors（MTP 投机头）=="
    if ! get "$BASE" model_mtp.safetensors; then
      rm -f model_mtp.safetensors
      echo "   $HF_REPO 里没有，改从 $MTP_REPO 取（两份逐字节相同）"
      get "$MTP_BASE" model_mtp.safetensors || { echo "下载 model_mtp.safetensors 失败" >&2; exit 1; }
    fi
  fi
  if [ ! -s model.safetensors ] || [ "$(stat -c%s model.safetensors)" != "$SIZE_MAIN" ]; then
    echo "== 并行下载 model.safetensors（$((SIZE_MAIN / 1000000000)) GB，16 连接，可断点续传）=="
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
for f in "${SMALL[@]}"; do
  [ -s "$f" ] && echo "  OK   $f" || { echo "  MISS $f" >&2; rc=1; }
done

echo
echo "源模型就位（$VARIANT）：$MODEL_DIR"
echo "下一步：bash scripts/setup_models.sh && bash scripts/deploy_online.sh"
exit "$rc"
