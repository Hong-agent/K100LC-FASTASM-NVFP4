// 后台按「组」预取权重，把**磁盘读/上传**和**GPU 计算**重叠起来。
//
// 组的划分对应前向的执行顺序：group 0 = embedding 那一批，group 1+il = 第 il 层，
// 最后一组 = lm_head / MTP / 视觉塔。主线程在用到某一组之前
// `hipStreamWaitEvent(默认流, 该组的事件)`，于是 GPU 可以一边算第 il 层、
// 一边让加载线程把第 il+1 层从磁盘搬进来，谁也不用等谁。
//
// 为什么需要一个线程：`hipMemcpyAsync` 的源如果是 pageable 内存（mmap 出来的
// 文件页就是），它会退化成同步拷贝。所以这里用 page-locked 缓冲 + pread，
// 由加载线程负责「读盘 -> 排队异步拷贝」，并用事件做缓冲复用。
#pragma once
#include <hip/hip_runtime.h>
#include <atomic>
#include <thread>
#include <vector>
#include <algorithm>
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <fcntl.h>
#include <unistd.h>

#define PF_CK(x) do { hipError_t e_ = (x); if (e_ != hipSuccess) { \
    printf("prefetch HIP ERR %s @%d: %s\n", #x, __LINE__, hipGetErrorString(e_)); exit(1);} } while (0)

class Prefetch {
public:
    struct Item { int file; size_t off; uint8_t* dst; size_t bytes; int group; };
    static constexpr int    NBUF  = 4;
    static constexpr size_t CHUNK = 32ull << 20;

    // 权重可能来自多个文件（RT4 权重 + 原始 NVFP4 safetensors）
    int add_file(const char* path, bool direct = false) {
        // O_DIRECT 绕开页缓存：本机只有 7.5GB 内存，13GB 的文件走页缓存会被反复换出，
        // 实测只有 0.96 GB/s；同一块盘 O_DIRECT 顺序读能到 3.1 GB/s。
        int fd = open(path, O_RDONLY | (direct ? O_DIRECT : 0));
        if (fd < 0 && direct) {
            printf("prefetch: O_DIRECT 打不开 %s，退回带缓存读\n", path);
            fd = open(path, O_RDONLY);
        }
        if (fd < 0) { printf("prefetch: 打不开 %s\n", path); exit(1); }
        fds.push_back(fd);
        return (int)fds.size() - 1;
    }

    // 线性模式：整个文件从 0 开始顺序读进一块连续的设备显存，读到哪一组就记哪一组的事件。
    // group_ends 必须覆盖 0..ngroups-1（空组就填上一个组的结束位置），按结束偏移升序。
    // file_base：载荷在文件里的起始偏移（.rp4 的头+索引在前面，不能从 0 读）
    void set_linear(size_t file_base, uint8_t* dst, size_t bytes,
                    std::vector<std::pair<int, size_t>> group_ends) {
        lin_base = file_base;
        lin_dst = dst; lin_bytes = bytes; lin_groups = std::move(group_ends);
        linear = true;
        ngroups = 0;
        for (auto& g : lin_groups) ngroups = std::max(ngroups, g.first + 1);
    }

    void add(int file, size_t off, void* dst, size_t bytes, int group) {
        if (!bytes) return;
        items.push_back({file, off, (uint8_t*)dst, bytes, group});
        if (group + 1 > ngroups) ngroups = group + 1;
    }

    // items 必须在调用前按 group 排好（add 的顺序就是加载顺序）
    void start() {
        if (!linear && items.empty()) return;
        // 两个来源（RT4 权重 + 原始 NVFP4 safetensors）是分别 add 的，
        // 这里统一按组排一遍；不排的话后 add 进来的那些永远轮不到加载。
        std::stable_sort(items.begin(), items.end(),
                         [](const Item& a, const Item& b) { return a.group < b.group; });
        if (getenv("RT_PREFETCH") && atoi(getenv("RT_PREFETCH")) == 0) {
            sync_load();
            return;
        }
        for (int i = 0; i < NBUF; i++) {
            PF_CK(hipHostMalloc(&pin[i], CHUNK + 4096));   // O_DIRECT 需要按块对齐，留余量
            PF_CK(hipEventCreateWithFlags(&buf_ev[i], hipEventDisableTiming));
        }
        PF_CK(hipStreamCreate(&load_stream));
        grp_ev.assign(ngroups, nullptr);
        for (int i = 0; i < ngroups; i++)
            PF_CK(hipEventCreateWithFlags(&grp_ev[i], hipEventDisableTiming));
        th = std::thread([this] { run(); });
    }

    // 让默认流（计算流）等这一组传完；不等也能跑，只是可能读到还没到的数据
    // 注意：`hipStreamWaitEvent` 对**还没记录过**的事件是空操作，所以必须先用
    // 主机侧的计数器确认这一组已经开始/完成加载，再去等事件，否则等于没等。
    void wait_group(int g) {
        if (!th.joinable()) return;                  // 同步兜底路径：已经全加载完了
        if (g < 0 || g >= (int)grp_ev.size()) return;
        while (ready.load(std::memory_order_acquire) <= g) std::this_thread::yield();
        PF_CK(hipStreamWaitEvent(0, grp_ev[g], 0));
    }

    void finish() { if (th.joinable()) th.join(); }
    bool async() const { return th.joinable(); }
    double seconds() const { return secs; }
    // 别让 std::thread 在还 joinable 的时候被析构（否则 std::terminate）
    ~Prefetch() { if (th.joinable()) th.join(); }

private:
    void run() {
        const double t0 = now();
        int bi = 0;
        if (linear) {
            size_t done = 0, gi = 0;
            while (done < lin_bytes) {
                PF_CK(hipEventSynchronize(buf_ev[bi]));
                const size_t n = std::min(CHUNK, lin_bytes - done);
                const size_t na = (n + 4095) & ~(size_t)4095;      // O_DIRECT: 长度按 4K 向上取
                const ssize_t got = pread(fds[0], pin[bi], na, (off_t)(lin_base + done));
                if (got < (ssize_t)n) {
                    printf("prefetch(linear): pread off=%zu n=%zu got=%zd\n", done, na, got);
                    exit(1);
                }
                PF_CK(hipMemcpyAsync(lin_dst + done, pin[bi], n, hipMemcpyHostToDevice, load_stream));
                PF_CK(hipEventRecord(buf_ev[bi], load_stream));
                done += n;
                bi = (bi + 1) % NBUF;
                while (gi < lin_groups.size() && lin_groups[gi].second <= done) {
                    PF_CK(hipEventRecord(grp_ev[lin_groups[gi].first], load_stream));
                    ready.store(lin_groups[gi].first + 1, std::memory_order_release);
                    gi++;
                }
            }
            PF_CK(hipStreamSynchronize(load_stream));
            secs = now() - t0;
            done_flag = true;
            return;
        }
        size_t i = 0;
        for (int g = 0; g < ngroups; g++) {
            while (i < items.size() && items[i].group == g) {
                const Item& it = items[i++];
                size_t done = 0;
                while (done < it.bytes) {
                    PF_CK(hipEventSynchronize(buf_ev[bi]));       // 这个缓冲上次的拷贝完了吗
                    const size_t n = std::min(CHUNK, it.bytes - done);
                    const ssize_t got = pread(fds[it.file], pin[bi], n, (off_t)(it.off + done));
                    if (got != (ssize_t)n) {
                        printf("prefetch: pread 失败 off=%zu n=%zu got=%zd\n", it.off + done, n, got);
                        exit(1);
                    }
                    PF_CK(hipMemcpyAsync(it.dst + done, pin[bi], n, hipMemcpyHostToDevice, load_stream));
                    PF_CK(hipEventRecord(buf_ev[bi], load_stream));
                    done += n;
                    bi = (bi + 1) % NBUF;
                }
            }
            PF_CK(hipEventRecord(grp_ev[g], load_stream));
            ready.store(g + 1, std::memory_order_release);
        }
        PF_CK(hipStreamSynchronize(load_stream));
        secs = now() - t0;
        done_flag = true;
    }

    // 关掉预取时的同步兜底：直接拷，不重叠
    void sync_load() {
        std::vector<uint8_t> buf(CHUNK);
        const double t0 = now();
        for (const Item& it : items) {
            size_t done = 0;
            while (done < it.bytes) {
                const size_t n = std::min(CHUNK, it.bytes - done);
                const ssize_t got = pread(fds[it.file], buf.data(), n, (off_t)(it.off + done));
                if (got != (ssize_t)n) { printf("prefetch: pread 失败\n"); exit(1); }
                PF_CK(hipMemcpy(it.dst + done, buf.data(), n, hipMemcpyHostToDevice));
                done += n;
            }
        }
        secs = now() - t0;
        done_flag = true;
    }

    static double now() {
        struct timespec ts;
        clock_gettime(CLOCK_MONOTONIC, &ts);
        return ts.tv_sec + ts.tv_nsec * 1e-9;
    }

public:
    std::atomic<bool> done_flag{false};
    std::atomic<int> ready{0};        // 已登记的组数（组按顺序完成）
private:
    std::vector<Item> items;
    std::vector<hipEvent_t> grp_ev;
    std::vector<int> fds;
    bool linear = false;
    size_t lin_base = 0;
    uint8_t* lin_dst = nullptr;
    size_t lin_bytes = 0;
    std::vector<std::pair<int, size_t>> lin_groups;
    hipEvent_t buf_ev[NBUF] = {};
    void* pin[NBUF] = {};
    hipStream_t load_stream = nullptr;
    std::thread th;
    int ngroups = 0;
    double secs = 0;
};
