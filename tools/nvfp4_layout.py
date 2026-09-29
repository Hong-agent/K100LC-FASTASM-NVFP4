#!/usr/bin/env python3
"""从 compressed-tensors 的 safetensors 里抽出所有 NVFP4 张量的文件内偏移，
写成一张 TSV 清单，供 C++ 运行时 mmap 后直接使用（不做任何数据搬运或转换）。

    python3 tools/nvfp4_layout.py model.safetensors nvfp4_manifest.tsv

清单每行：
    name <TAB> packed_off <TAB> packed_bytes <TAB> scale_off <TAB> scale_bytes
         <TAB> gscale <TAB> N <TAB> K

偏移是相对文件开头的绝对字节偏移。
"""
import json, struct, sys, collections


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    path, out_path = sys.argv[1], sys.argv[2]
    aux_path = out_path.replace('.tsv', '') + '_aux.tsv'
    if '--aux' in sys.argv:
        aux_path = sys.argv[sys.argv.index('--aux') + 1]
    with open(path, 'rb') as f:
        n = struct.unpack('<Q', f.read(8))[0]
        hdr = json.loads(f.read(n))
        base = 8 + n

        def read_f32(abs_off):
            pos = f.tell()
            f.seek(abs_off)
            v = struct.unpack('<f', f.read(4))[0]
            f.seek(pos)
            return v

        entries, skipped = [], collections.Counter()
        for name, info in hdr.items():
            if name == '__metadata__' or not name.endswith('.weight_packed'):
                continue
            stem = name[:-len('.weight_packed')]
            sc = hdr.get(stem + '.weight_scale')
            gs = hdr.get(stem + '.weight_global_scale')
            if sc is None or gs is None:
                skipped['缺 scale/global_scale'] += 1
                continue
            if info['dtype'] != 'U8' or sc['dtype'] != 'F8_E4M3':
                skipped['dtype %s/%s' % (info['dtype'], sc['dtype'])] += 1
                continue
            N, K2 = info['shape']
            entries.append((stem,
                            base + info['data_offsets'][0], info['data_offsets'][1] - info['data_offsets'][0],
                            base + sc['data_offsets'][0], sc['data_offsets'][1] - sc['data_offsets'][0],
                            read_f32(base + gs['data_offsets'][0]), N, K2 * 2))

    entries.sort()
    with open(out_path, 'w') as f:
        f.write("# name\tpacked_off\tpacked_bytes\tscale_off\tscale_bytes\tgscale\tN\tK\n")
        for e in entries:
            f.write("%s\t%d\t%d\t%d\t%d\t%.9g\t%d\t%d\n" % e)
    tp = sum(e[2] for e in entries)
    ts = sum(e[4] for e in entries)
    mac = sum(e[6] * e[7] for e in entries)
    print("NVFP4 张量 %d 个" % len(entries))
    print("  打包权重  %.3f GB" % (tp / 1e9))
    print("  块尺度    %.3f GB" % (ts / 1e9))
    print("  合计      %.3f GB" % ((tp + ts) / 1e9))
    print("  MAC 总计  %.3f G/次" % (mac / 1e9))
    if skipped:
        print("  跳过:", dict(skipped))
    print("清单写入", out_path)

    # ---- 附带一份「跑端到端要用到的非 NVFP4 张量」清单 ----
    want = []
    if 'model.language_model.embed_tokens.weight' in hdr:
        want.append('model.language_model.embed_tokens.weight')
    for name in hdr:
        if name.endswith('.post_attention_layernorm.weight'):
            want.append(name)
    want.sort(key=lambda s: (not s.endswith('embed_tokens.weight'), s))
    if want:
        with open(aux_path, 'w') as f:
            f.write("# name\toffset\tbytes\tdtype\tshape\n")
            for name in want:
                v = hdr[name]
                o0, o1 = v['data_offsets']
                f.write("%s\t%d\t%d\t%s\t%s\n" % (name, base + o0, o1 - o0, v['dtype'],
                                                  ','.join(map(str, v['shape']))))
        print("辅助清单写入 %s（%d 个张量：embedding + 每层 post_attention_layernorm）"
              % (aux_path, len(want)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
