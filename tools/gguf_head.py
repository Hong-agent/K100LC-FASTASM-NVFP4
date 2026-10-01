#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""读 GGUF 的头部：元数据 KV + 张量清单（名字/类型/形状/文件偏移）。

    python3 tools/gguf_head.py <model.gguf> [--tensors] [--meta] [--grep PAT]

只需要文件的开头部分就能工作（KV 段 + tensor info 段）；对大文件可以先下
头几百 MB 再解析，用来规划转换/加载，不必等整份下完。
"""
from __future__ import annotations

import argparse
import struct
import sys

# GGUF value types
T_U8, T_I8, T_U16, T_I16, T_U32, T_I32, T_F32, T_BOOL, T_STRING, T_ARRAY, \
    T_U64, T_I64, T_F64 = range(13)

SCALAR = {T_U8: ('<B', 1), T_I8: ('<b', 1), T_U16: ('<H', 2), T_I16: ('<h', 2),
          T_U32: ('<I', 4), T_I32: ('<i', 4), T_F32: ('<f', 4), T_BOOL: ('<?', 1),
          T_U64: ('<Q', 8), T_I64: ('<q', 8), T_F64: ('<d', 8)}

# 张量类型（GGML_TYPE_*）
GGML_TYPES = {
    0: 'F32', 1: 'F16', 2: 'Q4_0', 3: 'Q4_1', 6: 'Q5_0', 7: 'Q5_1', 8: 'Q8_0',
    9: 'Q8_1', 10: 'Q2_K', 11: 'Q3_K', 12: 'Q4_K', 13: 'Q5_K', 14: 'Q6_K',
    15: 'Q8_K', 16: 'IQ2_XXS', 17: 'IQ2_XS', 18: 'IQ3_XXS', 19: 'IQ1_S',
    20: 'IQ4_NL', 21: 'IQ3_S', 22: 'IQ2_S', 23: 'IQ4_XS', 24: 'I8', 25: 'I16',
    26: 'I32', 27: 'I64', 28: 'F64', 29: 'IQ1_M', 30: 'BF16',
    34: 'TQ1_0', 35: 'TQ2_0', 36: 'MXFP4',
}


class Reader:
    def __init__(self, path, limit=None):
        self.f = open(path, 'rb')
        self.limit = limit
        self.pos = 0

    def read(self, n):
        if self.limit is not None and self.pos + n > self.limit:
            raise EOFError(f'need {n} bytes at {self.pos}, file has {self.limit}')
        b = self.f.read(n)
        if len(b) != n:
            raise EOFError(f'short read at {self.pos}')
        self.pos += n
        return b

    def u32(self):
        return struct.unpack('<I', self.read(4))[0]

    def u64(self):
        return struct.unpack('<Q', self.read(8))[0]

    def string(self):
        n = self.u64()
        return self.read(n).decode('utf-8', 'replace')

    def value(self, t):
        if t in SCALAR:
            fmt, sz = SCALAR[t]
            return struct.unpack(fmt, self.read(sz))[0]
        if t == T_STRING:
            return self.string()
        if t == T_ARRAY:
            et = self.u32()
            n = self.u64()
            if et == T_STRING:
                # tokenizer 词表可能有十几万个字符串：只保留前几个当样本
                head = [self.string() for _ in range(min(n, 4))]
                for _ in range(n - min(n, 4)):
                    self.read(self.u64())
                return {'__array__': 'string', 'count': n, 'head': head}
            if et in SCALAR:
                fmt, sz = SCALAR[et]
                nbytes = sz * n
                if nbytes > 1 << 20:          # 大数组只跳过去
                    self.read(nbytes)
                    return {'__array__': GGML_TYPES.get(et, et), 'count': n}
                vals = list(struct.unpack('<' + fmt[1] * n, self.read(nbytes)))
                return vals
            raise ValueError(f'unsupported array elem type {et}')
        raise ValueError(f'unsupported value type {t}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('gguf')
    ap.add_argument('--tensors', action='store_true', help='打印张量清单')
    ap.add_argument('--meta', action='store_true', help='打印元数据')
    ap.add_argument('--grep', default='', help='只打印名字含该串的张量')
    ap.add_argument('--limit', type=int, default=None, help='只读前 N 字节')
    ap.add_argument('--tsv', default='', help='把张量清单写成 TSV（name type dims off）')
    args = ap.parse_args()

    r = Reader(args.gguf, args.limit)
    magic = r.read(4)
    if magic != b'GGUF':
        sys.exit(f'不是 GGUF：magic={magic!r}')
    ver = r.u32()
    ntensor = r.u64()
    nkv = r.u64()
    print(f'GGUF v{ver}  张量 {ntensor}  元数据 {nkv}')

    meta = {}
    show_meta = args.meta or not args.tensors
    for _ in range(nkv):
        k = r.string()
        t = r.u32()
        v = r.value(t)
        meta[k] = v
        if show_meta and not (isinstance(v, dict) and v.get('__array__')):
            # 大数组（词表/类型表）只报个数，别刷屏
            if isinstance(v, list) and len(v) > 8:
                print(f'  {k} = [{len(v)} 项] {v[:4]} …')
            elif isinstance(v, str) and len(v) > 200:
                print(f'  {k} = <{len(v)} 字节文本>')
            else:
                print(f'  {k} = {v}')

    align = int(meta.get('general.alignment', 32))
    infos = []
    for _ in range(ntensor):
        name = r.string()
        nd = r.u32()
        dims = [r.u64() for _ in range(nd)]
        tt = r.u32()
        off = r.u64()
        infos.append((name, GGML_TYPES.get(tt, tt), dims, off))
    data_start = (r.pos + align - 1) // align * align
    print(f'张量信息结束 @{r.pos}，数据起点 @{data_start}（对齐 {align}）')

    if args.tensors:
        import collections
        cnt = collections.Counter(t for _, t, _, _ in infos)
        print('类型分布:', dict(cnt))
        for name, t, dims, off in infos:
            if args.grep and args.grep not in name:
                continue
            print(f'  {name:60s} {t:8s} {dims}  off={off}')

    if args.tsv:
        # 每种类型的 block 尺寸（元素数 / 字节数），用于算张量体积
        BLK = {'F32': (1, 4), 'F16': (1, 2), 'BF16': (1, 2), 'Q8_0': (32, 34),
               'Q4_0': (32, 18), 'Q4_1': (32, 20), 'Q5_0': (32, 22), 'Q5_1': (32, 24),
               'Q2_K': (256, 84), 'Q3_K': (256, 110), 'Q4_K': (256, 144),
               'Q5_K': (256, 176), 'Q6_K': (256, 210), 'Q8_K': (256, 292),
               'IQ4_NL': (32, 18), 'IQ4_XS': (256, 136), 'MXFP4': (32, 17),
               'IQ2_S': (256, 82), 'IQ3_S': (256, 110), 'IQ3_XXS': (256, 98),
               'IQ2_XXS': (256, 66), 'IQ1_S': (256, 50), 'IQ1_M': (256, 56)}
        with open(args.tsv, 'w') as f:
            f.write('name\ttype\tdims\toffset\tbytes\n')
            for name, t, dims, off in infos:
                n = 1
                for d in dims:
                    n *= int(d)
                be, bb = BLK.get(t, (1, 4))
                nbytes = (n + be - 1) // be * bb
                f.write(f'{name}\t{t}\t{",".join(str(d) for d in dims)}\t'
                        f'{off}\t{nbytes}\n')
        print(f'清单已写 {args.tsv}（{len(infos)} 行）')


if __name__ == '__main__':
    main()
