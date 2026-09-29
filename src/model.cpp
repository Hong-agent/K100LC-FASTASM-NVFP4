// 自研运行时：RT4 权重 → 全模型前向（Qwen3.8-27B，混合 SSM + 注意力）
//
// 结构（与 HF transformers/models/qwen3_5/modeling_qwen3_5.py 逐行对齐）：
//   每层：x += mixer(rmsnorm(x, input_ln, 零中心))；x += mlp(rmsnorm(x, post_attn_ln))
//   mixer 两种：
//     full_attention（每 4 层一个）：q_proj → [q, gate] 交错 → q/k 各自 RMSNorm(256)
//       → 部分 RoPE(前 64 维) → int4 FlashAttention → * sigmoid(gate) → o_proj
//     linear_attention（其余）：in_proj_qkv → 因果卷积(核 4)+SiLU → q/k 各头 L2 归一
//       → gated delta net 递推 → 门控 RMSNorm(乘 silu(z)) → out_proj
//
// 用法：
//   rt --model <rt4文件> --json <manifest> --ids 1,2,3        # 前向 + 打印 top-k
//   rt --model ... --ids ... --dump out.bin --dump-layers 0,3 # 导出中间激活做对照
#include "kernels.h"
#include "vision_kernels.h"
#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cmath>
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <poll.h>
#include <unistd.h>
#include <fstream>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <chrono>
#include <algorithm>
#include <sstream>
#include <set>
#include "prefetch.h"

#define BM_ALIGN 128
#define CK(x) do { hipError_t e_ = (x); if (e_ != hipSuccess) { \
    printf("HIP ERR %s @%d: %s\n", #x, __LINE__, hipGetErrorString(e_)); exit(1);} } while (0)

// 解码注意力 split-KV 的段数上限：长上下文时提高它可让每个 block 串行处理的 tile 更少。
// RT_MAXSPLIT 可覆盖（1..32）；默认 8，保持与现有 DTK 产物一致。
static int fa_max_split() {
    static const int v = [] {
        const char* e = getenv("RT_MAXSPLIT");
        int n = e ? atoi(e) : 8;
        if (n < 1) n = 1;
        if (n > 32) n = 32;
        return n;
    }();
    return v;
}

// =========================== 分阶段计时（RT_PROF=1） ========================
// 用途：回答「这一步到底把时间花在哪」。默认全关（一次 getenv 之外零开销）。
// 实现：每个作用域在进入/退出时各记一个 hipEvent（同一条流上按程序顺序记录），
// **中途不同步**（同步会抽干流水线、把小内核的时间放大好几倍），最后只同步一次，
// 再按「相邻事件时间戳之差」把时间归到当时最内层的作用域。这样得到的是各段
// GPU 真实占用时间，加总是整步墙钟。
enum {
    P_EMBED = 0, P_NORM, P_LINEAR, P_FA, P_KV, P_GDN, P_HEAD, P_COPY, P_SAMPLE,
    P_CONV, P_SSM, P_GDNA, P_GNORM, P_ATTNPRE, P_QK, P_MTP, P_MTPD, P_NCAT,
};
static const char* P_NAME[P_NCAT] = {
    "embed", "norm/elem", "linear", "flash-attn", "kv/quant", "gdn", "head", "logits-copy",
    "sample", "gdn-conv", "gdn-ssm", "gdn-recur", "gdn-norm", "attn-pre", "kv-quant", "mtp",
    "mtp-draft",
};

#define PROF_POOL 65536
static hipEvent_t g_prof_ev[PROF_POOL];
static int g_prof_next = 0;
static bool g_prof_init = false;
// 时间轴：(类别, 事件)。类别 <0 表示「作用域结束」。
static std::vector<std::pair<int, hipEvent_t>> g_prof_tl;

struct ProfTick {
    int cat = -1;
    bool on = false;
    explicit ProfTick(int c) : cat(c) {
        if (cat < 0) return;
        if (!g_prof_init) { for (int k = 0; k < PROF_POOL; k++) hipEventCreate(&g_prof_ev[k]); g_prof_init = true; }
        if (g_prof_next + 1 >= PROF_POOL) return;          // 池子不够就放弃这段（不会发生）
        on = true;
        const hipEvent_t e = g_prof_ev[g_prof_next++];
        hipEventRecord(e, 0);
        g_prof_tl.push_back({cat, e});
    }
    ~ProfTick() {
        if (!on) return;
        const hipEvent_t e = g_prof_ev[g_prof_next++];
        hipEventRecord(e, 0);
        g_prof_tl.push_back({-1 - cat, e});
    }
};

// 把时间轴折叠成每类目的毫秒数（在最后一个事件处同步一次）。
static void prof_fold(double* acc) {
    if (g_prof_tl.empty()) return;
    hipEventSynchronize(g_prof_tl.back().second);
    std::vector<int> stack;
    for (size_t k = 0; k + 1 < g_prof_tl.size(); k++) {
        const int cat = g_prof_tl[k].first;
        if (cat >= 0) stack.push_back(cat); else if (!stack.empty()) stack.pop_back();
        if (stack.empty()) continue;
        float ms = 0.f;
        if (hipEventElapsedTime(&ms, g_prof_tl[k].second, g_prof_tl[k + 1].second) == hipSuccess)
            acc[stack.back()] += ms;
    }
    g_prof_tl.clear();
    g_prof_next = 0;
}


// ============================== 配置 =======================================
struct Cfg {
    int hidden = 5120, n_layer = 64, n_head = 24, n_kv = 4, head_dim = 256;
    int inter = 17408, vocab = 248320;
    int lk_head = 16, lv_head = 48, ldim = 128, conv_k = 4;
    float eps = 1e-6f, rope_theta = 1e7f;
    int rot = 64;                    // partial_rotary_factor 0.25 × 256
    int full_interval = 4;
    bool is_full(int il) const { return (il + 1) % full_interval == 0; }
};

// ============================== RT4 加载 ===================================
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

static std::string read_file(const std::string& p) {
    std::ifstream f(p, std::ios::binary);
    if (!f) { printf("无法打开 %s\n", p.c_str()); exit(1); }
    return std::string((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
}

void RT4::load(const std::string& path, const std::string& json) {
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
    map = (const uint8_t*)mmap(nullptr, map_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (map == MAP_FAILED) { printf("mmap 失败 %s\n", path.c_str()); exit(1); }
    printf("RT4: %zu 张量, %.2f GB (mmap)\n", tensors.size(), map_size / 1e9);
}

void RT4::upload() {
    CK(hipMalloc(&dev, map_size));
    dev_size = map_size;
    // 分块拷贝：一整块 13.9GB 的 hipMemcpy 从 pageable mmap 出发容易失败/很慢
    const size_t CH = 256ull << 20;
    for (size_t off = 0; off < map_size; off += CH) {
        const size_t n = std::min(CH, map_size - off);
        CK(hipMemcpy(dev + off, map + off, n, hipMemcpyHostToDevice));
    }
}

// ==================== 紧凑布局 + 按层分组的后台预取 ====================
// 两个作用：
//   1) 跳过被 NVFP4 取代的那些 MLP 张量 —— 它们一个字节都不会被读到，
//      但原来 dev 是按整文件大小分配的，白占 7.5GB 显存、白读 7.5GB 磁盘。
//   2) 把剩下的张量按「前向顺序」分组交给 Prefetch，加载和计算就能重叠。
static int tensor_group(const std::string& n) {
    const size_t p = n.find(".layers.");
    if (p != std::string::npos) return 1 + atoi(n.c_str() + p + 8);   // 第 il 层 -> 组 il+1
    if (n.find("embed_tokens") != std::string::npos) return 0;
    if (n.find("language_model.norm") != std::string::npos) return 0;
    return 66;                       // lm_head / MTP / 视觉塔：最后
}

static void plan_upload(RT4& rt, Prefetch& pf, int file, const std::set<std::string>& skip) {
    std::vector<RT4Tensor*> keep;
    size_t skipped = 0;
    for (auto& t : rt.tensors) {
        if (skip.count(t.name)) { skipped += (size_t)t.nbytes; continue; }
        keep.push_back(&t);
    }
    std::sort(keep.begin(), keep.end(),
              [](const RT4Tensor* a, const RT4Tensor* b) { return a->q_off < b->q_off; });

    // RT_COMPACT=0 只用于排查：退回「整份分配、只跳过拷贝」的老布局
    if (getenv("RT_COMPACT") && atoi(getenv("RT_COMPACT")) == 0) {
        rt.dev_size = rt.map_size;
        CK(hipMalloc(&rt.dev, rt.dev_size));
        std::vector<std::pair<int, RT4Tensor*>> o;
        for (RT4Tensor* t : keep) o.push_back({tensor_group(t->name), t});
        std::stable_sort(o.begin(), o.end(),
                         [](const auto& a, const auto& b) { return a.first < b.first; });
        for (auto& kv : o)
            pf.add(file, (size_t)kv.second->q_off, rt.dev + kv.second->q_off,
                   (size_t)kv.second->nbytes, kv.first);
        printf("RT4: 非紧凑布局 %.2f GB（跳过 %.2f GB 的拷贝）\n",
               rt.dev_size / 1e9, skipped / 1e9);
        return;
    }

    // 1) 紧凑排布
    std::vector<std::pair<int, std::pair<RT4Tensor*, size_t>>> plan;
    size_t off = 0;
    for (RT4Tensor* t : keep) {
        off = (off + 255) & ~(size_t)255;
        plan.push_back({tensor_group(t->name), {t, off}});
        off += (size_t)t->nbytes;
    }
    rt.dev_size = off;
    CK(hipMalloc(&rt.dev, rt.dev_size ? rt.dev_size : 1));

    // 2) 按组排序后登记预取（组小的先加载）
    std::stable_sort(plan.begin(), plan.end(),
                     [](const auto& a, const auto& b) { return a.first < b.first; });
    for (auto& [grp, tv] : plan) {
        RT4Tensor* t = tv.first;
        t->d_delta = (long long)tv.second - t->q_off;
        pf.add(file, (size_t)t->q_off, rt.dev + tv.second, (size_t)t->nbytes, grp);
    }
    printf("RT4: 紧凑布局 %zu 张量，%.2f GB（跳过 %.2f GB 被 NVFP4 取代的 MLP）\n",
           keep.size(), rt.dev_size / 1e9, skipped / 1e9);
}

// ==================== 打包文件模式 ====================
// ==================== .rp4 单文件模式 ====================
// tools/rp4_pack.py 把主模型（去掉被 NVFP4 取代的 MLP）、NVFP4 权重、MTP 头、
// 视觉塔全部装进一个自包含文件：64 字节头 + 索引 TSV + 按加载顺序排好的载荷。
// 运行时只需要这一个文件：读头、读索引、从头到尾顺序读载荷。
//
//   载荷偏移 == 设备偏移 == 索引里的 off
//
// 所以每个 RT4 张量的 q_off/s_off 直接用索引值，d_delta 保持 0；
// hptr()（主机侧 mmap）也落在同一个载荷基底上。
struct Rp4Row {
    std::string type, part, name, kind;
    int N = 0, K = 0, group = 0;
    size_t off = 0, bytes = 0, soff = 0;
    float gscale = 1.f;
};
struct Rp4 {
    std::string path;
    size_t index_off = 0, index_len = 0, data_off = 0, data_len = 0, count = 0;
    std::vector<Rp4Row> rows;
    std::vector<uint8_t> index_buf;      // 索引文本要一直留着给解析用
    const uint8_t* map = nullptr;        // mmap 出来的文件
    size_t map_size = 0;
    uint8_t* dev = nullptr;              // 一份设备缓冲，三部分共用
    bool ok = false;
};

static bool rp4_open(Rp4& r, const std::string& path) {
    const int fd = open(path.c_str(), O_RDONLY);
    if (fd < 0) return false;
    struct stat st{};
    fstat(fd, &st);
    char hdr[64];
    if (pread(fd, hdr, 64, 0) != 64 || memcmp(hdr, "K100RP4\0", 8)) {
        printf("%s 不是 .rp4（magic 不符）\n", path.c_str());
        close(fd);
        return false;
    }
    uint32_t ver = 0, flags = 0;
    memcpy(&ver, hdr + 8, 4);
    memcpy(&flags, hdr + 12, 4);
    if (ver != 1) { printf(".rp4 版本 %u 不认识\n", ver); close(fd); return false; }
    memcpy(&r.index_off, hdr + 16, 8);
    memcpy(&r.index_len, hdr + 24, 8);
    memcpy(&r.data_off, hdr + 32, 8);
    memcpy(&r.data_len, hdr + 40, 8);
    memcpy(&r.count, hdr + 48, 8);
    r.path = path;
    r.index_buf.resize(r.index_len);
    if (pread(fd, r.index_buf.data(), r.index_len, (off_t)r.index_off) != (ssize_t)r.index_len) {
        printf(".rp4 索引读取失败\n"); close(fd); return false;
    }
    // 解析索引（TSV）
    std::string text(r.index_buf.begin(), r.index_buf.end());
    std::istringstream is(text);
    std::string line;
    while (std::getline(is, line)) {
        if (line.empty() || line[0] == '#') continue;
        std::istringstream ss(line);
        Rp4Row row;
        ss >> row.type >> row.part >> row.name >> row.kind
           >> row.N >> row.K >> row.group >> row.off >> row.bytes >> row.soff >> row.gscale;
        if (!ss) { printf(".rp4 索引行解析失败: %s\n", line.c_str()); close(fd); return false; }
        r.rows.push_back(row);
    }
    // mmap 出来给主机侧读（prep_gm 的尺度、F() 的 f16/f32）
    r.map = (const uint8_t*)mmap(nullptr, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (r.map == MAP_FAILED) { printf(".rp4 mmap 失败\n"); close(fd); return false; }
    r.map_size = st.st_size;
    close(fd);
    r.ok = true;
    return true;
}

// 把某个 part 的张量灌进一个 RT4 视图：map/dev 都指向 .rp4 的载荷基底
static void rt4_from_rp4(RT4& rt, const Rp4& r, const char* part, uint8_t* dev) {
    for (const Rp4Row& row : r.rows) {
        if (row.part != part || row.type != "t") continue;
        RT4Tensor t;
        t.name = row.name;
        t.kind = row.kind;
        t.N = row.N; t.K = row.K; t.group = row.group;
        t.q_off = (long long)row.off;
        t.s_off = (long long)row.soff;
        t.nbytes = (long long)row.bytes;
        t.d_delta = 0;                       // 索引里的 off 已经是设备偏移
        rt.index[t.name] = (int)rt.tensors.size();
        rt.tensors.push_back(t);
    }
    rt.map = r.map + r.data_off;
    rt.map_size = r.data_len;
    rt.dev = dev;
    rt.dev_size = r.data_len;
}

// tools/nvfp4_pack.py 把「运行时要用到的全部权重」按前向顺序拼成一个连续文件，
// 文件偏移 == 设备偏移。加载于是退化成一次顺序读 + 顺序拷，运行时也不用再算布局。
struct PackRow { std::string type, name; size_t off, bytes; int group; };

static std::vector<PackRow> read_pack_index(const std::string& path) {
    std::vector<PackRow> rows;
    std::ifstream f(path);
    if (!f) return rows;
    std::string line;
    while (std::getline(f, line)) {
        if (line.empty() || line[0] == '#') continue;
        std::istringstream ss(line);
        PackRow r;
        ss >> r.type >> r.name >> r.off >> r.bytes >> r.group;
        if (!ss) continue;
        rows.push_back(r);
    }
    return rows;
}

static void plan_upload_packed(RT4& rt, Prefetch& pf, int file, const std::vector<PackRow>& rows,
                               std::map<std::string, size_t>& rt4_off,
                               std::map<std::string, size_t>& nvp_off,
                               std::map<std::string, size_t>& nvs_off) {
    size_t total = 0;
    std::map<int, std::pair<size_t, size_t>> grp;          // group -> [begin, end)
    for (const PackRow& r : rows) {
        total = std::max(total, r.off + r.bytes);
        auto it = grp.find(r.group);
        if (it == grp.end()) grp[r.group] = {r.off, r.off + r.bytes};
        else it->second.second = std::max(it->second.second, r.off + r.bytes);
        if (r.type == "rt4") rt4_off[r.name] = r.off;
        else if (r.type == "nvp") nvp_off[r.name] = r.off;
        else if (r.type == "nvs") nvs_off[r.name] = r.off;
    }
    rt.dev_size = total;
    CK(hipMalloc(&rt.dev, total ? total : 1));
    for (RT4Tensor& t : rt.tensors) {
        auto it = rt4_off.find(t.name);
        t.d_delta = it == rt4_off.end() ? -(long long)t.q_off
                                        : (long long)it->second - t.q_off;
    }
    // 整个文件从 0 开始顺序读；每读到一组的结尾就记下这一组的事件。
    // 空组（比如没有张量的第 65 组）沿用前一组的位置，于是立刻算作就绪。
    int maxg = 0;
    for (const auto& kv : grp) maxg = std::max(maxg, kv.first);
    std::vector<std::pair<int, size_t>> ends;
    size_t last = 0;
    for (int g = 0; g <= maxg; g++) {
        auto it = grp.find(g);
        if (it != grp.end()) last = std::max(last, it->second.second);
        ends.push_back({g, last});
    }
    pf.set_linear(0, rt.dev, total, ends);          // packed.bin 的载荷从 0 开始
    printf("RT4: 打包布局 %.2f GB（%zu 个张量，顺序读，%d 个分组事件）\n",
           total / 1e9, rows.size(), maxg + 1);
}

// ========================= 组优先尺度的转换 ================================
// RT4 的 i4 尺度是行优先 s[n*(K/G)+g]；int4 GEMM 要组优先 s[g*N+n]。
// 只给走 GEMM 路径的权重额外准备一份（尺度总量 ~0.2GB）。
static std::vector<float> make_group_major(const RT4& rt, const RT4Tensor* t) {
    const int ng = (int)(t->K / t->group);
    std::vector<float> out((size_t)t->N * ng);
    const uint16_t* s = (const uint16_t*)rt.hptr(t->s_off);
    for (int n = 0; n < t->N; n++)
        for (int g = 0; g < ng; g++) {
            const uint16_t h = s[(size_t)n * ng + g];
            const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
            float f = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
            out[(size_t)g * t->N + n] = sg ? -f : f;
        }
    return out;
}

// ============================== 权重视图 ===================================
struct Wq {                       // 一个 int4 权重矩阵
    const u32* q = nullptr;
    const float* s = nullptr;     // 行优先（GEMV）
    float* s_gm = nullptr;        // 组优先（GEMM，设备指针）
    int N = 0, K = 0, group = 128;
    // 可选：这份权重同时有一份**原始 NVFP4** 版本（混合模式，见 src/k_nvfp4.hip）。
    // 非空时 linear_quant 直接走 NVFP4 内核，上面的 int4 字段就不用了。
    const u32* nvp = nullptr;     // weight_packed [N][K/8] u32
    const uint8_t* nvs = nullptr; // weight_scale  [N][K/16] u8 (E4M3)
    float nvgs = 1.f;             // weight_global_scale
    bool has_nvfp4() const { return nvp != nullptr; }
};
struct Wf { const void* p = nullptr; int n = 0; bool is_f16 = false; };

// ============================== 视觉塔（RT4） ==============================
// 权重来自 tools/convert_vision_rt4.py：线性层 int4/128（N 补 64、K 补 128），
// norm/bias/pos_embed 是 f32。线性层直接复用文本运行时的 int4 GEMM。
struct VisionModel {
    struct VW {
        const uint16_t* w = nullptr;      // f16 [N,K]
        int N = 0, K = 0;
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
    static constexpr int MERGE_IN = 4608, OUT_H = 5120;
    static constexpr int PATCH_DIM = 3 * 2 * 16 * 16;
    static constexpr int POS_N = 2304, POS_SIDE = 48, DEPTH = 27;

    RT4 rt;
    std::vector<VLayer> layers;
    const Rp4* rp4_src = nullptr;         // 非空则从 .rp4 的 visual 部分取权重
    uint8_t* rp4_dev = nullptr;
    void init_from_rp4(const Rp4& r, uint8_t* dev) { rp4_src = &r; rp4_dev = dev; init("", ""); }
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

    // pos/rope 表按 (gh,gw) 网格缓存：表内容只由网格决定（n=4*gh*gw 随之固定），
    // 同网格的图片直接复用设备上已上传的表 —— 主机重建 + 三次 H2D 全部省掉。
    // 上限 8 个网格，LRU 淘汰（淘汰只是删记录，设备缓冲会被新网格覆盖）。
    std::map<std::pair<int, int>, long long> grid_cache;
    long long grid_tick = 0;
    static constexpr int GRID_CACHE_MAX = 8;

    static int align128(int n) { return (n + 127) / 128 * 128; }

    VW W(const std::string& name) {
        const RT4Tensor* t = rt.find(name);
        if (!t || t->kind != "f16") {
            printf("视觉权重缺失或不是 f16：%s\n", name.c_str());
            exit(1);
        }
        VW w;
        w.w = (const uint16_t*)rt.dptr(t);
        w.N = (int)t->N;
        w.K = (int)t->K;
        return w;
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
        if (rp4_src) {                    // .rp4 单文件模式：视觉塔也在那个文件里
            rt4_from_rp4(rt, *rp4_src, "visual", rp4_dev);
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
            L.n1w = F(n("norm1.weight")); L.n1b = F(n("norm1.bias"));
            L.n2w = F(n("norm2.weight")); L.n2b = F(n("norm2.bias"));
            L.qkvb = F(n("attn.qkv.bias")); L.projb = F(n("attn.proj.bias"));
            L.fc1b = F(n("mlp.linear_fc1.bias")); L.fc2b = F(n("mlp.linear_fc2.bias"));
        }
        m_fc1 = W("model.visual.merger.linear_fc1.weight");
        m_fc2 = W("model.visual.merger.linear_fc2.weight");
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
        CK(hipMalloc(&d_out, (size_t)MMpad * OUT_H * 4));
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
        k_vit_linear_f16(y, w.w, x, M, w.N, w.K, x_stride, w.N);
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
        k_vit_bias_add(d_out, m_fc2b, n_tokens, OUT_H);
        out.resize((size_t)n_tokens * OUT_H);
        CK(hipMemcpy(out.data(), d_out, out.size() * 4, hipMemcpyDeviceToHost));
        dump_dev("hemb", d_out, n_tokens, OUT_H);
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

struct Layer {
    bool full = false;
    Wf in_ln, post_ln;
    Wq mlp_gate, mlp_up, mlp_down;
    // full attention
    Wq q_proj, k_proj, v_proj, o_proj;
    Wf q_norm, k_norm;
    // linear attention
    Wq in_qkv, in_z, out_proj;
    Wf conv1d, dt_bias, a_log, ssm_norm;
    Wf ssm_alpha, ssm_beta;         // [48][5120] f16：太小不量化，加载时转 f32
};

// MTP 头（Qwen3.5 NextN）：[embedding | hidden] → fc → 一层标准全注意力 + MLP → norm
struct Mtp {
    Wq fc;
    Wf pre_norm_embedding, pre_norm_hidden, norm;
    Wf in_ln, post_ln, q_norm, k_norm;
    Wq q_proj, k_proj, v_proj, o_proj;
    Wq mlp_gate, mlp_up, mlp_down;
    // W8A8（权重文件是 .hi/.lo 双张量时自动打开，见 tools/mtp_w8_pack.py）：
    // int8 权重码拆成 w8 = 16*wh + wl（hi 的组尺度已预乘 16），于是
    // 「hi 走一遍 int4 linear + lo 再走一遍再相加」= int8 权重 × int8 激活。
    // 下面这 8 个是 lo 半边，w8=false 时全空（老路径：单遍 int4）。
    bool w8 = false;
    Wq fc_lo, q_lo, k_lo, v_lo, o_lo, mlp_gate_lo, mlp_up_lo, mlp_down_lo;
    bool loaded = false;
};

struct Dev {
    float *x = nullptr, *xb = nullptr;            // 残差流 / norm 输出
    float *m_gate = nullptr, *m_up = nullptr;     // MLP 中间 (17408)
    float *qfull = nullptr;                       // q_proj 输出 [T][12288]
    float *hq = nullptr, *hgate = nullptr, *hout = nullptr;   // [T][6144]
    float *hkk = nullptr, *hvv = nullptr;         // [T][1024]
    float *hfa = nullptr;                         // FA 输出 [24][TP][256]
    float *qkv3 = nullptr, *conv = nullptr, *gz = nullptr;    // GDN: [T][10240]/[T][6144]
    float *gq = nullptr, *gk = nullptr, *gv = nullptr;        // GDN 紧凑 q/k/v
    float *gab = nullptr, *gg = nullptr;          // a/b/gate [T][96]
    float *gbeta = nullptr;                       // sigmoid(b) [T][48]
    float *logits = nullptr;
    u32   *qq = nullptr;                          // 量化后的 Q [24][TP][256/KVEL]
    float *qs = nullptr;                          // 其尺度 [24][2][TP]
    float *conv_prev = nullptr;                   // 卷积状态快照（更新前）
    u32   *aq_big = nullptr;                      // GEMM 激活量化暂存
    float *asc_big = nullptr;
    u32   *aq_h = nullptr, *aq_l = nullptr;       // W4A8：两个 int4 数字
    float *asc8 = nullptr, *asc16 = nullptr;      // 对应的两组尺度（sc16 = 16*sc）
    float *c_tmp = nullptr;                       // 第二遍 GEMM 的输出（之后相加）
    int   *dids = nullptr;                        // 输入 token id（常驻，避免每步 malloc）
    // 解码注意力的 split-KV 暂存：24 头 × 最多 32 段（默认 RT_MAXSPLIT=8；验证批按 4 行分片）
    float *fa_pout = nullptr, *fa_pmax = nullptr, *fa_psum = nullptr;
    // 主模型每行的最终 norm 隐藏态（MTP 的 hidden 输入）与上一 token 的隐藏态
    float *h_norm = nullptr, *h_prev = nullptr;
    // MTP 草稿 / 预填充用的临时激活
    float *mtp_e = nullptr, *mtp_hin = nullptr, *mtp_hn = nullptr, *mtp_cat = nullptr;
    float *mtp_fc = nullptr, *mtp_tmp = nullptr, *mtp_out = nullptr;
    float *mtp_logits = nullptr;
    // MTP 的 W8A8：lo 半边的 linear 输出（[T][17408]，MTP 里 N 最大的一层）
    float *mtp_lin2 = nullptr;
    // MTP 验证批的逐 token 状态快照（GDN / 卷积），以及逐行 logits
    float *ssm_snap = nullptr, *conv_snap = nullptr;
    // 主模型 / MTP 的 V tile 暂存快照（V 的尺度按 64-key tile 共享，跨 tile 回滚必须恢复）
    float *vstage_snap = nullptr, *mtp_vstage_snap = nullptr;
    float *logits_all = nullptr;
    int   *argmax = nullptr;
    int   *mtp_dids = nullptr;
    void alloc(int T);
};
void Dev::alloc(int T) {
    const size_t H = 5120, F = 17408, C6 = 6144, C10 = 10240;
    const int TP = ((T + 63) / 64) * 64;
    T = ((T + 127) / 128) * 128;                 // GEMM 的 M 要按 BM=128 对齐
    CK(hipMalloc(&x, (size_t)T * H * 4));
    CK(hipMalloc(&xb, (size_t)T * H * 4));
    CK(hipMalloc(&m_gate, (size_t)T * F * 4));
    CK(hipMalloc(&m_up, (size_t)T * F * 4));
    CK(hipMalloc(&qfull, (size_t)T * 12288 * 4));
    CK(hipMalloc(&hq, (size_t)T * C6 * 4));
    CK(hipMalloc(&hgate, (size_t)T * C6 * 4));
    CK(hipMalloc(&hout, (size_t)T * C6 * 4));
    CK(hipMalloc(&hkk, (size_t)T * 1024 * 4));
    CK(hipMalloc(&hvv, (size_t)T * 1024 * 4));
    CK(hipMalloc(&hfa, (size_t)24 * TP * 256 * 4));
    CK(hipMalloc(&qkv3, (size_t)T * C10 * 4));
    CK(hipMalloc(&conv, (size_t)T * C10 * 4));
    CK(hipMalloc(&gz, (size_t)T * C6 * 4));
    CK(hipMalloc(&gq, (size_t)T * 2048 * 4));
    CK(hipMalloc(&gk, (size_t)T * 2048 * 4));
    CK(hipMalloc(&gv, (size_t)T * C6 * 4));
    CK(hipMalloc(&gab, (size_t)T * 96 * 4));
    CK(hipMalloc(&gg, (size_t)T * 48 * 4));
    CK(hipMalloc(&gbeta, (size_t)T * 48 * 4));
    CK(hipMalloc(&logits, (size_t)248320 * 4));
    CK(hipMalloc(&qq, (size_t)24 * TP * (256 / KVEL) * 4));
    CK(hipMalloc(&qs, (size_t)24 * 2 * TP * 4));
    CK(hipMalloc(&conv_prev, (size_t)3 * C10 * 4));
    CK(hipMalloc(&aq_big, (size_t)T * F / 2 + 64));
    CK(hipMalloc(&asc_big, (size_t)T * (F / 128) * 4 + 64));
    CK(hipMalloc(&aq_h, (size_t)T * F / 2 + 64));
    CK(hipMalloc(&aq_l, (size_t)T * F / 2 + 64));
    CK(hipMalloc(&asc8, (size_t)T * (F / 128) * 4 + 64));
    CK(hipMalloc(&asc16, (size_t)T * (F / 128) * 4 + 64));
    CK(hipMalloc(&c_tmp, (size_t)T * F * 4));
    CK(hipMalloc(&dids, (size_t)T * 4 + 64));
    CK(hipMalloc(&fa_pout, (size_t)4 * 24 * 32 * 256 * 4));
    CK(hipMalloc(&fa_pmax, (size_t)4 * 24 * 32 * 4));
    CK(hipMalloc(&fa_psum, (size_t)4 * 24 * 32 * 4));
    CK(hipMalloc(&h_norm, (size_t)T * H * 4));
    CK(hipMalloc(&h_prev, (size_t)H * 4));
    CK(hipMalloc(&mtp_e, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_hin, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_hn, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_cat, (size_t)T * 2 * H * 4));
    CK(hipMalloc(&mtp_fc, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_tmp, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_out, (size_t)T * H * 4));
    CK(hipMalloc(&mtp_lin2, (size_t)T * F * 4));
    CK(hipMalloc(&mtp_logits, (size_t)248320 * 4));
    CK(hipMalloc(&logits_all, (size_t)4 * 248320 * 4));
    CK(hipMalloc(&argmax, 4 * sizeof(int)));
    CK(hipMalloc(&mtp_dids, (size_t)4 * sizeof(int) + 64));
}

// ============================== 模型 =======================================
// 视觉塔输出的图像 embedding：覆盖 d.x 中 [start, start+count) 行的词嵌入。
// data 是宿主 f32 [count][hidden]；start 是整段 prompt 内的 token 下标。

// [kv_pool] begin —— 全局多会话 KV 槽池（纯宿主逻辑；设备拷贝在 Model::kv_* 里）。
// 被 tests/test_kv_pool.py 整段抽取出去配 stub 编译离线单测，改动时保持自包含：
// 只依赖 std::，不引用 Model / cfg / KVEL（维度全走 KvDims）。
//
// 动机：引擎只有一份按绝对位置写的注意力 KV + 一份 GDN 循环态，切换对话（A→B）
// 时 B 的预填充直接把 A 的状态覆盖掉。槽池把「切走的那一刻」的完整状态泊进槽：
//   * 48 个线性层的 ssm/conv 循环态 + h_prev（活态，以及预填充结束点的回退快照）
//   * 16 个注意力层 + MTP 层的 KV 前缀（k/ksc/v/vsc，按 [0, len) 拷出）
//   * 16 个注意力层 + MTP 层的 V 暂存区（vstage，见 Model::kv_copy_vstage：
//     k_kv_append_v 对半满 tile 的尺度依赖它的残留，回港后接着 append 必须一致）
// A 再回来时整段恢复，只补新消息 —— A→B→A 不再整段重算。
// 匹配语义与单上下文复用完全一致：新序列以槽序列为前缀 → 接着算（append）；
// 只命中到槽的快照点 → 退回快照点再补（rewind）；否则不入眼。
struct KvDims {
    int n_kv = 0, head_dim = 0;            // 注意力 KV 头数 / 每头维度
    int kvel = 4, bg = 64;                 // 每 dword 元素数（KV_BITS=8 → 4）；v 尺度 tile 高
    int max_ctx = 0, hidden = 0;
    int n_lin = 0, n_attn = 0;             // 线性层 / 注意力层个数
    long long ssm_one = 0, conv_one = 0;   // 每线性层循环态 / 卷积态的 float 数
};

// 一段备份拷贝的几何：live 侧 pitch 与槽侧 pitch 不同（live 按 max_ctx 步长分配，
// 槽内紧排）。连续段就是 height=1 的特例，统一走 2D 拷贝。
struct KvSeg {
    int src;                // 0=ssm(lin) 1=conv(lin) 2=hprev 3=snap_ssm 4=snap_conv 5=snap_hprev
                            // 6=kc(attn) 7=ksc 8=vc 9=vsc 10=mtp_kc 11=mtp_ksc 12=mtp_vc 13=mtp_vsc
    int idx;                // 层号（按 src 的类别：线性槽号 / 注意力槽号）
    size_t off;             // 槽内字节偏移
    size_t pitch_live;      // live 缓冲每行步长（字节）
    size_t pitch_slot;      // 槽内每行步长（字节）
    size_t width, height;   // 2D 拷贝的宽（字节）与行数
};

struct KvSlot {
    std::vector<int> ids;               // 泊船时的完整上下文（prompt + 已生成）
    int seq_len = 0, mtp_len = 0;       // 泊船时的一致长度
    int snap_len = -1;                  // 预填充结束点（rewind 用）
    bool snap_valid = false;
    void* dev = nullptr;                // 备份缓冲（Model 分配/释放）
    size_t bytes = 0;                   // 备缓冲字节数（0=空槽）
    long long tick = 0;                 // LRU 时钟
    bool used = false;
};

struct KvPool {
    int cap = 0;                        // 槽数（0=禁用；RT_KV_POOL）
    size_t cap_bytes = 0;               // 全部槽备份总字节上限（RT_KV_POOL_MB）
    std::vector<KvSlot> slots;
    int active = -1;                    // 活跃上下文来自哪个槽（-1=未入池）
    long long tick = 0;
    size_t total_bytes = 0;
    long long n_save = 0, n_restore = 0, n_evict = 0;
    std::function<void(void*)> free_dev;    // 驱逐/清空时释放设备缓冲（离线测试注入 stub）

    void config(int cap_, size_t cap_bytes_) {
        cap = cap_ > 0 ? cap_ : 0;
        cap_bytes = cap_bytes_;
        slots.assign(cap, KvSlot{});
    }

    // 槽备份布局：返回总字节，并把每段拷贝几何写进 segs（顺序固定，Model 按序拷）。
    static size_t layout(const KvDims& d, int seq, int mtp, bool snap, bool mtp_on,
                         std::vector<KvSeg>* segs) {
        size_t off = 0;
        auto push = [&](int src, int idx, size_t pitch_live, size_t row, size_t h) {
            if (segs) segs->push_back(KvSeg{src, idx, off, pitch_live, row, row, h});
            off += row * h;
        };
        for (int i = 0; i < d.n_lin; i++)
            push(0, i, (size_t)d.ssm_one * 4, (size_t)d.ssm_one * 4, 1);
        for (int i = 0; i < d.n_lin; i++)
            push(1, i, (size_t)d.conv_one * 4, (size_t)d.conv_one * 4, 1);
        push(2, 0, (size_t)d.hidden * 4, (size_t)d.hidden * 4, 1);
        if (snap) {
            for (int i = 0; i < d.n_lin; i++)
                push(3, i, (size_t)d.ssm_one * 4, (size_t)d.ssm_one * 4, 1);
            for (int i = 0; i < d.n_lin; i++)
                push(4, i, (size_t)d.conv_one * 4, (size_t)d.conv_one * 4, 1);
            push(5, 0, (size_t)d.hidden * 4, (size_t)d.hidden * 4, 1);
        }
        const size_t KV = (size_t)d.n_kv, D = (size_t)d.head_dim;
        const size_t kvel = (size_t)d.kvel, bg = (size_t)d.bg, MC = (size_t)d.max_ctx;
        const size_t krow = (size_t)seq * (D / kvel) * 4;      // k 每 head 的前缀字节
        const size_t vrows = ((size_t)seq + kvel - 1) / kvel;  // v 覆盖前缀的行数
        const size_t vtiles = ((size_t)seq + bg - 1) / bg;     // v 尺度覆盖前缀的 tile 数
        for (int i = 0; i < d.n_attn; i++) {
            push(6, i, MC * (D / kvel) * 4, krow, KV);         // kcache   [H][kv][D/kvel]
            // ksc 是「组优先」的 [H][2][kv]（见 src/k_new.hip 的 k_kv_append_k 与
            // src/k_fa.hip 的 Kscb[g*kv_cap + kv]）：两个 128 维组各占一整段 kv。
            // 整块按 [H*2][kv] 连续，所以每层要按行搬 KV*2 段、每段 seq 个 float，
            // 行距 = 一整段 kv（MC*4）。不能当成「每 head 一段 2*seq」来搬。
            push(7, i, MC * 4, (size_t)seq * 4, KV * 2);       // ksc      [H][2][kv]
            push(8, i, (MC / kvel) * D * 4, vrows * D * 4, KV);// vcache   [H][kv/kvel][D]
            push(9, i, (MC / bg) * D * 4, vtiles * D * 4, KV);// vsc      [H][tile][D]
        }
        if (mtp_on) {
            const size_t mrow = (size_t)mtp * (D / kvel) * 4;
            const size_t mvrows = ((size_t)mtp + kvel - 1) / kvel;
            const size_t mvtiles = ((size_t)mtp + bg - 1) / bg;
            push(10, 0, MC * (D / kvel) * 4, mrow, KV);
            push(11, 0, MC * 4, (size_t)mtp * 4, KV * 2);      // mtp_ksc  [H][2][kv]
            push(12, 0, (MC / kvel) * D * 4, mvrows * D * 4, KV);
            push(13, 0, (MC / bg) * D * 4, mvtiles * D * 4, KV);
        }
        return off;
    }

    // 最佳候选槽（不含活跃槽——活跃上下文在外面直接比）：返回 {槽号, 可复用起点}。
    // 起点语义：完全延续 → 槽全长；否则若命中到快照点 → 快照点；都不行 → 0。
    std::pair<int, size_t> best_match(const std::vector<int>& ids) const {
        int bi = -1;
        size_t bs = 0;
        for (int i = 0; i < (int)slots.size(); i++) {
            const KvSlot& s = slots[i];
            if (!s.used || s.bytes == 0 || i == active) continue;
            if ((int)s.ids.size() != s.seq_len) continue;              // 一致性守卫
            const size_t lim = std::min(s.ids.size(), ids.size());
            size_t lcp = 0;
            while (lcp < lim && s.ids[lcp] == ids[lcp]) lcp++;
            size_t st = 0;
            if (lcp == s.ids.size() && lcp < ids.size())
                st = lcp;                                             // append：整段延续
            else if (s.snap_valid && s.snap_len >= 0 &&
                     (size_t)s.snap_len <= s.ids.size() &&
                     lcp >= (size_t)s.snap_len && (size_t)s.snap_len < ids.size())
                st = (size_t)s.snap_len;                              // rewind：退回快照点
            if (st > bs) { bs = st; bi = i; }
        }
        return {bi, bs};
    }

    // 为「泊当前对话」找宿主槽：老槽原地更新；否则空槽优先、LRU 驱赶。
    // keep：马上要恢复的槽号，绝不能被拿来当宿主或驱逐（-1=无）。
    // 放不下（need 超总预算，或驱干净了还超）→ -1 = 放弃入池（直接丢弃，与旧行为一致）。
    int acquire_home(size_t need, int keep = -1) {
        if (cap <= 0 || need == 0 || need > cap_bytes) return -1;
        int home = active;
        if (home < 0) {
            home = -1;
            for (int i = 0; i < cap; i++)
                if (!slots[i].used && i != keep) { home = i; break; }
            if (home < 0) {                                           // 没空槽 → 驱逐最旧
                home = lru_victim(keep, -1);
                if (home < 0) return -1;
                evict(home);
            }
        }
        while (total_bytes - slots[home].bytes + need > cap_bytes) {
            const int v = lru_victim(home, keep);                     // 驱别的槽腾预算
            if (v < 0) return -1;
            evict(v);
        }
        return home;
    }

    void commit_save(int home, const std::vector<int>& ids_, int seq, int mtp,
                     int snap_len_, bool snap_valid_, void* dev, size_t bytes) {
        total_bytes -= slots[home].bytes;
        KvSlot& s = slots[home];
        s.ids = ids_;
        s.seq_len = seq; s.mtp_len = mtp;
        s.snap_len = snap_len_; s.snap_valid = snap_valid_;
        s.dev = dev; s.bytes = bytes; s.used = true;
        s.tick = ++tick;
        total_bytes += bytes;
        active = home;
        n_save++;
    }

    void commit_restore(int idx) {
        slots[idx].tick = ++tick;
        active = idx;
        n_restore++;
    }

    void drop_active() { active = -1; }     // 活跃上下文已被重算/清空：不再对应任何槽

    void clear_all() {                      // RESET：全池作废（设备缓冲经 free_dev 释放）
        for (auto& s : slots) {
            if (s.used && s.dev && free_dev) free_dev(s.dev);
            s = KvSlot{};
        }
        total_bytes = 0;
        active = -1;
    }

private:
    int lru_victim(int ex1, int ex2) const {  // 最旧的已用槽（排除 ex1/ex2；-1=不排除）
        int v = -1;
        for (int i = 0; i < (int)slots.size(); i++) {
            if (!slots[i].used || i == ex1 || i == ex2) continue;
            if (v < 0 || slots[i].tick < slots[v].tick) v = i;
        }
        return v;
    }
    void evict(int i) {
        if (slots[i].used && slots[i].dev && free_dev) free_dev(slots[i].dev);
        total_bytes -= slots[i].bytes;
        slots[i] = KvSlot{};
        n_evict++;
    }
};
// [kv_pool] end

struct EmbSpan {
    const float* data;
    int start;
    int count;
};

struct Model {
    Cfg cfg;
    RT4 rt;
    RT4 mtp_rt;
    std::vector<Layer> layers;
    Wq embed; Wf out_norm;
    Wq lm_head;
    std::vector<std::vector<float>> gm_scale;     // 组优先尺度（host 侧持有直到上传）
    std::vector<float*> gm_dev;
    Prefetch pf;                                  // 后台按层预取（与第一次前向重叠）
    std::set<std::string> nvfp4_names;             // 被 NVFP4 直跑取代的 RT4 张量名
    Rp4 rp4;                                       // .rp4 单文件模式
    bool rp4_used = false;
    int rp4_last_group = 0;

    // KV cache（16 个注意力层）与 GDN 状态（48 个线性层）
    int max_ctx = 131072, G = 128, BG = 64;
    std::vector<u32*> kcache, vcache; std::vector<float*> ksc, vsc, vstage;
    std::vector<float*> ssm_state, conv_state;
    int seq_len = 0;                              // 已缓存 token 数
    std::vector<int> lin_slot;                    // 线性层 → snap 槽位（-1=全注意力）
    std::vector<int> attn_slot;                   // 全注意力层 → vstage 快照槽位
    int n_lin = 0, n_attn = 0;

    // MTP 状态
    Mtp mtp;
    bool mtp_on = false;                          // 权重加载成功且本次运行启用
    int  mtp_n = 3;                               // 每轮最多草稿 token 数
    std::string mtp_path, mtp_json;               // MTP RT4 权重 / manifest（空则不启用）
    int  mtp_len = 0;                             // MTP KV 已写入条数（= 主模型 seq_len-1）
    u32* mtp_kc = nullptr; u32* mtp_vc = nullptr;
    float* mtp_ksc = nullptr; float* mtp_vsc = nullptr; float* mtp_vstage = nullptr;
    bool snap_mode = false;                       // 验证批：GDN/卷积保存逐 token 状态快照

    // ---- 对话前缀复用：跨请求复用 KV，避免每条消息都从头重算整段历史 ----
    // ctx_ids：当前 KV cache 里**实际缓存**的 token 序列（预填充喂进去的 + 生成时喂进去的）。
    // ctx_*  ：上一次预填充「刚结束、还没开始生成」那一刻的可回退快照，包含
    //          线性注意力/卷积层的循环状态与 h_prev。注意力层的 KV 是按绝对位置写的，
    //          把 seq_len 退回快照点再重新前向，越过的位置会被覆盖，所以不需要快照。
    // 新 prompt 只要以 ctx_ids 为前缀就能只补差量；只以快照点为前缀时退回快照点再补。
    std::vector<int> ctx_ids;
    float* ctx_ssm = nullptr;                     // n_lin  * ssm_one
    float* ctx_conv = nullptr;                    // n_lin  * conv_one
    float* ctx_hprev = nullptr;                   // hidden
    int  ctx_snap_len = -1;
    bool ctx_snap_valid = false;
    void save_ctx_snapshot();
    bool restore_ctx_snapshot();

    // ---- 全局 KV 槽池（见文件头 [kv_pool]：A→B→A 切对话不丢 KV）----
    KvPool kv_pool;
    KvDims kv_dims;
    bool kv_trace = false;
    size_t kv_slot_bytes(int seq, int mtp, bool snap) const;
    void kv_save_active(int keep = -1);
    bool kv_restore_slot(int idx);
    void kv_pool_clear();
    void kv_copy_slot(void* slot_dev, const std::vector<KvSeg>& segs, bool to_slot);
    size_t kv_vstage_bytes() const;               // 每个槽额外要带的 V 暂存区字节
    void kv_copy_vstage(void* base, bool to_slot);
    const void* kv_live_ptr(const KvSeg& g);
    int lin_slot_inv(int slot) const;             // 线性槽号 → 层号（反查 lin_slot）
    int attn_slot_inv(int slot) const;            // 注意力槽号 → 层号（反查 attn_slot）

    // 视觉塔（独立 RT4 文件；不参与文本层）
    VisionModel vm;
    bool vision_on = false;

    Dev d;
    int T_MAX = 4096;
    std::string dump_file;
    std::vector<int>* dump_layers = nullptr;
    bool stats = false;
    void dump_x(int il, int n);
    void dump_buf(int tag, const float* p, long long cnt);
    void dump_raw(const std::string& path, const void* p, size_t bytes);
    void db(int il, int stage, const float* p, long long cnt);   // 中间量 dump（RT_DUMP_BUF=1 时才写）
    void print_stats(int il, int n);
    void print_buf(const char* tag, const float* p, long long n);
    int dbg_layer = -1;

    // 分阶段计时（RT_PROF=1 打开；见文件头的 ProfTick）
    bool prof = false;
    double prof_acc[P_NCAT] = {0};
    long long prof_tokens = 0;               // 本次统计包含多少次 forward
    int pa(int cat) { return prof ? cat : -1; }
    void prof_reset() {
        for (int i = 0; i < P_NCAT; i++) prof_acc[i] = 0;
        prof_tokens = 0;
        g_prof_tl.clear();
        g_prof_next = 0;
    }
    void prof_flush() { if (prof) prof_fold(prof_acc); }
    void prof_print(const char* tag);

    void init(const std::string& path, const std::string& json);
    bool load_mtp(const std::string& path, const std::string& json);
    void reset_state();
    // 前向：ids[n]，positions 为绝对位置；返回最后一个 token 的 logits（设备指针）
    void forward(const int* ids, int n, bool log_last, int log_rows = 0,
                 bool extend_mtp = true, bool snap_states = false,
                 const EmbSpan* emb_spans = nullptr, int n_emb_spans = 0, int base_off = 0);
    void attention_layer(int il, int n);
    void gdn_layer(int il, int n);
    void mlp_layer(int il, int n);
    // MTP：把 n 行 (token, hidden) 送进 MTP 层并追加它自己的 KV；rows==1 时可输出 logits
    void mtp_layer_rows(const int* ids_dev, const float* hin, int rows, int pos0,
                        bool want_logits, int* argmax_out);
    int  mtp_draft_one(int token, const float* hin, int snap_slot = -1);
    // 草稿链：K 步严格串行的 MTP 前向，**中间不回主机**（上一步的 argmax 就在设备上，
    // 直接当下一步的输入 token），只在最后回读 K 个 token。快照槽位 = 0..K-1。
    void mtp_draft_chain(int first_token, const float* hin, int K, int* out_ids);
    void mtp_extend_context(const int* ids_dev, int n, int abs_off);
    void mtp_extra_entry(int token, bool want_logits, int* argmax_out, int snap_slot = -1);
    void mtp_restore_stage(int slot);
    // MTP 的线性层：W8A8 时 hi/lo 各走一遍 int4 linear 再相加（lo 为空则就是普通 int4）
    void mtp_linear(float* y, const Wq& hi, const Wq& lo, const float* x, int T);
    void rollback_state(int keep);
    // T 行 × N 输出的线性层：M 小走 GEMV，M 大走 GEMM（a 已经是量化好的 int4）
    void linear(float* y, const Wq& w, const float* x, int M);
    void linear_quant(float* y, const Wq& w, const float* x, int M, u32* aq, float* asc, int row_stride, int row_off);
};

// 取权重（名字带上语言模型的完整前缀）
static std::string tn(int il, const char* suffix) {
    char buf[256];
    snprintf(buf, sizeof(buf), "model.language_model.layers.%d.%s", il, suffix);
    return buf;
}

// ==================== 混合模式：MLP 挂上原始 NVFP4 权重 ====================
// RT4 的 MLP 权重是**离线重量化**过的 int4（清单里 relerr ≈ 12%）。这里额外从
// 原始 safetensors 读一份 checkpoint 原样的 NVFP4（weight_packed / weight_scale /
// weight_global_scale），原封不动搬进显存，交给 k_nvfp4_* 内核。
// 张量偏移来自 tools/nvfp4_layout.py 产出的 TSV，所以 C++ 侧
// 不需要解析 safetensors 的 JSON。
struct NvRow { int layer, which; size_t poff, pbytes, soff, sbytes; float gs; int N, K; };

// NVFP4 张量的名字（去掉 .weight_packed / .weight_scale 后缀）
static std::string nv_stem(const NvRow& r) {
    char buf[256];
    snprintf(buf, sizeof(buf), "model.language_model.layers.%d.mlp.%s", r.layer,
             r.which == 0 ? "gate_proj" : r.which == 1 ? "up_proj" : "down_proj");
    return buf;
}

// 只读清单（不碰权重），好在 rt.load() 之前就知道该跳过哪些 RT4 张量
static std::vector<NvRow> read_nvfp4_rows(const std::string& manifest, int n_layer) {
    std::vector<NvRow> rows;
    std::ifstream mf(manifest);
    if (!mf) { printf("NVFP4: 清单打不开（%s），MLP 仍走 int4\n", manifest.c_str()); return rows; }
    std::string line;
    while (std::getline(mf, line)) {
        if (line.empty() || line[0] == '#') continue;
        std::istringstream ss(line);
        std::string name;
        NvRow r{};
        ss >> name >> r.poff >> r.pbytes >> r.soff >> r.sbytes >> r.gs >> r.N >> r.K;
        if (!ss) continue;
        const size_t p = name.find(".layers.");
        if (p == std::string::npos) continue;
        r.layer = atoi(name.c_str() + p + 8);
        if (name.find(".mlp.gate_proj") != std::string::npos) r.which = 0;
        else if (name.find(".mlp.up_proj") != std::string::npos) r.which = 1;
        else if (name.find(".mlp.down_proj") != std::string::npos) r.which = 2;
        else continue;
        if (r.layer >= n_layer) continue;
        rows.push_back(r);
    }
    return rows;
}

// 这些 RT4 张量会被 NVFP4 版本取代，上传时可以整段跳过
static std::set<std::string> nvfp4_skip_names(const std::vector<NvRow>& rows) {
    std::set<std::string> s;
    for (const NvRow& r : rows) {
        char buf[256];
        snprintf(buf, sizeof(buf), "model.language_model.layers.%d.mlp.%s.weight", r.layer,
                 r.which == 0 ? "gate_proj" : r.which == 1 ? "up_proj" : "down_proj");
        s.insert(buf);
    }
    return s;
}

// 把 NVFP4 权重挂到 MLP 上。
//   packed == nullptr：各自 malloc，并登记进预取器（按层加载）
//   packed != nullptr：权重已经在打包文件的 dev 缓冲里，直接按索引贴指针
static void attach_nvfp4_mlp(std::vector<Layer>& layers, const std::vector<NvRow>& rows,
                             Prefetch& pf, int file,
                             const std::map<std::string, size_t>* nvp = nullptr,
                             const std::map<std::string, size_t>* nvs = nullptr,
                             uint8_t* dev = nullptr) {
    if (rows.empty()) return;
    size_t tot = 0;
    for (const NvRow& r : rows) {
        Wq* w = r.which == 0 ? &layers[r.layer].mlp_gate
               : r.which == 1 ? &layers[r.layer].mlp_up : &layers[r.layer].mlp_down;
        if (w->N != r.N || w->K != r.K) {
            printf("NVFP4: 形状不符 layer %d which %d: RT4 %dx%d vs NVFP4 %dx%d\n",
                   r.layer, r.which, w->N, w->K, r.N, r.K);
            exit(1);
        }
        if (nvp) {
            const std::string stem = nv_stem(r);
            auto a = nvp->find(stem), b = nvs->find(stem);
            if (a == nvp->end() || b == nvs->end()) {
                printf("NVFP4: 打包索引里缺 %s\n", stem.c_str());
                exit(1);
            }
            w->nvp = (const u32*)(dev + a->second);
            w->nvs = dev + b->second;
        } else {
            void *dp = nullptr, *ds = nullptr;
            CK(hipMalloc(&dp, r.pbytes));
            CK(hipMalloc(&ds, r.sbytes));
            pf.add(file, r.poff, dp, r.pbytes, 1 + r.layer);     // 和第 r.layer 层一起加载
            pf.add(file, r.soff, ds, r.sbytes, 1 + r.layer);
            w->nvp = (const u32*)dp;
            w->nvs = (const uint8_t*)ds;
        }
        w->nvgs = r.gs;
        tot += r.pbytes + r.sbytes;
    }
    printf("NVFP4: %zu 个 MLP 张量改为直跑（%.3f GB，权重零误差）\n",
           rows.size(), tot / 1e9);
}

void Model::init(const std::string& path, const std::string& json) {
    // ---- 先在主权重之前决定 NVFP4 会取代哪些 MLP 张量，这样上传时能整段跳过 ----
    std::vector<NvRow> nv_rows;
    std::string nv_st;
    std::map<std::string, size_t> rt4_off, nvp_off, nvs_off;
    std::vector<PackRow> pack_rows;          // 退回路径用（.rp4 模式下为空）
    std::string pack_bin;
    int f_rt = -1;
    const bool want_nvfp4 = getenv("RT_NVFP4") ? atoi(getenv("RT_NVFP4")) : 1;

    // ---- 优先用 .rp4 单文件（tools/rp4_pack.py 产出）：头 + 索引 + 载荷 ----
    {
        std::string p;
        const char* e = getenv("RT_RP4");
        if (e && !strcmp(e, "0")) { /* 显式关闭 */ }
        else if (e && *e) p = e;
        // 默认找项目自己的 models/ 目录（scripts/env.sh 会显式设置 RT_RP4）。
        else if (access("models/Qwen3.8-27B-NVFP4/model.rp4", R_OK) == 0)
            p = "models/Qwen3.8-27B-NVFP4/model.rp4";
        if (!p.empty() && want_nvfp4) rp4_used = rp4_open(rp4, p);
        else if (!p.empty()) printf("RT_NVFP4=0，.rp4 里没有 MLP 的 int4 权重，跳过\n");
    }
    if (rp4_used) {
        CK(hipMalloc(&rp4.dev, rp4.data_len));
        rt4_from_rp4(rt, rp4, "main", rp4.dev);
        for (const Rp4Row& row : rp4.rows) {
            if (row.type == "nvp") {
                nvp_off[row.name] = row.off;
                // 顺带把 NVFP4 的层号/投影/形状凑出来给 attach 用
                const size_t d = row.name.find(".layers.");
                if (d == std::string::npos) continue;
                NvRow r{};
                r.layer = atoi(row.name.c_str() + d + 8);
                if (row.name.find(".mlp.gate_proj") != std::string::npos) r.which = 0;
                else if (row.name.find(".mlp.up_proj") != std::string::npos) r.which = 1;
                else if (row.name.find(".mlp.down_proj") != std::string::npos) r.which = 2;
                else continue;
                r.N = row.N; r.K = row.K; r.gs = row.gscale;
                r.pbytes = row.bytes;            // 只用于打印体积
                nv_rows.push_back(r);
            } else if (row.type == "nvs") {
                nvs_off[row.name] = row.off;
                for (NvRow& nv : nv_rows)
                    if (nv_stem(nv) == row.name) nv.sbytes = row.bytes;
            }
        }
        std::sort(nv_rows.begin(), nv_rows.end(), [](const NvRow& a, const NvRow& b) {
            return a.layer != b.layer ? a.layer < b.layer : a.which < b.which; });
        nvfp4_names = nvfp4_skip_names(nv_rows);   // prep_gm 要靠它跳过被取代的权重
        // 线性预取：整段载荷从 0 顺序读，跨过分组边界时记事件
        std::map<int, size_t> gend;
        for (const Rp4Row& row : rp4.rows)
            gend[row.group] = std::max(gend[row.group], row.off + row.bytes);
        int maxg = 0;
        for (const auto& kv : gend) maxg = std::max(maxg, kv.first);
        std::vector<std::pair<int, size_t>> ends;
        size_t last = 0;
        for (int g = 0; g <= maxg; g++) {
            auto it = gend.find(g);
            if (it != gend.end()) last = std::max(last, it->second);
            ends.push_back({g, last});
        }
        rp4_last_group = maxg;
        pf.add_file(rp4.path.c_str(), true);
        pf.set_linear(rp4.data_off, rp4.dev, rp4.data_len, ends);
        printf("RP4: %s  %.3f GB  %zu 张量（main %zu / NVFP4 %d / MTP+视觉 %d），单文件模式\n",
               rp4.path.c_str(), rp4.data_len / 1e9, rp4.rows.size(),
               rt.tensors.size(), (int)nv_rows.size(),
               (int)std::count_if(rp4.rows.begin(), rp4.rows.end(),
                                  [](const Rp4Row& r) { return r.part != "main"; }));
    } else {
    rt.load(path, json);
    if (getenv("RT_NVFP4") ? atoi(getenv("RT_NVFP4")) : 1) {
        const char* mf = getenv("RT_NVFP4_MANIFEST");
        const char* sp = getenv("RT_NVFP4_SAFETENSORS");
        nv_st = sp ? sp : "models/Qwen3.8-27B-NVFP4/model.safetensors";
        nv_rows = read_nvfp4_rows(mf ? mf : "build/nvfp4_manifest.tsv",
                                  cfg.n_layer);
        nvfp4_names = nvfp4_skip_names(nv_rows);
    }
    // ---- 退回路径：打包文件 / 散读（tools/nvfp4_pack.py 产出的 packed.bin）----
    {
        // RT_PACKED 指定打包文件；不指定就看本项目 build/ 里有没有现成的；
        // RT_PACKED=0 明确关掉，退回散读。
        const char* pb = getenv("RT_PACKED");
        if (pb && !strcmp(pb, "0")) { /* 显式关闭 */ }
        else if (pb && *pb) pack_bin = pb;
        else if (access("build/packed.bin", R_OK) == 0)
            pack_bin = "build/packed.bin";
    }
    if (!pack_bin.empty()) {
        std::string ts = getenv("RT_PACKED_TSV") ? getenv("RT_PACKED_TSV") : "";
        if (ts.empty()) {
            const size_t dot = pack_bin.rfind('.');
            ts = (dot == std::string::npos ? pack_bin : pack_bin.substr(0, dot)) + ".tsv";
        }
        if (access(pack_bin.c_str(), R_OK) == 0) pack_rows = read_pack_index(ts);
        else printf("RT_PACKED=%s 不可读，退回散读\n", pack_bin.c_str());
    }
    // 打包文件是按「MLP 用 NVFP4 取代」生成的：NVFP4 开着才用它，
    // 否则那份 MLP 的 int4 权重根本没被打进包里。
    if (!pack_rows.empty()) {
        const bool has_nv = std::any_of(pack_rows.begin(), pack_rows.end(),
                                        [](const PackRow& r) { return r.type == "nvp"; });
        if (has_nv != !nv_rows.empty()) {
            printf("打包文件与 RT_NVFP4=%d 不匹配，退回散读\n", nv_rows.empty() ? 0 : 1);
            pack_rows.clear();
        }
    }
    // 打包文件用 O_DIRECT 顺序读；散读模式用带缓存读（偏移不保证块对齐）
    f_rt = pf.add_file(pack_rows.empty() ? path.c_str() : pack_bin.c_str(),
                       !pack_rows.empty());
    if (pack_rows.empty()) plan_upload(rt, pf, f_rt, nvfp4_names);
    else                   plan_upload_packed(rt, pf, f_rt, pack_rows, rt4_off, nvp_off, nvs_off);
    }
    layers.resize(cfg.n_layer);
    // 组优先尺度（先做 host 侧转换，之后再上传）
    std::vector<std::pair<Wq*, RT4Tensor*>> need_gm;
    auto W = [&](const std::string& n) -> Wq {
        const RT4Tensor* t = rt.find(n);
        if (!t) { printf("缺张量 %s\n", n.c_str()); exit(1); }
        Wq w;
        if (t->kind == "i4") {
            w.q = rt.qptr(t); w.s = rt.sptr(t); w.N = (int)t->N; w.K = (int)t->K; w.group = (int)t->group;
        } else { printf("权重 %s 不是 i4（%s），运行时暂不支持\n", n.c_str(), t->kind.c_str()); exit(1); }
        return w;
    };
    // 小张量（norm/conv/A_log/dt_bias/未量化的投影）：统一转 f32 放显存
    auto F = [&](const std::string& n) -> Wf {
        const RT4Tensor* t = rt.find(n);
        if (!t) { printf("缺张量 %s\n", n.c_str()); exit(1); }
        Wf w;
        if (t->kind == "f16") {
            const uint16_t* src = (const uint16_t*)(rt.hptr(t->q_off));
            const int cnt = (int)(t->nbytes / 2);
            std::vector<float> tmp(cnt);
            for (int i = 0; i < cnt; i++) {
                const uint16_t h = src[i];
                const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
                float f = ex == 0 ? ldexpf(ma / 1024.f, -14) : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
                tmp[i] = sg ? -f : f;
            }
            float* dp; CK(hipMalloc(&dp, (size_t)cnt * 4));
            CK(hipMemcpy(dp, tmp.data(), (size_t)cnt * 4, hipMemcpyHostToDevice));
            w.p = dp; w.n = cnt;
        } else {
            const int cnt = (int)(t->nbytes / 4);
            float* dp; CK(hipMalloc(&dp, (size_t)cnt * 4));
            CK(hipMemcpy(dp, rt.hptr(t->q_off), (size_t)cnt * 4, hipMemcpyHostToDevice));
            w.p = dp; w.n = cnt;
        }
        return w;
    };
    for (int il = 0; il < cfg.n_layer; il++) {
        Layer& L = layers[il];
        L.full = cfg.is_full(il);
        L.in_ln = F(tn(il, "input_layernorm.weight"));
        L.post_ln = F(tn(il, "post_attention_layernorm.weight"));
        L.mlp_gate = W(tn(il, "mlp.gate_proj.weight"));
        L.mlp_up = W(tn(il, "mlp.up_proj.weight"));
        L.mlp_down = W(tn(il, "mlp.down_proj.weight"));
        if (L.full) {
            L.q_proj = W(tn(il, "self_attn.q_proj.weight"));
            L.k_proj = W(tn(il, "self_attn.k_proj.weight"));
            L.v_proj = W(tn(il, "self_attn.v_proj.weight"));
            L.o_proj = W(tn(il, "self_attn.o_proj.weight"));
            L.q_norm = F(tn(il, "self_attn.q_norm.weight"));
            L.k_norm = F(tn(il, "self_attn.k_norm.weight"));
        } else {
            L.in_qkv = W(tn(il, "linear_attn.in_proj_qkv.weight"));
            L.in_z = W(tn(il, "linear_attn.in_proj_z.weight"));
            L.out_proj = W(tn(il, "linear_attn.out_proj.weight"));
            L.conv1d = F(tn(il, "linear_attn.conv1d.weight"));
            L.dt_bias = F(tn(il, "linear_attn.dt_bias"));
            L.a_log = F(tn(il, "linear_attn.A_log"));
            L.ssm_norm = F(tn(il, "linear_attn.norm.weight"));
            L.ssm_alpha = F(tn(il, "linear_attn.in_proj_a.weight"));
            L.ssm_beta = F(tn(il, "linear_attn.in_proj_b.weight"));
        }
    }
    embed = W("model.language_model.embed_tokens.weight");
    out_norm = F("model.language_model.norm.weight");
    lm_head = W("lm_head.weight");

    // ---- 组优先尺度：给 GEMM 路径准备 ----
    gm_scale.resize(rt.tensors.size());
    gm_dev.assign(rt.tensors.size(), nullptr);
    auto prep_gm = [&](const std::string& n) {
        const RT4Tensor* t = rt.find(n);
        if (!t || t->kind != "i4") return;
        if (nvfp4_names.count(n)) return;    // 这份权重被 NVFP4 取代，不用再准备 GEMM 尺度
        const int idx = rt.index[n];
        if (gm_dev[idx]) return;
        gm_scale[idx] = make_group_major(rt, t);
        CK(hipMalloc(&gm_dev[idx], gm_scale[idx].size() * 4));
        CK(hipMemcpy(gm_dev[idx], gm_scale[idx].data(), gm_scale[idx].size() * 4, hipMemcpyHostToDevice));
        gm_scale[idx].clear(); gm_scale[idx].shrink_to_fit();
    };
    for (int il = 0; il < cfg.n_layer; il++) {
        prep_gm(tn(il, "mlp.gate_proj.weight"));
        prep_gm(tn(il, "mlp.up_proj.weight"));
        prep_gm(tn(il, "mlp.down_proj.weight"));
        if (layers[il].full) {
            prep_gm(tn(il, "self_attn.q_proj.weight"));
            prep_gm(tn(il, "self_attn.k_proj.weight"));
            prep_gm(tn(il, "self_attn.v_proj.weight"));
            prep_gm(tn(il, "self_attn.o_proj.weight"));
        } else {
            prep_gm(tn(il, "linear_attn.in_proj_qkv.weight"));
            prep_gm(tn(il, "linear_attn.in_proj_z.weight"));
            prep_gm(tn(il, "linear_attn.out_proj.weight"));
        }
    }
    prep_gm("lm_head.weight");
    for (int il = 0; il < cfg.n_layer; il++) {
        Layer& L = layers[il];
        L.mlp_gate.s_gm = gm_dev[rt.index[tn(il, "mlp.gate_proj.weight")]];
        L.mlp_up.s_gm   = gm_dev[rt.index[tn(il, "mlp.up_proj.weight")]];
        L.mlp_down.s_gm = gm_dev[rt.index[tn(il, "mlp.down_proj.weight")]];
        if (L.full) {
            L.q_proj.s_gm = gm_dev[rt.index[tn(il, "self_attn.q_proj.weight")]];
            L.k_proj.s_gm = gm_dev[rt.index[tn(il, "self_attn.k_proj.weight")]];
            L.v_proj.s_gm = gm_dev[rt.index[tn(il, "self_attn.v_proj.weight")]];
            L.o_proj.s_gm = gm_dev[rt.index[tn(il, "self_attn.o_proj.weight")]];
        } else {
            L.in_qkv.s_gm   = gm_dev[rt.index[tn(il, "linear_attn.in_proj_qkv.weight")]];
            L.in_z.s_gm     = gm_dev[rt.index[tn(il, "linear_attn.in_proj_z.weight")]];
            L.out_proj.s_gm = gm_dev[rt.index[tn(il, "linear_attn.out_proj.weight")]];
        }
    }
    lm_head.s_gm = gm_dev[rt.index["lm_head.weight"]];

    // ---- 混合模式：把 MLP 的原始 NVFP4 权重挂上去（同样只登记，不拷贝）----
    if (!nv_rows.empty()) {
        if (rp4_used) {
            // .rp4 里已经排好，直接贴指针（dev 就是那段载荷）
            attach_nvfp4_mlp(layers, nv_rows, pf, -1, &nvp_off, &nvs_off, rt.dev);
        } else if (!pack_rows.empty()) {
            attach_nvfp4_mlp(layers, nv_rows, pf, f_rt, &nvp_off, &nvs_off, rt.dev);
        } else {
            const int f_nv = pf.add_file(nv_st.c_str());
            attach_nvfp4_mlp(layers, nv_rows, pf, f_nv);
        }
    }

    // ---- 激活缓冲 ----
    d.alloc(T_MAX);

    // ---- MTP 验证批的逐 token 状态快照 ----
    lin_slot.assign(cfg.n_layer, -1);
    attn_slot.assign(cfg.n_layer, -1);
    n_lin = 0; n_attn = 0;
    for (int il = 0; il < cfg.n_layer; il++) {
        if (!cfg.is_full(il)) lin_slot[il] = n_lin++;
        else                 attn_slot[il] = n_attn++;
    }
    const size_t ssm_one = (size_t)cfg.lv_head * cfg.ldim * cfg.ldim;
    const size_t conv_one = (size_t)(cfg.conv_k - 1) * 10240;
    // 快照只在 MTP 验证批（K+1 ≤ 4 行）里用；--no-mtp 时不分配，省 ~645MB 显存。
    const bool want_snap = !mtp_path.empty() || !mtp_json.empty();
    if (want_snap && n_lin > 0) {
        CK(hipMalloc(&d.ssm_snap, (size_t)n_lin * 4 * ssm_one * 4));
        CK(hipMalloc(&d.conv_snap, (size_t)n_lin * 4 * conv_one * 4));
    }
    if (want_snap && n_attn > 0) {
        const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
        CK(hipMalloc(&d.vstage_snap, (size_t)n_attn * 4 * vs * 4));
    }

    // ---- KV cache / GDN 状态 ----
    kcache.resize(cfg.n_layer, nullptr); vcache.resize(cfg.n_layer, nullptr);
    ksc.resize(cfg.n_layer, nullptr); vsc.resize(cfg.n_layer, nullptr);
    vstage.resize(cfg.n_layer, nullptr);
    ssm_state.resize(cfg.n_layer, nullptr); conv_state.resize(cfg.n_layer, nullptr);
    const int n_tile = max_ctx / BG;
    for (int il = 0; il < cfg.n_layer; il++) {
        if (cfg.is_full(il)) {
            CK(hipMalloc(&kcache[il], (size_t)cfg.n_kv * max_ctx * (cfg.head_dim / KVEL) * 4));
            CK(hipMalloc(&ksc[il], (size_t)cfg.n_kv * 2 * max_ctx * 4));
            CK(hipMalloc(&vcache[il], (size_t)cfg.n_kv * (max_ctx / KVEL) * cfg.head_dim * 4));
            CK(hipMalloc(&vsc[il], (size_t)cfg.n_kv * n_tile * cfg.head_dim * 4));
            CK(hipMalloc(&vstage[il], (size_t)cfg.n_kv * BG * cfg.head_dim * 4));
        } else {
            const size_t sd = (size_t)cfg.lv_head * cfg.ldim * cfg.ldim;
            CK(hipMalloc(&ssm_state[il], sd * 4));
            CK(hipMalloc(&conv_state[il], (size_t)(cfg.conv_k - 1) * 10240 * 4));
        }
    }
    // 对话前缀快照（约 157MB：48 个线性层 × (3.1MB 循环状态 + 123KB 卷积状态)）
    if (n_lin > 0) {
        CK(hipMalloc(&ctx_ssm, (size_t)n_lin * ssm_one * 4));
        CK(hipMalloc(&ctx_conv, (size_t)n_lin * conv_one * 4));
    }
    CK(hipMalloc(&ctx_hprev, (size_t)cfg.hidden * 4));
    printf("模型就绪：%d 层（%d 注意力 / %d 线性），max_ctx=%d\n",
           cfg.n_layer, cfg.n_layer / cfg.full_interval, cfg.n_layer - cfg.n_layer / cfg.full_interval,
           max_ctx);
    // KV cache / 注意力操作数位宽：默认 int8（每个 dword 装 KVEL=4 个元素，尺度 amax/127）。
    // K/V 打包与 Q/P 同一通路（v_dot4_i32_i8），可用 -DKV_BITS=4 回退到 int4 做 A/B。
    printf("KV cache：int%d（KVEL=%d，每 dword %d 个元素，尺度 amax/%d），%d 个注意力层\n",
           KV_BITS, KVEL, KVEL, KVQMAX, cfg.n_layer / cfg.full_interval);
    if (!mtp_path.empty() || !mtp_json.empty()) {
        if (load_mtp(mtp_path, mtp_json)) {
            printf("MTP 就绪：1 层，草稿数 %d，KV 容量 %d，权重 %s\n", mtp_n, max_ctx,
                   mtp.w8 ? "W8A8（int8 权重 × int8 激活，hi/lo 两遍）" : "int4/128（W4A8 激活）");
        } else {
            printf("MTP 未启用（权重加载失败）\n");
        }
    }
    // ---- 全局 KV 槽池（A→B→A 切对话不丢 KV；RT_KV_POOL=0 关闭）----
    // 放在 load_mtp 之后：槽大小估算要把 MTP 的 KV 段算进去。
    {
        const int pc = getenv("RT_KV_POOL") ? atoi(getenv("RT_KV_POOL")) : 4;
        const long long pmb = getenv("RT_KV_POOL_MB") ? atoll(getenv("RT_KV_POOL_MB")) : 4096;
        kv_dims = KvDims{cfg.n_kv, cfg.head_dim, KVEL, BG, max_ctx, cfg.hidden,
                         n_lin, n_attn, (long long)ssm_one, (long long)conv_one};
        kv_pool.config(pc, pmb > 0 ? (size_t)pmb * 1024 * 1024 : 0);
        kv_pool.free_dev = [](void* p) { if (p) hipFree(p); };
        kv_trace = getenv("RT_KV_TRACE") && atoi(getenv("RT_KV_TRACE")) != 0;
        const size_t one8k = KvPool::layout(kv_dims, 8192, 8191, true, mtp_on, nullptr) +
                             kv_vstage_bytes();
        printf("KV 池：%d 槽 / %.1f GB 上限（约 %.0f MB/8k 会话）%s\n",
               kv_pool.cap, kv_pool.cap_bytes / 1073741824.0, one8k / 1048576.0,
               kv_pool.cap > 0 ? "" : "【已关闭】");
    }
    // ---- 所有预取项都登记完了，启动后台加载 ----
    // 这里立即返回：服务可以马上开始接受请求，第一次前向会按层等数据到位。
    pf.start();
    if (pf.async())
        printf("权重正在后台按层加载（%.2f GB）；服务已可用，第一次请求会与加载重叠\n",
               rt.dev_size / 1e9);
}

// 加载 MTP 头（独立 RT4 文件，15 张量 / 0.22GB）。权重命名与 HF 一致：
//   mtp.fc.weight, mtp.layers.0.*, mtp.norm.weight,
//   mtp.pre_fc_norm_{embedding,hidden}.weight
bool Model::load_mtp(const std::string& path, const std::string& json) {
    if (rp4_used) {
        rt4_from_rp4(mtp_rt, rp4, "mtp", rp4.dev);      // .rp4 里已经带着 MTP
    } else {
        if (path.empty() || json.empty()) return false;
        mtp_rt.load(path, json);
        mtp_rt.upload();
    }

    auto MW = [&](const std::string& n) -> Wq {
        const RT4Tensor* t = mtp_rt.find(n);
        if (!t) { printf("MTP 缺张量 %s\n", n.c_str()); exit(1); }
        if (t->kind != "i4") { printf("MTP 权重 %s 不是 i4（%s）\n", n.c_str(), t->kind.c_str()); exit(1); }
        Wq w;
        w.q = mtp_rt.qptr(t); w.s = mtp_rt.sptr(t);
        w.N = (int)t->N; w.K = (int)t->K; w.group = (int)t->group;
        return w;
    };
    auto MF = [&](const std::string& n) -> Wf {
        const RT4Tensor* t = mtp_rt.find(n);
        if (!t) { printf("MTP 缺张量 %s\n", n.c_str()); exit(1); }
        Wf w;
        if (t->kind == "f16") {
            const uint16_t* src = (const uint16_t*)mtp_rt.hptr(t->q_off);
            const int cnt = (int)(t->nbytes / 2);
            std::vector<float> tmp(cnt);
            for (int i = 0; i < cnt; i++) {
                const uint16_t h = src[i];
                const uint32_t sg = (h >> 15) & 1, ex = (h >> 10) & 0x1F, ma = h & 0x3FF;
                const float f = ex == 0 ? ldexpf(ma / 1024.f, -14)
                                        : ldexpf(1.f + ma / 1024.f, (int)ex - 15);
                tmp[i] = sg ? -f : f;
            }
            float* dp; CK(hipMalloc(&dp, (size_t)cnt * 4));
            CK(hipMemcpy(dp, tmp.data(), (size_t)cnt * 4, hipMemcpyHostToDevice));
            w.p = dp; w.n = cnt;
        } else {
            const int cnt = (int)(t->nbytes / 4);
            float* dp; CK(hipMalloc(&dp, (size_t)cnt * 4));
            CK(hipMemcpy(dp, mtp_rt.hptr(t->q_off), (size_t)cnt * 4, hipMemcpyHostToDevice));
            w.p = dp; w.n = cnt;
        }
        return w;
    };
    auto pgm = [&](Wq& w, const char* n) {
        const RT4Tensor* t = mtp_rt.find(n);
        if (!t) { printf("MTP 缺张量 %s\n", n); exit(1); }
        std::vector<float> gm = make_group_major(mtp_rt, t);
        if (gm.empty()) { printf("MTP 张量 %s 的组尺度为空\n", n); exit(1); }
        CK(hipMalloc(&w.s_gm, gm.size() * 4));
        CK(hipMemcpy(w.s_gm, gm.data(), gm.size() * 4, hipMemcpyHostToDevice));
    };

    // W8A8 的权重文件里每张 int4 矩阵都拆成了 <name>.hi / <name>.lo（tools/mtp_w8_pack.py），
    // 靠这一点自动识别；RT_MTP_W8=1 只是在 main 里把默认路径指到 w8 文件。
    mtp.w8 = (mtp_rt.find("mtp.fc.weight") == nullptr);
    {
        const char* e = getenv("RT_MTP_W8");
        if (e && atoi(e) != 0 && !mtp.w8)
            printf("MTP: RT_MTP_W8=1 但权重不是 .hi/.lo 拆分格式，按普通 int4 加载\n");
    }

    // 一张逻辑矩阵：hi 半边（w8 时名字带 .hi），可选地再挂上 lo 半边
    auto MW8 = [&](Wq& hi, Wq* lo, const char* n) {
        const std::string base = n;
        const std::string hn = mtp.w8 ? base + ".hi" : base;
        hi = MW(hn);
        pgm(hi, hn.c_str());
        if (mtp.w8 && lo) {
            const std::string ln = base + ".lo";
            *lo = MW(ln);
            pgm(*lo, ln.c_str());
        }
    };

    mtp.pre_norm_embedding = MF("mtp.pre_fc_norm_embedding.weight");
    mtp.pre_norm_hidden = MF("mtp.pre_fc_norm_hidden.weight");
    mtp.norm = MF("mtp.norm.weight");
    mtp.in_ln = MF("mtp.layers.0.input_layernorm.weight");
    mtp.post_ln = MF("mtp.layers.0.post_attention_layernorm.weight");
    mtp.q_norm = MF("mtp.layers.0.self_attn.q_norm.weight");
    mtp.k_norm = MF("mtp.layers.0.self_attn.k_norm.weight");
    MW8(mtp.fc, &mtp.fc_lo, "mtp.fc.weight");
    MW8(mtp.q_proj, &mtp.q_lo, "mtp.layers.0.self_attn.q_proj.weight");
    MW8(mtp.k_proj, &mtp.k_lo, "mtp.layers.0.self_attn.k_proj.weight");
    MW8(mtp.v_proj, &mtp.v_lo, "mtp.layers.0.self_attn.v_proj.weight");
    MW8(mtp.o_proj, &mtp.o_lo, "mtp.layers.0.self_attn.o_proj.weight");
    MW8(mtp.mlp_gate, &mtp.mlp_gate_lo, "mtp.layers.0.mlp.gate_proj.weight");
    MW8(mtp.mlp_up, &mtp.mlp_up_lo, "mtp.layers.0.mlp.up_proj.weight");
    MW8(mtp.mlp_down, &mtp.mlp_down_lo, "mtp.layers.0.mlp.down_proj.weight");

    const int KV = cfg.n_kv, D = cfg.head_dim;
    CK(hipMalloc(&mtp_kc, (size_t)KV * max_ctx * (D / KVEL) * 4));
    CK(hipMalloc(&mtp_ksc, (size_t)KV * 2 * max_ctx * 4));
    CK(hipMalloc(&mtp_vc, (size_t)KV * (max_ctx / KVEL) * D * 4));
    CK(hipMalloc(&mtp_vsc, (size_t)KV * (max_ctx / BG) * D * 4));
    CK(hipMalloc(&mtp_vstage, (size_t)KV * BG * D * 4));
    CK(hipMalloc(&d.mtp_vstage_snap, (size_t)9 * KV * BG * D * 4));
    mtp.loaded = true;
    mtp_on = true;
    return true;
}

void Model::reset_state() {
    seq_len = 0;
    mtp_len = 0;
    ctx_ids.clear();
    ctx_snap_len = -1;
    ctx_snap_valid = false;
    kv_pool.drop_active();          // 活跃上下文清零：不再对应任何槽（槽内容保留待回港）
    for (int il = 0; il < cfg.n_layer; il++) {
        if (cfg.is_full(il)) {
            // KV 的尺度数组要初始化（未写的 tile 不能是 NaN）
            k_fill(ksc[il], 1.f, (long long)cfg.n_kv * 2 * max_ctx);
            k_fill(vsc[il], 1.f, (long long)cfg.n_kv * (max_ctx / BG) * cfg.head_dim);
        } else {
            k_fill(ssm_state[il], 0.f, (long long)cfg.lv_head * cfg.ldim * cfg.ldim);
            k_fill(conv_state[il], 0.f, (long long)(cfg.conv_k - 1) * 10240);
        }
    }
    if (mtp_on) {
        k_fill(mtp_ksc, 1.f, (long long)cfg.n_kv * 2 * max_ctx);
        k_fill(mtp_vsc, 1.f, (long long)cfg.n_kv * (max_ctx / BG) * cfg.head_dim);
    }
    CK(hipMemset(d.qq, 0, (size_t)24 * (((T_MAX + 63) / 64) * 64) * (256 / KVEL) * 4));
    k_fill(d.qs, 1.f, (long long)24 * 2 * (((T_MAX + 63) / 64) * 64));
    k_fill(d.h_prev, 0.f, (long long)cfg.hidden);
    CK(hipDeviceSynchronize());
}

// 线性层：M 小（≤4）走 W4A8 解码 GEMV，M 大走 W4A8 GEMM（激活 8bit）。
// 权重一律是 int4（RT4）；激活 8bit 是质量与速度的折中：解码是带宽瓶颈，int8 激活
// 不额外花带宽；预填充要多跑一遍 int4 GEMM（约 2 倍算力代价），但每层误差从
// int4 激活的 12~16% 降到 ~1.4%（实测 tools/ref_stages.py + build/qtest.py）。
// RT_ACT4=1 可以强制回退到纯 int4 激活（只用于性能对照）。
void Model::linear_quant(float* y, const Wq& w, const float* x, int M,
                         u32* aq, float* asc, int row_stride, int row_off) {
    // 混合模式：这份权重有原始 NVFP4，就直接跑 NVFP4 内核（激活按 16 一组量化）。
    if (w.has_nvfp4()) {
        if (row_stride != 0) { printf("nvfp4: 暂不支持 row_stride=%d\n", row_stride); exit(1); }
        if (M <= 4) k_nvfp4_gemv(y, w.nvp, w.nvs, 1.f / w.nvgs, x + row_off, M, w.N, w.K);
        else        k_nvfp4_gemm(y, w.nvp, w.nvs, 1.f / w.nvgs, x + row_off, M, w.N, w.K);
        return;
    }
    static const int act4 = getenv("RT_ACT4") ? atoi(getenv("RT_ACT4")) : 0;
    if (M <= 4) {
        if (act4) k_gemv_w4a4(y, w.q, w.s, x + row_off, M, w.N, w.K);
        else      k_gemv_w4a8(y, w.q, w.s, x + row_off, M, w.N, w.K);
    } else {
        const int Mp = ((M + BM_ALIGN - 1) / BM_ALIGN) * BM_ALIGN;   // GEMM 的 M 必须对齐
        if (act4) {
            k_quant_rows(aq, asc, x + row_off, Mp, w.K, w.group);
            k_gemm_i4(y, w.q, w.s_gm, aq, asc, Mp, w.N, w.K);
        } else {
            k_quant_rows_a8(d.aq_h, d.aq_l, d.asc8, d.asc16, x + row_off, Mp, w.K, w.group);
            k_gemm_i4_a8(y, d.c_tmp, w.q, w.s_gm, d.aq_h, d.aq_l, d.asc8, d.asc16,
                         Mp, w.N, w.K);
        }
    }
}
void Model::linear(float* y, const Wq& w, const float* x, int M) {
    // 激活量化暂存：按最大 K（17408）与 T_MAX 预留
    ProfTick _t(pa(P_LINEAR));
    linear_quant(y, w, x, M, d.aq_big, d.asc_big, 0, 0);
}


// ------------------------------ 注意力层 -----------------------------------
// Qwen3.5 全注意力：q_proj 每头出 [q(256), gate(256)]，q/k 各自 RMSNorm(256)、
// 部分 RoPE(前 64 维)、int4 FlashAttention、再乘 sigmoid(gate)、过 o_proj。
void Model::attention_layer(int il, int n) {
    Layer& L = layers[il];
    const int T = n, H = cfg.n_head, KV = cfg.n_kv, D = cfg.head_dim;
    const int pd = H * D * 2, qd = H * D;
    const int n_kv = seq_len + T;
    const int TP = ((T + 63) / 64) * 64;

    if (getenv("RT_TRACE")) printf("    [trace] attn layer %d T=%d seq_len=%d\n", il, T, seq_len);
    linear(d.qfull, L.q_proj, d.xb, T);          // [T][12288] = 每头 [q(256) gate(256)]
    linear(d.hkk, L.k_proj, d.xb, T);            // [T][1024] = [T][4][256]
    linear(d.hvv, L.v_proj, d.xb, T);
    db(il, 1, d.qfull, (long long)T * pd);
    db(il, 4, d.hkk, (long long)T * KV * D);
    db(il, 5, d.hvv, (long long)T * KV * D);

    {
        ProfTick _t(pa(P_ATTNPRE));
        // q_proj 每个头出 [q(256), gate(256)]，所以头间距是 2D，头内偏移 0 / D
        k_gather_heads(d.hq, d.qfull, T, H, D, pd, 0, 2 * D);      // q 抽成 [T][24][256]
        k_gather_heads(d.hgate, d.qfull, T, H, D, pd, D, 2 * D);   // gate 同上
        db(il, 3, d.hgate, (long long)T * H * D);
        k_rmsnorm(d.hq, d.hq, (const float*)L.q_norm.p, T * H, D, cfg.eps, true);
        k_rmsnorm(d.hkk, d.hkk, (const float*)L.k_norm.p, T * KV, D, cfg.eps, true);

        // 位置直接由 seq_len 推出来（原来每层都 hipMalloc + 阻塞 H2D + hipFree）
        k_rope(d.hq, d.hkk, nullptr, seq_len, T, T, H, KV, D, cfg.rot, cfg.rope_theta);
        db(il, 6, d.hkk, (long long)T * KV * D);      // k：rmsnorm + rope 之后

        // HF 的 attention scaling：scores 乘 1/sqrt(head_dim)，折进 Q 最省事
        k_scale(d.hq, 1.f / sqrtf((float)D), (long long)T * H * D);
        db(il, 2, d.hq, (long long)T * H * D);        // 已含 rmsnorm + rope + scale
    }

    {
        ProfTick _t(pa(P_QK));
        // 注意：Q 的尺度数组布局必须和 FA 内核读的一致（Qscg[g*n_q + row]，n_q=TP 是
        // 补齐后的行数），所以尺度按 TP 行写；按 T 行写会让 T 不是 64 倍数时整段错位。
        // 只量化真实的 T 行（解码时 T=1，原来按 TP=64 行做，白跑 63/64），
        // 补齐行保持 reset_state 的 0/1，FA 逐行独立、输出会被 scatter 丢掉。
        k_attn_q_quant(d.qq, d.qs, d.hq, T, H, D, 128, TP);
        k_kv_append_k(kcache[il], ksc[il], d.hkk, seq_len, T, KV, D, 128, max_ctx);
        if (!snap_mode) {
            ProfTick _t2(pa(P_KV));
            k_kv_append_v(vcache[il], vsc[il], vstage[il], d.hvv, seq_len, T, KV, D, BG,
                          max_ctx);
        }
        }
    if (getenv("RT_DUMP_ATTN") && il == atoi(getenv("RT_DUMP_ATTN"))) {
        // 把 FA 的输入原样落盘（不含补齐的尾部），给 tools/attn_check.py 逐元素核对
        const int nk = std::min(max_ctx, ((n_kv + 63) / 64) * 64);
        const size_t qb = (size_t)H * TP * (D / KVEL) * 4;
        dump_raw("build/attn_qq.bin", d.qq, qb);
        dump_raw("build/attn_qs.bin", d.qs, (size_t)H * 2 * TP * 4);
        // KV cache 按**分配容量** max_ctx 做行距，所以整块导出（前 nk 个 key 用得上）
        dump_raw("build/attn_k.bin", kcache[il], (size_t)KV * max_ctx * (D / KVEL) * 4);
        dump_raw("build/attn_ks.bin", ksc[il], (size_t)KV * 2 * max_ctx * 4);
        dump_raw("build/attn_v.bin", vcache[il], (size_t)KV * (max_ctx / KVEL) * D * 4);
        dump_raw("build/attn_vs.bin", vsc[il], (size_t)KV * (max_ctx / BG) * D * 4);
        printf("  [attn] 层 %d T=%d 的 FA 输入已导出（K 取前 %d 个 key）\n", il, T, nk);
    }
    {
        ProfTick _t(pa(P_FA));
        if (snap_mode && T <= 4) {
            // MTP 验证批：为保证与单 token 解码完全同算术（fp32 P），仍走解码内核。
            // 预填充 FA 的 P 是 4bit，用它校验会让接受/回滚后的轨迹与普通解码漂移。
            // 逐行追加 + 快照 V tile 尺度（回滚时逐行恢复），再一次性算完 T 行：
            // 每行的算术与单行内核逐位相同，但 KV 只读一遍、T 行并行（见 src/k_fa.hip）。
            for (int r = 0; r < T; r++) {
                // V 的 tile 尺度按前缀重算：逐行追加，复现单 token 解码时的量化。
                { ProfTick _t2(pa(P_KV));
                  k_kv_append_v(vcache[il], vsc[il], vstage[il],
                                d.hvv + (size_t)r * KV * D, seq_len + r, 1, KV, D, BG,
                                max_ctx); }
                {
                    const size_t vs = (size_t)KV * BG * D;
                    CK(hipMemcpyAsync(d.vstage_snap +
                                      ((size_t)attn_slot[il] * 4 + r) * vs,
                                      vstage[il], vs * 4, hipMemcpyDeviceToDevice, 0));
                }
            }
            // Vsnap 传每行 append 之后的 fp32 V tile 暂存：内核用它按「本行 prefix」
            // 重算最后一格的 V 量化，才能与逐 token 解码逐位相同。
            const size_t vs = (size_t)KV * BG * D;
            const int seq_mode = getenv("RT_VERIFY_SEQ") ? atoi(getenv("RT_VERIFY_SEQ")) : 0;
            if (seq_mode == 1) {                     // 诊断用：逐行调用（慢，等价性 A/B）
                for (int r = 0; r < T; r++) {
                    k_attention_decode_rows(d.hfa + (size_t)r * D,
                                            d.qq + (size_t)r * (D / KVEL), d.qs + r,
                                            kcache[il], ksc[il], vcache[il], vsc[il],
                                            d.vstage_snap +
                                                ((size_t)attn_slot[il] * 4 + r) * vs,
                                            0, TP, 1, seq_len + r + 1, H, H / KV, max_ctx,
                                            d.fa_pout, d.fa_pmax, d.fa_psum, fa_max_split());
                }
            } else {
                k_attention_decode_rows(d.hfa, d.qq, d.qs, kcache[il], ksc[il], vcache[il],
                                        vsc[il], d.vstage_snap + (size_t)attn_slot[il] * 4 * vs,
                                        vs, TP, T, seq_len + 1, H, H / KV, max_ctx,
                                        d.fa_pout, d.fa_pmax, d.fa_psum, fa_max_split());
            }
        } else {
            // FA 内核用 n_q 同时算「头内偏移」，所以要传补齐到 64 的 TP，否则各头输出互相踩
            k_attention(d.hfa, d.qq, d.qs, kcache[il], ksc[il], vcache[il], vsc[il],
                        TP, T, n_kv, seq_len, (n_kv + BG - 1) / BG, H, H / KV, max_ctx,
                        d.fa_pout, d.fa_pmax, d.fa_psum, fa_max_split());
        }
    }
    // 注意：输出必须在**注意力跑完之后**导出（以前放在前面，落盘的是上一次的陈旧值）
    if (getenv("RT_DUMP_ATTN") && il == atoi(getenv("RT_DUMP_ATTN")))
        dump_raw("build/attn_out.bin", d.hfa, (size_t)H * TP * D * 4);
    // 诊断用：验证批（T≥2）的注意力输出，用来对比「逐行顺序」与「一次算完」两条路。
    db(il, 7, d.hfa, (long long)H * TP * D);
    {
        ProfTick _t(pa(P_NORM));
        k_scatter_heads(d.hout, d.hfa, T, H, D, qd, 0, TP);
        k_sigmoid_mul(d.hout, d.hout, d.hgate, (long long)T * qd);
    }
    db(il, 8, d.hout, (long long)T * qd);
    linear(d.gz, L.o_proj, d.hout, T);
    db(il, 9, d.gz, (long long)T * cfg.hidden);
    k_add_inplace(d.x, d.gz, (long long)T * cfg.hidden);
}

// --------------------------- 线性注意力（GDN）-------------------------------
void Model::gdn_layer(int il, int n) {
    Layer& L = layers[il];
    const int T = n, Hk = cfg.lk_head, Hv = cfg.lv_head, D = cfg.ldim;
    const int qn = Hk * D, vn = Hv * D;

    linear(d.qkv3, L.in_qkv, d.xb, T);           // [T][10240] = [q(2048) k(2048) v(6144)]
    linear(d.gz, L.in_z, d.xb, T);               // z [T][6144]
    db(il, 1, d.qkv3, (long long)T * (qn * 2 + vn));
    db(il, 2, d.gz, (long long)T * vn);
    {
        ProfTick _t(pa(P_CONV));
        // 卷积要读「更新前」的状态，所以先快照
        CK(hipMemcpyAsync(d.conv_prev, conv_state[il],
                          (size_t)(cfg.conv_k - 1) * (qn * 2 + vn) * 4,
                          hipMemcpyDeviceToDevice, 0));
        k_conv1d_silu(d.conv, d.qkv3, (const float*)L.conv1d.p, d.conv_prev, T, qn * 2 + vn,
                      cfg.conv_k);
        if (snap_mode) {
            const size_t conv_one = (size_t)(cfg.conv_k - 1) * (qn * 2 + vn);
            float* snap = d.conv_snap + (size_t)lin_slot[il] * 4 * conv_one;
            k_conv_state_update_snap(conv_state[il], snap, d.qkv3, d.conv_prev, T,
                                     qn * 2 + vn, cfg.conv_k);
        } else {
            k_conv_state_update(conv_state[il], d.qkv3, d.conv_prev, T, qn * 2 + vn, cfg.conv_k);
        }
    }
    db(il, 3, d.conv, (long long)T * (qn * 2 + vn));
    {
        ProfTick _t(pa(P_GNORM));
        k_split_qkv(d.gq, d.gk, d.gv, d.conv, T, qn, qn, vn);
        k_l2norm(d.gq, T * Hk, D, cfg.eps);
        k_l2norm(d.gk, T * Hk, D, cfg.eps);
    }
    db(il, 4, d.gq, (long long)T * qn);
    db(il, 5, d.gk, (long long)T * qn);
    db(il, 6, d.gv, (long long)T * vn);

    {
        ProfTick _t(pa(P_SSM));
        k_ssm_ab_gate(d.gab, d.gbeta, d.gg, (const float*)L.ssm_alpha.p,
                      (const float*)L.ssm_beta.p, d.xb, (const float*)L.dt_bias.p,
                      (const float*)L.a_log.p, T, Hv, cfg.hidden);
    }
    db(il, 7, d.gab, (long long)2 * T * Hv);     // a | b（b 还是 logits）
    db(il, 8, d.gbeta, (long long)T * Hv);       // beta
    db(il, 9, d.gg, (long long)T * Hv);                     // g
    {
        ProfTick _t(pa(P_GDNA));
        if (snap_mode) {
            const size_t ssm_one = (size_t)Hv * D * D;
            float* snap = d.ssm_snap + (size_t)lin_slot[il] * 4 * ssm_one;
            k_gdn_snap(d.hout, d.gq, d.gk, d.gv, d.gg, d.gbeta, ssm_state[il], snap,
                       T, Hk, Hv, D, Hv / Hk);
        } else {
            k_gdn(d.hout, d.gq, d.gk, d.gv, d.gg, d.gbeta, ssm_state[il],
                  T, Hk, Hv, D, Hv / Hk);
        }
    }
    db(il, 10, d.hout, (long long)T * vn);
    {
        ProfTick _t(pa(P_GNORM));
        k_rmsnorm_gated(d.hout, d.hout, (const float*)L.ssm_norm.p, d.gz, T * Hv, D, cfg.eps);
    }
    db(il, 11, d.hout, (long long)T * vn);
    linear(d.gz, L.out_proj, d.hout, T);
    db(il, 12, d.gz, (long long)T * cfg.hidden);
    k_add_inplace(d.x, d.gz, (long long)T * cfg.hidden);
}

// --------------------------------- MLP -------------------------------------
void Model::mlp_layer(int il, int n) {
    Layer& L = layers[il];
    linear(d.m_gate, L.mlp_gate, d.xb, n);
    linear(d.m_up, L.mlp_up, d.xb, n);
    db(il, 21, d.m_gate, (long long)n * cfg.inter);
    db(il, 22, d.m_up, (long long)n * cfg.inter);
    {
        ProfTick _t(pa(P_NORM));
        k_silu_mul(d.m_gate, d.m_gate, d.m_up, (long long)n * cfg.inter);
    }
    db(il, 23, d.m_gate, (long long)n * cfg.inter);
    linear(d.gz, L.mlp_down, d.m_gate, n);
    db(il, 24, d.gz, (long long)n * cfg.hidden);
    k_add_inplace(d.x, d.gz, (long long)n * cfg.hidden);
}

// -------------------------------- 前向 -------------------------------------
// log_rows=0：只算最后一行（log_last 为真时）；log_rows>0：算前 log_rows 行的 logits
// （MTP 验证批最多 4 行）。extend_mtp=false 用于验证批：不更新 MTP 上下文，交由
// 引擎按接受长度回滚。snap_states=true 时 GDN/卷积保存逐 token 状态快照。
void Model::forward(const int* ids, int n, bool log_last, int log_rows, bool extend_mtp,
                    bool snap_states, const EmbSpan* emb_spans, int n_emb_spans, int base_off) {
    const int base = seq_len;
    pf.wait_group(0);            // embedding（组 0）必须先到
    // 常驻缓冲 + 异步拷贝：原来每步都 hipMalloc/hipFree + 同步 H2D
    CK(hipMemcpyAsync(d.dids, ids, (size_t)n * 4, hipMemcpyHostToDevice, 0));
    { ProfTick _t(pa(P_EMBED));
      k_embed(d.x, embed.q, (const unsigned short*)embed.s, d.dids, n, cfg.hidden, 128); }
    // 视觉塔 embedding：在 k_embed 之后覆盖对应行（同一条 stream，顺序有保证）。
    for (int si = 0; si < n_emb_spans; si++) {
        const EmbSpan& s = emb_spans[si];
        const int a = std::max(s.start, base_off);
        const int b = std::min(s.start + s.count, base_off + n);
        if (b <= a) continue;
        CK(hipMemcpyAsync(d.x + (size_t)(a - base_off) * cfg.hidden,
                          s.data + (size_t)(a - s.start) * cfg.hidden,
                          (size_t)(b - a) * cfg.hidden * sizeof(float),
                          hipMemcpyHostToDevice, 0));
    }
    if (stats) print_stats(-1, n);
    if (dump_layers && std::find(dump_layers->begin(), dump_layers->end(), -1) != dump_layers->end())
        dump_x(-1, n);
    snap_mode = snap_states;
    if (snap_states && !d.ssm_snap) {
        printf("forward: 需要逐 token 状态快照，但未分配（MTP 未启用）\n");
        exit(1);
    }
    for (int il = 0; il < cfg.n_layer; il++) {
        pf.wait_group(1 + il);   // 这一层的权重到了再算；加载线程同时在搬下一层
        { ProfTick _t(pa(P_NORM));
          k_rmsnorm(d.xb, d.x, (const float*)layers[il].in_ln.p, n, cfg.hidden, cfg.eps, true); }
        if (layers[il].full) attention_layer(il, n); else gdn_layer(il, n);
        { ProfTick _t(pa(P_NORM));
          k_rmsnorm(d.xb, d.x, (const float*)layers[il].post_ln.p, n, cfg.hidden, cfg.eps, true); }
        mlp_layer(il, n);
        if (stats) print_stats(il, n);
        if (dump_layers && std::find(dump_layers->begin(), dump_layers->end(), il) != dump_layers->end())
            dump_x(il, n);
    }
    snap_mode = false;
    // lm_head / 其余全局权重；.rp4 模式下 MTP 和视觉塔也在同一文件的后段，
    // 一并等完（首次前向多等约 1.1GB，换来不需要给它们各加一道闸门）
    pf.wait_group(rp4_used ? rp4_last_group : 66);
    { ProfTick _t(pa(P_HEAD));
      k_rmsnorm(d.h_norm, d.x, (const float*)out_norm.p, n, cfg.hidden, cfg.eps, true);
      static const int act4 = getenv("RT_ACT4") ? atoi(getenv("RT_ACT4")) : 0;
      if (log_rows > 0) {
          if (log_rows > 4) { printf("forward: log_rows=%d > 4\n", log_rows); exit(1); }
          if (act4) k_gemv_w4a4(d.logits_all, lm_head.q, lm_head.s, d.h_norm, log_rows,
                                lm_head.N, lm_head.K);
          else      k_gemv_w4a8(d.logits_all, lm_head.q, lm_head.s, d.h_norm, log_rows,
                                lm_head.N, lm_head.K);
      } else if (log_last) {
          const float* last = d.h_norm + (size_t)(n - 1) * cfg.hidden;
          if (act4) k_gemv_w4a4(d.logits, lm_head.q, lm_head.s, last, 1, lm_head.N, lm_head.K);
          else      k_gemv_w4a8(d.logits, lm_head.q, lm_head.s, last, 1, lm_head.N, lm_head.K);
      } }
    if (mtp_on && extend_mtp) {
        ProfTick _t(pa(P_MTP));
        mtp_extend_context(d.dids, n, base);
        CK(hipMemcpyAsync(d.h_prev, d.h_norm + (size_t)(n - 1) * cfg.hidden,
                          (size_t)cfg.hidden * 4, hipMemcpyDeviceToDevice, 0));
    }
    prof_tokens++;
    seq_len += n;
}

// -------------------------------- MTP --------------------------------
// MTP 的线性层，支持 W8A8：hi/lo 各跑一遍 int4 linear 再相加。
// pack 时 hi 的组尺度已经乘了 16，所以
//   s*16*Σwh·a + s*Σwl·a = s*Σ(16wh+wl)·a = s*Σw8·a
// 就是「int8 权重 × int8 激活」（激活两遍用同一份量化，误差只有 fp32 舍入）。
void Model::mtp_linear(float* y, const Wq& hi, const Wq& lo, const float* x, int T) {
    linear(y, hi, x, T);
    if (!mtp.w8) return;
    linear(d.mtp_lin2, lo, x, T);
    k_add_inplace(y, d.mtp_lin2, (long long)T * hi.N);
}

// 跑一层 MTP：输入 rows 个 (token, hidden) 对，hidden 是主模型最终 norm 后的隐藏态
// （第一层 MTP 深度）或上一轮 MTP 输出（链式草稿）。函数会把这些行追加进 MTP 自己的
// KV，并在 rows==1 且 want_logits 时输出 lm_head logits 的 argmax。
void Model::mtp_layer_rows(const int* ids_dev, const float* hin, int rows, int pos0,
                           bool want_logits, int* argmax_out) {
    // 同 IMG_EMB：.rp4 模式下 MTP 权重也在载荷后段，先等这一组到齐
    pf.wait_group(rp4_used ? rp4_last_group : 66);
    if (!mtp_on || rows <= 0) return;
    const int T = rows, H = cfg.hidden, HD = cfg.head_dim, KV = cfg.n_kv;
    const int TP = ((T + 63) / 64) * 64;
    const int qd = cfg.n_head * HD;
    const int t0 = mtp_len;
    // 这一层整体记一个 tick：草稿链以前完全没有分阶段计时，它那块时间在 profile 里
    // 是「消失」的（每轮 ~8 ms 不落在任何 bucket 里）。外层 tick 之后，下面没被
    // 单独 tick 的算子都归到 mtp-draft，内层的 linear/attention/head 仍各归各的。
    ProfTick _t_draft(pa(P_MTPD));

    // 下面既是 RT_PROF 的 tick，也带 RT_MTP_SKIP 的位掩码（后者**只用于量各段开销**，
    // 跳过某段后结果必然是错的，所以只在 MTPBENCH 里用）：
    //   1=embed/pre-norm/concat  2=q_norm/k_norm/rope/scale（qkv 投影本身不跳）
    //   4=Q 量化+KV 写入         8=注意力+scatter+sigmoid
    //   16=o_proj 后的 add/post-norm   32=silu   64=down 后的 add/final-norm
    static const int mtp_skip = getenv("RT_MTP_SKIP") ? atoi(getenv("RT_MTP_SKIP")) : 0;
#define MTP_ON(b) ((mtp_skip & (b)) == 0)
    if (MTP_ON(1)) {
        ProfTick _t(pa(P_EMBED));
        k_embed(d.mtp_e, embed.q, (const unsigned short*)embed.s, ids_dev, T, H, 128);
        k_rmsnorm(d.mtp_e, d.mtp_e, (const float*)mtp.pre_norm_embedding.p, T, H, cfg.eps, true);
        k_rmsnorm(d.mtp_hn, hin, (const float*)mtp.pre_norm_hidden.p, T, H, cfg.eps, true);
        k_concat2(d.mtp_cat, d.mtp_e, d.mtp_hn, T, H);
    }
    mtp_linear(d.mtp_fc, mtp.fc, mtp.fc_lo, d.mtp_cat, T);

    // ---- 与主模型 full attention 相同的一层 ----
    if (MTP_ON(2)) { ProfTick _t(pa(P_NORM));
        k_rmsnorm(d.xb, d.mtp_fc, (const float*)mtp.in_ln.p, T, H, cfg.eps, true); }
    mtp_linear(d.qfull, mtp.q_proj, mtp.q_lo, d.xb, T);
    mtp_linear(d.hkk, mtp.k_proj, mtp.k_lo, d.xb, T);
    mtp_linear(d.hvv, mtp.v_proj, mtp.v_lo, d.xb, T);
    if (MTP_ON(2)) { ProfTick _t(pa(P_ATTNPRE));
        k_gather_heads(d.hq, d.qfull, T, cfg.n_head, HD, 2 * qd, 0, 2 * HD);
        k_gather_heads(d.hgate, d.qfull, T, cfg.n_head, HD, 2 * qd, HD, 2 * HD);
        k_rmsnorm(d.hq, d.hq, (const float*)mtp.q_norm.p, T * cfg.n_head, HD, cfg.eps, true);
        k_rmsnorm(d.hkk, d.hkk, (const float*)mtp.k_norm.p, T * KV, HD, cfg.eps, true);
        k_rope(d.hq, d.hkk, nullptr, pos0, T, T, cfg.n_head, KV, HD, cfg.rot, cfg.rope_theta);
        k_scale(d.hq, 1.f / sqrtf((float)HD), (long long)T * cfg.n_head * HD); }
    if (MTP_ON(4)) { ProfTick _t(pa(P_QK)); k_attn_q_quant(d.qq, d.qs, d.hq, T, cfg.n_head, HD, 128, TP); }
    if (MTP_ON(4)) {
        ProfTick _t(pa(P_KV));
        k_kv_append_k(mtp_kc, mtp_ksc, d.hkk, t0, T, KV, HD, 128, max_ctx);
        k_kv_append_v(mtp_vc, mtp_vsc, mtp_vstage, d.hvv, t0, T, KV, HD, BG, max_ctx);
    }
    const int n_kv = t0 + T;
    if (MTP_ON(8)) {
        ProfTick _t(pa(P_FA));
        k_attention(d.hfa, d.qq, d.qs, mtp_kc, mtp_ksc, mtp_vc, mtp_vsc,
                    TP, T, n_kv, t0, (n_kv + BG - 1) / BG, cfg.n_head, cfg.n_head / KV,
                    max_ctx, d.fa_pout, d.fa_pmax, d.fa_psum, fa_max_split());
    }
    if (MTP_ON(8)) {
        ProfTick _t(pa(P_ATTNPRE));
        k_scatter_heads(d.hout, d.hfa, T, cfg.n_head, HD, qd, 0, TP);
        k_sigmoid_mul(d.hout, d.hout, d.hgate, (long long)T * qd);
    }
    mtp_linear(d.mtp_tmp, mtp.o_proj, mtp.o_lo, d.hout, T);
    if (MTP_ON(16)) { ProfTick _t(pa(P_NORM)); k_add_inplace(d.mtp_tmp, d.mtp_fc, (long long)T * H); }

    // ---- MLP ----
    if (MTP_ON(16)) { ProfTick _t(pa(P_NORM)); k_rmsnorm(d.xb, d.mtp_tmp, (const float*)mtp.post_ln.p, T, H, cfg.eps, true); }
    mtp_linear(d.m_gate, mtp.mlp_gate, mtp.mlp_gate_lo, d.xb, T);
    mtp_linear(d.m_up, mtp.mlp_up, mtp.mlp_up_lo, d.xb, T);
    if (MTP_ON(32)) { ProfTick _t(pa(P_NORM)); k_silu_mul(d.m_gate, d.m_gate, d.m_up, (long long)T * cfg.inter); }
    mtp_linear(d.gz, mtp.mlp_down, mtp.mlp_down_lo, d.m_gate, T);
    if (MTP_ON(64)) {
        ProfTick _t(pa(P_NORM));
        k_add_inplace(d.gz, d.mtp_tmp, (long long)T * H);
        k_rmsnorm(d.mtp_out, d.gz, (const float*)mtp.norm.p, T, H, cfg.eps, true);
    }

    if (want_logits) {
        if (T != 1) { printf("mtp_layer_rows: want_logits 只支持 1 行\n"); exit(1); }
        const int act4 = getenv("RT_ACT4") ? atoi(getenv("RT_ACT4")) : 0;
        {
            ProfTick _t(pa(P_HEAD));
            if (act4) k_gemv_w4a4(d.mtp_logits, lm_head.q, lm_head.s, d.mtp_out, 1,
                                  lm_head.N, lm_head.K);
            else      k_gemv_w4a8(d.mtp_logits, lm_head.q, lm_head.s, d.mtp_out, 1,
                                  lm_head.N, lm_head.K);
        }
        { ProfTick _t(pa(P_SAMPLE)); if (argmax_out) k_argmax(d.mtp_logits, 248320, argmax_out); }
    }
    mtp_len += T;
}

int Model::mtp_draft_one(int token, const float* hin, int snap_slot) {
    CK(hipMemcpyAsync(d.mtp_dids, &token, sizeof(int), hipMemcpyHostToDevice, 0));
    mtp_layer_rows(d.mtp_dids, hin, 1, mtp_len, true, d.argmax);
    if (snap_slot >= 0) {
        const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
        CK(hipMemcpyAsync(d.mtp_vstage_snap + (size_t)snap_slot * vs, mtp_vstage,
                          vs * 4, hipMemcpyDeviceToDevice, 0));
    }
    int id = -1;
    CK(hipMemcpy(&id, d.argmax, sizeof(int), hipMemcpyDeviceToHost));
    return id;
}

// 上面那版草稿（`mtp_draft_one`）每一步都要「argmax 回主机 → 再把 token 送回设备」，
// 3 步就是 3 次流水线抽干 + 3 次往返；每轮墙钟里因此有一块（~8 ms/轮）不记在
// 任何分阶段计时里。这一版把链留在设备上：草稿 i 的 argmax 写在 d.argmax[i]，
// 下一步的 k_embed 直接吃这个设备指针（k_embed 本来就收设备 int*），
// 只有整条链跑完才同步一次回读。
void Model::mtp_draft_chain(int first_token, const float* hin, int K, int* out_ids) {
    if (!mtp_on || K <= 0) return;
    CK(hipMemcpyAsync(d.mtp_dids, &first_token, sizeof(int), hipMemcpyHostToDevice, 0));
    const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
    const float* h = hin;
    for (int i = 0; i < K; i++) {
        const int* ids = (i == 0) ? d.mtp_dids : (d.argmax + (i - 1));
        mtp_layer_rows(ids, h, 1, mtp_len, true, d.argmax + i);
        CK(hipMemcpyAsync(d.mtp_vstage_snap + (size_t)i * vs, mtp_vstage,
                          vs * 4, hipMemcpyDeviceToDevice, 0));
        h = d.mtp_out;                     // 链式：上一轮的 MTP 隐藏态
    }
    CK(hipMemcpy(out_ids, d.argmax, (size_t)K * sizeof(int), hipMemcpyDeviceToHost));
}

// 把主模型刚算出的最终 norm 隐藏态按「错一位」的方式送进 MTP，建立/续接 MTP KV。
//   abs_off == 0：prompt 第一段，MTP 条目 k=0..n-2（token ids[1..n-1], hidden h[0..n-2]）
//   abs_off  > 0：用上一 token 的 hidden h_prev 和本段全部 token，条目 k=abs_off-1...
void Model::mtp_extend_context(const int* ids_dev, int n, int abs_off) {
    if (!mtp_on || n <= 0) return;
    const int H = cfg.hidden;
    if (abs_off == 0) {
        const int rows = n - 1;
        if (rows <= 0) return;
        CK(hipMemcpyAsync(d.mtp_hin, d.h_norm, (size_t)rows * H * 4,
                          hipMemcpyDeviceToDevice, 0));
        if (mtp_len != 0) { printf("MTP: chunk0 时 mtp_len=%d != 0\n", mtp_len); exit(1); }
        mtp_layer_rows(ids_dev + 1, d.mtp_hin, rows, 0, false, nullptr);
    } else {
        CK(hipMemcpyAsync(d.mtp_hin, d.h_prev, (size_t)H * 4,
                          hipMemcpyDeviceToDevice, 0));
        CK(hipMemcpyAsync(d.mtp_hin + H, d.h_norm, (size_t)(n - 1) * H * 4,
                          hipMemcpyDeviceToDevice, 0));
        if (mtp_len != abs_off - 1) {
            printf("MTP: abs_off=%d 时 mtp_len=%d != %d\n", abs_off, mtp_len, abs_off - 1);
            exit(1);
        }
        mtp_layer_rows(ids_dev, d.mtp_hin, n, abs_off - 1, false, nullptr);
    }
}

// 全接受时的补一步：把最后一个草稿 token 和上一草稿步的 MTP hidden 组成条目 k=mtp_len，
// 使 MTP KV 与新的主模型 seq_len-1 对齐。
void Model::mtp_extra_entry(int token, bool want_logits, int* argmax_out, int snap_slot) {
    if (!mtp_on) return;
    CK(hipMemcpyAsync(d.mtp_dids, &token, sizeof(int), hipMemcpyHostToDevice, 0));
    mtp_layer_rows(d.mtp_dids, d.mtp_out, 1, mtp_len, want_logits, argmax_out);
    if (snap_slot >= 0) {
        const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
        CK(hipMemcpyAsync(d.mtp_vstage_snap + (size_t)snap_slot * vs, mtp_vstage,
                          vs * 4, hipMemcpyDeviceToDevice, 0));
    }
}

void Model::mtp_restore_stage(int slot) {
    if (!mtp_on || slot < 0) return;
    const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
    CK(hipMemcpyAsync(mtp_vstage, d.mtp_vstage_snap + (size_t)slot * vs,
                      vs * 4, hipMemcpyDeviceToDevice, 0));
}

// 验证批之后按保留的候选数回滚：keep 是「接受的候选 token 数」（含 bonus token），
// 取第 keep-1 行状态快照恢复 GDN/卷积；主模型 final norm 还在 d.h_norm 里，
// 顺手取最后接受行的 hidden 作为下一轮 MTP 的 h_prev。
// 把「当前对话前缀」里不可由位置重建的那部分状态存下来：
//   * 48 个线性注意力层的循环状态（ssm_state）与卷积状态（conv_state）
//   * h_prev（MTP 续接上下文要用到的那一行的隐藏态）
// 生成还在进行时不能调用：只在预填充结束时存一次。
void Model::save_ctx_snapshot() {
    if (!ctx_ssm || !ctx_conv) return;
    const size_t ssm_one = (size_t)cfg.lv_head * cfg.ldim * cfg.ldim;
    const size_t conv_one = (size_t)(cfg.conv_k - 1) * 10240;
    for (int il = 0; il < cfg.n_layer; il++) {
        const int slot = lin_slot[il];
        if (slot < 0) continue;
        CK(hipMemcpyAsync(ctx_ssm + (size_t)slot * ssm_one, ssm_state[il],
                          ssm_one * 4, hipMemcpyDeviceToDevice, 0));
        CK(hipMemcpyAsync(ctx_conv + (size_t)slot * conv_one, conv_state[il],
                          conv_one * 4, hipMemcpyDeviceToDevice, 0));
    }
    CK(hipMemcpyAsync(ctx_hprev, d.h_prev, (size_t)cfg.hidden * 4,
                      hipMemcpyDeviceToDevice, 0));
    ctx_snap_len = seq_len;
    ctx_snap_valid = true;
}

// 退回到上一次预填充结束的快照：seq_len / mtp_len 退回去，循环状态整段恢复。
bool Model::restore_ctx_snapshot() {
    if (!ctx_snap_valid || ctx_snap_len < 0) return false;
    const size_t ssm_one = (size_t)cfg.lv_head * cfg.ldim * cfg.ldim;
    const size_t conv_one = (size_t)(cfg.conv_k - 1) * 10240;
    for (int il = 0; il < cfg.n_layer; il++) {
        const int slot = lin_slot[il];
        if (slot < 0) continue;
        CK(hipMemcpyAsync(ssm_state[il], ctx_ssm + (size_t)slot * ssm_one,
                          ssm_one * 4, hipMemcpyDeviceToDevice, 0));
        CK(hipMemcpyAsync(conv_state[il], ctx_conv + (size_t)slot * conv_one,
                          conv_one * 4, hipMemcpyDeviceToDevice, 0));
    }
    CK(hipMemcpyAsync(d.h_prev, ctx_hprev, (size_t)cfg.hidden * 4,
                      hipMemcpyDeviceToDevice, 0));
    seq_len = ctx_snap_len;
    mtp_len = ctx_snap_len > 0 ? ctx_snap_len - 1 : 0;   // 不变量：mtp_len == seq_len-1
    ctx_ids.resize((size_t)ctx_snap_len);
    return true;
}

// ================================ 全局 KV 槽池 ================================
// 设备侧的保存/恢复；决策与布局纯逻辑在文件头 [kv_pool] 的 KvPool 里。
// 一次泊船/回港 = 一次 D2D 拷贝（几百 MB，毫秒级），对比整段重算是秒到分钟级。

size_t Model::kv_slot_bytes(int seq, int mtp, bool snap) const {
    return KvPool::layout(kv_dims, seq, mtp, snap, mtp_on, nullptr);
}

// 槽段 → live 缓冲指针（顺序与 KvPool::layout 的 src 编号一一对应）
const void* Model::kv_live_ptr(const KvSeg& g) {
    switch (g.src) {
        case 0:  return ssm_state[lin_slot_inv(g.idx)];       // 线性槽号 → 层号
        case 1:  return conv_state[lin_slot_inv(g.idx)];
        case 2:  return d.h_prev;
        case 3:  return ctx_ssm + (size_t)g.idx * kv_dims.ssm_one;
        case 4:  return ctx_conv + (size_t)g.idx * kv_dims.conv_one;
        case 5:  return ctx_hprev;
        case 6:  return kcache[attn_slot_inv(g.idx)];
        case 7:  return ksc[attn_slot_inv(g.idx)];
        case 8:  return vcache[attn_slot_inv(g.idx)];
        case 9:  return vsc[attn_slot_inv(g.idx)];
        case 10: return mtp_kc;
        case 11: return mtp_ksc;
        case 12: return mtp_vc;
        default: return mtp_vsc;
    }
}

// lin_slot / attn_slot 是「层号 → 槽号」；这里要反查。层号 ≤ 64，直接线性扫。
int Model::lin_slot_inv(int slot) const {
    for (int il = 0; il < (int)lin_slot.size(); il++)
        if (lin_slot[il] == slot) return il;
    return -1;
}
int Model::attn_slot_inv(int slot) const {
    for (int il = 0; il < (int)attn_slot.size(); il++)
        if (attn_slot[il] == slot) return il;
    return -1;
}

void Model::kv_copy_slot(void* slot_dev, const std::vector<KvSeg>& segs, bool to_slot) {
    char* base = (char*)slot_dev;
    for (const KvSeg& g : segs) {
        if (g.width == 0 || g.height == 0) continue;
        void* live = const_cast<void*>(kv_live_ptr(g));
        if (to_slot)
            CK(hipMemcpy2DAsync(base + g.off, g.pitch_slot, live, g.pitch_live,
                                g.width, g.height, hipMemcpyDeviceToDevice, 0));
        else
            CK(hipMemcpy2DAsync(live, g.pitch_live, base + g.off, g.pitch_slot,
                                g.width, g.height, hipMemcpyDeviceToDevice, 0));
    }
}

// V 暂存区（vstage）也要跟着 KV 一起泊船/回港。它不是「已经在 KV 里、可由位置
// 重建」的东西：k_kv_append_v 对「只填了一半的 tile」按 amax(该 tile 已写过的所有
// key) 定尺度，而 tile 前半段的 f32 值就留在 stage 里（见 src/k_new.hip 的
// kv_append_v_k）。回港后如果紧接着 append（客户端把已提交序列原样带回来就是这条
// 路），第一个 append 落在 tile 中间，前半段 stage 已被别的对话覆盖 → 这一格的 V
// 尺度是错的。整个 stage 每层只有 KV*BG*D*4（本机 256 KB，16 层共 4 MB），一起搬
// 最省心，也让「一个槽 = 活跃状态的一份完整快照」这个不变式真正成立。
size_t Model::kv_vstage_bytes() const {
    if (n_attn <= 0) return 0;
    const size_t one = (size_t)cfg.n_kv * BG * cfg.head_dim * 4;
    return (size_t)n_attn * one + (mtp_on ? one : 0);
}

void Model::kv_copy_vstage(void* base, bool to_slot) {
    const size_t one = (size_t)cfg.n_kv * BG * cfg.head_dim * 4;
    char* p = (char*)base;
    for (int i = 0; i < n_attn; i++, p += one) {
        float* v = vstage[attn_slot_inv(i)];
        if (to_slot) CK(hipMemcpyAsync(p, v, one, hipMemcpyDeviceToDevice, 0));
        else         CK(hipMemcpyAsync(v, p, one, hipMemcpyDeviceToDevice, 0));
    }
    if (mtp_on && mtp_vstage) {
        if (to_slot) CK(hipMemcpyAsync(p, mtp_vstage, one, hipMemcpyDeviceToDevice, 0));
        else         CK(hipMemcpyAsync(mtp_vstage, p, one, hipMemcpyDeviceToDevice, 0));
    }
}

// 把当前活跃对话泊进池（切走 / 被整段重算替换之前调用）。
// keep：紧接着要恢复的槽号，泊船时绝不能驱逐它（-1=无）。
// 不变式守卫：ctx_ids 与 seq_len 失步（被调试 op 动过）就不泊，宁可丢。
void Model::kv_save_active(int keep) {
    if (kv_pool.cap <= 0 || ctx_ids.empty() || (int)ctx_ids.size() != seq_len) return;
    const bool snap = ctx_snap_valid && ctx_snap_len >= 0 &&
                      (size_t)ctx_snap_len <= ctx_ids.size();
    const size_t kvb = kv_slot_bytes(seq_len, mtp_len, snap);
    const size_t need = kvb + kv_vstage_bytes();
    const int home = kv_pool.acquire_home(need, keep);
    if (home < 0) return;
    // 备份缓冲按需重建（对话切换是人一次次的时间尺度，精确分配省显存）
    KvSlot& s = kv_pool.slots[home];
    if (s.dev) { CK(hipFree(s.dev)); s.dev = nullptr; kv_pool.total_bytes -= s.bytes; s.bytes = 0; }
    CK(hipMalloc(&s.dev, need));
    std::vector<KvSeg> segs;
    KvPool::layout(kv_dims, seq_len, mtp_len, snap, mtp_on, &segs);
    kv_copy_slot(s.dev, segs, true);
    kv_copy_vstage((char*)s.dev + kvb, true);
    kv_pool.commit_save(home, ctx_ids, seq_len, mtp_len,
                        snap ? ctx_snap_len : -1, snap, s.dev, need);
    if (kv_trace)
        fprintf(stderr, "[kvp] 泊船：槽 %d，%d tok（快照 %d）%.0f MB，池 %.2f/%.0f GB\n",
                home, seq_len, snap ? ctx_snap_len : -1, need / 1048576.0,
                kv_pool.total_bytes / 1073741824.0, kv_pool.cap_bytes / 1073741824.0);
}

// 回港：把槽内容整段恢复成活跃上下文（调用方保证这个槽确实比当前上下文更优）。
bool Model::kv_restore_slot(int idx) {
    if (idx < 0 || idx >= (int)kv_pool.slots.size()) return false;
    KvSlot& s = kv_pool.slots[idx];
    if (!s.used || !s.dev || s.bytes == 0 || (int)s.ids.size() != s.seq_len) return false;
    const bool snap = s.snap_valid && s.snap_len >= 0 && (size_t)s.snap_len <= s.ids.size();
    std::vector<KvSeg> segs;
    const size_t kvb = KvPool::layout(kv_dims, s.seq_len, s.mtp_len, snap, mtp_on, &segs);
    if (kvb + kv_vstage_bytes() != s.bytes)
        return false;                       // 布局对不上（维度变过？）宁可不恢复
    kv_copy_slot(s.dev, segs, false);
    kv_copy_vstage((char*)s.dev + kvb, false);
    seq_len = s.seq_len;
    mtp_len = s.mtp_len;
    ctx_ids = s.ids;
    ctx_snap_len = snap ? s.snap_len : -1;
    ctx_snap_valid = snap;
    kv_pool.commit_restore(idx);
    if (kv_trace)
        fprintf(stderr, "[kvp] 回港：槽 %d，%d tok（快照 %d）\n", idx, seq_len,
                snap ? ctx_snap_len : -1);
    return true;
}

void Model::kv_pool_clear() {               // RESET：全池作废（基准测量要「冷」状态）
    kv_pool.clear_all();
    if (kv_trace) fprintf(stderr, "[kvp] 清池\n");
}


void Model::rollback_state(int keep) {
    const int H = cfg.hidden;
    if (keep <= 0) return;
    CK(hipMemcpyAsync(d.h_prev, d.h_norm + (size_t)(keep - 1) * H,
                      (size_t)H * 4, hipMemcpyDeviceToDevice, 0));
    const size_t ssm_one = (size_t)cfg.lv_head * cfg.ldim * cfg.ldim;
    const size_t conv_one = (size_t)(cfg.conv_k - 1) * 10240;
    for (int il = 0; il < cfg.n_layer; il++) {
        const int slot = lin_slot[il];
        if (slot < 0) {
            const int as = attn_slot[il];
            const size_t vs = (size_t)cfg.n_kv * BG * cfg.head_dim;
            CK(hipMemcpyAsync(vstage[il],
                              d.vstage_snap + ((size_t)as * 4 + (keep - 1)) * vs,
                              vs * 4, hipMemcpyDeviceToDevice, 0));
            continue;
        }
        const float* ss = d.ssm_snap + ((size_t)slot * 4 + (keep - 1)) * ssm_one;
        const float* cs = d.conv_snap + ((size_t)slot * 4 + (keep - 1)) * conv_one;
        CK(hipMemcpyAsync(ssm_state[il], ss, ssm_one * 4, hipMemcpyDeviceToDevice, 0));
        CK(hipMemcpyAsync(conv_state[il], cs, conv_one * 4, hipMemcpyDeviceToDevice, 0));
    }
}

void Model::print_buf(const char* tag, const float* p, long long n) {
    std::vector<float> buf(n);
    CK(hipMemcpy(buf.data(), p, (size_t)n * 4, hipMemcpyDeviceToHost));
    double s = 0, mx = 0; int nan = 0;
    for (float v : buf) { if (std::isnan(v)) nan++; else { s += fabs(v); mx = std::max(mx, (double)fabs(v)); } }
    printf("    [%s] mean|.|=%.5f max|.|=%.4f nan=%d / %lld\n", tag,
           s / (double)(n - nan), mx, nan, n);
    if (nan) {
        int shown = 0;
        for (long long i = 0; i < n && shown < 4; i++)
            if (std::isnan(buf[i])) { printf("        nan@%lld (行 %lld)", i, i % (n / 4)); shown++; }
        printf("\n");
    }
}

// 分阶段计时汇总（RT_PROF=1）。按「每次 forward」折算成毫秒。
// 注意：走 stderr，避免污染 --engine 的逐行协议（stdout）。
void Model::prof_print(const char* tag) {
    if (!prof) return;
    prof_fold(prof_acc);
    const double d = prof_tokens > 0 ? (double)prof_tokens : 1.0;
    double tot = 0;
    for (int i = 0; i < P_NCAT; i++) tot += prof_acc[i];
    fprintf(stderr, "PROF %s: %.2f ms/步（n=%lld 步，合计 %.1f ms）\n", tag, tot / d, prof_tokens,
            tot);
    for (int i = 0; i < P_NCAT; i++)
        fprintf(stderr, "PROF   %-12s %8.2f ms  %5.1f%%\n", P_NAME[i], prof_acc[i] / d,
                100.0 * prof_acc[i] / (tot > 0 ? tot : 1.0));
    fflush(stderr);
}

void Model::print_stats(int il, int n) {
    std::vector<float> buf((size_t)n * cfg.hidden);
    CK(hipMemcpy(buf.data(), d.x, buf.size() * 4, hipMemcpyDeviceToHost));
    double s = 0, mx = 0; int nan = 0;
    for (float v : buf) { if (std::isnan(v)) nan++; else { s += fabs(v); mx = std::max(mx, (double)fabs(v)); } }
    printf("  [x] layer %3d: mean|.|=%.4f max|.|=%.3f nan=%d\n", il, s / (double)(buf.size() - nan), mx, nan);
    if (nan) {
        for (size_t i = 0; i < buf.size(); i++)
            if (std::isnan(buf[i])) { printf("     首个 NaN: idx=%zu (token %zu, dim %zu)\n", i, i / cfg.hidden, i % cfg.hidden); break; }
    }
}

void Model::dump_buf(int tag, const float* p, long long cnt) {
    std::vector<float> buf(cnt);
    CK(hipMemcpy(buf.data(), p, (size_t)cnt * 4, hipMemcpyDeviceToHost));
    FILE* f = fopen(dump_file.c_str(), "ab");
    const int hdr[2] = { tag, (int)cnt };
    fwrite(hdr, sizeof(int), 2, f);
    fwrite(buf.data(), 4, buf.size(), f);
    fclose(f);
    printf("  [dump] tag %d → %s (%lld)\n", tag, dump_file.c_str(), cnt);
}

void Model::dump_x(int il, int n) {
    std::vector<float> buf((size_t)n * cfg.hidden);
    CK(hipMemcpy(buf.data(), d.x, buf.size() * 4, hipMemcpyDeviceToHost));
    FILE* f = fopen(dump_file.c_str(), "ab");
    const int hdr[2] = { il, n * cfg.hidden };
    fwrite(hdr, sizeof(int), 2, f);
    fwrite(buf.data(), 4, buf.size(), f);
    fclose(f);
    printf("  [dump] layer %d → %s (%d×%d)\n", il, dump_file.c_str(), n, cfg.hidden);
}

// 中间量 dump：tag = 1000 + 层号*100 + 阶段号（见 tools/ref_hf.py 的对照表）。
// 只有 RT_DUMP_BUF=1 且给了 --dump 时才写，正常路径零开销。
void Model::db(int il, int stage, const float* p, long long cnt) {
    static const int on = getenv("RT_DUMP_BUF") ? atoi(getenv("RT_DUMP_BUF")) : 0;
    if (!on || dump_file.empty()) return;
    dump_buf(1000 + il * 100 + stage, p, cnt);
}

void Model::dump_raw(const std::string& path, const void* p, size_t bytes) {
    std::vector<uint8_t> buf(bytes);
    CK(hipMemcpy(buf.data(), p, bytes, hipMemcpyDeviceToHost));
    FILE* f = fopen(path.c_str(), "wb");
    fwrite(buf.data(), 1, bytes, f);
    fclose(f);
    printf("  [dump] %s (%zu B)\n", path.c_str(), bytes);
}

// ============================== 采样器 =====================================
struct Sampler {
    float temp = 1.f, top_p = 1.f;
    int top_k = 0;
    uint64_t st = 88172645463325252ull;
    std::vector<std::pair<float, int>> cand;   // (概率, id)
    std::vector<int> idx;
    std::vector<float> ex;                     // 无截断路径的 exp 缓存（省掉第二遍 expf）

    uint32_t rnd() { st ^= st << 13; st ^= st >> 7; st ^= st << 17; return (uint32_t)(st >> 32); }
    float uni() { return (float)(rnd() >> 8) * (1.f / (float)(1u << 24)); }

    // 采样器。原来 top_k=0/top_p=1 时会对全部 248320 个 logit 做一次 std::sort，
    // 墙钟实测比贪心慢 ~20 ms/token（见 RESUME 的「解码提速」第 1 条）。现在：
    //   * 无截断 → 完全不用排序，两遍 O(V) 精确采样；
    //   * 有截断 → nth_element 选出前 K 个（K=top_k 或 2048），只对 K 个排序。
    int pick(const float* lg, int V) {
        if (temp <= 0.f) {                       // 贪心
            int best = 0; float bv = lg[0];
            for (int i = 1; i < V; i++) if (lg[i] > bv) { bv = lg[i]; best = i; }
            return best;
        }
        float mx = lg[0];
        for (int i = 1; i < V; i++) mx = std::max(mx, lg[i]);
        const float inv_t = 1.f / temp;

        if (top_k <= 0 && top_p >= 1.f) {        // 无截断：O(V)，不排序
            ex.resize(V);
            double sum = 0;
            for (int i = 0; i < V; i++) {
                const float e = expf((lg[i] - mx) * inv_t);
                ex[i] = e;
                sum += (double)e;
            }
            const double r = (double)uni() * sum;
            double c = 0;
            for (int i = 0; i < V; i++) {
                c += (double)ex[i];
                if (r <= c) return i;
            }
            return V - 1;
        }

        // 有截断：先选候选集（top_p 用「前 K 大」近似，K 个以外的质量可忽略）
        const int K = std::min(V, top_k > 0 ? top_k : 2048);
        idx.resize(V);
        for (int i = 0; i < V; i++) idx[i] = i;
        std::nth_element(idx.begin(), idx.begin() + K, idx.end(),
                         [&](int a, int b) { return lg[a] > lg[b]; });
        idx.resize(K);
        std::sort(idx.begin(), idx.end(), [&](int a, int b) { return lg[a] > lg[b]; });
        cand.resize(K);
        double sum = 0;
        for (int i = 0; i < K; i++) {
            const float p = expf((lg[idx[i]] - mx) * inv_t);
            cand[i] = {p, idx[i]};
            sum += p;
        }
        int keep = K;
        if (top_p < 1.f) {                       // top-p：留累积概率到 top_p 为止（至少 1 个）
            double acc = 0;
            for (int i = 0; i < K; i++) {
                acc += cand[i].first;
                if (acc >= (double)top_p * sum) { keep = i + 1; break; }
            }
        }
        double acc = 0;
        for (int i = 0; i < keep; i++) acc += cand[i].first;
        const float r = uni() * (float)acc;
        float c = 0;
        for (int i = 0; i < keep; i++) {
            c += cand[i].first;
            if (r <= c) return cand[i].second;
        }
        return cand[keep - 1].second;
    }
};

static void topk_of(const std::vector<float>& lg, int k, std::vector<int>& ids,
                    std::vector<float>& vals) {
    std::vector<int> idx(lg.size());
    for (size_t i = 0; i < idx.size(); i++) idx[i] = (int)i;
    const int kk = std::min<int>(k, (int)idx.size());
    std::partial_sort(idx.begin(), idx.begin() + kk, idx.end(),
                      [&](int a, int b) { return lg[a] > lg[b]; });
    ids.assign(idx.begin(), idx.begin() + kk);
    vals.clear();
    for (int i = 0; i < kk; i++) vals.push_back(lg[idx[i]]);
}

static std::vector<int> parse_ids(const std::string& s) {
    std::vector<int> v;
    for (size_t p = 0; p < s.size();) {
        size_t q = s.find(',', p);
        if (q == std::string::npos) q = s.size();
        std::string tok = s.substr(p, q - p);
        if (!tok.empty()) v.push_back(atoi(tok.c_str()));
        p = q + 1;
    }
    return v;
}

// 引擎模式：stdin 逐行命令、stdout 逐行结果（scripts/serve.py 当作模型进程）。
//   RESET                                    状态清零
//   PREFILL <id,id,...>                      前向（按 CHUNK 自动分块），回 top-5
//   PREFILL_NR <id,id,...>                   同 PREFILL，但本轮禁用一切 KV 复用
//                                            （跳过活跃前缀与全局槽池的匹配，整段重算；
//                                            服务端发现「改了历史 / 换了会话」时用）
//   PREFILL_EMB <ids> <emb_file> <s:c,...>   同 PREFILL，但用视觉塔 embedding 覆盖
//                                            [s,s+c) 行的词嵌入（emb_file 为 f32）
//   IMG_EMB <patch_file> <out_file> <gh> <gw>
//                                            用 RT4 视觉塔编码图片 patch，输出 f32
//                                            [n_tokens,5120]，回 "OK image <n_tokens>"
//   MTP <n>                                  设置 MTP 草稿数（0=普通逐 token 解码）
//   GEN <n> <temp> <top_p> <top_k> <seed> <stop_csv>
//                                            从当前 logits 采样，每个 token 一行 "TOK <id>"，
//                                            收尾 "END <n> <ms>"
//   ROLLTEST / ROLLTEST2                     状态回滚等价性诊断（见各自分支注释）
//   QUIT
static void engine_loop(Model& m) {
    const int CHUNK = 512;
    std::vector<float> lg(248320);
    Sampler smp;
    bool have_logits = false;
    std::string line;

    // GEN 期间非阻塞看一眼 stdin：Web 端「停止」按钮会发 STOP，收到就在本轮
    // （MTP 一轮 ~75ms）结束后中断生成。GEN 期间的其它命令一律丢弃 —— 服务端
    // 在发出 STOP 后会等本次 GEN 收尾才释放请求锁，所以不会有人在这时插命令。
    auto stop_pending = []() -> bool {
        struct pollfd pfd;
        pfd.fd = STDIN_FILENO;
        pfd.events = POLLIN;
        pfd.revents = 0;
        if (std::cin.rdbuf()->in_avail() <= 0 && poll(&pfd, 1, 0) <= 0) return false;
        std::string s;
        if (!std::getline(std::cin, s)) return true;       // stdin 关了，等同于停止
        return s.rfind("STOP", 0) == 0 || s.rfind("QUIT", 0) == 0;
    };

    // 预填充。**能用旧 KV 就不重算**：这是一条对话里「每条消息都要等一遍整段历史」
    // 的根源 —— 网页每轮都把整段 messages 重新渲染送进来，token 序列天然是上一轮的
    // 前缀，所以这里只补差量就够了。
    //   1) 完全命中（新序列以已缓存序列为前缀）    → 直接接在后面
    //   2) 只命中到「上次预填充结束」的快照点      → 退回快照点再补
    //      （模型会先输出 <think> 再给正文，而客户端只回传正文，所以通常落在这一档）
    //   3) 都不命中（换了对话 / 改了历史 / 带图）  → 老老实实整段重算
    //   1')/2') 的候选不止当前上下文：全局 KV 槽池里泊着的别的对话也算（A→B→A 时
    //   A 的 KV 在槽里，恢复它比整段重算便宜得多）。槽赢了就先把当前对话泊进池、
    //   再把槽恢复成活跃上下文，然后照常走 1)/2)。
    // force_nr：本次 PREFILL 禁用一切复用（活跃上下文的前缀 + 全局槽池都跳过），
    // 直接整段重算。服务端在「客户端改了历史」时会用它（见 scripts/serve.py）：
    // 引擎只认 token 前缀，分不出「助手那段是客户端重分词导致的自然分叉」还是
    // 「历史被真改了」，所以由知道 keys 的服务端来要求整段重算。
    // 跳过的是「匹配」，不是「入池」：当前活跃上下文照常先泊进池（A→B→A 不受影响）。
    auto run_prefill = [&](const std::vector<int>& ids, const EmbSpan* spans, int nspans,
                           bool force_nr = false) {
        size_t start = 0;
        size_t lcp = 0;
        const char* mode = "none";
        // 兜底：ctx_ids 与 seq_len 失步（被别的调试 op 动过）就放弃复用，避免拿错前缀。
        if ((int)m.ctx_ids.size() != m.seq_len) {
            m.ctx_ids.clear();
            m.ctx_snap_valid = false;
            m.ctx_snap_len = -1;
            m.kv_pool.drop_active();          // 失步的活跃上下文不可信，也不再入池
        }
        // 只有纯文本才复用：带视觉 embedding 的 prompt 不能靠 token 前缀判断。
        // RT_NO_KV_REUSE=1 可关掉复用（A/B 对拍、排查问题时用）。
        static const bool no_reuse = getenv("RT_NO_KV_REUSE") && atoi(getenv("RT_NO_KV_REUSE")) != 0;
        const bool may_reuse = !no_reuse && !force_nr;
        if (may_reuse && nspans == 0) {
            // ---- 先问全局槽池：别的对话也许比当前上下文更值得用（A→B→A）----
            if (m.kv_pool.cap > 0) {
                size_t active_start = 0;
                if (!m.ctx_ids.empty() && (int)m.ctx_ids.size() == m.seq_len) {
                    const size_t alim = std::min(m.ctx_ids.size(), ids.size());
                    size_t alcp = 0;
                    while (alcp < alim && m.ctx_ids[alcp] == ids[alcp]) alcp++;
                    if (alcp == m.ctx_ids.size() && alcp < ids.size())
                        active_start = alcp;
                    else if (m.ctx_snap_valid && alcp >= (size_t)m.ctx_snap_len &&
                             (size_t)m.ctx_snap_len < ids.size())
                        active_start = (size_t)m.ctx_snap_len;
                }
                const auto [si, sstart] = m.kv_pool.best_match(ids);
                if (si >= 0 && sstart > active_start) {
                    m.kv_save_active(si);     // 先把当前对话泊进它的槽（keep=si 防误驱）
                    m.kv_restore_slot(si);    // 槽回港成为活跃上下文；失败则维持原状走下面的老路
                }
            }
            // ---- 当前上下文（可能刚被槽恢复替换）照常 append / rewind ----
            if ((int)m.ctx_ids.size() == m.seq_len && !m.ctx_ids.empty()) {
                const size_t lim = std::min(m.ctx_ids.size(), ids.size());
                while (lcp < lim && m.ctx_ids[lcp] == ids[lcp]) lcp++;
                if (lcp == m.ctx_ids.size() && lcp < ids.size()) {
                    start = lcp; mode = "append";
                } else if (m.ctx_snap_valid && lcp >= (size_t)m.ctx_snap_len &&
                           (size_t)m.ctx_snap_len < ids.size() && m.restore_ctx_snapshot()) {
                    start = (size_t)m.ctx_snap_len; mode = "rewind";
                }
            }
        }
        if (getenv("RT_KV_TRACE"))
            fprintf(stderr, "[kv] seq_len=%d ctx=%zu snap=%d(%s) lcp=%zu start=%zu mode=%s"
                    " 池[泊%lld 港%lld 逐%lld]\n",
                    m.seq_len, m.ctx_ids.size(), m.ctx_snap_len,
                    m.ctx_snap_valid ? "valid" : "invalid", lcp, start, mode,
                    m.kv_pool.n_save, m.kv_pool.n_restore, m.kv_pool.n_evict);
        if (start == 0) {
            // 换对话 / 改历史 / 带图：当前对话先泊进池（全局生效），再整段重算新的。
            if (!no_reuse && m.kv_pool.cap > 0) m.kv_save_active();
            m.reset_state();
            mode = "none";
        }
        m.prof_reset();
        // 快照点刻意**不取在 prompt 最末尾**：分词是"看后文"的，prompt 最后一个 token
        // 常会和后面的内容并成一个新 token（实测模板以 `<think>\n` 结束，客户端回传正文
        // 时那个 `\n` 会和正文首字符合并成 271，而不是原来的 198）。往前留 tail 个 token，
        // 后面重跑这一小截的成本可以忽略，换来前缀一定命中。
        // 代价：每轮多算 tail 个 token（默认 8）。
        static const int tail = getenv("RT_KV_TAIL") ? std::max(0, atoi(getenv("RT_KV_TAIL"))) : 8;
        // 快照点还必须是 V 量化 tile 的边界（BG 的整数倍）。原因：k_kv_append_v 对
        // 「只填了一半的 tile」是按 amax(该 tile 已写过的所有 key) 定尺度的，而 tile
        // 前半段的 f32 值来自暂存 stage 的残留（见 kernels/flash_attn_core.h 顶部与
        // src/k_new.hip 的 kv_append_v_k）。退回快照点重算时若 snap 落在 tile 中间，
        // 前半段 stage 可能是别的对话/别的步留下的 —— 尺度就错了，恢复出来的回答会
        // 和整段重算不一致（A→B→A 实测）。对齐到 tile 边界后整个 tile 一次写完，
        // 尺度只由本次写入的 key 决定，与整段重算逐位等价。
        // 向下取整只会让快照点更早（最多多算 BG-1 个 token），不影响「前缀一定命中」。
        const int bg = m.BG > 0 ? m.BG : 1;
        const size_t snap_at = ids.size() > (size_t)tail
                             ? (((ids.size() - tail) / (size_t)bg) * (size_t)bg) : 0;
        bool snap_taken = false;
        auto t0 = std::chrono::steady_clock::now();
        for (size_t off = start; off < ids.size();) {
            size_t lim = std::min<size_t>(off + CHUNK, ids.size());
            if (snap_at > off && snap_at < lim) lim = snap_at;   // 在快照点切一刀
            const int n = (int)(lim - off);
            m.forward(ids.data() + off, n, lim == ids.size(), 0, true, false,
                      spans, nspans, (int)off);
            off = lim;
            if (off == snap_at) { m.save_ctx_snapshot(); snap_taken = true; }
        }
        m.ctx_ids.insert(m.ctx_ids.end(), ids.begin() + start, ids.end());
        CK(hipDeviceSynchronize());
        auto t1 = std::chrono::steady_clock::now();
        const double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
        { ProfTick _t(m.pa(P_COPY));
          CK(hipMemcpy(lg.data(), m.d.logits, lg.size() * 4, hipMemcpyDeviceToHost)); }
        have_logits = true;
        // 整段重算时无论如何都要留一个快照；只补差量时若没经过快照点，保留旧的那个（依然有效）。
        if (!snap_taken && start == 0) m.save_ctx_snapshot();
        // 带视觉 embedding 的 prompt 不能留作复用前缀：图片占位 token id 一样，但
        // 实际 embedding 取决于图片内容，按 token 前缀复用会把旧图的 KV 用在新图上。
        if (nspans > 0) {
            m.ctx_ids.clear();
            m.ctx_snap_valid = false;
            m.ctx_snap_len = -1;
        }
        std::vector<int> ti; std::vector<float> tv;
        topk_of(lg, 5, ti, tv);
        const size_t fresh = ids.size() - start;
        // 机器可读：total=整段 prompt，computed=这次真正算的，reused=从 KV 直接复用的。
        printf("OK prefill total=%zu computed=%zu reused=%zu mode=%s ms=%.1f tps=%.1f",
               ids.size(), fresh, start, mode, ms, fresh / (ms / 1000.0));
        for (size_t i = 0; i < ti.size(); i++) printf(" %d:%.3f", ti[i], tv[i]);
        printf("\n");
        fflush(stdout);
        m.prof_print("prefill");
    };

    while (std::getline(std::cin, line)) {
        while (!line.empty() && (line.back() == '\r' || line.back() == '\n')) line.pop_back();
        if (line.empty()) continue;
        const size_t sp = line.find(' ');
        const std::string op = sp == std::string::npos ? line : line.substr(0, sp);
        const std::string arg = sp == std::string::npos ? "" : line.substr(sp + 1);
        if (op == "QUIT") break;
        if (op == "RESET") {
            m.reset_state();
            have_logits = false;
            printf("OK reset\n");
            fflush(stdout);
        } else if (op == "MTP") {
            m.mtp_n = std::max(0, std::min(3, atoi(arg.c_str())));
            printf("OK mtp %d%s\n", m.mtp_n, m.mtp_on ? "" : " (no weights)");
            fflush(stdout);
        } else if (op == "PREFILL") {
            const std::vector<int> ids = parse_ids(arg);
            run_prefill(ids, nullptr, 0);
        } else if (op == "PREFILL_NR") {          // 禁用复用（服务端改了历史时用）
            const std::vector<int> ids = parse_ids(arg);
            run_prefill(ids, nullptr, 0, true);
        } else if (op == "PREFILL_EMB") {
            const size_t p1 = arg.find(' ');
            const size_t p2 = p1 == std::string::npos ? std::string::npos
                                                      : arg.find(' ', p1 + 1);
            if (p1 == std::string::npos || p2 == std::string::npos) {
                printf("ERR usage PREFILL_EMB <ids> <emb_file> <start:count,...>\n");
                fflush(stdout);
                continue;
            }
            const std::vector<int> ids = parse_ids(arg.substr(0, p1));
            const std::string path = arg.substr(p1 + 1, p2 - p1 - 1);
            const std::string spec = arg.substr(p2 + 1);
            std::vector<std::pair<int, int>> ranges;
            long long total_tokens = 0;
            size_t p = 0;
            while (p <= spec.size()) {
                const size_t q = spec.find(',', p);
                const std::string one = spec.substr(p, q == std::string::npos
                                                       ? std::string::npos : q - p);
                if (!one.empty()) {
                    const size_t colon = one.find(':');
                    if (colon == std::string::npos) {
                        printf("ERR bad emb span %s\n", one.c_str());
                        fflush(stdout);
                        ranges.clear();
                        break;
                    }
                    const int st = atoi(one.substr(0, colon).c_str());
                    const int ct = atoi(one.substr(colon + 1).c_str());
                    if (ct <= 0) {
                        printf("ERR bad emb count %s\n", one.c_str());
                        fflush(stdout);
                        ranges.clear();
                        break;
                    }
                    ranges.push_back({st, ct});
                    total_tokens += ct;
                }
                if (q == std::string::npos) break;
                p = q + 1;
            }
            if (ranges.empty() && !spec.empty()) continue;
            const size_t H = (size_t)m.cfg.hidden;
            std::vector<float> embs((size_t)total_tokens * H);
            std::ifstream f(path, std::ios::binary);
            if (!f) {
                printf("ERR open emb file %s\n", path.c_str());
                fflush(stdout);
                continue;
            }
            f.seekg(0, std::ios::end);
            const size_t bytes = (size_t)f.tellg();
            f.seekg(0, std::ios::beg);
            if (bytes != embs.size() * sizeof(float)) {
                printf("ERR emb size got %zu expect %zu\n", bytes,
                       embs.size() * sizeof(float));
                fflush(stdout);
                continue;
            }
            if (!embs.empty()) f.read((char*)embs.data(), bytes);
            std::vector<EmbSpan> spans;
            long long off = 0;
            for (const auto& r : ranges) {
                spans.push_back({embs.data() + (size_t)off * H, r.first, r.second});
                off += r.second;
            }
            run_prefill(ids, spans.data(), (int)spans.size());
        } else if (op == "IMG_EMB") {
            // .rp4 模式下视觉权重在载荷的最后一段，必须先等预取把这一组搬完；
            // 否则 IMG_EMB 会去读还没初始化的显存，算出一个尺度都不对的 embedding
            // （实测 RMS 差 48 倍、余弦只有 0.58，模型还能读出部分文字所以不容易发现）。
            m.pf.wait_group(m.rp4_used ? m.rp4_last_group : 66);
            if (!m.vision_on) {
                printf("ERR vision not loaded\n");
                fflush(stdout);
                continue;
            }
            std::vector<std::string> f;
            { size_t p = 0; while (p <= arg.size()) { size_t q = arg.find(' ', p);
                if (q == std::string::npos) q = arg.size();
                f.push_back(arg.substr(p, q - p)); p = q + 1; } }
            if (f.size() < 4) {
                printf("ERR usage IMG_EMB <patch_file> <out_file> <gh> <gw>\n");
                fflush(stdout);
                continue;
            }
            int n_tokens = 0;
            const int gh = atoi(f[2].c_str()), gw = atoi(f[3].c_str());
            auto ti0 = std::chrono::steady_clock::now();
            if (m.vm.encode_file(f[0], f[1], n_tokens, gh, gw)) {
                auto ti1 = std::chrono::steady_clock::now();
                const double ms = std::chrono::duration<double, std::milli>(ti1 - ti0).count();
                printf("OK image %d %.1f ms\n", n_tokens, ms);
            } else {
                printf("ERR vision encode failed\n");
            }
            fflush(stdout);
        } else if (op == "GEN") {
            std::vector<std::string> f;
            { size_t p = 0; while (p <= arg.size()) { size_t q = arg.find(' ', p);
                if (q == std::string::npos) q = arg.size();
                f.push_back(arg.substr(p, q - p)); p = q + 1; } }
            const int n = !f.empty() ? atoi(f[0].c_str()) : 1;
            smp.temp = f.size() > 1 ? (float)atof(f[1].c_str()) : 1.f;
            smp.top_p = f.size() > 2 ? (float)atof(f[2].c_str()) : 1.f;
            smp.top_k = f.size() > 3 ? atoi(f[3].c_str()) : 0;
            if (f.size() > 4 && !f[4].empty())
                smp.st = (uint64_t)atoll(f[4].c_str()) ^ 0x9E3779B97F4A7C15ull;
            const std::vector<int> stops = f.size() > 5 ? parse_ids(f[5]) : std::vector<int>{};
            if (!have_logits) { printf("ERR no logits\n"); fflush(stdout); continue; }
            int produced = 0;
            long long draft_try = 0, draft_ok = 0, mtp_rounds = 0;
            bool interrupted = false;              // 客户端发来 STOP
            std::vector<float> tlog;
            float mtp_ema = -1.f;                  // MTP 自适应的接受率 ema（统计输出用）
            m.prof_reset();
            auto t0 = std::chrono::steady_clock::now();
            const size_t V = 248320;
            if (m.mtp_on && smp.temp <= 0.f && m.mtp_n > 0) {
                // 贪心 MTP 投机：每轮草拟 K 个、主模型一次前向校验，接受前缀。
                // RT_MTP_HOST_ARGMAX=1 退回旧的主机侧 argmax 路径（A/B 对照用）。
                static const bool host_argmax =
                    getenv("RT_MTP_HOST_ARGMAX") && atoi(getenv("RT_MTP_HOST_ARGMAX")) != 0;
                // 自适应草稿数（RT_MTP_ADAPTIVE=0 关闭，默认开）：ema 跟踪接受率，
                // 接受率低的内容（代码、列表边界）降 K 省掉无效草稿 —— 草稿链成本
                // 近似线性于 K，全拒时这 K 步全部白跑。升档要连续 2 轮达标（滞回）
                // 防抖动；前 5 轮满 K 收集统计。
                static const bool adapt =
                    !(getenv("RT_MTP_ADAPTIVE") && atoi(getenv("RT_MTP_ADAPTIVE")) == 0);
                float acc_ema = 0.6f;              // 乐观先探
                int last_K = 3, up_cnt = 0;
                bool have_next = false;            // 设备侧路径：下轮首 token 已由 argmax 直出
                int next_tok = 0;
                while (produced < n) {
                    if (stop_pending()) { interrupted = true; break; }
                    int id;
                    { ProfTick _t(m.pa(P_SAMPLE));
                      // 设备侧路径下，贪心 token 直接用上一轮验证批的 argmax，
                      // 不必再扫一遍 lg（贪心 pick 本身就是 argmax，逐位等价）。
                      if (have_next) { id = next_tok; have_next = false; }
                      else             id = smp.pick(lg.data(), V); }
                    printf("TOK %d\n", id);
                    fflush(stdout);
                    produced++;
                    if (std::find(stops.begin(), stops.end(), id) != stops.end()) break;
                    if (produced >= n) break;

                    int K = std::min(std::min(m.mtp_n, n - produced), 3);
                    if (adapt && mtp_rounds > 5) {
                        int want = (int)std::lrint(acc_ema * m.mtp_n * 1.25f);
                        want = std::max(1, std::min(want, m.mtp_n));
                        if (want > last_K) {       // 升档滞回：连续两轮想升才真的升
                            if (++up_cnt < 2) want = last_K;
                            else up_cnt = 0;
                        } else {
                            up_cnt = 0;
                        }
                        K = std::min(K, want);
                    }
                    last_K = K;
                    mtp_rounds++;
                    int drafts[8];
                    // 草稿链留在设备上（中间不回主机）；快照槽位 0..K-1 供回滚用
                    { ProfTick _t(m.pa(P_MTPD));
                      m.mtp_draft_chain(id, m.d.h_prev, K, drafts); }

                    int cand[8];
                    cand[0] = id;
                    for (int i = 0; i < K; i++) cand[i + 1] = drafts[i];
                    const int base = m.seq_len;
                    {
                        ProfTick _t(m.pa(P_MTP));
                        m.forward(cand, K + 1, false, K + 1, false, true);
                        CK(hipDeviceSynchronize());
                    }
                    // 校验批的 argmax：默认走设备侧两级归约（k_new.hip 的 k_argmax：
                    // 128 block 扫段 + 1 block 合并），每轮只回读 (K+1) 个 int。
                    // 旧路径拷回 (K+1)×1MB logits 再在主机扫全词表，合计 0.82ms/轮；
                    // 更早试过的「单 block 设备版」反而 2.30ms/轮——单 block 串行读
                    // 1MB 是延迟受限的，两级归约版没有这个问题。
                    int am[8] = {0, 0, 0, 0, 0, 0, 0, 0};
                    int acc = 0;
                    if (host_argmax) {
                        tlog.resize((size_t)(K + 1) * V);
                        { ProfTick _t(m.pa(P_COPY));
                          CK(hipMemcpy(tlog.data(), m.d.logits_all, tlog.size() * 4,
                                       hipMemcpyDeviceToHost)); }
                        for (int i = 0; i < K; i++) {
                            const float* row = tlog.data() + (size_t)i * V;
                            int bi = 0; float bv = row[0];
                            for (int v = 1; v < (int)V; v++)
                                if (row[v] > bv) { bv = row[v]; bi = v; }
                            if (bi == drafts[i]) acc++; else break;
                        }
                    } else {
                        { ProfTick _t(m.pa(P_COPY));
                          for (int i = 0; i <= K; i++)      // 行 K 是全接受时的 bonus
                              k_argmax(m.d.logits_all + (size_t)i * V, (long long)V,
                                       m.d.argmax + i);
                          CK(hipMemcpy(am, m.d.argmax, (size_t)(K + 1) * sizeof(int),
                                       hipMemcpyDeviceToHost)); }
                        for (int i = 0; i < K; i++) {
                            if (am[i] == drafts[i]) acc++; else break;
                        }
                    }
                    if (K > 0) acc_ema = 0.85f * acc_ema + 0.15f * ((float)acc / K);
                    mtp_ema = acc_ema;
                    // 调试开关：强制全部拒绝，用来单独验证回滚路径与普通解码等价
                    if (getenv("RT_MTP_FORCE_REJECT")) acc = 0;
                    if (getenv("RT_MTP_TRACE")) {
                        fprintf(stderr, "MTPROUND base=%d K=%d acc=%d drafts=", base, K, acc);
                        for (int i = 0; i < K; i++) fprintf(stderr, "%d,", drafts[i]);
                        fprintf(stderr, "\n");
                    }
                    draft_try += K;
                    draft_ok += acc;

                    // 输出接受的前缀；遇到 stop 或到达 n 就停在这里。
                    int a_use = 0;
                    bool hit_stop = false, hit_limit = false;
                    for (int i = 0; i < acc; i++) {
                        const int tok = drafts[i];
                        printf("TOK %d\n", tok);
                        fflush(stdout);
                        produced++;
                        a_use = i + 1;
                        if (std::find(stops.begin(), stops.end(), tok) != stops.end()) {
                            hit_stop = true;
                            break;
                        }
                        if (produced >= n) { hit_limit = true; break; }
                    }
                    if (!hit_stop && !hit_limit) a_use = acc;

                    const int keep = 1 + a_use;
                    m.rollback_state(keep);
                    m.seq_len = base + keep;
                    // KV 里现在留下的是 [id] + 前 a_use 个被接受的草稿，ctx_ids 跟着改。
                    m.ctx_ids.resize((size_t)base);
                    m.ctx_ids.push_back(id);
                    for (int i = 0; i < a_use; i++) m.ctx_ids.push_back(drafts[i]);
                    if (a_use < K) {
                        m.mtp_len = base + a_use;
                        m.mtp_restore_stage(a_use);
                    } else {
                        // 全接受：最后一个 token 的 MTP 条目还没写，补一步。
                        m.mtp_len = base + K - 1;
                        m.mtp_extra_entry(drafts[K - 1], false, nullptr, K);
                    }

                    if (hit_stop || produced >= n) break;
                    if (host_argmax) {
                        ProfTick _t(m.pa(P_COPY));
                        memcpy(lg.data(), tlog.data() + (size_t)a_use * V, V * 4);
                    } else {
                        // 接受前缀之后那一行的 argmax 就是下一轮首 token（贪心下与
                        // smp.pick(lg) 逐位等价）：1MB 行拷贝 + 主机全词表扫描全省掉。
                        next_tok = am[a_use];
                        have_next = true;
                    }
                }
            } else {
                for (int i = 0; i < n; i++) {
                    if (stop_pending()) { interrupted = true; break; }
                    int id;
                    { ProfTick _t(m.pa(P_SAMPLE)); id = smp.pick(lg.data(), V); }
                    printf("TOK %d\n", id);
                    fflush(stdout);
                    produced++;
                    if (std::find(stops.begin(), stops.end(), id) != stops.end()) break;
                    if (i + 1 < n) {
                        m.forward(&id, 1, true);
                        m.ctx_ids.push_back(id);       // 这个 token 进 KV 了
                        { ProfTick _t(m.pa(P_COPY));
                          CK(hipMemcpy(lg.data(), m.d.logits, lg.size() * 4,
                                       hipMemcpyDeviceToHost)); }
                    }
                }
            }
            auto t1 = std::chrono::steady_clock::now();
            const double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
            printf("END %d %.1f%s\n", produced, ms, interrupted ? " stopped" : "");
            fflush(stdout);
            if (draft_try > 0) {
                fprintf(stderr, "MTP 统计：轮数 %lld，草稿 %lld，接受 %lld（%.3f token/轮，%.1f%%）\n",
                        mtp_rounds, draft_try, draft_ok, (double)draft_ok /
                        std::max(1.0, (double)mtp_rounds),
                        100.0 * (double)draft_ok / (double)draft_try);
                if (mtp_ema >= 0.f)
                    fprintf(stderr, "MTP 自适应：接受率 ema=%.2f（RT_MTP_ADAPTIVE=0 可关）\n",
                            mtp_ema);
            }
            m.prof_print("decode");
        } else if (op == "MTPBENCH") {
            // 这些是调试 op，会自己乱动 seq_len / 快照，跑完不再保证和 ctx_ids 一致：
            // 直接作废对话前缀，下一轮 PREFILL 走整段重算。
            m.ctx_ids.clear(); m.ctx_snap_valid = false; m.ctx_snap_len = -1;
            // 单独量 MTP 草稿链（不含主模型校验）：MTPBENCH <步数>
            //   RT_MTPBENCH_NOHEAD=1：不跑 lm_head，用来把「MTP 头」与「lm_head」的代价分开
            // 需要先 PREFILL 建立 MTP KV；跑完再 PREFILL 一次即复位。
            const int mb_steps = arg.empty() ? 30 : atoi(arg.c_str());
            const int mb_tok = 248044;
            const bool mb_head = !(getenv("RT_MTPBENCH_NOHEAD") &&
                                   atoi(getenv("RT_MTPBENCH_NOHEAD")) != 0);
            // RT_MTPBENCH_GEMV=1：只把 8 个 GEMV（+ 可选 lm_head）连起来跑，输入固定、
            // 互不依赖 —— 用来把「GEMV 本身的吞吐」与「草稿链的依赖延迟/元素级算子」分开。
            const bool mb_gemv = getenv("RT_MTPBENCH_GEMV") &&
                                 atoi(getenv("RT_MTPBENCH_GEMV")) != 0;
            // RT_MTPBENCH_GEMV=2：逐个矩阵单独量带宽（同一个 launch 序列，只换矩阵）
            const int mb_gemv2 = getenv("RT_MTPBENCH_GEMV") ? atoi(getenv("RT_MTPBENCH_GEMV")) : 0;
            double mb_bytes = 0;
            auto mb_add = [&](const Wq& w) { mb_bytes += (double)w.N * w.K * 0.5; };
            mb_add(m.mtp.fc); mb_add(m.mtp.q_proj); mb_add(m.mtp.k_proj);
            mb_add(m.mtp.v_proj); mb_add(m.mtp.o_proj); mb_add(m.mtp.mlp_gate);
            mb_add(m.mtp.mlp_up); mb_add(m.mtp.mlp_down);
            if (mb_head) mb_bytes += (double)m.lm_head.N * m.lm_head.K * 0.5;
            int mb_out[4] = {0, 0, 0, 0};
            if (mb_gemv2 == 2) {
                // 逐个矩阵量：同一个循环体，只换权重/输入，报各自的 GB/s。
                // 用来回答「8 个 MTP 矩阵为什么只有 385 GB/s」——是大矩阵本身慢，
                // 还是小矩阵（k/v 只有 2.6 MB）的启动/爬坡被摊薄得不够。
                struct MBRow { const char* name; const Wq* w; float* y; const float* x; };
                const MBRow rows[] = {
                    {"mtp.fc   [5120x10240]", &m.mtp.fc, m.d.mtp_fc, m.d.mtp_cat},
                    {"q_proj   [12288x5120]", &m.mtp.q_proj, m.d.qfull, m.d.xb},
                    {"k_proj   [1024x5120]", &m.mtp.k_proj, m.d.hkk, m.d.xb},
                    {"v_proj   [1024x5120]", &m.mtp.v_proj, m.d.hvv, m.d.xb},
                    {"o_proj   [5120x6144]", &m.mtp.o_proj, m.d.mtp_tmp, m.d.hout},
                    {"mlp.gate [17408x5120]", &m.mtp.mlp_gate, m.d.m_gate, m.d.xb},
                    {"mlp.up   [17408x5120]", &m.mtp.mlp_up, m.d.m_up, m.d.xb},
                    {"mlp.down [5120x17408]", &m.mtp.mlp_down, m.d.gz, m.d.m_gate},
                    {"lm_head  [248320x5120]", &m.lm_head, m.d.mtp_logits, m.d.mtp_out},
                };
                for (const MBRow& r : rows) {
                    const double gb = (double)r.w->N * r.w->K * 0.5 / 1e9;
                    CK(hipDeviceSynchronize());
                    const auto t0 = std::chrono::steady_clock::now();
                    for (int i = 0; i < mb_steps; i++)
                        m.linear(r.y, *r.w, r.x, 1);
                    CK(hipDeviceSynchronize());
                    const auto t1 = std::chrono::steady_clock::now();
                    const double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();
                    printf("MTPBENCH 单矩阵 %s  %.4f ms  %6.0f GB/s（%.4f GB）\n",
                           r.name, ms / mb_steps, gb * mb_steps / (ms / 1e3), gb);
                    fflush(stdout);
                }
            }
            m.prof_reset();
            CK(hipDeviceSynchronize());
            const auto mb_t0 = std::chrono::steady_clock::now();
            for (int i = 0; i < mb_steps; i++) {
                if (mb_gemv) {
                    m.mtp_linear(m.d.mtp_fc, m.mtp.fc, m.mtp.fc_lo, m.d.mtp_cat, 1);
                    m.mtp_linear(m.d.qfull, m.mtp.q_proj, m.mtp.q_lo, m.d.xb, 1);
                    m.mtp_linear(m.d.hkk, m.mtp.k_proj, m.mtp.k_lo, m.d.xb, 1);
                    m.mtp_linear(m.d.hvv, m.mtp.v_proj, m.mtp.v_lo, m.d.xb, 1);
                    m.mtp_linear(m.d.mtp_tmp, m.mtp.o_proj, m.mtp.o_lo, m.d.hout, 1);
                    m.mtp_linear(m.d.m_gate, m.mtp.mlp_gate, m.mtp.mlp_gate_lo, m.d.xb, 1);
                    m.mtp_linear(m.d.m_up, m.mtp.mlp_up, m.mtp.mlp_up_lo, m.d.xb, 1);
                    m.mtp_linear(m.d.gz, m.mtp.mlp_down, m.mtp.mlp_down_lo, m.d.m_gate, 1);
                    if (mb_head)
                        k_gemv_w4a8(m.d.mtp_logits, m.lm_head.q, m.lm_head.s,
                                    m.d.mtp_out, 1, m.lm_head.N, m.lm_head.K);
                } else if (mb_head) {
                    m.mtp_draft_chain(mb_tok, m.d.mtp_out, 1, mb_out);
                } else {
                    CK(hipMemcpyAsync(m.d.mtp_dids, &mb_tok, sizeof(int),
                                      hipMemcpyHostToDevice, 0));
                    m.mtp_layer_rows(m.d.mtp_dids, m.d.mtp_out, 1, m.mtp_len, false, nullptr);
                }
            }
            CK(hipDeviceSynchronize());
            const auto mb_t1 = std::chrono::steady_clock::now();
            const double mb_ms = std::chrono::duration<double, std::milli>(mb_t1 - mb_t0).count();
            printf("MTPBENCH steps=%d head=%d  %.3f ms/步  %.0f GB/s（%.3f GB/步，合计 %.1f ms）\n",
                   mb_steps, mb_head ? 1 : 0, mb_ms / mb_steps,
                   mb_ms > 0 ? mb_bytes * mb_steps / (mb_ms / 1e3) / 1e9 : 0.0,
                   mb_bytes / 1e9, mb_ms);
            fflush(stdout);
            m.prof_tokens = mb_steps;                 // RT_PROF=1 时按步折算（此时只统计 linear）
            m.prof_print("mtpbench");
            {
                // 附带量「纯启动」成本：一串相同数量的小 kernel，不含任何依赖与访存
                const int pb_n = mb_steps * 32;
                CK(hipDeviceSynchronize());
                const auto pb0 = std::chrono::steady_clock::now();
                for (int i = 0; i < pb_n; i++)
                    k_add_inplace(m.d.xb, m.d.x, (long long)m.cfg.hidden);
                CK(hipDeviceSynchronize());
                const auto pb1 = std::chrono::steady_clock::now();
                const double pb_ms = std::chrono::duration<double, std::milli>(pb1 - pb0).count();
                printf("MTPBENCH 启动探针: %d 个独立小 kernel（无依赖）  %.3f µs/kernel\n",
                       pb_n, 1000.0 * pb_ms / pb_n);
                fflush(stdout);
                // 同一个探针，但每个 kernel 都依赖上一个（就地读写同一块）。草稿链上
                // 的内核全是这种关系，所以这个数字才是「少一个 launch 省多少」的答案。
                const int pb_dep = mb_steps * 8;
                CK(hipDeviceSynchronize());
                const auto pd0 = std::chrono::steady_clock::now();
                for (int i = 0; i < pb_dep; i++)
                    k_scale(m.d.xb, 1.0000001f, (long long)m.cfg.hidden);
                CK(hipDeviceSynchronize());
                const auto pd1 = std::chrono::steady_clock::now();
                const double pd_ms = std::chrono::duration<double, std::milli>(pd1 - pd0).count();
                printf("MTPBENCH 依赖链探针: %d 个串行小 kernel（依赖前一个）  %.3f µs/kernel\n",
                       pb_dep, 1000.0 * pd_ms / pb_dep);
                fflush(stdout);
            }
        } else if (op == "ROLLTEST") {
            // 这些是调试 op，会自己乱动 seq_len / 快照，跑完不再保证和 ctx_ids 一致：
            // 直接作废对话前缀，下一轮 PREFILL 走整段重算。
            m.ctx_ids.clear(); m.ctx_snap_valid = false; m.ctx_snap_len = -1;
            // 调试：<prompt_csv> <t0> <t1> <draft_csv>
            // 比较 (t0,t1) 逐 token 前向，与 [t0,d1,d2,d3] 验证批回滚到 t0 后再前向 t1
            // 的 logits。两者应在 1e-5 量级内一致。
            std::vector<std::string> f;
            { size_t p = 0; while (p <= arg.size()) { size_t q = arg.find(' ', p);
                if (q == std::string::npos) q = arg.size();
                f.push_back(arg.substr(p, q - p)); p = q + 1; } }
            if (f.size() < 4) { printf("ERR usage ROLLTEST <prompt_csv> <t0> <t1> <draft_csv>\n");
                                fflush(stdout); continue; }
            const std::vector<int> prompt = parse_ids(f[0]);
            const int t0 = atoi(f[1].c_str()), t1 = atoi(f[2].c_str());
            std::vector<int> dr = parse_ids(f[3]);
            while ((int)dr.size() < 3) dr.push_back(0);
            const size_t V = 248320;
            std::vector<float> la0(V), la1(V), lb0(V), lb1(V);
            auto run_prefill = [&]() {
                m.reset_state();
                for (size_t off = 0; off < prompt.size(); off += CHUNK) {
                    const int nn = (int)std::min<size_t>(CHUNK, prompt.size() - off);
                    m.forward(prompt.data() + off, nn, off + nn == prompt.size());
                }
                CK(hipDeviceSynchronize());
            };
            auto copy_last = [&](std::vector<float>& v) {
                CK(hipMemcpy(v.data(), m.d.logits, V * 4, hipMemcpyDeviceToHost));
            };
            run_prefill();
            m.forward(&t0, 1, true); copy_last(la0);
            m.forward(&t1, 1, true); copy_last(la1);
            run_prefill();
            const int base = m.seq_len;
            const int cand[4] = {t0, dr[0], dr[1], dr[2]};
            m.forward(cand, 4, false, 4, false, true);
            CK(hipDeviceSynchronize());
            CK(hipMemcpy(lb0.data(), m.d.logits_all, V * 4, hipMemcpyDeviceToHost));
            m.rollback_state(1);
            m.seq_len = base + 1;
            m.mtp_len = base;
            m.forward(&t1, 1, true); copy_last(lb1);
            auto diff = [&](const std::vector<float>& a, const std::vector<float>& b) {
                double mx = 0, s = 0;
                for (size_t i = 0; i < V; i++) { mx = std::max(mx, (double)fabs(a[i] - b[i]));
                                                s += fabs(a[i] - b[i]); }
                return std::pair<double, double>{mx, s / V};
            };
            auto d0 = diff(la0, lb0), d1 = diff(la1, lb1);
            printf("ROLLTEST t0 max=%.6g mean=%.6g   t1 max=%.6g mean=%.6g\n",
                   d0.first, d0.second, d1.first, d1.second);
            fflush(stdout);
        } else if (op == "ROLLTEST2") {
            // 这些是调试 op，会自己乱动 seq_len / 快照，跑完不再保证和 ctx_ids 一致：
            // 直接作废对话前缀，下一轮 PREFILL 走整段重算。
            m.ctx_ids.clear(); m.ctx_snap_valid = false; m.ctx_snap_len = -1;
            // 调试：<prompt_csv> <4个候选token_csv> <probe>
            // 对 keep=1..4 分别比较：普通逐 token 前向 vs 验证批 + 回滚后再前向 probe。
            std::vector<std::string> f;
            { size_t p = 0; while (p <= arg.size()) { size_t q = arg.find(' ', p);
                if (q == std::string::npos) q = arg.size();
                f.push_back(arg.substr(p, q - p)); p = q + 1; } }
            if (f.size() < 3) { printf("ERR usage ROLLTEST2 <prompt_csv> <tok4_csv> <probe>\n");
                                fflush(stdout); continue; }
            const std::vector<int> prompt = parse_ids(f[0]);
            std::vector<int> toks = parse_ids(f[1]);
            while ((int)toks.size() < 4) toks.push_back(0);
            const int probe = atoi(f[2].c_str());
            const size_t V = 248320;
            std::vector<float> la(V), lb(V);
            auto run_prefill = [&]() {
                m.reset_state();
                for (size_t off = 0; off < prompt.size(); off += CHUNK) {
                    const int nn = (int)std::min<size_t>(CHUNK, prompt.size() - off);
                    m.forward(prompt.data() + off, nn, off + nn == prompt.size());
                }
                CK(hipDeviceSynchronize());
            };
            auto diff = [&](const std::vector<float>& a, const std::vector<float>& b) {
                double mx = 0, s = 0;
                for (size_t i = 0; i < V; i++) { mx = std::max(mx, (double)fabs(a[i] - b[i]));
                                                s += fabs(a[i] - b[i]); }
                return std::pair<double, double>{mx, s / V};
            };
            for (int keep = 1; keep <= 4; keep++) {
                run_prefill();
                for (int j = 0; j < keep; j++) m.forward(&toks[j], 1, true);
                m.forward(&probe, 1, true);
                CK(hipMemcpy(la.data(), m.d.logits, V * 4, hipMemcpyDeviceToHost));

                run_prefill();
                const int base = m.seq_len;
                m.forward(toks.data(), 4, false, 4, false, true);
                CK(hipDeviceSynchronize());
                m.rollback_state(keep);
                m.seq_len = base + keep;
                m.mtp_len = base + keep - 1;
                m.forward(&probe, 1, true);
                CK(hipMemcpy(lb.data(), m.d.logits, V * 4, hipMemcpyDeviceToHost));
                auto d = diff(la, lb);
                printf("ROLLTEST2 keep=%d max=%.6g mean=%.6g\n", keep, d.first, d.second);
            }
            fflush(stdout);
        } else {
            printf("ERR unknown op %s\n", op.c_str());
            fflush(stdout);
        }
    }
}

// -------------------------------- main -------------------------------------

// .rp4 单文件模式可用吗？（供 MTP / 视觉塔的「启用与否」判断使用）
//
// .rp4 里已经装齐了主模型、NVFP4、MTP 头、视觉塔，运行时不会去读
// qwen38_27b_mtp.rt4 / qwen38_27b_vision.rt4。所以那两个文件在不在，
// 不能拿来决定要不要启用 MTP/视觉——只有 .rp4 也不在（走散读回退）时，
// 才必须要求它们真实存在。判定规则与 Model::init 里的 .rp4 解析保持一致。
static bool rp4_available() {
    if (getenv("RT_NVFP4") && atoi(getenv("RT_NVFP4")) == 0) return false;  // 纯 int4 路线不用 .rp4
    const char* e = getenv("RT_RP4");
    if (e && !strcmp(e, "0")) return false;
    if (e && *e) return access(e, R_OK) == 0;
    return access("models/Qwen3.8-27B-NVFP4/model.rp4", R_OK) == 0;
}

int main(int argc, char** argv) {
    std::string model, json, dump, mtp_path, mtp_json, vision_path, vision_json;
    std::vector<int> ids;
    bool stats_flag = false;
    int dbg_layer = 1;
    int topk = 10, ctx = 32768;
    int mtp_n = getenv("RT_MTP_N") ? atoi(getenv("RT_MTP_N")) : 3;
    bool no_mtp = getenv("RT_NO_MTP") ? atoi(getenv("RT_NO_MTP")) != 0 : false;
    bool engine = false;
    std::vector<int> dumplayers;
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        auto nx = [&]() { return std::string(argv[++i]); };
        if (a == "--model") model = nx();
        else if (a == "--json") json = nx();
        else if (a == "--mtp") mtp_path = nx();
        else if (a == "--mtp-json") mtp_json = nx();
        else if (a == "--vision") vision_path = nx();
        else if (a == "--vision-json") vision_json = nx();
        else if (a == "--mtp-n") mtp_n = atoi(nx().c_str());
        else if (a == "--no-mtp") no_mtp = true;
        else if (a == "--ctx") ctx = atoi(nx().c_str());
        else if (a == "--topk") topk = atoi(nx().c_str());
        else if (a == "--dump") dump = nx();
        else if (a == "--engine") engine = true;
        else if (a == "--stats") stats_flag = true;
        else if (a == "--dbg-layer") dbg_layer = atoi(nx().c_str());
        else if (a == "--ids") {
            std::string s = nx();
            for (size_t p = 0; p < s.size();) {
                size_t q = s.find(',', p);
                if (q == std::string::npos) q = s.size();
                ids.push_back(atoi(s.substr(p, q - p).c_str()));
                p = q + 1;
            }
        } else if (a == "--dump-layers") {
            std::string s = nx();
            for (size_t p = 0; p < s.size();) {
                size_t q = s.find(',', p);
                if (q == std::string::npos) q = s.size();
                dumplayers.push_back(atoi(s.substr(p, q - p).c_str()));
                p = q + 1;
            }
        } else { printf("未知参数 %s\n", a.c_str()); return 1; }
    }
    if (model.empty() || (ids.empty() && !engine)) {
        printf("用法: rt --model <rt4> --json <manifest> --ids 1,2,3 [--ctx 32768] [--topk 10] "
               "[--mtp mtp.rt4 --mtp-json mtp.rt4.json --mtp-n 3] "
               "[--dump f.bin --dump-layers 0,1,3]  或  rt --engine\n");
        return 1;
    }
    if (no_mtp) { mtp_path.clear(); mtp_json.clear(); }
    // 未显式给 MTP 时：先看 RT_MTP 环境变量，再找权重同目录的 qwen38_27b_mtp.rt4。
    if (!no_mtp && mtp_path.empty()) {
        const char* env = getenv("RT_MTP");
        if (env && *env) mtp_path = env;
    }
    if (!no_mtp && mtp_path.empty() && !model.empty()) {
        const size_t slash = model.find_last_of('/');
        const std::string dir = slash == std::string::npos ? "." : model.substr(0, slash);
        // RT_MTP_W8=1 时改用 int8 权重（tools/mtp_w8_pack.py 的产物）；
        // 权重文件本身也能被 load_mtp 识别，所以显式给 --mtp/RT_MTP 时不用这个开关。
        const char* w8 = getenv("RT_MTP_W8");
        mtp_path = dir + ((w8 && atoi(w8) != 0) ? "/qwen38_27b_mtp_w8.rt4" : "/qwen38_27b_mtp.rt4");
    }
    if (!mtp_path.empty() && mtp_json.empty()) mtp_json = mtp_path + ".json";
    if (!mtp_path.empty() && access(mtp_path.c_str(), R_OK) != 0 && !rp4_available())
        mtp_path.clear();
    if (mtp_path.empty()) mtp_json.clear();
    if (vision_path.empty()) {
        const char* env = getenv("RT_VISION_RT4");
        if (env && *env) vision_path = env;
    }
    if (vision_path.empty() && !model.empty()) {
        const size_t slash = model.find_last_of('/');
        const std::string dir = slash == std::string::npos ? "." : model.substr(0, slash);
        vision_path = dir + "/qwen38_27b_vision.rt4";
    }
    if (!vision_path.empty() && vision_json.empty()) vision_json = vision_path + ".json";
    if (!vision_path.empty() && access(vision_path.c_str(), R_OK) != 0 && !rp4_available()) {
        vision_path.clear();
        vision_json.clear();
    }
    if (!dump.empty()) remove(dump.c_str());      // 每次运行重建 dump 文件
    Model m;
    m.stats = stats_flag;
    m.prof = getenv("RT_PROF") ? atoi(getenv("RT_PROF")) : 0;
    m.dbg_layer = dbg_layer;
    m.max_ctx = ctx;
    m.mtp_path = mtp_path;
    m.mtp_json = mtp_json;
    m.mtp_n = std::max(0, std::min(3, mtp_n));
    m.dump_file = dump;
    m.dump_layers = dumplayers.empty() ? nullptr : &dumplayers;
    m.T_MAX = engine ? 512 : (int)ids.size();
    auto t0 = std::chrono::steady_clock::now();
    m.init(model, json);
    if (!vision_path.empty()) {
        if (m.rp4_used) m.vm.init_from_rp4(m.rp4, m.rp4.dev);
        else            m.vm.init(vision_path, vision_json);
        m.vision_on = true;
    }
    auto t1 = std::chrono::steady_clock::now();
    m.reset_state();
    if (engine) {
        printf("READY %.1f\n", std::chrono::duration<double>(t1 - t0).count());
        fflush(stdout);
        engine_loop(m);
        return 0;
    }
    m.forward(ids.data(), (int)ids.size(), true);
    CK(hipDeviceSynchronize());
    auto t2 = std::chrono::steady_clock::now();
    std::vector<float> logits(248320);
    CK(hipMemcpy(logits.data(), m.d.logits, logits.size() * 4, hipMemcpyDeviceToHost));
    // top-k
    std::vector<int> idx(logits.size());
    for (size_t i = 0; i < idx.size(); i++) idx[i] = (int)i;
    std::partial_sort(idx.begin(), idx.begin() + topk, idx.end(),
                      [&](int a, int b) { return logits[a] > logits[b]; });
    printf("前向完成：%zu token，加载 %.1fs，前向 %.2fs\n",
           ids.size(),
           std::chrono::duration<double>(t1 - t0).count(),
           std::chrono::duration<double>(t2 - t1).count());
    printf("top-%d logits：", topk);
    for (int i = 0; i < topk; i++) printf(" %d(%.3f)", idx[i], logits[idx[i]]);
    printf("\n");
    return 0;
}
