# nvfp4_gemm_kernel 的机器码地图（手工改汇编用）

内核机器码来自 `kernels/asm/k_nvfp4/002__Z17nvfp4_gemm_kernelPKjPKhPKaS4_PKfPfiiif.s`
（1055 行 ≈ 1054 条指令，5976 字节）；它由 DTK 编译产物反汇编而来，本项目**没有 GPU
编译器**，所以任何改动都得手工写 `.s`（自研汇编器 `asm.py` + `encodings.json` 支持
255 种指令，包含 `ds_read_b128`/`ds_write_b128`/`v_dot4_i32_i8`）。

算法（对应 `kernels/nvfp4/nvfp4_gemm_kernel.h`）：`C[M,N] = A[M,K]·W[N,K]^T`，
权重是 NVFP4 原生布局 `wp[N][K/8] u32` + `ws[N][K/16] u8(E4M3)` + 逐张量 `inv_gscale`；
激活按 16 一组量化成 `ae/ao[M][K/2] i8` + `asc[M][K/16] f32`。
分块：BM=BN=64、BK=64（`NVFP4_BK`）、256 线程（16×16），网格 `(N/64, M/64)`。

## 1. 控制流（行号 = `.s` 行号）

```
  1.. 82   序言：kernarg、共享地址寄存器、计数器清零
              s[8:9]=wp s[10:11]=ws s[12:13]=ae s[14:15]=ao s[6:7]=asc
              s16=M s17=N s18=K s19=inv_gscale s33=K>>4 s34=K>>3 s35=K>>1
              s30=blockIdx.y*64 s31=blockIdx.x*64 s36=k0
              v26..v31 = 共享各数组的「基址 + 本线程索引」寄存器
 83        s_branch → 614        ; 进循环前先给第 0 块 staging
 84.. 85   （回边落点：恢复 exec / 等 lgkm）
 86        s_barrier
 87..610   dot 块：8 个 kd × (4×ds_read_b128 + 32×v_dot4_i32_i8 + 折叠)
 611       s_barrier
 612..613  s36 += 64 ; 若 s36 ≥ K → 816（收尾）
 614..615  s_and_saveexec_b64 s[20:21], vcc ; 若无有效 lane → 84（空块直接回头）
 616..661  激活 staging：全局读(2×global_load_dwordx2) → ds_write2st64 写 sAe/sAo
              （内含 626/638/648/662 的小循环与边界谓词）
 663..815  权重 staging：global_load_dwordx2 → v_perm 解码 → ds_write 写 sWe/sWo，
              再读两个尺度（global_load_dword / global_load_sbyte）写 sAsc/sWsc；
              772 的回边 → 84
816..1055 收尾：把 16 个 fp32 累加器写回 C（4 组 global_store_dword ×16）
```

共享布局（字节偏移，来自序言里的常量）：

| 数组 | 偏移 | 尺寸 | 布局 |
|---|---|---|---|
| sAsc | 0x0000 (写时 offset:8192 即 0x2000) | 1 KB | `[64][4] f32` |
| sWsc | 0x0400 (=9216=0x2400) | 1 KB | `[64][4] f32` |
| sAe | 0x0800 起（v26/v28 用 0x1000/0x2000 组合） | 2 KB | `[8][64] u32`（转置：`[kd][row]`） |
| sAo | | 2 KB | 同上 |
| sWe | | 2 KB | 同上 |
| sWo | | 2 KB | 同上 |

合计 10 KB（`sAsc`+`sWsc`+4×2KB = 0x2800）。

## 2. 每线程每 K-tile 的指令账（普查自 `.s`）

| 成分 | 条数 | 占比 |
|---|---|---|
| `v_dot4_i32_i8` | 256 | 35% |
| 尺度折叠 `v_cvt_f32_i32`64 + `v_fmac_f32`64 + `v_mul_f32`67 | 195 | **27%** |
| 边界谓词/掩码 `s_cbranch_execz`31 + `s_and_saveexec_b64`23 + `s_or_b64`29 | 83 | 11% |
| `s_waitcnt` | 51 | — |
| `ds_read_b128` 32 + `ds_read2_b32` 16 + 地址/循环 | ~150 | 21% |

## 3. 手工优化清单（按收益）

**A. 把 staging 改写成「直落式」**（去掉谓词与掩码累积）

现在的 staging 是编译器给「任意 M/N」生成的：每个元素都过一遍 `m < M`（= `s16 > v39`）、
`n < N`，还带掩码累积 `s_or_b64 s[22:23], s[0:1], s[22:23]` 与小循环。我们的形状
M/N 都是 64 的整数倍（q/k/v/o_proj、in_proj_*、mlp_*、lm_head 248320 也是），
所以可以写成：

```
r = tid >> 2 ; c = tid & 3                      // 两个 staging 都恰好 1 轮
av = *(uint2*)(ae + (m0+r)*(K/2) + k0/2 + c*8)  // 8 字节 = 16 个偶 k 码
bv = *(uint2*)(ao + (m0+r)*(K/2) + k0/2 + c*8)
写 sAe[2c][r], sAe[2c+1][r] = av.x, av.y         // ds_write2st64_b32
写 sAo[2c][r], sAo[2c+1][r] = bv.x, bv.y
wv = *(uint2*)(wp + (n0+r)*(K/8) + (k0/16+c))    // 16 个码
解码 wv.x,wv.y → sWe/sWo[2c][r], [2c+1][r]        // v_perm_b32 ×3 + bfi
sAsc[r][c] = *(float*)(asc + (m0+r)*(K/16) + k0/16 + c)
sWsc[r][c] = e4m3(*(u8*)(ws + (n0+r)*(K/16) + k0/16 + c)) * 0.5 * inv_gscale
```

约 30 条指令，替掉现在约 200 行的 staging（其中 83 条是谓词开销）→ 目标 **−10%**。
注意：**必须只在 M%64==0 且 N%64==0 时分派到这个内核**（越界读会踩到别的张量）。

**B. 软件流水（把 5 个全局读提前到 dot 块之前）**

现在顺序是 `[staging(读+解码+写)] → barrier → [dot] → barrier → [下一个 staging]`，
所以每个 K-tile 的全局读延迟（几百周期）完全暴露。改成：

```
循环体： [读下一块的 5 个全局值到寄存器] → [dot 块（读共享）] → [解码+写共享] → barrier
```

即把 A 里那 5 个 global_load 提到 dot 之前（值放临时 VGPR，解码仍在 dot 之后），
共享只有一份也安全（写发生在 dot 之后）。需要同步更新
`kernels/kernel_spec.json` 里该内核的 VGPR 数。目标 **−10~20%**。

**C. BM 64→128**：权重解码/shared 写入摊到两倍行上；要重写 dot 块的展开偏移，收益最小。

**D. 尺度折叠（27%）不能省**：除非把权重尺度从每 16 个 k 改成每 128 个（= 退化成
int4 的精度），与「和 MLP 规格一致」冲突。

## 4. 验收方式

1. `python3 -c "import asm; asm.assemble(...)"` —— 汇编通过；
2. `bash build.sh` —— 进 HSACO；
3. `NVCHK <层>` —— 与 `tools/nvfp4_ref.py` 的参考实现逐元素对拍（现在一致到 1e-7）；
4. `GEMMBENCH 20 512` —— 与 `model.rp4.int4only` 的同形状读数对比（现在 NVFP4 9.8
   vs int4 W4A8 17.4 TMAC/s）；
5. `bash tests/run_all.sh` —— 20 项全过。

## 5. 已知限制

NVFP4 GEMM 在 `M ≥ 1024` 时非法地址访问（128/256/512 正常）。运行时预填充 `CHUNK=512`，
模型跑不到；`GEMMBENCH` 默认只测这三档。

## 6. 逐条解码（第二轮，已核对）

### kernarg

`s[4:5]` 是 kernarg 段指针，序言里 `s_add_u32 s4, s4, 64` 跳过 64 字节的**隐式参数**，
所以显式参数从 +0 开始（与 `kernel_spec.json` 的 `args` 一致）：

| 偏移 | 参数 |
|---|---|
| 0 / 8 / 16 / 24 / 32 / 40 | `wp` / `ws` / `ae` / `ao` / `asc` / `C` |
| 48 / 52 / 56 / 60 | `M` / `N` / `K` / `inv_gscale` |
| 64.. | 隐式：`hidden_block_count_*`、`hidden_group_size_*`（= blockDim）、… |

`s_load_dword s0, s[4:5], 0xc` 读的是**隐式** `hidden_group_size_x`（+64+12=76），
`s39 = s0 & 0xffff` = **blockDim.x = 256** —— 这就是 staging 小循环的步长
（`for (idx = tid; idx < BM*NC; idx += 256)`，恰好一轮）。`s19 = 0xff` 是它的上界。

### 寄存器角色（staging 段）

| 寄存器 | 含义 |
|---|---|
| `v0` | threadIdx.x（0..255） |
| `s30 = blockIdx.y*64` | `m0`（行块起点） |
| `s31 = blockIdx.x*64` | `n0`（列块起点） |
| `s36` | `k0`（K 循环变量，每轮 +64） |
| `s33 = K>>4`、`s34 = K>>3`、`s35 = K>>1` | 尺度行距(float) / 权重行距(dword) / 激活行距(byte) |
| `s[24:25] = ae + k0/2`、`s[26:27] = ao + k0/2` | 两个激活数组的本轮基址 |
| `s40 = k0/16` | 本轮在 16 组里的起点 |
| `v32..v36` | E4M3→f32 的位运算 LUT 常量（`v_perm_b32`/`v_bfi_b32` 用） |
| `v26..v31` | dot 块 4 个数组 + 2 个尺度数组的共享读地址寄存器 |

### 共享布局（已由地址公式与 `group_segment=10240` 双向确认）

```
sAe  @    0   [8][64] u32   转置布局：元素 [kd][row]
sAo  @ 2048   [8][64] u32
sWe  @ 4096   [8][64] u32
sWo  @ 6144   [8][64] u32
sAsc @ 8192   [64][4] f32   （行距 16 字节）
sWsc @ 9216   [64][4] f32
```

### 三个 staging 的逐线程公式（tid = v0）

```
r = tid >> 2 ,  c = tid & 3            // 每个 staging 都恰好一轮

激活： ae + (m0+r)*(K/2) + k0/2 + c*8   → global_load_dwordx2  （偶 k 码，2 dword=16 k）
       ao + (m0+r)*(K/2) + k0/2 + c*8   → global_load_dwordx2  （奇 k 码）
       共享地址 = c*512 + r*4
         ds_write2st64_b32 v37, v5, v6 offset1:1                    // 写 sAe @0
         ds_write2st64_b32 v37, v3, v4 offset0:8 offset1:9          // 写 sAo @+2048

权重： wp + (n0+r)*(K/2) + (k0/16 + c)*8 → global_load_dwordx2      （16 个码）
       解码：每个 dword 过 v_perm_b32 ×3 + v_bfi_b32（用 v32..v36 的 LUT）
       共享地址 = c*512 + r*4
         ds_write2st64_b32 v5, v37, v38 offset0:16 offset1:17       // 写 sWe @+4096
         ds_write2st64_b32 v5, v3,  v4  offset0:24 offset1:25       // 写 sWo @+6144

尺度： asc + (m0+r)*(K/16) + (k0/16 + c) → global_load_dword
       共享地址 = (r<<4) | c ; ds_write_b32 v4, v1 offset:8192      // 写 sAsc
      ws  + (n0+r)*(K/16) + (k0/16 + c) → global_load_sbyte         // E4M3 码
       解码：v_bfe/v_and/v_cmp + v_cvt…（×0.5×inv_gscale = v25 里已算好）
       ds_write_b32 v4, v1 offset:9216                              // 写 sWsc
```

`ds_write2st64_b32` 的 `offset0/offset1` 单位是 **256 字节**（st64），所以
`offset0:8 offset1:9` = 基址 +2048 与 +2304 —— 这正是 sAo 的两个 dword 相对 sAe 的距离，
说明写指令里**没有**把数组基址放进地址寄存器，而是用立即数偏移区分数组。

### 还差一步才能动刀

dot 块里读两个尺度数组用的是 `ds_read2_b32`（16 条）配 `v30/v31`（序言里
`v_lshl_or_b32 v30, v2, 6, v3` 形式，v2 = tid>>4、v3 = 0x2000/0x2400）。
把这两条读地址的公式确认下来（`sAsc[r][g]` 的行距到底取 16 字节还是 4 字节，
写侧 `(r<<4)|c` 与读侧必须自洽），就可以：

1. 把 614..815 整段换成第 3 节 A 的直落式 staging（≈30 条指令）；
2. 再把 5 个 `global_load` 提到 dot 块之前 → 第 3 节 B；
3. 只在新内核里做，运行时按 `M%64==0 && N%64==0 && K%64==0` 分派，
   旧内核原样保留兜底。
