// Qwen3.6-35B-A3B（qwen35moe, Q8_0 GGUF）自研运行时。
//
// 与稠密 27B 那条路径（model.cpp）并行存在：同一套 HSA 运行时（runtime/hsa_rt）
// 与自研内核（k_new/k_fa/…），只是权重来源换成 GGUF 原生编码、MLP 换成 MoE。
//
// 当前进度：M1 骨架 —— 读 GGUF 元数据当配置、把 753 张量全部上卡、报告显存占用。
// 前向（SSM/注意力/MoE/MTP）在后续里程碑接上。
#include "moe35.h"

#include "gguf.h"
#include "kernels.h"
#include "vision_kernels.h"
#include "vision.h"
#include <hip/hip_runtime.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <algorithm>
#include <sys/stat.h>
#include <map>
#include <string>
#include <vector>

// 分段计时（RT_Q36_PROF=1）
struct Prof {
    double attn = 0, moe = 0, head = 0, embed = 0;
    long long n = 0;
    void add(double& slot, std::chrono::steady_clock::time_point t0) {
        slot += std::chrono::duration<double, std::milli>(
                    std::chrono::steady_clock::now() - t0).count();
    }
    void report() {
        if (!n) return;
        fprintf(stderr, "/token: attn=%.1fms moe=%.1fms head=%.1fms embed=%.1fms (%.1fms/token, n=%lld)\n",
                attn / n, moe / n, head / n, embed / n,
                (attn + moe + head + embed) / n, n);
    }
};

#define CK(x) do { hipError_t e_ = (x); if (e_ != hipSuccess) { \
    printf("HIP ERR %s @%d: %s\n", #x, __LINE__, hipGetErrorString(e_)); exit(1);} } while (0)

namespace {

// qwen35moe 的配置：全部来自 GGUF 元数据，不写死维度。
struct Cfg35 {
    int n_layer = 0, hidden = 0, n_head = 0, n_kv = 0, head_dim = 0;
    int vocab = 0;
    int lk_head = 0, lv_head = 0, ldim = 0, conv_k = 0, inner = 0;
    int n_expert = 0, top_k = 0, moe_inter = 0, shexp_inter = 0;
    int full_interval = 4, rot = 0, mtp_layers = 0;
    float eps = 1e-6f, rope_theta = 1e7f;
    bool is_full(int il) const { return (il + 1) % full_interval == 0; }
    int n_full() const { int c = 0; for (int i = 0; i < n_layer; i++) if (is_full(i)) c++; return c; }
};

long long meta(Gguf& g, const char* k, long long def = 0) {
    auto it = g.meta_int.find(k);
    return it == g.meta_int.end() ? def : it->second;
}

Cfg35 cfg_from_gguf(Gguf& g) {
    Cfg35 c;
    c.n_layer     = (int)meta(g, "qwen35moe.block_count");          // 含 MTP 层
    c.hidden      = (int)meta(g, "qwen35moe.embedding_length");
    c.n_head      = (int)meta(g, "qwen35moe.attention.head_count");
    c.n_kv        = (int)meta(g, "qwen35moe.attention.head_count_kv");
    c.head_dim    = (int)meta(g, "qwen35moe.attention.key_length");
    c.vocab       = 248320;                                          // token_embd dim1
    c.lk_head     = (int)meta(g, "qwen35moe.ssm.group_count");
    c.inner       = (int)meta(g, "qwen35moe.ssm.inner_size");        // 4096
    c.ldim        = (int)meta(g, "qwen35moe.ssm.state_size");        // 128
    c.lv_head     = c.ldim ? c.inner / c.ldim : 0;                   // 32
    c.conv_k      = (int)meta(g, "qwen35moe.ssm.conv_kernel");
    c.n_expert    = (int)meta(g, "qwen35moe.expert_count");
    c.top_k       = (int)meta(g, "qwen35moe.expert_used_count");
    c.moe_inter   = (int)meta(g, "qwen35moe.expert_feed_forward_length");
    c.shexp_inter = (int)meta(g, "qwen35moe.expert_shared_feed_forward_length");
    c.full_interval = (int)meta(g, "qwen35moe.full_attention_interval", 4);
    c.rot         = (int)meta(g, "qwen35moe.rope.dimension_count");
    c.mtp_layers  = (int)meta(g, "qwen35moe.nextn_predict_layers");
    c.eps         = (float)g.meta_num.count("qwen35moe.attention.layer_norm_rms_epsilon")
                        ? (float)g.meta_num["qwen35moe.attention.layer_norm_rms_epsilon"]
                        : 1e-6f;
    c.rope_theta  = (float)(g.meta_num.count("qwen35moe.rope.freq_base")
                            ? g.meta_num["qwen35moe.rope.freq_base"] : 1e7);
    c.n_layer -= c.mtp_layers;          // block_count 含 MTP 层，前向只跑主干
    return c;
}

// 一份上卡后的权重：名字 → 显存指针 / 类型 / 形状
struct DevTensor {
    void* p = nullptr;
    int type = 0;
    long long nbytes = 0;
    std::vector<long long> dims;
    long long nelem() const { long long n = 1; for (long long d : dims) n *= d; return n; }
};

struct Weights35 {
    std::map<std::string, DevTensor> t;
    long long total = 0;
    const DevTensor* find(const std::string& n) const {
        auto it = t.find(n);
        return it == t.end() ? nullptr : &it->second;
    }
};

// 逐张量 pread → 显存（分块拷贝；主机内存只有几 GB，不能整份读进来）
void upload_tensor(Gguf& g, const GgufTensor& src, DevTensor& dst, long long file_size) {
    const long long abs = g.file_off(src);
    if (abs + src.nbytes > file_size) {
        printf("  !! %s 还没下完（需要到 %lld，文件只有 %.2f GB）\n",
               src.name.c_str(), abs + src.nbytes, file_size / 1e9);
        exit(2);
    }
    CK(hipMalloc(&dst.p, (size_t)src.nbytes));
    const size_t CH = 64ull << 20;
    for (long long off = 0; off < src.nbytes; off += (long long)CH) {
        const size_t n = (size_t)std::min<long long>(CH, src.nbytes - off);
        CK(hipMemcpy((uint8_t*)dst.p + off, g.map + abs + off, n, hipMemcpyHostToDevice));
    }
    dst.type = src.type;
    dst.nbytes = src.nbytes;
    dst.dims = src.dims;
}

int usage() {
    printf("moe35: rt --gguf <model.gguf> [--load-only] [--q8-selftest]\n");
    return 1;
}

// ---------------------------------------------------------------- Q8_0 GEMV --
// q8_0_dot_k 的参数（kernarg 72，从内核汇编逐条核对）：
//   (w, x, partial, nblocks, workgroup, nbpr, magic_nbpr,
//    rows_per_exp_x, magic_rpe_x, ids, expert_stride, rows_per_exp_w, magic_rpe_w)
// 语义：gid = 全局块号 i；q1,b = divmod(i,nbpr)；e = q1/rows_per_exp_x →
//   x 块 = e*nbpr+b；w_grp = q1/rows_per_exp_w → id = ids[w_grp]，
//   w 块 = id*stride + (q1%rows_per_exp_w)*nbpr + b（Q8_0 块 = 34 字节 / 32 权重）。
// 单矩阵：rows_per_exp_x = rows_per_exp_w = rows，ids[0]=0，stride 任意 → 退化成普通 GEMV。
uint32_t div_magic(uint32_t d) { return (uint32_t)((0x100000000ull / d) + 1); }

// ids 表必须给**设备**指针（内核按 global buffer 读）；单矩阵时内容是 0。
uint32_t* ids_zero() {
    static uint32_t* p = nullptr;
    if (!p) {
        CK(hipMalloc(&p, 4));
        uint32_t z = 0;
        CK(hipMemcpy(p, &z, 4, hipMemcpyHostToDevice));
    }
    return p;
}

void k_q8_dot(const void* w, const float* x, float* partial, int nblocks, int nbpr,
              int rpe_x, const uint32_t* ids, uint32_t stride, int rpe_w) {
    q8_0_dot_k<<<nblocks, 64>>>(w, x, partial, nblocks, 64, nbpr, (int)div_magic(nbpr),
                                rpe_x, (int)div_magic(rpe_x), ids, stride, rpe_w,
                                (int)div_magic(rpe_w));
}

void k_reduce(const float* partial, float* y, int rows, int nbpr) {
    reduce_blocks_k<<<rows, 64>>>(partial, y, rows, nbpr);
}

// f32 权重 GEMV：y[N] = W[N][K] · x[K]（路由 gate / 小张量）
void linear_f32(float* y, const float* w, const float* x, int N, int K) {
    gemv_f32_k<<<N, 64>>>(w, x, y, (unsigned)N, (unsigned)(K / 4), 64u);
}

// Q8_0 权重视图（GGUF 里 ne0 = 连续维 = K，ne1 = N）
struct Q8W { const void* p = nullptr; int N = 0, K = 0; };

// y[N] = W[N][K] · x[K]（M=1，解码路径）
//
// 注意：一次发射的 workgroup 数不能太大 —— 实测 N=248320（K=2048 → 1590 万
// workgroup / 10.2 亿 work-item）会让 GPU 报 "Invalid address access"，
// 而 4 万~4 百万 workgroup 正常。这里按 65536 行分块发射绕开。
void linear_q8(float* y, const Q8W& w, const float* x, float* partial) {
    const int nbpr = w.K / 32;
    const int CHUNK = 65536;
    for (int r0 = 0; r0 < w.N; r0 += CHUNK) {
        const int rn = std::min(CHUNK, w.N - r0);
        const void* wp = (const uint8_t*)w.p + (long long)r0 * nbpr * 34;
        k_q8_dot(wp, x, partial, rn * nbpr, nbpr, rn, ids_zero(), 0u, rn);
        k_reduce(partial, y + r0, rn, nbpr);
    }
}

// F32 权重自检：blk.0.ffn_gate_inp [K=2048, N=256]（MoE 路由矩阵）
void f32_selftest(Gguf& g, long long file_size) {
    const GgufTensor* t = g.find("blk.0.ffn_gate_inp.weight");
    if (!t || t->type != 0) { printf("ffn_gate_inp 不是 F32\n"); return; }
    const int K = (int)t->dims[0], N = (int)t->dims[1];
    if (g.file_off(*t) + t->nbytes > file_size) { printf("  还没下完\n"); return; }
    printf("F32 自检：blk.0.ffn_gate_inp [N=%d,K=%d]\n", N, K);
    const float* w = (const float*)(g.map + g.file_off(*t));
    std::vector<float> x((size_t)K);
    srand(7);
    for (int i = 0; i < K; i++) x[i] = (float)((rand() % 2000) - 1000) / 1000.f;
    float *d_w = nullptr, *d_x = nullptr, *d_y = nullptr;
    CK(hipMalloc(&d_w, (size_t)t->nbytes));
    CK(hipMemcpy(d_w, w, (size_t)t->nbytes, hipMemcpyHostToDevice));
    CK(hipMalloc(&d_x, (size_t)K * 4));
    CK(hipMemcpy(d_x, x.data(), (size_t)K * 4, hipMemcpyHostToDevice));
    CK(hipMalloc(&d_y, (size_t)N * 4));
    linear_f32(d_y, d_w, d_x, N, K);
    CK(hipDeviceSynchronize());
    std::vector<float> got((size_t)N);
    CK(hipMemcpy(got.data(), d_y, (size_t)N * 4, hipMemcpyDeviceToHost));
    double maxerr = 0;
    for (int n = 0; n < N; n++) {
        double acc = 0;
        for (int k = 0; k < K; k++) acc += (double)w[(size_t)n * K + k] * x[k];
        maxerr = std::max(maxerr, fabs(acc - got[n]));
    }
    printf("  最大绝对误差 %.3e → %s\n", maxerr, maxerr < 1e-2 ? "一致 ✓" : "不一致 ✗");
}

// 专家切片自检：blk.0.ffn_gate_exps [K=2048, N=512, E=256] 的第 0 / 255 个专家
void expert_selftest(Weights35& w, int expert) {
    const DevTensor* t = w.find("blk.0.ffn_gate_exps.weight");
    if (!t) { printf("没有 blk.0.ffn_gate_exps.weight\n"); return; }
    const int K = (int)t->dims[0], N = (int)t->dims[1];
    const long long stride = (long long)N * (K / 32) * 34;
    printf("专家切片自检：专家 %d（K=%d N=%d stride=%lld）\n", expert, K, N, stride);
    void* d_w = nullptr;
    CK(hipMalloc(&d_w, (size_t)stride));
    CK(hipMemcpy(d_w, (const uint8_t*)t->p + (long long)expert * stride, (size_t)stride,
                 hipMemcpyDeviceToDevice));
    std::vector<float> x((size_t)K), got((size_t)N);
    srand(99 + expert);
    for (int i = 0; i < K; i++) x[i] = (float)((rand() % 2000) - 1000) / 1000.f;
    float *d_x = nullptr, *d_y = nullptr, *d_p = nullptr;
    CK(hipMalloc(&d_x, (size_t)K * 4));
    CK(hipMemcpy(d_x, x.data(), (size_t)K * 4, hipMemcpyHostToDevice));
    CK(hipMalloc(&d_y, (size_t)N * 4));
    CK(hipMalloc(&d_p, (size_t)N * (K / 32) * 4));
    Q8W wq{d_w, N, K};
    linear_q8(d_y, wq, d_x, d_p);
    CK(hipDeviceSynchronize());
    CK(hipMemcpy(got.data(), d_y, (size_t)N * 4, hipMemcpyDeviceToHost));
    // CPU 参考：把专家切片从显存拷回主机再解
    std::vector<uint8_t> raw((size_t)stride);
    CK(hipMemcpy(raw.data(), d_w, (size_t)stride, hipMemcpyDeviceToHost));
    double maxerr = 0;
    const int nbpr = K / 32;
    for (int n = 0; n < 8; n++) {
        double acc = 0;
        for (int b = 0; b < nbpr; b++) {
            const uint8_t* blk = raw.data() + ((size_t)n * nbpr + b) * 34;
            uint16_t h; memcpy(&h, blk, 2);
            const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
            float d = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
            if (sg) d = -d;
            for (int i = 0; i < 32; i++)
                acc += (double)d * (double)((const int8_t*)blk)[2 + i] * x[b * 32 + i];
        }
        maxerr = std::max(maxerr, fabs(acc - (double)got[n]));
        if (n < 2) printf("  row%d gpu=%.6f cpu=%.6f\n", n, got[n], acc);
    }
    printf("  最大绝对误差 %.3e → %s\n", maxerr, maxerr < 1e-3 ? "一致 ✓" : "不一致 ✗");
}

// 大矩阵 GEMV 规模二分：lm_head（N=248320, K=2048）——找出 grid 上限
void big_gemv_test(Weights35& w, int N) {
    const DevTensor* t = w.find("output.weight");
    if (!t) { printf("没有 output.weight\n"); return; }
    const int K = (int)t->dims[0];
    const int nbpr = K / 32;
    printf("大 GEMV 测试：N=%d（%d 个块，grid=%d workgroup）\n", N, N * nbpr, N * nbpr);
    std::vector<float> x((size_t)K);
    for (int i = 0; i < K; i++) x[i] = (float)((i % 17) - 8) / 8.f;
    float *d_x = nullptr, *d_y = nullptr, *d_p = nullptr;
    CK(hipMalloc(&d_x, (size_t)K * 4));
    CK(hipMemcpy(d_x, x.data(), (size_t)K * 4, hipMemcpyHostToDevice));
    CK(hipMalloc(&d_y, (size_t)N * 4));
    CK(hipMalloc(&d_p, (size_t)N * nbpr * 4));
    Q8W wq{t->p, N, K};
    linear_q8(d_y, wq, d_x, d_p);
    CK(hipDeviceSynchronize());
    std::vector<float> got(4);
    CK(hipMemcpy(got.data(), d_y, 16, hipMemcpyDeviceToHost));
    printf("  前 4 行 GPU: %.6f %.6f %.6f %.6f（同步 OK）\n", got[0], got[1], got[2], got[3]);
}

// 自检：拿 output.weight 的前若干行，与 Python 参考（tools/gguf_head.py 之外另算）对账。
void q8_selftest(Gguf& g, long long file_size) {
    const GgufTensor* t = g.find("output.weight");
    if (!t) { printf("没有 output.weight\n"); return; }
    const int K = (int)t->dims[0], N = (int)t->dims[1];
    const int rows = 8;                       // 只验前 8 行
    printf("Q8_0 自检：output.weight [N=%d,K=%d]，取前 %d 行\n", N, K, rows);
    const long long need = g.file_off(*t) + (long long)rows * (K / 32) * 34;
    if (need > file_size) { printf("  权重还没下完\n"); return; }

    Q8W w{t->type == 8 ? (const void*)(g.map + g.file_off(*t)) : nullptr, rows, K};
    if (!w.p) { printf("  类型不是 Q8_0\n"); return; }
    // 权重上卡（只用前 rows 行）+ 随机输入
    void* d_w = nullptr; float *d_x = nullptr, *d_y = nullptr, *d_p = nullptr;
    const size_t wb = (size_t)rows * (K / 32) * 34;
    CK(hipMalloc(&d_w, wb));
    CK(hipMemcpy(d_w, w.p, wb, hipMemcpyHostToDevice));
    std::vector<float> x((size_t)K), ref((size_t)rows);
    srand(1234);
    for (int i = 0; i < K; i++) x[i] = (float)((rand() % 2000) - 1000) / 1000.f;
    CK(hipMalloc(&d_x, (size_t)K * 4));
    CK(hipMemcpy(d_x, x.data(), (size_t)K * 4, hipMemcpyHostToDevice));
    CK(hipMalloc(&d_y, (size_t)rows * 4));
    const int nbpr = K / 32;
    CK(hipMalloc(&d_p, (size_t)rows * nbpr * 4));
    Q8W wr{d_w, rows, K};
    linear_q8(d_y, wr, d_x, d_p);
    CK(hipDeviceSynchronize());
    std::vector<float> got((size_t)rows);
    CK(hipMemcpy(got.data(), d_y, (size_t)rows * 4, hipMemcpyDeviceToHost));

    // 主机参考：按 Q8_0 布局解码（d 是 f16，qs 是 32 个 int8）
    const uint8_t* raw = (const uint8_t*)w.p;
    double maxerr = 0;
    for (int r = 0; r < rows; r++) {
        float acc = 0;
        for (int b = 0; b < nbpr; b++) {
            const uint8_t* blk = raw + ((size_t)r * nbpr + b) * 34;
            uint16_t h; memcpy(&h, blk, 2);
            const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
            float d = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
            if (sg) d = -d;
            for (int i = 0; i < 32; i++) {
                const int8_t q = ((const int8_t*)blk)[2 + i];
                acc += d * (float)q * x[b * 32 + i];
            }
        }
        ref[r] = acc;
        const double e = fabs((double)got[r] - (double)acc);
        if (e > maxerr) maxerr = e;
        if (r < 3) printf("  row%d: gpu=%.6f  cpu=%.6f\n", r, got[r], acc);
    }
    printf("  最大绝对误差 %.3e → %s\n", maxerr, maxerr < 1e-3 ? "一致 ✓" : "不一致 ✗");
}

// ================================ 模型 =====================================
// 布局约定（与 GGUF 的 ne0 连续一致，也就与内核的 w[n*K + k] 一致）：
//   Q8_0 专家张量 [K, N, E]：第 e 个专家基址 = p + e*(N*K/32*34)

// ================= Q8_0 → W8（hi/lo 两张 int4）重打包 =====================
// 动机：q8_0_dot_k 实测只有 ~7.8 GB/s（指令受限、且不跨行复用权重），而现役
// W4A8 GEMV 在 M=1..4 行时能到 300~500 GB/s（27B 的 MTP 就是这么存的）。
// 于是把 Q8_0 权重一次性重打包成「int8 = 16*hi + lo」两张 int4 + 每 128 组
// f16 尺度（hi 的尺度预乘 16），运行时用现役 k_gemv_w4a8 跑两遍相加 ——
// 精度与 Q8 等价（int8 权重 × int8 激活），显存不变（4bit+4bit = 8bit）。
struct W8 {
    const u32* hi = nullptr;        // [rows][K/2] 低半字节 = 偶数 k
    const u32* lo = nullptr;
    const uint16_t* shi = nullptr;  // [rows][K/128] f16（= 16*s）
    const uint16_t* slo = nullptr;  // [rows][K/128] f16（= s）
    long long rows = 0, K = 0;
};

inline uint16_t f32_to_f16(float f) {
    uint32_t u; memcpy(&u, &f, 4);
    const uint32_t sg = (u >> 31) & 1, ex = (u >> 23) & 0xFF, ma = u & 0x7FFFFF;
    int e = (int)ex - 127 + 15;
    uint16_t h;
    if (ex == 0) { h = (uint16_t)(sg << 15); }
    else if (e >= 31) { h = (uint16_t)((sg << 15) | (31 << 10)); }
    else if (e <= 0) { h = (uint16_t)(sg << 15); }
    else { h = (uint16_t)((sg << 15) | ((uint32_t)e << 10) | (ma >> 13)); }
    return h;
}

// t：设备上的 Q8_0 张量（行 = 行，列 = K，第二/三维都被展平成行）
bool packchk_done = false;
W8 pack_q8(DevTensor* t) {
    const int K = (int)t->dims[0];
    long long rows = 1;
    for (size_t i = 1; i < t->dims.size(); i++) rows *= t->dims[i];
    const int nb32 = K / 32, nb128 = K / 128;
    if (K % 128) { printf("pack_q8: K=%d 不是 128 的倍数\n", K); exit(1); }
    W8 w;
    w.rows = rows; w.K = K;
    u32* dhi = nullptr; u32* dlo = nullptr; uint16_t* dshi = nullptr; uint16_t* dslo = nullptr;
    CK(hipMalloc(&dhi, (size_t)rows * (K / 8) * 4));
    CK(hipMalloc(&dlo, (size_t)rows * (K / 8) * 4));
    CK(hipMalloc(&dshi, (size_t)rows * nb128 * 2));
    CK(hipMalloc(&dslo, (size_t)rows * nb128 * 2));
    const long long CH_ROWS = 4096;
    std::vector<uint8_t> src;
    std::vector<uint32_t> hi, lo;
    std::vector<uint16_t> shi, slo;
    for (long long r0 = 0; r0 < rows; r0 += CH_ROWS) {
        const long long rn = std::min(CH_ROWS, rows - r0);
        const size_t row_bytes = (size_t)nb32 * 34;
        src.resize((size_t)rn * row_bytes);
        CK(hipMemcpy(src.data(), (const uint8_t*)t->p + (size_t)r0 * row_bytes,
                     src.size(), hipMemcpyDeviceToHost));
        hi.assign((size_t)rn * (K / 8), 0u);
        lo.assign((size_t)rn * (K / 8), 0u);
        shi.assign((size_t)rn * nb128, 0);
        slo.assign((size_t)rn * nb128, 0);
        for (long long r = 0; r < rn; r++) {
            for (int g = 0; g < nb128; g++) {
                float blk[128];
                float amax = 0.f;
                for (int s32 = 0; s32 < 4; s32++) {
                    const uint8_t* bp = src.data() + ((size_t)r * nb32 + g * 4 + s32) * 34;
                    uint16_t hh; memcpy(&hh, bp, 2);
                    const uint32_t sg = (hh >> 15) & 1, ex = (hh >> 10) & 0x1F,
                                   ma = hh & 0x3FF;
                    float d = ex == 0 ? ldexpf(ma / 1024.f, -14)
                                      : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
                    if (sg) d = -d;
                    for (int i = 0; i < 32; i++) {
                        const float v = d * (float)((const int8_t*)bp)[2 + i];
                        blk[s32 * 32 + i] = v;
                        amax = std::max(amax, fabsf(v));
                    }
                }
                const float sc = amax > 0 ? amax / 127.f : 1.f;
                shi[(size_t)r * nb128 + g] = f32_to_f16(sc * 16.f);
                slo[(size_t)r * nb128 + g] = f32_to_f16(sc);
                for (int i = 0; i < 128; i++) {
                    int q = (int)lrintf(blk[i] / sc);
                    q = std::max(-128, std::min(127, q));
                    const int hi4 = (q + 8) >> 4;          // floor，∈ [-8,7]
                    const int lo4 = q - 16 * hi4;           // ∈ [-8,7]
                    const size_t dword = (size_t)r * (K / 8) + (size_t)(g * 128 + i) / 8;
                    const int sh = 4 * ((g * 128 + i) % 8);
                    hi[dword] |= (uint32_t)(hi4 & 0xF) << sh;
                    lo[dword] |= (uint32_t)(lo4 & 0xF) << sh;
                }
            }
        }
        CK(hipMemcpy((uint8_t*)dhi + (size_t)r0 * (K / 8) * 4, hi.data(), hi.size() * 4,
                     hipMemcpyHostToDevice));
        CK(hipMemcpy((uint8_t*)dlo + (size_t)r0 * (K / 8) * 4, lo.data(), lo.size() * 4,
                     hipMemcpyHostToDevice));
        CK(hipMemcpy((uint8_t*)dshi + (size_t)r0 * nb128 * 2, shi.data(), shi.size() * 2,
                     hipMemcpyHostToDevice));
        CK(hipMemcpy((uint8_t*)dslo + (size_t)r0 * nb128 * 2, slo.data(), slo.size() * 2,
                     hipMemcpyHostToDevice));
    }
    if (getenv("RT_Q36_PACKCHK") && !packchk_done) {
        packchk_done = true;
        const size_t row_bytes = (size_t)nb32 * 34;
        std::vector<uint8_t> one(row_bytes);
        CK(hipMemcpy(one.data(), (const uint8_t*)t->p, row_bytes, hipMemcpyDeviceToHost));
        // 第一行前 128 个权重的 Q8 原值与 W8 重建值（从刚打包的 host 缓冲取）
        printf("packchk [rows=%lld K=%d]  前 8 个权重：\n", rows, K);
        for (int i = 0; i < 8; i++) {
            const uint8_t* bp = one.data() + (i / 32) * 34;
            uint16_t hh; memcpy(&hh, bp, 2);
            const uint32_t sg2 = (hh >> 15) & 1, ex2 = (hh >> 10) & 0x1F, ma2 = hh & 0x3FF;
            float d = ex2 == 0 ? ldexpf(ma2 / 1024.f, -14) : ldexpf(1.f + ma2 / 1024.f, (int)ex2 - 15);
            if (sg2) d = -d;
            const float q8v = d * (float)((const int8_t*)bp)[2 + i % 32];
            const uint32_t dw = hi[(size_t)(i / 8)];
            const int h4 = (int)((dw >> (4 * (i % 8))) & 0xF);
            const int hi_s = h4 >= 8 ? h4 - 16 : h4;
            uint32_t dwl = lo[(size_t)(i / 8)];
            const int l4 = (int)((dwl >> (4 * (i % 8))) & 0xF);
            const int lo_s = l4 >= 8 ? l4 - 16 : l4;
            float sh; { uint16_t t16 = shi[(size_t)(i / 128)];
                        const uint32_t s2 = (t16 >> 15) & 1, e2 = (t16 >> 10) & 0x1F, m2 = t16 & 0x3FF;
                        float f2 = e2 == 0 ? ldexpf(m2 / 1024.f, -14) : ldexpf(1.f + m2 / 1024.f, (int)e2 - 15);
                        sh = sg2 ? -f2 : f2; }
            float sl; { uint16_t t16 = slo[(size_t)(i / 128)];
                        const uint32_t s2 = (t16 >> 15) & 1, e2 = (t16 >> 10) & 0x1F, m2 = t16 & 0x3FF;
                        float f2 = e2 == 0 ? ldexpf(m2 / 1024.f, -14) : ldexpf(1.f + m2 / 1024.f, (int)e2 - 15);
                        sl = sg2 ? -f2 : f2; }
            const float w8v = hi_s * sh + lo_s * sl;
            printf("   k=%d  Q8=%.6f  W8=%.6f  hi=%d sh=%.6f lo=%d sl=%.6f\n",
                   i, q8v, w8v, hi_s, sh, lo_s, sl);
        }
    }
    if (!getenv("RT_Q36_KEEPQ8")) CK(hipFree((void*)t->p));   // 源 Q8 用完就还显存
    else t->nbytes = 0;
    t->p = nullptr;
    w.hi = dhi; w.lo = dlo; w.shi = dshi; w.slo = dslo;
    return w;
}

// y[rows] = W · x（rows ≤ 4，两遍 W4A8）
void lin_w8(float* y, const W8& w, const float* x, int rows, int n_out,
            long long row_off = 0, float* tmp = nullptr) {
    k_gemv_w4a8(y, (const u32*)((const uint8_t*)w.hi + row_off * (w.K / 8) * 4),
                (const float*)((const uint8_t*)w.shi + row_off * (w.K / 128) * 2),
                x, rows, n_out, (int)w.K);
    if (!tmp) return;
    k_gemv_w4a8(tmp, (const u32*)((const uint8_t*)w.lo + row_off * (w.K / 8) * 4),
                (const float*)((const uint8_t*)w.slo + row_off * (w.K / 128) * 2),
                x, rows, n_out, (int)w.K);
    k_add_inplace(y, tmp, (long long)rows * n_out);
}

// MTP（blk.40）：nextn.eh_proj + 一层全注意力 + MoE + shared_head_norm → lm_head
struct MtpW {
    const DevTensor *in_ln = nullptr, *post_ln = nullptr, *q = nullptr, *k = nullptr,
                    *v = nullptr, *o = nullptr, *qnorm = nullptr, *knorm = nullptr;
    const DevTensor *eh = nullptr, *enorm = nullptr, *hnorm = nullptr, *shnorm = nullptr;
    const DevTensor *ginp = nullptr, *gshexp = nullptr, *gexp = nullptr, *uexp = nullptr,
                    *dexp = nullptr, *sgate = nullptr, *sup = nullptr, *sdown = nullptr;
    u32 *kc = nullptr; float *ksc = nullptr, *vsc = nullptr, *vstage = nullptr; u32 *vc = nullptr;
    float *e = nullptr, *hn = nullptr, *cat = nullptr, *x = nullptr;
    int len = 0;                       // MTP 自己的位置计数
    bool bound = false;
};

struct Mo35 {
    Gguf g;
    Cfg35 cfg;
    Weights35 w;

    struct L {
        const DevTensor *in_ln = nullptr, *post_ln = nullptr;
        // 线性注意力
        const DevTensor *qkv = nullptr, *z = nullptr, *conv = nullptr, *alog = nullptr,
                        *dtb = nullptr, *snorm = nullptr, *sout = nullptr;
        float *alpha = nullptr, *beta = nullptr;      // Q8_0 → f32（小张量，加载时解）
        // 全注意力
        const DevTensor *q = nullptr, *k = nullptr, *v = nullptr, *o = nullptr,
                        *qnorm = nullptr, *knorm = nullptr;
        // MoE
        const DevTensor *ginp = nullptr, *gshexp = nullptr, *gexp = nullptr,
                        *uexp = nullptr, *dexp = nullptr, *sgate = nullptr,
                        *sup = nullptr, *sdown = nullptr;
    };
    std::vector<L> Ls;
    const DevTensor *embed = nullptr, *fnorm = nullptr, *lmhead = nullptr;
    MtpW mtp;

    // 激活（单 token；预填充时按 token 循环）
    float *x = nullptr, *xb = nullptr, *qfull = nullptr, *hq = nullptr, *hgate = nullptr,
          *hkk = nullptr, *hvv = nullptr, *hfa = nullptr, *hout = nullptr, *z_ = nullptr,
          *qkv3 = nullptr, *conv = nullptr, *gq = nullptr, *gk = nullptr, *gv = nullptr,
          *gab = nullptr, *gbeta = nullptr, *gg = nullptr, *tmp = nullptr, *gbuf = nullptr,
          *ubuf = nullptr, *dbuf = nullptr, *acc = nullptr, *router = nullptr,
          *shexp = nullptr,
          *partial = nullptr, *logits = nullptr, *pout = nullptr, *pmax = nullptr,
          *psum = nullptr, *conv_prev = nullptr;
    u32* qq = nullptr;
    float* qs = nullptr;
    std::vector<u32*> kc; std::vector<float*> ksc;
    std::vector<u32*> vc; std::vector<float*> vsc; std::vector<float*> vstage;
    std::vector<float*> conv_state, ssm_state;
    int seq_len = 0, max_ctx = 40960, TP = 64, BM = 64;
    int n_partial = 0;
    std::map<const void*, W8> w8;      // 张量 → 重打包后的 W8
    float* tmp8 = nullptr;             // 第二遍（lo）输出暂存（按最大 N 分配）
    // 批量校验（M = K+1 ≤ 4 行）的缓冲
    float *h_last = nullptr;                    // 主模型最近一次的位置 hidden（MTP 草拟用）
    float *xr = nullptr, *xbr = nullptr, *qfull_r = nullptr, *hq_r = nullptr,
          *hgate_r = nullptr, *hkk_r = nullptr, *hvv_r = nullptr, *hout_r = nullptr,
          *tmp_r = nullptr, *z_r = nullptr, *qkv_r = nullptr, *conv_r = nullptr,
          *gq_r = nullptr, *gk_r = nullptr, *gv_r = nullptr, *gab_r = nullptr,
          *gbeta_r = nullptr, *gg_r = nullptr, *g_r = nullptr, *u_r = nullptr,
          *d_r = nullptr, *router_r = nullptr, *shexp_r = nullptr, *acc_r = nullptr,
          *logits_r = nullptr, *convprev_r = nullptr;
    u32* ids_exp = nullptr;                    // 每 (行,槽) 的专家号表
    u32* snap_mtp_kc = nullptr;                // MTP KV 快照（回滚用）
    int* d_arg = nullptr;                      // 批量 argmax 输出
    std::vector<float*> snap_list_conv, snap_list_ssm;   // 每层的逐 token 快照槽
    std::vector<float*> snap_conv_A, snap_ssm_A;         // 批量前的整层快照
    VisionModel vis;
    bool vision_on = false;
    std::vector<float> emb_override;      // 图片 embedding（[rows][H]）
    std::map<int, int> emb_rows;          // 位置 → emb_override 的行号
    Prof prof;
    bool mtp_enabled = false;
    bool spec_mode = false;             // decode_step 里由它主导草拟链
    int draft = -1;
    long long mtp_try = 0, mtp_hit = 0;
    int mtp_k = 3;                              // 投机草稿数（1..3）

    float* alloc(int n) {
        float* p = nullptr;
        CK(hipMalloc(&p, (size_t)n * 4 + 64));
        CK(hipMemset(p, 0, (size_t)n * 4));
        return p;
    }
    u32* alloc_u32(int n) {
        u32* p = nullptr;
        CK(hipMalloc(&p, (size_t)n * 4 + 64));
        CK(hipMemset(p, 0, (size_t)n * 4));
        return p;
    }
};

// ---------------------------------------------------------------- 权重绑定 --
// GGUF 里 GDN 的 value-head 顺序与 HF/引擎不同：GGUF 下标 i = g + Hk*v，
// HF 下标 j = g*rep + v（rep = Hv/Hk）。不改内核，而是在上卡后把按 head
// 分块的权重就地换成 HF 顺序（见 tools/gguf_vhead_perm.py 的同一套公式）。
void permute_head_blocks(uint8_t* p, int n_heads, size_t block_bytes, int Hk, int rep) {
    std::vector<uint8_t> tmp((size_t)n_heads * block_bytes);
    memcpy(tmp.data(), p, tmp.size());
    for (int j = 0; j < n_heads; j++) {
        const int i = (j % rep) * Hk + j / rep;          // HF j ← GGUF i
        memcpy(p + (size_t)j * block_bytes, tmp.data() + (size_t)i * block_bytes, block_bytes);
    }
}

// 把一份张量（或其片段）的 head 分块换成 HF 顺序；rows=每一行有多少字节的块
// axis_rows=true：head 是「行」方向（块 = 每 head 的整行）；false：head 在行内（列）
void fix_vhead(DevTensor* t, int Hk, int Hv, int rows_per_head, bool axis_rows,
               long long row_off = 0, long long n_rows = -1) {
    const int rep = Hv / Hk;
    const long long N = t->dims.size() > 1 ? t->dims[1] : 1;      // 行数
    const long long row_bytes = t->nbytes / N;
    if (n_rows < 0) n_rows = N - row_off;
    std::vector<uint8_t> buf((size_t)n_rows * row_bytes);
    CK(hipMemcpy(buf.data(), (const uint8_t*)t->p + (size_t)row_off * row_bytes,
                 buf.size(), hipMemcpyDeviceToHost));
    if (axis_rows) {
        permute_head_blocks(buf.data(), Hv, (size_t)rows_per_head * row_bytes, Hk, rep);
    } else {
        const size_t blk = row_bytes / Hv;                        // 每 head 在行内的字节数
        std::vector<uint8_t> tmp(blk);
        for (long long r = 0; r < n_rows; r++) {
            uint8_t* row = buf.data() + (size_t)r * row_bytes;
            std::vector<uint8_t> whole(row_bytes);
            memcpy(whole.data(), row, row_bytes);
            for (int j = 0; j < Hv; j++) {
                const int i = (j % rep) * Hk + j / rep;
                memcpy(row + (size_t)j * blk, whole.data() + (size_t)i * blk, blk);
            }
        }
    }
    CK(hipMemcpy((uint8_t*)t->p + (size_t)row_off * row_bytes, buf.data(), buf.size(),
                 hipMemcpyHostToDevice));
}

// 1-D f32 向量（A_log / dt_bias）：每个 value head 一个元素
void fix_vhead_1d(DevTensor* t, int Hk, int Hv) {
    const int rep = Hv / Hk;
    std::vector<float> v((size_t)Hv), o((size_t)Hv);
    CK(hipMemcpy(v.data(), t->p, (size_t)Hv * 4, hipMemcpyDeviceToHost));
    for (int j = 0; j < Hv; j++) o[j] = v[(j % rep) * Hk + j / rep];
    CK(hipMemcpy(t->p, o.data(), (size_t)Hv * 4, hipMemcpyHostToDevice));
}

const DevTensor* need(Weights35& w, const std::string& n) {
    const DevTensor* t = w.find(n);
    if (!t) { printf("缺张量 %s\n", n.c_str()); exit(1); }
    return t;
}

DevTensor* need_mut(Weights35& w, const std::string& n) {
    auto it = w.t.find(n);
    if (it == w.t.end()) { printf("缺张量 %s\n", n.c_str()); exit(1); }
    return &it->second;
}

// 主机侧把 Q8_0 矩阵解成 f32 再上卡（只用于小张量：in_proj_a/b 这类）
float* q8_to_f32(Weights35& w, const std::string& name) {
    const DevTensor* t = need(w, name);
    if (t->type != 8) { printf("%s 不是 Q8_0\n", name.c_str()); exit(1); }
    const int K = (int)t->dims[0], N = (int)t->dims[1];
    std::vector<uint8_t> raw((size_t)t->nbytes);
    CK(hipMemcpy(raw.data(), t->p, (size_t)t->nbytes, hipMemcpyDeviceToHost));
    std::vector<float> out((size_t)N * K);
    const int nb = K / 32;
    for (int n = 0; n < N; n++)
        for (int b = 0; b < nb; b++) {
            const uint8_t* blk = raw.data() + ((size_t)n * nb + b) * 34;
            uint16_t h; memcpy(&h, blk, 2);
            const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
            float d = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
            if (sg) d = -d;
            for (int i = 0; i < 32; i++)
                out[(size_t)n * K + b * 32 + i] =
                    d * (float)((const int8_t*)blk)[2 + i];
        }
    float* dev = nullptr;
    CK(hipMalloc(&dev, out.size() * 4));
    CK(hipMemcpy(dev, out.data(), out.size() * 4, hipMemcpyHostToDevice));
    return dev;
}

void bind(Mo35& m) {
    Weights35& w = m.w;
    m.embed = need(w, "token_embd.weight");
    m.fnorm = need(w, "output_norm.weight");
    m.lmhead = need(w, "output.weight");
    m.Ls.resize(m.cfg.n_layer);
    for (int il = 0; il < m.cfg.n_layer; il++) {
        char b[256];
        auto nm = [&](const char* s) { snprintf(b, sizeof(b), "blk.%d.%s", il, s); return std::string(b); };
        Mo35::L& L = m.Ls[il];
        L.in_ln = need(w, nm("attn_norm.weight"));
        L.post_ln = need(w, nm("post_attention_norm.weight"));
        // MoE（每层都有）
        L.ginp = need(w, nm("ffn_gate_inp.weight"));
        L.gshexp = need(w, nm("ffn_gate_inp_shexp.weight"));
        L.gexp = need(w, nm("ffn_gate_exps.weight"));
        L.uexp = need(w, nm("ffn_up_exps.weight"));
        L.dexp = need(w, nm("ffn_down_exps.weight"));
        L.sgate = need(w, nm("ffn_gate_shexp.weight"));
        L.sup = need(w, nm("ffn_up_shexp.weight"));
        L.sdown = need(w, nm("ffn_down_shexp.weight"));
        if (m.cfg.is_full(il)) {
            L.q = need(w, nm("attn_q.weight"));
            L.k = need(w, nm("attn_k.weight"));
            L.v = need(w, nm("attn_v.weight"));
            L.o = need(w, nm("attn_output.weight"));
            L.qnorm = need(w, nm("attn_q_norm.weight"));
            L.knorm = need(w, nm("attn_k_norm.weight"));
        } else {
            L.qkv = need(w, nm("attn_qkv.weight"));
            L.z = need(w, nm("attn_gate.weight"));
            L.conv = need(w, nm("ssm_conv1d.weight"));
            L.alog = need(w, nm("ssm_a"));
            L.dtb = need(w, nm("ssm_dt.bias"));
            L.snorm = need(w, nm("ssm_norm.weight"));
            L.sout = need(w, nm("ssm_out.weight"));
            L.alpha = q8_to_f32(w, nm("ssm_alpha.weight"));
            L.beta = q8_to_f32(w, nm("ssm_beta.weight"));
            // GGUF 的 v-head 顺序 → HF/引擎顺序（否则门控/β/A_log/z/out_proj 全错位）
            const int Hk = m.cfg.lk_head, Hv = m.cfg.lv_head, D = m.cfg.ldim;
            const int qn = Hk * D, vn = Hv * D;
            fix_vhead_1d(need_mut(w, nm("ssm_a")), Hk, Hv);
            fix_vhead_1d(need_mut(w, nm("ssm_dt.bias")), Hk, Hv);
            // alpha/beta：q8_to_f32 出来的 f32 副本也要按同一顺序重排
            {
                const int rep = Hv / Hk;
                const int Kh = m.cfg.hidden;
                std::vector<float> ta((size_t)Hv * Kh), tb((size_t)Hv * Kh);
                CK(hipMemcpy(ta.data(), L.alpha, ta.size() * 4, hipMemcpyDeviceToHost));
                CK(hipMemcpy(tb.data(), L.beta, tb.size() * 4, hipMemcpyDeviceToHost));
                std::vector<float> oa(ta.size()), ob(tb.size());
                (void)qn;
                for (int j = 0; j < Hv; j++) {
                    const int i = (j % rep) * Hk + j / rep;
                    memcpy(oa.data() + (size_t)j * Kh, ta.data() + (size_t)i * Kh,
                           (size_t)Kh * 4);
                    memcpy(ob.data() + (size_t)j * Kh, tb.data() + (size_t)i * Kh,
                           (size_t)Kh * 4);
                }
                CK(hipMemcpy(L.alpha, oa.data(), oa.size() * 4, hipMemcpyHostToDevice));
                CK(hipMemcpy(L.beta, ob.data(), ob.size() * 4, hipMemcpyHostToDevice));
            }
            fix_vhead(need_mut(w, nm("attn_gate.weight")), Hk, Hv, D, true);
            fix_vhead(need_mut(w, nm("ssm_out.weight")), Hk, Hv, D, false);
            fix_vhead(need_mut(w, nm("ssm_conv1d.weight")), Hk, Hv, D, true, 2 * qn, vn);
            fix_vhead(need_mut(w, nm("attn_qkv.weight")), Hk, Hv, D, true, 2 * qn, vn);
        }
    }
    // 把 Q8_0 线性权重重打包成 W8（hi/lo int4），运行时走现役高速 W4A8 内核
    // 注意：W8（hi/lo int4 + W4A8 内核）实测线性层快 5~86 倍，
    // 但数值还没有对齐（整模型输出退化），所以默认关闭，用 RT_Q36_W8=1 打开。
    if (getenv("RT_Q36_W8") && strcmp(getenv("RT_Q36_W8"), "0")) {
        int npack = 0;
        long long bytes = 0;
        for (auto& kv : w.t) {
            DevTensor& t = kv.second;
            if (!t.p || t.type != 8) continue;                 // 只处理 Q8_0
            if (t.dims.empty() || t.dims[0] % 128) continue;   // K 必须是 128 的倍数
            if (kv.first.find("token_embd") != std::string::npos) continue;   // 词表走主机解
            if (const char* one = getenv("RT_Q36_PACK_ONE"))
                if (kv.first != one) continue;
            W8 p8 = pack_q8(&t);
            bytes += (long long)p8.rows * p8.K;
            m.w8[&kv.second] = p8;
            npack++;
        }
        printf("W8 重打包：%d 个 Q8_0 线性权重（%.2f GB）\n", npack, bytes / 1e9);
        fflush(stdout);
    }
    printf("权重绑定完成：%d 层\n", m.cfg.n_layer);
    fprintf(stderr, "权重绑定完成：%d 层\n", m.cfg.n_layer);
}

void alloc_bufs(Mo35& m) {
    const Cfg35& c = m.cfg;
    const int H = c.hidden, Hn = c.n_head, KV = c.n_kv, D = c.head_dim;
    const int qd = Hn * D, pd = qd * 2;
    const int qn = c.lk_head * c.ldim, vn = c.lv_head * c.ldim, C = qn * 2 + vn;
    const int E = c.n_expert, MI = c.moe_inter;
    m.x = m.alloc(H); m.xb = m.alloc(H); m.tmp = m.alloc(std::max(H, vn));
    m.qfull = m.alloc(pd); m.hq = m.alloc(qd); m.hgate = m.alloc(qd);
    m.hkk = m.alloc(KV * D); m.hvv = m.alloc(KV * D);
    m.hfa = m.alloc(Hn * m.TP * D); m.hout = m.alloc(qd);
    m.z_ = m.alloc(vn); m.qkv3 = m.alloc(C); m.conv = m.alloc(C);
    m.gq = m.alloc(qn); m.gk = m.alloc(qn); m.gv = m.alloc(vn);
    m.gab = m.alloc(2 * c.lv_head); m.gbeta = m.alloc(c.lv_head); m.gg = m.alloc(c.lv_head);
    m.gbuf = m.alloc(MI); m.ubuf = m.alloc(MI); m.dbuf = m.alloc(H);
    m.acc = m.alloc(H); m.router = m.alloc(E);
    m.shexp = m.alloc(1);
    m.conv_prev = m.alloc((c.conv_k - 1) * C);
    m.qq = m.alloc_u32(Hn * m.TP * (D / KVEL));
    m.qs = m.alloc(Hn * 2 * m.TP);
    m.pout = m.alloc(4 * 24 * 32 * D);
    m.pmax = m.alloc(4 * 24 * 32);
    m.psum = m.alloc(4 * 24 * 32);
    // partial：最大的是 lm_head（N=vocab, nbpr=K/32）
    m.n_partial = std::max((int)(c.vocab * (H / 32)),
                           std::max(MI * (H / 32), H * (MI / 32)));
    m.partial = m.alloc(m.n_partial);
    m.logits = m.alloc(c.vocab);
    m.kc.resize(c.n_layer, nullptr); m.ksc.resize(c.n_layer, nullptr);
    m.vc.resize(c.n_layer, nullptr); m.vsc.resize(c.n_layer, nullptr);
    m.vstage.resize(c.n_layer, nullptr);
    m.conv_state.resize(c.n_layer, nullptr); m.ssm_state.resize(c.n_layer, nullptr);
    for (int il = 0; il < c.n_layer; il++) {
        if (c.is_full(il)) {
            m.kc[il] = m.alloc_u32(KV * m.max_ctx * (D / KVEL));
            m.ksc[il] = m.alloc(KV * 2 * m.max_ctx);
            m.vc[il] = m.alloc_u32(KV * (m.max_ctx / KVEL) * D);
            m.vsc[il] = m.alloc(KV * (m.max_ctx / 64) * D);
            m.vstage[il] = m.alloc(KV * 64 * D);
        } else {
            m.conv_state[il] = m.alloc((c.conv_k - 1) * C);
            m.ssm_state[il] = m.alloc(c.lv_head * c.ldim * c.ldim);
        }
    }
    // 批量校验缓冲（M4 = 4 行）
    {
        const int M4 = 4;
        const int C = qn * 2 + vn;
        m.h_last = m.alloc(H);
        m.tmp8 = m.alloc(c.vocab);
        m.xr = m.alloc(M4 * H); m.xbr = m.alloc(M4 * H);
        m.qfull_r = m.alloc(M4 * pd); m.hq_r = m.alloc(M4 * qd); m.hgate_r = m.alloc(M4 * qd);
        m.hkk_r = m.alloc(M4 * KV * D); m.hvv_r = m.alloc(M4 * KV * D);
        m.hout_r = m.alloc(M4 * qd); m.tmp_r = m.alloc(M4 * std::max(H, vn));
        m.z_r = m.alloc(M4 * vn); m.qkv_r = m.alloc(M4 * C); m.conv_r = m.alloc(M4 * C);
        m.gq_r = m.alloc(M4 * qn); m.gk_r = m.alloc(M4 * qn); m.gv_r = m.alloc(M4 * vn);
        m.gab_r = m.alloc(M4 * 2 * c.lv_head); m.gbeta_r = m.alloc(M4 * c.lv_head);
        m.gg_r = m.alloc(M4 * c.lv_head);
        m.g_r = m.alloc(M4 * c.top_k * MI); m.u_r = m.alloc(M4 * c.top_k * MI);
        m.d_r = m.alloc(M4 * c.top_k * H);
        m.router_r = m.alloc(M4 * E); m.shexp_r = m.alloc(M4);
        m.acc_r = m.alloc(M4 * H);
        m.convprev_r = m.alloc((c.conv_k - 1) * C);
        CK(hipMalloc(&m.ids_exp, (size_t)M4 * c.top_k * 4));
        CK(hipMalloc(&m.d_arg, (size_t)M4 * 4));
        m.snap_mtp_kc = m.alloc_u32(c.n_kv * m.max_ctx * (D / KVEL));
        // 每层状态快照（投机解码被拒时要回滚）
        for (int il = 0; il < c.n_layer; il++) {
            m.snap_conv_A.push_back(c.is_full(il) ? nullptr : m.alloc((c.conv_k - 1) * C));
            m.snap_ssm_A.push_back(c.is_full(il) ? nullptr : m.alloc(c.lv_head * c.ldim * c.ldim));
            if (c.is_full(il)) { m.snap_list_conv.push_back(nullptr); m.snap_list_ssm.push_back(nullptr); }
            else {
                m.snap_list_conv.push_back(m.alloc(4 * (c.conv_k - 1) * C));
                m.snap_list_ssm.push_back(m.alloc(4 * c.lv_head * c.ldim * c.ldim));
            }
        }
    }
    printf("激活/KV 缓冲就绪（max_ctx=%d）\n", m.max_ctx);
}

// ------------------------------------------------------------------ 前向 ---
#define STEP(msg) do { if (getenv("RT_Q36_TRACE")) { printf("  [trace] %s\n", msg); fflush(stdout); } } while (0)
#define TRACE_SYNC(tag) do { if (getenv("RT_Q36_TRACE")) { CK(hipDeviceSynchronize()); printf("  [trace] %s\n", tag); fflush(stdout); } } while (0)

// Q8_0 线性层；expert >= 0 时按专家切片（第 3 维是专家数）
// 若该张量已重打包成 W8，则走两遍 W4A8（快 50 倍），否则退回 Q8 融合点积。
void lin_q8(Mo35& m, float* y, const DevTensor* t, const float* x, int expert = -1) {
    const int K = (int)t->dims[0];
    const int N = t->dims.size() > 1 ? (int)t->dims[1] : 1;
    auto it8 = m.w8.find(t);
    if (it8 != m.w8.end()) {
        const long long rowoff = expert >= 0 ? (long long)expert * N : 0;
        lin_w8(y, it8->second, x, 1, N, rowoff, m.tmp8);
        return;
    }
    const void* p = t->p;
    if (expert >= 0 && t->dims.size() > 2) {
        const long long stride = (long long)N * (K / 32) * 34;
        p = (const uint8_t*)p + (long long)expert * stride;
    }
    Q8W w{p, N, K};
    linear_q8(y, w, x, m.partial);
}

void lin_f32(Mo35& m, float* y, const DevTensor* t, const float* x) {
    const int K = (int)t->dims[0];
    const int N = t->dims.size() > 1 ? (int)t->dims[1] : 1;
    linear_f32(y, (const float*)t->p, x, N, K);
}

// 词表行：主机侧解 Q8_0 → dst（token_embd [K=2048, V]）
void embed_row_into(Mo35& m, int id, float* dst) {
    STEP("embed");
    const DevTensor* t = m.embed;
    const int K = (int)t->dims[0];
    const long long row_bytes = (long long)(K / 32) * 34;
    std::vector<uint8_t> raw((size_t)row_bytes);
    CK(hipMemcpy(raw.data(), (const uint8_t*)t->p + (long long)id * row_bytes,
                 (size_t)row_bytes, hipMemcpyDeviceToHost));
    std::vector<float> out((size_t)K);
    for (int b = 0; b < K / 32; b++) {
        const uint8_t* blk = raw.data() + (size_t)b * 34;
        uint16_t h; memcpy(&h, blk, 2);
        const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
        float d = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
        if (sg) d = -d;
        for (int i = 0; i < 32; i++)
            out[b * 32 + i] = d * (float)((const int8_t*)blk)[2 + i];
    }
    CK(hipMemcpy(dst, out.data(), (size_t)K * 4, hipMemcpyHostToDevice));
}

void embed_row(Mo35& m, int id) { embed_row_into(m, id, m.x); }

// MoE：路由 softmax + top-k → 逐专家 gate/up/down → 加权合并；再加共享专家（sigmoid 门）
// MoE 主体：可传任意层的权重视图（主干层 / MTP 层共用）
void moe_apply(Mo35& m, const Mo35::L& L, float* x, int il) {
    STEP("moe: rmsnorm");
    const Cfg35& c = m.cfg;
    const int H = c.hidden, MI = c.moe_inter, E = c.n_expert, TOP = c.top_k;
    const bool dump = il == 0 && m.seq_len == 0 && getenv("RT_Q36_DUMP");
    if (dump) {
        std::vector<float> h((size_t)H);
        CK(hipMemcpy(h.data(), x, (size_t)H * 4, hipMemcpyDeviceToHost));
        std::string p = std::string(getenv("RT_Q36_DUMP")) + ".moe_in.f32";
        FILE* fp = fopen(p.c_str(), "wb");
        if (fp) { fwrite(h.data(), 4, h.size(), fp); fclose(fp); }
    }
    k_rmsnorm(m.xb, x, (const float*)L.post_ln->p, 1, H, c.eps, false);

    // 路由（f32 [H,E]）→ 主机 top-k + 重归一
    lin_f32(m, m.router, L.ginp, m.xb);
    STEP("moe: router");
    lin_f32(m, m.shexp, L.gshexp, m.xb);              // 1 行 × H（输出必须是设备指针）
    float shexp_gate = 0.f;
    CK(hipMemcpy(&shexp_gate, m.shexp, 4, hipMemcpyDeviceToHost));
    std::vector<float> r((size_t)E);
    CK(hipMemcpy(r.data(), m.router, (size_t)E * 4, hipMemcpyDeviceToHost));
    {
        float mx = r[0];
        for (int i = 1; i < E; i++) mx = std::max(mx, r[i]);
        double sum = 0;
        for (int i = 0; i < E; i++) { r[i] = expf(r[i] - mx); sum += r[i]; }
        for (int i = 0; i < E; i++) r[i] = (float)(r[i] / sum);
    }
    std::vector<int> idx((size_t)E);
    for (int i = 0; i < E; i++) idx[i] = i;
    std::partial_sort(idx.begin(), idx.begin() + TOP, idx.end(),
                      [&](int a, int b) { return r[a] > r[b]; });
    double wsum = 0;
    for (int k = 0; k < TOP; k++) wsum += r[idx[k]];
    if (wsum <= 0) wsum = 1;

    k_fill(m.acc, 0.f, H);
#define TRACE_SYNC(tag) do { if (getenv("RT_Q36_TRACE")) { CK(hipDeviceSynchronize()); printf("  [trace] %s\n", tag); fflush(stdout); } } while (0)
    // 共享专家
    lin_q8(m, m.gbuf, L.sgate, m.xb);
    TRACE_SYNC("shexp gate ok");
    lin_q8(m, m.ubuf, L.sup, m.xb);
    k_silu_mul(m.gbuf, m.gbuf, m.ubuf, MI);
    lin_q8(m, m.dbuf, L.sdown, m.gbuf);
    TRACE_SYNC("shexp down ok");
    const float sg = 1.f / (1.f + expf(-shexp_gate));
    k_scale(m.dbuf, sg, H);
    k_add_inplace(m.acc, m.dbuf, H);
    // 前 TOP 个专家
    STEP("moe: experts");
    for (int k = 0; k < TOP; k++) {
        const int e = idx[k];
        const float we = (float)(r[e] / wsum);
        STEP("moe: expert gate");
        lin_q8(m, m.gbuf, L.gexp, m.xb, e);
        TRACE_SYNC("exp gate ok");
        STEP("moe: expert up");
        lin_q8(m, m.ubuf, L.uexp, m.xb, e);
        k_silu_mul(m.gbuf, m.gbuf, m.ubuf, MI);
        STEP("moe: expert down");
        lin_q8(m, m.dbuf, L.dexp, m.gbuf, e);
        TRACE_SYNC("exp down ok");
        k_scale(m.dbuf, we, H);
        k_add_inplace(m.acc, m.dbuf, H);
        TRACE_SYNC("exp acc ok");
    }
    k_add_inplace(x, m.acc, H);
    if (dump) {
        std::vector<float> h((size_t)H);
        CK(hipMemcpy(h.data(), x, (size_t)H * 4, hipMemcpyDeviceToHost));
        std::string p = std::string(getenv("RT_Q36_DUMP")) + ".moe_out.f32";
        FILE* fp = fopen(p.c_str(), "wb");
        if (fp) { fwrite(h.data(), 4, h.size(), fp); fclose(fp); }
    }
    TRACE_SYNC("moe final add ok");
}

void moe(Mo35& m, int il) { moe_apply(m, m.Ls[il], m.x, il); }

// BF16 → f32 设备副本（blk.40 的路由矩阵是 BF16）
const DevTensor* bf16_to_f32_dev(Weights35& w, const std::string& name) {
    const DevTensor* t = need(w, name);
    const int n = (int)t->nelem();
    std::vector<uint16_t> raw((size_t)n);
    CK(hipMemcpy(raw.data(), t->p, (size_t)n * 2, hipMemcpyDeviceToHost));
    std::vector<float> out((size_t)n);
    for (int i = 0; i < n; i++) {
        const uint32_t u = (uint32_t)raw[i] << 16;
        memcpy(&out[i], &u, 4);
    }
    float* d = nullptr;
    CK(hipMalloc(&d, (size_t)n * 4));
    CK(hipMemcpy(d, out.data(), (size_t)n * 4, hipMemcpyHostToDevice));
    DevTensor nd;
    nd.p = d; nd.type = 0; nd.nbytes = (long long)n * 4; nd.dims = t->dims;
    w.t[name + ".f32"] = nd;
    return &w.t[name + ".f32"];
}

// MTP 头（blk.40）
void bind_mtp(Mo35& m) {
    Weights35& w = m.w;
    MtpW& t = m.mtp;
    if (!w.find("blk.40.attn_norm.weight")) {
        printf("没有 blk.40（MTP 头），跳过\n");
        return;
    }
    char b[256];
    auto nm = [&](const char* s) { snprintf(b, sizeof(b), "blk.40.%s", s); return std::string(b); };
    t.in_ln = need(w, nm("attn_norm.weight"));
    t.post_ln = need(w, nm("post_attention_norm.weight"));
    t.q = need(w, nm("attn_q.weight"));
    t.k = need(w, nm("attn_k.weight"));
    t.v = need(w, nm("attn_v.weight"));
    t.o = need(w, nm("attn_output.weight"));
    t.qnorm = need(w, nm("attn_q_norm.weight"));
    t.knorm = need(w, nm("attn_k_norm.weight"));
    t.eh = need(w, nm("nextn.eh_proj.weight"));
    t.enorm = need(w, nm("nextn.enorm.weight"));
    t.hnorm = need(w, nm("nextn.hnorm.weight"));
    t.shnorm = need(w, nm("nextn.shared_head_norm.weight"));
    t.ginp = bf16_to_f32_dev(w, nm("ffn_gate_inp.weight"));
    t.gshexp = bf16_to_f32_dev(w, nm("ffn_gate_inp_shexp.weight"));
    t.gexp = need(w, nm("ffn_gate_exps.weight"));
    t.uexp = need(w, nm("ffn_up_exps.weight"));
    t.dexp = need(w, nm("ffn_down_exps.weight"));
    t.sgate = need(w, nm("ffn_gate_shexp.weight"));
    t.sup = need(w, nm("ffn_up_shexp.weight"));
    t.sdown = need(w, nm("ffn_down_shexp.weight"));
    const Cfg35& c = m.cfg;
    const int KV = c.n_kv, D = c.head_dim;
    t.kc = m.alloc_u32(KV * m.max_ctx * (D / KVEL));
    t.ksc = m.alloc(KV * 2 * m.max_ctx);
    t.vc = m.alloc_u32(KV * (m.max_ctx / KVEL) * D);
    t.vsc = m.alloc(KV * (m.max_ctx / 64) * D);
    t.vstage = m.alloc(KV * 64 * D);
    t.e = m.alloc(c.hidden);
    t.hn = m.alloc(c.hidden);
    t.cat = m.alloc(2 * c.hidden);
    t.x = m.alloc(c.hidden);
    t.bound = true;
    printf("MTP 头就绪（blk.40）\n");
}

// 全注意力层（每 4 层一个）：q 带 gate、q/k 各自 RMSNorm、部分 RoPE、int8 KV + FA
void attn_full(Mo35& m, int il) {
    STEP("attn_full");
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int H = c.n_head, KV = c.n_kv, D = c.head_dim, Hd = c.hidden;
    const int qd = H * D, pd = qd * 2;
    const bool dump = il == 3 && m.seq_len <= 1 && getenv("RT_Q36_DUMP");
    auto dumpf = [&](const char* tag, const float* p, int n) {
        if (!dump) return;
        std::vector<float> h((size_t)n);
        CK(hipMemcpy(h.data(), p, (size_t)n * 4, hipMemcpyDeviceToHost));
        std::string path = std::string(getenv("RT_Q36_DUMP")) + "." + tag + ".f32";
        FILE* fp = fopen(path.c_str(), "wb");
        if (fp) { fwrite(h.data(), 4, h.size(), fp); fclose(fp); }
    };
    k_rmsnorm(m.xb, m.x, (const float*)L.in_ln->p, 1, Hd, c.eps, false);
    lin_q8(m, m.qfull, L.q, m.xb);
    lin_q8(m, m.hkk, L.k, m.xb);
    lin_q8(m, m.hvv, L.v, m.xb);
    k_gather_heads(m.hq, m.qfull, 1, H, D, pd, 0, 2 * D);
    k_gather_heads(m.hgate, m.qfull, 1, H, D, pd, D, 2 * D);
    dumpf("l3_xb", m.xb, Hd);
    dumpf("l3_qfull", m.qfull, pd);
    dumpf("l3_hkk_pre", m.hkk, KV * D);
    dumpf("l3_hvv", m.hvv, KV * D);
    dumpf("l3_hq_pre", m.hq, qd);
    dumpf("l3_hgate", m.hgate, qd);
    // 注意：Qwen3.6(qwen35moe) 的 q/k norm 是**标准 RMSNorm**（权重均值≈1.3，
    // 与 27B/Qwen3.5 的 zero-centered 写法不同，27B 那份均值≈0.23 才用 (1+w)）
    k_rmsnorm(m.hq, m.hq, (const float*)L.qnorm->p, H, D, c.eps, false);
    k_rmsnorm(m.hkk, m.hkk, (const float*)L.knorm->p, KV, D, c.eps, false);
    {
        char tag[64];
        snprintf(tag, sizeof(tag), "l3_s%d_hq_prerope", m.seq_len);
        dumpf(tag, m.hq, qd);
        snprintf(tag, sizeof(tag), "l3_s%d_hk_prerope", m.seq_len);
        dumpf(tag, m.hkk, KV * D);
    }
    k_rope(m.hq, m.hkk, nullptr, m.seq_len, 1, 1, H, KV, D, c.rot, c.rope_theta);
    k_scale(m.hq, 1.f / sqrtf((float)D), (long long)qd);
    k_attn_q_quant(m.qq, m.qs, m.hq, 1, H, D, 128, m.TP);
    k_kv_append_k(m.kc[il], m.ksc[il], m.hkk, m.seq_len, 1, KV, D, 128, m.max_ctx);
    k_kv_append_v(m.vc[il], m.vsc[il], m.vstage[il], m.hvv, m.seq_len, 1, KV, D, 64,
                  m.max_ctx);
    const int n_kv = m.seq_len + 1;
    k_attention(m.hfa, m.qq, m.qs, m.kc[il], m.ksc[il], m.vc[il], m.vsc[il],
                m.TP, 1, n_kv, m.seq_len, (n_kv + 63) / 64, H, H / KV, m.max_ctx,
                m.pout, m.pmax, m.psum, 8);
    {
        char tag[64];
        snprintf(tag, sizeof(tag), "l3_s%d_hfa", m.seq_len);
        dumpf(tag, m.hfa, H * m.TP * D);
        snprintf(tag, sizeof(tag), "l3_s%d_hq_rope", m.seq_len);
        dumpf(tag, m.hq, qd);
        snprintf(tag, sizeof(tag), "l3_s%d_hkk_rope", m.seq_len);
        dumpf(tag, m.hkk, KV * D);
        snprintf(tag, sizeof(tag), "l3_s%d_hvv", m.seq_len);
        dumpf(tag, m.hvv, KV * D);
    }
    k_scatter_heads(m.hout, m.hfa, 1, H, D, qd, 0, m.TP);
    k_sigmoid_mul(m.hout, m.hout, m.hgate, qd);
    lin_q8(m, m.tmp, L.o, m.hout);
    k_add_inplace(m.x, m.tmp, Hd);
}

// 线性注意力层（gated delta net）
void attn_lin(Mo35& m, int il) {
    STEP("attn_lin: qkv/z");
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int Hd = c.hidden, Hk = c.lk_head, Hv = c.lv_head, D = c.ldim;
    const int qn = Hk * D, vn = Hv * D, C = qn * 2 + vn, K = c.conv_k;
    const bool dump = il == 0 && m.seq_len == 0 && getenv("RT_Q36_DUMP");
    auto dumpf = [&](const char* tag, const float* p, int n) {
        if (!dump) return;
        std::vector<float> h((size_t)n);
        CK(hipMemcpy(h.data(), p, (size_t)n * 4, hipMemcpyDeviceToHost));
        std::string path = std::string(getenv("RT_Q36_DUMP")) + "." + tag + ".f32";
        FILE* fp = fopen(path.c_str(), "wb");
        if (fp) { fwrite(h.data(), 4, h.size(), fp); fclose(fp); }
    };
    k_rmsnorm(m.xb, m.x, (const float*)L.in_ln->p, 1, Hd, c.eps, false);
    lin_q8(m, m.qkv3, L.qkv, m.xb);
    lin_q8(m, m.z_, L.z, m.xb);
    dumpf("l0_xb", m.xb, Hd);
    dumpf("l0_qkv", m.qkv3, C);
    dumpf("l0_z", m.z_, vn);
    STEP("attn_lin: conv");
    CK(hipMemcpyAsync(m.conv_prev, m.conv_state[il], (size_t)(K - 1) * C * 4,
                      hipMemcpyDeviceToDevice, 0));
    k_conv1d_silu(m.conv, m.qkv3, (const float*)L.conv->p, m.conv_prev, 1, C, K);
    k_conv_state_update(m.conv_state[il], m.qkv3, m.conv_prev, 1, C, K);
    k_split_qkv(m.gq, m.gk, m.gv, m.conv, 1, qn, qn, vn);
    STEP("attn_lin: l2norm/ssm");
    k_l2norm(m.gq, Hk, D, c.eps);
    k_l2norm(m.gk, Hk, D, c.eps);
    k_ssm_ab_gate(m.gab, m.gbeta, m.gg, L.alpha, L.beta, m.xb,
                  (const float*)L.dtb->p, (const float*)L.alog->p, 1, Hv, Hd);
    k_gdn(m.hout, m.gq, m.gk, m.gv, m.gg, m.gbeta, m.ssm_state[il],
          1, Hk, Hv, D, Hv / Hk);
    dumpf("l0_conv", m.conv, C);
    dumpf("l0_gq", m.gq, qn);
    dumpf("l0_gk", m.gk, qn);
    dumpf("l0_gv", m.gv, vn);
    dumpf("l0_gab", m.gab, 2 * Hv);
    dumpf("l0_gbeta", m.gbeta, Hv);
    dumpf("l0_gg", m.gg, Hv);
    dumpf("l0_gdn", m.hout, vn);
    STEP("attn_lin: out");
    k_rmsnorm_gated(m.hout, m.hout, (const float*)L.snorm->p, m.z_, Hv, D, c.eps);
    dumpf("l0_gnorm", m.hout, vn);
    lin_q8(m, m.tmp, L.sout, m.hout);
    dumpf("l0_out", m.tmp, Hd);
    k_add_inplace(m.x, m.tmp, Hd);
}

// MTP 草稿：输入「刚生成的 token + 主模型该位置的 hidden」，输出下一个 token 的草稿
// ======================= 批量校验前向（M = K+1 ≤ 4 行）=======================
// 关键技巧：q8_0_dot_k 的「专家组」参数可以把「行号」编进块号，
// 于是 M 行的线性层只读一遍权重 —— 这是投机解码能加速的根本。
uint32_t* ids_zero4() {
    static uint32_t* p = nullptr;
    if (!p) {
        CK(hipMalloc(&p, 16));
        uint32_t z[4] = {0, 0, 0, 0};
        CK(hipMemcpy(p, z, 16, hipMemcpyHostToDevice));
    }
    return p;
}

// y[M][N] = x[M][K] · W[N][K]^T
void linear_q8_rows(Mo35& m, float* y, const DevTensor* t, const float* x, int M,
                    int expert = -1) {
    const int K = (int)t->dims[0];
    const int N = t->dims.size() > 1 ? (int)t->dims[1] : 1;
    auto it8 = m.w8.find(t);
    if (it8 != m.w8.end() && M <= 4) {
        const long long rowoff = expert >= 0 ? (long long)expert * N : 0;
        lin_w8(y, it8->second, x, M, N, rowoff, m.tmp8);
        return;
    }
    const int nbpr = K / 32;
    const void* p = t->p;
    if (expert >= 0 && t->dims.size() > 2)
        p = (const uint8_t*)p + (long long)expert * N * nbpr * 34;
    k_q8_dot(p, x, m.partial, M * N * nbpr, nbpr, N, ids_zero4(), 0u, N);
    k_reduce(m.partial, y, M * N, nbpr);
}

// 专家批量：[M][TOP] 个输出行，x 每行被 TOP 个输出行共用
void linear_q8_experts(Mo35& m, float* y, const DevTensor* t, const float* x, int M,
                       int TOP, int rpe_x) {
    const int K = (int)t->dims[0];
    const int N = (int)t->dims[1];
    const int nbpr = K / 32;
    const long long estr = (long long)N * nbpr * 34;
    const int total = M * TOP * N;
    k_q8_dot(t->p, x, m.partial, total * nbpr, nbpr, rpe_x, m.ids_exp, (uint32_t)estr, N);
    k_reduce(m.partial, y, total, nbpr);
}

// MoE：逐行路由 + 批量专家（权重只读一遍）
void moe_apply_rows(Mo35& m, const Mo35::L& L, float* x, int M) {
    const Cfg35& c = m.cfg;
    const int H = c.hidden, MI = c.moe_inter, E = c.n_expert, TOP = c.top_k;
    k_rmsnorm(m.xbr, x, (const float*)L.post_ln->p, M, H, c.eps, false);
    for (int r = 0; r < M; r++) {
        lin_f32(m, m.router_r + (size_t)r * E, L.ginp, m.xbr + (size_t)r * H);
        lin_f32(m, m.shexp_r + r, L.gshexp, m.xbr + (size_t)r * H);
    }
    std::vector<float> rout((size_t)M * E), sgate((size_t)M);
    CK(hipMemcpy(rout.data(), m.router_r, rout.size() * 4, hipMemcpyDeviceToHost));
    CK(hipMemcpy(sgate.data(), m.shexp_r, sgate.size() * 4, hipMemcpyDeviceToHost));
    std::vector<uint32_t> ids((size_t)M * TOP);
    std::vector<float> wts((size_t)M * TOP);
    for (int r = 0; r < M; r++) {
        float* row = rout.data() + (size_t)r * E;
        float mx = row[0];
        for (int i = 1; i < E; i++) mx = std::max(mx, row[i]);
        double sum = 0;
        for (int i = 0; i < E; i++) { row[i] = expf(row[i] - mx); sum += row[i]; }
        std::vector<int> idx((size_t)E);
        for (int i = 0; i < E; i++) idx[i] = i;
        std::partial_sort(idx.begin(), idx.begin() + TOP, idx.end(),
                          [&](int a, int b) { return row[a] > row[b]; });
        double ws = 0;
        for (int k = 0; k < TOP; k++) ws += row[idx[k]];
        if (ws <= 0) ws = 1;
        for (int k = 0; k < TOP; k++) {
            ids[(size_t)r * TOP + k] = (uint32_t)idx[k];
            wts[(size_t)r * TOP + k] = (float)(row[idx[k]] / ws);
        }
    }
    CK(hipMemcpy(m.ids_exp, ids.data(), ids.size() * 4, hipMemcpyHostToDevice));
    // 共享专家（批量）
    linear_q8_rows(m, m.g_r, L.sgate, m.xbr, M);
    linear_q8_rows(m, m.u_r, L.sup, m.xbr, M);
    k_silu_mul(m.g_r, m.g_r, m.u_r, M * MI);
    linear_q8_rows(m, m.tmp_r, L.sdown, m.g_r, M);
    // 专家（批量：M*TOP 行一次算完）
    linear_q8_experts(m, m.g_r, L.gexp, m.xbr, M, TOP, TOP * MI);
    linear_q8_experts(m, m.u_r, L.uexp, m.xbr, M, TOP, TOP * MI);
    k_silu_mul(m.g_r, m.g_r, m.u_r, M * TOP * MI);
    linear_q8_experts(m, m.d_r, L.dexp, m.g_r, M, TOP, H);
    // 加权合并（主机侧，M*TOP*H 只有 4*8*2048 个数）
    std::vector<float> dr((size_t)M * TOP * H), sd((size_t)M * H);
    CK(hipMemcpy(dr.data(), m.d_r, dr.size() * 4, hipMemcpyDeviceToHost));
    CK(hipMemcpy(sd.data(), m.tmp_r, sd.size() * 4, hipMemcpyDeviceToHost));
    std::vector<float> acc((size_t)M * H);
    for (int r = 0; r < M; r++) {
        const float sg = 1.f / (1.f + expf(-sgate[r]));
        for (int d = 0; d < H; d++) {
            double v = sg * (double)sd[(size_t)r * H + d];
            for (int k = 0; k < TOP; k++)
                v += (double)wts[(size_t)r * TOP + k] * dr[((size_t)r * TOP + k) * H + d];
            acc[(size_t)r * H + d] = (float)v;
        }
    }
    CK(hipMemcpy(m.acc_r, acc.data(), acc.size() * 4, hipMemcpyHostToDevice));
    k_add_inplace(x, m.acc_r, M * H);
}

void moe_rows(Mo35& m, int il, int M) { moe_apply_rows(m, m.Ls[il], m.xr, M); }

// 全注意力（M 行）
void attn_full_rows(Mo35& m, int il, int M, int pos0) {
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int Hn = c.n_head, KV = c.n_kv, D = c.head_dim, Hd = c.hidden;
    const int qd = Hn * D, pd = qd * 2;
    const int TP = ((M + 63) / 64) * 64;
    k_rmsnorm(m.xbr, m.xr, (const float*)L.in_ln->p, M, Hd, c.eps, false);
    linear_q8_rows(m, m.qfull_r, L.q, m.xbr, M);
    linear_q8_rows(m, m.hkk_r, L.k, m.xbr, M);
    linear_q8_rows(m, m.hvv_r, L.v, m.xbr, M);
    k_gather_heads(m.hq_r, m.qfull_r, M, Hn, D, pd, 0, 2 * D);
    k_gather_heads(m.hgate_r, m.qfull_r, M, Hn, D, pd, D, 2 * D);
    k_rmsnorm(m.hq_r, m.hq_r, (const float*)L.qnorm->p, M * Hn, D, c.eps, false);
    k_rmsnorm(m.hkk_r, m.hkk_r, (const float*)L.knorm->p, M * KV, D, c.eps, false);
    k_rope(m.hq_r, m.hkk_r, nullptr, pos0, M, M, Hn, KV, D, c.rot, c.rope_theta);
    k_scale(m.hq_r, 1.f / sqrtf((float)D), (long long)M * qd);
    k_attn_q_quant(m.qq, m.qs, m.hq_r, M, Hn, D, 128, TP);
    k_kv_append_k(m.kc[il], m.ksc[il], m.hkk_r, pos0, M, KV, D, 128, m.max_ctx);
    k_kv_append_v(m.vc[il], m.vsc[il], m.vstage[il], m.hvv_r, pos0, M, KV, D, 64, m.max_ctx);
    const int n_kv = pos0 + M;
    k_attention(m.hfa, m.qq, m.qs, m.kc[il], m.ksc[il], m.vc[il], m.vsc[il],
                TP, M, n_kv, pos0, (n_kv + 63) / 64, Hn, Hn / KV, m.max_ctx,
                m.pout, m.pmax, m.psum, 8);
    k_scatter_heads(m.hout_r, m.hfa, M, Hn, D, qd, 0, TP);
    k_sigmoid_mul(m.hout_r, m.hout_r, m.hgate_r, M * qd);
    linear_q8_rows(m, m.tmp_r, L.o, m.hout_r, M);
    k_add_inplace(m.xr, m.tmp_r, M * Hd);
}

// 线性注意力（M 行）
void attn_lin_rows(Mo35& m, int il, int M, int pos0, bool snap = true) {
    (void)pos0;
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int Hd = c.hidden, Hk = c.lk_head, Hv = c.lv_head, D = c.ldim;
    const int qn = Hk * D, vn = Hv * D, C = qn * 2 + vn, K = c.conv_k;
    k_rmsnorm(m.xbr, m.xr, (const float*)L.in_ln->p, M, Hd, c.eps, false);
    linear_q8_rows(m, m.qkv_r, L.qkv, m.xbr, M);
    linear_q8_rows(m, m.z_r, L.z, m.xbr, M);
    CK(hipMemcpyAsync(m.convprev_r, m.conv_state[il], (size_t)(K - 1) * C * 4,
                      hipMemcpyDeviceToDevice, 0));
    k_conv1d_silu(m.conv_r, m.qkv_r, (const float*)L.conv->p, m.convprev_r, M, C, K);
    if (snap) {
        k_conv_state_update_snap(m.conv_state[il], m.snap_list_conv[il], m.qkv_r,
                                 m.convprev_r, M, C, K);
    } else {
        k_conv_state_update(m.conv_state[il], m.qkv_r, m.convprev_r, M, C, K);
    }
    k_split_qkv(m.gq_r, m.gk_r, m.gv_r, m.conv_r, M, qn, qn, vn);
    k_l2norm(m.gq_r, M * Hk, D, c.eps);
    k_l2norm(m.gk_r, M * Hk, D, c.eps);
    k_ssm_ab_gate(m.gab_r, m.gbeta_r, m.gg_r, L.alpha, L.beta, m.xbr,
                  (const float*)L.dtb->p, (const float*)L.alog->p, M, Hv, Hd);
    if (snap) {
        k_gdn_snap(m.hout_r, m.gq_r, m.gk_r, m.gv_r, m.gg_r, m.gbeta_r,
                   m.ssm_state[il], m.snap_list_ssm[il], M, Hk, Hv, D, Hv / Hk);
    } else {
        k_gdn(m.hout_r, m.gq_r, m.gk_r, m.gv_r, m.gg_r, m.gbeta_r, m.ssm_state[il],
              M, Hk, Hv, D, Hv / Hk);
    }
    k_rmsnorm_gated(m.hout_r, m.hout_r, (const float*)L.snorm->p, m.z_r, M * Hv, D, c.eps);
    linear_q8_rows(m, m.tmp_r, L.sout, m.hout_r, M);
    k_add_inplace(m.xr, m.tmp_r, M * Hd);
}

// 批量前向：ids[M] → 每行 logits 的 argmax（m.d_arg）
void forward_rows(Mo35& m, const int* ids, int M, int pos0) {
    const Cfg35& c = m.cfg;
    for (int r = 0; r < M; r++) embed_row_into(m, ids[r], m.xr + (size_t)r * c.hidden);
    for (int il = 0; il < c.n_layer; il++) {
        if (c.is_full(il)) attn_full_rows(m, il, M, pos0);
        else               attn_lin_rows(m, il, M, pos0);
        moe_rows(m, il, M);
    }
    for (int r = 0; r < M; r++) {
        k_rmsnorm(m.xbr, m.xr + (size_t)r * c.hidden, (const float*)m.fnorm->p, 1,
                  c.hidden, c.eps, false);
        lin_q8(m, m.logits, m.lmhead, m.xbr);
        int* d1 = m.d_arg + r;
        k_argmax(m.logits, c.vocab, d1);
    }
    CK(hipDeviceSynchronize());
}

void reset_states(Mo35& m) {
    for (int il = 0; il < m.cfg.n_layer; il++) {
        if (m.cfg.is_full(il)) {
            CK(hipMemset(m.kc[il], 0, (size_t)m.cfg.n_kv * m.max_ctx *
                                       (m.cfg.head_dim / KVEL) * 4));
            CK(hipMemset(m.ksc[il], 0, (size_t)m.cfg.n_kv * 2 * m.max_ctx * 4));
            CK(hipMemset(m.vc[il], 0, (size_t)m.cfg.n_kv * (m.max_ctx / KVEL) *
                                       m.cfg.head_dim * 4));
            CK(hipMemset(m.vsc[il], 0, (size_t)m.cfg.n_kv * (m.max_ctx / 64) *
                                       m.cfg.head_dim * 4));
            CK(hipMemset(m.vstage[il], 0, (size_t)m.cfg.n_kv * 64 * m.cfg.head_dim * 4));
        } else {
            CK(hipMemset(m.conv_state[il], 0, (size_t)(m.cfg.conv_k - 1) *
                         (m.cfg.lk_head * 2 + m.cfg.lv_head) * m.cfg.ldim * 4));
            CK(hipMemset(m.ssm_state[il], 0, (size_t)m.cfg.lv_head * m.cfg.ldim *
                                              m.cfg.ldim * 4));
        }
    }
    if (m.mtp.bound) {
        CK(hipMemset(m.mtp.kc, 0, (size_t)m.cfg.n_kv * m.max_ctx *
                                  (m.cfg.head_dim / KVEL) * 4));
        CK(hipMemset(m.mtp.vc, 0, (size_t)m.cfg.n_kv * (m.max_ctx / KVEL) *
                                  m.cfg.head_dim * 4));
        m.mtp.len = 0;
    }
    m.seq_len = 0;
    m.mtp_try = m.mtp_hit = 0;
    m.draft = -1;
}

// 状态快照 / 回滚（投机被拒时用）
void rollback_states(Mo35& m, int j) {
    const Cfg35& c = m.cfg;
    const int C = (c.lk_head * 2 + c.lv_head) * c.ldim;
    const size_t conv_one = (size_t)(c.conv_k - 1) * C;
    const size_t ssm_one = (size_t)c.lv_head * c.ldim * c.ldim;
    for (int il = 0; il < c.n_layer; il++) {
        if (c.is_full(il)) continue;
        if (j > 0) {          // 逐 token 槽：第 j-1 个 token 之后的状态
            CK(hipMemcpy(m.conv_state[il], m.snap_list_conv[il] + (size_t)(j - 1) * conv_one,
                         conv_one * 4, hipMemcpyDeviceToDevice));
            CK(hipMemcpy(m.ssm_state[il], m.snap_list_ssm[il] + (size_t)(j - 1) * ssm_one,
                         ssm_one * 4, hipMemcpyDeviceToDevice));
        } else {              // 全部拒绝：回到批量前的快照
            CK(hipMemcpy(m.conv_state[il], m.snap_conv_A[il], conv_one * 4,
                         hipMemcpyDeviceToDevice));
            CK(hipMemcpy(m.ssm_state[il], m.snap_ssm_A[il], ssm_one * 4,
                         hipMemcpyDeviceToDevice));
        }
    }
}

void snap_states(Mo35& m, int M_rows) {
    (void)M_rows;
    const Cfg35& c = m.cfg;
    const int C = (c.lk_head * 2 + c.lv_head) * c.ldim;
    for (int il = 0; il < c.n_layer; il++) {
        if (c.is_full(il)) continue;
        CK(hipMemcpy(m.snap_conv_A[il], m.conv_state[il],
                     (size_t)(c.conv_k - 1) * C * 4, hipMemcpyDeviceToDevice));
        CK(hipMemcpy(m.snap_ssm_A[il], m.ssm_state[il],
                     (size_t)c.lv_head * c.ldim * c.ldim * 4, hipMemcpyDeviceToDevice));
    }
    if (m.mtp.bound)
        CK(hipMemcpy(m.snap_mtp_kc, m.mtp.kc, (size_t)c.n_kv * m.max_ctx *
                     (c.head_dim / KVEL) * 4, hipMemcpyDeviceToDevice));
}

void restore_states(Mo35& m) {
    const Cfg35& c = m.cfg;
    const int C = (c.lk_head * 2 + c.lv_head) * c.ldim;
    for (int il = 0; il < c.n_layer; il++) {
        if (c.is_full(il)) continue;
        CK(hipMemcpy(m.conv_state[il], m.snap_list_conv[il],
                     (size_t)(c.conv_k - 1) * C * 4, hipMemcpyDeviceToDevice));
        CK(hipMemcpy(m.ssm_state[il], m.snap_list_ssm[il],
                     (size_t)c.lv_head * c.ldim * c.ldim * 4, hipMemcpyDeviceToDevice));
    }
}

int mtp_draft(Mo35& m, int last_id, const float* hidden) {
    MtpW& t = m.mtp;
    if (!t.bound) return -1;
    const Cfg35& c = m.cfg;
    const int H = c.hidden, Hn = c.n_head, KV = c.n_kv, D = c.head_dim;
    const int qd = Hn * D, pd = qd * 2;
    embed_row_into(m, last_id, t.e);
    k_rmsnorm(t.e, t.e, (const float*)t.enorm->p, 1, H, c.eps, false);
    k_rmsnorm(t.hn, hidden, (const float*)t.hnorm->p, 1, H, c.eps, false);
    k_concat2(t.cat, t.e, t.hn, 1, H);
    lin_q8(m, t.x, t.eh, t.cat);
    // 一层全注意力（用 MTP 自己的 KV）
    k_rmsnorm(m.xb, t.x, (const float*)t.in_ln->p, 1, H, c.eps, false);
    lin_q8(m, m.qfull, t.q, m.xb);
    lin_q8(m, m.hkk, t.k, m.xb);
    lin_q8(m, m.hvv, t.v, m.xb);
    k_gather_heads(m.hq, m.qfull, 1, Hn, D, pd, 0, 2 * D);
    k_gather_heads(m.hgate, m.qfull, 1, Hn, D, pd, D, 2 * D);
    k_rmsnorm(m.hq, m.hq, (const float*)t.qnorm->p, Hn, D, c.eps, false);
    k_rmsnorm(m.hkk, m.hkk, (const float*)t.knorm->p, KV, D, c.eps, false);
    k_rope(m.hq, m.hkk, nullptr, t.len, 1, 1, Hn, KV, D, c.rot, c.rope_theta);
    k_scale(m.hq, 1.f / sqrtf((float)D), (long long)qd);
    k_attn_q_quant(m.qq, m.qs, m.hq, 1, Hn, D, 128, m.TP);
    k_kv_append_k(t.kc, t.ksc, m.hkk, t.len, 1, KV, D, 128, m.max_ctx);
    k_kv_append_v(t.vc, t.vsc, t.vstage, m.hvv, t.len, 1, KV, D, 64, m.max_ctx);
    const int n_kv = t.len + 1;
    k_attention(m.hfa, m.qq, m.qs, t.kc, t.ksc, t.vc, t.vsc, m.TP, 1, n_kv, t.len,
                (n_kv + 63) / 64, Hn, Hn / KV, m.max_ctx, m.pout, m.pmax, m.psum, 8);
    k_scatter_heads(m.hout, m.hfa, 1, Hn, D, qd, 0, m.TP);
    k_sigmoid_mul(m.hout, m.hout, m.hgate, qd);
    lin_q8(m, m.tmp, t.o, m.hout);
    k_add_inplace(t.x, m.tmp, H);
    // MoE（blk.40 的专家权重）
    Mo35::L Lm;
    Lm.post_ln = t.post_ln;
    Lm.ginp = t.ginp; Lm.gshexp = t.gshexp; Lm.gexp = t.gexp; Lm.uexp = t.uexp;
    Lm.dexp = t.dexp; Lm.sgate = t.sgate; Lm.sup = t.sup; Lm.sdown = t.sdown;
    moe_apply(m, Lm, t.x, -1);
    k_rmsnorm(m.xb, t.x, (const float*)t.shnorm->p, 1, H, c.eps, false);
    lin_q8(m, m.logits, m.lmhead, m.xb);
    int* d_best = nullptr;
    CK(hipMalloc(&d_best, 4));
    k_argmax(m.logits, c.vocab, d_best);
    CK(hipDeviceSynchronize());
    int id = -1;
    CK(hipMemcpy(&id, d_best, 4, hipMemcpyDeviceToHost));
    CK(hipFree(d_best));
    t.len++;
    return id;
}

int forward1(Mo35& m, int id);      // 声明（decode_step 先用到）

// MTP 链式草拟：K 步串行（第 i 步用上一轮的 MTP 隐藏态）
void mtp_chain(Mo35& m, int first_token, int K, int* out) {
    const float* h = m.h_last;
    int tok = first_token;
    for (int i = 0; i < K; i++) {
        out[i] = mtp_draft(m, tok, h);
        h = m.xb;                      // mtp_draft 末尾把 normed 输出留在 m.xb
        tok = out[i];
    }
}

// 投机解码一步：处理 cur，返回本轮产出的 token（1 ~ K+1 个）
// 不变量：返回后 KV 覆盖到「倒数第二个输出 token」的位置，最后一个待处理
std::vector<int> decode_step(Mo35& m, int cur, int K) {
    std::vector<int> out;
    m.spec_mode = true;                         // 草稿链由这里统一做
    const int pred = forward1(m, cur);          // KV 覆盖…位置 p；pred = p+1 的预测
    m.spec_mode = false;
    if (K <= 0 || !m.mtp.bound || !m.mtp_enabled) { out.push_back(pred); return out; }
    const int mtp_len0 = m.mtp.len;
    int drafts[4] = {0, 0, 0, 0};
    mtp_chain(m, cur, K, drafts);
    if (getenv("RT_Q36_SPEC"))
        fprintf(stderr, "  [spec] pred=%d draft0=%d（mtp.len=%d）\n", pred, drafts[0], mtp_len0);
    if (drafts[0] != pred) {                    // 第一个就拒：草稿全弃
        m.mtp.len = mtp_len0;
        out.push_back(pred);
        return out;
    }
    // 批量校验 drafts[0..K-1]（pos0 = m.seq_len = p+1）
    snap_states(m, K);
    forward_rows(m, drafts, K, m.seq_len);
    int arg[4] = {-1, -1, -1, -1};
    CK(hipMemcpy(arg, m.d_arg, (size_t)K * 4, hipMemcpyDeviceToHost));
    int j = 1;
    while (j < K && arg[j - 1] == drafts[j]) j++;
    const int next = arg[j - 1];                // 第 j 个草稿之后的修正/bonus token
    rollback_states(m, j);
    m.seq_len += j;                             // KV 现在覆盖到 p+j
    m.mtp.len = mtp_len0 + j;
    for (int i = 0; i < j; i++) out.push_back(drafts[i]);
    out.push_back(next);
    if (getenv("RT_Q36_SPEC"))
        fprintf(stderr, "  投机：草稿 %d 接受 %d → 本轮出 %zu token\\n", K, j, out.size());
    return out;
}

int forward1(Mo35& m, int id) {
    STEP("forward1: embed");
    const bool prof = getenv("RT_Q36_PROF") != nullptr;
    auto tick = std::chrono::steady_clock::now();
    auto it = m.emb_rows.find(m.seq_len);
    if (it != m.emb_rows.end()) {
        CK(hipMemcpy(m.x, m.emb_override.data() + (size_t)it->second * m.cfg.hidden,
                     (size_t)m.cfg.hidden * 4, hipMemcpyHostToDevice));
    } else {
        embed_row(m, id);
    }
    const char* dump_all = getenv("RT_Q36_DUMP_ALL");
    auto dumpx = [&](const char* fmt, int il) {
        if (!dump_all || m.seq_len != 0) return;
        std::vector<float> h((size_t)m.cfg.hidden);
        CK(hipMemcpy(h.data(), m.x, (size_t)m.cfg.hidden * 4, hipMemcpyDeviceToHost));
        char nm[256];
        snprintf(nm, sizeof(nm), fmt, dump_all, il);
        FILE* fp = fopen(nm, "wb");
        if (fp) { fwrite(h.data(), 4, h.size(), fp); fclose(fp); }
    };
    dumpx("%s/L%d_in.f32", 0);
    if (getenv("RT_Q36_STATS")) {
        static std::vector<float> h;
        h.resize(m.cfg.hidden);
        CK(hipMemcpy(h.data(), m.x, (size_t)m.cfg.hidden * 4, hipMemcpyDeviceToHost));
        double s = 0, mx = 0;
        for (float v : h) { s += (double)v * v; if (fabs(v) > mx) mx = fabs(v); }
        fprintf(stderr, "   EMB  rms=%.4f max=%.3f first=%.4f\n", sqrt(s / m.cfg.hidden), mx, h[0]);
    }
    if (prof) { m.prof.add(m.prof.embed, tick); tick = std::chrono::steady_clock::now(); }
    for (int il = 0; il < m.cfg.n_layer; il++) {
        if (m.cfg.is_full(il)) attn_full(m, il);
        else                   attn_lin(m, il);
        if (prof) { m.prof.add(m.prof.attn, tick); tick = std::chrono::steady_clock::now(); }
        TRACE_SYNC("attn ok");
        dumpx("%s/L%d_mix.f32", il);
        moe(m, il);
        if (prof) { m.prof.add(m.prof.moe, tick); tick = std::chrono::steady_clock::now(); }
        TRACE_SYNC("moe ok");
        dumpx("%s/L%d_out.f32", il);
        dumpx("%s/L%d_in.f32", il + 1);
        if (getenv("RT_Q36_STATS")) {          // 每层隐藏态 RMS / 极值（定位数值问题）
            static std::vector<float> h;
            h.resize(m.cfg.hidden);
            CK(hipMemcpy(h.data(), m.x, (size_t)m.cfg.hidden * 4, hipMemcpyDeviceToHost));
            double s = 0, mx = 0;
            for (float v : h) { s += (double)v * v; if (fabs(v) > mx) mx = fabs(v); }
            fprintf(stderr, "   L%-3d rms=%.4f max=%.3f first=%.4f\n", il,
                    sqrt(s / m.cfg.hidden), mx, h[0]);
        }
        if ((il + 1) % 10 == 0 || il == m.cfg.n_layer - 1)
            fprintf(stderr, "   层 %d/%d\n", il + 1, m.cfg.n_layer);
    }
    CK(hipMemcpy(m.h_last, m.x, (size_t)m.cfg.hidden * 4, hipMemcpyDeviceToDevice));
    if (m.mtp.bound && m.mtp_enabled && !m.spec_mode) m.draft = mtp_draft(m, id, m.x);
    k_rmsnorm(m.xb, m.x, (const float*)m.fnorm->p, 1, m.cfg.hidden, m.cfg.eps, false);
    TRACE_SYNC("final norm ok");
    lin_q8(m, m.logits, m.lmhead, m.xb);
    if (prof) { m.prof.add(m.prof.head, tick); m.prof.n++; }
    TRACE_SYNC("lm_head ok");
    int* d_best = nullptr;
    CK(hipMalloc(&d_best, 4));
    k_argmax(m.logits, m.cfg.vocab, d_best);
    CK(hipDeviceSynchronize());
    int best = -1;
    CK(hipMemcpy(&best, d_best, 4, hipMemcpyDeviceToHost));
    CK(hipFree(d_best));
    if (getenv("RT_Q36_TOPK")) {                 // 诊断：打印 top-k logits
        std::vector<float> lg((size_t)m.cfg.vocab);
        CK(hipMemcpy(lg.data(), m.logits, (size_t)m.cfg.vocab * 4, hipMemcpyDeviceToHost));
        std::vector<int> id((size_t)m.cfg.vocab);
        for (int i = 0; i < m.cfg.vocab; i++) id[i] = i;
        const int k = atoi(getenv("RT_Q36_TOPK"));
        std::partial_sort(id.begin(), id.begin() + k, id.end(),
                          [&](int a, int b) { return lg[a] > lg[b]; });
        fprintf(stderr, "  top%d:", k);
        for (int i = 0; i < k; i++) fprintf(stderr, " %d(%.2f)", id[i], lg[id[i]]);
        fprintf(stderr, "\n");
    }
    if (m.draft >= 0) { m.mtp_try++; if (m.draft == best) m.mtp_hit++; }
    m.seq_len++;
    return best;
}

}  // namespace

int run_moe35(int argc, char** argv) {
    std::string gguf_path;
    bool load_only = false;
    bool selftest = false;
    bool engine = false;
    int max_layers = getenv("RT_Q36_MAXLAYERS") ? atoi(getenv("RT_Q36_MAXLAYERS")) : -1;
    int gen_n = 0, mtp_n = 0, mtp_k = 3;
    bool check_rows = getenv("RT_Q36_CHECKROWS") != nullptr;
    std::vector<int> ids;
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        if (a == "--gguf" && i + 1 < argc) gguf_path = argv[++i];
        else if (a == "--model" && i + 1 < argc) {
            std::string v = argv[++i];
            if (v.size() > 5 && v.compare(v.size() - 5, 5, ".gguf") == 0) gguf_path = v;
        }
        else if (a == "--load-only") load_only = true;
        else if (a == "--q8-selftest") selftest = true;
        else if (a == "--engine") engine = true;
        else if (a == "--max-layers" && i + 1 < argc) max_layers = atoi(argv[++i]);
        else if (a == "--gen" && i + 1 < argc) gen_n = atoi(argv[++i]);
        else if (a == "--mtp" && i + 1 < argc) mtp_n = atoi(argv[++i]);
        else if (a == "--mtp-k" && i + 1 < argc) mtp_k = atoi(argv[++i]);
        else if (a == "--ids" && i + 1 < argc) {
            std::string s = argv[++i];
            for (size_t p = 0; p < s.size();) {
                size_t q = s.find(',', p);
                if (q == std::string::npos) q = s.size();
                ids.push_back(atoi(s.substr(p, q - p).c_str()));
                p = q + 1;
            }
        }
    }
    if (gguf_path.empty()) return usage();

    Gguf g;
    if (!g.open(gguf_path)) return 1;
    Cfg35 cfg = cfg_from_gguf(g);
    printf("qwen35moe: %d 层（%d 全注意力 + %d 线性注意力）+ %d MTP\n",
           cfg.n_layer, cfg.n_full(), cfg.n_layer - cfg.n_full(), cfg.mtp_layers);
    printf("  hidden=%d heads=%d/%d head_dim=%d vocab=%d\n",
           cfg.hidden, cfg.n_head, cfg.n_kv, cfg.head_dim, cfg.vocab);
    printf("  MoE: %d 专家 top-%d 中间维 %d（共享专家 %d）\n",
           cfg.n_expert, cfg.top_k, cfg.moe_inter, cfg.shexp_inter);
    printf("  SSM: key_heads=%d value_heads=%d dim=%d conv=%d rot=%d\n",
           cfg.lk_head, cfg.lv_head, cfg.ldim, cfg.conv_k, cfg.rot);

    struct stat st {};
    {
        FILE* f = fopen(gguf_path.c_str(), "rb");
        if (!f) return 1;
        fstat(fileno(f), &st);
        fclose(f);
    }
    if (selftest) {
        q8_selftest(g, (long long)st.st_size);
        f32_selftest(g, (long long)st.st_size);
        Weights35 w2;
        const GgufTensor* t = g.find("blk.0.ffn_gate_exps.weight");
        if (t && g.file_off(*t) + t->nbytes <= (long long)st.st_size) {
            DevTensor d;
            upload_tensor(g, *t, d, (long long)st.st_size);
            w2.t.emplace(t->name, std::move(d));
            expert_selftest(w2, 0);
            expert_selftest(w2, 255);
            const GgufTensor* tt = g.find("output.weight");
            if (tt && g.file_off(*tt) + tt->nbytes <= (long long)st.st_size) {
                DevTensor d2;
                upload_tensor(g, *tt, d2, (long long)st.st_size);
                Weights35 w3;
                w3.t.emplace(tt->name, std::move(d2));
                for (int n : {1024, 8192, 65536, 248320}) {
                    if (n > (int)tt->dims[1]) break;
                    big_gemv_test(w3, n);
                }
            }
        } else {
            printf("blk.0.ffn_gate_exps 还没下完，跳过专家自检\n");
        }
        return 0;
    }
    if (load_only) {
        // 只校验张量是否齐全（不占显存）
        for (auto& t : g.tensors)
            if (g.file_off(t) + t.nbytes > (long long)st.st_size) {
                printf("缺 %s（需要到 %lld，文件 %.2f GB）\n", t.name.c_str(),
                       g.file_off(t) + t.nbytes, st.st_size / 1e9);
                return 2;
            }
        printf("703+ 张量齐全，可以上卡\n");
        return 0;
    }

    // --max-layers N：只上卡前 N 层（+embed/head），用于边下边调试
    auto wanted = [&](const std::string& n) {
        if (max_layers < 0) return true;
        if (n.rfind("blk.", 0) != 0) return true;          // embed/output/norm
        const int il = atoi(n.c_str() + 4);
        return il < max_layers;
    };
    Mo35 m;
    long long done = 0;
    for (auto& t : g.tensors) {
        if (!wanted(t.name)) continue;
        DevTensor d;
        upload_tensor(g, t, d, (long long)st.st_size);
        m.w.total += d.nbytes;
        m.w.t.emplace(t.name, std::move(d));
        done++;
        if (done % 100 == 0)
            printf("  上卡 %lld 张量（%.1f GB）\n", done, m.w.total / 1e9);
    }
    printf("权重上卡完成：%zu 张量，%.2f GB（显存）\n", m.w.t.size(), m.w.total / 1e9);
    m.cfg = cfg;
    if (max_layers > 0 && max_layers < m.cfg.n_layer) {
        printf("（只跑前 %d 层，调试用）\n", max_layers);
        m.cfg.n_layer = max_layers;
    }
    bind(m);
    alloc_bufs(m);
    bind_mtp(m);
    m.mtp_k = std::max(1, std::min(3, mtp_k));
    if (mtp_n > 0) m.mtp_enabled = m.mtp.bound;
    {
        const char* env = getenv("RT_VISION_RT4");
        std::string vpath = env && *env ? env
            : std::string("models/Qwen3.6-35B-A3B/qwen36_vision.rt4");
        if (access(vpath.c_str(), R_OK) == 0) {
            m.vis.init(vpath, vpath + ".json");
            m.vision_on = true;
            fprintf(stderr, "视觉塔就绪（%s，投影维度 %d）\n", vpath.c_str(), m.vis.out_dim);
        } else {
            fprintf(stderr, "没有视觉权重 %s，图片功能关闭\n", vpath.c_str());
        }
    }
    if (engine) {
        // 引擎协议（serve.py / chat.py 用）：PREFILL / GEN / MTP / RESET / QUIT
        printf("READY\n");
        fflush(stdout);
        std::string line;
        int last = -1;
        while (std::getline(std::cin, line)) {
            std::string op = line, arg;
            const size_t sp = line.find(' ');
            if (sp != std::string::npos) { op = line.substr(0, sp); arg = line.substr(sp + 1); }
            if (op == "QUIT") break;
            if (op == "RESET") {
                reset_states(m);
                last = -1;
                printf("OK reset\n");                m.mtp.len = 0; m.mtp_try = m.mtp_hit = 0; m.draft = -1;
                printf("OK reset\n");
            } else if (op == "MTP") {
                const int k = atoi(arg.c_str());
                m.mtp_enabled = (k > 0 && m.mtp.bound);
                m.mtp_try = m.mtp_hit = 0;
                printf("OK mtp %d%s\n", m.mtp_enabled ? k : 0,
                       m.mtp.bound ? "" : " (无 MTP 权重)");
            } else if (op == "PREFILL" || op == "PREFILL_NR") {
                std::vector<int> ids2;
                for (size_t p = 0; p < arg.size();) {
                    size_t q = arg.find(',', p);
                    if (q == std::string::npos) q = arg.size();
                    ids2.push_back(atoi(arg.substr(p, q - p).c_str()));
                    p = q + 1;
                }
                const auto t0 = std::chrono::steady_clock::now();
                for (int id : ids2) last = forward1(m, id);
                const double ms = std::chrono::duration<double, std::milli>(
                                      std::chrono::steady_clock::now() - t0).count();
                printf("OK prefill total=%zu computed=%zu reused=0 mode=fresh ms=%.1f tps=%.1f\n",
                       ids2.size(), ids2.size(), ms,
                       ms > 0 ? ids2.size() * 1000.0 / ms : 0.0);
            } else if (op == "GEN") {
                int n = atoi(arg.c_str());
                if (n <= 0) n = 1;
                if (last < 0) { printf("ERR no logits\n"); fflush(stdout); continue; }
                for (int i = 0; i < n; i++) {
                    last = forward1(m, last);
                    printf("TOK %d\n", last);
                    fflush(stdout);
                }
                printf("END length=%d\n", n);
                if (m.mtp_try)
                    fprintf(stderr, "MTP 统计：草稿 %lld，命中 %lld（%.1f%%）\n",
                            m.mtp_try, m.mtp_hit, 100.0 * m.mtp_hit / m.mtp_try);
            } else if (op == "IMG_EMB") {
                // IMG_EMB <patch_file> <out_file> <gh> <gw>
                if (!m.vision_on) { printf("ERR vision not loaded\n"); fflush(stdout); continue; }
                std::vector<std::string> f;
                { size_t p = 0; while (p <= arg.size()) { size_t q = arg.find(' ', p);
                    if (q == std::string::npos) q = arg.size();
                    f.push_back(arg.substr(p, q - p)); p = q + 1; } }
                if (f.size() < 4) { printf("ERR IMG_EMB 参数不足\n"); fflush(stdout); continue; }
                const auto t0 = std::chrono::steady_clock::now();
                int ntok = 0;
                if (!m.vis.encode_file(f[0], f[1], ntok, atoi(f[2].c_str()), atoi(f[3].c_str()))) {
                    printf("ERR 视觉编码失败\n");
                } else {
                    const double ms = std::chrono::duration<double, std::milli>(
                                          std::chrono::steady_clock::now() - t0).count();
                    printf("OK image %d %.1f ms\n", ntok, ms);
                }
            } else if (op == "PREFILL_EMB") {
                // PREFILL_EMB <ids> <emb_file> <off:count,...>
                const size_t p1 = arg.find(' ');
                const size_t p2 = p1 == std::string::npos ? std::string::npos
                                                          : arg.find(' ', p1 + 1);
                if (p1 == std::string::npos || p2 == std::string::npos) {
                    printf("ERR usage PREFILL_EMB <ids> <emb_file> <off:count,...>\n");
                    fflush(stdout);
                    continue;
                }
                std::vector<int> ids2;
                for (size_t p = 0; p < p1;) {
                    size_t q = arg.find(',', p);
                    if (q == std::string::npos || q > p1) q = p1;
                    ids2.push_back(atoi(arg.substr(p, q - p).c_str()));
                    p = q + 1;
                }
                std::string embf = arg.substr(p1 + 1, p2 - p1 - 1);
                std::string spans = arg.substr(p2 + 1);
                m.emb_rows.clear();
                {
                    std::ifstream fi(embf, std::ios::binary | std::ios::ate);
                    if (!fi) { printf("ERR 打不开 embedding 文件\n"); fflush(stdout); continue; }
                    const size_t bytes = (size_t)fi.tellg();
                    fi.seekg(0);
                    m.emb_override.resize(bytes / 4);
                    fi.read((char*)m.emb_override.data(), bytes);
                }
                int pos = 0;
                for (size_t p = 0; p < spans.size();) {
                    size_t q = spans.find(',', p);
                    if (q == std::string::npos) q = spans.size();
                    const std::string sp = spans.substr(p, q - p);
                    const size_t c = sp.find(':');
                    const int off = atoi(sp.c_str());
                    const int cnt = c == std::string::npos ? 0 : atoi(sp.c_str() + c + 1);
                    for (int i = 0; i < cnt; i++) m.emb_rows[pos++] = off + i;
                    p = q + 1;
                }
                const auto t0 = std::chrono::steady_clock::now();
                for (int id : ids2) last = forward1(m, id);
                m.emb_rows.clear();
                const double ms = std::chrono::duration<double, std::milli>(
                                      std::chrono::steady_clock::now() - t0).count();
                printf("OK prefill total=%zu computed=%zu reused=0 mode=emb ms=%.1f tps=%.1f\n",
                       ids2.size(), ids2.size(), ms,
                       ms > 0 ? ids2.size() * 1000.0 / ms : 0.0);
            } else if (op == "STOP") {
                /* 忽略 */
            } else {
                printf("OK %s\n", op.c_str());
            }
            fflush(stdout);
        }
        return 0;
    }
    if (getenv("RT_Q36_LINCHK")) {
        // 同一张量、同一输入：Q8 路径 vs W8 路径
        const DevTensor* t = need(m.w, getenv("RT_Q36_LINCHK"));
        const int K = (int)t->dims[0], N = (int)t->dims[1];
        std::vector<float> x((size_t)K);
        for (int i = 0; i < K; i++) x[i] = (float)((i % 23) - 11) / 11.f;
        CK(hipMemcpy(m.xb, x.data(), (size_t)K * 4, hipMemcpyHostToDevice));
        fprintf(stderr, "LINCHK: t->p=%p xb=%p logits=%p partial=%p tmp8=%p\n",
                (const void*)t->p, (void*)m.xb, (void*)m.logits, (void*)m.partial,
                (void*)m.tmp8);
        std::vector<float> y8((size_t)N), yw((size_t)N);
        // Q8 路径（临时绕过 W8 表）
        {
            auto it = m.w8.find(t);
            W8 save;
            bool had = it != m.w8.end();
            if (had) { save = it->second; m.w8.erase(it); }
            lin_q8(m, m.logits, t, m.xb);
            CK(hipDeviceSynchronize());
            CK(hipMemcpy(y8.data(), m.logits, (size_t)N * 4, hipMemcpyDeviceToHost));
            if (had) m.w8[t] = save;
        }
        lin_q8(m, m.logits, t, m.xb);
        CK(hipDeviceSynchronize());
        CK(hipMemcpy(yw.data(), m.logits, (size_t)N * 4, hipMemcpyDeviceToHost));
        double mx = 0, err = 0;
        for (int i = 0; i < N; i++) { mx = std::max(mx, (double)fabsf(y8[i])); err = std::max(err, (double)fabsf(y8[i] - yw[i])); }
        printf("%s [N=%d,K=%d]  max|y|=%.4f  Q8 vs W8 max_abs=%.6f\n",
               getenv("RT_Q36_LINCHK"), N, K, mx, err);
        for (int i = 0; i < 4; i++) printf("   y8=%.5f yw=%.5f\n", y8[i], yw[i]);
        return 0;
    }
    if (getenv("RT_Q36_BENCH")) {
        const int it = atoi(getenv("RT_Q36_BENCH"));
        auto bench = [&](const char* tag, const DevTensor* t, int expert, float* out) {
            const int N = (int)t->dims[1], K = (int)t->dims[0];
            auto t0 = std::chrono::steady_clock::now();
            for (int i = 0; i < it; i++) lin_q8(m, out, t, m.xb, expert);
            CK(hipDeviceSynchronize());
            const double ms = std::chrono::duration<double, std::milli>(
                                  std::chrono::steady_clock::now() - t0).count() / it;
            printf("%-28s N=%-6d K=%-6d  %.1f µs/次  %.1f GB/s\n", tag, N, K, ms * 1000,
                   (double)N * K * 1.0625 / (ms / 1000) / 1e9);
        };
        auto t0 = std::chrono::steady_clock::now();
        for (int i = 0; i < it; i++) lin_f32(m, m.router, m.Ls[0].ginp, m.xb);
        CK(hipDeviceSynchronize());
        printf("%-28s N=%-6d K=%-6d  %.1f µs/次\n", "router(f32 256x2048)", 256, 2048,
               std::chrono::duration<double, std::milli>(
                   std::chrono::steady_clock::now() - t0).count() / it * 1000);
        bench("attn_qkv(8192x2048)", m.Ls[0].qkv, -1, m.qfull);
        bench("attn_q(8192x2048)", m.Ls[3].q, -1, m.qfull);
        bench("ssm_out(2048x4096)", m.Ls[0].sout, -1, m.tmp);
        bench("expert_gate(512x2048)", m.Ls[0].gexp, 0, m.gbuf);
        bench("expert_down(2048x512)", m.Ls[0].dexp, 0, m.dbuf);
        bench("lm_head(248320x2048)", m.lmhead, -1, m.logits);
        return 0;
    }
    if (check_rows) {
        const int M = (int)std::min<size_t>(ids.size(), 4);
        reset_states(m);
        forward_rows(m, ids.data(), M, 0);
        std::vector<int> bat(M);
        CK(hipMemcpy(bat.data(), m.d_arg, (size_t)M * 4, hipMemcpyDeviceToHost));
        reset_states(m);
        std::vector<int> seq(M);
        for (int r = 0; r < M; r++) seq[r] = forward1(m, ids[r]);
        int bad = 0;
        for (int r = 0; r < M; r++) {
            printf("  row %d: 批量=%d 逐token=%d %s\n", r, bat[r], seq[r],
                   bat[r] == seq[r] ? "✓" : "✗");
            if (bat[r] != seq[r]) bad++;
        }
        printf("批量校验对拍：%d/%d 一致\n", M - bad, M);
        return bad ? 1 : 0;
    }
    if (ids.empty()) return 0;
    printf("=== 前向 ===\n");
    int last = -1;
    for (size_t i = 0; i < ids.size(); i++) {
        const int64_t t0 = (int64_t)time(nullptr);
        last = forward1(m, ids[i]);
        fprintf(stderr, "  in=%d → next=%d（%.1fs，seq_len=%d）\n", ids[i], last,
                (double)((int64_t)time(nullptr) - t0), m.seq_len);
    }
    if (last >= 0) printf("TOKEN %d\n", last);
    fflush(stdout);
    {
        int produced = 0;
        while (produced < gen_n) {
            const auto t0 = std::chrono::steady_clock::now();
            std::vector<int> o = decode_step(m, last, m.mtp_enabled ? m.mtp_k : 0);
            const double ms = std::chrono::duration<double, std::milli>(
                                  std::chrono::steady_clock::now() - t0).count();
            for (int tk : o) {
                if (produced++ >= gen_n) break;
                printf("TOKEN %d\n", tk);
                fflush(stdout);
                last = tk;
            }
            fprintf(stderr, "  gen %d/%d，本轮 %zu token（%.0f ms，%.0f ms/token）\n",
                    produced, gen_n, o.size(), ms, ms / (double)o.size());
        }
    }
    if (m.mtp_try)
        fprintf(stderr, "MTP 统计：草稿 %lld，命中 %lld（%.1f%%）\n",
                m.mtp_try, m.mtp_hit, 100.0 * m.mtp_hit / m.mtp_try);
    m.prof.report();
    return 0;
}
