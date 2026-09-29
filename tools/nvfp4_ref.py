#!/usr/bin/env python3
"""NVFP4 参考实现（纯 NumPy，无 torch 依赖）。

格式（compressed-tensors `nvfp4-pack-quantized`，即 unsloth/Qwen3.8-27B-NVFP4 里的 MLP）：

    weight_packed  U8  [N, K/2]   两个 E2M1 码一个字节，偶数 k 在低半字节
    weight_scale   E4M3[N, K/16]  每 16 个 k 一个块尺度
    weight_global_scale F32 [1]   逐张量

    反量化:  w[n,k] = e2m1(code) * e4m3(weight_scale[n, k//16]) / weight_global_scale

本文件同时是内核的对照真值：`python3 tools/nvfp4_ref.py --selftest` 校验 LUT
与「x2 精确整数化」这个核心性质。
"""
import numpy as np
import struct, json, sys


def build_e2m1_lut():
    """E2M1 码 c -> 浮点值。s=bit3, e=(c>>1)&3, m=c&1"""
    lut = np.zeros(16, dtype=np.float32)
    for c in range(16):
        s = (c >> 3) & 1
        e = (c >> 1) & 3
        m = c & 1
        if e == 0:
            v = 0.5 if m else 0.0
        else:
            v = (1.0 + 0.5 * m) * float(1 << (e - 1))
        lut[c] = -v if s else v
    return lut


E2M1 = build_e2m1_lut()
# 核心性质：2 * E2M1 恰好是整数，落在 [-12, 12]。
E2M1_X2 = np.rint(E2M1 * 2).astype(np.int32)


def build_e4m3_lut():
    """E4M3 码 i -> 浮点值（NaN 用 0 代替）。"""
    lut = np.zeros(256, dtype=np.float32)
    for i in range(256):
        s = (i >> 7) & 1
        e = (i >> 3) & 0xF
        m = i & 7
        if e == 0:
            v = np.ldexp(np.float32(m) / 8.0, -6)
        elif e == 15 and m == 7:
            v = np.float32('nan')
        else:
            v = np.ldexp(1.0 + m / 8.0, e - 7)
        lut[i] = -v if s else v
    return lut


E4M3 = build_e4m3_lut()


def unpack_codes(packed):
    """[N, K/2] U8 -> [N, K] 码（偶数 k 取低半字节）。"""
    lo = (packed & 0x0F).astype(np.uint8)
    hi = ((packed >> 4) & 0x0F).astype(np.uint8)
    out = np.empty((packed.shape[0], packed.shape[1] * 2), dtype=np.uint8)
    out[:, 0::2] = lo
    out[:, 1::2] = hi
    return out


def dequant_nvfp4(packed, scale_u8, global_scale):
    """反量化成 f32。packed [N,K/2] u8, scale_u8 [N,K/16] u8(E4M3), gs 标量。"""
    codes = unpack_codes(packed)
    vals = E2M1[codes]
    blk = E4M3[scale_u8].repeat(16, axis=1)
    return vals * blk / np.float32(global_scale)


def st_read_header(path):
    with open(path, 'rb') as f:
        n = struct.unpack('<Q', f.read(8))[0]
        return json.loads(f.read(n)), 8 + n


def st_read_tensor(path, info, hdr_off):
    dt = {'F32': '<f4', 'F16': '<f2', 'BF16': 'u2', 'U8': 'u1', 'F8_E4M3': 'u1'}[info['dtype']]
    o0, o1 = info['data_offsets']
    with open(path, 'rb') as f:
        f.seek(hdr_off + o0)
        raw = f.read(o1 - o0)
    a = np.frombuffer(raw, dtype=dt).reshape(info['shape'])
    if info['dtype'] == 'BF16':
        a = (a.astype(np.uint32) << 16).view(np.float32)
    return a


def selftest():
    ok = True
    want = [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0]
    got = [float(E2M1[c]) for c in range(8)]
    if got != want:
        print('E2M1 正半轴不符:', got)
        ok = False
    if list(E2M1[8:]) != [-v for v in want]:
        print('E2M1 负半轴不符:', list(E2M1[8:]))
        ok = False
    print('E2M1 LUT   :', [float(v) for v in E2M1])
    print('E2M1 x2    :', list(map(int, E2M1_X2)), ' <- 全部整数，落在 [-12,12]')
    checks = {0x00: 0.0, 0x38: 1.0, 0x3C: 1.5, 0xB8: -1.0, 0x01: 2.0 ** -9}
    for k, v in checks.items():
        if abs(float(E4M3[k]) - v) > 1e-9:
            print('E4M3[%#04x] = %s 期望 %s' % (k, float(E4M3[k]), v))
            ok = False
    print('E4M3 LUT   : 抽查通过')
    rng = np.random.default_rng(0)
    packed = rng.integers(0, 256, size=(4, 8), dtype=np.uint8)
    codes = unpack_codes(packed)
    for n in range(4):
        for k in range(16):
            c, b = codes[n, k], packed[n, k // 2]
            if (k % 2 == 0 and c != (b & 0xF)) or (k % 2 == 1 and c != (b >> 4)):
                print('解包顺序错误 n=%d k=%d' % (n, k))
                ok = False
    print('解包顺序   : 偶数 k = 低半字节 OK')
    print('SELFTEST', 'PASS' if ok else 'FAIL')
    return ok


if __name__ == '__main__':
    args = sys.argv[1:]
    if not args or '--selftest' in args:
        sys.exit(0 if selftest() else 1)
    if '--inspect' in args:
        i = args.index('--inspect')
        path, name = args[i + 1], args[i + 2]
        hdr, off = st_read_header(path)
        wp = st_read_tensor(path, hdr[name + '.weight_packed'], off)
        ws = st_read_tensor(path, hdr[name + '.weight_scale'], off)
        gs = float(st_read_tensor(path, hdr[name + '.weight_global_scale'], off)[0])
        ig = float(st_read_tensor(path, hdr[name + '.input_global_scale'], off)[0])
        print('%s: packed%s scale%s gscale=%.6g igscale=%.6g' % (name, wp.shape, ws.shape, gs, ig))
        w = dequant_nvfp4(wp[:8], ws[:8], gs)
        print('反量化前 8 行: mean=%.5f std=%.5f amax=%.5f' % (w.mean(), w.std(), np.abs(w).max()))
        c = unpack_codes(wp[:4])
        blkmax = np.abs(E2M1[c]).reshape(4, -1, 16).max(axis=2)
        bs = E4M3[ws[:4]]
        print('块内 amax/(6*scale) 均值 = %.4f   (应约 = 1/gscale = %.6g)'
              % ((blkmax / (6 * bs)).mean(), 1 / gs))
