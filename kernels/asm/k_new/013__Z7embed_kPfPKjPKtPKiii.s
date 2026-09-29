.text
k__Z7embed_kPfPKjPKtPKiii:
s_load_dwordx2 s[0:1], s[4:5], 0x20
s_waitcnt lgkmcnt(0)
s_ashr_i32 s16, s0, 31
s_lshr_b32 s2, s16, 29
s_add_i32 s2, s0, s2
s_ashr_i32 s2, s2, 3
v_cmp_gt_i32_e32 vcc, s2, v0
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 200
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_ashr_i32 s7, s6, 31
s_lshl_b64 s[18:19], s[6:7], 2
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, s2
s_waitcnt lgkmcnt(0)
s_add_u32 s18, s14, s18
s_addc_u32 s19, s15, s19
s_ashr_i32 s3, s1, 31
s_add_i32 s1, s1, s3
s_xor_b32 s7, s1, s3
v_cvt_f32_u32_e32 v1, s7
s_add_i32 s1, s0, s16
s_xor_b32 s17, s16, s3
s_xor_b32 s1, s1, s16
v_rcp_iflag_f32_e32 v1, v1
s_sub_i32 s15, 0, s7
s_load_dword s18, s[18:19], 0x0
s_mov_b32 s14, 0
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
s_waitcnt lgkmcnt(0)
s_ashr_i32 s19, s18, 31
s_mul_i32 s19, s19, s2
v_readfirstlane_b32 s16, v1
s_mul_i32 s15, s15, s16
s_mul_hi_u32 s15, s16, s15
s_add_i32 s15, s16, s15
s_mul_hi_u32 s16, s1, s15
s_mul_i32 s20, s16, s7
s_sub_i32 s1, s1, s20
s_add_i32 s21, s16, 1
s_sub_i32 s20, s1, s7
s_cmp_ge_u32 s1, s7
s_cselect_b32 s16, s21, s16
s_cselect_b32 s1, s20, s1
s_add_i32 s20, s16, 1
s_cmp_ge_u32 s1, s7
s_cselect_b32 s1, s20, s16
s_xor_b32 s1, s1, s17
s_sub_i32 s1, s1, s17
s_mul_hi_i32 s16, s1, s18
s_mul_i32 s17, s1, s18
s_mul_hi_i32 s1, s0, s6
s_mul_i32 s0, s0, s6
s_lshl_b64 s[0:1], s[0:1], 2
v_mov_b32_e32 v1, v2
s_add_u32 s6, s8, s0
s_load_dword s0, s[4:5], 0x34
v_mad_u64_u32 v[3:4], s[4:5], s18, v3, v[0:1]
s_addc_u32 s4, s9, s1
v_mov_b32_e32 v1, s11
v_add_u32_e32 v4, s19, v4
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
s_and_b32 s5, s0, 0xffff
v_add_co_u32_e32 v3, vcc, s10, v3
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
s_lshl_b32 s8, s5, 2
v_lshlrev_b32_e32 v1, 3, v0
s_lshl_b32 s9, s5, 3
s_mov_b64 s[0:1], 0
s_mov_b32 s10, 0x3a800000
v_mul_hi_u32 v5, v1, s15
v_mov_b32_e32 v6, s16
v_mov_b32_e32 v7, s13
v_mov_b32_e32 v10, s14
v_mul_lo_u32 v8, v5, s7
v_add_u32_e32 v9, 1, v5
v_add_u32_e32 v0, s5, v0
v_sub_u32_e32 v8, v1, v8
v_cmp_le_u32_e32 vcc, s7, v8
v_cndmask_b32_e32 v5, v5, v9, vcc
v_subrev_u32_e32 v9, s7, v8
v_cndmask_b32_e32 v8, v8, v9, vcc
v_add_u32_e32 v9, 1, v5
v_cmp_le_u32_e32 vcc, s7, v8
v_cndmask_b32_e32 v5, v5, v9, vcc
v_xor_b32_e32 v5, s3, v5
v_subrev_u32_e32 v5, s3, v5
v_ashrrev_i32_e32 v8, 31, v5
v_add_co_u32_e32 v5, vcc, s17, v5
v_addc_co_u32_e32 v6, vcc, v8, v6, vcc
v_lshlrev_b64 v[5:6], 1, v[5:6]
v_mov_b32_e32 v9, s4
v_add_co_u32_e32 v5, vcc, s12, v5
v_addc_co_u32_e32 v6, vcc, v7, v6, vcc
global_load_ushort v7, v[5:6], off
global_load_dword v8, v[3:4], off
v_lshlrev_b64 v[5:6], 2, v[1:2]
v_add_co_u32_e32 v3, vcc, s8, v3
v_addc_co_u32_e32 v4, vcc, v4, v10, vcc
v_add_co_u32_e32 v13, vcc, s6, v5
v_addc_co_u32_e32 v14, vcc, v9, v6, vcc
v_add_u32_e32 v1, s9, v1
s_waitcnt vmcnt(0)
v_and_b32_e32 v5, 15, v8
v_bfe_u32 v6, v8, 4, 4
v_cmp_lt_u32_e32 vcc, 7, v5
v_bfe_u32 v9, v8, 8, 4
v_cndmask_b32_e64 v17, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v6
v_bfe_u32 v10, v8, 12, 4
v_bfe_u32 v11, v8, 16, 4
v_bfe_u32 v12, v8, 20, 4
v_bfe_u32 v15, v8, 24, 4
v_lshrrev_b32_e32 v16, 28, v8
v_ashrrev_i32_e32 v8, 31, v8
v_cndmask_b32_e64 v18, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v9
v_and_or_b32 v8, v8, -16, v16
v_cndmask_b32_e64 v16, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v10
v_or_b32_e32 v5, v17, v5
v_cndmask_b32_e64 v17, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v11
v_or_b32_e32 v6, v18, v6
v_cndmask_b32_e64 v18, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v12
v_or_b32_e32 v9, v16, v9
v_cndmask_b32_e64 v16, 0, -16, vcc
v_cmp_lt_u32_e32 vcc, 7, v15
v_or_b32_e32 v10, v17, v10
v_cndmask_b32_e64 v17, 0, -16, vcc
v_or_b32_e32 v12, v16, v12
v_and_b32_e32 v16, 0xffff, v7
v_or_b32_e32 v15, v17, v15
v_bfe_u32 v17, v16, 10, 5
v_and_b32_e32 v16, 0x3ff, v16
v_cvt_f32_u32_e32 v16, v16
v_or_b32_e32 v11, v18, v11
v_add_u32_e32 v18, -15, v17
v_cmp_le_i32_e32 vcc, s2, v0
v_fma_f32 v19, v16, s10, 1.0
v_ldexp_f32 v18, v19, v18
v_cvt_f32_i32_e32 v19, v8
v_cvt_f32_i32_e32 v5, v5
v_cvt_f32_i32_e32 v6, v6
v_cvt_f32_i32_e32 v8, v9
v_cvt_f32_i32_e32 v9, v10
v_cvt_f32_i32_e32 v10, v11
v_cvt_f32_i32_e32 v11, v12
v_cvt_f32_i32_e32 v12, v15
v_mul_f32_e32 v15, 0x3a800000, v16
s_or_b64 s[0:1], vcc, s[0:1]
v_ldexp_f32 v15, v15, -14
v_cmp_eq_u32_e32 vcc, 0, v17
v_cndmask_b32_e32 v15, v18, v15, vcc
v_cmp_gt_i16_e32 vcc, 0, v7
v_cndmask_b32_e64 v15, v15, -v15, vcc
v_mul_f32_e32 v5, v5, v15
v_mul_f32_e32 v6, v6, v15
v_mul_f32_e32 v7, v8, v15
v_mul_f32_e32 v8, v9, v15
v_mul_f32_e32 v9, v10, v15
v_mul_f32_e32 v10, v11, v15
v_mul_f32_e32 v11, v12, v15
v_mul_f32_e32 v12, v19, v15
global_store_dwordx4 v[13:14], v[5:8], off
global_store_dwordx4 v[13:14], v[9:12], off offset:16
s_andn2_b64 exec, exec, s[0:1]
s_cbranch_execnz 65407
s_endpgm
