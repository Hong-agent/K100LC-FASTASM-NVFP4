.text
k__Z15quant_rows_a8_kPjS_PfS0_PKfiiiii:
s_load_dwordx4 s[16:19], s[4:5], 0x28
s_load_dwordx2 s[2:3], s[4:5], 0x20
s_load_dword s0, s[4:5], 0x38
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_ashr_i32 s7, s6, 31
s_waitcnt lgkmcnt(0)
v_mad_i64_i32 v[4:5], s[20:21], s17, v0, 0
s_ashr_i32 s1, s0, 31
s_cmp_gt_i32 s17, 0
s_mul_hi_i32 s5, s19, s6
s_mul_i32 s4, s19, s6
v_mov_b32_e32 v3, 0
s_cselect_b64 s[20:21], -1, 0
s_cmp_lt_i32 s17, 1
s_mov_b32 s22, 0
s_cbranch_scc1 66
s_cmp_lt_u32 s17, 4
s_cbranch_scc1 33
s_and_b32 s22, s17, -4
s_lshl_b64 s[24:25], s[4:5], 2
s_lshl_b64 s[26:27], s[0:1], 2
s_add_u32 s19, s2, s26
s_addc_u32 s23, s3, s27
v_lshlrev_b64 v[1:2], 2, v[4:5]
s_add_u32 s19, s19, s24
s_addc_u32 s23, s23, s25
v_mov_b32_e32 v3, s23
v_add_co_u32_e32 v1, vcc, s19, v1
v_addc_co_u32_e32 v2, vcc, v3, v2, vcc
v_add_co_u32_e32 v1, vcc, 8, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_mov_b32 s19, 0
v_mov_b32_e32 v3, 0
global_load_dwordx4 v[6:9], v[1:2], off offset:-8
s_add_i32 s19, s19, 4
v_add_co_u32_e32 v1, vcc, 16, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_cmp_eq_u32 s22, s19
s_waitcnt vmcnt(0)
v_max3_f32 v3, v3, |v6|, |v7|
v_max3_f32 v3, v3, |v8|, |v9|
s_cbranch_scc0 65524
s_and_b32 s19, s17, 3
s_cmp_eq_u32 s19, 0
s_mov_b32 s23, 0
s_cbranch_scc0 6
s_branch 31
v_mov_b32_e32 v3, 0
s_and_b32 s19, s17, 3
s_cmp_eq_u32 s19, 0
s_mov_b32 s23, 0
s_cbranch_scc1 26
s_lshl_b64 s[24:25], s[4:5], 2
s_lshl_b64 s[26:27], s[0:1], 2
s_lshl_b64 s[22:23], s[22:23], 2
s_add_u32 s22, s2, s22
s_addc_u32 s23, s3, s23
s_add_u32 s22, s22, s26
s_addc_u32 s23, s23, s27
v_lshlrev_b64 v[1:2], 2, v[4:5]
s_add_u32 s22, s22, s24
s_addc_u32 s23, s23, s25
v_mov_b32_e32 v6, s23
v_add_co_u32_e32 v1, vcc, s22, v1
v_addc_co_u32_e32 v2, vcc, v6, v2, vcc
global_load_dword v6, v[1:2], off
v_max_f32_e32 v3, v3, v3
v_add_co_u32_e32 v1, vcc, 4, v1
s_add_i32 s19, s19, -1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_cmp_lg_u32 s19, 0
s_waitcnt vmcnt(0)
v_max_f32_e64 v6, |v6|, |v6|
v_max_f32_e32 v3, v3, v6
s_cbranch_scc1 65524
s_mov_b32 s24, 0x42ee0000
v_div_scale_f32 v6, s[22:23], s24, s24, v3
v_div_scale_f32 v7, vcc, v3, s24, v3
v_mov_b32_e32 v1, s6
v_mov_b32_e32 v2, s7
v_mad_i64_i32 v[1:2], s[22:23], s18, v0, v[1:2]
s_mov_b32 s19, 0
v_lshlrev_b64 v[1:2], 2, v[1:2]
v_rcp_f32_e32 v8, v6
v_fma_f32 v9, -v6, v8, 1.0
v_fmac_f32_e32 v8, v9, v8
v_mul_f32_e32 v9, v7, v8
v_fma_f32 v10, -v6, v9, v7
v_fmac_f32_e32 v9, v10, v8
v_fma_f32 v6, -v6, v9, v7
v_div_fmas_f32 v6, v6, v8, v9
v_mov_b32_e32 v8, s13
v_add_co_u32_e32 v7, vcc, s12, v1
v_addc_co_u32_e32 v8, vcc, v8, v2, vcc
v_mov_b32_e32 v9, s15
v_add_co_u32_e32 v1, vcc, s14, v1
v_addc_co_u32_e32 v2, vcc, v9, v2, vcc
v_cmp_lt_f32_e32 vcc, 0, v3
v_div_fixup_f32 v6, v6, s24, v3
v_cndmask_b32_e32 v6, 1.0, v6, vcc
v_mul_f32_e32 v3, 0x41800000, v6
s_andn2_b64 vcc, exec, s[20:21]
global_store_dword v[7:8], v6, off
global_store_dword v[1:2], v3, off
s_cbranch_vccnz 380
s_ashr_i32 s7, s16, 31
s_lshr_b32 s7, s7, 29
s_add_i32 s7, s16, s7
v_mul_lo_u32 v0, v0, s17
s_ashr_i32 s12, s7, 3
s_mul_hi_i32 s7, s12, s6
s_mul_i32 s6, s12, s6
s_lshl_b64 s[6:7], s[6:7], 2
s_add_u32 s8, s8, s6
v_ashrrev_i32_e32 v1, 31, v0
v_lshrrev_b64 v[2:3], 1, v[0:1]
s_addc_u32 s9, s9, s7
s_add_u32 s6, s10, s6
v_and_b32_e32 v2, -4, v2
s_addc_u32 s7, s11, s7
s_lshl_b64 s[4:5], s[4:5], 2
v_mov_b32_e32 v1, s9
v_add_co_u32_e32 v0, vcc, s8, v2
s_add_u32 s2, s2, s4
v_addc_co_u32_e32 v1, vcc, v1, v3, vcc
s_addc_u32 s3, s3, s5
s_lshl_b64 s[0:1], s[0:1], 2
v_mov_b32_e32 v7, s7
v_add_co_u32_e32 v2, vcc, s6, v2
s_add_u32 s0, s2, s0
v_lshlrev_b64 v[4:5], 2, v[4:5]
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
s_addc_u32 s1, s3, s1
v_mov_b32_e32 v7, s1
v_add_co_u32_e32 v4, vcc, s0, v4
v_addc_co_u32_e32 v5, vcc, v7, v5, vcc
s_mov_b32 s4, 0x2f800000
s_mov_b32 s5, 0xcf800000
s_movk_i32 s6, 0xff80
s_movk_i32 s7, 0xf0
s_movk_i32 s8, 0x80
s_movk_i32 s9, 0x800
s_mov_b32 s10, 0xf0000
s_mov_b32 s11, 0x800000
s_brev_b32 s12, 16
global_load_dwordx2 v[11:12], v[4:5], off
global_load_dwordx4 v[7:10], v[4:5], off offset:8
s_add_i32 s19, s19, 8
s_cmp_lt_i32 s19, s17
s_waitcnt vmcnt(1)
v_div_scale_f32 v13, s[0:1], v6, v6, v11
v_div_scale_f32 v14, vcc, v11, v6, v11
v_div_scale_f32 v15, s[0:1], v6, v6, v12
s_waitcnt vmcnt(0)
v_div_scale_f32 v16, s[0:1], v6, v6, v7
v_rcp_f32_e32 v17, v13
v_fma_f32 v18, -v13, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v14, v17
v_fma_f32 v19, -v13, v18, v14
v_fmac_f32_e32 v18, v19, v17
v_div_scale_f32 v19, s[0:1], v12, v6, v12
v_fma_f32 v13, -v13, v18, v14
v_rcp_f32_e32 v14, v15
v_div_fmas_f32 v13, v13, v17, v18
v_rcp_f32_e32 v17, v16
s_mov_b64 vcc, s[0:1]
v_fma_f32 v18, -v15, v14, 1.0
v_fmac_f32_e32 v14, v18, v14
v_fma_f32 v18, -v16, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v19, v14
v_fma_f32 v20, -v15, v18, v19
v_fmac_f32_e32 v18, v20, v14
v_fma_f32 v15, -v15, v18, v19
v_div_scale_f32 v19, s[2:3], v7, v6, v7
v_div_fmas_f32 v14, v15, v14, v18
s_mov_b64 vcc, s[2:3]
v_div_fixup_f32 v11, v13, v6, v11
v_rndne_f32_e32 v11, v11
v_mov_b32_e32 v13, 0x8000
v_mul_f32_e32 v15, v19, v17
v_fma_f32 v18, -v16, v15, v19
v_fmac_f32_e32 v15, v18, v17
v_div_scale_f32 v18, s[0:1], v6, v6, v8
v_fma_f32 v16, -v16, v15, v19
v_div_scale_f32 v19, s[0:1], v8, v6, v8
v_div_fmas_f32 v15, v16, v17, v15
s_mov_b64 vcc, s[0:1]
v_div_fixup_f32 v12, v14, v6, v12
v_rndne_f32_e32 v12, v12
v_mov_b32_e32 v14, 0x80000
v_rcp_f32_e32 v16, v18
v_fma_f32 v17, -v18, v16, 1.0
v_fmac_f32_e32 v16, v17, v16
v_mul_f32_e32 v17, v19, v16
v_fma_f32 v20, -v18, v17, v19
v_fmac_f32_e32 v17, v20, v16
v_fma_f32 v18, -v18, v17, v19
v_div_fmas_f32 v16, v18, v16, v17
v_div_scale_f32 v19, s[2:3], v6, v6, v9
v_div_fixup_f32 v15, v15, v6, v7
v_rndne_f32_e32 v15, v15
v_div_fixup_f32 v16, v16, v6, v8
global_load_dwordx2 v[7:8], v[4:5], off offset:24
v_rcp_f32_e32 v17, v19
v_rndne_f32_e32 v16, v16
v_fma_f32 v18, -v19, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_div_scale_f32 v18, vcc, v9, v6, v9
v_mul_f32_e32 v20, v18, v17
v_fma_f32 v21, -v19, v20, v18
v_fmac_f32_e32 v20, v21, v17
v_fma_f32 v18, -v19, v20, v18
v_div_fmas_f32 v17, v18, v17, v20
v_div_scale_f32 v18, s[0:1], v6, v6, v10
v_div_fixup_f32 v9, v17, v6, v9
v_rcp_f32_e32 v19, v18
v_rndne_f32_e32 v9, v9
v_fma_f32 v20, -v18, v19, 1.0
v_fmac_f32_e32 v19, v20, v19
v_div_scale_f32 v20, vcc, v10, v6, v10
v_mul_f32_e32 v21, v20, v19
v_fma_f32 v22, -v18, v21, v20
v_fmac_f32_e32 v21, v22, v19
v_fma_f32 v18, -v18, v21, v20
v_div_fmas_f32 v18, v18, v19, v21
s_waitcnt vmcnt(0)
v_div_scale_f32 v17, s[0:1], v6, v6, v7
v_div_fixup_f32 v10, v18, v6, v10
v_rndne_f32_e32 v10, v10
v_rcp_f32_e32 v18, v17
v_fma_f32 v19, -v17, v18, 1.0
v_fmac_f32_e32 v18, v19, v18
v_div_scale_f32 v19, vcc, v7, v6, v7
v_mul_f32_e32 v20, v19, v18
v_fma_f32 v21, -v17, v20, v19
v_fmac_f32_e32 v20, v21, v18
v_fma_f32 v17, -v17, v20, v19
v_div_fmas_f32 v17, v17, v18, v20
v_div_scale_f32 v18, s[0:1], v6, v6, v8
v_div_fixup_f32 v7, v17, v6, v7
v_rcp_f32_e32 v19, v18
v_mul_f32_e64 v17, |v11|, s4
v_floor_f32_e32 v17, v17
v_rndne_f32_e32 v7, v7
v_fma_f32 v20, -v18, v19, 1.0
v_fmac_f32_e32 v19, v20, v19
v_div_scale_f32 v20, vcc, v8, v6, v8
v_mul_f32_e32 v21, v20, v19
v_fma_f32 v22, -v18, v21, v20
v_fmac_f32_e32 v21, v22, v19
v_fma_f32 v18, -v18, v21, v20
v_div_fmas_f32 v18, v18, v19, v21
v_mov_b32_e32 v19, 0x77
v_add_co_u32_e32 v4, vcc, 32, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_div_fixup_f32 v8, v18, v6, v8
v_ashrrev_i32_e32 v18, 31, v11
v_fma_f32 v11, v17, s5, |v11|
v_mul_f32_e64 v17, |v12|, s4
v_floor_f32_e32 v17, v17
v_fma_f32 v17, v17, s5, |v12|
v_cvt_u32_f32_e32 v11, v11
v_cvt_u32_f32_e32 v17, v17
v_ashrrev_i32_e32 v12, 31, v12
v_rndne_f32_e32 v8, v8
v_xor_b32_e32 v11, v11, v18
v_xor_b32_e32 v17, v17, v12
v_sub_u32_e32 v11, v11, v18
v_mul_f32_e64 v18, |v15|, s4
v_sub_u32_e32 v12, v17, v12
v_mul_f32_e64 v17, |v16|, s4
v_floor_f32_e32 v18, v18
v_floor_f32_e32 v17, v17
v_fma_f32 v18, v18, s5, |v15|
v_fma_f32 v17, v17, s5, |v16|
v_cvt_u32_f32_e32 v18, v18
v_cvt_u32_f32_e32 v17, v17
v_ashrrev_i32_e32 v15, 31, v15
v_ashrrev_i32_e32 v16, 31, v16
v_med3_i32 v11, v11, s6, v19
v_xor_b32_e32 v18, v18, v15
v_med3_i32 v12, v12, s6, v19
v_xor_b32_e32 v17, v17, v16
v_sub_u32_e32 v15, v18, v15
v_and_b32_e32 v18, 15, v11
v_sub_u32_e32 v16, v17, v16
v_lshlrev_b32_e32 v17, 4, v12
v_and_or_b32 v17, v17, s7, v18
v_mul_f32_e64 v18, |v9|, s4
v_floor_f32_e32 v18, v18
v_fma_f32 v18, v18, s5, |v9|
v_cvt_u32_f32_e32 v18, v18
v_ashrrev_i32_e32 v9, 31, v9
v_med3_i32 v15, v15, s6, v19
v_med3_i32 v16, v16, s6, v19
v_xor_b32_e32 v18, v18, v9
v_sub_u32_e32 v9, v18, v9
v_mul_f32_e64 v18, |v10|, s4
v_floor_f32_e32 v18, v18
v_fma_f32 v18, v18, s5, |v10|
v_cvt_u32_f32_e32 v18, v18
v_ashrrev_i32_e32 v10, 31, v10
v_med3_i32 v9, v9, s6, v19
v_lshl_add_u32 v13, v9, 12, v13
v_xor_b32_e32 v18, v18, v10
v_sub_u32_e32 v10, v18, v10
v_mul_f32_e64 v18, |v7|, s4
v_floor_f32_e32 v18, v18
v_fma_f32 v18, v18, s5, |v7|
v_cvt_u32_f32_e32 v18, v18
v_ashrrev_i32_e32 v7, 31, v7
v_med3_i32 v10, v10, s6, v19
v_lshl_add_u32 v14, v10, 16, v14
v_xor_b32_e32 v18, v18, v7
v_sub_u32_e32 v7, v18, v7
v_mul_f32_e64 v18, |v8|, s4
v_floor_f32_e32 v18, v18
v_fma_f32 v18, v18, s5, |v8|
v_cvt_u32_f32_e32 v18, v18
v_ashrrev_i32_e32 v8, 31, v8
v_med3_i32 v7, v7, s6, v19
v_add_u32_e32 v11, 8, v11
v_xor_b32_e32 v18, v18, v8
v_sub_u32_e32 v8, v18, v8
v_lshl_add_u32 v18, v15, 4, s8
v_and_b32_e32 v18, 0xf00, v18
v_and_or_b32 v13, v13, s10, v18
v_lshl_add_u32 v18, v16, 8, s9
v_add_u32_e32 v12, 8, v12
v_and_b32_e32 v18, 0xf000, v18
v_and_b32_e32 v14, 0xf00000, v14
v_med3_i32 v8, v8, s6, v19
v_lshl_add_u32 v19, v7, 20, s11
v_bfe_u32 v11, v11, 4, 4
v_and_b32_e32 v12, 0xf0, v12
v_lshlrev_b32_e32 v7, 24, v7
v_and_b32_e32 v19, 0xf000000, v19
v_or3_b32 v13, v14, v18, v13
v_lshl_add_u32 v14, v8, 24, s12
v_lshlrev_b32_e32 v15, 8, v15
v_lshlrev_b32_e32 v16, 12, v16
v_and_b32_e32 v7, 0xf000000, v7
v_lshlrev_b32_e32 v8, 28, v8
v_and_b32_e32 v14, 0xf0000000, v14
v_or3_b32 v11, v11, v12, v19
v_and_b32_e32 v15, 0xf00, v15
v_and_b32_e32 v16, 0xf000, v16
v_lshlrev_b32_e32 v9, 16, v9
v_lshlrev_b32_e32 v10, 20, v10
v_or3_b32 v7, v17, v7, v8
v_or3_b32 v8, v11, v14, v13
v_and_b32_e32 v9, 0xf0000, v9
v_and_b32_e32 v10, 0xf00000, v10
v_or3_b32 v7, v7, v15, v16
global_store_dword v[0:1], v8, off
v_add_co_u32_e32 v0, vcc, 4, v0
v_or3_b32 v7, v7, v9, v10
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
global_store_dword v[2:3], v7, off
v_add_co_u32_e32 v2, vcc, 4, v2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_cbranch_scc1 65203
s_endpgm
