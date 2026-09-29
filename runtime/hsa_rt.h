// hsa_rt.h —— 「全自研」路线的运行时垫片。
//
// RT4 运行时（K100LC-RT4/src）只用到了很小一撮 HIP API：内存分配/拷贝、内核启动
// （<<<>>>）、事件与同步。这里用 /opt/hyhal 的 HSA 直接实现这一小撮，内核全部来自
// k100lc-asm 自研汇编器产出的 HSACO（build/k100lc_all.hsaco），**不链接任何 DTK
// 组件**（libgalaxyhip / libamd_comgr / hipcc 一概不需要）。
//
// 用法（见 tools/build_nodtk.sh）：把 src/*.hip 里的设备代码剥掉、把 <<<>>> 换成
// hsart_launch(...)，再和本文件一起用 g++ 编译。
#pragma once
#include <cstddef>
#include <cstdint>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <initializer_list>
#include <string>

// ============================ HIP API 子集 ============================
typedef int hipError_t;
#define hipSuccess 0
typedef uint16_t __half;                 // 只在 launch 参数的指针类型里出现

struct dim3 {                            // 与 HIP 的 dim3 兼容的最小版本
    unsigned x, y, z;
    dim3(unsigned x_ = 1, unsigned y_ = 1, unsigned z_ = 1) : x(x_), y(y_), z(z_) {}
};

struct EventImpl;
struct StreamImpl;
typedef StreamImpl* hipStream_t;         // 与 HIP 一样是指针类型（0 = 默认流）
typedef EventImpl* hipEvent_t;

enum {
    hipMemcpyHostToDevice = 1,
    hipMemcpyDeviceToHost = 2,
    hipMemcpyDeviceToDevice = 3,
    hipEventDisableTiming = 1,
};

hipError_t hipMalloc(void** p, size_t n);
template <class T>                              // HIP 的 hipMalloc 是模板，照抄一份
inline hipError_t hipMalloc(T** p, size_t n) {
    return hipMalloc(reinterpret_cast<void**>(p), n);
}
hipError_t hipHostMalloc(void** p, size_t n);
hipError_t hipFree(void* p);
hipError_t hipMemcpy(void* dst, const void* src, size_t n, int kind);
hipError_t hipMemcpyAsync(void* dst, const void* src, size_t n, int kind, hipStream_t s);
hipError_t hipMemcpy2DAsync(void* dst, size_t dpitch, const void* src, size_t spitch,
                            size_t width, size_t height, int kind, hipStream_t s);
hipError_t hipMemset(void* p, int v, size_t n);
hipError_t hipDeviceSynchronize();
hipError_t hipStreamCreate(hipStream_t* s);
hipError_t hipStreamSynchronize(hipStream_t s);
hipError_t hipStreamWaitEvent(hipStream_t s, hipEvent_t e, unsigned flags);
hipError_t hipEventCreate(hipEvent_t* e);
hipError_t hipEventCreateWithFlags(hipEvent_t* e, unsigned flags);
hipError_t hipEventRecord(hipEvent_t e, hipStream_t s);
hipError_t hipEventSynchronize(hipEvent_t e);
hipError_t hipEventElapsedTime(float* ms, hipEvent_t a, hipEvent_t b);
hipError_t hipGetLastError();
const char* hipGetErrorString(hipError_t e);

// 内核表（由 tools/gen_nodtk.py 从自研 HSACO 的 metadata 生成）
#include "nodtk_kernels.h"

// 把一包 kernarg 投递给指定内核（实现在 hsa_rt.cpp）
void hsart_dispatch(const RtKernel* k, dim3 grid, dim3 block, int smem,
                    const void* kernarg, size_t kernarg_size);
void hsart_init(const char* hsaco_path);        // 幂等；默认读 $RT_HSACO

// ============================ 内核启动 ============================
// 生成的源码里，`foo_k<<<g, b, smem>>>(a, x, n);` 被改写成
//   hsart_launch("foo_k", g, b, smem, 0, a, x, n);
// 参数按 metadata 的 .offset/.size 逐个搬进 kernarg（顺序与源码一致）。
inline void hsart_fill_arg(const RtKernel* k, size_t idx, char* kernarg, size_t ksize,
                           const void* val, size_t vsize) {
    if (idx >= k->nargs) {
        fprintf(stderr, "hsa_rt: %s 参数过多（表里只有 %u 个）\n", k->name, k->nargs);
        exit(1);
    }
    const RtArg& a = k->args[idx];
    if (a.kind > 1) {                    // 隐藏参数由 dispatch 侧填，这里跳过（不该发生）
        fprintf(stderr, "hsa_rt: %s 第 %zu 个参数是隐藏参数 %u\n", k->name, idx, a.kind);
        exit(1);
    }
    size_t n = vsize < a.size ? vsize : a.size;
    if ((size_t)a.off + n > ksize) { fprintf(stderr, "hsa_rt: %s kernarg 越界\n", k->name); exit(1); }
    memcpy(kernarg + a.off, val, n);
}

const RtKernel* hsart_lookup(const char* name);

template <class... A>
inline void hsart_launch(const char* name, dim3 grid, dim3 block, int smem, int stream, A... args) {
    (void)stream;                        // 全部走单队列（默认流）
    hsart_init(nullptr);
    const RtKernel* k = hsart_lookup(name);
    if (!k) { fprintf(stderr, "hsa_rt: 自研 HSACO 里没有内核 %s\n", name); exit(1); }
    char kernarg[MAX_KERNARG];
    memset(kernarg, 0, k->kernarg_size);
    size_t idx = 0;
    (void)std::initializer_list<int>{ (hsart_fill_arg(k, idx++, kernarg, k->kernarg_size,
                                                      (const void*)&args, sizeof(A)), 0)... };
    hsart_dispatch(k, grid, block, smem, kernarg, k->kernarg_size);
}
