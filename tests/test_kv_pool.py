#!/usr/bin/env python3
"""全局 KV 槽池的离线单测：把 src/model.cpp 的 [kv_pool] 段原样抽出来，
配上测试 main 编译运行，只测纯宿主决策逻辑（布局/匹配/驱逐/泊船回港），
不碰 GPU。model.cpp 里那段改了，这里自动跟着走（标记不同步会直接报错）。

覆盖：
  1. layout        槽备份几何：段序、紧排、快照/MTP 增量、seq=0 退化
  2. best_match    append/rewind 语义、活跃槽排除、失步守卫、起点大者赢
  3. acquire_home  空槽优先、LRU 驱逐、keep 保护、预算、active 原位
  4. 生命周期      commit_save/restore、drop_active、clear_all、free_dev
  5. 全流程模拟    A→B→A→C→B→A、rewind 回港、LRU 逐槽、预算逐槽、
                   放弃入池（退回旧行为）、池关闭（不影响单上下文复用）
"""
import os
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# 模拟 run_prefill 的决策路径（宿主侧），管芯逻辑与 src/model.cpp 保持同构：
# 池优先 → 当前上下文 append/rewind → 都不行先泊船再整段重算。
MAIN = r'''
// ================================ 测试 ================================
#include <cstdio>

static int n_fail = 0;
static void check(const char* name, bool cond) {
    printf("%s  %s\n", cond ? "ok  " : "FAIL", name);
    if (!cond) n_fail++;
}

// 直接摆一个「已泊」槽（绕开 acquire/commit，专测决策逻辑）
static void use(KvPool& q, int i, size_t b) {
    q.slots[i].used = true;  q.slots[i].bytes = b;
    q.slots[i].tick = ++q.tick;  q.total_bytes += b;
}

// ---------- 1. layout：槽备份几何 ----------
static void test_layout() {
    KvDims d{8, 128, 4, 64, 8192, 4096, 2, 3, 16, 8};
    std::vector<KvSeg> g;
    const size_t L1 = KvPool::layout(d, 100, 99, false, false, &g);
    check("layout 基础段数 17", g.size() == 17);
    check("layout 带 segs 与不带一致", L1 == KvPool::layout(d, 100, 99, false, false, nullptr));
    const int want_src[17] = {0,0, 1,1, 2, 6,7,8,9, 6,7,8,9, 6,7,8,9};
    bool order = true;
    for (int i = 0; i < 17; i++) order = order && g[i].src == want_src[i];
    check("layout 段顺序", order);
    bool tight = true, contig = true;
    for (size_t i = 0; i < g.size(); i++) {
        tight = tight && g[i].pitch_slot == g[i].width;   // 槽内紧排
        if (i) contig = contig && g[i].off == g[i-1].off + g[i-1].width * g[i-1].height;
    }
    check("layout 槽内 pitch==width", tight);
    check("layout 偏移连续无空洞",
          contig && L1 == g.back().off + g.back().width * g.back().height);
    // 线性段：ssm/conv 每层一行，hprev 单段
    check("ssm 段几何", g[0].width == (size_t)16*4 && g[0].height == 1 && g[0].pitch_live == (size_t)16*4);
    check("conv 段几何", g[2].width == (size_t)8*4 && g[2].height == 1);
    check("hprev 段几何", g[4].width == (size_t)4096*4 && g[4].height == 1);
    // 注意力段（seq=100：krow=100*32*4，vrows=25，vtiles=2）
    check("kc 几何",  g[5].width == (size_t)100*(128/4)*4 && g[5].height == 8 &&
                      g[5].pitch_live == (size_t)8192*(128/4)*4);
    // ksc 是「组优先」的 [H][2][kv]：两个 128 维组各占一整段 kv，整块按 [H*2][kv]
    // 连续，所以每层搬 KV*2 行、行距 = 一整段 kv（见 src/k_new.hip 的 k_kv_append_k
    // 与 src/k_fa.hip 的 Kscb[g*kv_cap + kv]）。这里 KV=8 → 16 行。
    check("ksc 几何", g[6].width == (size_t)100*4 && g[6].height == 16 &&
                      g[6].pitch_live == (size_t)8192*4);
    check("vc 几何",  g[7].width == ((100+3)/4)*(size_t)128*4 && g[7].height == 8 &&
                      g[7].pitch_live == (8192/4)*(size_t)128*4);
    check("vsc 几何", g[8].width == ((100+63)/64)*(size_t)128*4 && g[8].height == 8 &&
                      g[8].pitch_live == (8192/64)*(size_t)128*4);
    // 回归守卫：每段在 live 侧必须落在该注意力层自己的分配里（layer_bytes），
    // 即 (height-1)*pitch_live + width ≤ layer_bytes。
    const size_t KV = 8, MC = 8192, D = 128, KVEL = 4, BG = 64;
    const size_t layer_bytes[4] = { KV * MC * (D / KVEL) * 4, KV * 2 * MC * 4,
                                    KV * (MC / KVEL) * D * 4, KV * (MC / BG) * D * 4 };
    bool fit = true;
    for (int k = 0; k < 4; k++) {
        const KvSeg& s = g[5 + k];
        fit = fit && (s.height - 1) * s.pitch_live + s.width <= layer_bytes[k];
    }
    check("注意力段不越出每层分配", fit);
    // 总量手算：线性 16576 + 3 层 × (8×(12800+800+12800+1024))
    check("layout 总字节", L1 == 2*(size_t)64 + 2*(size_t)32 + (size_t)4096*4
                                  + 3 * 8 * (12800 + 800 + 12800 + 1024));
    // 快照：多 5 段（snap_ssm×2 snap_conv×2 snap_hprev）
    std::vector<KvSeg> g2;
    const size_t L2 = KvPool::layout(d, 100, 99, true, false, &g2);
    check("layout 快照多 5 段", g2.size() == 22 && g2[5].src == 3 && g2[7].src == 4 && g2[9].src == 5);
    check("layout 快照增量", L2 == L1 + 2*(size_t)64 + 2*(size_t)32 + (size_t)4096*4);
    // MTP：末尾多 4 段，几何按 mtp 长度（99：mrow=12672，mvrows=25，mvtiles=2）
    std::vector<KvSeg> g3;
    const size_t L3 = KvPool::layout(d, 100, 99, true, true, &g3);
    check("layout MTP 多 4 段", g3.size() == 26 && g3[22].src == 10 && g3[25].src == 13);
    check("layout MTP 段几何",
          g3[22].width == (size_t)99*32*4 && g3[23].width == (size_t)99*4 &&
          g3[23].height == 16 && g3[23].pitch_live == (size_t)8192*4 &&
          g3[24].width == ((99+3)/4)*(size_t)128*4 && g3[25].width == ((99+63)/64)*(size_t)128*4);
    check("layout MTP 增量",
          L3 == L2 + 8 * ((size_t)99*32*4 + 2*(size_t)99*4 + 25*(size_t)512 + 2*(size_t)512));
    // seq=0：注意力段全零宽，只剩线性部分
    check("layout seq=0 只剩线性",
          KvPool::layout(d, 0, 0, false, false, nullptr) == 2*(size_t)64 + 2*(size_t)32 + (size_t)4096*4);
    // 注意力段按 seq、MTP 段按 mtp，互不干扰
    std::vector<KvSeg> g4;
    KvPool::layout(d, 100, 50, false, true, &g4);
    check("layout attn/MTP 各按各长度",
          g4[5].width == (size_t)100*32*4 && g4[17].width == (size_t)50*32*4);
}

// ---------- 2. best_match ----------
static void test_best_match() {
    KvPool p;
    p.config(4, 1ull << 30);
    auto mk = [&](int i, std::vector<int> ids, int seq, int snap, bool sv, size_t bytes) {
        p.slots[i].ids = ids;  p.slots[i].seq_len = seq;
        p.slots[i].snap_len = snap;  p.slots[i].snap_valid = sv;
        p.slots[i].used = true;  p.slots[i].bytes = bytes;
        p.slots[i].tick = ++p.tick;  p.total_bytes += bytes;
    };
    const std::vector<int> A = {1,2,3,4,5,6,7,8,9,10};
    const std::vector<int> B = {1,2,3,4,5,20,21,22,23,24};
    mk(0, A, 10, -1, false, 100);
    mk(1, B, 10, 5, true, 100);
    mk(3, A, 9, -1, false, 100);            // ids.size()=10 != seq_len=9：失步守卫
    auto bm = [&](const std::vector<int>& q) { return p.best_match(q); };

    check("append 命中整段延续",
          bm({1,2,3,4,5,6,7,8,9,10,11,12}) == std::make_pair(0, (size_t)10));
    check("rewind 命中快照点",
          bm({1,2,3,4,5,30,31}) == std::make_pair(1, (size_t)5));
    check("无前缀关系不命中", bm({99,98}) == std::make_pair(-1, (size_t)0));
    check("比槽短不命中",      bm({1,2,3}) == std::make_pair(-1, (size_t)0));
    p.slots[1].used = false;                // 屏蔽 B 的快照点干扰，单测「完全相等」语义
    check("完全相等不算延续",  bm(A) == std::make_pair(-1, (size_t)0));
    p.slots[1].used = true;
    // 起点更大者赢：槽 2={1,2,3} append 起点 3 vs 槽 1 rewind 起点 5
    mk(2, {1,2,3}, 3, -1, false, 100);
    check("起点更大者赢", bm({1,2,3,4,5,40}) == std::make_pair(1, (size_t)5));
    p.slots[2] = KvSlot{};  p.total_bytes -= 100;
    // 活跃槽不参与（活跃上下文在外面直接比）
    p.active = 0;
    check("活跃槽被排除",
          bm({1,2,3,4,5,6,7,8,9,10,11}) == std::make_pair(1, (size_t)5));
    p.active = -1;
    // 失步守卫：唯一匹配的槽 ids/seq_len 对不上 → 跳过
    p.slots[0].used = false;  p.slots[1].used = false;
    check("失步槽被跳过",
          bm({1,2,3,4,5,6,7,8,9,10,11}) == std::make_pair(-1, (size_t)0));
}

// ---------- 3. acquire_home ----------
static void test_acquire() {
    {   // 关闭的池：一切查询都空
        KvPool z;  z.config(0, 0);
        check("关闭的池不命中", z.best_match({1,2}) == std::make_pair(-1, (size_t)0));
        check("关闭的池不可泊", z.acquire_home(10) == -1);
    }
    {   // 空槽优先，从 0 号开始；need 越界/为 0 直接放弃
        KvPool q;  q.config(4, 1000);
        check("空池首选 0 号槽", q.acquire_home(500) == 0);
        check("need 超总预算放弃", q.acquire_home(1001) == -1);
        check("need 为 0 放弃", q.acquire_home(0) == -1);
        use(q, 0, 400);  use(q, 1, 300);
        check("空槽按序取用", q.acquire_home(200) == 2);
        use(q, 2, 200);  use(q, 3, 100);
        // 满池 → 驱逐最旧（tick 最小 = 槽 0），腾出的槽当宿主
        check("满池驱逐最旧", q.acquire_home(150) == 0 && !q.slots[0].used && q.n_evict == 1);
    }
    {   // keep 保护：绝不住进/驱逐 keep 指的槽
        KvPool q;  q.config(4, 1000);
        for (int i = 0; i < 4; i++) use(q, i, 100);
        check("keep 槽不被驱逐", q.acquire_home(150, 1) == 0 && q.slots[1].used);
        KvPool s;  s.config(1, 1000);
        use(s, 0, 100);
        check("无槽可驱放弃", s.acquire_home(50, 0) == -1 && s.slots[0].used);
    }
    {   // active 槽原位更新（哪怕还有空槽）
        KvPool q;  q.config(4, 1000);
        q.active = 1;  use(q, 1, 100);
        check("active 槽原位更新", q.acquire_home(200) == 1);
    }
    {   // 预算不够就驱别的槽（keep 优先级最高，先驱非 keep）
        KvPool q;  q.config(3, 1000);
        use(q, 0, 600);  use(q, 1, 300);
        const int h = q.acquire_home(500, 1);
        check("预算不足逐旧槽(keep 保护)",
              h == 2 && !q.slots[0].used && q.slots[1].used && q.n_evict == 1);
        // keep 挤爆预算：驱光了别人还不够 → 放弃（keep 槽完好）
        KvPool r;  r.config(3, 1000);
        use(r, 0, 600);  use(r, 1, 600);
        check("keep 挤爆预算放弃",
              r.acquire_home(500, 0) == -1 && r.slots[0].used && !r.slots[1].used);
    }
}

// ---------- 4. 生命周期 ----------
static void test_lifecycle() {
    KvPool c;  c.config(3, 1 << 20);
    int freed = 0;
    c.free_dev = [&](void*) { freed++; };
    int home = c.acquire_home(100);
    check("泊船拿到空槽", home == 0);
    c.commit_save(home, {1,2,3}, 3, 3, 2, true, (void*)0x11, 100);
    check("commit_save 记账",
          c.active == 0 && c.slots[0].seq_len == 3 && c.slots[0].bytes == 100 &&
          c.total_bytes == 100 && c.n_save == 1 && c.slots[0].ids.size() == 3);
    home = c.acquire_home(200);              // active=0 → 原位
    check("active 原位", home == 0);
    c.commit_save(0, {1,2,3,4}, 4, 4, 3, true, (void*)0x22, 200);
    check("原位更新记账",
          c.total_bytes == 200 && c.slots[0].seq_len == 4 && c.n_save == 2 &&
          c.slots[0].tick == 2);
    c.commit_restore(0);
    check("commit_restore 记账",
          c.active == 0 && c.n_restore == 1 && c.slots[0].tick == 3);
    c.slots[1].used = true;  c.slots[1].bytes = 50;  c.slots[1].dev = (void*)0x33;
    c.slots[1].tick = ++c.tick;  c.total_bytes += 50;
    c.drop_active();
    check("drop_active 只断开不断内容",
          c.active == -1 && c.slots[0].used && c.slots[1].used);
    c.clear_all();
    check("clear_all 释放全部并归零",
          freed == 2 && c.total_bytes == 0 && !c.slots[0].used &&
          !c.slots[1].used && c.active == -1);
    check("clear_all 不算驱逐", c.n_evict == 0);
    // 驱逐要经 free_dev 释放设备缓冲
    KvPool e;  e.config(2, 1 << 20);
    int ef = 0;
    e.free_dev = [&](void*) { ef++; };
    use(e, 0, 10);  e.slots[0].dev = (void*)0x44;
    use(e, 1, 10);  e.slots[1].dev = (void*)0x55;
    check("驱逐释放设备缓冲", e.acquire_home(10) == 0 && ef == 1 && e.n_evict == 1);
}

// ---------- 5. 全流程模拟（决策逻辑与 run_prefill 同构） ----------
// 只模拟宿主侧决策：prefill 返回「真正要算的起点」（0=整段重算）。
struct SimCtx {
    KvPool* pool;
    std::vector<int> ctx_ids;
    int seq_len = 0, snap_len = -1;
    bool snap_valid = false;

    void save_active(int keep = -1) {
        if (ctx_ids.empty() || (int)ctx_ids.size() != seq_len) return;
        const size_t need = ctx_ids.size() * 10 + 100;      // 假装的字节数
        const int home = pool->acquire_home(need, keep);
        if (home < 0) return;
        pool->commit_save(home, ctx_ids, seq_len, seq_len, snap_len, snap_valid,
                          (void*)(size_t)(home + 1), need);
    }
    bool restore_slot(int idx) {
        KvSlot& s = pool->slots[idx];
        if (!s.used || s.bytes == 0 || (int)s.ids.size() != s.seq_len) return false;
        ctx_ids = s.ids;  seq_len = s.seq_len;
        snap_len = s.snap_valid ? s.snap_len : -1;
        snap_valid = s.snap_valid;
        pool->commit_restore(idx);
        return true;
    }
    void reset() {
        ctx_ids.clear();  seq_len = 0;  snap_len = -1;  snap_valid = false;
        pool->drop_active();
    }
    size_t prefill(const std::vector<int>& ids) {
        size_t start = 0;
        if ((int)ctx_ids.size() != seq_len) { ctx_ids.clear(); snap_valid = false; snap_len = -1; pool->drop_active(); }
        if (pool->cap > 0) {                                // 先问全局槽池
            size_t active_start = 0;
            if (!ctx_ids.empty() && (int)ctx_ids.size() == seq_len) {
                const size_t alim = std::min(ctx_ids.size(), ids.size());
                size_t alcp = 0;
                while (alcp < alim && ctx_ids[alcp] == ids[alcp]) alcp++;
                if (alcp == ctx_ids.size() && alcp < ids.size()) active_start = alcp;
                else if (snap_valid && alcp >= (size_t)snap_len && (size_t)snap_len < ids.size())
                    active_start = (size_t)snap_len;
            }
            const auto [si, sstart] = pool->best_match(ids);
            if (si >= 0 && sstart > active_start) {
                save_active(si);
                restore_slot(si);
            }
        }
        if ((int)ctx_ids.size() == seq_len && !ctx_ids.empty()) {   // 当前上下文 append/rewind
            const size_t lim = std::min(ctx_ids.size(), ids.size());
            size_t lcp = 0;
            while (lcp < lim && ctx_ids[lcp] == ids[lcp]) lcp++;
            if (lcp == ctx_ids.size() && lcp < ids.size()) {
                start = lcp;
            } else if (snap_valid && lcp >= (size_t)snap_len && (size_t)snap_len < ids.size()) {
                start = (size_t)snap_len;                  // rewind：退回快照点
                ctx_ids.resize(start);  seq_len = (int)start;
            }
        }
        if (start == 0) { save_active(); reset(); }
        ctx_ids.insert(ctx_ids.end(), ids.begin() + start, ids.end());
        seq_len = (int)ids.size();
        snap_len = (int)ids.size() - 2;  snap_valid = true;   // 模拟 RT_KV_TAIL=2
        return start;
    }
};

static void test_flow_aba() {
    KvPool P;  P.config(8, 1ull << 30);
    SimCtx sim{&P};
    const std::vector<int> A1 = {1,2,3,4,5,6,7,8,9,10};
    const std::vector<int> B1 = {100,101,102,103,104,105};
    const std::vector<int> C1 = {200,201,202};
    std::vector<int> A2 = A1;  A2.push_back(11);  A2.push_back(12);
    std::vector<int> A3 = A2;  A3.push_back(13);
    std::vector<int> B2 = B1;  B2.push_back(106);
    std::vector<int> B3 = B2;  B3.push_back(107);
    std::vector<int> B4 = B3;  B4.push_back(108);
    std::vector<int> A4 = A3;  A4.push_back(14);

    check("A 首轮整段算", sim.prefill(A1) == 0);
    check("A 二轮只补差量", sim.prefill(A2) == 10);
    check("切到 B 整段算", sim.prefill(B1) == 0);
    check("切走时 A 泊进槽 0", P.n_save == 1 && P.slots[0].seq_len == (int)A2.size());
    check("B 二轮只补差量", sim.prefill(B2) == 6);
    check("回到 A 从槽 0 复用", sim.prefill(A3) == 12);
    check("回港前 B 泊进槽 1", P.n_save == 2 && P.n_restore == 1 &&
                              P.slots[1].seq_len == (int)B2.size());
    check("切到 C 整段算", sim.prefill(C1) == 0);
    check("A 原位更新进槽 0", P.n_save == 3 && P.slots[0].seq_len == (int)A3.size());
    check("回到 B 从槽 1 复用", sim.prefill(B3) == 7);
    check("C 泊进新槽 2", P.n_save == 4 && P.n_restore == 2 &&
                         P.slots[2].seq_len == (int)C1.size());
    check("B 三轮只补差量", sim.prefill(B4) == 8);
    check("再回 A 从槽 0 复用", sim.prefill(A4) == 13);
    check("B 原位更新进槽 1", P.n_save == 5 && P.n_restore == 3 &&
                             P.slots[1].seq_len == (int)B4.size());
    check("槽内容终态", P.slots[0].seq_len == (int)A3.size() &&
                       P.slots[1].seq_len == (int)B4.size() &&
                       P.slots[2].seq_len == (int)C1.size());
    check("全程无驱逐", P.n_evict == 0);
}

static void test_flow_rewind() {
    // 客户端只回传正文：token 只命中到快照点 → 槽回港后从快照点补
    KvPool R;  R.config(2, 1ull << 30);
    SimCtx rs{&R};
    const std::vector<int> D1 = {5,6,7,8,9,10};
    const std::vector<int> E1 = {50,51};
    const std::vector<int> D2 = {5,6,7,8,20,21};   // 只命中 D1 的快照点(4)
    check("D 首轮整段算", rs.prefill(D1) == 0);
    check("切到 E 整段算", rs.prefill(E1) == 0);
    check("回 D 从快照点补", rs.prefill(D2) == 4);
    check("回港一次", R.n_restore == 1);
}

static void test_flow_lru() {
    // 槽比对话少：A→B→C→A 时最旧的 B 被逐，A 命中，B 再来只能整段重算
    KvPool L;  L.config(2, 1ull << 30);
    int evicted = 0;
    L.free_dev = [&](void*) { evicted++; };
    SimCtx ls{&L};
    const std::vector<int> A1 = {1,2,3,4,5,6,7,8,9,10};
    const std::vector<int> B1 = {100,101,102,103,104,105};
    const std::vector<int> C1 = {200,201,202};
    std::vector<int> A2 = A1;  A2.push_back(11);  A2.push_back(12);
    std::vector<int> B2 = B1;  B2.push_back(106);

    ls.prefill(A1);  ls.prefill(B1);  ls.prefill(C1);
    check("A→B→C：A、B 各占一槽", L.slots[0].seq_len == (int)A1.size() &&
                                L.slots[1].seq_len == (int)B1.size());
    check("回 A 命中槽 0", ls.prefill(A2) == 10);
    check("B 被逐、C 顶替进槽 1", evicted == 1 && L.n_evict == 1 &&
                                L.slots[1].seq_len == (int)C1.size());
    check("B 再来只能整段重算", ls.prefill(B2) == 0);
}

static void test_flow_budget() {
    // 预算压力下回港：要恢复的槽（keep）绝不能被预算驱逐误杀
    KvPool M;  M.config(8, 400);
    int ev2 = 0;
    M.free_dev = [&](void*) { ev2++; };
    SimCtx ms{&M};
    const std::vector<int> A1 = {1,2,3,4,5,6,7,8,9,10};     // need 200
    const std::vector<int> B1 = {100,101,102,103,104,105};  // need 160
    const std::vector<int> C1 = {200,201,202};              // need 130
    std::vector<int> A2 = A1;  A2.push_back(11);  A2.push_back(12);

    ms.prefill(A1);  ms.prefill(B1);  ms.prefill(C1);
    check("A/B 占 360/400 预算", M.slots[0].used && M.slots[1].used);
    check("回 A 仍从槽 0 复用", ms.prefill(A2) == 10);
    check("keep 保护：A 没被误驱", M.slots[0].used && M.slots[0].seq_len == (int)A1.size());
    check("预算逐的是 B", ev2 == 1 && M.n_evict == 1 && !M.slots[1].used);
    check("C 泊进了槽 2", M.slots[2].used && M.slots[2].seq_len == (int)C1.size());
}

static void test_flow_giveup() {
    // 槽备份放不下（超预算）：放弃入池，退回「用完就丢弃」的旧行为，不崩
    KvPool S;  S.config(4, 150);                 // A1 需要 200 > 150
    SimCtx ss{&S};
    const std::vector<int> A1 = {1,2,3,4,5,6,7,8,9,10};
    const std::vector<int> B1 = {100,101,102,103,104,105};
    std::vector<int> A2 = A1;  A2.push_back(11);
    ss.prefill(A1);
    check("放不下就不泊", ss.prefill(B1) == 0 && S.n_save == 0 && !S.slots[0].used);
    check("回来只能整段重算", ss.prefill(A2) == 0);
}

static void test_flow_disabled() {
    // 池关闭（RT_KV_POOL=0）：退回单上下文复用，append 依然工作
    KvPool Z;  Z.config(0, 0);
    SimCtx zs{&Z};
    const std::vector<int> A1 = {1,2,3,4,5,6,7,8,9,10};
    std::vector<int> A2 = A1;  A2.push_back(11);
    check("关闭时首轮整段算", zs.prefill(A1) == 0);
    check("关闭时 append 仍生效", zs.prefill(A2) == 10);
    check("关闭时不入池", Z.n_save == 0);
}

int main() {
    test_layout();
    test_best_match();
    test_acquire();
    test_lifecycle();
    test_flow_aba();
    test_flow_rewind();
    test_flow_lru();
    test_flow_budget();
    test_flow_giveup();
    test_flow_disabled();
    printf("\n%s（%d 项失败）\n", n_fail ? "有失败项" : "全部通过", n_fail);
    return n_fail ? 1 : 0;
}
'''


def extract_pool_section():
    with open(os.path.join(ROOT, 'src/model.cpp'), encoding='utf-8') as f:
        src = f.read()
    begin, end = '// [kv_pool] begin', '// [kv_pool] end'
    b, e = src.find(begin), src.find(end)
    if b < 0 or e < 0 or e < b:
        raise RuntimeError('model.cpp 里找不到 [kv_pool] begin/end 标记（与测试不同步）')
    nl = src.find('\n', b)                     # 标记行可能带尾巴，从下一行开始抽
    return src[nl + 1:e]


def first_found(cmds):
    for c in cmds:
        if shutil.which(c):
            return c
    return None


def main():
    cxx = first_found(['g++', 'c++', 'clang++'])
    if not cxx:
        print('FAIL  找不到 g++/c++/clang++')
        return 1
    tmp = tempfile.mkdtemp(prefix='kv-pool-test-')
    try:
        cc = os.path.join(tmp, 'test_kv_pool.cc')
        with open(cc, 'w', encoding='utf-8') as f:
            f.write('// 由 tests/test_kv_pool.py 生成，勿手动编辑。\n')
            f.write('#include <algorithm>\n#include <cstddef>\n#include <cstdint>\n')
            f.write('#include <functional>\n#include <utility>\n#include <vector>\n')
            f.write(extract_pool_section())
            f.write(MAIN)
        exe = os.path.join(tmp, 'test_kv_pool')
        r = subprocess.run([cxx, '-std=c++17', '-O2', '-Wall', '-o', exe, cc],
                           capture_output=True, text=True)
        if r.returncode != 0:
            print('FAIL  编译失败：')
            print(r.stderr)
            return 1
        if r.stderr.strip():
            print('[编译警告]')
            print(r.stderr.strip())
        r = subprocess.run([exe])
        return r.returncode
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == '__main__':
    sys.exit(main())
