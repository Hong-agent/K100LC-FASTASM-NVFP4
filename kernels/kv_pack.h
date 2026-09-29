// KV cache / 注意力操作数的打包位宽（单一来源）。
//
// KV_BITS = 8（默认）：Q/K/V 都按 int8 打包，每个 dword 装 4 个元素，尺度取 amax/127。
// KV_BITS = 4        ：老的 int4 打包（每个 dword 8 个元素，尺度 amax/7），只留着做 A/B。
//
// 为什么要一起换：`v_dot4_i32_i8` / `v_dot8_i32_i4` 要求两个源操作数同宽度，
// 所以 Q（QK^T）与 P（PV）必须跟着 K/V 一起换位宽，格式是**全局**的一个选择，
// 不是单个张量的选项。编译：FLAGS="-DKV_BITS=4" bash scripts/build_rt.sh
#pragma once

#ifndef KV_BITS
#define KV_BITS 8
#endif

#if KV_BITS == 8
#define KVEL 4            // 每个 dword（u32）装几个元素
#define KVQMAX 127        // 量化满量程：codes ∈ [-128, 127]，尺度 = amax / KVQMAX
#elif KV_BITS == 4
#define KVEL 8
#define KVQMAX 7
#else
#error "KV_BITS 只能是 4 或 8"
#endif

#define KVMASK ((1u << KV_BITS) - 1u)   // 单个码的掩码
