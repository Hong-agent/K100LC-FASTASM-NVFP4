.text
k__Z16fa_decode_comb_kPfPKfS1_S1_ii:
s_load_dwordx2 s[2:3], s[4:5], 0x20
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_mov_b32 s18, 0
s_waitcnt lgkmcnt(0)
s_cmp_gt_i32 s2, 0
s_cselect_b64 s[0:1], -1, 0
s_cmp_lt_i32 s2, 1
s_mul_hi_u32 s7, s2, s6
s_mul_i32 s4, s2, s6
s_cbranch_scc1 38
s_ashr_i32 s5, s6, 31
s_mul_i32 s5, s2, s5
s_add_i32 s5, s7, s5
s_cmp_lt_u32 s2, 8
s_cbranch_scc1 36
s_and_b32 s18, s2, -8
s_lshl_b64 s[16:17], s[4:5], 2
s_add_u32 s16, s16, s12
s_addc_u32 s17, s17, s13
s_add_u32 s16, s16, 28
s_addc_u32 s17, s17, 0
s_mov_b32 s19, 0
v_mov_b32_e32 v3, 0xf149f2ca
s_load_dwordx8 s[20:27], s[16:17], -0x1c
s_add_i32 s19, s19, 8
s_add_u32 s16, s16, 32
s_addc_u32 s17, s17, 0
s_cmp_eq_u32 s18, s19
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s21
v_mov_b32_e32 v2, s23
v_max3_f32 v1, v3, s20, v1
v_mov_b32_e32 v4, s25
v_max3_f32 v1, v1, s22, v2
v_mov_b32_e32 v5, s27
v_max3_f32 v1, v1, s24, v4
v_max3_f32 v3, v1, s26, v5
s_cbranch_scc0 65516
s_and_b32 s19, s2, 7
s_cmp_eq_u32 s19, 0
s_cbranch_scc0 9
s_branch 25
v_mov_b32_e32 v3, 0xf149f2ca
s_branch 22
v_mov_b32_e32 v3, 0xf149f2ca
s_and_b32 s19, s2, 7
s_cmp_eq_u32 s19, 0
s_cbranch_scc1 17
s_add_u32 s16, s4, s18
s_addc_u32 s17, s5, 0
s_lshl_b64 s[16:17], s[16:17], 2
s_add_u32 s16, s12, s16
s_addc_u32 s17, s13, s17
s_load_dword s5, s[16:17], 0x0
s_add_u32 s16, s16, 4
v_max_f32_e32 v1, v3, v3
s_addc_u32 s17, s17, 0
s_add_i32 s19, s19, -1
s_waitcnt lgkmcnt(0)
v_max_f32_e64 v2, s5, s5
s_cmp_lg_u32 s19, 0
v_max_f32_e32 v3, v1, v2
s_cbranch_scc1 65524
s_andn2_b64 vcc, exec, s[0:1]
s_cbranch_vccnz 98
s_ashr_i32 s0, s6, 31
s_mul_i32 s0, s2, s0
s_add_i32 s5, s7, s0
s_cmp_eq_u32 s2, 1
s_cbranch_scc1 96
s_and_b32 s0, s2, -2
s_sub_i32 s7, 0, s0
s_lshl_b64 s[0:1], s[4:5], 10
s_add_u32 s0, s10, s0
v_lshlrev_b32_e32 v1, 2, v0
s_addc_u32 s1, s11, s1
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v1, vcc, s0, v1
s_lshl_b64 s[0:1], s[4:5], 2
s_add_u32 s0, s0, 4
s_addc_u32 s1, s1, 0
s_add_u32 s16, s12, s0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_addc_u32 s17, s13, s1
v_add_co_u32_e32 v1, vcc, 0x400, v1
s_add_u32 s18, s14, s0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_addc_u32 s19, s15, s1
s_mov_b64 s[20:21], 0
v_mov_b32_e32 v4, 0
s_mov_b32 s22, 0xc2fc0000
v_mov_b32_e32 v6, 0x1f800000
v_mov_b32_e32 v7, 0x42800000
s_movk_i32 s23, 0x800
v_mov_b32_e32 v5, 0
global_load_dword v8, v[1:2], off offset:-1024
global_load_dword v9, v[1:2], off
s_load_dwordx2 s[0:1], s[16:17], -0x4
s_load_dwordx2 s[24:25], s[18:19], -0x4
v_add_co_u32_e32 v1, vcc, s23, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v10, s0, v3
v_sub_f32_e32 v11, s1, v3
v_mul_f32_e32 v10, 0x3fb8aa3b, v10
v_mul_f32_e32 v11, 0x3fb8aa3b, v11
v_cmp_gt_f32_e32 vcc, s22, v10
v_cmp_gt_f32_e64 s[0:1], s22, v11
v_cndmask_b32_e32 v14, 0, v7, vcc
v_cndmask_b32_e64 v15, 0, v7, s[0:1]
v_add_f32_e32 v10, v10, v14
v_cndmask_b32_e32 v12, 1.0, v6, vcc
v_add_f32_e32 v11, v11, v15
v_cmp_gt_f32_e32 vcc, s22, v10
v_cndmask_b32_e64 v13, 1.0, v6, s[0:1]
v_cndmask_b32_e32 v14, 0, v7, vcc
v_cmp_gt_f32_e64 s[0:1], s22, v11
v_cndmask_b32_e64 v15, 0, v7, s[0:1]
v_add_f32_e32 v10, v10, v14
v_add_f32_e32 v11, v11, v15
v_exp_f32_e32 v10, v10
s_add_u32 s20, s20, -2
v_exp_f32_e32 v11, v11
s_addc_u32 s21, s21, -1
s_add_u32 s16, s16, 8
v_cndmask_b32_e32 v14, 1.0, v6, vcc
s_addc_u32 s17, s17, 0
v_cndmask_b32_e64 v15, 1.0, v6, s[0:1]
v_mul_f32_e32 v10, v10, v14
s_add_u32 s18, s18, 8
v_mul_f32_e32 v11, v11, v15
v_mul_f32_e32 v10, v12, v10
s_addc_u32 s19, s19, 0
v_mul_f32_e32 v11, v13, v11
v_fmac_f32_e32 v4, s24, v10
s_cmp_eq_u32 s7, s20
v_fmac_f32_e32 v4, s25, v11
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v5, v8, v10
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v5, v9, v11
s_cbranch_scc0 65477
s_sub_u32 s0, 0, s20
s_subb_u32 s1, 0, s21
s_bitcmp0_b32 s2, 0
s_cbranch_scc0 9
s_branch 53
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
s_branch 50
s_mov_b64 s[0:1], 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v4, 0
s_bitcmp0_b32 s2, 0
s_cbranch_scc1 45
s_add_u32 s0, s4, s0
s_addc_u32 s1, s5, s1
s_lshl_b64 s[4:5], s[0:1], 2
s_add_u32 s12, s12, s4
s_addc_u32 s13, s13, s5
s_lshl_b64 s[0:1], s[0:1], 10
v_lshl_or_b32 v1, v0, 2, s0
v_mov_b32_e32 v2, s1
v_mov_b32_e32 v6, s11
v_add_co_u32_e32 v1, vcc, s10, v1
v_addc_co_u32_e32 v2, vcc, v6, v2, vcc
global_load_dword v1, v[1:2], off
s_load_dword s1, s[12:13], 0x0
s_mov_b32 s2, 0xc2fc0000
v_mov_b32_e32 v6, 0x42800000
v_mov_b32_e32 v2, 0x1f800000
s_add_u32 s0, s14, s4
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v3, s1, v3
v_mul_f32_e32 v3, 0x3fb8aa3b, v3
v_cmp_gt_f32_e32 vcc, s2, v3
v_cndmask_b32_e32 v8, 0, v6, vcc
v_add_f32_e32 v3, v3, v8
v_cndmask_b32_e32 v7, 1.0, v2, vcc
v_cmp_gt_f32_e32 vcc, s2, v3
v_cndmask_b32_e32 v6, 0, v6, vcc
v_add_f32_e32 v3, v3, v6
s_addc_u32 s1, s15, s5
v_exp_f32_e32 v3, v3
s_load_dword s0, s[0:1], 0x0
v_cndmask_b32_e32 v2, 1.0, v2, vcc
v_mul_f32_e32 v2, v3, v2
v_mul_f32_e32 v2, v7, v2
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v4, s0, v2
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v5, v1, v2
v_cmp_lt_f32_e32 vcc, 0, v4
s_cbranch_vccz 29
v_div_scale_f32 v1, s[0:1], v4, v4, v5
v_div_scale_f32 v2, vcc, v5, v4, v5
v_rcp_f32_e32 v3, v1
v_fma_f32 v6, -v1, v3, 1.0
v_fmac_f32_e32 v3, v6, v3
v_mul_f32_e32 v6, v2, v3
v_fma_f32 v7, -v1, v6, v2
v_fmac_f32_e32 v6, v7, v3
v_fma_f32 v1, -v1, v6, v2
v_div_fmas_f32 v2, v1, v3, v6
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v3, s6
v_mad_i64_i32 v[0:1], s[0:1], s3, v3, v[0:1]
v_mov_b32_e32 v3, s9
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_add_co_u32_e32 v0, vcc, s8, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
v_div_fixup_f32 v2, v2, v4, v5
global_store_dword v[0:1], v2, off
s_endpgm
