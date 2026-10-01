// 视觉塔（RT4）：从 model.cpp 抽出来，供稠密 27B 与 Qwen3.6 MoE 两条路径共用。
// 需要包含者已经 include 了 kernels.h / vision_kernels.h / hip 运行时。
#pragma once
#ifndef CK
#define CK(x) do { hipError_t e_ = (x); if (e_ != hipSuccess) { \
    printf("HIP ERR %s @%d: %s\n", #x, __LINE__, hipGetErrorString(e_)); exit(1);} } while (0)
#endif
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

struct RT4Tensor {
    std::string name, kind;
    long long N, K, group, q_off, s_off, nbytes;
    // 设备侧的偏移差：紧凑上传时（跳过被 NVFP4 取代的 MLP 张量）设备布局不再等于
    // 文件布局，这里记 dev_off = q_off + d_delta，sptr 同样加这个差。
    long long d_delta = 0;
};
struct RT4 {
    // 本机宿主只有 ~7GB 内存，13.9GB 的权重必须 mmap（虚拟地址），不能整份读进来
    const uint8_t* map = nullptr;
    size_t map_size = 0;
    std::vector<RT4Tensor> tensors;
    std::map<std::string, int> index;
    uint8_t* dev = nullptr;                      // 设备上的整份权重
    size_t dev_size = 0;                         // 紧凑布局后的实际显存占用

    const RT4Tensor* find(const std::string& n) const {
        auto it = index.find(n);
        return it == index.end() ? nullptr : &tensors[it->second];
    }
    void load(const std::string& path, const std::string& json);
    void upload();                               // 同步整份拷贝（MTP / 视觉塔用）
    const uint8_t* dptr(const RT4Tensor* t) const { return dev + t->q_off + t->d_delta; }
    const u32* qptr(const RT4Tensor* t) const { return (const u32*)dptr(t); }
    const float* sptr(const RT4Tensor* t) const { return (const float*)(dev + t->s_off + t->d_delta); }
    const uint8_t* hptr(long long off) const { return map + off; }
};

// 把（十几 GB 的）权重文件映射进主机地址空间。
//
// 为什么要自己挑地址：内核默认会把这么大的映射放到 mmap 区的**顶部**（0x7fff…
// 附近），而载荷里的张量偏移可能有几个 GB —— base + off 一旦越过 47 位（一个
// 「非规范地址」，比如 0x8000_03xx_xxxx），CPU 一读就是 SIGSEGV。实测 .rp4 稍微
// 换个大小就会踩到（同一个张量前一天好好的，换包后就崩）。
// 这里显式给一个低位地址做提示，并校验「base + 长度」仍落在规范区间里。
inline void* map_weights(int fd, size_t n) {
    for (unsigned long long hint = 0x200000000000ULL; hint >= 0x1000000000ULL; hint >>= 1) {
        void* p = mmap((void*)hint, n, PROT_READ, MAP_PRIVATE, fd, 0);
        if (p != MAP_FAILED) {
            if ((unsigned long long)p + n <= 0x7FFFFFFFFFFFULL) return p;
            munmap(p, n);                      // 提示被忽略、还是落在高位 → 再试更低的
        }
    }
    void* p = mmap(nullptr, n, PROT_READ, MAP_PRIVATE, fd, 0);
    if (p == MAP_FAILED) { printf("mmap 权重大文件失败（%.2f GB）\n", n / 1e9); exit(1); }
    return p;
}

inline std::string read_file(const std::string& p) {
    std::ifstream f(p, std::ios::binary);
    if (!f) { printf("无法打开 %s\n", p.c_str()); exit(1); }
    return std::string((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
}

inline void RT4::load(const std::string& path, const std::string& json) {
    const std::string js = read_file(json);
    size_t p = 0;
    while ((p = js.find("\"name\": \"", p)) != std::string::npos) {
        const size_t q0 = p + 9, q1 = js.find('"', q0);
        const size_t obj_end = js.find('}', q1);
        const std::string obj = js.substr(q1, obj_end - q1);
        RT4Tensor t;
        t.name = js.substr(q0, q1 - q0);
        auto num = [&](const char* key, long long def) -> long long {
            size_t k = obj.find(key);
            return k == std::string::npos ? def : atoll(obj.c_str() + k + strlen(key));
        };
        size_t k = obj.find("\"kind\": \"");
        if (k != std::string::npos) t.kind = obj.substr(k + 9, obj.find('"', k + 9) - k - 9);
        t.N = num("\"shape\": [", 0);
        size_t comma = obj.find(',', obj.find("\"shape\": ["));
        t.K = comma == std::string::npos ? 1 : atoll(obj.c_str() + comma + 1);
        t.group = num("\"group\": ", 128);
        t.q_off = num("\"q_off\": ", 0);
        t.s_off = num("\"s_off\": ", 0);
        t.nbytes = num("\"nbytes\": ", 0);
        index[t.name] = (int)tensors.size();
        tensors.push_back(t);
        p = obj_end;
    }
    const int fd = open(path.c_str(), O_RDONLY);
    if (fd < 0) { printf("无法打开 %s\n", path.c_str()); exit(1); }
    struct stat st{};
    fstat(fd, &st);
    map_size = (size_t)st.st_size;
    map = (const uint8_t*)map_weights(fd, map_size);
    printf("RT4: %zu 张量, %.2f GB (mmap)\n", tensors.size(), map_size / 1e9);
}

inline void RT4::upload() {
    CK(hipMalloc(&dev, map_size));
    dev_size = map_size;
    // 分块拷贝：一整块 13.9GB 的 hipMemcpy 从 pageable mmap 出发容易失败/很慢
    const size_t CH = 256ull << 20;
    for (size_t off = 0; off < map_size; off += CH) {
        const size_t n = std::min(CH, map_size - off);
        CK(hipMemcpy(dev + off, map + off, n, hipMemcpyHostToDevice));
    }
}

// ============================== 视觉塔（RT4） ==============================
// 权重来自 tools/convert_vision_rt4.py：线性层默认 int4/128（N 补 64、K 补 128，
// W4A8：int4 权重 × int8 激活；--f16 可退回 f16），norm/bias/pos_embed 是 f32。
// 线性层直接复用文本运行时的 W4A8 GEMV / GEMM。
struct VisionModel {
    struct VW {
        const uint16_t* w = nullptr;   // f16 [N,K]
        const u32* q = nullptr;        // int4 [N,K/2]（低半字节 = 偶数 k）
        const uint16_t* s = nullptr;   // int4 行优先 f16 尺度 [N][K/group]
        float* s_gm = nullptr;         // int4 组优先 f32 尺度（GEMM 用）
        int N = 0, K = 0, group = 128;
        bool i4 = false;
    };
    struct VLayer {
        VW qkv, proj, fc1, fc2;
        const float *n1w = nullptr, *n1b = nullptr;
        const float *n2w = nullptr, *n2b = nullptr;
        const float *qkvb = nullptr, *projb = nullptr;
        const float *fc1b = nullptr, *fc2b = nullptr;
    };

    static constexpr int H = 1152, HEADS = 16, HD = 72;
    static constexpr int QKV = 3456, INTER = 4304, INTER_PAD = 4352;
    static constexpr int MERGE_IN = 4608;
    int out_dim = 5120;             // 视觉->文本的投影维度（27B=5120，Qwen3.6=2048）
    static constexpr int PATCH_DIM = 3 * 2 * 16 * 16;
    static constexpr int POS_N = 2304, POS_SIDE = 48, DEPTH = 27;

    RT4 rt;
    std::vector<VLayer> layers;
    // .rp4 模式：由调用方给一个「从 rp4 灌进 RT4 视图」的加载器（model.cpp 里是 rt4_from_rp4）
    const void* rp4_src = nullptr;
    void (*rp4_loader)(RT4&, const void*, uint8_t*) = nullptr;
    uint8_t* rp4_dev = nullptr;
    void init_from_rp4(const void* r, void (*loader)(RT4&, const void*, uint8_t*), uint8_t* dev) {
        rp4_src = r; rp4_loader = loader; rp4_dev = dev; init("", "");
    }
    VW patch_w, m_fc1, m_fc2;
    const float *patch_b = nullptr, *m_nw = nullptr, *m_nb = nullptr;
    const float *m_fc1b = nullptr, *m_fc2b = nullptr;
    const float* pos_host = nullptr;
    bool loaded = false;
    int max_patches = 0, Mpad = 0, MMpad = 0;
    std::vector<float*> dev_f32;

    float *d_patch = nullptr, *d_h = nullptr, *d_norm = nullptr, *d_qkv = nullptr;
    float *d_attn = nullptr, *d_mlp = nullptr, *d_tmp = nullptr, *d_pos = nullptr;
    float *d_cos = nullptr, *d_sin = nullptr, *d_merger = nullptr, *d_merger2 = nullptr;
    float *d_out = nullptr;

    // int4/W4A8 的激活量化暂存（按最大 K/N/patch 数预留，只分配一次）
    u32 *vaq_h = nullptr, *vaq_l = nullptr;
    float *vasc = nullptr, *vasc16 = nullptr, *vc_tmp = nullptr;
    int vk_max = 0, vn_max = 0;

    // pos/rope 表按 (gh,gw) 网格缓存：表内容只由网格决定（n=4*gh*gw 随之固定），
    // 同网格的图片直接复用设备上已上传的表 —— 主机重建 + 三次 H2D 全部省掉。
    // 上限 8 个网格，LRU 淘汰（淘汰只是删记录，设备缓冲会被新网格覆盖）。
    std::map<std::pair<int, int>, long long> grid_cache;
    long long grid_tick = 0;
    static constexpr int GRID_CACHE_MAX = 8;

    static int align128(int n) { return (n + 127) / 128 * 128; }

    static float h2f(uint16_t h) {
        const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
        const float f = ex == 0 ? ldexpf(ma / 1024.f, -14)
                                : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
        return sg ? -f : f;
    }

    VW W(const std::string& name) {
        const RT4Tensor* t = rt.find(name);
        if (!t) { printf("视觉权重缺失：%s\n", name.c_str()); exit(1); }
        VW w;
        w.N = (int)t->N;
        w.K = (int)t->K;
        w.group = (int)(t->group ? t->group : 128);
        if (t->kind == "i4") {
            w.i4 = true;
            w.q = rt.qptr(t);
            w.s = (const uint16_t*)rt.sptr(t);
        } else if (t->kind == "f16") {
            w.w = (const uint16_t*)rt.dptr(t);
        } else {
            printf("视觉权重 %s 的 kind=%s 不支持（需要 i4 或 f16）\n",
                   name.c_str(), t->kind.c_str());
            exit(1);
        }
        return w;
    }

    // int4 权重的组优先 f32 尺度（GEMM 用），布局与文本侧 make_group_major 相同。
    void make_gm(const std::string& name, VW& w) {
        if (!w.i4) return;
        const RT4Tensor* t = rt.find(name);
        const int ng = w.K / w.group;
        std::vector<float> out((size_t)w.N * ng);
        const uint16_t* s = (const uint16_t*)rt.hptr(t->s_off);
        for (int n = 0; n < w.N; n++)
            for (int g = 0; g < ng; g++)
                out[(size_t)g * w.N + n] = h2f(s[(size_t)n * ng + g]);
        CK(hipMalloc(&w.s_gm, out.size() * 4));
        CK(hipMemcpy(w.s_gm, out.data(), out.size() * 4, hipMemcpyHostToDevice));
        vk_max = std::max(vk_max, w.K);
        vn_max = std::max(vn_max, w.N);
    }

    const float* F(const std::string& name) {
        const RT4Tensor* t = rt.find(name);
        if (!t || t->kind != "f32") {
            printf("视觉张量缺失或不是 f32：%s\n", name.c_str());
            exit(1);
        }
        float* dev = nullptr;
        CK(hipMalloc(&dev, t->nbytes));
        CK(hipMemcpy(dev, rt.hptr(t->q_off), t->nbytes, hipMemcpyHostToDevice));
        dev_f32.push_back(dev);
        return dev;
    }

    void init(const std::string& path, const std::string& json) {
        if (rp4_src && rp4_loader) {       // .rp4 单文件模式：视觉塔也在那个文件里
            rp4_loader(rt, rp4_src, rp4_dev);
        } else {
            rt.load(path, json);
            rt.upload();
        }
        max_patches = getenv("RT_VISION_MAX_PATCHES")
                          ? atoi(getenv("RT_VISION_MAX_PATCHES")) : 4096;
        Mpad = align128(max_patches);
        MMpad = align128(max_patches / 4);
        layers.resize(DEPTH);
        patch_w = W("model.visual.patch_embed.proj.weight");
        patch_b = F("model.visual.patch_embed.proj.bias");
        const RT4Tensor* pe = rt.find("model.visual.pos_embed.weight");
        if (!pe || pe->kind != "f32" || pe->N != POS_N || pe->K != H) {
            printf("pos_embed 形状不对\n"); exit(1);
        }
        pos_host = (const float*)rt.hptr(pe->q_off);
        for (int il = 0; il < DEPTH; il++) {
            auto n = [&](const char* s) {
                char b[256]; snprintf(b, sizeof(b), "model.visual.blocks.%d.%s", il, s);
                return std::string(b);
            };
            VLayer& L = layers[il];
            L.qkv = W(n("attn.qkv.weight"));
            L.proj = W(n("attn.proj.weight"));
            L.fc1 = W(n("mlp.linear_fc1.weight"));
            L.fc2 = W(n("mlp.linear_fc2.weight"));
            make_gm(n("attn.qkv.weight"), L.qkv);
            make_gm(n("attn.proj.weight"), L.proj);
            make_gm(n("mlp.linear_fc1.weight"), L.fc1);
            make_gm(n("mlp.linear_fc2.weight"), L.fc2);
            L.n1w = F(n("norm1.weight")); L.n1b = F(n("norm1.bias"));
            L.n2w = F(n("norm2.weight")); L.n2b = F(n("norm2.bias"));
            L.qkvb = F(n("attn.qkv.bias")); L.projb = F(n("attn.proj.bias"));
            L.fc1b = F(n("mlp.linear_fc1.bias")); L.fc2b = F(n("mlp.linear_fc2.bias"));
        }
        m_fc1 = W("model.visual.merger.linear_fc1.weight");
        m_fc2 = W("model.visual.merger.linear_fc2.weight");
        out_dim = m_fc2.N;          // 由权重形状决定，不写死
        make_gm("model.visual.patch_embed.proj.weight", patch_w);
        make_gm("model.visual.merger.linear_fc1.weight", m_fc1);
        make_gm("model.visual.merger.linear_fc2.weight", m_fc2);
        m_nw = F("model.visual.merger.norm.weight");
        m_nb = F("model.visual.merger.norm.bias");
        m_fc1b = F("model.visual.merger.linear_fc1.bias");
        m_fc2b = F("model.visual.merger.linear_fc2.bias");

        CK(hipMalloc(&d_patch, (size_t)Mpad * PATCH_DIM * 4));
        CK(hipMalloc(&d_h, (size_t)Mpad * H * 4));
        CK(hipMalloc(&d_norm, (size_t)Mpad * H * 4));
        CK(hipMalloc(&d_qkv, (size_t)Mpad * QKV * 4));
        CK(hipMalloc(&d_attn, (size_t)Mpad * H * 4));
        CK(hipMalloc(&d_mlp, (size_t)Mpad * INTER_PAD * 4));
        CK(hipMalloc(&d_tmp, (size_t)Mpad * H * 4));
        CK(hipMalloc(&d_pos, (size_t)Mpad * H * 4));
        CK(hipMalloc(&d_cos, (size_t)Mpad * HD * 4));
        CK(hipMalloc(&d_sin, (size_t)Mpad * HD * 4));
        CK(hipMalloc(&d_merger, (size_t)MMpad * MERGE_IN * 4));
        CK(hipMalloc(&d_merger2, (size_t)MMpad * MERGE_IN * 4));
        CK(hipMalloc(&d_out, (size_t)MMpad * out_dim * 4));
        if (vk_max > 0) {
            // k_quant_rows_a8：每行 K/8 个 dword，尺度 [K/group][Mpad]（组优先）
            CK(hipMalloc(&vaq_h, (size_t)Mpad * (vk_max / 8) * 4));
            CK(hipMalloc(&vaq_l, (size_t)Mpad * (vk_max / 8) * 4));
            CK(hipMalloc(&vasc, (size_t)(vk_max / 128) * Mpad * 4));
            CK(hipMalloc(&vasc16, (size_t)(vk_max / 128) * Mpad * 4));
            CK(hipMalloc(&vc_tmp, (size_t)Mpad * vn_max * 4));
        }
        CK(hipMemset(d_patch, 0, (size_t)Mpad * PATCH_DIM * 4));
        CK(hipMemset(d_attn, 0, (size_t)Mpad * H * 4));
        CK(hipMemset(d_mlp, 0, (size_t)Mpad * INTER_PAD * 4));
        CK(hipMemset(d_merger, 0, (size_t)MMpad * MERGE_IN * 4));
        loaded = true;
        printf("视觉塔 RT4 就绪：%d 层，max_patches=%d\n", DEPTH, max_patches);
    }

    void linear(float* y, const VW& w, const float* x, int M) {
        linear_s(y, w, x, M, w.K);
    }

    void linear_s(float* y, const VW& w, const float* x, int M, int x_stride) {
        if (!w.i4) {
            k_vit_linear_f16(y, w.w, x, M, w.N, w.K, x_stride, w.N);
            return;
        }
        // int4 权重 × int8 激活（W4A8）：小 M 走 GEMV，整图 patch 走 GEMM。
        if (x_stride == 0) x_stride = w.K;
        if (M <= 4 && x_stride == w.K) {
            k_gemv_w4a8(y, w.q, (const float*)w.s, x, M, w.N, w.K);
            return;
        }
        const int Mp = align128(M);          // GEMM 的 M 必须是 128 的整数倍
        if (!w.s_gm) { printf("视觉 int4 权重组尺度未初始化\n"); exit(1); }
        k_quant_rows_a8(vaq_h, vaq_l, vasc, vasc16, x, Mp, w.K, w.group, x_stride);
        k_gemm_i4_a8(y, vc_tmp, w.q, w.s_gm, vaq_h, vaq_l, vasc, vasc16,
                     Mp, w.N, w.K);
    }

    void dump_dev(const char* tag, const float* p, int rows, int D) {
        if (!getenv("RT_VISION_DUMP")) return;
        std::vector<float> h((size_t)rows * D);
        CK(hipMemcpy(h.data(), p, h.size() * 4, hipMemcpyDeviceToHost));
        char path[256];
        snprintf(path, sizeof(path), "/tmp/vit_%s.f32", tag);
        FILE* f = fopen(path, "wb");
        if (!f) return;
        fwrite(h.data(), 4, h.size(), f);
        fclose(f);
        fprintf(stderr, "  dump %s [%d,%d]\n", path, rows, D);
    }

    static float lin_value(int i, int n) {
        return n <= 1 ? 0.f : (float)i * (POS_SIDE - 1) / (n - 1);
    }

    void make_pos(int h, int w, int n, std::vector<float>& out) {
        const int gh = h / 2, gw = w / 2;
        out.resize((size_t)n * H);
        for (int idx = 0; idx < n; idx++) {
            int rem = idx;
            const int mw = rem % 2; rem /= 2;
            const int mh = rem % 2; rem /= 2;
            const int gc = rem % gw; rem /= gw;
            const int gr = rem % gh;
            const int row = gr * 2 + mh;
            const int col = gc * 2 + mw;
            const float hf = lin_value(row, h);
            const float wf = lin_value(col, w);
            int h0 = (int)hf, w0 = (int)wf;
            int h1 = std::min(h0 + 1, POS_SIDE - 1), w1 = std::min(w0 + 1, POS_SIDE - 1);
            const float dh = hf - h0, dw = wf - w0;
            const float* p00 = pos_host + ((size_t)h0 * POS_SIDE + w0) * H;
            const float* p01 = pos_host + ((size_t)h0 * POS_SIDE + w1) * H;
            const float* p10 = pos_host + ((size_t)h1 * POS_SIDE + w0) * H;
            const float* p11 = pos_host + ((size_t)h1 * POS_SIDE + w1) * H;
            float* o = out.data() + (size_t)idx * H;
            for (int d = 0; d < H; d++)
                o[d] = (1 - dh) * (1 - dw) * p00[d] + (1 - dh) * dw * p01[d] +
                       dh * (1 - dw) * p10[d] + dh * dw * p11[d];
        }
    }

    void make_rope(int h, int w, int n, std::vector<float>& cos, std::vector<float>& sin) {
        const int maxhw = std::max(h, w);
        const int nf = 18;
        std::vector<float> inv(nf);
        for (int i = 0; i < nf; i++) inv[i] = 1.f / powf(10000.f, (2.f * i) / 36.f);
        cos.resize((size_t)n * HD);
        sin.resize((size_t)n * HD);
        // sincos 只依赖行号/列号（真正的自由度是 maxhw×nf，不是 n×nf）：
        // 预计算一张表，逐 token 退化成纯 gather —— 超越函数调用从 n×72 降到
        // maxhw×72（1024 patch 时约 30 倍），数值与逐 token 重算逐位一致。
        std::vector<float> ct((size_t)maxhw * nf), st((size_t)maxhw * nf);
        for (int j = 0; j < maxhw; j++)
            for (int i = 0; i < nf; i++) {
                const float a = j * inv[i];
                ct[(size_t)j * nf + i] = cosf(a);
                st[(size_t)j * nf + i] = sinf(a);
            }
        const int gw2 = w / 2;
        for (int idx = 0; idx < n; idx++) {
            int rem = idx;
            const int mw = rem % 2; rem /= 2;
            const int mh = rem % 2; rem /= 2;
            const int gc = rem % gw2; rem /= gw2;
            const int gr = rem;
            const int row = gr * 2 + mh, col = gc * 2 + mw;
            float* c = cos.data() + (size_t)idx * HD;
            float* s = sin.data() + (size_t)idx * HD;
            const float* crow = ct.data() + (size_t)row * nf;
            const float* srow = st.data() + (size_t)row * nf;
            const float* ccol = ct.data() + (size_t)col * nf;
            const float* scol = st.data() + (size_t)col * nf;
            for (int i = 0; i < nf; i++) {
                c[i] = crow[i]; s[i] = srow[i];
                c[nf + i] = ccol[i]; s[nf + i] = scol[i];
                c[2 * nf + i] = c[i]; s[2 * nf + i] = s[i];
                c[3 * nf + i] = c[nf + i]; s[3 * nf + i] = s[nf + i];
            }
        }
    }

    bool encode(const float* patches, int n, std::vector<float>& out, int& n_tokens,
                int gh, int gw) {
        if (!loaded || n <= 0 || n % 4 != 0) {
            printf("vision: 非法 patch 数 %d\n", n); return false;
        }
        if (n > max_patches) {
            printf("vision: patch 数 %d > max_patches %d\n", n, max_patches); return false;
        }
        const int Mp = align128(n);
        // 只清尾部 padding：[0,n) 马上被下面的 H2D 全量覆盖，[Mp,Mpad) 自构造期
        // memset 后从未被写过、恒为零。原版全量清 Mpad 是纯浪费。
        if (Mp > n)
            CK(hipMemset(d_patch + (size_t)n * PATCH_DIM, 0,
                         (size_t)(Mp - n) * PATCH_DIM * 4));
        CK(hipMemcpy(d_patch, patches, (size_t)n * PATCH_DIM * 4, hipMemcpyHostToDevice));
        linear(d_h, patch_w, d_patch, n);
        k_vit_bias_add(d_h, patch_b, n, H);
        // pos/rope 表按网格缓存（见 grid_cache 成员注释）。异常形状（n != 4*gh*gw，
        // 理论上不该出现）不走缓存，每次照旧重算 —— 行为与旧版一致。
        const bool cacheable = (n == 4 * gh * gw);
        const auto key = std::make_pair(gh, gw);
        auto it = grid_cache.find(key);
        if (cacheable && it != grid_cache.end()) {
            it->second = ++grid_tick;                 // 命中：设备上的表直接可用
        } else {
            std::vector<float> pos, cos, sin;
            make_pos(gh, gw, n, pos);
            make_rope(gh, gw, n, cos, sin);
            CK(hipMemcpy(d_pos, pos.data(), (size_t)n * H * 4, hipMemcpyHostToDevice));
            CK(hipMemcpy(d_cos, cos.data(), (size_t)n * HD * 4, hipMemcpyHostToDevice));
            CK(hipMemcpy(d_sin, sin.data(), (size_t)n * HD * 4, hipMemcpyHostToDevice));
            if (cacheable) {
                if ((int)grid_cache.size() >= GRID_CACHE_MAX) {   // LRU 淘汰最旧网格
                    auto old = std::min_element(
                        grid_cache.begin(), grid_cache.end(),
                        [](const std::pair<const std::pair<int, int>, long long>& a,
                           const std::pair<const std::pair<int, int>, long long>& b) {
                            return a.second < b.second;
                        });
                    grid_cache.erase(old);
                }
                grid_cache[key] = ++grid_tick;
            }
        }
        k_add_inplace(d_h, d_pos, (long long)n * H);
        dump_dev("h00", d_h, n, H);
        for (int il = 0; il < DEPTH; il++) {
            VLayer& L = layers[il];
            k_vit_layernorm(d_norm, d_h, L.n1w, L.n1b, n, H, 1e-6f);
            if (il == 0) dump_dev("l0_norm1", d_norm, n, H);
            linear(d_qkv, L.qkv, d_norm, n);
            k_vit_bias_add(d_qkv, L.qkvb, n, QKV);
            if (il == 0) dump_dev("l0_qkv", d_qkv, n, QKV);
            k_vit_rope(d_qkv, d_cos, d_sin, n, HEADS, HD, QKV);
            if (il == 0) dump_dev("l0_qkv_rope", d_qkv, n, QKV);
            k_vit_attention(d_attn, d_qkv, n, HEADS, HD, QKV, 1.f / sqrtf(72.f));
            if (il == 0) dump_dev("l0_attn", d_attn, n, H);
            linear(d_tmp, L.proj, d_attn, n);
            k_vit_bias_add(d_tmp, L.projb, n, H);
            k_add_inplace(d_h, d_tmp, (long long)n * H);
            if (il == 0) dump_dev("l0_res", d_h, n, H);
            k_vit_layernorm(d_norm, d_h, L.n2w, L.n2b, n, H, 1e-6f);
            if (il == 0) dump_dev("l0_norm2", d_norm, n, H);
            linear(d_mlp, L.fc1, d_norm, n);                 // [n, 4352]
            if (il == 0) dump_dev("l0_fc1", d_mlp, n, INTER_PAD);
            k_vit_bias_add_s(d_mlp, L.fc1b, n, INTER, INTER_PAD);  // 只加逻辑 4304 列
            k_vit_gelu(d_mlp, d_mlp, (long long)n * INTER_PAD, 0);
            if (il == 0) dump_dev("l0_gelu", d_mlp, n, INTER_PAD);
            linear_s(d_tmp, L.fc2, d_mlp, n, INTER_PAD);
            k_vit_bias_add(d_tmp, L.fc2b, n, H);
            k_add_inplace(d_h, d_tmp, (long long)n * H);
            if (il == 0) dump_dev("h01", d_h, n, H);
            if (il == 1) dump_dev("h02", d_h, n, H);
            if ((il + 1) % 9 == 0)
                fprintf(stderr, "  视觉层 %d/%d\n", il + 1, DEPTH);
        }
        k_vit_layernorm(d_norm, d_h, m_nw, m_nb, n, H, 1e-6f);
        n_tokens = n / 4;
        const int MMp = align128(n_tokens);
        CK(hipMemset(d_merger, 0, (size_t)MMpad * MERGE_IN * 4));
        CK(hipMemcpy(d_merger, d_norm, (size_t)n * H * 4, hipMemcpyDeviceToDevice));
        linear(d_merger2, m_fc1, d_merger, n_tokens);
        k_vit_bias_add(d_merger2, m_fc1b, n_tokens, MERGE_IN);
        k_vit_gelu(d_merger2, d_merger2, (long long)n_tokens * MERGE_IN, 1);
        linear(d_out, m_fc2, d_merger2, n_tokens);
        k_vit_bias_add(d_out, m_fc2b, n_tokens, out_dim);
        out.resize((size_t)n_tokens * out_dim);
        CK(hipMemcpy(out.data(), d_out, out.size() * 4, hipMemcpyDeviceToHost));
        dump_dev("hemb", d_out, n_tokens, out_dim);
        return true;
    }

    bool encode_file(const std::string& patch_path, const std::string& out_path,
                     int& n_tokens, int gh, int gw) {
        std::ifstream f(patch_path, std::ios::binary);
        if (!f) { printf("无法打开 patch 文件 %s\n", patch_path.c_str()); return false; }
        f.seekg(0, std::ios::end);
        const size_t bytes = (size_t)f.tellg();
        f.seekg(0, std::ios::beg);
        if (bytes == 0 || bytes % (PATCH_DIM * 4)) {
            printf("patch 文件大小不对 %zu\n", bytes); return false;
        }
        const int n = (int)(bytes / (PATCH_DIM * 4));
        std::vector<float> patches(bytes / 4);
        f.read((char*)patches.data(), bytes);
        std::vector<float> out;
        if (!encode(patches.data(), n, out, n_tokens, gh, gw)) return false;
        std::ofstream o(out_path, std::ios::binary);
        if (!o) { printf("无法写 embedding 文件 %s\n", out_path.c_str()); return false; }
        o.write((const char*)out.data(), out.size() * 4);
        return true;
    }
};
