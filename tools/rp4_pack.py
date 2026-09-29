#!/usr/bin/env python3
"""把「模型需要用到的全部权重」合成一个自包含的 .rp4 文件。

一个 .rp4 = 64 字节头 + 索引（TSV 文本）+ 载荷（按加载顺序拼好的权重字节）。
载荷顺序 == 设备偏移 == 加载顺序，所以运行时只要：

    读头 -> 读索引 -> 从头到尾顺序读载荷（O_DIRECT）-> 完

主模型里被 NVFP4 取代的张量在打包时整段丢掉（既省空间也省 I/O）：168 个 MLP 是
checkpoint 原生 NVFP4；注意力 / 线性注意力投影、lm_head、第 56~63 层 MLP 由
tools/nvfp4_quant.py 从 FP8 按同一规格重量化（--nvfp4-extra）。
MTP 头（`mtp.`）和视觉塔（`model.visual.`）也一起装进来，运行时不再需要
任何别的权重文件。

    python3 tools/rp4_pack.py \\
        --main  <qwen38_27b.rt4>        --main-json  <qwen38_27b.rt4.json> \\
        --mtp   <qwen38_27b_mtp.rt4>    --mtp-json   <qwen38_27b_mtp.rt4.json> \\
        --vision <qwen38_27b_vision.rt4> --vision-json <qwen38_27b_vision.rt4.json> \\
        --nvfp4 <model.safetensors> --nvfp4-tsv <nvfp4_manifest.tsv> \\
        --nvfp4-extra <nvfp4_extra_blob.bin> --nvfp4-extra-tsv <nvfp4_extra_manifest.tsv> \\
        --out <model.rp4>
"""
import argparse
import json
import struct
import sys
import time

MAGIC = b'K100RP4\0'
VERSION = 1
ALIGN = 4096          # 载荷起点与块对齐，方便 O_DIRECT
ITEM_ALIGN = 256      # 每个张量的起点对齐（向量载入够用）
CHUNK = 32 << 20


def tensor_group(n):
    """必须与运行时 src/model.cpp 的 tensor_group() 一致。"""
    p = n.find('.layers.')
    if p >= 0:
        return 1 + int(n[p + len('.layers.'):].split('.')[0])
    if 'embed_tokens' in n:
        return 0
    if 'language_model.norm' in n:
        return 0
    return 66


def read_nvfp4_tsv(path, src='nv'):
    rows = []
    with open(path) as f:
        for line in f:
            if line.startswith('#') or not line.strip():
                continue
            p = line.split()
            rows.append(dict(stem=p[0], poff=int(p[1]), pbytes=int(p[2]),
                             soff=int(p[3]), sbytes=int(p[4]), gscale=float(p[5]),
                             N=int(p[6]), K=int(p[7]), src=src))
    return rows


def main():
    ap = argparse.ArgumentParser()
    for k in ('main', 'mtp', 'vision'):
        ap.add_argument('--' + k, required=True)
        ap.add_argument('--%s-json' % k, required=True)
    ap.add_argument('--nvfp4', required=True)
    ap.add_argument('--nvfp4-tsv', required=True)
    # 额外一份「从 FP8 重量化出来的 NVFP4」（tools/nvfp4_quant.py 的产物）：
    # 注意力/线性注意力投影、lm_head、第 56~63 层 MLP。载荷单独一个 blob。
    ap.add_argument('--nvfp4-extra')
    ap.add_argument('--nvfp4-extra-tsv')
    ap.add_argument('--out', required=True)
    a = ap.parse_args()

    nv = read_nvfp4_tsv(a.nvfp4_tsv, 'nv')
    if a.nvfp4_extra:
        if not a.nvfp4_extra_tsv:
            sys.exit('--nvfp4-extra 需要同时给 --nvfp4-extra-tsv')
        have = {r['stem'] for r in nv}
        extra = read_nvfp4_tsv(a.nvfp4_extra_tsv, 'nve')
        for r in extra:
            if r['stem'] in have:
                sys.exit('extra 清单与主清单重复：%s' % r['stem'])
        nv += extra
    nv_stems = {r['stem'] for r in nv}

    # items: (group, type, part, name, kind, N, K, grp, src, src_off, bytes, gscale, sdelta)
    # sdelta = 尺度区相对张量起点的偏移（i4 才有，其它为 0）
    items, skipped = [], 0

    main_ts = json.load(open(a.main_json))['tensors']
    for t in main_ts:
        nm = t['name']
        if nm.endswith('.weight') and nm[:-len('.weight')] in nv_stems:
            skipped += t['nbytes']
            # 被 NVFP4 取代：载荷里整段丢掉，但保留一条**零字节的元数据行**，
            # 因为运行时仍然要按名字查到它的 N/K（真正的数据来自 NVFP4 那两行）。
            items.append((tensor_group(nm), 't', 'main', nm, t['kind'], t['shape'][0],
                          t['shape'][1] if len(t['shape']) > 1 else 1, t.get('group', 0),
                          'main', t['q_off'], 0, 0.0, 0))
            continue
        items.append((tensor_group(nm), 't', 'main', nm, t['kind'], t['shape'][0],
                      t['shape'][1] if len(t['shape']) > 1 else 1, t.get('group', 0),
                      'main', t['q_off'], t['nbytes'], 0.0,
                      (t['s_off'] - t['q_off']) if t['kind'] == 'i4' else 0))
    for r in nv:
        g = tensor_group(r['stem'])
        items.append((g, 'nvp', 'main', r['stem'], 'nvfp4', r['N'], r['K'], 16,
                      r['src'], r['poff'], r['pbytes'], r['gscale'], 0))
        items.append((g, 'nvs', 'main', r['stem'], 'nvfp4', r['N'], r['K'], 16,
                      r['src'], r['soff'], r['sbytes'], r['gscale'], 0))

    for part, jpath, src in (('mtp', a.mtp_json, 'mtp'), ('visual', a.vision_json, 'vision')):
        grp = 67 if part == 'mtp' else 68
        for t in json.load(open(jpath))['tensors']:
            items.append((grp, 't', part, t['name'], t['kind'], t['shape'][0],
                          t['shape'][1] if len(t['shape']) > 1 else 1, t.get('group', 0),
                          src, t['q_off'], t['nbytes'], 0.0,
                          (t['s_off'] - t['q_off']) if t['kind'] == 'i4' else 0))

    items.sort(key=lambda x: x[0])                  # 稳定排序：组内保持源顺序

    plan, off = [], 0
    for it in items:
        off = (off + ITEM_ALIGN - 1) // ITEM_ALIGN * ITEM_ALIGN
        plan.append(it + (off,))
        off += it[10]
    data_len = off

    # 索引文本（TSV，运行时按列解析）
    lines = ['# type\tpart\tname\tkind\tN\tK\tgroup\toff\tnbytes\tsoff\tgscale']
    for (g, typ, part, name, kind, N, K, grp, src, soff, nb, gs, sdelta, o) in plan:
        lines.append('%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%.9g'
                     % (typ, part, name, kind, N, K, grp, o, nb, o + sdelta, gs))
    index = ('\n'.join(lines) + '\n').encode()

    hdr_len = 64
    index_off = hdr_len
    data_off = (index_off + len(index) + ALIGN - 1) // ALIGN * ALIGN
    # 8 + 4 + 4 + 8*5 + 8 = 64 字节
    hdr = struct.pack('<8sIIQQQQQ8s', MAGIC, VERSION, 0,
                      index_off, len(index), data_off, data_len, len(plan), b'')
    assert len(hdr) == hdr_len

    print('rp4: %d 个张量（main %d / nvfp4 %d / mtp %d / visual %d），跳过 %.3f GB'
          % (len(plan),
             sum(1 for p in plan if p[2] == 'main' and p[1] == 't'),
             sum(1 for p in plan if p[1] != 't'),
             sum(1 for p in plan if p[2] == 'mtp'),
             sum(1 for p in plan if p[2] == 'visual'), skipped / 1e9))
    print('  载荷 %.3f GB，索引 %d 行，文件共 %.3f GB'
          % (data_len / 1e9, len(lines) - 1, (data_off + data_len) / 1e9))

    srcs = {'main': open(a.main, 'rb'), 'mtp': open(a.mtp, 'rb'),
            'vision': open(a.vision, 'rb'), 'nv': open(a.nvfp4, 'rb')}
    if a.nvfp4_extra:
        srcs['nve'] = open(a.nvfp4_extra, 'rb')
    t0 = time.time()
    with open(a.out, 'wb') as out:
        out.write(hdr)
        out.write(index)
        out.write(b'\0' * (data_off - out.tell()))
        cur = 0
        for n, it in enumerate(plan):
            o = it[13]
            if o > cur:
                out.write(b'\0' * (o - cur))
                cur = o
            fh = srcs[it[8]]
            fh.seek(it[9])
            left = it[10]
            while left:
                b = fh.read(min(CHUNK, left))
                if not b:
                    sys.exit('源文件提前结束：%s' % it[3])
                out.write(b)
                left -= len(b)
                cur += len(b)
            if (n + 1) % 200 == 0:
                el = time.time() - t0
                print('  %d/%d  %.2f GB  %.1f s  %.2f GB/s'
                      % (n + 1, len(plan), cur / 1e9, el, cur / el / 1e9), flush=True)
    dt = time.time() - t0
    print('写入 %s（%.3f GB，%.1f s，%.2f GB/s）' % (a.out, (data_off + data_len) / 1e9, dt,
                                                  (data_off + data_len) / dt / 1e9))
    return 0


if __name__ == '__main__':
    sys.exit(main())
