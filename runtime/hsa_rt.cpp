// hsa_rt.cpp —— 用 /opt/hyhal 的 HSA 实现 RT4 运行时需要的 HIP 子集。
// 内核来自自研 HSACO：优先 $RT_HSACO，其次 build/k100lc_all.hsaco，
// 再退回可执行文件旁边的 prebuilt/（源码包里带了预编译版本，解压即可跑）。
//
// 语义取舍（都对「跑通」友好，性能上标明代价）：
//   * 拷贝：H2D 走 hsa_amd_memory_async_copy（源先 hsa_memory_register，否则退回
//     hsa_memory_copy）；D2H/D2D 因为要读「可能刚被内核写过」的设备内存，先做一次
//     全设备同步再拷 —— 比 HIP 的流序保守，但绝对安全。
//   * 事件：本实现里拷贝在调用线程上就是同步完成的，所以「记录」= 置一个序号，
//     「等事件」= 自旋等序号到位（预取线程与主线程之间靠它排序）。
//     hipEventElapsedTime 因此返回 0（RT_PROF 在这条路线上不可用，见 README）。
//   * 内核投递：单队列、in-order；kernarg 用 64 个槽轮转，复用前等该槽上一次完成。
#include "hsa_rt.h"

#include <hsa/hsa.h>
#include <hsa/hsa_ext_amd.h>

#include <unistd.h>

#include <atomic>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

#ifndef RT_HSACO_DEFAULT
#define RT_HSACO_DEFAULT "build/k100lc_all.hsaco"
#endif

#define HSA_CHECK(expr) do { hsa_status_t st_ = (expr); if (st_ != HSA_STATUS_SUCCESS) { \
    const char* s_ = nullptr; hsa_status_string(st_, &s_); \
    fprintf(stderr, "hsa_rt: %s:%d %s -> %s\n", __FILE__, __LINE__, #expr, s_ ? s_ : "?"); \
    exit(1); } } while (0)

// 头里只前置声明；定义放全局，保证 hipEvent_t/hipStream_t 的指针语义与 HIP 一致
struct EventImpl {
    std::atomic<uint64_t> seq{0};
};
struct StreamImpl { int dummy = 0; };

namespace {

constexpr int N_SLOT = 64;

hsa_agent_t g_gpu{};
std::vector<hsa_agent_t> g_cpus;
hsa_amd_memory_pool_t g_data_pool{};
hsa_amd_memory_pool_t g_karg_pool{};
hsa_amd_memory_pool_t g_host_pool{};        // CPU 侧（pinned）——拷贝的暂存区
hsa_status_t g_host_pool_st = HSA_STATUS_ERROR;
hsa_queue_t* g_queue = nullptr;
hsa_executable_t g_exec{};
uint64_t g_kobj[k_table_n];

void*     g_karg[N_SLOT];
hsa_signal_t g_sig[N_SLOT];
bool      g_slot_used[N_SLOT];
int       g_next = 0;

std::mutex g_mtx;

std::vector<std::pair<const void*, size_t>> g_reg;      // 已注册的主机区间

void check_hsa(hsa_status_t st, const char* what) {
    if (st != HSA_STATUS_SUCCESS) {
        const char* s = nullptr;
        hsa_status_string(st, &s);
        fprintf(stderr, "hsa_rt: %s -> %s\n", what, s ? s : "?");
        exit(1);
    }
}

hsa_status_t cb_agent(hsa_agent_t agent, void*) {
    hsa_device_type_t type{};
    HSA_CHECK(hsa_agent_get_info(agent, HSA_AGENT_INFO_DEVICE, &type));
    if (type == HSA_DEVICE_TYPE_GPU) {
        g_gpu = agent;
    } else if (type == HSA_DEVICE_TYPE_CPU) {
        g_cpus.push_back(agent);
    }
    return HSA_STATUS_SUCCESS;
}

hsa_status_t cb_pool(hsa_amd_memory_pool_t pool, void*) {
    hsa_amd_segment_t seg{};
    hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_SEGMENT, &seg);
    if (seg != HSA_AMD_SEGMENT_GLOBAL) return HSA_STATUS_SUCCESS;
    uint32_t flags = 0;
    bool alloc_ok = false;
    hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_GLOBAL_FLAGS, &flags);
    hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_RUNTIME_ALLOC_ALLOWED, &alloc_ok);
    if (!alloc_ok) return HSA_STATUS_SUCCESS;
    static bool have_karg = false, have_data = false;
    if (!have_karg && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_KERNARG_INIT)) {
        g_karg_pool = pool; have_karg = true;
    }
    if (!have_karg && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_FINE_GRAINED)) {
        g_karg_pool = pool; have_karg = true;
    }
    if (!have_data && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_COARSE_GRAINED)) {
        g_data_pool = pool; have_data = true;
    }
    return HSA_STATUS_SUCCESS;
}

void* pool_alloc(hsa_amd_memory_pool_t pool, size_t n) {
    void* p = nullptr;
    check_hsa(hsa_amd_memory_pool_allocate(pool, n, 0, &p), "pool_allocate");
    std::vector<hsa_agent_t> agents;
    agents.push_back(g_gpu);
    for (hsa_agent_t c : g_cpus) agents.push_back(c);
    check_hsa(hsa_amd_agents_allow_access((uint32_t)agents.size(), agents.data(), nullptr, p),
              "allow_access");
    return p;
}

hsa_status_t cb_host_pool(hsa_amd_memory_pool_t pool, void*) {
    if (g_host_pool_st == HSA_STATUS_SUCCESS) return HSA_STATUS_SUCCESS;
    hsa_amd_segment_t seg{};
    hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_SEGMENT, &seg);
    if (seg != HSA_AMD_SEGMENT_GLOBAL) return HSA_STATUS_SUCCESS;
    bool alloc_ok = false;
    hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_RUNTIME_ALLOC_ALLOWED, &alloc_ok);
    if (!alloc_ok) return HSA_STATUS_SUCCESS;
    g_host_pool = pool;
    g_host_pool_st = HSA_STATUS_SUCCESS;
    return HSA_STATUS_SUCCESS;
}

hsa_status_t cb_pool_ok(hsa_status_t st) {
    return st == HSA_STATUS_INFO_BREAK ? HSA_STATUS_SUCCESS : st;
}

// 拷贝暂存区：主机侧 pinned 内存。hsa_amd_memory_async_copy 的源/目的必须
// 是 agent 可访问的（页锁定）内存 —— 直接拿 malloc/栈地址去拷会报
// "Invalid address access"，所以统一过一次暂存区。
void*  g_stage = nullptr;
size_t g_stage_sz = 0;
std::mutex g_stage_mtx;

void* stage(size_t n) {
    if (n > g_stage_sz) {
        if (g_stage) hsa_amd_memory_pool_free(g_stage);
        g_stage = pool_alloc(g_host_pool, n);
        g_stage_sz = n;
    }
    return g_stage;
}

hsa_status_t get_symbol(const char* name, hsa_agent_t agent, hsa_executable_symbol_t* out) {
    hsa_status_t st = hsa_executable_get_symbol_by_name(g_exec, name, &agent, out);
    if (st == HSA_STATUS_SUCCESS) return st;
    std::string alt = std::string("&") + name;
    st = hsa_executable_get_symbol_by_name(g_exec, alt.c_str(), &agent, out);
    if (st == HSA_STATUS_SUCCESS) return st;
    alt = std::string(name) + ".kd";
    return hsa_executable_get_symbol_by_name(g_exec, alt.c_str(), &agent, out);
}

void load_hsaco(const char* path) {
    static std::string alt_path;              // 命中备选路径时给它一个长生命周期
    FILE* f = fopen(path, "rb");
    if (!f) {
        // 再试几个常见位置（相对当前目录 + 相对可执行文件所在目录）。
        char exe_dir[4096] = "";
        if (ssize_t n = readlink("/proc/self/exe", exe_dir, sizeof(exe_dir) - 1); n > 0) {
            exe_dir[n] = '\0';
            if (char* s = strrchr(exe_dir, '/')) *s = '\0'; else exe_dir[0] = '\0';
        }
        std::vector<std::string> alts = {
            "build/k100lc_all.hsaco", "prebuilt/k100lc_all.hsaco", "./k100lc_all.hsaco"};
        if (exe_dir[0]) {
            alts.push_back(std::string(exe_dir) + "/k100lc_all.hsaco");
            alts.push_back(std::string(exe_dir) + "/../build/k100lc_all.hsaco");
            alts.push_back(std::string(exe_dir) + "/../prebuilt/k100lc_all.hsaco");
        }
        for (const std::string& a : alts)
            if ((f = fopen(a.c_str(), "rb"))) { alt_path = a; path = alt_path.c_str(); break; }
    }
    if (!f) { fprintf(stderr, "hsa_rt: 打不开自研 HSACO（%s）\n", path); exit(1); }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    void* image = malloc((size_t)sz);
    if (fread(image, 1, (size_t)sz, f) != (size_t)sz) { fprintf(stderr, "hsa_rt: HSACO 读失败\n"); exit(1); }
    fclose(f);
    check_hsa(hsa_executable_create_alt(HSA_PROFILE_FULL, HSA_DEFAULT_FLOAT_ROUNDING_MODE_DEFAULT,
                                        nullptr, &g_exec), "executable_create");
    hsa_code_object_reader_t reader;
    check_hsa(hsa_code_object_reader_create_from_memory(image, (size_t)sz, &reader),
              "code_object_reader");
    check_hsa(hsa_executable_load_agent_code_object(g_exec, g_gpu, reader, nullptr, nullptr),
              "load_agent_code_object");
    check_hsa(hsa_executable_freeze(g_exec, nullptr), "executable_freeze");
    for (int i = 0; i < k_table_n; i++) {
        hsa_executable_symbol_t sym;
        HSA_CHECK(get_symbol(k_table[i].name, g_gpu, &sym));
        HSA_CHECK(hsa_executable_symbol_get_info(
            sym, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_OBJECT, &g_kobj[i]));
    }
    fprintf(stderr, "hsa_rt: 自研 HSACO %s 已加载（%d 个 kernel，只依赖 /opt/hyhal）\n",
            path, k_table_n);
}

void make_queue() {
    uint32_t qsize = 0;
    HSA_CHECK(hsa_agent_get_info(g_gpu, HSA_AGENT_INFO_QUEUE_MAX_SIZE, &qsize));
    if (qsize > (uint32_t)N_SLOT) qsize = N_SLOT;
    const char* qenv = getenv("RT_HSART_QMULTI");
    const hsa_queue_type_t qtype = (qenv && atoi(qenv)) ? HSA_QUEUE_TYPE_MULTI : HSA_QUEUE_TYPE_SINGLE;
    HSA_CHECK(hsa_queue_create(g_gpu, qsize, qtype, nullptr, nullptr,
                               UINT32_MAX, UINT32_MAX, &g_queue));
    for (int i = 0; i < N_SLOT; i++) {
        g_karg[i] = pool_alloc(g_karg_pool, MAX_KERNARG);
        HSA_CHECK(hsa_signal_create(1, 0, nullptr, &g_sig[i]));
        g_slot_used[i] = false;
    }
}

void ensure_registered(const void* p, size_t n) {
    for (auto& r : g_reg) {
        const char* a = (const char*)r.first;
        if ((const char*)p >= a && (const char*)p + n <= a + r.second) return;
    }
    if (hsa_memory_register(const_cast<void*>(p), n) == HSA_STATUS_SUCCESS) g_reg.push_back({p, n});
}

// H2D：源在主机内存（可能是 mmap 出来的文件页 / 栈上的小数组）
void copy_h2d(void* dst, const void* src, size_t n) {
    if (g_cpus.empty() || g_host_pool_st != HSA_STATUS_SUCCESS) {
        HSA_CHECK(hsa_memory_copy(dst, src, n));
        return;
    }
    std::lock_guard<std::mutex> lk(g_stage_mtx);
    void* st = stage(n);
    memcpy(st, src, n);
    hsa_signal_t sig;
    HSA_CHECK(hsa_signal_create(1, 0, nullptr, &sig));
    hsa_status_t stc = hsa_amd_memory_async_copy(dst, g_gpu, st, g_cpus[0], n, 0, nullptr, sig);
    if (stc == HSA_STATUS_SUCCESS)
        hsa_signal_wait_scacquire(sig, HSA_SIGNAL_CONDITION_LT, 1, UINT64_MAX,
                                  HSA_WAIT_STATE_ACTIVE);
    else
        HSA_CHECK(hsa_memory_copy(dst, src, n));
    hsa_signal_destroy(sig);
}

// D2H：同样过一次 pinned 暂存区
void copy_d2h(void* dst, const void* src, size_t n) {
    if (g_cpus.empty() || g_host_pool_st != HSA_STATUS_SUCCESS) {
        HSA_CHECK(hsa_memory_copy(dst, src, n));
        return;
    }
    std::lock_guard<std::mutex> lk(g_stage_mtx);
    void* st = stage(n);
    hsa_signal_t sig;
    HSA_CHECK(hsa_signal_create(1, 0, nullptr, &sig));
    hsa_status_t stc = hsa_amd_memory_async_copy(st, g_cpus[0], src, g_gpu, n, 0, nullptr, sig);
    if (stc == HSA_STATUS_SUCCESS) {
        hsa_signal_wait_scacquire(sig, HSA_SIGNAL_CONDITION_LT, 1, UINT64_MAX, HSA_WAIT_STATE_ACTIVE);
        memcpy(dst, st, n);
    } else {
        HSA_CHECK(hsa_memory_copy(dst, src, n));
    }
    hsa_signal_destroy(sig);
}

}  // namespace

// ============================ 初始化 ============================
void hsart_init(const char* hsaco_path) {
    static bool done = false;
    static std::mutex init_mtx;
    std::lock_guard<std::mutex> lk(init_mtx);
    if (done) return;
    done = true;
    HSA_CHECK(hsa_init());
    HSA_CHECK(hsa_iterate_agents(cb_agent, nullptr));
    HSA_CHECK(hsa_amd_agent_iterate_memory_pools(g_gpu, cb_pool, nullptr));
    if (!g_cpus.empty()) hsa_amd_agent_iterate_memory_pools(g_cpus[0], cb_host_pool, nullptr);
    const char* env = getenv("RT_HSACO");
    load_hsaco((env && *env) ? env : (hsaco_path && *hsaco_path ? hsaco_path : RT_HSACO_DEFAULT));
    make_queue();
}

const RtKernel* hsart_lookup(const char* name) {
    static std::string norm_buf;
    norm_buf.clear();
    for (const char* p = name; *p; p++)
        if (*p != ' ' && *p != '\t' && *p != '\n') norm_buf.push_back(*p);
    for (int i = 0; i < k_table_n; i++)
        if (norm_buf == k_table[i].lookup) return &k_table[i];
    return nullptr;
}

// ============================ 内核投递 ============================
void hsart_dispatch(const RtKernel* k, dim3 grid, dim3 block, int smem,
                    const void* kernarg, size_t kernarg_size) {
    std::lock_guard<std::mutex> lk(g_mtx);
    const int slot = g_next;
    if (g_slot_used[slot])
        hsa_signal_wait_scacquire(g_sig[slot], HSA_SIGNAL_CONDITION_LT, 1, UINT64_MAX,
                                  HSA_WAIT_STATE_ACTIVE);
    char* ka = (char*)g_karg[slot];
    memcpy(ka, kernarg, kernarg_size);

    // 隐藏参数
    const uint64_t gx = (uint64_t)grid.x * block.x, gy = (uint64_t)grid.y * block.y,
                   gz = (uint64_t)grid.z * block.z;
    const uint32_t nbx = (uint32_t)((gx + block.x - 1) / block.x);
    const uint32_t nby = (uint32_t)((gy + block.y - 1) / block.y);
    const uint32_t nbz = (uint32_t)((gz + block.z - 1) / block.z);
    int dims = gz > 1 ? 3 : (gy > 1 ? 2 : 1);
    for (uint32_t i = 0; i < k->nargs; i++) {
        const RtArg& a = k->args[i];
        if (a.kind == 0) continue;
        uint64_t v = 0, w = 0;
        switch (a.kind) {
            case 1: v = nbx; break;
            case 2: v = nby; break;
            case 3: v = nbz; break;
            case 4: v = block.x; break;
            case 5: v = block.y; break;
            case 6: v = block.z; break;
            case 7: case 8: case 9: v = 0; break;      // remainder
            case 10: case 11: case 12: v = 0; break;   // global offset
            case 13: v = (uint64_t)dims; break;
            default: v = 0; break;
        }
        if (a.size == 2) { uint16_t t = (uint16_t)v; memcpy(ka + a.off, &t, 2); }
        else if (a.size == 4) { uint32_t t = (uint32_t)v; memcpy(ka + a.off, &t, 4); }
        else { memcpy(ka + a.off, &v, 8); }
        (void)w;
    }

    hsa_kernel_dispatch_packet_t* pkt = (hsa_kernel_dispatch_packet_t*)(
        (char*)g_queue->base_address +
        (hsa_queue_load_write_index_relaxed(g_queue) % g_queue->size) * sizeof(*pkt));
    memset(pkt, 0, sizeof(*pkt));
    // setup 的低 2 位是 grid 维度数（1/2/3），不是「已初始化」标志。
    // 写死 1 会让运行时合法地忽略 grid_size_y/z（workgroup_id_y/z 恒为 0）。
    pkt->setup = (uint16_t)dims;
    pkt->workgroup_size_x = (uint16_t)block.x;
    pkt->workgroup_size_y = (uint16_t)block.y;
    pkt->workgroup_size_z = (uint16_t)block.z;
    pkt->grid_size_x = gx;
    pkt->grid_size_y = gy;
    pkt->grid_size_z = gz;
    pkt->private_segment_size = k->private_size;
    pkt->group_segment_size = k->group_size + (uint32_t)smem;
    pkt->kernel_object = g_kobj[k - k_table];
    pkt->kernarg_address = ka;
    hsa_signal_store_screlease(g_sig[slot], 1);
    pkt->completion_signal = g_sig[slot];
    const uint16_t header = (uint16_t)(
        (HSA_PACKET_TYPE_KERNEL_DISPATCH << HSA_PACKET_HEADER_TYPE) |
        (HSA_FENCE_SCOPE_SYSTEM << HSA_PACKET_HEADER_SCACQUIRE_FENCE_SCOPE) |
        (HSA_FENCE_SCOPE_SYSTEM << HSA_PACKET_HEADER_SCRELEASE_FENCE_SCOPE));
    static const int dbg = getenv("RT_HSART_DEBUG") ? atoi(getenv("RT_HSART_DEBUG")) : 0;
    if (dbg)
        fprintf(stderr, "hsa_rt: %-28s grid=(%u,%u,%u) wg=(%u,%u,%u) kernarg=%p kobj=%llu "
                        "group=%u(+%d) priv=%u ksize=%zu\n",
                k->lookup, (unsigned)gx, (unsigned)gy, (unsigned)gz,
                (unsigned)block.x, (unsigned)block.y, (unsigned)block.z, (void*)ka,
                (unsigned long long)g_kobj[k - k_table], k->group_size, smem,
                k->private_size, kernarg_size);
    __atomic_store_n(&pkt->header, header, __ATOMIC_RELEASE);
    const uint64_t index = hsa_queue_load_write_index_relaxed(g_queue);
    hsa_queue_store_write_index_screlease(g_queue, index + 1);
    hsa_signal_store_screlease(g_queue->doorbell_signal, index);
    g_slot_used[slot] = true;
    g_next = (g_next + 1) % N_SLOT;
}

// ============================ HIP API ============================
hipError_t hipMalloc(void** p, size_t n) {
    hsart_init(nullptr);
    if (!n) n = 1;
    *p = pool_alloc(g_data_pool, n);
    return hipSuccess;
}

hipError_t hipHostMalloc(void** p, size_t n) {
    if (posix_memalign(p, 4096, n < 4096 ? 4096 : n) != 0) return 1;   // 4K 对齐（O_DIRECT 用）
    return hipSuccess;
}

hipError_t hipFree(void* p) {
    if (p) hsa_amd_memory_pool_free(p);
    return hipSuccess;
}

hipError_t hipDeviceSynchronize() {
    if (!g_queue) return hipSuccess;
    std::lock_guard<std::mutex> lk(g_mtx);
    for (int i = 0; i < N_SLOT; i++)
        if (g_slot_used[i])
            hsa_signal_wait_scacquire(g_sig[i], HSA_SIGNAL_CONDITION_LT, 1, UINT64_MAX,
                                      HSA_WAIT_STATE_ACTIVE);
    return hipSuccess;
}

hipError_t hipMemcpy(void* dst, const void* src, size_t n, int kind) {
    hsart_init(nullptr);
    if (kind == hipMemcpyHostToDevice) {
        copy_h2d(dst, src, n);
    } else if (kind == hipMemcpyDeviceToHost) {
        hipDeviceSynchronize();          // 源可能刚被内核写过
        copy_d2h(dst, src, n);
    } else {
        hipDeviceSynchronize();          // 源可能刚被内核写过
        HSA_CHECK(hsa_memory_copy(dst, src, n));
    }
    return hipSuccess;
}

hipError_t hipMemcpyAsync(void* dst, const void* src, size_t n, int kind, hipStream_t) {
    return hipMemcpy(dst, src, n, kind);
}

// 二维拷贝：height 行、每行 width 字节，两侧行距各自为 pitch。
// 垫片里的 hipMemcpy 本来就是同步的（hipMemcpyAsync 只是转发），所以这里只在
// 「行距 != 行宽」时按行拆开搬；整块连续时退化成一次拷贝。
// KV 槽池（Model::kv_copy_slot）走的就是这条路径：live 侧按 max_ctx 的步长、
// 槽内紧排，设备到设备。
hipError_t hipMemcpy2DAsync(void* dst, size_t dpitch, const void* src, size_t spitch,
                            size_t width, size_t height, int kind, hipStream_t) {
    hsart_init(nullptr);
    if (width == 0 || height == 0) return hipSuccess;
    if (dpitch == width && spitch == width)          // 两侧都紧排：一次搬完
        return hipMemcpy(dst, src, width * height, kind);
    if (kind != hipMemcpyHostToDevice) hipDeviceSynchronize();   // 源可能刚被内核写过
    char* d = static_cast<char*>(dst);
    const char* s = static_cast<const char*>(src);
    for (size_t r = 0; r < height; r++) {
        void* dr = d + r * dpitch;
        const void* sr = s + r * spitch;
        if (kind == hipMemcpyHostToDevice)        copy_h2d(dr, sr, width);
        else if (kind == hipMemcpyDeviceToHost)   copy_d2h(dr, sr, width);
        else                                      HSA_CHECK(hsa_memory_copy(dr, sr, width));
    }
    return hipSuccess;
}

hipError_t hipMemset(void* p, int v, size_t n) {
    hipDeviceSynchronize();
    memset(p, v, n);
    return hipSuccess;
}

hipError_t hipStreamCreate(hipStream_t* s) { *s = new StreamImpl(); return hipSuccess; }
hipError_t hipStreamSynchronize(hipStream_t) { return hipDeviceSynchronize(); }
hipError_t hipStreamWaitEvent(hipStream_t, hipEvent_t e, unsigned) {
    return hipEventSynchronize(e);
}

hipError_t hipEventCreate(hipEvent_t* e) { *e = new EventImpl(); return hipSuccess; }
hipError_t hipEventCreateWithFlags(hipEvent_t* e, unsigned) { return hipEventCreate(e); }
hipError_t hipEventRecord(hipEvent_t e, hipStream_t) {
    if (!e) return hipSuccess;
    e->seq.fetch_add(1, std::memory_order_release);
    return hipSuccess;
}
hipError_t hipEventSynchronize(hipEvent_t e) {
    if (!e) return hipSuccess;
    const uint64_t want = e->seq.load(std::memory_order_acquire);
    if (want == 0) return hipSuccess;            // 没记录过：按 HIP 语义是空操作
    while (e->seq.load(std::memory_order_acquire) < want) std::this_thread::yield();
    return hipSuccess;
}
hipError_t hipEventElapsedTime(float* ms, hipEvent_t, hipEvent_t) { *ms = 0.f; return hipSuccess; }

hipError_t hipGetLastError() { return hipSuccess; }
const char* hipGetErrorString(hipError_t) { return "hsa_rt"; }
