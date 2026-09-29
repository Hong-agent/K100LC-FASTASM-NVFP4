// NVFP4 解码 GEMV 内核（单一来源：合成基准与真实模型运行时共用）。
//
// 布局约定（都是 compressed-tensors `nvfp4-pack-quantized` 的**原生布局**，不转换）：
//   权重  wp [N][K/8] u32      = weight_packed [N][K/2] u8 的位重解释
//         ws [N][K/16] u8     = weight_scale（E4M3）
//         inv_gscale          = 1 / weight_global_scale
//   激活  ae/ao [M][K/2] i8    偶 k / 奇 k 拆开，每 16 个 k 一个 f32 尺度 asc[M][K/16]
//   输出  y[M][N] f32
//
// 为什么权重侧无损：见 include/nvfp4/nvfp4_decode.h 与 docs/DESIGN.md §2。
#pragma once
#include <hip/hip_runtime.h>
#include <cstdint>
#include "../include/nvfp4/nvfp4_decode.h"

#define NVFP4_GRP 16
#ifndef NVFP4_NTHREADS
#define NVFP4_NTHREADS 256
#endif
#define NVFP4_NWARP (NVFP4_NTHREADS / 64)

__device__ __forceinline__ int nvfp4_dot4_i8(unsigned a, unsigned b, int acc) {
    int r;
    asm volatile("v_dot4_i32_i8 %0, %1, %2, %3" : "=v"(r) : "v"(a), "v"(b), "v"(acc));
    return r;
}

// 激活量化：a[M][K] f32 -> ae/ao[M][K/2] i8 + asc[M][K/16] f32
// 块边界与权重的 16 块对齐，这样两边尺度可以逐块相乘。
__global__ void nvfp4_quant_act(const float* __restrict__ a, int8_t* __restrict__ ae,
                                int8_t* __restrict__ ao, float* __restrict__ asc,
                                int M, int K) {
    const int g = blockIdx.x, m = blockIdx.y, t = threadIdx.x;
    const int n = min(NVFP4_GRP, K - g * NVFP4_GRP);
    if (n <= 0) return;
    const float* src = a + (size_t)m * K + (size_t)g * NVFP4_GRP;
    float amax = 0.f;
    for (int i = t; i < n; i += blockDim.x) amax = fmaxf(amax, fabsf(src[i]));
    for (int off = 16; off; off >>= 1) amax = fmaxf(amax, __shfl_xor(amax, off));
    __shared__ float ss;
    if (t == 0) {
        const float s = amax > 0.f ? amax / 127.f : 1.f;
        ss = s;
        asc[m * (K / NVFP4_GRP) + g] = s;
    }
    __syncthreads();
    const float inv = 1.f / ss;
    int8_t* e = ae + (size_t)m * (K / 2);
    int8_t* o = ao + (size_t)m * (K / 2);
    for (int i = t; i < n; i += blockDim.x) {
        const int k = g * NVFP4_GRP + i;
        int q = (int)lrintf(src[i] * inv);
        q = q > 127 ? 127 : (q < -128 ? -128 : q);
        ((k & 1) ? o : e)[k >> 1] = (int8_t)q;
    }
}

// 一个 warp 处理 NROW 行；lane 每次吃一个 16 宽的分块（2 个 dword）。
template <int M, int NROW>
__global__ void nvfp4_gemv(const uint32_t* __restrict__ wp, const uint8_t* __restrict__ ws,
                           const int8_t* __restrict__ ae, const int8_t* __restrict__ ao,
                           const float* __restrict__ asc, float* __restrict__ out,
                           int N, int K, float inv_gscale) {
    __shared__ float s_lut[256];    // E4M3 字节 -> e4m3(v) * 0.5 / gscale
    for (int i = threadIdx.x; i < 256; i += blockDim.x)
        s_lut[i] = nvfp4_e4m3_to_f32(i) * (0.5f * inv_gscale);
    __syncthreads();

    const int lane = threadIdx.x & 63;
    const int warp = threadIdx.x >> 6;
    const int KD = K / 8, NG = K / NVFP4_GRP, K2 = K / 2;
    const int row0 = (blockIdx.x * NVFP4_NWARP + warp) * NROW;
    if (row0 >= N) return;
    const int nr = (row0 + NROW <= N) ? NROW : (N - row0);

    for (int r = 0; r < nr; r++) {
        const int n = row0 + r;
        const uint32_t* wprow = wp + (size_t)n * KD;
        const uint8_t* wsrow = ws + (size_t)n * NG;
        float facc[M];
#pragma unroll
        for (int m = 0; m < M; m++) facc[m] = 0.f;
        for (int g = lane; g < NG; g += 64) {
            const uint2 wv = ((const uint2*)wprow)[g];
            unsigned we0, wo0, we1, wo1;
            nvfp4_decode8(wv.x, we0, wo0);
            nvfp4_decode8(wv.y, we1, wo1);
            const float wsc = s_lut[wsrow[g]];
#pragma unroll
            for (int m = 0; m < M; m++) {
                const uint2 av = ((const uint2*)(ae + (size_t)m * K2))[g];
                const uint2 bv = ((const uint2*)(ao + (size_t)m * K2))[g];
                int d = 0;
                d = nvfp4_dot4_i8(we0, av.x, d);
                d = nvfp4_dot4_i8(wo0, bv.x, d);
                d = nvfp4_dot4_i8(we1, av.y, d);
                d = nvfp4_dot4_i8(wo1, bv.y, d);
                facc[m] += (float)d * (wsc * asc[m * NG + g]);
            }
        }
        float f[M];
#pragma unroll
        for (int m = 0; m < M; m++) f[m] = facc[m];
        for (int off = 32; off; off >>= 1)
#pragma unroll
            for (int m = 0; m < M; m++) f[m] += __shfl_xor(f[m], off);
        if (lane == 0)
#pragma unroll
            for (int m = 0; m < M; m++) out[(size_t)m * N + n] = f[m];
    }
}

// 主机侧发射（按行数自动选 NROW）
// 宽载版本：一个 lane 每次吃 **两个** 16 分块（4 个 dword = 128 位权重载入），
// 权重/激活/尺度各一次 128 位或成对载入，把访存指令数砍一半。
// 注意：要求 K/16 为偶数（K 是 32 的倍数）。
template <int M, int NROW>
__global__ void nvfp4_gemv_wide(const uint32_t* __restrict__ wp, const uint8_t* __restrict__ ws,
                                const int8_t* __restrict__ ae, const int8_t* __restrict__ ao,
                                const float* __restrict__ asc, float* __restrict__ out,
                                int N, int K, float inv_gscale) {
    __shared__ float s_lut[256];
    for (int i = threadIdx.x; i < 256; i += blockDim.x)
        s_lut[i] = nvfp4_e4m3_to_f32(i) * (0.5f * inv_gscale);
    __syncthreads();

    const int lane = threadIdx.x & 63;
    const int warp = threadIdx.x >> 6;
    const int NG = K / NVFP4_GRP, NP = NG / 2, K2 = K / 2;
    const int row0 = (blockIdx.x * NVFP4_NWARP + warp) * NROW;
    if (row0 >= N) return;
    const int nr = (row0 + NROW <= N) ? NROW : (N - row0);

    for (int r = 0; r < nr; r++) {
        const int n = row0 + r;
        const uint4* wprow = (const uint4*)(wp + (size_t)n * (K / 8));
        const uint16_t* wsrow = (const uint16_t*)(ws + (size_t)n * NG);
        float facc[M];
#pragma unroll
        for (int m = 0; m < M; m++) facc[m] = 0.f;
        for (int p = lane; p < NP; p += 64) {
            const uint4 wv = wprow[p];
            unsigned a0e, a0o, a1e, a1o, a2e, a2o, a3e, a3o;
            nvfp4_decode8(wv.x, a0e, a0o);
            nvfp4_decode8(wv.y, a1e, a1o);
            nvfp4_decode8(wv.z, a2e, a2o);
            nvfp4_decode8(wv.w, a3e, a3o);
            const uint16_t wsb = wsrow[p];
            const float w0 = s_lut[wsb & 0xFF], w1 = s_lut[wsb >> 8];
#pragma unroll
            for (int m = 0; m < M; m++) {
                const uint4 av = ((const uint4*)(ae + (size_t)m * K2))[p];
                const uint4 bv = ((const uint4*)(ao + (size_t)m * K2))[p];
                // 两个 16 分块各有自己的尺度，整数点积必须**分开**累加
                int d0 = 0, d1 = 0;
                d0 = nvfp4_dot4_i8(a0e, av.x, d0);
                d0 = nvfp4_dot4_i8(a0o, bv.x, d0);
                d0 = nvfp4_dot4_i8(a1e, av.y, d0);
                d0 = nvfp4_dot4_i8(a1o, bv.y, d0);
                d1 = nvfp4_dot4_i8(a2e, av.z, d1);
                d1 = nvfp4_dot4_i8(a2o, bv.z, d1);
                d1 = nvfp4_dot4_i8(a3e, av.w, d1);
                d1 = nvfp4_dot4_i8(a3o, bv.w, d1);
                const float2 sc = ((const float2*)(asc + m * NG))[p];
                facc[m] += (float)d0 * (w0 * sc.x) + (float)d1 * (w1 * sc.y);
            }
        }
        float f[M];
#pragma unroll
        for (int m = 0; m < M; m++) f[m] = facc[m];
        for (int off = 32; off; off >>= 1)
#pragma unroll
            for (int m = 0; m < M; m++) f[m] += __shfl_xor(f[m], off);
        if (lane == 0)
#pragma unroll
            for (int m = 0; m < M; m++) out[(size_t)m * N + n] = f[m];
    }
}

inline bool nvfp4_gemv_wide_ok(int K) { return (K / NVFP4_GRP) % 2 == 0; }

inline void nvfp4_gemv_wide_launch(int M, const uint32_t* wp, const uint8_t* ws, const int8_t* ae,
                                   const int8_t* ao, const float* asc, float* out,
                                   int N, int K, float inv_gscale, int nrow = 1, hipStream_t st = 0) {
    const int rpb = NVFP4_NWARP * nrow;
    const int blocks = (N + rpb - 1) / rpb;
    dim3 g(blocks);
#define CASE(NR)                                                                        \
    case NR:                                                                            \
        if (M == 1) nvfp4_gemv_wide<1, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 2) nvfp4_gemv_wide<2, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 3) nvfp4_gemv_wide<3, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 4) nvfp4_gemv_wide<4, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else { fprintf(stderr, "wide 只支持 M=1..4\n"); exit(1); }                        \
        break;
    switch (nrow) { CASE(1) CASE(2) default: fprintf(stderr, "wide nrow=%d 不支持\n", nrow); exit(1); }
#undef CASE
}

inline void nvfp4_gemv_launch(int M, const uint32_t* wp, const uint8_t* ws, const int8_t* ae,
                              const int8_t* ao, const float* asc, float* out,
                              int N, int K, float inv_gscale, int nrow = 2,
                              hipStream_t st = 0) {
    const int rpb = NVFP4_NWARP * nrow;
    const int blocks = (N + rpb - 1) / rpb;
    dim3 g(blocks);
#define CASE(NR)                                                                       \
    case NR:                                                                           \
        if (M == 1) nvfp4_gemv<1, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 2) nvfp4_gemv<2, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 3) nvfp4_gemv<3, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else if (M == 4) nvfp4_gemv<4, NR><<<g, NVFP4_NTHREADS, 0, st>>>(wp, ws, ae, ao, asc, out, N, K, inv_gscale); \
        else { fprintf(stderr, "M=%d 不支持\n", M); exit(1); }                          \
        break;
    switch (nrow) { CASE(1) CASE(2) CASE(3) CASE(4) default: fprintf(stderr, "nrow=%d 不支持\n", nrow); exit(1); }
#undef CASE
}
