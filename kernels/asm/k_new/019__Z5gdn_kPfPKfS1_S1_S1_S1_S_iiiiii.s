.text
k__Z5gdn_kPfPKfS1_S1_S1_S1_S_iiiiii:
s_load_dword s6, s[4:5], 0x5c
s_load_dwordx4 s[20:23], s[4:5], 0x38
s_add_u32 s0, s0, s10
s_addc_u32 s1, s1, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s6, s6, 0xffff
s_mul_i32 s9, s9, s6
v_add_u32_e32 v0, s9, v0
v_cmp_gt_i32_e32 vcc, s23, v0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 516
s_load_dwordx2 s[6:7], s[4:5], 0x48
s_waitcnt lgkmcnt(0)
s_cmp_eq_u32 s7, 0
s_cbranch_scc1 512
s_ashr_i32 s7, s21, 31
s_add_i32 s9, s21, s7
s_xor_b32 s7, s9, s7
v_cvt_f32_u32_e32 v1, s7
s_sub_i32 s11, 0, s7
s_ashr_i32 s9, s8, 31
s_add_i32 s10, s8, s9
v_rcp_iflag_f32_e32 v1, v1
s_xor_b32 s10, s10, s9
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s12, v1
s_mul_i32 s11, s11, s12
s_mul_hi_u32 s11, s12, s11
s_add_i32 s12, s12, s11
s_mul_hi_u32 s11, s10, s12
s_mul_i32 s11, s11, s7
s_sub_i32 s10, s10, s11
s_sub_i32 s11, s10, s7
s_cmp_ge_u32 s10, s7
s_cselect_b32 s10, s11, s10
s_sub_i32 s11, s10, s7
s_cmp_ge_u32 s10, s7
s_cselect_b32 s7, s11, s10
s_xor_b32 s7, s7, s9
s_sub_i32 s34, s7, s9
s_cbranch_execnz 30
s_ashr_i32 s7, s6, 31
s_add_i32 s6, s6, s7
s_xor_b32 s6, s6, s7
v_cvt_f32_u32_e32 v1, s6
s_ashr_i32 s9, s8, 31
s_add_i32 s10, s8, s9
s_xor_b32 s7, s9, s7
v_rcp_iflag_f32_e32 v1, v1
s_xor_b32 s9, s10, s9
s_sub_i32 s10, 0, s6
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s11, v1
s_mul_i32 s10, s10, s11
s_mul_hi_u32 s10, s11, s10
s_add_i32 s11, s11, s10
s_mul_hi_u32 s10, s9, s11
s_mul_i32 s11, s10, s6
s_sub_i32 s9, s9, s11
s_add_i32 s12, s10, 1
s_sub_i32 s11, s9, s6
s_cmp_ge_u32 s9, s6
s_cselect_b32 s10, s12, s10
s_cselect_b32 s9, s11, s9
s_add_i32 s11, s10, 1
s_cmp_ge_u32 s9, s6
s_cselect_b32 s6, s11, s10
s_xor_b32 s6, s6, s7
s_sub_i32 s34, s6, s7
s_load_dwordx4 s[24:27], s[4:5], 0x30
v_ashrrev_i32_e32 v1, 31, v0
v_mov_b32_e32 v2, s8
v_mad_i64_i32 v[2:3], s[6:7], s23, v2, v[0:1]
s_ashr_i32 s9, s23, 31
s_cmp_gt_i32 s23, 0
s_waitcnt lgkmcnt(0)
s_cselect_b64 s[26:27], -1, 0
s_cmp_lt_i32 s23, 1
s_mov_b32 s6, 0
s_cbranch_scc1 65
s_cmp_lt_u32 s23, 4
s_cbranch_scc1 29
v_mul_lo_u32 v6, v3, s23
v_mul_lo_u32 v7, v2, s9
v_mad_u64_u32 v[4:5], s[6:7], v2, s23, 0
s_and_b32 s6, s23, -4
s_mov_b32 s7, 0
v_add3_u32 v5, v5, v7, v6
v_lshlrev_b64 v[4:5], 2, v[4:5]
v_mov_b32_e32 v6, s25
v_add_co_u32_e32 v4, vcc, s24, v4
v_addc_co_u32_e32 v5, vcc, v5, v6, vcc
v_add_co_u32_e32 v4, vcc, 8, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_mov_b32_e32 v6, 16
global_load_dwordx4 v[7:10], v[4:5], off offset:-8
s_add_i32 s7, s7, 4
v_add_co_u32_e32 v4, vcc, 16, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_eq_u32 s6, s7
s_waitcnt vmcnt(0)
buffer_store_dwordx4 v[7:10], v6, s[0:3], 0 offen
v_add_u32_e32 v6, 16, v6
s_cbranch_scc0 65525
s_and_b32 s10, s23, 3
s_cmp_eq_u32 s10, 0
s_mov_b32 s7, 0
s_cbranch_scc1 30
v_mul_lo_u32 v7, v3, s23
v_mul_lo_u32 v8, v2, s9
v_mad_u64_u32 v[4:5], s[12:13], v2, s23, 0
s_lshl_b32 s11, s6, 2
s_lshl_b64 s[6:7], s[6:7], 2
v_add3_u32 v5, v5, v8, v7
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_add_u32 s6, s24, s6
s_addc_u32 s7, s25, s7
v_mov_b32_e32 v6, 16
v_mov_b32_e32 v7, s7
v_add_co_u32_e32 v4, vcc, s6, v4
v_add_u32_e32 v6, s11, v6
v_addc_co_u32_e32 v5, vcc, v7, v5, vcc
global_load_dword v7, v[4:5], off
v_add_co_u32_e32 v4, vcc, 4, v4
s_add_i32 s10, s10, -1
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_lg_u32 s10, 0
s_waitcnt vmcnt(0)
buffer_store_dword v7, v6, s[0:3], 0 offen
v_add_u32_e32 v6, 4, v6
s_cbranch_scc1 65525
s_cmp_lt_i32 s20, 1
s_cbranch_scc1 305
s_ashr_i32 s33, s8, 31
v_cvt_f32_i32_e32 v4, s23
s_cmp_lt_i32 s23, 1
v_mov_b32_e32 v5, 0x4f800000
s_cselect_b64 vcc, -1, 0
v_cndmask_b32_e32 v5, 1.0, v5, vcc
v_mul_f32_e32 v4, v5, v4
s_mov_b32 s6, 0xf800000
v_mul_f32_e32 v5, 0x4f800000, v4
v_cmp_gt_f32_e64 s[6:7], s6, v4
v_cndmask_b32_e64 v5, v4, v5, s[6:7]
s_mov_b32 s44, s22
v_sqrt_f32_e32 v6, v5
s_ashr_i32 s22, s22, 31
s_and_b32 s45, s23, 3
s_load_dwordx8 s[12:19], s[4:5], 0x0
s_load_dwordx4 s[28:31], s[4:5], 0x20
v_add_u32_e32 v7, -1, v6
v_fma_f32 v8, -v7, v6, v5
v_cmp_ge_f32_e64 s[10:11], 0, v8
v_add_u32_e32 v8, 1, v6
v_cndmask_b32_e64 v7, v6, v7, s[10:11]
v_fma_f32 v6, -v8, v6, v5
v_cmp_lt_f32_e64 s[10:11], 0, v6
v_cndmask_b32_e64 v6, v7, v8, s[10:11]
v_mul_f32_e32 v7, 0x37800000, v6
v_cndmask_b32_e64 v6, v6, v7, s[6:7]
v_mov_b32_e32 v7, 0x260
v_cmp_class_f32_e64 s[6:7], v5, v7
v_cndmask_b32_e64 v5, v6, v5, s[6:7]
v_add_u32_e32 v6, -1, v5
v_add_u32_e32 v7, 1, v5
v_mov_b32_e32 v8, 0x37800000
v_fma_f32 v10, -v6, v5, v4
v_cndmask_b32_e32 v8, 1.0, v8, vcc
v_fma_f32 v9, -v7, v5, v4
v_cmp_ge_f32_e32 vcc, 0, v10
v_cndmask_b32_e32 v5, v5, v6, vcc
v_cmp_lt_f32_e32 vcc, 0, v9
s_movk_i32 s6, 0x260
v_cndmask_b32_e32 v5, v5, v7, vcc
v_mul_f32_e32 v5, v8, v5
v_cmp_class_f32_e64 vcc, v4, s6
v_cndmask_b32_e32 v4, v5, v4, vcc
v_div_scale_f32 v5, s[6:7], v4, v4, 1.0
v_div_scale_f32 v6, vcc, 1.0, v4, 1.0
s_cmp_gt_u32 s23, 3
s_cselect_b64 s[6:7], -1, 0
s_and_b32 s46, s23, -4
s_mul_hi_i32 s35, s34, s23
s_mul_i32 s34, s34, s23
s_cmp_lg_u32 s45, 0
s_cselect_b64 s[10:11], -1, 0
s_lshl_b64 s[34:35], s[34:35], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s47, s16, s34
s_addc_u32 s48, s17, s35
s_add_u32 s36, s47, 8
s_mul_hi_i32 s39, s23, s21
v_rcp_f32_e32 v7, v5
s_mul_i32 s38, s23, s21
s_mov_b32 s5, 0
s_addc_u32 s37, s48, 0
v_fma_f32 v8, -v5, v7, 1.0
v_fmac_f32_e32 v7, v8, v7
v_mul_f32_e32 v8, v6, v7
v_fma_f32 v9, -v5, v8, v6
v_fmac_f32_e32 v8, v9, v7
v_fma_f32 v5, -v5, v8, v6
v_div_fmas_f32 v5, v5, v7, v8
s_lshl_b64 s[38:39], s[38:39], 2
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v8, 16
s_mov_b32 s21, 0
v_div_fixup_f32 v6, v5, v4, 1.0
s_branch 18
s_waitcnt vmcnt(0)
v_mov_b32_e32 v9, 0
s_add_i32 s21, s21, 1
s_add_u32 s36, s36, s38
s_addc_u32 s37, s37, s39
s_add_u32 s47, s47, s38
s_addc_u32 s48, s48, s39
s_add_u32 s14, s14, s38
s_addc_u32 s15, s15, s39
s_add_u32 s16, s16, s38
v_mov_b32_e32 v10, s13
v_add_co_u32_e32 v4, vcc, s12, v4
s_addc_u32 s17, s17, s39
v_addc_co_u32_e32 v5, vcc, v10, v5, vcc
s_cmp_eq_u32 s21, s20
global_store_dword v[4:5], v9, off
s_cbranch_scc1 182
s_mul_i32 s4, s21, s22
s_mul_hi_u32 s40, s21, s44
s_add_i32 s4, s40, s4
s_mul_i32 s40, s21, s44
s_add_u32 s40, s40, s8
s_addc_u32 s41, s4, s33
s_lshl_b64 s[42:43], s[40:41], 2
s_add_u32 s50, s30, s42
s_addc_u32 s51, s31, s43
global_load_dword v9, v7, s[50:51]
s_andn2_b64 vcc, exec, s[26:27]
v_mov_b32_e32 v10, 0
s_cbranch_vccnz 67
s_add_u32 s42, s28, s42
s_addc_u32 s43, s29, s43
global_load_dword v4, v7, s[42:43]
s_andn2_b64 vcc, exec, s[6:7]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v4, 0x3fb8aa3b, v4
s_nop 0
v_exp_f32_e32 v4, v4
s_cbranch_vccnz 30
v_mov_b32_e32 v5, 16
s_mov_b32 s4, 0
v_mov_b32_e32 v10, 0
s_mov_b64 s[42:43], s[36:37]
buffer_load_dwordx4 v[11:14], v5, s[0:3], 0 offen
global_load_dwordx4 v[15:18], v7, s[42:43] offset:-8
s_add_i32 s4, s4, 4
s_add_u32 s42, s42, 16
s_addc_u32 s43, s43, 0
s_cmp_eq_u32 s46, s4
s_waitcnt vmcnt(1)
v_mul_f32_e32 v11, v4, v11
v_mul_f32_e32 v12, v4, v12
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v10, v11, v15
v_mul_f32_e32 v13, v4, v13
v_fmac_f32_e32 v10, v12, v16
v_mul_f32_e32 v14, v4, v14
v_fmac_f32_e32 v10, v13, v17
buffer_store_dwordx4 v[11:14], v5, s[0:3], 0 offen
v_add_u32_e32 v5, 16, v5
v_fmac_f32_e32 v10, v14, v18
s_cbranch_scc0 65514
s_mov_b32 s4, s46
s_andn2_b64 vcc, exec, s[10:11]
s_cbranch_vccz 5
s_branch 26
s_mov_b32 s4, 0
v_mov_b32_e32 v10, 0
s_andn2_b64 vcc, exec, s[10:11]
s_cbranch_vccnz 22
s_lshl_b32 s42, s4, 2
v_add_u32_e32 v5, s42, v8
s_lshl_b64 s[42:43], s[4:5], 2
s_add_u32 s42, s47, s42
s_addc_u32 s43, s48, s43
s_mov_b32 s4, s45
buffer_load_dword v11, v5, s[0:3], 0 offen
global_load_dword v12, v7, s[42:43]
s_add_u32 s42, s42, 4
s_addc_u32 s43, s43, 0
s_add_i32 s4, s4, -1
s_cmp_lg_u32 s4, 0
s_waitcnt vmcnt(1)
v_mul_f32_e32 v11, v4, v11
buffer_store_dword v11, v5, s[0:3], 0 offen
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v10, v11, v12
v_add_u32_e32 v5, 4, v5
s_cbranch_scc1 65520
v_mov_b32_e32 v4, s23
v_mad_u64_u32 v[4:5], s[42:43], s40, v4, v[0:1]
s_mul_i32 s4, s41, s23
s_mul_i32 s40, s40, s9
v_add_u32_e32 v5, s4, v5
v_add_u32_e32 v5, s40, v5
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_andn2_b64 vcc, exec, s[26:27]
s_cbranch_vccnz 65426
v_mov_b32_e32 v12, s19
v_add_co_u32_e32 v11, vcc, s18, v4
v_addc_co_u32_e32 v12, vcc, v12, v5, vcc
global_load_dword v11, v[11:12], off
s_andn2_b64 vcc, exec, s[6:7]
s_waitcnt vmcnt(0)
v_sub_f32_e32 v10, v11, v10
v_mul_f32_e32 v10, v9, v10
s_cbranch_vccnz 46
v_mov_b32_e32 v11, 16
s_mov_b32 s4, 0
v_mov_b32_e32 v9, 0
s_mov_b64 s[40:41], s[16:17]
s_mov_b64 s[42:43], s[14:15]
s_add_u32 s50, s40, s34
s_addc_u32 s51, s41, s35
global_load_dwordx4 v[16:19], v7, s[50:51]
s_add_u32 s50, s42, s34
buffer_load_dwordx4 v[12:15], v11, s[0:3], 0 offen
s_addc_u32 s51, s43, s35
global_load_dwordx4 v[20:23], v7, s[50:51]
s_add_i32 s4, s4, 4
s_add_u32 s42, s42, 16
s_addc_u32 s43, s43, 0
s_add_u32 s40, s40, 16
s_addc_u32 s41, s41, 0
s_cmp_eq_u32 s46, s4
s_waitcnt vmcnt(1)
v_fma_f32 v12, v10, v16, v12
v_fma_f32 v13, v10, v17, v13
v_fma_f32 v14, v10, v18, v14
v_fmac_f32_e32 v15, v10, v19
buffer_store_dwordx4 v[12:15], v11, s[0:3], 0 offen
v_add_u32_e32 v11, 16, v11
s_waitcnt vmcnt(1)
v_mul_f32_e32 v12, v12, v20
v_mul_f32_e32 v13, v13, v21
v_fmac_f32_e32 v9, v6, v12
v_mul_f32_e32 v14, v14, v22
v_fmac_f32_e32 v9, v6, v13
v_mul_f32_e32 v15, v15, v23
v_fmac_f32_e32 v9, v6, v14
v_fmac_f32_e32 v9, v6, v15
s_cbranch_scc0 65499
s_mov_b32 s4, s46
s_andn2_b64 vcc, exec, s[10:11]
s_cbranch_vccz 5
s_branch 65372
s_mov_b32 s4, 0
v_mov_b32_e32 v9, 0
s_andn2_b64 vcc, exec, s[10:11]
s_cbranch_vccnz 65368
s_lshl_b32 s40, s4, 2
v_add_u32_e32 v11, s40, v8
s_lshl_b64 s[40:41], s[4:5], 2
s_add_u32 s4, s40, s34
s_addc_u32 s40, s41, s35
s_mov_b32 s41, s45
s_add_u32 s42, s16, s4
s_addc_u32 s43, s17, s40
global_load_dword v13, v7, s[42:43]
s_add_u32 s42, s14, s4
buffer_load_dword v12, v11, s[0:3], 0 offen
s_addc_u32 s43, s15, s40
global_load_dword v14, v7, s[42:43]
s_add_u32 s4, s4, 4
s_addc_u32 s40, s40, 0
s_add_i32 s41, s41, -1
s_cmp_lg_u32 s41, 0
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v12, v10, v13
buffer_store_dword v12, v11, s[0:3], 0 offen
s_waitcnt vmcnt(1)
v_mul_f32_e32 v12, v12, v14
v_add_u32_e32 v11, 4, v11
v_fmac_f32_e32 v9, v6, v12
s_cbranch_scc1 65513
s_branch 65338
s_andn2_b64 vcc, exec, s[26:27]
s_cbranch_vccnz 66
v_mul_lo_u32 v0, v3, s23
v_mul_lo_u32 v1, v2, s9
s_cmp_lt_u32 s23, 4
s_mov_b32 s4, 0
s_cbranch_scc1 25
v_mad_u64_u32 v[4:5], s[4:5], v2, s23, 0
v_mov_b32_e32 v6, s25
s_and_b32 s4, s23, -4
v_add3_u32 v5, v5, v1, v0
v_lshlrev_b64 v[0:1], 2, v[4:5]
v_mov_b32_e32 v4, 16
v_add_co_u32_e32 v0, vcc, s24, v0
v_addc_co_u32_e32 v1, vcc, v1, v6, vcc
v_add_co_u32_e32 v0, vcc, 8, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_mov_b32 s5, 0
buffer_load_dwordx4 v[5:8], v4, s[0:3], 0 offen
s_add_i32 s5, s5, 4
v_add_u32_e32 v4, 16, v4
s_cmp_eq_u32 s4, s5
s_waitcnt vmcnt(0)
global_store_dwordx4 v[0:1], v[5:8], off offset:-8
v_add_co_u32_e32 v0, vcc, 16, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_cbranch_scc0 65525
s_and_b32 s6, s23, 3
s_cmp_eq_u32 s6, 0
s_mov_b32 s5, 0
s_cbranch_scc1 30
v_mul_lo_u32 v3, v3, s23
v_mul_lo_u32 v4, v2, s9
v_mad_u64_u32 v[0:1], s[8:9], v2, s23, 0
s_lshl_b32 s7, s4, 2
s_lshl_b64 s[4:5], s[4:5], 2
v_add3_u32 v1, v1, v4, v3
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_add_u32 s4, s24, s4
s_addc_u32 s5, s25, s5
v_mov_b32_e32 v2, 16
v_mov_b32_e32 v3, s5
v_add_co_u32_e32 v0, vcc, s4, v0
v_add_u32_e32 v2, s7, v2
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
buffer_load_dword v3, v2, s[0:3], 0 offen
s_add_i32 s6, s6, -1
v_add_u32_e32 v2, 4, v2
s_cmp_lg_u32 s6, 0
s_waitcnt vmcnt(0)
global_store_dword v[0:1], v3, off
v_add_co_u32_e32 v0, vcc, 4, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_cbranch_scc1 65525
s_endpgm
s_branch 65051
