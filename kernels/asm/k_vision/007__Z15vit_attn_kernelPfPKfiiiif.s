.text
k__Z15vit_attn_kernelPfPKfiiiif:
s_load_dwordx4 s[12:15], s[4:5], 0x10
s_load_dwordx2 s[24:25], s[4:5], 0x8
s_load_dword s18, s[4:5], 0x34
s_add_u32 s0, s0, s10
s_addc_u32 s1, s1, 0
s_waitcnt lgkmcnt(0)
s_mul_hi_i32 s7, s15, s9
s_mul_i32 s6, s15, s9
s_ashr_i32 s46, s15, 31
s_lshl_b64 s[26:27], s[6:7], 2
s_add_u32 s22, s24, s26
s_mul_i32 s10, s8, s14
s_addc_u32 s23, s25, s27
s_ashr_i32 s11, s10, 31
v_cmp_gt_i32_e64 s[6:7], s12, v0
v_cmp_le_i32_e32 vcc, s12, v0
s_and_saveexec_b64 s[16:17], vcc
s_xor_b64 s[16:17], exec, s[16:17]
v_mov_b32_e32 v1, 0
s_mov_b32 s19, 0xf149f2ca
s_or_saveexec_b64 s[16:17], s[16:17]
s_load_dwordx2 s[20:21], s[4:5], 0x0
s_load_dword s33, s[4:5], 0x20
s_mul_i32 s4, s14, s13
s_and_b32 s8, s18, 0xffff
v_mov_b32_e32 v7, s19
s_xor_b64 exec, exec, s[16:17]
s_cbranch_execz 118
s_ashr_i32 s5, s4, 31
s_cmp_gt_i32 s14, 0
v_mad_i64_i32 v[2:3], s[34:35], s15, v0, 0
s_cselect_b64 s[28:29], -1, 0
s_add_i32 s18, s14, -1
s_and_b32 s44, s14, 7
s_cmp_gt_u32 s18, 6
s_cselect_b64 s[30:31], -1, 0
s_and_b32 s45, s14, -8
s_cmp_lg_u32 s44, 0
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_cselect_b64 s[34:35], -1, 0
s_lshl_b64 s[38:39], s[4:5], 2
v_mov_b32_e32 v4, s39
v_add_co_u32_e32 v5, vcc, s38, v2
s_mul_hi_i32 s39, s15, s8
s_mul_i32 s38, s15, s8
s_lshl_b64 s[36:37], s[10:11], 2
v_addc_co_u32_e32 v4, vcc, v3, v4, vcc
s_lshl_b64 s[38:39], s[38:39], 2
v_mov_b32_e32 v3, s25
v_add_co_u32_e32 v2, vcc, s24, v5
s_add_u32 s5, s24, s36
v_addc_co_u32_e32 v3, vcc, v3, v4, vcc
s_addc_u32 s18, s25, s37
v_add_co_u32_e32 v6, vcc, s5, v5
s_add_u32 s5, s26, s36
v_mov_b32_e32 v7, s18
s_addc_u32 s18, s27, s37
s_add_u32 s5, s24, s5
s_mov_b32 s19, 0
v_mov_b32_e32 v1, 0
v_addc_co_u32_e32 v8, vcc, v7, v4, vcc
s_addc_u32 s47, s25, s18
s_mov_b64 s[40:41], 0
v_mov_b32_e32 v7, 0xf149f2ca
v_mov_b32_e32 v9, v0
s_branch 14
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v4, s33, v10
v_max_f32_e32 v5, v7, v7
v_max_f32_e32 v7, v5, v4
v_mov_b32_e32 v4, s39
v_add_co_u32_e32 v2, vcc, s38, v2
v_add_u32_e32 v9, s8, v9
v_addc_co_u32_e32 v3, vcc, v3, v4, vcc
v_cmp_le_i32_e32 vcc, s12, v9
s_or_b64 s[40:41], vcc, s[40:41]
v_add_co_u32_e32 v6, vcc, s38, v6
v_addc_co_u32_e32 v8, vcc, v8, v4, vcc
s_andn2_b64 exec, exec, s[40:41]
s_cbranch_execz 62
s_andn2_b64 vcc, exec, s[28:29]
v_mov_b32_e32 v10, 0
s_cbranch_vccnz 65519
s_mov_b32 s18, 0
v_mov_b32_e32 v10, 0
s_andn2_b64 vcc, exec, s[30:31]
s_cbranch_vccnz 32
v_mov_b32_e32 v5, v3
s_mov_b64 s[42:43], s[22:23]
v_mov_b32_e32 v4, v2
v_mov_b32_e32 v11, s37
v_add_co_u32_e32 v19, vcc, s36, v4
v_addc_co_u32_e32 v20, vcc, v5, v11, vcc
global_load_dwordx4 v[11:14], v[19:20], off
global_load_dwordx4 v[15:18], v[19:20], off offset:16
s_add_u32 s48, s42, s36
s_addc_u32 s49, s43, s37
s_load_dwordx8 s[48:55], s[48:49], 0x0
s_add_i32 s18, s18, 8
s_add_u32 s42, s42, 32
v_add_co_u32_e32 v4, vcc, 32, v4
s_addc_u32 s43, s43, 0
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_eq_u32 s45, s18
s_waitcnt vmcnt(1) lgkmcnt(0)
v_fmac_f32_e32 v10, s48, v11
v_fmac_f32_e32 v10, s49, v12
v_fmac_f32_e32 v10, s50, v13
v_fmac_f32_e32 v10, s51, v14
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v10, s52, v15
v_fmac_f32_e32 v10, s53, v16
v_fmac_f32_e32 v10, s54, v17
v_fmac_f32_e32 v10, s55, v18
s_cbranch_scc0 65508
s_mov_b32 s18, s45
s_andn2_b64 vcc, exec, s[34:35]
s_cbranch_vccnz 65481
s_lshl_b64 s[42:43], s[18:19], 2
v_mov_b32_e32 v5, s43
v_add_co_u32_e32 v4, vcc, s42, v6
s_add_u32 s42, s5, s42
v_addc_co_u32_e32 v5, vcc, v8, v5, vcc
s_addc_u32 s43, s47, s43
s_mov_b32 s18, s44
global_load_dword v11, v[4:5], off
s_load_dword s48, s[42:43], 0x0
s_add_u32 s42, s42, 4
v_add_co_u32_e32 v4, vcc, 4, v4
s_addc_u32 s43, s43, 0
s_add_i32 s18, s18, -1
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_lg_u32 s18, 0
s_waitcnt vmcnt(0) lgkmcnt(0)
v_fmac_f32_e32 v10, s48, v11
s_cbranch_scc1 65523
s_branch 65460
s_or_b64 exec, exec, s[40:41]
s_or_b64 exec, exec, s[16:17]
v_lshlrev_b32_e32 v2, 2, v0
v_cmp_lt_u16_e64 s[18:19], s8, 2
v_or_b32_e32 v6, 0x9000, v2
s_lshr_b32 s47, s8, 1
v_cmp_gt_u16_e64 s[16:17], s8, 1
s_and_b64 vcc, exec, s[18:19]
ds_write_b32 v2, v7 offset:36864
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccnz 27
s_mov_b32 s5, s47
s_branch 8
s_or_b64 exec, exec, s[18:19]
s_lshr_b32 s18, s5, 1
s_cmp_lt_u32 s5, 2
s_mov_b32 s5, s18
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 17
v_cmp_gt_u32_e32 vcc, s5, v0
s_and_saveexec_b64 s[18:19], vcc
s_cbranch_execz 65525
v_lshl_add_u32 v2, s5, 2, v6
ds_read_b32 v2, v2
ds_read_b32 v3, v6
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v2, v2, v2
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v3, v3, v3
v_max_f32_e32 v2, v3, v2
ds_write_b32 v6, v2
s_branch 65511
v_mov_b32_e32 v7, 0
ds_read_b32 v8, v7 offset:36864
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[18:19], s[6:7]
s_cbranch_execz 123
s_ashr_i32 s5, s4, 31
v_mul_lo_u32 v4, s46, v0
v_mul_lo_u32 v5, s15, v1
v_mad_u64_u32 v[2:3], s[36:37], s15, v0, 0
s_cmp_gt_i32 s14, 0
s_cselect_b64 s[30:31], -1, 0
s_and_b32 s48, s14, 7
s_cmp_gt_u32 s14, 7
s_cselect_b64 s[34:35], -1, 0
s_and_b32 s49, s14, -8
v_add3_u32 v3, v3, v5, v4
s_cmp_lg_u32 s48, 0
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_cselect_b64 s[36:37], -1, 0
s_lshl_b64 s[40:41], s[4:5], 2
v_mov_b32_e32 v4, s41
v_add_co_u32_e32 v5, vcc, s40, v2
s_mul_hi_i32 s41, s15, s8
s_mul_i32 s40, s15, s8
s_lshl_b64 s[38:39], s[10:11], 2
v_addc_co_u32_e32 v4, vcc, v3, v4, vcc
s_lshl_b64 s[40:41], s[40:41], 2
v_mov_b32_e32 v3, s25
v_add_co_u32_e32 v2, vcc, s24, v5
s_add_u32 s5, s24, s38
v_addc_co_u32_e32 v3, vcc, v3, v4, vcc
s_addc_u32 s28, s25, s39
v_add_co_u32_e32 v9, vcc, s5, v5
s_add_u32 s5, s26, s38
v_mov_b32_e32 v7, s28
s_addc_u32 s28, s27, s39
s_add_u32 s5, s24, s5
s_mov_b32 s29, 0
v_addc_co_u32_e32 v10, vcc, v7, v4, vcc
s_addc_u32 s50, s25, s28
s_mov_b64 s[42:43], 0
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v11, v0
s_branch 16
v_fma_f32 v4, s33, v12, -v8
v_mul_f32_e32 v4, 0x3fb8aa3b, v4
v_mov_b32_e32 v5, s41
v_exp_f32_e32 v4, v4
v_add_co_u32_e32 v2, vcc, s40, v2
v_add_u32_e32 v11, s8, v11
v_addc_co_u32_e32 v3, vcc, v3, v5, vcc
v_cmp_le_i32_e32 vcc, s12, v11
s_or_b64 s[42:43], vcc, s[42:43]
v_add_co_u32_e32 v9, vcc, s40, v9
v_add_f32_e32 v7, v7, v4
v_addc_co_u32_e32 v10, vcc, v10, v5, vcc
s_andn2_b64 exec, exec, s[42:43]
s_cbranch_execz 62
s_andn2_b64 vcc, exec, s[30:31]
v_mov_b32_e32 v12, 0
s_cbranch_vccnz 65517
s_mov_b32 s28, 0
v_mov_b32_e32 v12, 0
s_andn2_b64 vcc, exec, s[34:35]
s_cbranch_vccnz 32
v_mov_b32_e32 v5, v3
s_mov_b64 s[44:45], s[22:23]
v_mov_b32_e32 v4, v2
v_mov_b32_e32 v13, s39
v_add_co_u32_e32 v21, vcc, s38, v4
v_addc_co_u32_e32 v22, vcc, v5, v13, vcc
global_load_dwordx4 v[13:16], v[21:22], off
global_load_dwordx4 v[17:20], v[21:22], off offset:16
s_add_u32 s52, s44, s38
s_addc_u32 s53, s45, s39
s_load_dwordx8 s[52:59], s[52:53], 0x0
s_add_i32 s28, s28, 8
s_add_u32 s44, s44, 32
v_add_co_u32_e32 v4, vcc, 32, v4
s_addc_u32 s45, s45, 0
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_eq_u32 s49, s28
s_waitcnt vmcnt(1) lgkmcnt(0)
v_fmac_f32_e32 v12, s52, v13
v_fmac_f32_e32 v12, s53, v14
v_fmac_f32_e32 v12, s54, v15
v_fmac_f32_e32 v12, s55, v16
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v12, s56, v17
v_fmac_f32_e32 v12, s57, v18
v_fmac_f32_e32 v12, s58, v19
v_fmac_f32_e32 v12, s59, v20
s_cbranch_scc0 65508
s_mov_b32 s28, s49
s_andn2_b64 vcc, exec, s[36:37]
s_cbranch_vccnz 65479
s_lshl_b64 s[44:45], s[28:29], 2
v_mov_b32_e32 v5, s45
v_add_co_u32_e32 v4, vcc, s44, v9
s_add_u32 s44, s5, s44
v_addc_co_u32_e32 v5, vcc, v10, v5, vcc
s_addc_u32 s45, s50, s45
s_mov_b32 s28, s48
global_load_dword v13, v[4:5], off
s_load_dword s51, s[44:45], 0x0
s_add_u32 s44, s44, 4
v_add_co_u32_e32 v4, vcc, 4, v4
s_addc_u32 s45, s45, 0
s_add_i32 s28, s28, -1
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_lg_u32 s28, 0
s_waitcnt vmcnt(0) lgkmcnt(0)
v_fmac_f32_e32 v12, s51, v13
s_cbranch_scc1 65523
s_branch 65458
s_or_b64 exec, exec, s[42:43]
s_or_b64 exec, exec, s[18:19]
s_andn2_b64 vcc, exec, s[16:17]
ds_write_b32 v6, v7
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccz 107
v_mov_b32_e32 v2, 0
ds_read_b32 v9, v2 offset:36864
s_cmp_gt_i32 s14, 0
s_cselect_b64 s[28:29], -1, 0
s_cmp_lt_i32 s14, 1
s_mov_b32 s5, 0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 34
s_cmp_lt_u32 s14, 8
s_cbranch_scc1 19
s_and_b32 s5, s14, -8
v_mov_b32_e32 v2, 16
s_mov_b32 s16, 0
s_mov_b32 s30, 0
s_mov_b32 s17, s16
s_mov_b32 s18, s16
s_mov_b32 s19, s16
v_mov_b32_e32 v3, s16
s_add_i32 s30, s30, 8
v_mov_b32_e32 v4, s17
v_mov_b32_e32 v5, s18
v_mov_b32_e32 v6, s19
s_cmp_eq_u32 s5, s30
buffer_store_dwordx4 v[3:6], v2, s[0:3], 0 offen
buffer_store_dwordx4 v[3:6], v2, s[0:3], 0 offen offset:16
v_add_u32_e32 v2, 32, v2
s_cbranch_scc0 65521
s_and_b32 s16, s14, 7
s_cmp_eq_u32 s16, 0
s_cbranch_scc1 10
s_lshl_b32 s5, s5, 2
v_mov_b32_e32 v2, 16
v_add_u32_e32 v2, s5, v2
v_mov_b32_e32 v3, 0
s_add_i32 s16, s16, -1
buffer_store_dword v3, v2, s[0:3], 0 offen
s_cmp_lg_u32 s16, 0
v_add_u32_e32 v2, 4, v2
s_cbranch_scc1 65530
s_and_saveexec_b64 s[16:17], s[6:7]
s_cbranch_execz 243
v_mul_lo_u32 v4, s46, v0
v_mul_lo_u32 v5, s15, v1
v_mad_u64_u32 v[2:3], s[30:31], s15, v0, 0
s_lshl_b32 s40, s4, 1
s_ashr_i32 s5, s4, 31
s_ashr_i32 s41, s40, 31
s_and_b32 s36, s14, 7
s_cmp_gt_u32 s14, 7
s_cselect_b64 s[6:7], -1, 0
s_and_b32 s37, s14, -8
v_add3_u32 v3, v3, v5, v4
s_cmp_lg_u32 s36, 0
v_lshlrev_b64 v[4:5], 2, v[2:3]
s_cselect_b64 s[30:31], -1, 0
s_lshl_b64 s[4:5], s[4:5], 2
v_mov_b32_e32 v2, s5
v_add_co_u32_e32 v6, vcc, s4, v4
s_mul_hi_i32 s5, s15, s8
s_mul_i32 s4, s15, s8
s_lshl_b64 s[34:35], s[10:11], 2
s_lshl_b64 s[4:5], s[4:5], 2
s_add_u32 s18, s24, s34
s_addc_u32 s39, s25, s35
s_add_u32 s15, s26, s34
v_addc_co_u32_e32 v7, vcc, v5, v2, vcc
s_addc_u32 s26, s27, s35
v_mov_b32_e32 v3, s25
v_add_co_u32_e32 v2, vcc, s24, v6
s_add_u32 s15, s24, s15
v_addc_co_u32_e32 v3, vcc, v3, v7, vcc
s_addc_u32 s38, s25, s26
s_lshl_b64 s[24:25], s[40:41], 2
v_mov_b32_e32 v11, s39
v_add_co_u32_e32 v10, vcc, s18, v6
s_add_u32 s18, s18, s24
v_addc_co_u32_e32 v11, vcc, v11, v7, vcc
s_addc_u32 s24, s39, s25
v_mov_b32_e32 v6, s24
v_add_co_u32_e32 v12, vcc, s18, v4
v_addc_co_u32_e32 v13, vcc, v6, v5, vcc
v_add_co_u32_e32 v4, vcc, 28, v12
s_mov_b32 s19, 0
v_addc_co_u32_e32 v5, vcc, 0, v13, vcc
s_mov_b64 s[24:25], 0
v_mov_b32_e32 v14, 16
v_mov_b32_e32 v15, v0
s_branch 36
s_or_b64 exec, exec, s[16:17]
s_lshr_b32 s5, s47, 1
s_cmp_lt_u32 s47, 2
s_mov_b32 s47, s5
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 65429
v_cmp_gt_u32_e32 vcc, s47, v0
s_and_saveexec_b64 s[16:17], vcc
s_cbranch_execz 65525
v_lshl_add_u32 v2, s47, 2, v6
ds_read_b32 v2, v2
ds_read_b32 v3, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
ds_write_b32 v6, v2
s_branch 65514
v_mov_b32_e32 v6, s5
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v3, v6, vcc
v_add_co_u32_e32 v10, vcc, s4, v10
v_addc_co_u32_e32 v11, vcc, v11, v6, vcc
v_add_co_u32_e32 v4, vcc, s4, v4
v_add_u32_e32 v15, s8, v15
v_addc_co_u32_e32 v5, vcc, v5, v6, vcc
v_cmp_le_i32_e32 vcc, s12, v15
s_or_b64 s[24:25], vcc, s[24:25]
v_add_co_u32_e32 v12, vcc, s4, v12
v_addc_co_u32_e32 v13, vcc, v13, v6, vcc
s_andn2_b64 exec, exec, s[24:25]
s_cbranch_execz 155
s_andn2_b64 vcc, exec, s[28:29]
s_cbranch_vccnz 61
s_mov_b32 s18, 0
v_mov_b32_e32 v16, 0
s_andn2_b64 vcc, exec, s[6:7]
s_cbranch_vccnz 32
v_mov_b32_e32 v7, v3
s_mov_b64 s[26:27], s[22:23]
v_mov_b32_e32 v6, v2
v_mov_b32_e32 v17, s35
v_add_co_u32_e32 v25, vcc, s34, v6
v_addc_co_u32_e32 v26, vcc, v7, v17, vcc
global_load_dwordx4 v[17:20], v[25:26], off
global_load_dwordx4 v[21:24], v[25:26], off offset:16
s_add_u32 s40, s26, s34
s_addc_u32 s41, s27, s35
s_load_dwordx8 s[40:47], s[40:41], 0x0
s_add_i32 s18, s18, 8
s_add_u32 s26, s26, 32
v_add_co_u32_e32 v6, vcc, 32, v6
s_addc_u32 s27, s27, 0
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_cmp_eq_u32 s37, s18
s_waitcnt vmcnt(1) lgkmcnt(0)
v_fmac_f32_e32 v16, s40, v17
v_fmac_f32_e32 v16, s41, v18
v_fmac_f32_e32 v16, s42, v19
v_fmac_f32_e32 v16, s43, v20
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v16, s44, v21
v_fmac_f32_e32 v16, s45, v22
v_fmac_f32_e32 v16, s46, v23
v_fmac_f32_e32 v16, s47, v24
s_cbranch_scc0 65508
s_mov_b32 s18, s37
s_andn2_b64 vcc, exec, s[30:31]
s_cbranch_vccnz 20
s_lshl_b64 s[26:27], s[18:19], 2
v_mov_b32_e32 v7, s27
v_add_co_u32_e32 v6, vcc, s26, v10
s_add_u32 s26, s15, s26
v_addc_co_u32_e32 v7, vcc, v11, v7, vcc
s_addc_u32 s27, s38, s27
s_mov_b32 s18, s36
global_load_dword v17, v[6:7], off
s_load_dword s39, s[26:27], 0x0
s_add_u32 s26, s26, 4
v_add_co_u32_e32 v6, vcc, 4, v6
s_addc_u32 s27, s27, 0
s_add_i32 s18, s18, -1
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_cmp_lg_u32 s18, 0
s_waitcnt vmcnt(0) lgkmcnt(0)
v_fmac_f32_e32 v16, s39, v17
s_cbranch_scc1 65523
s_andn2_b64 vcc, exec, s[28:29]
s_cbranch_vccz 4
s_branch 65459
v_mov_b32_e32 v16, 0
s_andn2_b64 vcc, exec, s[28:29]
s_cbranch_vccnz 65456
v_fma_f32 v6, s33, v16, -v8
v_mul_f32_e32 v6, 0x3fb8aa3b, v6
s_mov_b32 s18, 0
v_exp_f32_e32 v6, v6
v_div_scale_f32 v7, s[26:27], v9, v9, v6
v_div_scale_f32 v16, vcc, v6, v9, v6
v_rcp_f32_e32 v17, v7
v_fma_f32 v18, -v7, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v16, v17
v_fma_f32 v19, -v7, v18, v16
v_fmac_f32_e32 v18, v19, v17
v_fma_f32 v7, -v7, v18, v16
v_div_fmas_f32 v7, v7, v17, v18
s_andn2_b64 vcc, exec, s[6:7]
v_div_fixup_f32 v16, v7, v9, v6
s_cbranch_vccnz 39
v_mov_b32_e32 v7, v5
v_mov_b32_e32 v17, 16
s_mov_b32 s26, 0
v_mov_b32_e32 v6, v4
global_load_dwordx4 v[18:21], v[6:7], off offset:-28
global_load_dwordx4 v[26:29], v[6:7], off offset:-12
buffer_load_dwordx4 v[22:25], v17, s[0:3], 0 offen
buffer_load_dwordx4 v[30:33], v17, s[0:3], 0 offen offset:16
s_add_i32 s26, s26, 8
v_add_co_u32_e32 v6, vcc, 32, v6
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_cmp_eq_u32 s37, s26
s_mov_b32 s18, s37
s_waitcnt vmcnt(1)
v_fma_f32 v22, v16, v18, v22
v_fma_f32 v23, v16, v19, v23
v_fma_f32 v24, v16, v20, v24
v_fmac_f32_e32 v25, v16, v21
s_waitcnt vmcnt(0)
v_fma_f32 v30, v16, v26, v30
v_fma_f32 v31, v16, v27, v31
v_fma_f32 v32, v16, v28, v32
v_fmac_f32_e32 v33, v16, v29
buffer_store_dwordx4 v[22:25], v17, s[0:3], 0 offen
buffer_store_dwordx4 v[30:33], v17, s[0:3], 0 offen offset:16
v_add_u32_e32 v17, 32, v17
s_cbranch_scc0 65501
s_andn2_b64 vcc, exec, s[30:31]
s_cbranch_vccnz 65389
s_lshl_b32 s26, s18, 2
v_add_u32_e32 v17, s26, v14
s_lshl_b64 s[26:27], s[18:19], 2
v_mov_b32_e32 v7, s27
v_add_co_u32_e32 v6, vcc, s26, v12
v_addc_co_u32_e32 v7, vcc, v13, v7, vcc
s_mov_b32 s18, s36
global_load_dword v18, v[6:7], off
buffer_load_dword v19, v17, s[0:3], 0 offen
s_add_i32 s18, s18, -1
v_add_co_u32_e32 v6, vcc, 4, v6
s_cmp_lg_u32 s18, 0
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v19, v16, v18
buffer_store_dword v19, v17, s[0:3], 0 offen
v_add_u32_e32 v17, 4, v17
s_cbranch_scc1 65522
s_branch 65367
s_or_b64 exec, exec, s[16:17]
s_andn2_b64 vcc, exec, s[28:29]
s_cbranch_vccnz 43
s_cmp_lt_u32 s14, 8
s_mov_b32 s4, 0
s_cbranch_scc1 20
s_and_b32 s4, s14, -8
v_mul_u32_u24_e32 v2, 0x120, v0
v_mov_b32_e32 v3, 16
s_mov_b32 s5, 0
buffer_load_dwordx4 v[4:7], v3, s[0:3], 0 offen
buffer_load_dwordx4 v[8:11], v3, s[0:3], 0 offen offset:16
s_add_i32 s5, s5, 8
v_add_u32_e32 v3, 32, v3
s_cmp_eq_u32 s4, s5
s_waitcnt vmcnt(1)
ds_write_b128 v2, v[4:7]
s_waitcnt vmcnt(0)
ds_write_b128 v2, v[8:11] offset:16
v_add_u32_e32 v2, 32, v2
s_cbranch_scc0 65521
s_and_b32 s5, s14, 7
s_cmp_eq_u32 s5, 0
s_cbranch_scc1 17
s_lshl_b32 s4, s4, 2
s_movk_i32 s6, 0x120
v_mov_b32_e32 v2, s4
v_mov_b32_e32 v3, 16
v_mad_u32_u24 v2, v0, s6, v2
v_add_u32_e32 v3, s4, v3
buffer_load_dword v4, v3, s[0:3], 0 offen
s_add_i32 s5, s5, -1
v_add_u32_e32 v3, 4, v3
s_cmp_lg_u32 s5, 0
s_waitcnt vmcnt(0)
ds_write_b32 v2, v4
v_add_u32_e32 v2, 4, v2
s_cbranch_scc1 65526
v_cmp_gt_i32_e32 vcc, s14, v0
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 80
v_cmp_eq_u16_e64 s[6:7], s8, 0
s_mov_b32 s4, 0
s_and_b64 vcc, exec, s[6:7]
s_cbranch_vccnz 40
v_cmp_lt_u16_e64 s[6:7], s8, 8
s_and_b64 vcc, exec, s[6:7]
s_cbranch_vccnz 38
s_and_b32 s4, s8, 0xfff8
v_lshlrev_b32_e32 v3, 2, v0
s_mov_b32 s5, 0
v_mov_b32_e32 v2, 0
ds_read2_b32 v[4:5], v3 offset1:72
ds_read2_b32 v[6:7], v3 offset0:144 offset1:216
v_add_u32_e32 v10, 0x400, v3
ds_read2_b32 v[8:9], v10 offset0:32 offset1:104
ds_read2_b32 v[10:11], v10 offset0:176 offset1:248
s_add_i32 s5, s5, 8
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v2, v2, v4
v_add_f32_e32 v2, v2, v5
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v2, v2, v6
v_add_f32_e32 v2, v2, v7
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v2, v2, v8
v_add_f32_e32 v2, v2, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v10
v_add_u32_e32 v3, 0x900, v3
s_cmp_eq_u32 s4, s5
v_add_f32_e32 v2, v2, v11
s_cbranch_scc0 65509
s_and_b32 s5, s8, 7
s_cmp_eq_u32 s5, 0
s_cbranch_scc0 7
s_branch 18
v_mov_b32_e32 v2, 0
s_branch 16
v_mov_b32_e32 v2, 0
s_and_b32 s5, s8, 7
s_cmp_eq_u32 s5, 0
s_cbranch_scc1 12
s_mulk_i32 s4, 0x120
v_lshl_add_u32 v3, v0, 2, s4
ds_read_b32 v4, v3
s_add_i32 s5, s5, -1
v_add_u32_e32 v3, 0x120, v3
s_cmp_lg_u32 s5, 0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v4
s_cbranch_scc1 65527
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v0, vcc, s10, v0
s_mul_i32 s4, s13, s9
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
v_mov_b32_e32 v3, s14
v_mad_u64_u32 v[0:1], s[4:5], s4, v3, v[0:1]
s_mul_hi_i32 s4, s13, s9
s_mul_i32 s4, s4, s14
v_add_u32_e32 v1, s4, v1
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_mov_b32_e32 v3, s21
v_add_co_u32_e32 v0, vcc, s20, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
