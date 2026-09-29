.text
k__Z9quant_actPKfPaS1_PfPiii:
s_load_dword s9, s[4:5], 0x2c
s_lshl_b32 s20, s6, 7
s_waitcnt lgkmcnt(0)
s_cmp_ge_i32 s20, s9
s_cbranch_scc1 277
s_load_dwordx8 s[12:19], s[4:5], 0x0
s_load_dwordx2 s[10:11], s[4:5], 0x20
s_mul_hi_i32 s1, s9, s7
s_mul_i32 s0, s9, s7
s_lshl_b64 s[0:1], s[0:1], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s2, s12, s0
s_mov_b32 s8, s7
s_addc_u32 s3, s13, s1
s_ashr_i32 s7, s6, 31
s_lshl_b64 s[0:1], s[6:7], 9
s_add_u32 s7, s2, s0
s_addc_u32 s21, s3, s1
s_sub_i32 s0, s9, s20
s_min_i32 s22, s0, 0x80
v_cmp_gt_i32_e64 s[2:3], s22, v0
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 27
s_load_dword s23, s[4:5], 0x3c
s_mov_b64 s[12:13], 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s23, s23, 0xffff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[4:5], 2, v[1:2]
v_mov_b32_e32 v6, s21
v_add_co_u32_e32 v4, vcc, s7, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_load_dword v2, v[4:5], off
v_add_u32_e32 v1, s23, v1
v_max_f32_e32 v3, v3, v3
v_cmp_le_i32_e32 vcc, s22, v1
s_or_b64 s[12:13], vcc, s[12:13]
s_waitcnt vmcnt(0)
v_max_f32_e64 v2, |v2|, |v2|
v_max_f32_e32 v3, v3, v2
s_andn2_b64 exec, exec, s[12:13]
s_cbranch_execnz 65518
s_or_b64 exec, exec, s[12:13]
s_or_b64 exec, exec, s[0:1]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v6, -1, v1
v_and_b32_e32 v7, 63, v6
v_and_b32_e32 v1, 64, v6
v_add_u32_e32 v8, 64, v1
v_xor_b32_e32 v1, 16, v7
v_cmp_lt_i32_e32 vcc, v1, v8
v_cndmask_b32_e32 v1, v6, v1, vcc
v_lshlrev_b32_e32 v2, 2, v1
ds_bpermute_b32 v1, v2, v3
v_max_f32_e32 v3, v3, v3
v_cmp_eq_u32_e64 s[0:1], 0, v0
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v1, v1, v1
v_max_f32_e32 v1, v3, v1
v_xor_b32_e32 v3, 8, v7
v_cmp_lt_i32_e32 vcc, v3, v8
v_cndmask_b32_e32 v3, v6, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v4, v3, v1
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v4, v4, v4
v_max_f32_e32 v1, v1, v4
v_xor_b32_e32 v4, 4, v7
v_cmp_lt_i32_e32 vcc, v4, v8
v_cndmask_b32_e32 v4, v6, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v5, v4, v1
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v5, v5, v5
v_max_f32_e32 v1, v1, v5
v_xor_b32_e32 v5, 2, v7
v_cmp_lt_i32_e32 vcc, v5, v8
v_cndmask_b32_e32 v5, v6, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
ds_bpermute_b32 v9, v5, v1
v_xor_b32_e32 v7, 1, v7
v_cmp_lt_i32_e32 vcc, v7, v8
v_cndmask_b32_e32 v6, v6, v7, vcc
v_lshlrev_b32_e32 v6, 2, v6
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v9, v9, v9
v_max_f32_e32 v1, v1, v9
ds_bpermute_b32 v7, v6, v1
s_and_saveexec_b64 s[12:13], s[0:1]
s_cbranch_execz 41
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v7, v7, v7
v_max_f32_e32 v1, v1, v1
v_max_f32_e32 v1, v1, v7
s_mov_b32 s23, 0x42fe0000
v_div_scale_f32 v7, s[24:25], s23, s23, v1
v_div_scale_f32 v8, vcc, v1, s23, v1
s_ashr_i32 s24, s9, 31
s_lshr_b32 s24, s24, 25
s_add_i32 s24, s9, s24
s_ashr_i32 s24, s24, 7
s_mul_i32 s24, s24, s8
s_add_i32 s24, s24, s6
s_ashr_i32 s25, s24, 31
s_lshl_b64 s[24:25], s[24:25], 2
s_add_u32 s18, s18, s24
s_addc_u32 s19, s19, s25
v_rcp_f32_e32 v9, v7
v_fma_f32 v10, -v7, v9, 1.0
v_fmac_f32_e32 v9, v10, v9
v_mul_f32_e32 v10, v8, v9
v_fma_f32 v11, -v7, v10, v8
v_fmac_f32_e32 v10, v11, v9
v_fma_f32 v7, -v7, v10, v8
v_div_fmas_f32 v7, v7, v9, v10
v_cmp_lt_f32_e32 vcc, 0, v1
v_mov_b32_e32 v8, 0
v_div_fixup_f32 v7, v7, s23, v1
v_cndmask_b32_e32 v1, 1.0, v7, vcc
global_store_dword v8, v1, s[18:19]
ds_write_b32 v8, v1
s_or_b64 exec, exec, s[12:13]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, 0
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[12:13], s[2:3]
s_cbranch_execz 87
v_mov_b32_e32 v7, 0
s_load_dword s3, s[4:5], 0x3c
ds_read_b32 v8, v7
s_lshr_b32 s2, s9, 31
s_add_i32 s2, s9, s2
s_ashr_i32 s2, s2, 1
s_mul_hi_i32 s4, s2, s8
s_mul_i32 s5, s2, s8
s_waitcnt lgkmcnt(0)
s_and_b32 s18, s3, 0xffff
s_mov_b64 s[2:3], 0
s_mov_b32 s19, 0x2f800000
s_mov_b32 s23, 0xcf800000
s_movk_i32 s24, 0xff80
v_mov_b32_e32 v9, 0x7f
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[10:11], 2, v[0:1]
v_mov_b32_e32 v1, s21
v_add_co_u32_e32 v10, vcc, s7, v10
v_addc_co_u32_e32 v11, vcc, v1, v11, vcc
global_load_dword v1, v[10:11], off
v_and_b32_e32 v13, 1, v0
v_add_u32_e32 v12, s20, v0
v_mov_b32_e32 v14, s17
v_mov_b32_e32 v16, s15
v_mov_b32_e32 v17, s16
v_mov_b32_e32 v18, s14
v_add_u32_e32 v0, s18, v0
s_waitcnt vmcnt(0)
v_div_scale_f32 v10, s[26:27], v8, v8, v1
v_div_scale_f32 v11, vcc, v1, v8, v1
v_rcp_f32_e32 v15, v10
v_fma_f32 v19, -v10, v15, 1.0
v_fmac_f32_e32 v15, v19, v15
v_mul_f32_e32 v19, v11, v15
v_fma_f32 v20, -v10, v19, v11
v_fmac_f32_e32 v19, v20, v15
v_fma_f32 v10, -v10, v19, v11
v_div_fmas_f32 v10, v10, v15, v19
v_cmp_eq_u32_e32 vcc, 0, v13
v_cndmask_b32_e32 v13, v14, v16, vcc
v_lshrrev_b32_e32 v14, 31, v12
v_add_u32_e32 v12, v12, v14
v_cndmask_b32_e32 v15, v17, v18, vcc
v_cmp_le_i32_e32 vcc, s22, v0
v_ashrrev_i32_e32 v12, 1, v12
v_mov_b32_e32 v11, s4
s_or_b64 s[2:3], vcc, s[2:3]
v_ashrrev_i32_e32 v14, 31, v12
v_add_co_u32_e32 v12, vcc, s5, v12
v_addc_co_u32_e32 v11, vcc, v14, v11, vcc
v_div_fixup_f32 v1, v10, v8, v1
v_rndne_f32_e32 v1, v1
v_mul_f32_e64 v10, |v1|, s19
v_floor_f32_e32 v10, v10
v_fma_f32 v10, v10, s23, |v1|
v_cvt_u32_f32_e32 v14, v10
v_ashrrev_i32_e32 v1, 31, v1
v_add_co_u32_e32 v10, vcc, v15, v12
v_xor_b32_e32 v12, v14, v1
v_sub_u32_e32 v1, v12, v1
v_med3_i32 v1, v1, s24, v9
v_addc_co_u32_e32 v11, vcc, v13, v11, vcc
v_add_u32_e32 v7, v1, v7
global_store_byte v[10:11], v1, off
s_andn2_b64 exec, exec, s[2:3]
s_cbranch_execnz 65471
s_or_b64 exec, exec, s[2:3]
s_or_b64 exec, exec, s[12:13]
ds_bpermute_b32 v0, v2, v7
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v0, v7
ds_bpermute_b32 v1, v3, v0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v1, v0
ds_bpermute_b32 v1, v4, v0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v1, v0
ds_bpermute_b32 v1, v5, v0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v1, v0
ds_bpermute_b32 v1, v6, v0
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 15
s_ashr_i32 s0, s9, 31
s_lshr_b32 s0, s0, 25
s_add_i32 s9, s9, s0
s_ashr_i32 s0, s9, 7
s_mul_i32 s0, s0, s8
s_add_i32 s0, s0, s6
s_ashr_i32 s1, s0, 31
s_lshl_b64 s[0:1], s[0:1], 2
s_add_u32 s0, s10, s0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v1, v0
s_addc_u32 s1, s11, s1
v_mov_b32_e32 v1, 0
global_store_dword v1, v0, s[0:1]
s_endpgm
