.text
k__Z13kv_append_k_kPjPfPKfiiiiii:
s_load_dwordx4 s[8:11], s[4:5], 0x20
s_load_dwordx4 s[0:3], s[4:5], 0x0
s_load_dwordx2 s[12:13], s[4:5], 0x10
s_ashr_i32 s15, s7, 31
v_mov_b32_e32 v1, 0
s_waitcnt lgkmcnt(0)
s_mul_hi_i32 s14, s8, s6
s_mul_i32 s8, s8, s6
s_add_u32 s19, s8, s7
s_addc_u32 s21, s14, s15
s_ashr_i32 s22, s9, 31
s_cmp_gt_i32 s10, 0
s_mov_b32 s18, 0
s_cselect_b64 s[16:17], -1, 0
s_cmp_lt_i32 s10, 1
s_mul_i32 s8, s19, s22
s_mul_hi_u32 s20, s19, s9
s_mul_i32 s21, s21, s9
s_mul_i32 s14, s19, s9
v_mov_b32_e32 v4, v1
s_cbranch_scc1 68
s_cmp_lt_u32 s10, 4
s_cbranch_scc1 34
v_mad_i64_i32 v[2:3], s[24:25], s10, v0, 0
s_add_i32 s15, s20, s8
s_add_i32 s15, s15, s21
s_and_b32 s18, s10, -4
s_lshl_b64 s[24:25], s[14:15], 2
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_add_u32 s15, s12, s24
s_addc_u32 s19, s13, s25
v_mov_b32_e32 v4, s19
v_add_co_u32_e32 v2, vcc, s15, v2
v_addc_co_u32_e32 v3, vcc, v4, v3, vcc
v_add_co_u32_e32 v2, vcc, 8, v2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_mov_b32 s15, 0
v_mov_b32_e32 v4, 0
global_load_dwordx4 v[5:8], v[2:3], off offset:-8
s_add_i32 s15, s15, 4
v_add_co_u32_e32 v2, vcc, 16, v2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_cmp_eq_u32 s18, s15
s_waitcnt vmcnt(0)
v_max3_f32 v4, v4, |v5|, |v6|
v_max3_f32 v4, v4, |v7|, |v8|
s_cbranch_scc0 65524
s_and_b32 s23, s10, 3
s_cmp_eq_u32 s23, 0
s_mov_b32 s19, 0
s_cbranch_scc0 6
s_branch 32
v_mov_b32_e32 v4, 0
s_and_b32 s23, s10, 3
s_cmp_eq_u32 s23, 0
s_mov_b32 s19, 0
s_cbranch_scc1 27
s_add_i32 s15, s20, s8
v_mad_i64_i32 v[2:3], s[24:25], s10, v0, 0
s_add_i32 s15, s15, s21
s_lshl_b64 s[24:25], s[14:15], 2
s_lshl_b64 s[18:19], s[18:19], 2
s_add_u32 s15, s12, s18
s_addc_u32 s18, s13, s19
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_add_u32 s15, s15, s24
s_addc_u32 s18, s18, s25
v_mov_b32_e32 v5, s18
v_add_co_u32_e32 v2, vcc, s15, v2
v_addc_co_u32_e32 v3, vcc, v5, v3, vcc
global_load_dword v5, v[2:3], off
v_max_f32_e32 v4, v4, v4
v_add_co_u32_e32 v2, vcc, 4, v2
s_add_i32 s23, s23, -1
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_cmp_lg_u32 s23, 0
s_waitcnt vmcnt(0)
v_max_f32_e64 v5, |v5|, |v5|
v_max_f32_e32 v4, v4, v5
s_cbranch_scc1 65524
s_mov_b32 s15, 0x42fe0000
v_div_scale_f32 v2, s[18:19], s15, s15, v4
s_ashr_i32 s18, s10, 31
s_add_i32 s19, s10, s18
v_div_scale_f32 v3, vcc, v4, s15, v4
s_xor_b32 s19, s19, s18
v_cvt_f32_u32_e32 v5, s19
s_load_dword s4, s[4:5], 0x18
s_sub_i32 s23, 0, s19
s_add_i32 s5, s9, s22
v_rcp_iflag_f32_e32 v5, v5
s_xor_b32 s5, s5, s22
s_waitcnt lgkmcnt(0)
s_add_i32 s4, s6, s4
s_xor_b32 s18, s22, s18
v_mul_f32_e32 v5, 0x4f7ffffe, v5
v_cvt_u32_f32_e32 v5, v5
v_rcp_f32_e32 v6, v2
v_readfirstlane_b32 s6, v5
v_fma_f32 v5, -v2, v6, 1.0
v_fmac_f32_e32 v6, v5, v6
v_mul_f32_e32 v5, v3, v6
v_fma_f32 v7, -v2, v5, v3
v_fmac_f32_e32 v5, v7, v6
s_mul_i32 s23, s23, s6
v_fma_f32 v2, -v2, v5, v3
s_mul_hi_u32 s23, s6, s23
v_div_fmas_f32 v3, v2, v6, v5
s_add_i32 s6, s6, s23
s_mul_hi_u32 s6, s5, s6
s_mul_i32 s23, s6, s19
s_sub_i32 s5, s5, s23
s_add_i32 s23, s6, 1
s_sub_i32 s24, s5, s19
s_cmp_ge_u32 s5, s19
s_cselect_b32 s6, s23, s6
s_cselect_b32 s5, s24, s5
s_add_i32 s23, s6, 1
s_cmp_ge_u32 s5, s19
s_cselect_b32 s5, s23, s6
s_xor_b32 s5, s5, s18
s_sub_i32 s5, s5, s18
v_mov_b32_e32 v2, s7
v_mad_i64_i32 v[1:2], s[18:19], s5, v2, v[0:1]
v_div_fixup_f32 v7, v3, s15, v4
s_ashr_i32 s5, s4, 31
v_mul_lo_u32 v9, v2, s11
v_mov_b32_e32 v2, s4
s_ashr_i32 s6, s11, 31
v_mov_b32_e32 v3, s5
v_mul_lo_u32 v8, v1, s6
v_mad_u64_u32 v[5:6], s[18:19], v1, s11, v[2:3]
v_cmp_lt_f32_e32 vcc, 0, v4
v_cndmask_b32_e32 v2, 1.0, v7, vcc
v_add3_u32 v6, v9, v6, v8
v_lshlrev_b64 v[3:4], 2, v[5:6]
v_mov_b32_e32 v1, s3
v_add_co_u32_e32 v3, vcc, s2, v3
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
s_andn2_b64 vcc, exec, s[16:17]
global_store_dword v[3:4], v2, off
s_cbranch_vccnz 193
s_mul_i32 s3, s11, s7
s_mul_hi_i32 s2, s11, s7
s_add_u32 s4, s3, s4
s_addc_u32 s2, s2, s5
s_lshr_b32 s3, s22, 30
s_add_i32 s3, s9, s3
s_ashr_i32 s5, s3, 2
s_mov_b32 s6, s11
s_ashr_i32 s3, s5, 31
s_mul_i32 s3, s4, s3
s_mul_hi_u32 s6, s4, s5
s_add_i32 s3, s6, s3
s_mul_i32 s2, s2, s5
s_add_i32 s3, s3, s2
s_mul_i32 s2, s4, s5
v_mad_i64_i32 v[0:1], s[4:5], s10, v0, 0
s_lshl_b64 s[2:3], s[2:3], 2
s_add_u32 s0, s0, s2
v_and_b32_e32 v3, -4, v0
s_addc_u32 s1, s1, s3
v_add_co_u32_e32 v3, vcc, s0, v3
s_add_i32 s0, s20, s8
s_add_i32 s15, s0, s21
v_mov_b32_e32 v5, s1
s_lshl_b64 s[0:1], s[14:15], 2
v_ashrrev_i32_e32 v4, 31, v0
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_add_u32 s0, s12, s0
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
s_addc_u32 s1, s13, s1
v_mov_b32_e32 v5, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v5, v1, vcc
v_add_co_u32_e32 v0, vcc, 8, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_mov_b64 s[4:5], 0
s_mov_b32 s6, 0x2f800000
s_mov_b32 s7, 0xcf800000
s_movk_i32 s8, 0xff80
s_mov_b32 s9, 0xc0c0500
global_load_dwordx4 v[5:8], v[0:1], off offset:-8
v_mov_b32_e32 v10, s5
v_add_co_u32_e32 v9, vcc, s4, v3
v_addc_co_u32_e32 v10, vcc, v4, v10, vcc
s_add_u32 s4, s4, 4
s_addc_u32 s5, s5, 0
s_cmp_lt_i32 s4, s10
s_waitcnt vmcnt(0)
v_div_scale_f32 v11, s[0:1], v2, v2, v5
v_div_scale_f32 v12, vcc, v5, v2, v5
v_div_scale_f32 v13, s[0:1], v2, v2, v6
v_div_scale_f32 v14, s[0:1], v2, v2, v7
v_div_scale_f32 v15, s[0:1], v2, v2, v8
v_div_scale_f32 v16, s[0:1], v6, v2, v6
v_rcp_f32_e32 v17, v11
v_fma_f32 v18, -v11, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v12, v17
v_fma_f32 v19, -v11, v18, v12
v_fmac_f32_e32 v18, v19, v17
v_rcp_f32_e32 v19, v13
v_fma_f32 v11, -v11, v18, v12
v_rcp_f32_e32 v12, v14
v_div_fmas_f32 v11, v11, v17, v18
v_rcp_f32_e32 v17, v15
v_fma_f32 v18, -v13, v19, 1.0
v_fmac_f32_e32 v19, v18, v19
v_fma_f32 v18, -v14, v12, 1.0
v_fmac_f32_e32 v12, v18, v12
v_fma_f32 v18, -v15, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v16, v19
v_fma_f32 v20, -v13, v18, v16
v_fmac_f32_e32 v18, v20, v19
v_fma_f32 v13, -v13, v18, v16
v_div_scale_f32 v16, s[2:3], v7, v2, v7
s_mov_b64 vcc, s[0:1]
v_div_fmas_f32 v13, v13, v19, v18
v_add_co_u32_e32 v0, vcc, 16, v0
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_mov_b64 vcc, s[2:3]
v_div_fixup_f32 v5, v11, v2, v5
v_rndne_f32_e32 v5, v5
v_mul_f32_e64 v11, |v5|, s6
v_floor_f32_e32 v11, v11
v_mul_f32_e32 v18, v16, v12
v_fma_f32 v19, -v14, v18, v16
v_fmac_f32_e32 v18, v19, v12
v_div_scale_f32 v19, s[0:1], v8, v2, v8
v_fma_f32 v14, -v14, v18, v16
v_div_fmas_f32 v12, v14, v12, v18
s_mov_b64 vcc, s[0:1]
v_div_fixup_f32 v6, v13, v2, v6
v_rndne_f32_e32 v6, v6
v_ashrrev_i32_e32 v13, 31, v5
v_fma_f32 v5, v11, s7, |v5|
v_cvt_u32_f32_e32 v5, v5
v_mov_b32_e32 v16, 0x7f
v_xor_b32_e32 v5, v5, v13
v_sub_u32_e32 v5, v5, v13
v_med3_i32 v5, v5, s8, v16
v_mul_f32_e32 v20, v19, v17
v_fma_f32 v21, -v15, v20, v19
v_fmac_f32_e32 v20, v21, v17
v_fma_f32 v15, -v15, v20, v19
v_div_fmas_f32 v14, v15, v17, v20
v_div_fixup_f32 v7, v12, v2, v7
v_mul_f32_e64 v12, |v6|, s6
v_rndne_f32_e32 v7, v7
v_floor_f32_e32 v11, v12
v_mul_f32_e64 v12, |v7|, s6
v_ashrrev_i32_e32 v15, 31, v6
v_fma_f32 v6, v11, s7, |v6|
v_floor_f32_e32 v11, v12
v_cvt_u32_f32_e32 v6, v6
v_xor_b32_e32 v6, v6, v15
v_sub_u32_e32 v6, v6, v15
v_med3_i32 v6, v6, s8, v16
v_div_fixup_f32 v8, v14, v2, v8
v_rndne_f32_e32 v8, v8
v_mul_f32_e64 v12, |v8|, s6
v_ashrrev_i32_e32 v14, 31, v7
v_fma_f32 v7, v11, s7, |v7|
v_floor_f32_e32 v11, v12
v_ashrrev_i32_e32 v17, 31, v8
v_cvt_u32_f32_e32 v7, v7
v_fma_f32 v8, v11, s7, |v8|
v_cvt_u32_f32_e32 v8, v8
v_lshlrev_b32_e32 v6, 8, v6
v_xor_b32_e32 v7, v7, v14
v_sub_u32_e32 v7, v7, v14
v_xor_b32_e32 v8, v8, v17
v_med3_i32 v7, v7, s8, v16
v_sub_u32_e32 v8, v8, v17
v_perm_b32 v5, v6, v5, s9
v_lshlrev_b32_e32 v6, 16, v7
v_med3_i32 v7, v8, s8, v16
v_and_b32_e32 v6, 0xff0000, v6
v_lshlrev_b32_e32 v7, 24, v7
v_or3_b32 v5, v5, v6, v7
global_store_dword v[9:10], v5, off
s_cbranch_scc1 65388
s_endpgm
