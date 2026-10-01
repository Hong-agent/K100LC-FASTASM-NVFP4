#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成并编译 GGUF→RT4 的 C 重量化器（复用 llama.cpp ggml 的解码函数）。

    python3 tools/gen_gguf_requant.py            # 生成 + 编译 build/gguf_requant

产物：
  build/ggml_dequant_impl.h   ggml-common.h（结构体+网格表）+ 抽取的 dequantize_row_*
  build/gguf_requant.c        主程序：按 plan.tsv 把 GGUF 张量解码并重量化进 .rt4
  build/gguf_requant          可执行文件

plan.tsv（由 tools/gguf_to_rt4.py 生成，制表符分隔）：
    gguf_name  kind  rows  cols  gguf_off  q_off  s_off  bb_per_row  blk_elems  type_id
"""
from __future__ import annotations

import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
BUILD = ROOT / "build"
GGML_C = pathlib.Path("/tmp/ggml-quants.c")
GGML_H = pathlib.Path("/tmp/ggml-common.h")

FUNCS = ["q2_K", "q4_K", "q6_K", "iq2_xxs", "iq2_xs", "iq2_s", "iq3_xxs", "iq3_s",
         "iq4_xs", "iq4_nl", "iq1_m", "q8_0", "q4_0"]

HELPERS = ["get_scale_min_k4"]


def extract_funcs(src: str) -> str:
    out = []
    for name in HELPERS:
        m = re.search(rf"^static inline void {re.escape(name)}\(", src, re.M)
        if not m:
            print(f"  ! 未找到 helper {name}", file=sys.stderr)
            continue
        i = src.index("{", m.end()); depth = 0; j = i
        while True:
            if src[j] == "{": depth += 1
            elif src[j] == "}":
                depth -= 1
                if depth == 0: break
            j += 1
        out.append(src[m.start():j + 1])
    for name in FUNCS:
        m = re.search(rf"^void dequantize_row_{re.escape(name)}\(", src, re.M)
        if not m:
            print(f"  ! 未找到 dequantize_row_{name}", file=sys.stderr)
            continue
        i = src.index("{", m.end())
        depth = 0
        j = i
        while True:
            if src[j] == "{":
                depth += 1
            elif src[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        out.append(src[m.start():j + 1])
    return "\n\n".join(out)


HEADER = """// 自动生成（gen_gguf_requant.py）：ggml 结构体/表 + 解码函数
#define GGML_COMMON_DECL_C
#define GGML_COMMON_IMPL_C
#include "ggml-common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <assert.h>

typedef uint16_t ggml_half_t;
static inline float f16_to_f32(uint16_t h) {
    uint32_t s = (uint32_t)(h >> 15) << 31, e = (h >> 10) & 0x1F, m = h & 0x3FF, o;
    if (e == 0) { if (m == 0) o = s; else { e = 127 - 15 + 1; while (!(m & 0x400)) { m <<= 1; e--; } m &= 0x3FF; o = s | (e << 23) | (m << 13); } }
    else if (e == 31) o = s | 0x7F800000u | (m << 13);
    else o = s | ((e - 15 + 127) << 23) | (m << 13);
    float f; memcpy(&f, &o, 4); return f;
}
#define GGML_FP16_TO_FP32(x) f16_to_f32((uint16_t)(x))
#define GGML_RESTRICT
#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
#define QK_K 256
__attribute__((unused)) static int nearest_int(float f) { return (int)lrintf(f); }

%s
"""

MAIN = r"""
// gguf_requant: 按 plan.tsv 把 GGUF 张量解码 -> f32 -> int4(group 128)/f32/f16
typedef struct { char name[192]; char kind[8]; long long rows, cols, goff, qoff, soff;
                 int bbrow; int blk; int tid; } Ent;

// GGUF 类型号 → 每块字节数 / 每块元素数（官方 ggml_type 枚举）
static const int BLOK[64] = {
    [0]=4, [1]=2, [2]=18, [3]=20, [4]=18, [5]=20, [6]=34, [8]=84, [9]=110,
    [10]=144, [11]=176, [12]=210, [14]=66, [15]=74, [16]=98, [18]=18, [19]=110,
    [20]=82, [21]=136, [27]=56, [28]=2,
};
static const int ELEMS[64] = {
    [0]=1, [1]=1, [2]=32, [3]=32, [4]=32, [5]=32, [6]=32, [8]=256, [9]=256,
    [10]=256, [11]=256, [12]=256, [14]=256, [15]=256, [16]=256, [18]=32, [19]=256,
    [20]=256, [21]=256, [27]=256, [28]=1,
};
static inline uint16_t f32_to_f16(float f) {
    uint32_t x; memcpy(&x,&f,4);
    uint32_t sign=(x>>16)&0x8000, exp=(x>>23)&0xFF, mant=x&0x7FFFFF;
    int32_t ee=(int32_t)exp-127+15;
    if (exp==0xFF) return (uint16_t)(sign|0x7C00);
    if (ee>=31) return (uint16_t)(sign|0x7C00);
    if (ee<=0) return (uint16_t)sign;
    return (uint16_t)(sign|(ee<<10)|(mant>>13));
}
static int deq(int tid, const uint8_t* src, float* dst, int n_elems) {
    switch (tid) {
    case 0: memcpy(dst, src, (size_t)n_elems*4); return 0;              // F32
    case 1: for (int i=0;i<n_elems;i++) { uint16_t h; memcpy(&h, src+2*i, 2); dst[i]=f16_to_f32(h);} return 0;
    case 28: for (int i=0;i<n_elems;i++) { uint16_t h; memcpy(&h, src+2*i, 2); uint32_t u=(uint32_t)h<<16; memcpy(&dst[i], &u, 4);} return 0;
    case 2:  dequantize_row_q4_0((const block_q4_0*)src, dst, n_elems); return 0;
    case 6:  dequantize_row_q8_0((const block_q8_0*)src, dst, n_elems); return 0;
    case 8:  dequantize_row_q2_K((const block_q2_K*)src, dst, n_elems); return 0;
    case 10: dequantize_row_q4_K((const block_q4_K*)src, dst, n_elems); return 0;
    case 12: dequantize_row_q6_K((const block_q6_K*)src, dst, n_elems); return 0;
    case 14: dequantize_row_iq2_xxs((const block_iq2_xxs*)src, dst, n_elems); return 0;
    case 15: dequantize_row_iq2_xs((const block_iq2_xs*)src, dst, n_elems); return 0;
    case 16: dequantize_row_iq3_xxs((const block_iq3_xxs*)src, dst, n_elems); return 0;
    case 18: dequantize_row_iq4_nl((const block_iq4_nl*)src, dst, n_elems); return 0;
    case 19: dequantize_row_iq3_s((const block_iq3_s*)src, dst, n_elems); return 0;
    case 20: dequantize_row_iq2_s((const block_iq2_s*)src, dst, n_elems); return 0;
    case 21: dequantize_row_iq4_xs((const block_iq4_xs*)src, dst, n_elems); return 0;
    case 27: dequantize_row_iq1_m((const block_iq1_m*)src, dst, n_elems); return 0;
    default: fprintf(stderr, "requant: 不支持的 GGUF 类型 id=%d\n", tid); return -1;
    }
}
int main(int argc, char** argv) {
    if (argc != 4) { fprintf(stderr, "用法: %s plan.tsv in.gguf out.rt4\n", argv[0]); return 2; }
    FILE* fp = fopen(argv[1], "r");
    FILE* fg = fopen(argv[2], "rb");
    FILE* fo = fopen(argv[3], "wb");
    if (!fp || !fg || !fo) { perror("open"); return 1; }
    // 输出按 256B 对齐预置
    Ent e; char line[512];
    float* buf = NULL; size_t cap = 0; uint8_t* raw = NULL; size_t rawcap = 0;
    int pad[64]; memset(pad, 0, sizeof(pad));
    fseek(fo, 0, SEEK_END); long long out_end = ftell(fo);
    if (out_end == 0) { fseek(fo, 0, SEEK_SET); }
    double worst = 0; char worst_name[192] = "";
    while (fgets(line, sizeof(line), fp)) {
        if (line[0] == '#' || line[0] == '\n') continue;
        if (sscanf(line, "%191s %7s %lld %lld %lld %lld %lld %d %d %d",
                   e.name, e.kind, &e.rows, &e.cols, &e.goff, &e.qoff, &e.soff,
                   &e.bbrow, &e.blk, &e.tid) != 10) { fprintf(stderr, "plan 解析失败: %s", line); return 1; }
        long long nb_row = e.cols / e.blk;          // 每行的块数
        long long chunk_rows = 4096;
        if (chunk_rows > e.rows) chunk_rows = e.rows;
        if ((size_t)(chunk_rows*e.cols) > cap) { cap = chunk_rows*e.cols; buf = realloc(buf, cap*4); }
        if ((size_t)(chunk_rows*e.bbrow) > rawcap) { rawcap = chunk_rows*e.bbrow; raw = realloc(raw, rawcap); }
        for (long long r0 = 0; r0 < e.rows; r0 += chunk_rows) {
            long long nr = e.rows - r0 < chunk_rows ? e.rows - r0 : chunk_rows;
            long long bytes = nr * e.bbrow;
            fseeko(fg, e.goff + r0 * e.bbrow, SEEK_SET);
            if (fread(raw, 1, bytes, fg) != (size_t)bytes) { fprintf(stderr, "读 GGUF 失败 %s\n", e.name); return 1; }
            if (deq(e.tid, raw, buf, (int)(nr*e.cols)) != 0) return 1;
            if (e.kind[0] == 'i') {
                // 每 128 个一组：s = amax/7, q = clamp(rint(w/s), -8, 7)，低半字节 = 偶数 k
                long long ng = e.cols / 128;
                uint8_t* qb = (uint8_t*)malloc((size_t)nr * e.cols / 2);
                uint16_t* sb = (uint16_t*)malloc((size_t)nr * ng * 2);
                double sum2e = 0, sum2r = 0;
                for (long long r = 0; r < nr; r++) {
                    const float* row = buf + r * e.cols;
                    for (long long g = 0; g < ng; g++) {
                        const float* b = row + g * 128;
                        float amax = 0;
                        for (int i = 0; i < 128; i++) { float a = fabsf(b[i]); if (a > amax) amax = a; }
                        float s = amax > 0.f ? amax / 7.f : 1.f;
                        sb[r * ng + g] = f32_to_f16(s);
                        for (int i = 0; i < 128; i += 2) {
                            int c0 = (int)lrintf(b[i] / s), c1 = (int)lrintf(b[i + 1] / s);
                            c0 = c0 > 7 ? 7 : (c0 < -8 ? -8 : c0);
                            c1 = c1 > 7 ? 7 : (c1 < -8 ? -8 : c1);
                            qb[(r * e.cols + g * 128 + i) / 2] =
                                (uint8_t)((c0 & 0xF) | ((c1 & 0xF) << 4));
                            float e0 = b[i] - (float)c0 * s, e1 = b[i + 1] - (float)c1 * s;
                            sum2e += (double)e0 * e0 + (double)e1 * e1;
                            sum2r += (double)b[i] * b[i] + (double)b[i + 1] * b[i + 1];
                        }
                    }
                }
                double rel = sqrt(sum2e / (sum2r > 1e-30 ? sum2r : 1e-30));
                if (rel > worst) { worst = rel; snprintf(worst_name, sizeof(worst_name), "%s", e.name); }
                fseeko(fo, e.qoff + r0 * e.cols / 2, SEEK_SET);
                fwrite(qb, 1, (size_t)nr * e.cols / 2, fo);
                fseeko(fo, e.soff + r0 * ng * 2, SEEK_SET);
                fwrite(sb, 1, (size_t)nr * ng * 2, fo);
                free(qb); free(sb);
            } else if (e.kind[0] == 'f') {
                fseeko(fo, e.qoff + r0 * e.cols * (e.kind[1] == '3' ? 4 : 2), SEEK_SET);
                if (e.kind[1] == '3') fwrite(buf, 4, (size_t)nr * e.cols, fo);
                else {
                    uint16_t* h = (uint16_t*)malloc((size_t)nr * e.cols * 2);
                    for (long long i = 0; i < nr * e.cols; i++) h[i] = f32_to_f16(buf[i]);
                    fwrite(h, 2, (size_t)nr * e.cols, fo);
                    free(h);
                }
            }
        }
        fprintf(stderr, "  %-60s %s ok\n", e.name, e.kind);
    }
    fprintf(stderr, "完成。最大重量化 RMS 相对误差：%.4f（%s）\n", worst, worst_name);
    return 0;
}
"""


def main() -> int:
    src = GGML_C.read_text()
    BUILD.mkdir(parents=True, exist_ok=True)
    hdr = HEADER % extract_funcs(src)
    (BUILD / "ggml_dequant_impl.h").write_text(hdr, encoding="utf-8")
    (BUILD / "gguf_requant.c").write_text('#include "ggml_dequant_impl.h"\n' + MAIN,
                                          encoding="utf-8")
    subprocess.run(["gcc", "-O2", "-std=gnu11", "-I", str(BUILD), "-I", "/tmp",
                    str(BUILD / "gguf_requant.c"), "-o", str(BUILD / "gguf_requant"),
                    "-lm"],
                   check=True)
    print(f"-> {BUILD/'gguf_requant'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
