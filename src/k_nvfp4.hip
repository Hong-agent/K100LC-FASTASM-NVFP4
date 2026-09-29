// 混合模式：MLP 用**原始 NVFP4 权重**直跑，其余部分仍走 RT4 的 int4/FP8 路径。
//
// 为什么要这个文件：RT4 的 MLP 权重是离线重量化过的 int4（有损）。这里换成
// checkpoint 里原样的 NVFP4（无损），复用 k100lc-fast-nvfp4 的内核：
//     kernels/nvfp4_gemv_kernel.h   解码 GEMV（宽载版）与激活量化
//     kernels/nvfp4_gemm.hip        预填充 GEMM
// 编译时用 -I 指向那个项目，保持内核单一来源，不复制代码。
//
// 与 RT4 现有路径的差别只有一处：激活按 **16** 个一组量化（对齐 NVFP4 的块），
// 而 RT4 的 int4 路径按 128 个一组。其余（残差、norm、采样）完全不动。
#include "kernels.h"
#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include "nvfp4_gemv_kernel.h"      // -I ../k100lc-fast-nvfp4/kernels
#include "nvfp4_gemm_kernel.h"

// ---------------------------------------------------------------- 激活缓冲 --
static int8_t* s_ae = nullptr;
static int8_t* s_ao = nullptr;
static float*  s_as = nullptr;
static long long s_capa = 0;              // 按 rows*K 计

static void ensure_act(int rows, int K) {
    const long long need = (long long)rows * K;
    if (need <= s_capa) return;
    if (s_ae) hipFree(s_ae);
    if (s_ao) hipFree(s_ao);
    if (s_as) hipFree(s_as);
    hipMalloc(&s_ae, need / 2 + 64);
    hipMalloc(&s_ao, need / 2 + 64);
    hipMalloc(&s_as, (size_t)rows * (K / 16) * 4 + 64);
    s_capa = need;
}

static void quant_act16(const float* x, int rows, int K) {
    nvfp4_quant_act<<<dim3(K / 16, rows), 32>>>(x, s_ae, s_ao, s_as, rows, K);
    if (hipGetLastError() != hipSuccess) { printf("nvfp4 quant_act16 launch fail\n"); exit(1); }
}

// -------------------------------------------------------------- 解码 GEMV --
void k_nvfp4_gemv(float* y, const void* wp, const void* ws, float inv_gscale,
                  const float* x, int rows, int N, int K) {
    if (rows > 4) { printf("k_nvfp4_gemv: rows=%d > 4（预填充请走 GEMM）\n", rows); exit(1); }
    if (K % 32) { printf("k_nvfp4_gemv: K=%d 不是 32 的倍数\n", K); exit(1); }
    if ((K / 16) % 2) { printf("k_nvfp4_gemv: K/16=%d 不是偶数\n", K / 16); exit(1); }
    ensure_act(rows, K);
    static const int noq = getenv("RT_NOQ") ? atoi(getenv("RT_NOQ")) : 0;
    if (!noq) quant_act16(x, rows, K);
    nvfp4_gemv_wide_launch(rows, (const uint32_t*)wp, (const uint8_t*)ws, s_ae, s_ao, s_as,
                           y, N, K, inv_gscale, 1);
    if (hipGetLastError() != hipSuccess) { printf("nvfp4 gemv launch fail\n"); exit(1); }
}

// ------------------------------------------------------------ 预填充 GEMM --
void k_nvfp4_gemm(float* y, const void* wp, const void* ws, float inv_gscale,
                  const float* x, int M, int N, int K) {
    if (K % 64) { printf("k_nvfp4_gemm: K=%d 不是 64 的倍数\n", K); exit(1); }
    if ((K / 16) % 2) { printf("k_nvfp4_gemm: K/16 不是偶数\n"); exit(1); }
    ensure_act(M, K);
    quant_act16(x, M, K);
    nvfp4_gemm_launch((const uint32_t*)wp, (const uint8_t*)ws, s_ae, s_ao, s_as,
                      y, M, N, K, inv_gscale);
    if (hipGetLastError() != hipSuccess) { printf("nvfp4 gemm launch fail\n"); exit(1); }
}
