#!/bin/bash
# 一条命令构建整个项目。**不需要 DTK，不需要 Docker。**
#
#   bash build.sh          # 汇编内核 -> 单个 HSACO -> 生成 host 源码 -> g++ 编出 build/rt
#   bash build.sh --check  # 构建后追加内核自检与 HSA 加载检查
#
# 只用到：Python（自研汇编器 + 打包脚本，随包自带一份）、g++（host 代码）、
# /opt/hyhal（HSA 运行时，来自 DCU 驱动）。
#
# 提示：源码包里带了 prebuilt/rt，**不编译也能直接跑**（run.sh / serve.sh 会自动用它）。
# 这个脚本是在需要重新生成内核机器码或改造内核时才用。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

BUILD="$ROOT/build"
mkdir -p "$BUILD"

echo "== 0/4 环境检查 =="
command -v g++     >/dev/null || { echo "缺 g++（主机编译器）" >&2; exit 1; }
if [ ! -d /opt/hyhal/include ] || [ ! -d /opt/hyhal/lib ]; then
  echo "缺 /opt/hyhal（DCU 驱动自带的 HSA 运行时）；先安装 DCU 驱动，见 driver/INSTALL.md" >&2
  exit 1
fi

# 找一个能用 msgpack 的 Python：优先本项目自带的（离线包里就有），其次系统 python3。
PY=""
if [ -x "$ROOT/runtime/python/bin/python3.10" ] &&
   PYTHONPATH="$ROOT/runtime/py" "$ROOT/runtime/python/bin/python3.10" -c 'import msgpack' 2>/dev/null; then
  PY="$ROOT/runtime/python/bin/python3.10"
  export PYTHONPATH="$ROOT/runtime/py${PYTHONPATH:+:$PYTHONPATH}"
elif command -v python3 >/dev/null && python3 -c 'import msgpack' 2>/dev/null; then
  PY=python3
else
  echo "找不到带 msgpack 的 Python（自带 runtime/python 也没有，系统 python3 也没有）" >&2
  exit 1
fi
echo "   python: $PY ($("$PY" -V 2>&1 | awk '{print $2}'))"
echo "   $(g++ --version | head -1)"

echo "== 1/4 用自研汇编器汇编全部内核 =="
"$PY" tools/build_kernels.py

echo "== 2/4 合成单个自研 HSACO =="
"$PY" tools/make_hsaco_multi.py "$BUILD/all_kernels_spec.json" "$BUILD/k100lc_all.hsaco" \
  | grep -E '^wrote|^ *\[0\]' | head -2
"$PY" - "$BUILD/k100lc_all.hsaco" <<'PYEOF'
import sys, hashlib
data = open(sys.argv[1], 'rb').read()
print(f"   {len(data)} 字节  sha256={hashlib.sha256(data).hexdigest()}")
PYEOF

echo "== 3/4 生成无 DTK 的 host 源码 =="
"$PY" tools/gen_nodtk.py --hsaco "$BUILD/k100lc_all.hsaco" --out "$BUILD/nodtk" | tail -3

echo "== 4/4 编译运行时（g++，只链接 libhsa-runtime64）=="
g++ -O2 -std=c++17 -DRT_NODTK \
    -I "$BUILD/nodtk" -I "$ROOT/runtime" -I "$ROOT/src" -I /opt/hyhal/include \
    -DRT_HSACO_DEFAULT="\"build/k100lc_all.hsaco\"" \
    "$BUILD"/nodtk/*.cpp "$ROOT/runtime/hsa_rt.cpp" \
    -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 -lpthread \
    -o "$BUILD/rt"
echo "   产物：$BUILD/rt"
echo "   动态依赖：$(ldd "$BUILD/rt" | awk '{print $1}' | grep -E 'hsa|hip|comgr|galaxy' | tr '\n' ' ')"
echo "   DTK 库引用：$(ldd "$BUILD/rt" | grep -c -E 'galaxyhip|comgr|libhip')"

if [ "${1:-}" = "--check" ]; then
  echo "== 自检 =="
  "$PY" tests/test_asm.py
  g++ -O2 -I/opt/hyhal/include tools/hsa_min_loader.c \
      -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
      -o "$BUILD/hsa_min_loader"
  HSA_LOADER_RESOLVE_ONLY=1 "$BUILD/hsa_min_loader" "$BUILD/k100lc_all.hsaco" _Z11scale_mul_kPffx
fi

# 顺手刷新随包的 prebuilt（换内核/改运行时后，部署方不编译也能跑）
mkdir -p "$ROOT/prebuilt"
cp -f "$BUILD/k100lc_all.hsaco" "$ROOT/prebuilt/k100lc_all.hsaco"
cp -f "$BUILD/rt" "$ROOT/prebuilt/rt"

echo
echo "构建完成。下一步："
echo "  bash serve.sh            # 网页控制台 + OpenAI 兼容接口"
echo "  bash run.sh --prompt 你好 # 命令行对话"
