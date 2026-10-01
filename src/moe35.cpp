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

// Q8_0 权重视图（GGUF 里 ne0 = 连续维 = K，ne1 = N）
struct Q8W { const void* p = nullptr; int N = 0, K = 0; };

// y[N] = W[N][K] · x[K]（M=1，解码路径）
void linear_q8(float* y, const Q8W& w, const float* x, float* partial) {
    const int nbpr = w.K / 32;
    k_q8_dot(w.p, x, partial, w.N * nbpr, nbpr, w.N, ids_zero(), 0u, w.N);
    k_reduce(partial, y, w.N, nbpr);
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

}  // namespace

int run_moe35(int argc, char** argv) {
    std::string gguf_path;
    bool load_only = false;
    bool selftest = false;
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        if (a == "--gguf" && i + 1 < argc) gguf_path = argv[++i];
        else if (a == "--load-only") load_only = true;
        else if (a == "--q8-selftest") selftest = true;
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
    if (selftest) { q8_selftest(g, (long long)st.st_size); return 0; }
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

    Weights35 w;
    long long done = 0;
    for (auto& t : g.tensors) {
        DevTensor d;
        upload_tensor(g, t, d, (long long)st.st_size);
        w.total += d.nbytes;
        w.t.emplace(t.name, std::move(d));
        done++;
        if (done % 100 == 0)
            printf("  上卡 %lld/%zu 张量（%.1f GB）\n", done, g.tensors.size(), w.total / 1e9);
    }
    printf("权重上卡完成：%zu 张量，%.2f GB（显存）\n", w.t.size(), w.total / 1e9);
    return 0;
}
