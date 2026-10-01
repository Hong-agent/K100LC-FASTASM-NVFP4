#!/bin/bash
# 本项目唯一的环境入口：**不依赖 DTK 工具链，也不依赖 Docker**。
#
# 需要的东西只有三样：
#   1) 本机 DCU 驱动 + HSA 运行时（/opt/hyhal，`hy-smi` 能列出卡）
#   2) 主机 g++（只用来编译 host 代码）
#   3) Python 3（汇编内核 / 打包 / 起服务）
#
# 编译产物 build/rt 只链接 libhsa-runtime64，DTK 库引用为 0。
#
#   source scripts/env.sh
#
# 不设置 set -e/-u，避免影响交互式 shell。

export RT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"

# ---------------- 权重与产物 ----------------
# 默认模型：Qwen3.8-27B-INT4（RedHatAI 原生 pack-quantized int4 checkpoint，
# 由 tools/convert.c 的 int4 分支转成 RT4）。NVFP4 checkpoint 是显式 opt-in：
#   RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 bash serve.sh
export RT_MODEL_DIR="${RT_MODEL_DIR:-$RT_ROOT/models/Qwen3.8-27B-INT4}"
export RT_RT4="${RT_RT4:-$RT_MODEL_DIR/rt4/qwen38_27b.rt4}"
export RT_RT4_JSON="${RT_RT4_JSON:-$RT_MODEL_DIR/rt4/qwen38_27b.rt4.json}"
export RT_MTP="${RT_MTP:-$RT_MODEL_DIR/rt4/qwen38_27b_mtp.rt4}"
export RT_VISION_RT4="${RT_VISION_RT4:-$RT_MODEL_DIR/rt4/qwen38_27b_vision.rt4}"
# 视觉塔默认在 DCU 上跑（引擎的 IMG_EMB，27 层）。**它不进 .rp4**：引擎直接从
# 下面这个 RT_VISION_RT4 文件加载（默认打包 VISION_RP4=0）。
# 想让 27 层改在 CPU 上算（scripts/vision_cpu.py，纯 NumPy，引擎不加载视觉权重）：
# RT_VISION_DEVICE=cpu。
export RT_VISION_DEVICE="${RT_VISION_DEVICE:-gpu}"

# ---------------- 默认精度：全 W4A8 ----------------
# 项目默认三条链路都用「int4 权重 × int8 激活」：
#   大模型  RT_INT4_NATIVE=0 关掉 checkpoint 原生 int4（W4A16），走 RT4 的 W4A8；
#   MTP     RT_MTP_W8=0：用 int4 权重，不用 W8A8 的 .hi/.lo；
#   视觉塔  权重是 tools/convert_vision_rt4.py 的 int4/128 产物，在 GPU 上跑。
# 都不用 NVFP4 / W4A16 / W4A4。想回旧路线就显式覆盖这几个环境变量。
export RT_NVFP4="${RT_NVFP4:-0}"
export RT_RP4="${RT_RP4:-0}"
export RT_INT4_NATIVE="${RT_INT4_NATIVE:-0}"
export RT_ACT4="${RT_ACT4:-0}"
export RT_MTP_W8="${RT_MTP_W8:-0}"

# 权重单文件：优先模型目录里的 model.rp4（离线包里就是它），其次 build/model-int4.rp4
# （本机开发时 scripts/pack_weights.sh 的默认产物）。两者都没有时退回
# 「NVFP4 清单 + 原始 safetensors」直读（只有 NVFP4 路线才用得上）。
if [ -z "${RT_RP4:-}" ]; then
  for _p in "$RT_MODEL_DIR/model.rp4" "$RT_ROOT/build/model-int4.rp4"; do
    [ -r "$_p" ] && { export RT_RP4="$_p"; break; }
  done
fi
export RT_NVFP4_MANIFEST="${RT_NVFP4_MANIFEST:-$RT_ROOT/build/nvfp4_manifest.tsv}"

# ---------------- 原生 compressed-tensors INT4（K100LC-kernels 的 int4_dot_k）--------
# 默认开启：线性层的**解码/小批**直接吃 checkpoint 的 weight_packed + weight_scale
# （不转换、不重量化），走 K100LC-kernels 的 int4_dot_k（W4A16）。清单由那个包的
# tools/int4_engine_manifest.py 生成；RT_INT4_NATIVE=0 可回到纯 RT4 路线，
# RT_INT4_PREFILL=native 让预填充也走原生内核（默认仍用 RT4 的 W4A8 GEMM，快得多）。
export RT_INT4_MANIFEST="${RT_INT4_MANIFEST:-$RT_ROOT/build/int4_manifest.tsv}"
export RT_INT4_SAFETENSORS="${RT_INT4_SAFETENSORS:-$RT_MODEL_DIR/model.safetensors}"
export RT_NVFP4_SAFETENSORS="${RT_NVFP4_SAFETENSORS:-$RT_ROOT/models/Qwen3.8-27B-NVFP4/model.safetensors}"

# ---------------- 内核 / 运行时 ----------------
# build/ 是自己编出来的；没有就退到随包附带的 prebuilt/（这样解压后不编译也能跑）。
if [ -z "${RT_HSACO:-}" ]; then
  for _p in "$RT_ROOT/build/k100lc_all.hsaco" "$RT_ROOT/prebuilt/k100lc_all.hsaco"; do
    [ -r "$_p" ] && { export RT_HSACO="$_p"; break; }
  done
  export RT_HSACO="${RT_HSACO:-$RT_ROOT/build/k100lc_all.hsaco}"
fi
if [ -z "${RT_ENGINE_BIN:-}" ]; then
  for _p in "$RT_ROOT/build/rt" "$RT_ROOT/prebuilt/rt"; do
    [ -x "$_p" ] && { export RT_ENGINE_BIN="$_p"; break; }
  done
  export RT_ENGINE_BIN="${RT_ENGINE_BIN:-$RT_ROOT/build/rt}"
fi

# HSA 运行时（唯一的非 libc 动态依赖）。注意：这里**没有** DTK 的 hip/comgr 目录。
export LD_LIBRARY_PATH="/opt/hyhal/lib:/opt/hyhal/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

# ---------------- Python ----------------
# 服务端（scripts/serve.py、scripts/chat.py）需要 fastapi / uvicorn / tokenizers /
# jinja2 / numpy。runtime/ 下自带一份（gitignore，不随源码包发布）；有它就优先用，
# 没有就退回系统 python3 + 自行 pip 安装（见 README「依赖」）。
#
# 注意：这里**不改 PATH、不设 PYTHONHOME**，让 `python3` 保持系统解释器不变
# （build.sh 的汇编/打包脚本要用系统的 msgpack）。需要跑服务时用 $RT_PYTHON，
# 并把 $RT_PY_DEPS 加进 PYTHONPATH（serve.sh / run.sh 已经处理好）。
export RT_PY_DEPS="${RT_PY_DEPS:-$RT_ROOT/runtime/py}"
if [ -z "${RT_PYTHON:-}" ] && [ -x "$RT_ROOT/runtime/python/bin/python3.10" ]; then
  export RT_PYTHON="$RT_ROOT/runtime/python/bin/python3.10"
fi
export RT_PYTHON="${RT_PYTHON:-python3}"

# ---------------- 杂项 ----------------
export USER="${USER:-$(id -un)}"
export LOGNAME="${LOGNAME:-$USER}"
export RT_ARCH="${RT_ARCH:-gfx926}"
export PYTHONUNBUFFERED=1
