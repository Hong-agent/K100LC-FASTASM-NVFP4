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
#include <hip/hip_runtime.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cstdint>
#include <algorithm>
#include <sys/stat.h>
#include <map>
#include <string>
#include <vector>

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
const DevTensor* need(Weights35& w, const std::string& n) {
    const DevTensor* t = w.find(n);
    if (!t) { printf("缺张量 %s\n", n.c_str()); exit(1); }
    return t;
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
        }
    }
    printf("权重绑定完成：%d 层\n", m.cfg.n_layer);
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
    printf("激活/KV 缓冲就绪（max_ctx=%d）\n", m.max_ctx);
}

// ------------------------------------------------------------------ 前向 ---
#define STEP(msg) do { if (getenv("RT_Q36_TRACE")) { printf("  [trace] %s\n", msg); fflush(stdout); } } while (0)
#define TRACE_SYNC(tag) do { if (getenv("RT_Q36_TRACE")) { CK(hipDeviceSynchronize()); printf("  [trace] %s\n", tag); fflush(stdout); } } while (0)

// Q8_0 线性层；expert >= 0 时按专家切片（第 3 维是专家数）
void lin_q8(Mo35& m, float* y, const DevTensor* t, const float* x, int expert = -1) {
    const int K = (int)t->dims[0];
    const int N = t->dims.size() > 1 ? (int)t->dims[1] : 1;
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

// 词表行：主机侧解 Q8_0 → x（token_embd [K=2048, V]）
void embed_row(Mo35& m, int id) {
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
    CK(hipMemcpy(m.x, out.data(), (size_t)K * 4, hipMemcpyHostToDevice));
}

// MoE：路由 softmax + top-k → 逐专家 gate/up/down → 加权合并；再加共享专家（sigmoid 门）
void moe(Mo35& m, int il) {
    STEP("moe: rmsnorm");
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int H = c.hidden, MI = c.moe_inter, E = c.n_expert, TOP = c.top_k;
    k_rmsnorm(m.xb, m.x, (const float*)L.post_ln->p, 1, H, c.eps, false);

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
    k_add_inplace(m.x, m.acc, H);
    TRACE_SYNC("moe final add ok");
}

// 全注意力层（每 4 层一个）：q 带 gate、q/k 各自 RMSNorm、部分 RoPE、int8 KV + FA
void attn_full(Mo35& m, int il) {
    STEP("attn_full");
    const Cfg35& c = m.cfg;
    Mo35::L& L = m.Ls[il];
    const int H = c.n_head, KV = c.n_kv, D = c.head_dim, Hd = c.hidden;
    const int qd = H * D, pd = qd * 2;
    k_rmsnorm(m.xb, m.x, (const float*)L.in_ln->p, 1, Hd, c.eps, false);
    lin_q8(m, m.qfull, L.q, m.xb);
    lin_q8(m, m.hkk, L.k, m.xb);
    lin_q8(m, m.hvv, L.v, m.xb);
    k_gather_heads(m.hq, m.qfull, 1, H, D, pd, 0, 2 * D);
    k_gather_heads(m.hgate, m.qfull, 1, H, D, pd, D, 2 * D);
    // 注意：Qwen3.6(qwen35moe) 的 q/k norm 是**标准 RMSNorm**（权重均值≈1.3，
    // 与 27B/Qwen3.5 的 zero-centered 写法不同，27B 那份均值≈0.23 才用 (1+w)）
    k_rmsnorm(m.hq, m.hq, (const float*)L.qnorm->p, H, D, c.eps, false);
    k_rmsnorm(m.hkk, m.hkk, (const float*)L.knorm->p, KV, D, c.eps, false);
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
    k_rmsnorm(m.xb, m.x, (const float*)L.in_ln->p, 1, Hd, c.eps, false);
    lin_q8(m, m.qkv3, L.qkv, m.xb);
    lin_q8(m, m.z_, L.z, m.xb);
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
    STEP("attn_lin: out");
    k_rmsnorm_gated(m.hout, m.hout, (const float*)L.snorm->p, m.z_, Hv, D, c.eps);
    lin_q8(m, m.tmp, L.sout, m.hout);
    k_add_inplace(m.x, m.tmp, Hd);
}

int forward1(Mo35& m, int id) {
    STEP("forward1: embed");
    embed_row(m, id);
    for (int il = 0; il < m.cfg.n_layer; il++) {
        if (m.cfg.is_full(il)) attn_full(m, il);
        else                   attn_lin(m, il);
        TRACE_SYNC("attn ok");
        moe(m, il);
        TRACE_SYNC("moe ok");
        if ((il + 1) % 10 == 0 || il == m.cfg.n_layer - 1)
            printf("   层 %d/%d\n", il + 1, m.cfg.n_layer);
    }
    k_rmsnorm(m.xb, m.x, (const float*)m.fnorm->p, 1, m.cfg.hidden, m.cfg.eps, false);
    TRACE_SYNC("final norm ok");
    lin_q8(m, m.logits, m.lmhead, m.xb);
    TRACE_SYNC("lm_head ok");
    int* d_best = nullptr;
    CK(hipMalloc(&d_best, 4));
    k_argmax(m.logits, m.cfg.vocab, d_best);
    CK(hipDeviceSynchronize());
    int best = -1;
    CK(hipMemcpy(&best, d_best, 4, hipMemcpyDeviceToHost));
    CK(hipFree(d_best));
    m.seq_len++;
    return best;
}

}  // namespace

int run_moe35(int argc, char** argv) {
    std::string gguf_path;
    bool load_only = false;
    bool selftest = false;
    int max_layers = -1, gen_n = 0;
    std::vector<int> ids;
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        if (a == "--gguf" && i + 1 < argc) gguf_path = argv[++i];
        else if (a == "--load-only") load_only = true;
        else if (a == "--q8-selftest") selftest = true;
        else if (a == "--max-layers" && i + 1 < argc) max_layers = atoi(argv[++i]);
        else if (a == "--gen" && i + 1 < argc) gen_n = atoi(argv[++i]);
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
    for (int i = 0; i < gen_n; i++) {
        const int64_t t0 = (int64_t)time(nullptr);
        last = forward1(m, last);
        printf("TOKEN %d\n", last);
        fflush(stdout);
        fprintf(stderr, "  gen %d → %d（%.1fs）\n", i, last,
                (double)((int64_t)time(nullptr) - t0));
    }
    return 0;
}
