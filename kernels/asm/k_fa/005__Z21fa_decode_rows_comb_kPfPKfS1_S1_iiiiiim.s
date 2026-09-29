.text
k__Z21fa_decode_rows_comb_kPfPKfS1_S1_iiiiiim:
s_load_dwordx8 s[8:15], s[4:5], 0x10
s_load_dwordx4 s[16:19], s[4:5], 0x0
s_load_dwordx2 s[20:21], s[4:5], 0x30
s_mov_b32 s0, s7
s_waitcnt lgkmcnt(0)
s_add_i32 s1, s7, s12
s_add_i32 s1, s1, 63
s_ashr_i32 s2, s1, 31
s_lshr_b32 s2, s2, 26
s_add_i32 s1, s1, s2
s_ashr_i32 s1, s1, 6
s_max_i32 s7, s15, 1
s_cmp_gt_i32 s15, 0
s_mov_b32 s22, s13
s_cselect_b64 s[2:3], -1, 0
s_cmp_ge_i32 s7, s14
s_cselect_b64 s[12:13], -1, 0
s_mov_b32 s26, s7
s_lshl_b32 s7, s7, 3
s_or_b64 s[12:13], s[2:3], s[12:13]
s_cmp_lt_i32 s1, s7
s_cselect_b64 s[24:25], -1, 0
s_or_b64 s[12:13], s[12:13], s[24:25]
s_andn2_b64 vcc, exec, s[12:13]
s_lshl_b32 s7, s26, 1
s_cbranch_vccnz 65525
s_ashr_i32 s1, s0, 31
s_ashr_i32 s27, s20, 31
s_cmp_lg_u32 s26, 0
s_mul_hi_i32 s13, s22, s0
s_mul_i32 s12, s22, s0
s_cselect_b64 s[2:3], -1, 0
s_cmp_eq_u32 s26, 0
s_mov_b32 s23, 0
s_cbranch_scc1 46
s_ashr_i32 s24, s22, 31
s_ashr_i32 s7, s6, 31
s_cmp_lt_u32 s26, 8
s_cbranch_scc1 45
s_and_b32 s23, s26, -8
s_lshl_b64 s[14:15], s[12:13], 2
s_lshl_b64 s[28:29], s[6:7], 2
s_add_u32 s7, s14, s28
s_addc_u32 s14, s15, s29
s_mul_i32 s15, s7, s27
s_mul_hi_u32 s25, s7, s20
s_add_i32 s15, s25, s15
s_mul_i32 s14, s14, s20
s_add_i32 s15, s15, s14
s_mul_i32 s7, s7, s20
s_add_u32 s7, s7, s8
s_addc_u32 s15, s15, s9
s_add_u32 s14, s7, 28
s_addc_u32 s15, s15, 0
s_mov_b32 s7, 0
v_mov_b32_e32 v5, 0xf149f2ca
s_load_dwordx8 s[36:43], s[14:15], -0x1c
s_add_i32 s7, s7, 8
s_add_u32 s14, s14, 32
s_addc_u32 s15, s15, 0
s_cmp_eq_u32 s23, s7
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s37
v_mov_b32_e32 v2, s39
v_max3_f32 v1, v5, s36, v1
v_mov_b32_e32 v3, s41
v_max3_f32 v1, v1, s38, v2
v_mov_b32_e32 v4, s43
v_max3_f32 v1, v1, s40, v3
v_max3_f32 v5, v1, s42, v4
s_cbranch_scc0 65516
s_and_b32 s7, s26, 7
s_cmp_eq_u32 s7, 0
s_cbranch_scc0 9
s_branch 38
v_mov_b32_e32 v5, 0xf149f2ca
s_branch 35
v_mov_b32_e32 v5, 0xf149f2ca
s_and_b32 s7, s26, 7
s_cmp_eq_u32 s7, 0
s_cbranch_scc1 30
s_mul_i32 s29, s0, s20
s_mul_hi_i32 s14, s0, s20
s_mul_i32 s15, s29, s24
s_mul_hi_u32 s24, s29, s22
s_add_i32 s15, s24, s15
s_mul_i32 s14, s14, s22
s_add_i32 s15, s15, s14
s_mul_i32 s14, s29, s22
s_mul_i32 s28, s20, s6
s_lshl_b64 s[14:15], s[14:15], 2
s_mul_hi_i32 s25, s20, s6
s_add_u32 s22, s28, s23
s_addc_u32 s23, s25, 0
s_lshl_b64 s[22:23], s[22:23], 2
s_add_u32 s14, s14, s22
s_addc_u32 s15, s15, s23
s_add_u32 s14, s8, s14
s_addc_u32 s15, s9, s15
s_load_dword s22, s[14:15], 0x0
s_add_u32 s14, s14, 4
v_max_f32_e32 v1, v5, v5
s_addc_u32 s15, s15, 0
s_add_i32 s7, s7, -1
s_waitcnt lgkmcnt(0)
v_max_f32_e64 v2, s22, s22
s_cmp_lg_u32 s7, 0
v_max_f32_e32 v5, v1, v2
s_cbranch_scc1 65524
s_andn2_b64 vcc, exec, s[2:3]
s_cbranch_vccnz 127
s_ashr_i32 s7, s6, 31
s_cmp_eq_u32 s26, 1
s_cbranch_scc1 127
s_add_u32 s2, s12, s6
s_addc_u32 s3, s13, s7
s_mul_i32 s14, s2, s27
s_mul_hi_u32 s15, s2, s20
s_add_i32 s14, s15, s14
s_mul_i32 s3, s3, s20
s_add_i32 s3, s14, s3
s_mul_i32 s2, s2, s20
s_lshl_b64 s[2:3], s[2:3], 10
s_add_u32 s2, s18, s2
v_lshlrev_b32_e32 v3, 2, v0
s_addc_u32 s3, s19, s3
v_mov_b32_e32 v1, s3
v_add_co_u32_e32 v2, vcc, s2, v3
v_addc_co_u32_e32 v4, vcc, 0, v1, vcc
s_movk_i32 s2, 0x400
v_add_co_u32_e32 v1, vcc, s2, v2
s_lshl_b64 s[2:3], s[12:13], 10
s_lshl_b64 s[14:15], s[6:7], 10
s_add_u32 s2, s2, s14
s_addc_u32 s3, s3, s15
s_mul_i32 s14, s2, s27
s_mul_hi_u32 s15, s2, s20
s_add_i32 s14, s15, s14
s_mul_i32 s3, s3, s20
s_add_i32 s14, s14, s3
s_mul_i32 s2, s2, s20
s_add_u32 s2, s18, s2
v_addc_co_u32_e32 v2, vcc, 0, v4, vcc
s_addc_u32 s3, s19, s14
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v3, vcc, s2, v3
s_lshl_b64 s[2:3], s[12:13], 2
s_lshl_b64 s[14:15], s[6:7], 2
s_add_u32 s2, s2, s14
s_addc_u32 s3, s3, s15
s_mul_i32 s7, s2, s27
s_mul_hi_u32 s14, s2, s20
s_add_i32 s7, s14, s7
s_mul_i32 s3, s3, s20
s_add_i32 s7, s7, s3
s_mul_i32 s2, s2, s20
s_add_u32 s2, s2, 4
s_addc_u32 s3, s7, 0
s_add_u32 s22, s8, s2
s_addc_u32 s23, s9, s3
s_and_b32 s7, s26, -2
s_add_u32 s24, s10, s2
v_addc_co_u32_e32 v4, vcc, 0, v4, vcc
s_addc_u32 s25, s11, s3
s_mov_b64 s[14:15], 0
v_mov_b32_e32 v6, 0
s_mov_b32 s28, 0xc2fc0000
v_mov_b32_e32 v8, 0x1f800000
v_mov_b32_e32 v9, 0x42800000
s_movk_i32 s29, 0x800
v_mov_b32_e32 v7, 0
global_load_dword v10, v[3:4], off
global_load_dword v11, v[1:2], off
s_load_dwordx2 s[2:3], s[22:23], -0x4
s_load_dwordx2 s[30:31], s[24:25], -0x4
v_add_co_u32_e32 v1, vcc, s29, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_add_co_u32_e32 v3, vcc, s29, v3
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v12, s2, v5
v_addc_co_u32_e32 v4, vcc, 0, v4, vcc
v_sub_f32_e32 v13, s3, v5
v_mul_f32_e32 v12, 0x3fb8aa3b, v12
v_mul_f32_e32 v13, 0x3fb8aa3b, v13
v_cmp_gt_f32_e32 vcc, s28, v12
v_cmp_gt_f32_e64 s[2:3], s28, v13
v_cndmask_b32_e32 v16, 0, v9, vcc
v_cndmask_b32_e64 v17, 0, v9, s[2:3]
v_add_f32_e32 v12, v12, v16
v_cndmask_b32_e32 v14, 1.0, v8, vcc
v_add_f32_e32 v13, v13, v17
v_cmp_gt_f32_e32 vcc, s28, v12
v_cndmask_b32_e64 v15, 1.0, v8, s[2:3]
v_cndmask_b32_e32 v16, 0, v9, vcc
v_cmp_gt_f32_e64 s[2:3], s28, v13
v_cndmask_b32_e64 v17, 0, v9, s[2:3]
v_add_f32_e32 v12, v12, v16
v_add_f32_e32 v13, v13, v17
v_exp_f32_e32 v12, v12
s_add_u32 s14, s14, 2
v_exp_f32_e32 v13, v13
s_addc_u32 s15, s15, 0
s_add_u32 s22, s22, 8
v_cndmask_b32_e32 v16, 1.0, v8, vcc
s_addc_u32 s23, s23, 0
v_cndmask_b32_e64 v17, 1.0, v8, s[2:3]
v_mul_f32_e32 v12, v12, v16
s_add_u32 s24, s24, 8
v_mul_f32_e32 v13, v13, v17
v_mul_f32_e32 v12, v14, v12
s_addc_u32 s25, s25, 0
v_mul_f32_e32 v13, v15, v13
v_fmac_f32_e32 v6, s30, v12
s_cmp_eq_u32 s7, s14
v_fmac_f32_e32 v6, s31, v13
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v7, v10, v12
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v7, v11, v13
s_cbranch_scc0 65475
s_bitcmp0_b32 s26, 0
s_cbranch_scc0 9
s_branch 69
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_branch 66
s_mov_b64 s[14:15], 0
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v6, 0
s_bitcmp0_b32 s26, 0
s_cbranch_scc1 61
s_mul_i32 s2, s12, s27
s_mul_hi_u32 s3, s12, s20
s_add_i32 s2, s3, s2
s_mul_i32 s3, s13, s20
s_add_i32 s3, s2, s3
s_mul_i32 s2, s12, s20
s_lshl_b64 s[12:13], s[2:3], 10
s_add_u32 s12, s18, s12
s_addc_u32 s13, s19, s13
s_lshl_b64 s[2:3], s[2:3], 2
s_add_u32 s18, s8, s2
s_addc_u32 s19, s9, s3
s_mul_hi_i32 s7, s20, s6
s_mul_i32 s22, s20, s6
s_add_u32 s20, s10, s2
s_addc_u32 s23, s11, s3
s_add_u32 s2, s22, s14
s_addc_u32 s3, s7, s15
s_lshl_b64 s[8:9], s[2:3], 2
s_add_u32 s10, s18, s8
s_addc_u32 s11, s19, s9
s_lshl_b64 s[2:3], s[2:3], 10
v_lshl_or_b32 v1, v0, 2, s2
v_mov_b32_e32 v2, s3
v_mov_b32_e32 v3, s13
v_add_co_u32_e32 v1, vcc, s12, v1
v_addc_co_u32_e32 v2, vcc, v3, v2, vcc
global_load_dword v1, v[1:2], off
s_load_dword s3, s[10:11], 0x0
s_mov_b32 s7, 0xc2fc0000
v_mov_b32_e32 v3, 0x42800000
v_mov_b32_e32 v2, 0x1f800000
s_add_u32 s2, s20, s8
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v4, s3, v5
v_mul_f32_e32 v4, 0x3fb8aa3b, v4
v_cmp_gt_f32_e32 vcc, s7, v4
v_cndmask_b32_e32 v8, 0, v3, vcc
v_add_f32_e32 v4, v4, v8
v_cndmask_b32_e32 v5, 1.0, v2, vcc
v_cmp_gt_f32_e32 vcc, s7, v4
v_cndmask_b32_e32 v3, 0, v3, vcc
v_add_f32_e32 v3, v4, v3
s_addc_u32 s3, s23, s9
v_exp_f32_e32 v3, v3
s_load_dword s2, s[2:3], 0x0
v_cndmask_b32_e32 v2, 1.0, v2, vcc
v_mul_f32_e32 v2, v3, v2
v_mul_f32_e32 v2, v5, v2
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v6, s2, v2
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v7, v1, v2
v_cmp_lt_f32_e32 vcc, 0, v6
s_cbranch_vccz 39
v_div_scale_f32 v1, s[2:3], v6, v6, v7
v_div_scale_f32 v2, vcc, v7, v6, v7
s_load_dwordx2 s[2:3], s[4:5], 0x38
s_waitcnt lgkmcnt(0)
s_mul_i32 s1, s1, s2
v_rcp_f32_e32 v3, v1
v_fma_f32 v4, -v1, v3, 1.0
v_fmac_f32_e32 v3, v4, v3
v_mul_f32_e32 v4, v2, v3
v_fma_f32 v5, -v1, v4, v2
v_fmac_f32_e32 v4, v5, v3
v_fma_f32 v1, -v1, v4, v2
v_div_fmas_f32 v2, v1, v3, v4
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v3, s6
v_mad_i64_i32 v[0:1], s[4:5], s21, v3, v[0:1]
v_mov_b32_e32 v3, s2
v_mad_u64_u32 v[0:1], s[4:5], s0, v3, v[0:1]
s_mul_i32 s0, s0, s3
v_mov_b32_e32 v3, s17
v_add_u32_e32 v1, s1, v1
v_add_u32_e32 v1, s0, v1
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_add_co_u32_e32 v0, vcc, s16, v0
v_div_fixup_f32 v2, v2, v6, v7
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
