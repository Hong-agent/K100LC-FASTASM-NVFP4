// NVFP4 (E2M1) -> int8 无损解码原语（gfx926 / K100_LC）。
//
// 核心事实（见 docs/FINDINGS.md §5）：
//     E2M1 的 16 个码，取「2 x 值」之后**恰好是整数**，落在 [-12, 12]：
//         code 0..7  ->  0, 1, 2, 3, 4, 6, 8, 12
//         code 8..15 ->  0,-1,-2,-3,-4,-6,-8,-12
//     所以 FP4 -> int8 是**零误差**的（只差一个全局因子 1/2），
//     可以直接喂给 v_dot4_i32_i8，而不像 int4 那样必须二次量化。
//
// 解码实现：用两次 v_perm_b32 当一个 8 字节 LUT，再用一次 v_perm_b32 造逐字节
// 符号掩码。gfx926 上 v_perm_b32 的实测语义（docs/FINDINGS.md §4）：
//     v_perm_b32 dst, A, B, idx :  idx 字节 0..3 取 **B** 的字节 0..3
//                                 idx 字节 4..7 取 **A** 的字节 0..3
//                                 idx 字节 bit7 置位 -> 0xFF
//
// 一个 dword = 4 字节 = 8 个 FP4 码（偶数 k 在低半字节，与 compressed-tensors
// 的 `nvfp4-pack-quantized` 一致）。解得两个 int8x4：
//     W_e = [I(k0), I(k2), I(k4), I(k6)]
//     W_o = [I(k1), I(k3), I(k5), I(k7)]
// 激活侧只要按同样的「偶/奇拆开」布局存 int8，两次 dot4_i32_i8 即可。
#pragma once
#include <cstdint>

// ------------------------------------------------------------------ 表常量 --
// 正表：字节 i = I(i)，i = 0..7
#define NVFP4_P_B 0x03020100u   // I(0..3) = 0,1,2,3   （v_perm 的 B 源：index 0..3）
#define NVFP4_P_A 0x0C080604u   // I(4..7) = 4,6,8,12  （v_perm 的 A 源：index 4..7）
// 负表：字节 i = I(8+i)
#define NVFP4_N_B 0xFDFEFF00u   // I(8..11)  = 0,-1,-2,-3
#define NVFP4_N_A 0xF4F8FAFCu   // I(12..15) = -4,-6,-8,-12
// 符号掩码表：index 0 -> 0x00，index 1 -> 0xFF
#define NVFP4_SGN 0x0000FF00u

#ifdef __HIPCC__

// 逐字节：I(code) 的 4 个字节。idx/sgn 都是「每字节一个」的 dword。
__device__ __forceinline__ unsigned nvfp4_lut4(unsigned idx, unsigned sgn) {
    unsigned p, n, m;
    asm volatile("v_perm_b32 %0, %1, %2, %3" : "=v"(p) : "v"(NVFP4_P_A), "v"(NVFP4_P_B), "v"(idx));
    asm volatile("v_perm_b32 %0, %1, %2, %3" : "=v"(n) : "v"(NVFP4_N_A), "v"(NVFP4_N_B), "v"(idx));
    asm volatile("v_perm_b32 %0, %1, %2, %3" : "=v"(m) : "v"(0u), "v"(NVFP4_SGN), "v"(sgn));
    return p ^ ((p ^ n) & m);
}

// 一个 dword（8 个 FP4 码）-> 偶数 k 的 4 个 int8、奇数 k 的 4 个 int8。
__device__ __forceinline__ void nvfp4_decode8(unsigned x, unsigned& we, unsigned& wo) {
    const unsigned idx_e = x & 0x07070707u;          // 偶数码的 3bit 表索引
    const unsigned sgn_e = (x >> 3) & 0x01010101u;   // 偶数码的符号位
    const unsigned idx_o = (x >> 4) & 0x07070707u;
    const unsigned sgn_o = (x >> 7) & 0x01010101u;
    we = nvfp4_lut4(idx_e, sgn_e);
    wo = nvfp4_lut4(idx_o, sgn_o);
}

// E4M3 (1-4-3, bias 7) -> f32。gfx926 没有 v_cvt_f32_fp8，只能自己拼位。
// 每 16 个权重才用一次，成本可忽略。
__device__ __forceinline__ float nvfp4_e4m3_to_f32(unsigned b) {
    const unsigned s = (b >> 7) & 1u, e = (b >> 3) & 0xFu, m = b & 7u;
    if (e == 0) {                                   // 次正规：m/8 * 2^-6 = m * 2^-9
        const float v = (float)m * 1.953125e-3f;    // 2^-9
        return s ? -v : v;
    }
    if (e == 15) {                                  // E4M3 的 15 只有 m<7 是有限值
        if (m == 7) return 0.0f;                    // NaN -> 0（模型里不出现）
        const float v = (1.0f + 0.125f * m) * 256.0f;   // 2^(15-7) = 256
        return s ? -v : v;
    }
    unsigned u = (s << 31) | ((e + 120u) << 23) | (m << 20);   // e-7+127 = e+120
    float f;
    __builtin_memcpy(&f, &u, 4);
    return f;
}

#endif // __HIPCC__

// ------------------------------------------------- 主机侧参考（同一张表） --
#if defined(__cplusplus) && !defined(NVFP4_DEVICE_ONLY)
namespace nvfp4_host {

// 2 x E2M1 的精确整数值
inline const int* e2m1_x2_table() {
    static const int t[16] = {0, 1, 2, 3, 4, 6, 8, 12, 0, -1, -2, -3, -4, -6, -8, -12};
    return t;
}

// 逐字节参考实现（用于 CPU 端对照，语义与 nvfp4_lut4 完全一致）
inline unsigned lut4_ref(unsigned idx, unsigned sgn) {
    unsigned out = 0;
    const int* t = e2m1_x2_table();
    for (int i = 0; i < 4; i++) {
        const unsigned ix = (idx >> (8 * i)) & 7u;
        const unsigned sg = (sgn >> (8 * i)) & 1u;
        // 码 c = sg*8 + ix，值就是表里的 t[c]（表后半段本来就是负数）
        const unsigned v = ((unsigned)t[ix + (sg ? 8 : 0)]) & 0xFFu;
        out |= v << (8 * i);
    }
    return out;
}

// E4M3 (1-4-3, bias 7) -> float
inline float e4m3_to_f32_ref(unsigned b) {
    const int s = (b >> 7) & 1, e = (b >> 3) & 0xF, m = b & 7;
    double v;
    if (e == 0) v = (m / 8.0) * std::ldexp(1.0, -6);
    else if (e == 15 && m == 7) v = 0.0;
    else v = (1.0 + m / 8.0) * std::ldexp(1.0, e - 7);
    return (float)(s ? -v : v);
}

// dword（8 个码）-> 偶/奇两个 int8x4
inline void decode8_ref(unsigned x, unsigned& we, unsigned& wo) {
    const unsigned idx_e = x & 0x07070707u;
    const unsigned sgn_e = (x >> 3) & 0x01010101u;
    const unsigned idx_o = (x >> 4) & 0x07070707u;
    const unsigned sgn_o = (x >> 7) & 0x01010101u;
    we = lut4_ref(idx_e, sgn_e);
    wo = lut4_ref(idx_o, sgn_o);
}

}  // namespace nvfp4_host
#endif
