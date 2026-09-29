#!/usr/bin/env python3
"""把「运行时要加载的权重」按**前向顺序**拼成一个连续文件。

原来运行时要从两个文件里按 851+336 个散落的偏移去 pread（RT4 权重一个文件、
原始 NVFP4 safetensors 另一个）。拼成一个之后：

  * 文件顺序 == 加载顺序 == 设备布局，加载退化成「顺序读 + 顺序拷」；
  * 显式跳过那些被 NVFP4 取代的 MLP 张量，文件本身就比两个源加起来小；
  * 运行时不用再算紧凑布局，直接照索引贴偏移即可。

    python3 tools/nvfp4_pack.py \\
        --rt4 <qwen38_27b.rt4> --rt4-json <qwen38_27b.rt4.json> \\
        --nvfp4 <model.safetensors> --nvfp4-tsv <nvfp4_manifest.tsv> \\
        --out build/packed.bin --index build/packed.tsv

索引（TSV）每行：type <TAB> name <TAB> packed_off <TAB> bytes <TAB> group
  type = rt4（RT4 张量，name 是 RT4 里的完整张量名）
       | nvp（NVFP4 的 weight_packed，name 是去掉 .weight_packed 的名字）
       | nvs（NVFP4 的 weight_scale）
"""
import argparse
import json
import os
import sys
import time

ALIGN = 256
CHUNK = 32 << 20


def tensor_group(n):
    """必须与运行时的 tensor_group() 完全一致。"""
    p = n.find('.layers.')
    if p >= 0:
        return 1 + int(n[p + len('.layers.'):].split('.')[0])
    if 'embed_tokens' in n:
        return 0
    if 'language_model.norm' in n:
        return 0
    return 66


def read_nvfp4_tsv(path):
    rows = []
    with open(path) as f:
        for line in f:
            if line.startswith('#') or not line.strip():
                continue
            p = line.split()
            rows.append(dict(stem=p[0], poff=int(p[1]), pbytes=int(p[2]),
                             soff=int(p[3]), sbytes=int(p[4]), gscale=float(p[5]),
                             N=int(p[6]), K=int(p[7])))
    return rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rt4', required=True)
    ap.add_argument('--rt4-json', required=True)
    ap.add_argument('--nvfp4', required=True)
    ap.add_argument('--nvfp4-tsv', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--index', required=True)
    args = ap.parse_args()

    rt = json.load(open(args.rt4_json))['tensors']
    nv = read_nvfp4_tsv(args.nvfp4_tsv)
    nv_stems = {r['stem'] for r in nv}

    def replaced(name):
        return name.endswith('.weight') and name[:-len('.weight')] in nv_stems

    items = []          # (group, type, name, src, src_off, bytes)
    skipped = 0
    for t in rt:
        if replaced(t['name']):
            skipped += t['nbytes']
            continue
        items.append((tensor_group(t['name']), 'rt4', t['name'], 'rt4', t['q_off'], t['nbytes']))
    for r in nv:
        g = tensor_group(r['stem'])
        items.append((g, 'nvp', r['stem'], 'nv', r['poff'], r['pbytes']))
        items.append((g, 'nvs', r['stem'], 'nv', r['soff'], r['sbytes']))
    items.sort(key=lambda x: x[0])          # 稳定排序：组内保持源顺序

    plan, off = [], 0
    for g, typ, name, src, soff, nb in items:
        off = (off + ALIGN - 1) // ALIGN * ALIGN
        plan.append((g, typ, name, src, soff, nb, off))
        off += nb
    total = off

    print('打包：%d 项（RT4 %d + NVFP4 %d），跳过 %.3f GB，产出 %.3f GB'
          % (len(plan), sum(1 for p in plan if p[1] == 'rt4'),
             sum(1 for p in plan if p[1] != 'rt4'), skipped / 1e9, total / 1e9))

    f_rt = open(args.rt4, 'rb')
    f_nv = open(args.nvfp4, 'rb')
    t0 = time.time()
    cur = 0
    with open(args.out, 'wb') as out, open(args.index, 'w') as idx:
        idx.write('# type\tname\tpacked_off\tbytes\tgroup\n')
        for n, (g, typ, name, src, soff, nb, poff) in enumerate(plan):
            if poff > cur:
                out.write(b'\0' * (poff - cur))
                cur = poff
            fh = f_rt if src == 'rt4' else f_nv
            fh.seek(soff)
            left = nb
            while left:
                b = fh.read(min(CHUNK, left))
                if not b:
                    sys.exit('源文件提前结束：%s off=%d' % (name, soff + nb - left))
                out.write(b)
                left -= len(b)
            cur += nb
            idx.write('%s\t%s\t%d\t%d\t%d\n' % (typ, name, poff, nb, g))
            if (n + 1) % 100 == 0:
                done = cur / 1e9
                el = time.time() - t0
                print('  %d/%d  %.2f GB  %.1f s  %.2f GB/s'
                      % (n + 1, len(plan), done, el, done / max(el, 1e-9)), flush=True)
    dt = time.time() - t0
    print('写完 %s（%.3f GB，%.1f s，%.2f GB/s）' % (args.out, total / 1e9, dt, total / dt / 1e9))
    print('索引 %s' % args.index)
    return 0


if __name__ == '__main__':
    sys.exit(main())
