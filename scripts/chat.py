#!/usr/bin/env python3
# 命令行对话：分词 → 引擎前向/生成 → 解码成文本。在 DTK 容器里跑：
#   bash scripts/dsh.sh 'python3 scripts/chat.py --prompt "你好" --n 64 --temp 0'
#
#   python3 scripts/chat.py --prompt "你好" --n 64 --temp 0
#   python3 scripts/chat.py --ids 248045,... --n 32 --raw
import argparse
import os
import queue
import subprocess
import sys
import threading
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import tok as T                                                   # noqa: E402

EOS = [248044, 248046]          # <|endoftext|> / <|im_end|>


class GenStream:
    """一次 GEN 的输出（TOK... / END...）读进队列，读到 END 或 EOF 后线程退出。

    每请求一个专属线程 + 队列，见 Engine.gen_stream 的说明。
    """

    def __init__(self, out):
        self._out = out
        self.q = queue.Queue()
        self.t = threading.Thread(target=self._run, daemon=True)

    def _run(self):
        while True:
            line = self._out.readline()
            self.q.put(line)
            if not line or line.startswith('END '):
                break

    def start(self):
        self.t.start()

    def get(self):
        """取下一行（'' 表示引擎退出）。阻塞，通常在 to_thread 里调用。"""
        return self.q.get()

    def join(self, timeout=None):
        self.t.join(timeout)


class Engine:
    """rt --engine 子进程的薄封装（含崩溃自愈：引擎死了 ensure() 会重新拉起）。"""

    def __init__(self, model=None, json=None, cmd=None, log=None, ctx=None, mtp_n=None,
                 no_mtp=False, env_extra=None, stderr=None):
        model = model or os.environ.get('RT_RT4',
                                        os.path.join(ROOT, 'models/Qwen3.8-27B-NVFP4/rt4/qwen38_27b.rt4'))
        json = json or os.environ.get('RT_RT4_JSON',
                                      os.path.join(ROOT, 'models/Qwen3.8-27B-NVFP4/rt4/qwen38_27b.rt4.json'))
        env = dict(os.environ)
        if env_extra:
            env.update(env_extra)
        if cmd is None:
            # RT_ENGINE_BIN 可以把后端换成任意实现同一引擎协议的进程 ——
            # 例如 k100lc-asm 的 build/nodtk/rt（自研 HSACO + /opt/hyhal HSA，无 DTK）。
            exe = os.environ.get('RT_ENGINE_BIN') or os.path.join(ROOT, 'build', 'rt')
            cmd = [exe, '--engine', '--model', model, '--json', json]
            if ctx:
                cmd += ['--ctx', str(int(ctx))]
            if mtp_n is not None:
                cmd += ['--mtp-n', str(int(mtp_n))]
            if no_mtp:
                cmd += ['--no-mtp']
        # 供 /health 等展示当前 MTP 草稿数（RT 引擎默认 3，--no-mtp 时为 0）
        self.mtp_n = 0 if no_mtp else (3 if mtp_n is None else int(mtp_n))
        self.log = log
        self.lock = threading.Lock()
        self._cmd = cmd                       # 重启时原样复用
        self._env = env
        self._stderr = stderr                 # None=继承父进程；否则传给 Popen（bench 用来分阶段收 stderr）
        self.epoch = 0                        # 每次 ensure 重启 +1；调用方据此作废引擎侧状态
        self.restarts = 0                     # 累计自动重启次数（/health 展示用）
        self._restart_times = []              # crash-loop 保护用
        self._spawn()

    def _spawn(self):
        self.p = subprocess.Popen(self._cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                  stderr=self._stderr, bufsize=1, text=True, env=self._env)
        while True:
            line = self.p.stdout.readline()
            if not line:
                raise RuntimeError('引擎启动失败（进程退出）')
            if line.startswith('READY'):
                break
            if self.log:
                print(f'[engine] {line.strip()}', file=sys.stderr)

    def alive(self):
        return self.p is not None and self.p.poll() is None

    def ensure(self, max_restarts=3, window=300.0):
        """引擎死了就重启（阻塞，含权重加载，秒到分钟级）；活着时是廉价 no-op。

        crash-loop 保护：window 秒内已重启 max_restarts 次仍崩溃就放弃、抛
        RuntimeError，避免驱动持续故障时无限拉起。重启成功 epoch +1 —— 引擎的
        KV/会话状态全部清零，调用方（serve 的对话前缀缓存等）必须按 epoch 作废。
        """
        with self.lock:
            if self.alive():
                return self.epoch
            now = time.time()
            self._restart_times = [t for t in self._restart_times if now - t < window]
            if len(self._restart_times) >= max_restarts:
                raise RuntimeError(
                    f'引擎在 {window:.0f}s 内已重启 {max_restarts} 次仍崩溃，停止自动重启')
            code = self.p.returncode if self.p else '?'
            print(f'[engine] 引擎已退出（code={code}），自动重启…', file=sys.stderr)
            self._spawn()
            self._restart_times.append(time.time())
            self.restarts += 1
            self.epoch += 1
            print(f'[engine] 重启完成（epoch={self.epoch}）', file=sys.stderr)
            return self.epoch

    def cmd(self, s):
        try:
            self.p.stdin.write(s + '\n')
            self.p.stdin.flush()
        except (OSError, ValueError) as e:
            # 引擎死掉后 stdin 是破管道（BrokenPipeError）——统一转成 RuntimeError，
            # 调用方（serve 的自愈逻辑）只认这一种异常类型。
            raise RuntimeError(f'引擎已退出，无法发送命令（{e}）') from e

    def stop(self):
        """请求中断正在进行的一次生成（引擎在 GEN 循环里非阻塞看一眼 stdin）。"""
        try:
            self.p.stdin.write('STOP\n')
            self.p.stdin.flush()
        except (OSError, ValueError):
            pass

    def gen_stream(self, n, temp=0.0, top_p=1.0, top_k=0, seed=1234, stops=EOS):
        """发起一次生成，返回可逐行消费的 GenStream（用于流式转发）。

        读操作固定在一个「每请求专属」的线程里：客户端中途断开时 asyncio 取消的是
        协程，取消不了阻塞在 readline 的线程；专属线程保证残留的行只留在本次请求
        自己的队列里，不会串到下一个请求。
        """
        self.cmd(f'GEN {n} {temp} {top_p} {top_k} {seed} ' + ','.join(str(s) for s in stops))
        st = GenStream(self.p.stdout)
        st.start()
        return st

    def prefill(self, ids):
        with self.lock:
            self.cmd('PREFILL ' + ','.join(str(i) for i in ids))
            return self.p.stdout.readline().strip()

    def prefill_emb(self, ids, emb_path, spans):
        """带视觉 embedding 的 prefill；spans 为 [(start, count), ...]。"""
        spec = ','.join(f'{int(s)}:{int(c)}' for s, c in spans)
        with self.lock:
            self.cmd('PREFILL_EMB ' + ','.join(str(i) for i in ids) +
                     f' {emb_path} {spec}')
            return self.p.stdout.readline().strip()

    def image_embed(self, patch_path, out_path, gh, gw):
        """调用 RT4 视觉塔编码一张图片，返回 token 数。"""
        with self.lock:
            self.cmd(f'IMG_EMB {patch_path} {out_path} {int(gh)} {int(gw)}')
            while True:
                line = self.p.stdout.readline()
                if not line:
                    raise RuntimeError('引擎在图片编码时退出')
                line = line.strip()
                if line.startswith('OK image '):
                    parts = line.split()
                    ms = float(parts[3]) if len(parts) > 3 else 0.0
                    return int(parts[2]), ms
                if line.startswith('ERR'):
                    raise RuntimeError(line)

    def set_mtp(self, k):
        """打开/关闭 MTP 草稿数（权重已加载时无需重启进程）。"""
        with self.lock:
            self.cmd(f'MTP {int(k)}')
            st = self.p.stdout.readline().strip()
            if st.startswith('OK'):
                self.mtp_n = int(k)
            return st

    def gen(self, n, temp=0.0, top_p=1.0, top_k=0, seed=1234, stops=EOS):
        with self.lock:
            self.cmd(f'GEN {n} {temp} {top_p} {top_k} {seed} ' + ','.join(str(s) for s in stops))
            ids = []
            while True:
                line = self.p.stdout.readline()
                if not line:
                    raise RuntimeError('引擎提前退出')
                line = line.strip()
                if line.startswith('TOK '):
                    ids.append(int(line[4:]))
                elif line.startswith('END '):
                    return ids, line
                else:
                    print('[engine] ' + line, file=sys.stderr)

    def close(self):
        try:
            with self.lock:
                self.cmd('QUIT')
            self.p.wait(timeout=10)
        except Exception:                                          # noqa: BLE001
            self.p.kill()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prompt')
    ap.add_argument('--ids')
    ap.add_argument('--system')
    ap.add_argument('--n', type=int, default=64)
    ap.add_argument('--temp', type=float, default=0.0)
    ap.add_argument('--top-p', type=float, default=1.0)
    ap.add_argument('--top-k', type=int, default=0)
    ap.add_argument('--seed', type=int, default=1234)
    ap.add_argument('--raw', action='store_true', help='prompt 不当 chat 处理，直接编码')
    ap.add_argument('--dump-layers')
    ap.add_argument('--mtp-n', type=int, default=None, help='MTP 草稿数（默认 3；0 关闭投机）')
    ap.add_argument('--no-mtp', action='store_true', help='不加载 MTP 权重')
    args = ap.parse_args()

    if args.ids:
        ids = [int(x) for x in args.ids.split(',')]
        text_in = None
    elif args.raw:
        text_in = args.prompt or ''
        ids = T.encode(text_in)
    else:
        msgs = []
        if args.system:
            msgs.append({'role': 'system', 'content': args.system})
        msgs.append({'role': 'user', 'content': args.prompt or '你好'})
        text_in = T.apply_chat(msgs)
        ids = T.encode(text_in)
    if args.dump_layers:
        os.environ['RT_DUMP_BUF'] = '1'
    eng = Engine(log=True, mtp_n=args.mtp_n, no_mtp=args.no_mtp)
    try:
        t0 = time.time()
        st = eng.prefill(ids)
        t1 = time.time()
        print(f'[prefill] {st}')
        out, end = eng.gen(args.n, args.temp, args.top_p, args.top_k, args.seed)
        t2 = time.time()
        print(f'[gen] {end}  (墙钟 {t2 - t1:.2f}s)')
        if text_in:
            print('--- 输入 ---')
            print(text_in, end='')
        print('--- 生成 ---')
        print(T.decode(out))
        print('--- ids ---')
        print(out)
    finally:
        eng.close()


if __name__ == '__main__':
    main()
