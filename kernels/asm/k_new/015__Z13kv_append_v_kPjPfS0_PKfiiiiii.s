.text
k__Z13kv_append_v_kPjPfS0_PKfiiiiii:
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_waitcnt lgkmcnt(0)
s_cmp_lt_i32 s17, 1
s_cbranch_scc1 538
s_load_dwordx2 s[20:21], s[4:5], 0x30
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_mul_i32 s2, s19, s6
s_mul_hi_i32 s0, s19, s6
s_ashr_i32 s7, s6, 31
s_waitcnt lgkmcnt(0)
s_ashr_i32 s33, s20, 31
s_mul_i32 s1, s2, s33
s_mul_hi_u32 s3, s2, s20
s_add_i32 s1, s3, s1
s_mul_i32 s0, s0, s20
s_add_i32 s1, s1, s0
s_mul_i32 s0, s2, s20
s_ashr_i32 s5, s19, 31
s_lshl_b64 s[0:1], s[0:1], 2
s_add_u32 s0, s12, s0
s_addc_u32 s1, s13, s1
v_mov_b32_e32 v3, s1
s_add_i32 s1, s20, s33
s_xor_b32 s38, s1, s33
v_cvt_f32_u32_e32 v5, s38
v_lshlrev_b32_e32 v4, 2, v0
v_add_co_u32_e32 v2, vcc, s0, v4
v_rcp_iflag_f32_e32 v5, v5
s_ashr_i32 s0, s21, 31
s_lshr_b32 s1, s0, 30
s_add_i32 s1, s21, s1
v_mul_f32_e32 v5, 0x4f7ffffe, v5
v_cvt_u32_f32_e32 v10, v5
s_add_i32 s3, s21, s0
s_ashr_i32 s2, s1, 2
s_xor_b32 s1, s0, s33
s_xor_b32 s0, s3, s0
s_sub_i32 s3, 0, s38
v_readfirstlane_b32 s21, v10
s_mul_i32 s3, s3, s21
s_mul_hi_u32 s3, s21, s3
s_add_i32 s21, s21, s3
s_mul_hi_u32 s3, s0, s21
s_mul_i32 s21, s3, s38
s_sub_i32 s0, s0, s21
s_add_i32 s21, s3, 1
s_sub_i32 s22, s0, s38
s_cmp_ge_u32 s0, s38
s_cselect_b32 s3, s21, s3
s_cselect_b32 s0, s22, s0
s_add_i32 s21, s3, 1
s_cmp_ge_u32 s0, s38
s_cselect_b32 s0, s21, s3
s_xor_b32 s0, s0, s1
s_sub_i32 s0, s0, s1
s_cmp_gt_i32 s20, 0
s_mul_hi_i32 s21, s0, s6
s_mul_i32 s39, s0, s6
s_cselect_b64 s[24:25], -1, 0
s_lshr_b32 s0, s33, 30
s_add_i32 s0, s20, s0
s_ashr_i32 s3, s0, 2
s_mul_hi_i32 s1, s19, s18
s_mul_i32 s0, s19, s18
s_mov_b32 s4, s19
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_lshl_b64 s[26:27], s[0:1], 2
s_mul_hi_i32 s1, s6, s20
s_mul_i32 s0, s6, s20
s_lshl_b64 s[28:29], s[4:5], 5
s_lshl_b64 s[30:31], s[4:5], 2
v_mov_b32_e32 v5, s13
v_add_co_u32_e32 v4, vcc, s12, v4
s_lshl_b64 s[12:13], s[0:1], 2
s_add_u32 s22, s12, 12
s_addc_u32 s34, s13, 0
s_mul_i32 s35, s22, s5
s_mul_hi_u32 s36, s22, s19
s_add_i32 s35, s36, s35
s_mul_i32 s34, s34, s19
s_add_i32 s40, s35, s34
s_lshl_b64 s[34:35], s[4:5], 4
s_mul_i32 s41, s22, s19
s_add_u32 s22, s12, 8
s_addc_u32 s36, s13, 0
s_mul_i32 s37, s22, s5
s_mul_hi_u32 s42, s22, s19
s_add_i32 s37, s42, s37
s_mul_i32 s36, s36, s19
s_add_i32 s42, s37, s36
s_mul_i32 s43, s22, s19
s_add_u32 s22, s12, 4
s_addc_u32 s36, s13, 0
s_mul_i32 s37, s22, s5
s_mul_hi_u32 s44, s22, s19
s_add_i32 s37, s44, s37
s_mul_i32 s36, s36, s19
s_add_i32 s44, s37, s36
s_mul_i32 s45, s22, s19
s_mul_i32 s22, s0, s5
s_mul_hi_u32 s36, s0, s19
s_add_i32 s22, s36, s22
s_mul_i32 s1, s1, s19
s_add_i32 s1, s22, s1
s_mul_i32 s0, s0, s19
s_lshl_b64 s[36:37], s[0:1], 2
s_mul_hi_i32 s0, s6, s2
s_mul_i32 s2, s6, s2
s_mul_i32 s1, s2, s5
s_mul_hi_u32 s22, s2, s19
s_add_i32 s1, s22, s1
s_mul_i32 s0, s0, s19
s_add_i32 s1, s1, s0
s_mul_i32 s0, s2, s19
s_lshl_b64 s[0:1], s[0:1], 2
s_add_u32 s8, s8, s0
s_mov_b32 s23, 0
v_mov_b32_e32 v1, 0
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_addc_u32 s9, s9, s1
s_mul_hi_i32 s46, s3, s19
s_mul_i32 s19, s3, s19
s_mov_b32 s47, 0x42fe0000
s_mov_b32 s48, 0x2f800000
s_mov_b32 s49, 0xcf800000
s_movk_i32 s50, 0xff80
s_mov_b32 s51, 0xc0c0500
s_mov_b32 s52, 0xff0000
v_mov_b32_e32 v11, 0x7f
s_mov_b32 s53, 0
s_branch 3
s_add_i32 s53, s54, s53
s_cmp_ge_i32 s53, s17
s_cbranch_scc1 399
s_add_i32 s0, s53, s16
s_ashr_i32 s1, s0, 31
s_add_i32 s3, s1, s0
s_xor_b32 s2, s1, s33
s_xor_b32 s1, s3, s1
v_readfirstlane_b32 s3, v10
s_mul_i32 s22, s38, s3
s_sub_i32 s22, 0, s22
s_mul_hi_u32 s22, s22, s3
s_add_i32 s22, s22, s3
s_mul_hi_u32 s3, s1, s22
s_mul_i32 s22, s3, s38
s_sub_i32 s1, s1, s22
s_add_i32 s22, s3, 1
s_sub_i32 s54, s1, s38
s_cmp_ge_u32 s1, s38
s_cselect_b32 s3, s22, s3
s_cselect_b32 s1, s54, s1
s_add_i32 s22, s3, 1
s_cmp_ge_u32 s1, s38
s_cselect_b32 s1, s22, s3
s_xor_b32 s1, s1, s2
s_sub_i32 s2, s1, s2
s_mul_i32 s1, s2, s20
s_sub_i32 s0, s0, s1
s_sub_i32 s1, s17, s53
s_sub_i32 s3, s20, s0
s_min_i32 s54, s1, s3
s_cmp_lt_i32 s54, 1
s_cbranch_scc1 36
s_mul_i32 s1, s53, s18
s_add_u32 s1, s1, s6
v_mov_b32_e32 v6, s4
v_mad_u64_u32 v[6:7], s[56:57], s1, v6, v[0:1]
s_mul_hi_i32 s3, s53, s18
s_addc_u32 s3, s3, s7
s_mul_i32 s3, s3, s4
v_add_u32_e32 v7, s3, v7
s_mul_i32 s1, s1, s5
v_add_u32_e32 v7, s1, v7
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_mov_b32_e32 v8, s15
v_add_co_u32_e32 v6, vcc, s14, v6
v_addc_co_u32_e32 v7, vcc, v8, v7, vcc
s_mov_b32 s1, s0
s_mov_b32 s3, s54
global_load_dword v12, v[6:7], off
s_mul_hi_i32 s57, s1, s4
s_mul_i32 s56, s1, s4
v_mov_b32_e32 v8, s27
v_add_co_u32_e32 v6, vcc, s26, v6
s_lshl_b64 s[56:57], s[56:57], 2
v_addc_co_u32_e32 v7, vcc, v7, v8, vcc
s_add_i32 s3, s3, -1
s_add_i32 s1, s1, 1
v_mov_b32_e32 v9, s57
v_add_co_u32_e32 v8, vcc, s56, v2
s_cmp_eq_u32 s3, 0
v_addc_co_u32_e32 v9, vcc, v3, v9, vcc
s_waitcnt vmcnt(0)
global_store_dword v[8:9], v12, off
s_cbranch_scc0 65518
s_add_i32 s55, s54, s0
s_cmp_lt_i32 s55, 1
s_cbranch_scc1 62
s_add_i32 s0, s55, -1
s_cmp_lt_u32 s0, 7
s_cbranch_scc1 61
v_mov_b32_e32 v7, v3
s_and_b32 s22, s55, -8
s_mov_b32 s0, 0
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v6, v2
v_mov_b32_e32 v18, s31
v_add_co_u32_e32 v12, vcc, s30, v6
v_addc_co_u32_e32 v13, vcc, v7, v18, vcc
v_add_co_u32_e32 v14, vcc, s30, v12
v_addc_co_u32_e32 v15, vcc, v13, v18, vcc
v_add_co_u32_e32 v16, vcc, s30, v14
v_addc_co_u32_e32 v17, vcc, v15, v18, vcc
global_load_dword v9, v[6:7], off
global_load_dword v19, v[12:13], off
global_load_dword v20, v[14:15], off
v_add_co_u32_e32 v12, vcc, s30, v16
v_addc_co_u32_e32 v13, vcc, v17, v18, vcc
v_add_co_u32_e32 v14, vcc, s30, v12
v_addc_co_u32_e32 v15, vcc, v13, v18, vcc
global_load_dword v21, v[16:17], off
global_load_dword v22, v[12:13], off
v_add_co_u32_e32 v12, vcc, s30, v14
v_addc_co_u32_e32 v13, vcc, v15, v18, vcc
v_add_co_u32_e32 v16, vcc, s30, v12
v_addc_co_u32_e32 v17, vcc, v13, v18, vcc
global_load_dword v14, v[14:15], off
s_nop 0
global_load_dword v12, v[12:13], off
s_add_i32 s0, s0, 8
global_load_dword v13, v[16:17], off
v_mov_b32_e32 v15, s29
v_add_co_u32_e32 v6, vcc, s28, v6
v_addc_co_u32_e32 v7, vcc, v7, v15, vcc
s_cmp_eq_u32 s22, s0
s_waitcnt vmcnt(6)
v_max3_f32 v8, v8, |v9|, |v19|
s_waitcnt vmcnt(4)
v_max3_f32 v8, v8, |v20|, |v21|
s_waitcnt vmcnt(2)
v_max3_f32 v8, v8, |v22|, |v14|
s_waitcnt vmcnt(0)
v_max3_f32 v8, v8, |v12|, |v13|
s_cbranch_scc0 65486
s_and_b32 s0, s55, 7
s_cmp_eq_u32 s0, 0
s_cbranch_scc0 8
s_branch 34
v_mov_b32_e32 v8, 0
s_branch 32
s_mov_b32 s22, 0
v_mov_b32_e32 v8, 0
s_and_b32 s0, s55, 7
s_cmp_eq_u32 s0, 0
s_cbranch_scc1 27
s_lshl_b64 s[56:57], s[22:23], 2
s_add_u32 s1, s56, s12
v_mov_b32_e32 v6, s4
v_mad_u64_u32 v[6:7], s[58:59], s1, v6, v[4:5]
s_addc_u32 s3, s57, s13
s_mul_i32 s3, s3, s4
v_add_u32_e32 v7, s3, v7
s_mul_i32 s1, s1, s5
s_sub_i32 s0, 0, s0
v_add_u32_e32 v7, s1, v7
v_mov_b32_e32 v9, s0
global_load_dword v12, v[6:7], off
v_max_f32_e32 v8, v8, v8
v_mov_b32_e32 v13, s31
v_add_co_u32_e32 v9, vcc, 1, v9
v_add_co_u32_e64 v6, s[0:1], s30, v6
v_addc_co_u32_e64 v7, s[0:1], v7, v13, s[0:1]
s_andn2_b64 vcc, exec, vcc
s_waitcnt vmcnt(0)
v_max_f32_e64 v12, |v12|, |v12|
v_max_f32_e32 v8, v8, v12
s_cbranch_vccnz 65521
v_div_scale_f32 v6, s[0:1], s47, s47, v8
v_div_scale_f32 v7, vcc, v8, s47, v8
s_ashr_i32 s0, s2, 31
v_mov_b32_e32 v12, s4
s_add_u32 s1, s2, s39
s_addc_u32 s3, s0, s21
s_mul_i32 s3, s3, s4
v_mov_b32_e32 v13, s11
v_rcp_f32_e32 v9, v6
v_fma_f32 v14, -v6, v9, 1.0
v_fmac_f32_e32 v9, v14, v9
v_mul_f32_e32 v14, v7, v9
v_fma_f32 v15, -v6, v14, v7
v_fmac_f32_e32 v14, v15, v9
v_fma_f32 v6, -v6, v14, v7
v_div_fmas_f32 v9, v6, v9, v14
v_mad_u64_u32 v[6:7], s[56:57], s1, v12, v[0:1]
s_mul_i32 s1, s1, s5
v_add_u32_e32 v7, s3, v7
v_add_u32_e32 v7, s1, v7
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_add_co_u32_e32 v6, vcc, s10, v6
v_addc_co_u32_e32 v7, vcc, v13, v7, vcc
v_cmp_lt_f32_e32 vcc, 0, v8
v_div_fixup_f32 v9, v9, s47, v8
v_cndmask_b32_e32 v12, 1.0, v9, vcc
s_andn2_b64 vcc, exec, s[24:25]
global_store_dword v[6:7], v12, off
s_cbranch_vccnz 65329
v_mov_b32_e32 v6, s2
v_mad_u64_u32 v[6:7], s[56:57], s19, v6, v[0:1]
s_mul_i32 s1, s46, s2
s_mul_i32 s0, s19, s0
v_add_u32_e32 v7, s1, v7
v_add_u32_e32 v7, s0, v7
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_mov_b32_e32 v8, s9
v_add_co_u32_e32 v6, vcc, s8, v6
v_addc_co_u32_e32 v7, vcc, v8, v7, vcc
v_mov_b32_e32 v9, v5
s_mov_b32 s0, 0
v_mov_b32_e32 v8, v4
s_branch 143
s_waitcnt vmcnt(0)
v_div_scale_f32 v17, s[0:1], v12, v12, v16
v_div_scale_f32 v18, s[0:1], v12, v12, v15
v_div_scale_f32 v19, vcc, v16, v12, v16
v_div_scale_f32 v20, s[0:1], v15, v12, v15
v_div_scale_f32 v21, s[2:3], v12, v12, v14
v_div_scale_f32 v24, s[2:3], v14, v12, v14
v_rcp_f32_e32 v22, v17
v_rcp_f32_e32 v23, v18
v_fma_f32 v25, -v17, v22, 1.0
v_fmac_f32_e32 v22, v25, v22
v_mul_f32_e32 v25, v19, v22
v_fma_f32 v27, -v17, v25, v19
v_fma_f32 v26, -v18, v23, 1.0
v_fmac_f32_e32 v25, v27, v22
v_fmac_f32_e32 v23, v26, v23
v_fma_f32 v17, -v17, v25, v19
v_mul_f32_e32 v26, v20, v23
v_div_fmas_f32 v17, v17, v22, v25
v_fma_f32 v28, -v18, v26, v20
v_fmac_f32_e32 v26, v28, v23
v_fma_f32 v18, -v18, v26, v20
s_mov_b64 vcc, s[0:1]
v_div_fmas_f32 v18, v18, v23, v26
v_div_scale_f32 v20, s[0:1], v12, v12, v13
v_rcp_f32_e32 v19, v21
v_div_scale_f32 v22, s[0:1], v13, v12, v13
s_mov_b64 vcc, s[2:3]
v_fma_f32 v23, -v21, v19, 1.0
v_fmac_f32_e32 v19, v23, v19
v_mul_f32_e32 v23, v24, v19
v_fma_f32 v25, -v21, v23, v24
v_div_fixup_f32 v16, v17, v12, v16
v_rndne_f32_e32 v16, v16
v_mul_f32_e64 v17, |v16|, s48
v_floor_f32_e32 v17, v17
v_fmac_f32_e32 v23, v25, v19
v_div_fixup_f32 v15, v18, v12, v15
v_ashrrev_i32_e32 v18, 31, v16
v_fma_f32 v16, v17, s49, |v16|
v_cvt_u32_f32_e32 v16, v16
v_rndne_f32_e32 v15, v15
v_mul_f32_e64 v17, |v15|, s48
v_floor_f32_e32 v17, v17
v_xor_b32_e32 v16, v16, v18
v_sub_u32_e32 v16, v16, v18
v_fma_f32 v18, -v21, v23, v24
v_div_fmas_f32 v18, v18, v19, v23
v_rcp_f32_e32 v19, v20
s_mov_b64 vcc, s[0:1]
v_fma_f32 v17, v17, s49, |v15|
v_cvt_u32_f32_e32 v17, v17
v_fma_f32 v21, -v20, v19, 1.0
v_fmac_f32_e32 v19, v21, v19
v_mul_f32_e32 v21, v22, v19
v_fma_f32 v23, -v20, v21, v22
v_fmac_f32_e32 v21, v23, v19
v_fma_f32 v20, -v20, v21, v22
v_div_fmas_f32 v19, v20, v19, v21
v_ashrrev_i32_e32 v15, 31, v15
v_xor_b32_e32 v17, v17, v15
v_sub_u32_e32 v15, v17, v15
v_med3_i32 v15, v15, s50, v11
v_div_fixup_f32 v14, v18, v12, v14
v_rndne_f32_e32 v14, v14
v_mul_f32_e64 v17, |v14|, s48
v_floor_f32_e32 v17, v17
v_fma_f32 v17, v17, s49, |v14|
v_cvt_u32_f32_e32 v17, v17
v_med3_i32 v16, v16, s50, v11
v_lshlrev_b32_e32 v15, 8, v15
v_ashrrev_i32_e32 v14, 31, v14
v_perm_b32 v15, v15, v16, s51
v_xor_b32_e32 v16, v17, v14
v_div_fixup_f32 v13, v19, v12, v13
v_rndne_f32_e32 v13, v13
v_sub_u32_e32 v14, v16, v14
v_mul_f32_e64 v16, |v13|, s48
v_floor_f32_e32 v16, v16
v_fma_f32 v16, v16, s49, |v13|
v_cvt_u32_f32_e32 v16, v16
v_med3_i32 v14, v14, s50, v11
v_lshlrev_b32_e32 v14, 16, v14
v_ashrrev_i32_e32 v13, 31, v13
v_and_or_b32 v14, v14, s52, v15
v_xor_b32_e32 v15, v16, v13
v_sub_u32_e32 v13, v15, v13
v_med3_i32 v13, v13, s50, v11
v_lshl_or_b32 v13, v13, 24, v14
global_store_dword v[6:7], v13, off
v_mov_b32_e32 v13, s35
v_add_co_u32_e32 v8, vcc, s34, v8
v_addc_co_u32_e32 v9, vcc, v9, v13, vcc
v_mov_b32_e32 v13, s31
s_add_i32 s0, s22, 1
v_add_co_u32_e32 v6, vcc, s30, v6
s_cmp_ge_i32 s0, s20
v_addc_co_u32_e32 v7, vcc, v7, v13, vcc
s_cbranch_scc1 65170
s_cmp_lt_i32 s0, s55
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
s_cbranch_scc0 5
v_mov_b32_e32 v14, s37
v_add_co_u32_e32 v13, vcc, s36, v8
v_addc_co_u32_e32 v14, vcc, v9, v14, vcc
global_load_dword v16, v[13:14], off
s_add_i32 s22, s0, 1
s_cmp_ge_i32 s22, s55
s_cbranch_scc1 5
v_mov_b32_e32 v14, s44
v_add_co_u32_e32 v13, vcc, s45, v8
v_addc_co_u32_e32 v14, vcc, v9, v14, vcc
global_load_dword v15, v[13:14], off
s_add_i32 s22, s22, 1
s_cmp_ge_i32 s22, s55
v_mov_b32_e32 v13, 0
v_mov_b32_e32 v14, 0
s_cbranch_scc1 5
v_mov_b32_e32 v14, s42
v_add_co_u32_e32 v17, vcc, s43, v8
v_addc_co_u32_e32 v18, vcc, v9, v14, vcc
global_load_dword v14, v[17:18], off
s_add_i32 s22, s22, 1
s_cmp_ge_i32 s22, s55
s_cbranch_scc1 65363
v_mov_b32_e32 v13, s40
v_add_co_u32_e32 v17, vcc, s41, v8
v_addc_co_u32_e32 v18, vcc, v9, v13, vcc
global_load_dword v13, v[17:18], off
s_branch 65357
s_endpgm
