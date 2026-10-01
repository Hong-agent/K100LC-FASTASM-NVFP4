// 专家权重 gather（MoE 解码路径）。
//
// 起因：Qwen3.6-MoE 每层 256 个专家里选 8 个，权重在显存里是「按专家散落」的，
// 现役 W4A8 GEMV 只会算连续行 —— 于是每层要打 8 个专家的 gate/up/down 共 24 次
// 调用（每次 hi/lo 两趟 + 一次相加）。而单次内核投递实测 8.4 µs，24 次调用光
// 投递就要 0.6 ms/层。把选中的专家行先 gather 成一块连续暂存，GEMV 就只要 1 次。
//
// 布局：源 = W8 打包后的权重（[E*rows][bpe] 连续，专家 e 的行从 e*rows 开始）
//   目的（mode 0，按行堆叠）：dst[(slot*rows + row)*bpe + off]
//   目的（mode 1，K 方向交织）：dst[row*(nslot*bpe) + slot*bpe + off]
// mode 1 用来把「N 个专家的 K 拼起来」：down 投影 Σ_e w_e·W_e[n][k]·x_e[k] 正好等于
// 一次 K'=nslot*K 的 GEMV（权重按专家分段拼在 K 方向、激活也按专家分段拼）。
//
// grid = (ceil((bpe>>cshift)/64), rows, nslot)，block = 64，每个 lane 拷 2^cshift 字节。
// 参数：dst, src, tab(设备端 u32 专家号表), rows, bpe, cshift, nslot, mode
.text
k__Z12gather_exp_kPvPKvPKjiiii:
s_load_dwordx2 s[0:1], s[4:5], 0x0      // dst
s_load_dwordx2 s[2:3], s[4:5], 0x8      // src
s_load_dwordx2 s[10:11], s[4:5], 0x10   // tab
s_load_dword s12, s[4:5], 0x18          // rows（每个专家多少行）
s_load_dword s13, s[4:5], 0x1c          // bpe（每个专家每行多少字节）
s_load_dword s14, s[4:5], 0x20          // cshift（log2 每次拷贝字节数）
s_load_dword s15, s[4:5], 0x24          // nslot（专家个数）
s_load_dword s16, s[4:5], 0x28          // mode
s_waitcnt lgkmcnt(0)
// off = (wgid_x * 64 + lane) << cshift；越界的 lane 直接退出
v_lshl_or_b32 v0, s6, 6, v0
v_mov_b32_e32 v8, s14
v_lshlrev_b32_e32 v0, v8, v0
v_cmp_gt_u32_e32 vcc, s13, v0
s_and_saveexec_b64 s[18:19], vcc
s_cbranch_execz L_end
// e = tab[slot]
s_lshl_b32 s20, s8, 2
s_mov_b32 s21, 0
s_add_u32 s20, s20, s10
s_addc_u32 s21, s21, s11
s_load_dword s22, s[20:21], 0x0
s_waitcnt lgkmcnt(0)
// 源偏移 = (e*rows + row)*bpe + off
s_mul_i32 s23, s22, s12
s_add_u32 s23, s23, s7
s_mul_i32 s23, s23, s13
v_mov_b32_e32 v1, s23
v_add_u32_e32 v1, v1, v0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, s3
v_add_co_u32_e32 v10, vcc, s2, v1
v_addc_co_u32_e32 v11, vcc, v3, v2, vcc
global_load_dwordx4 v[4:7], v[10:11], off
// 目的偏移
s_cmp_eq_u32 s16, 0
s_cbranch_scc0 L_mode1
s_mul_i32 s24, s8, s12                  // mode 0: (slot*rows + row)*bpe
s_add_u32 s24, s24, s7
s_branch L_addr
L_mode1:
s_mul_i32 s24, s7, s15                  // mode 1: (row*nslot + slot)*bpe
s_add_u32 s24, s24, s8
L_addr:
s_mul_i32 s24, s24, s13
v_mov_b32_e32 v1, s24
v_add_u32_e32 v1, v1, v0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, s1
v_add_co_u32_e32 v10, vcc, s0, v1
v_addc_co_u32_e32 v11, vcc, v3, v2, vcc
s_waitcnt vmcnt(0)
global_store_dwordx4 v[10:11], v[4:7], off
L_end:
s_or_b64 exec, exec, s[18:19]
s_endpgm
