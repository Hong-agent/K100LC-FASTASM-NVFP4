#!/bin/bash
# 启动网页控制台 + OpenAI 兼容接口（网页来自 K100LC-RT4/web，后端是本项目的 build/rt）。
# **默认 = 全 W4A8**：大模型 / MTP / 视觉塔都是 int4 权重 × int8 激活，
# 权重直接用 models/Qwen3.8-27B-INT4/rt4 下的 .rt4（不走 .rp4 / NVFP4 / W4A16）。
# 这三个默认值在 scripts/env.sh 里（RT_NVFP4=0 / RT_RP4=0 / RT_INT4_NATIVE=0 /
# RT_ACT4=0 / RT_MTP_W8=0 / RT_VISION_DEVICE=gpu），需要旧路线就显式覆盖。
#
#   bash serve.sh                         # 默认 http://<本机IP>/（监听 80，不带端口号）
#   PORT=8080 CTX=40960 MTP_N=0 bash serve.sh
#   bash serve.sh --stop
#
# 换成 NVFP4 checkpoint（opt-in，会覆盖默认的 W4A8 设置）：
#   RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 RT_RP4=build/model.rp4 bash serve.sh
#
# 前端引擎是 build/rt：自研汇编器产出的 HSACO + /opt/hyhal 的 HSA 直跑，
# 不经过 DTK，也不经过 Docker。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/scripts/env.sh"
cd "$RT_ROOT"

# 默认监听 80，这样局域网里直接访问 http://<本机IP>/ 就行（不用带端口号）。
PORT="${PORT:-80}"
CTX="${CTX:-40960}"
# MTP 草稿数的默认值：默认路线是 RT4 W4A8（RT_INT4_NATIVE=0），MTP 划算 → 默认 3。
# 若手动开回原生 int4（RT_INT4_NATIVE=1，W4A16），验证批要按行重读权重
# （4 行 = 4 遍），实测 6.9 tok/s 反而低于无 MTP 的 10.1 tok/s → 那种配置下默认关。
if [ -z "${MTP_N:-}" ]; then
  if [ "${RT_INT4_NATIVE:-1}" = "0" ]; then MTP_N=3; else MTP_N=0; fi
fi
PIDFILE="$RT_ROOT/build/serve.pid"
LOGFILE="$RT_ROOT/build/serve.log"
NO_MTP_FLAG=""
[ "${NO_MTP:-0}" != "0" ] && NO_MTP_FLAG="--no-mtp"

export RT_ENGINE_BIN="${RT_ENGINE_BIN:-$RT_ROOT/build/rt}"
export RT_SERVED_NAME="${RT_SERVED_NAME:-qwen38-fastasm-int4}"
# RT_VISION_DEVICE 默认 gpu，由 scripts/env.sh 设置（视觉塔不进 .rp4，从 RT_VISION_RT4 单独加载）

# --stop 只读 pidfile，不碰端口：必须放在特权端口检查**之前**，
# 否则默认 80 + 没有 cap_net_bind_service 时会先报错退出，服务停不掉。
if [ "${1:-}" = "--stop" ]; then
  if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    SRV_PID="$(cat "$PIDFILE")"
    # 进程组里挂着引擎子进程，杀整组，别留孤儿占显存。
    kill -TERM -"$SRV_PID" 2>/dev/null || kill -TERM "$SRV_PID" 2>/dev/null
    rm -f "$PIDFILE"
    echo "已停止 serve"
  else
    echo "serve 未运行"
  fi
  exit 0
fi

# 80 是特权端口：非 root 时要么给解释器一次性加能力，要么退回高位端口。
if [ "$PORT" -lt 1024 ] && [ "$(id -u)" != 0 ] && command -v getcap >/dev/null 2>&1; then
  if ! getcap "$RT_PYTHON" 2>/dev/null | grep -q cap_net_bind_service; then
    echo "端口 $PORT 是特权端口，而 $RT_PYTHON 没有 cap_net_bind_service。" >&2
    echo "  一次性授权： sudo setcap 'cap_net_bind_service=+ep' $RT_PYTHON" >&2
    echo "  或改用高位端口： PORT=8080 bash serve.sh" >&2
    exit 1
  fi
fi

if [ ! -x "$RT_ENGINE_BIN" ]; then
  echo "缺少引擎 $RT_ENGINE_BIN，先跑：bash build.sh" >&2
  exit 1
fi
if [ ! -r "$RT_MODEL_DIR/tokenizer.json" ]; then
  echo "缺少 tokenizer：$RT_MODEL_DIR/tokenizer.json" >&2
  echo "先跑：bash scripts/setup_models.sh" >&2
  exit 1
fi
# 权重来源二选一：.rp4 单文件，或直接给 --model/--json 的 .rt4（如 GGUF 转出来的）。
# RT_RP4=0 表示显式关闭 .rp4 单文件模式（serve.py / 引擎都认这个约定）。
if [ "${RT_RP4:-}" = "0" ] || [ ! -r "${RT_RP4:-}" ]; then
  if [ -r "${RT_RT4:-}" ] && [ -r "${RT_RT4_JSON:-}" ]; then
    echo "  （无 .rp4，直接用 RT4：$RT_RT4）"
    export RT_RP4=0
  else
    echo "缺少权重 ${RT_RP4:-（未设置）}" >&2
    echo "  默认模型是 int4：先跑 bash scripts/convert_weights.sh && bash scripts/pack_weights.sh" >&2
    exit 1
  fi
fi

mkdir -p "$RT_ROOT/build"
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "serve 已在运行，PID $(cat "$PIDFILE")（日志 $LOGFILE）" >&2
  exit 0
fi

set -o allexport
PYTHONPATH="$RT_PY_DEPS${PYTHONPATH:+:$PYTHONPATH}"
export PYTHONPATH
set +o allexport

if command -v setsid >/dev/null 2>&1; then
  setsid bash -c 'echo $$ >"$1"; shift; exec "$RT_PYTHON" "$@"' _ "$PIDFILE" \
    scripts/serve.py --port "$PORT" --ctx "$CTX" \
    --default-max-tokens "${RT_DEFAULT_MAX_TOKENS:-40960}" --mtp-n "$MTP_N" $NO_MTP_FLAG \
    >"$LOGFILE" 2>&1 </dev/null &
else
  nohup "$RT_PYTHON" scripts/serve.py --port "$PORT" --ctx "$CTX" \
    --default-max-tokens "${RT_DEFAULT_MAX_TOKENS:-40960}" --mtp-n "$MTP_N" $NO_MTP_FLAG \
    >"$LOGFILE" 2>&1 </dev/null &
  echo "$!" >"$PIDFILE"
fi

for _ in $(seq 1 240); do
  if grep -q '\[serve\] 模型就绪' "$LOGFILE" 2>/dev/null; then break; fi
  PID="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [ -z "$PID" ] || ! kill -0 "$PID" 2>/dev/null; then
    echo "启动失败，日志尾部：" >&2
    tail -40 "$LOGFILE" >&2 || true
    rm -f "$PIDFILE"
    exit 1
  fi
  sleep 0.5
done

# 「模型就绪」是在绑端口之前打的，端口被占用时要再确认一次，别误报成功。
sleep 0.5
PID="$(cat "$PIDFILE" 2>/dev/null || true)"
if [ -z "$PID" ] || ! kill -0 "$PID" 2>/dev/null || \
   grep -qE 'address already in use|\[Errno 98\]' "$LOGFILE" 2>/dev/null; then
  echo "启动失败（端口 $PORT 可能被占用），日志尾部：" >&2
  tail -20 "$LOGFILE" >&2 || true
  kill -TERM -"$PID" 2>/dev/null || kill -TERM "$PID" 2>/dev/null || true
  rm -f "$PIDFILE"
  exit 1
fi

LAN_IP="$(ip -4 -o addr show scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | grep -v '^172\.17\.' | head -1)"
PORT_SUFFIX=":$PORT"; [ "$PORT" = "80" ] && PORT_SUFFIX=""
echo "网页控制台已启动（引擎 $RT_ENGINE_BIN）"
echo "  网页 : http://${LAN_IP:-127.0.0.1}${PORT_SUFFIX}/"
echo "  接口 : http://${LAN_IP:-127.0.0.1}${PORT_SUFFIX}/v1"
echo "  日志 : tail -f $LOGFILE"
echo "  停止 : bash serve.sh --stop"
