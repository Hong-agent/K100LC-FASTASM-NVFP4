// NVFP4 预填充 GEMM 内核（单一来源：独立基准与混合运行时共用）。
// C[M,N] = A[M,K] x W[N,K]，权重是原始 NVFP4 布局，激活是 int8（偶/奇拆开，每 16 一组尺度）。
//
// 与解码 GEMV 的差别：预填充是**算力受限**的，而 FP4->int8 的解码差不多是
// 「每元素 2.6 条指令」，会直接吃掉点积吞吐。所以这里把权重**协作解码进
// shared memory 一次**，再让 BM 行激活复用它，把解码成本摊掉。
//
// shared 布局刻意**转置**成 [dword][行]：按 [行][dword] 存时行距 32B，16 个线程的
// 地址间隔恰好是 128B 的整数倍，全部落在同一个 bank（实测 16 路冲突，只有
// 3.57 TMAC/s）；转置后 13.07 TMAC/s。
#pragma once
#include <hip/hip_runtime.h>
#include <cstdint>
#include "../include/nvfp4/nvfp4_decode.h"

__device__ __forceinline__ int nvfp4_gdot4(unsigned a, unsigned b, int acc) {
    int r;
    asm volatile("v_dot4_i32_i8 %0, %1, %2, %3" : "=v"(r) : "v"(a), "v"(b), "v"(acc));
    return r;
}

#ifndef NVFP4_BK
#define NVFP4_BK 64          // K 方向每次搬运的宽度
#endif
#ifndef NVFP4_TM
#define NVFP4_TM 4           // 每线程 TM x TN 个输出
#endif
#ifndef NVFP4_TN
#define NVFP4_TN 4
#endif
#define NVFP4_BM (16 * NVFP4_TM)   // block 覆盖的 M 行数（线程网格固定 16 x 16）
#define NVFP4_BN (16 * NVFP4_TN)   // block 覆盖的 N 列数
#define NVFP4_BKG (NVFP4_BK / 16)  // 这一块里包含几个 16 组

// sAe/sAo: [BK/8][BM] u32 ; sWe/sWo: [BK/8][BN] u32 ; sAsc/sWsc: [行][BKG] f32
__global__ void nvfp4_gemm_kernel(const uint32_t* __restrict__ wp, const uint8_t* __restrict__ ws,
                                  const int8_t* __restrict__ ae, const int8_t* __restrict__ ao,
                                  const float* __restrict__ asc, float* __restrict__ C,
                                  int M, int N, int K, float inv_gscale) {
    constexpr int BM = NVFP4_BM, BN = NVFP4_BN, BK = NVFP4_BK;
    constexpr int TM = NVFP4_TM, TN = NVFP4_TN, BKG = NVFP4_BKG;
    __shared__ unsigned sAe[BK / 8][BM], sAo[BK / 8][BM];
    __shared__ unsigned sWe[BK / 8][BN], sWo[BK / 8][BN];
    __shared__ float sAsc[BM][BKG], sWsc[BN][BKG];

    const int tid = threadIdx.x;
    const int tx = tid & 15, ty = tid >> 4;
    const int m0 = blockIdx.y * BM;
    const int n0 = blockIdx.x * BN;
    const int KD = K / 8;
    const int NG = K / 16;

    float facc[TM][TN];
#pragma unroll
    for (int i = 0; i < TM; i++)
#pragma unroll
        for (int j = 0; j < TN; j++) facc[i][j] = 0.f;

    for (int k0 = 0; k0 < K; k0 += BK) {
        const int NC = BK / 16;
        // ---- 激活：转置着搬进 shared ----
        for (int idx = tid; idx < BM * NC; idx += blockDim.x) {
            const int r = idx / NC, c = idx - r * NC;
            const int m = m0 + r;
            uint2 ev = make_uint2(0, 0), ov = make_uint2(0, 0);
            if (m < M) {
                ev = *(const uint2*)(ae + (size_t)m * (K / 2) + (size_t)k0 / 2 + c * 8);
                ov = *(const uint2*)(ao + (size_t)m * (K / 2) + (size_t)k0 / 2 + c * 8);
            }
            sAe[c * 2][r] = ev.x; sAe[c * 2 + 1][r] = ev.y;
            sAo[c * 2][r] = ov.x; sAo[c * 2 + 1][r] = ov.y;
        }
        // ---- 权重：解码后转置着写进 shared ----
        for (int idx = tid; idx < BN * NC; idx += blockDim.x) {
            const int r = idx / NC, c = idx - r * NC;
            const int n = n0 + r;
            uint2 x = make_uint2(0, 0);
            if (n < N) x = ((const uint2*)(wp + (size_t)n * KD))[k0 / 16 + c];
            unsigned w0e, w0o, w1e, w1o;
            nvfp4_decode8(x.x, w0e, w0o);
            nvfp4_decode8(x.y, w1e, w1o);
            sWe[c * 2][r] = w0e; sWe[c * 2 + 1][r] = w1e;
            sWo[c * 2][r] = w0o; sWo[c * 2 + 1][r] = w1o;
        }
        // ---- 尺度（每 16 个 k 一个），权重侧顺带乘 0.5/gscale ----
        for (int idx = tid; idx < BM * BKG; idx += blockDim.x) {
            const int r = idx / BKG, g = idx - r * BKG;
            const int m = m0 + r;
            sAsc[r][g] = (m < M) ? asc[(size_t)m * NG + k0 / 16 + g] : 0.f;
        }
        for (int idx = tid; idx < BN * BKG; idx += blockDim.x) {
            const int r = idx / BKG, g = idx - r * BKG;
            const int n = n0 + r;
            sWsc[r][g] = (n < N)
                ? nvfp4_e4m3_to_f32(ws[(size_t)n * NG + k0 / 16 + g]) * (0.5f * inv_gscale) : 0.f;
        }
        __syncthreads();

        // ---- 寄存器分块点积 ----
        int iacc[TM][TN];
#pragma unroll
        for (int i = 0; i < TM; i++)
#pragma unroll
            for (int j = 0; j < TN; j++) iacc[i][j] = 0;
#pragma unroll
        for (int kd = 0; kd < BK / 8; kd++) {
            unsigned aev[TM], aov[TM], wev[TN], wov[TN];
#pragma unroll
            for (int i = 0; i < TM; i++) {
                aev[i] = sAe[kd][ty * TM + i];
                aov[i] = sAo[kd][ty * TM + i];
            }
#pragma unroll
            for (int j = 0; j < TN; j++) {
                wev[j] = sWe[kd][tx * TN + j];
                wov[j] = sWo[kd][tx * TN + j];
            }
#pragma unroll
            for (int i = 0; i < TM; i++)
#pragma unroll
                for (int j = 0; j < TN; j++) {
                    iacc[i][j] = nvfp4_gdot4(aev[i], wev[j], iacc[i][j]);
                    iacc[i][j] = nvfp4_gdot4(aov[i], wov[j], iacc[i][j]);
                }
            if ((kd & 1) == 1) {          // 每 16 个 k 折一次浮点尺度
                const int g = kd >> 1;
                float sa[TM], sw[TN];
#pragma unroll
                for (int i = 0; i < TM; i++) sa[i] = sAsc[ty * TM + i][g];
#pragma unroll
                for (int j = 0; j < TN; j++) sw[j] = sWsc[tx * TN + j][g];
#pragma unroll
                for (int i = 0; i < TM; i++)
#pragma unroll
                    for (int j = 0; j < TN; j++) {
                        facc[i][j] += (float)iacc[i][j] * (sa[i] * sw[j]);
                        iacc[i][j] = 0;
                    }
            }
        }
        __syncthreads();
    }

#pragma unroll
    for (int i = 0; i < TM; i++) {
        const int m = m0 + ty * TM + i;
        if (m >= M) continue;
#pragma unroll
        for (int j = 0; j < TN; j++) {
            const int n = n0 + tx * TN + j;
            if (n < N) C[(size_t)m * N + n] = facc[i][j];
        }
    }
}

inline void nvfp4_gemm_launch(const uint32_t* wp, const uint8_t* ws, const int8_t* ae,
                              const int8_t* ao, const float* asc, float* C,
                              int M, int N, int K, float inv_gscale, hipStream_t st = 0) {
    dim3 grid((N + NVFP4_BN - 1) / NVFP4_BN, (M + NVFP4_BM - 1) / NVFP4_BM);
    nvfp4_gemm_kernel<<<grid, 256, 0, st>>>(wp, ws, ae, ao, asc, C, M, N, K, inv_gscale);
}

// 同一份算法的「精确形状」变体：M/N/K 都是分块整数倍时用，省掉 staging 里的
// 边界谓词与掩码累积（见 docs/NVFP4-GEMM-ASM.md）。暂时与原内核逐字节相同，
// 先把「第二个内核槽 + 运行时分派」这条链路打通并验证，再往里塞去守卫的 staging。
inline void nvfp4_gemm_launch_ng(const uint32_t* wp, const uint8_t* ws, const int8_t* ae,
                                 const int8_t* ao, const float* asc, float* C,
                                 int M, int N, int K, float inv_gscale, hipStream_t st = 0) {
    dim3 grid(N / NVFP4_BN, M / NVFP4_BM);
    nvfp4_gemm_kernel_ng<<<grid, 256, 0, st>>>(wp, ws, ae, ao, asc, C, M, N, K, inv_gscale);
}
