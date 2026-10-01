// 解码 GEMV 封装：复用现役 W4A4 GEMV（kernels/gemv_w4a4_core.h）
#include "kernels.h"
#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include "../kernels/gemv_w4a4_core.h"
#include "../kernels/gemv_w4a8_core.h"

// 量化缓冲（激活按 32 个一组）：随 rows 变化，按需扩容
static uint8_t* s_aq = nullptr;
static float*   s_as = nullptr;
static long long s_cap = 0;

void k_gemv_w4a4(float* y, const u32* wq, const float* wsc, const float* x, int rows, int N, int K) {
    if (rows > 4) { printf("k_gemv_w4a4: rows=%d > 4（预填充请走 GEMM）\n", rows); exit(1); }
    const long long need = (long long)rows * K;
    if (need > s_cap) {
        if (s_aq) hipFree(s_aq);
        if (s_as) hipFree(s_as);
        hipMalloc(&s_aq, need / 2 + 64);
        hipMalloc(&s_as, (size_t)rows * (K / SG) * 4 + 64);
        s_cap = need;
    }
    dim3 qgrid(K / SG, rows);
    quant_act4<<<qgrid, 32>>>(x, s_aq, s_as, rows, K);
    // M=4（MTP 验证批）走 ROWS=2 变体：每 warp 2 行权重、共享同一份激活加载，
    // 实测权重带宽 372 → 515 GB/s（+38%）；结果与 gemv_w4a4<4> 逐位一致。
    if (rows == 4 || rows == 3) {
        const int nwarp2 = NTHREADS / 64;
        const dim3 g2((N + nwarp2 * 2 - 1) / (nwarp2 * 2));
        if (rows == 4)
            gemv_w4a4_r2_k<<<g2, NTHREADS>>>((const u32*)wq, (const uint16_t*)wsc,
                                             (const u32*)s_aq, s_as, y, N, K);
        else
            gemv_w4a4_r2_m3_k<<<g2, NTHREADS>>>((const u32*)wq, (const uint16_t*)wsc,
                                                (const u32*)s_aq, s_as, y, N, K);
        if (hipGetLastError() != hipSuccess) { printf("gemv_w4a4_r2 launch fail\n"); exit(1); }
        return;
    }
    if (getenv("GEMV_DEBUG")) {
        float h[8]; uint8_t hq[8];
        hipMemcpy(h, s_as, 16, hipMemcpyDeviceToHost);
        hipMemcpy(hq, s_aq, 8, hipMemcpyDeviceToHost);
        printf("    [gemv] N=%d K=%d rows=%d  as[0:4]=%.5f %.5f %.5f %.5f  aq[0:4]=%02x %02x %02x %02x  x[0:2]=%.5f %.5f\n",
               N, K, rows, h[0], h[1], h[2], h[3], hq[0], hq[1], hq[2], hq[3], x[0], x[1]);
    }
    const int nwarp = NTHREADS / 64;
    const dim3 grid((N + nwarp * ROWS - 1) / (nwarp * ROWS));
    switch (rows) {
        case 1: gemv_w4a4<1><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_aq, s_as, y, N, K); break;
        case 2: gemv_w4a4<2><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_aq, s_as, y, N, K); break;
        case 3: gemv_w4a4<3><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_aq, s_as, y, N, K); break;
        case 4: gemv_w4a4<4><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_aq, s_as, y, N, K); break;
    }
    if (hipGetLastError() != hipSuccess) { printf("gemv launch fail\n"); exit(1); }
}

// ---------------------------------------------------------------- W4A8 ----
// 解码路径现役内核：int4 权重 × int8 激活（dot4），权重只读一遍。
// 激活缓冲按需扩容；ae/ao 是「偶数下标 / 奇数下标」两半的 int8。
static int8_t* s_ae = nullptr;
static int8_t* s_ao = nullptr;
static float*  s_asc = nullptr;
static int*    s_asu = nullptr;
static long long s_cap8 = 0;

// 激活缓冲按需扩容（elems = 元素数 = rows×K）
static void w4a8_ensure(long long elems) {
    if (elems <= s_cap8) return;
    if (s_ae) hipFree(s_ae);
    if (s_ao) hipFree(s_ao);
    if (s_asc) hipFree(s_asc);
    if (s_asu) hipFree(s_asu);
    hipMalloc(&s_ae, elems / 2 + 64);
    hipMalloc(&s_ao, elems / 2 + 64);
    hipMalloc(&s_asc, elems / GRP * 4 + 64);
    hipMalloc(&s_asu, elems / GRP * 4 + 64);
    s_cap8 = elems;
}

// 只做激活量化（不跑 GEMV）：MoE 里 8 个专家的 gate/up 用的是同一份 xb，
// 量化一次就够。原来每个专家都重新量化一遍 —— 每层白扔十几次内核投递
//（单次投递实测 8.4 µs，是 8 专家路径的主要开销之一）。
// elems 必须是 GRP(128) 的整数倍（按 aoff 取用时的组边界才对齐）。
void k_w4a8_quant(const float* x, long long elems) {
    if (elems % GRP) { printf("k_w4a8_quant: elems=%lld 不是 %d 的整数倍\n", elems, GRP); exit(1); }
    w4a8_ensure(elems);
    static const int noq = getenv("RT_NOQ") ? atoi(getenv("RT_NOQ")) : 0;
    if (!noq)
        quant_act<<<dim3((unsigned)(elems / GRP), 1), 32>>>(x, s_ae, s_ao, s_asc, s_asu,
                                                            1, (int)elems);
}

// 用「已量化」的激活跑一行 W4A8 GEMV；aoff 是激活元素偏移（GRP 的整数倍）。
void k_w4a8_run1(float* y, const u32* wq, const float* wsc, int N, int K, long long aoff) {
    if (aoff % GRP) { printf("k_w4a8_run1: aoff=%lld 不是 %d 的整数倍\n", aoff, GRP); exit(1); }
    const int nwarp = NTHREADS / 64;
    const dim3 grid((N + nwarp - 1) / nwarp);
    gemv_w4a8<1, false, 1><<<grid, NTHREADS>>>(
        wq, (const uint16_t*)wsc, (const u32*)(s_ae + aoff / 2), (const u32*)(s_ao + aoff / 2),
        s_asc + aoff / GRP, s_asu + aoff / GRP, y, N, K);
    if (hipGetLastError() != hipSuccess) { printf("k_w4a8_run1 launch fail\n"); exit(1); }
}

void k_gemv_w4a8(float* y, const u32* wq, const float* wsc, const float* x, int rows, int N, int K) {
    if (rows > 4) { printf("k_gemv_w4a8: rows=%d > 4（预填充请走 GEMM）\n", rows); exit(1); }
    if (K % GRP) { printf("k_gemv_w4a8: K=%d 不是 %d 的整数倍\n", K, GRP); exit(1); }
    const long long need = (long long)rows * K;
    w4a8_ensure(need);
    // RT_NOQ=1 只用于计时对照：跳过量化内核（结果是错的，只回答「这些启动值多少时间」）
    static const int noq = getenv("RT_NOQ") ? atoi(getenv("RT_NOQ")) : 0;
    if (!noq) quant_act<<<dim3(K / GRP, rows), 32>>>(x, s_ae, s_ao, s_asc, s_asu, rows, K);
    const int nwarp = NTHREADS / 64;
    // M=2~4 是 MTP 校验批：一个 warp 处理 2 行权重、共享激活加载，实测带宽
    // M=2 +7%、M=3 +18%、M=4 +22%。M=1 继续用 1 行/warp（ROWS=2 在单 token 解码反而慢）。
    const int rpp = rows >= 2 ? 2 : 1;
    const dim3 grid((N + nwarp * rpp - 1) / (nwarp * rpp));
    // M==1（解码）走共享内存版本：激活先协作搬进 LDS，全局侧只剩权重。
    // 共享内存 = 2*(K/8)*4（激活）+ 2*(K/GRP)*4（尺度）字节。
    // 实测：把激活搬进 LDS 反而更慢（41.7 vs 38.2 ms/token）——4 个 warp 重复读的
    // 那份激活本来就命中 L1/L2，而协作装载多了一次块内 barrier 和共享内存占用。
    // 代码留着，默认关闭（RT_SMEM=1 才启用）以便以后换形状时再试。
    static const int nosmem = getenv("RT_SMEM") ? 0 : 1;
    // 激活搬进 LDS 的分支：M=1 时省掉 4 个 warp 的重复全局读；M>1 时更重要——
    // 每个 lane 每轮要读 M×32B 激活、只读 NROW×16B 权重，激活的全局负载是权重
    // 的数倍，会把权重流拖住（实测见 docs/GEMV.md 与桌面效率报告）。
    // 默认关闭（RT_SMEM=1 打开），A/B 用。
    const size_t smem_bytes = (size_t)(2 * rows * (K / 8) + 2 * rows * (K / GRP)) * 4;
    if (!nosmem && smem_bytes <= 48 * 1024) {
#ifndef RT_NODTK
        // 无 DTK 构建里设备内核不存在（内核由自研 HSACO 提供），这段动态共享内存
        // 上限设置也不需要：hsa_rt 直接把 smem 写进 dispatch packet。
        static bool done_attr = false;
        if (!done_attr) {
            for (const void* fn : {(const void*)&gemv_w4a8<1, true, 1>,
                                   (const void*)&gemv_w4a8<2, true, 2>,
                                   (const void*)&gemv_w4a8<3, true, 2>,
                                   (const void*)&gemv_w4a8<4, true, 2>})
                hipFuncSetAttribute(fn, hipFuncAttributeMaxDynamicSharedMemorySize, 48 * 1024);
            done_attr = true;
        }
#endif
        switch (rows) {
            case 1: gemv_w4a8<1, true, 1><<<grid, NTHREADS, smem_bytes>>>(
                        wq, (const uint16_t*)wsc, (const u32*)s_ae, (const u32*)s_ao,
                        s_asc, s_asu, y, N, K); break;
            case 2: gemv_w4a8<2, true, 2><<<grid, NTHREADS, smem_bytes>>>(
                        wq, (const uint16_t*)wsc, (const u32*)s_ae, (const u32*)s_ao,
                        s_asc, s_asu, y, N, K); break;
            case 3: gemv_w4a8<3, true, 2><<<grid, NTHREADS, smem_bytes>>>(
                        wq, (const uint16_t*)wsc, (const u32*)s_ae, (const u32*)s_ao,
                        s_asc, s_asu, y, N, K); break;
            case 4: gemv_w4a8<4, true, 2><<<grid, NTHREADS, smem_bytes>>>(
                        wq, (const uint16_t*)wsc, (const u32*)s_ae, (const u32*)s_ao,
                        s_asc, s_asu, y, N, K); break;
        }
        if (hipGetLastError() != hipSuccess) { printf("gemv_w4a8 smem launch fail\n"); exit(1); }
        return;
    }
    switch (rows) {
        case 1: gemv_w4a8<1, false, 1><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_ae,
                                                           (const u32*)s_ao, s_asc, s_asu, y, N, K); break;
        case 2: gemv_w4a8<2, false, 2><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_ae,
                                                           (const u32*)s_ao, s_asc, s_asu, y, N, K); break;
        case 3: gemv_w4a8<3, false, 2><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_ae,
                                                           (const u32*)s_ao, s_asc, s_asu, y, N, K); break;
        case 4: gemv_w4a8<4, false, 2><<<grid, NTHREADS>>>(wq, (const uint16_t*)wsc, (const u32*)s_ae,
                                                           (const u32*)s_ao, s_asc, s_asu, y, N, K); break;
    }
    if (hipGetLastError() != hipSuccess) { printf("gemv_w4a8 launch fail\n"); exit(1); }
}
