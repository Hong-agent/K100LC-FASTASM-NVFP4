.text
k__Z12quant_rows_kPjPfPKfiiiii:
s_load_dwordx4 s[0:3], s[4:5], 0x18
s_load_dword s12, s[4:5], 0x28
s_load_dwordx4 s[8:11], s[4:5], 0x0
s_load_dwordx2 s[14:15], s[4:5], 0x10
s_ashr_i32 s7, s6, 31
s_waitcnt lgkmcnt(0)
v_mad_i64_i32 v[2:3], s[16:17], s1, v0, 0
s_ashr_i32 s13, s12, 31
s_cmp_gt_i32 s1, 0
s_mul_hi_i32 s5, s3, s6
s_mul_i32 s4, s3, s6
v_mov_b32_e32 v1, 0
s_cselect_b64 s[16:17], -1, 0
s_cmp_lt_i32 s1, 1
s_mov_b32 s18, 0
s_cbranch_scc1 66
s_cmp_lt_u32 s1, 4
s_cbranch_scc1 33
s_and_b32 s18, s1, -4
s_lshl_b64 s[20:21], s[4:5], 2
s_lshl_b64 s[22:23], s[12:13], 2
s_add_u32 s3, s14, s22
s_addc_u32 s19, s15, s23
v_lshlrev_b64 v[4:5], 2, v[2:3]
s_add_u32 s3, s3, s20
s_addc_u32 s19, s19, s21
v_mov_b32_e32 v1, s19
v_add_co_u32_e32 v4, vcc, s3, v4
v_addc_co_u32_e32 v1, vcc, v1, v5, vcc
v_add_co_u32_e32 v4, vcc, 8, v4
v_addc_co_u32_e32 v5, vcc, 0, v1, vcc
s_mov_b32 s3, 0
v_mov_b32_e32 v1, 0
global_load_dwordx4 v[6:9], v[4:5], off offset:-8
s_add_i32 s3, s3, 4
v_add_co_u32_e32 v4, vcc, 16, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_eq_u32 s18, s3
s_waitcnt vmcnt(0)
v_max3_f32 v1, v1, |v6|, |v7|
v_max3_f32 v1, v1, |v8|, |v9|
s_cbranch_scc0 65524
s_and_b32 s3, s1, 3
s_cmp_eq_u32 s3, 0
s_mov_b32 s19, 0
s_cbranch_scc0 6
s_branch 31
v_mov_b32_e32 v1, 0
s_and_b32 s3, s1, 3
s_cmp_eq_u32 s3, 0
s_mov_b32 s19, 0
s_cbranch_scc1 26
s_lshl_b64 s[20:21], s[4:5], 2
s_lshl_b64 s[22:23], s[12:13], 2
s_lshl_b64 s[18:19], s[18:19], 2
s_add_u32 s18, s14, s18
s_addc_u32 s19, s15, s19
s_add_u32 s18, s18, s22
s_addc_u32 s19, s19, s23
v_lshlrev_b64 v[4:5], 2, v[2:3]
s_add_u32 s18, s18, s20
s_addc_u32 s19, s19, s21
v_mov_b32_e32 v6, s19
v_add_co_u32_e32 v4, vcc, s18, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_load_dword v6, v[4:5], off
v_max_f32_e32 v1, v1, v1
v_add_co_u32_e32 v4, vcc, 4, v4
s_add_i32 s3, s3, -1
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_cmp_lg_u32 s3, 0
s_waitcnt vmcnt(0)
v_max_f32_e64 v6, |v6|, |v6|
v_max_f32_e32 v1, v1, v6
s_cbranch_scc1 65524
s_mov_b32 s20, 0x40e00000
v_div_scale_f32 v4, s[18:19], s20, s20, v1
v_div_scale_f32 v5, vcc, v1, s20, v1
s_mov_b32 s3, 0
v_rcp_f32_e32 v6, v4
v_fma_f32 v7, -v4, v6, 1.0
v_fmac_f32_e32 v6, v7, v6
v_mul_f32_e32 v7, v5, v6
v_fma_f32 v8, -v4, v7, v5
v_fmac_f32_e32 v7, v8, v6
v_fma_f32 v4, -v4, v7, v5
v_div_fmas_f32 v8, v4, v6, v7
v_mov_b32_e32 v4, s6
v_mov_b32_e32 v5, s7
v_mad_i64_i32 v[4:5], s[18:19], s2, v0, v[4:5]
v_mov_b32_e32 v7, s11
v_lshlrev_b64 v[4:5], 2, v[4:5]
v_add_co_u32_e32 v6, vcc, s10, v4
v_addc_co_u32_e32 v7, vcc, v7, v5, vcc
v_cmp_lt_f32_e32 vcc, 0, v1
v_div_fixup_f32 v4, v8, s20, v1
v_cndmask_b32_e32 v4, 1.0, v4, vcc
s_andn2_b64 vcc, exec, s[16:17]
global_store_dword v[6:7], v4, off
s_cbranch_vccnz 321
s_ashr_i32 s2, s0, 31
v_mul_lo_u32 v0, v0, s1
s_lshr_b32 s2, s2, 29
s_add_i32 s0, s0, s2
s_ashr_i32 s0, s0, 3
s_mul_hi_i32 s7, s0, s6
s_mul_i32 s6, s0, s6
v_ashrrev_i32_e32 v1, 31, v0
s_lshl_b64 s[6:7], s[6:7], 2
v_lshrrev_b64 v[0:1], 1, v[0:1]
s_add_u32 s0, s8, s6
s_addc_u32 s2, s9, s7
v_and_b32_e32 v0, -4, v0
s_lshl_b64 s[4:5], s[4:5], 2
v_add_co_u32_e32 v0, vcc, s0, v0
s_add_u32 s0, s14, s4
v_mov_b32_e32 v5, s2
s_addc_u32 s2, s15, s5
s_lshl_b64 s[4:5], s[12:13], 2
s_add_u32 s0, s0, s4
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_addc_co_u32_e32 v1, vcc, v5, v1, vcc
s_addc_u32 s2, s2, s5
v_mov_b32_e32 v5, s2
v_add_co_u32_e32 v2, vcc, s0, v2
v_addc_co_u32_e32 v3, vcc, v5, v3, vcc
s_mov_b32 s0, 0x2f800000
s_mov_b32 s2, 0xcf800000
s_mov_b32 s4, 0xf000
global_load_dword v9, v[2:3], off
s_add_i32 s3, s3, 8
s_cmp_lt_i32 s3, s1
s_waitcnt vmcnt(0)
v_div_scale_f32 v5, s[6:7], v4, v4, v9
v_div_scale_f32 v6, vcc, v9, v4, v9
v_rcp_f32_e32 v10, v5
v_fma_f32 v7, -v5, v10, 1.0
v_fmac_f32_e32 v10, v7, v10
v_mul_f32_e32 v11, v6, v10
v_fma_f32 v7, -v5, v11, v6
v_fmac_f32_e32 v11, v7, v10
v_fma_f32 v12, -v5, v11, v6
global_load_dwordx4 v[5:8], v[2:3], off offset:4
v_div_fmas_f32 v10, v12, v10, v11
v_div_fixup_f32 v9, v10, v4, v9
v_rndne_f32_e32 v9, v9
v_mul_f32_e64 v10, |v9|, s0
v_floor_f32_e32 v10, v10
v_fma_f32 v10, v10, s2, |v9|
v_cvt_u32_f32_e32 v10, v10
v_ashrrev_i32_e32 v9, 31, v9
v_xor_b32_e32 v10, v10, v9
v_sub_u32_e32 v9, v10, v9
v_med3_i32 v9, v9, -8, 7
v_and_b32_e32 v9, 15, v9
s_waitcnt vmcnt(0)
v_div_scale_f32 v11, s[6:7], v4, v4, v5
s_nop 0
v_rcp_f32_e32 v12, v11
v_fma_f32 v13, -v11, v12, 1.0
v_fmac_f32_e32 v12, v13, v12
v_div_scale_f32 v13, vcc, v5, v4, v5
v_mul_f32_e32 v14, v13, v12
v_fma_f32 v15, -v11, v14, v13
v_fmac_f32_e32 v14, v15, v12
v_fma_f32 v11, -v11, v14, v13
v_div_fmas_f32 v11, v11, v12, v14
v_div_scale_f32 v12, s[6:7], v4, v4, v6
v_div_fixup_f32 v11, v11, v4, v5
v_rcp_f32_e32 v13, v12
v_rndne_f32_e32 v10, v11
v_mul_f32_e64 v11, |v10|, s0
v_floor_f32_e32 v11, v11
v_fma_f32 v14, -v12, v13, 1.0
v_fmac_f32_e32 v13, v14, v13
v_div_scale_f32 v14, vcc, v6, v4, v6
v_fma_f32 v11, v11, s2, |v10|
v_cvt_u32_f32_e32 v11, v11
v_ashrrev_i32_e32 v10, 31, v10
v_xor_b32_e32 v11, v11, v10
v_sub_u32_e32 v10, v11, v10
v_med3_i32 v10, v10, -8, 7
v_lshlrev_b32_e32 v10, 4, v10
v_and_b32_e32 v10, 0xf0, v10
v_mul_f32_e32 v15, v14, v13
v_fma_f32 v16, -v12, v15, v14
v_fmac_f32_e32 v15, v16, v13
v_fma_f32 v12, -v12, v15, v14
v_div_fmas_f32 v12, v12, v13, v15
v_div_scale_f32 v13, s[6:7], v4, v4, v7
v_div_fixup_f32 v12, v12, v4, v6
v_rcp_f32_e32 v14, v13
v_rndne_f32_e32 v11, v12
v_mul_f32_e64 v12, |v11|, s0
v_floor_f32_e32 v12, v12
v_fma_f32 v15, -v13, v14, 1.0
v_fmac_f32_e32 v14, v15, v14
v_div_scale_f32 v15, vcc, v7, v4, v7
v_fma_f32 v12, v12, s2, |v11|
v_cvt_u32_f32_e32 v12, v12
v_ashrrev_i32_e32 v11, 31, v11
v_xor_b32_e32 v12, v12, v11
v_sub_u32_e32 v11, v12, v11
v_med3_i32 v11, v11, -8, 7
v_lshlrev_b32_e32 v11, 8, v11
v_and_b32_e32 v11, 0xf00, v11
v_mul_f32_e32 v16, v15, v14
v_fma_f32 v17, -v13, v16, v15
v_fmac_f32_e32 v16, v17, v14
v_fma_f32 v13, -v13, v16, v15
v_div_fmas_f32 v13, v13, v14, v16
v_div_scale_f32 v14, s[6:7], v4, v4, v8
v_div_fixup_f32 v13, v13, v4, v7
global_load_dwordx3 v[5:7], v[2:3], off offset:20
v_rcp_f32_e32 v15, v14
v_rndne_f32_e32 v12, v13
v_mul_f32_e64 v13, |v12|, s0
v_floor_f32_e32 v13, v13
v_fma_f32 v16, -v14, v15, 1.0
v_fmac_f32_e32 v15, v16, v15
v_div_scale_f32 v16, vcc, v8, v4, v8
v_fma_f32 v13, v13, s2, |v12|
v_cvt_u32_f32_e32 v13, v13
v_ashrrev_i32_e32 v12, 31, v12
v_xor_b32_e32 v13, v13, v12
v_sub_u32_e32 v12, v13, v12
v_med3_i32 v12, v12, -8, 7
v_lshlrev_b32_e32 v12, 12, v12
v_and_or_b32 v10, v12, s4, v10
v_mul_f32_e32 v17, v16, v15
v_fma_f32 v18, -v14, v17, v16
v_fmac_f32_e32 v17, v18, v15
v_fma_f32 v14, -v14, v17, v16
v_div_fmas_f32 v14, v14, v15, v17
v_div_fixup_f32 v8, v14, v4, v8
v_rndne_f32_e32 v8, v8
v_mul_f32_e64 v13, |v8|, s0
v_floor_f32_e32 v13, v13
v_fma_f32 v13, v13, s2, |v8|
v_cvt_u32_f32_e32 v13, v13
v_ashrrev_i32_e32 v8, 31, v8
v_xor_b32_e32 v13, v13, v8
v_sub_u32_e32 v8, v13, v8
v_med3_i32 v8, v8, -8, 7
v_lshlrev_b32_e32 v8, 16, v8
v_and_b32_e32 v8, 0xf0000, v8
v_or3_b32 v8, v8, v11, v10
s_waitcnt vmcnt(0)
v_div_scale_f32 v14, s[6:7], v4, v4, v5
s_nop 0
v_rcp_f32_e32 v15, v14
v_fma_f32 v16, -v14, v15, 1.0
v_fmac_f32_e32 v15, v16, v15
v_div_scale_f32 v16, vcc, v5, v4, v5
v_mul_f32_e32 v17, v16, v15
v_fma_f32 v18, -v14, v17, v16
v_fmac_f32_e32 v17, v18, v15
v_fma_f32 v14, -v14, v17, v16
v_div_fmas_f32 v14, v14, v15, v17
v_div_scale_f32 v15, s[6:7], v4, v4, v6
v_div_fixup_f32 v5, v14, v4, v5
v_rcp_f32_e32 v16, v15
v_rndne_f32_e32 v5, v5
v_mul_f32_e64 v13, |v5|, s0
v_floor_f32_e32 v13, v13
v_fma_f32 v17, -v15, v16, 1.0
v_fmac_f32_e32 v16, v17, v16
v_div_scale_f32 v17, vcc, v6, v4, v6
v_fma_f32 v13, v13, s2, |v5|
v_cvt_u32_f32_e32 v13, v13
v_ashrrev_i32_e32 v5, 31, v5
v_xor_b32_e32 v13, v13, v5
v_sub_u32_e32 v5, v13, v5
v_med3_i32 v5, v5, -8, 7
v_lshlrev_b32_e32 v5, 20, v5
v_and_b32_e32 v5, 0xf00000, v5
v_mul_f32_e32 v18, v17, v16
v_fma_f32 v19, -v15, v18, v17
v_fmac_f32_e32 v18, v19, v16
v_fma_f32 v15, -v15, v18, v17
v_div_fmas_f32 v15, v15, v16, v18
v_div_scale_f32 v16, s[6:7], v4, v4, v7
v_div_fixup_f32 v6, v15, v4, v6
v_rcp_f32_e32 v17, v16
v_rndne_f32_e32 v6, v6
v_mul_f32_e64 v13, |v6|, s0
v_floor_f32_e32 v13, v13
v_fma_f32 v18, -v16, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_div_scale_f32 v18, vcc, v7, v4, v7
v_fma_f32 v13, v13, s2, |v6|
v_cvt_u32_f32_e32 v13, v13
v_ashrrev_i32_e32 v6, 31, v6
v_xor_b32_e32 v13, v13, v6
v_sub_u32_e32 v6, v13, v6
v_med3_i32 v6, v6, -8, 7
v_lshlrev_b32_e32 v6, 24, v6
v_and_b32_e32 v6, 0xf000000, v6
v_or3_b32 v5, v5, v9, v6
v_mul_f32_e32 v19, v18, v17
v_fma_f32 v20, -v16, v19, v18
v_fmac_f32_e32 v19, v20, v17
v_fma_f32 v16, -v16, v19, v18
v_div_fmas_f32 v16, v16, v17, v19
v_add_co_u32_e32 v2, vcc, 32, v2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_div_fixup_f32 v7, v16, v4, v7
v_rndne_f32_e32 v7, v7
v_mul_f32_e64 v12, |v7|, s0
v_floor_f32_e32 v12, v12
v_fma_f32 v12, v12, s2, |v7|
v_cvt_u32_f32_e32 v12, v12
v_ashrrev_i32_e32 v7, 31, v7
v_xor_b32_e32 v12, v12, v7
v_sub_u32_e32 v7, v12, v7
v_med3_i32 v7, v7, -8, 7
v_lshlrev_b32_e32 v7, 28, v7
v_or3_b32 v5, v5, v7, v8
global_store_dword v[0:1], v5, off
v_add_co_u32_e32 v0, vcc, 4, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_cbranch_scc1 65250
s_endpgm
