#!/bin/bash
# Qwen3.6-35B-A3B(GGUF) 常驻引擎：权重只加载一次，之后反复用（CLI / HTTP 共用）。
#
#   bash scripts/q36_engine.sh start     # 起常驻引擎（37.8 GB 上卡一次，约 2 分钟）
#   bash scripts/q36_engine.sh status
#   bash scripts/q36_engine.sh stop
#
# 引擎通过两个 FIFO 说话（build/q36.engine.in / .out），协议就是 build/rt --engine：
#   RESET / PREFILL <ids> / GEN <n> ... / MTP <k> / QUIT
# scripts/q36.py 不传 --spawn 时会直接连这个常驻引擎，不再重复加载权重。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

GGUF="${RT_GGUF:-$ROOT/models/Qwen3.6-35B-A3B-q8/Qwen3.6-35B-A3B-Q8_0.gguf}"
ENGINE="${RT_ENGINE_BIN:-$ROOT/build/rt}"
IN="$ROOT/build/q36.engine.in"
OUT="$ROOT/build/q36.engine.out"
PID="$ROOT/build/q36.engine.pid"
LOG="$ROOT/build/q36.engine.log"
export LD_LIBRARY_PATH="/opt/hyhal/lib:/opt/hyhal/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export RT_HSACO="${RT_HSACO:-$ROOT/build/k100lc_all.hsaco}"

case "${1:-start}" in
  start)
    [ -x "$ENGINE" ] || { echo "缺引擎 $ENGINE（先跑 bash build.sh）" >&2; exit 1; }
    [ -r "$GGUF" ]   || { echo "缺权重 $GGUF" >&2; exit 1; }
    if [ -f "$PID" ] && kill -0 "$(cat "$PID")" 2>/dev/null; then
      echo "引擎已在运行（PID $(cat "$PID")）"; exit 0
    fi
    mkdir -p "$ROOT/build"
    [ -p "$IN" ]  || mkfifo "$IN"
    [ -p "$OUT" ] || mkfifo "$OUT"
    # 先用读写方式打开两个 FIFO，这样引擎启动不会因为「没有对端」而阻塞
    exec 3<>"$IN"
    exec 4<>"$OUT"
    setsid "$ENGINE" --gguf "$GGUF" --engine <&3 >&4 2>>"$LOG" &
    EPID=$!
    echo "$EPID" > "$PID"
    # 等 READY（从 log 里看引擎自己的输出会进 OUT，这里直接等进程活着 + 端口就绪）
    for _ in $(seq 1 600); do
      if ! kill -0 "$EPID" 2>/dev/null; then
        echo "引擎启动失败，日志尾部：" >&2; tail -20 "$LOG" >&2; exit 1
      fi
      if grep -q "权重绑定完成" "$LOG" 2>/dev/null; then break; fi
      sleep 0.5
    done
    sleep 0.5
    echo "常驻引擎已启动：PID $EPID"
    echo "  FIFO : $IN / $OUT"
    echo "  日志 : tail -f $LOG"
    ;;
  stop)
    if [ -f "$PID" ] && kill -0 "$(cat "$PID")" 2>/dev/null; then
      kill -TERM "$(cat "$PID")" 2>/dev/null || true
      sleep 1
      kill -KILL "$(cat "$PID")" 2>/dev/null || true
      rm -f "$PID"
      echo "已停止常驻引擎"
    else
      echo "引擎未运行"
    fi
    ;;
  status)
    if [ -f "$PID" ] && kill -0 "$(cat "$PID")" 2>/dev/null; then
      echo "运行中：PID $(cat "$PID")"
      ps -o pid,rss,vsz,etime,cmd -p "$(cat "$PID")" | tail -1
    else
      echo "未运行"
    fi
    ;;
  *) echo "用法: bash scripts/q36_engine.sh start|stop|status" >&2; exit 1 ;;
esac
