.text
k__Z15nvfp4_quant_actPKfPaS1_Pfii:
s_load_dword s20, s[4:5], 0x24
s_lshl_b32 s3, s6, 4
s_waitcnt lgkmcnt(0)
s_sub_i32 s0, s20, s3
s_min_i32 s18, s0, 16
s_cmp_lt_i32 s18, 1
s_cbranch_scc1 233
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_mul_hi_i32 s1, s20, s7
s_mul_i32 s0, s20, s7
s_lshl_b64 s[0:1], s[0:1], 2
s_mov_b32 s2, s7
s_waitcnt lgkmcnt(0)
s_add_u32 s8, s8, s0
s_addc_u32 s9, s9, s1
s_ashr_i32 s7, s6, 31
s_lshl_b64 s[0:1], s[6:7], 6
s_add_u32 s7, s8, s0
s_addc_u32 s19, s9, s1
v_cmp_gt_u32_e64 s[0:1], s18, v0
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 27
s_load_dword s21, s[4:5], 0x34
s_mov_b64 s[16:17], 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s21, s21, 0xffff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[4:5], 2, v[1:2]
v_mov_b32_e32 v6, s19
v_add_co_u32_e32 v4, vcc, s7, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_load_dword v2, v[4:5], off
v_add_u32_e32 v1, s21, v1
v_max_f32_e32 v3, v3, v3
v_cmp_le_i32_e32 vcc, s18, v1
s_or_b64 s[16:17], vcc, s[16:17]
s_waitcnt vmcnt(0)
v_max_f32_e64 v2, |v2|, |v2|
v_max_f32_e32 v3, v3, v2
s_andn2_b64 exec, exec, s[16:17]
s_cbranch_execnz 65518
s_or_b64 exec, exec, s[16:17]
s_or_b64 exec, exec, s[8:9]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v2, -1, v1
v_and_b32_e32 v4, 63, v2
v_and_b32_e32 v1, 64, v2
v_add_u32_e32 v5, 64, v1
v_xor_b32_e32 v1, 16, v4
v_cmp_lt_i32_e32 vcc, v1, v5
v_cndmask_b32_e32 v1, v2, v1, vcc
v_lshlrev_b32_e32 v1, 2, v1
ds_bpermute_b32 v1, v1, v3
v_max_f32_e32 v3, v3, v3
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v1, v1, v1
v_max_f32_e32 v1, v3, v1
v_xor_b32_e32 v3, 8, v4
v_cmp_lt_i32_e32 vcc, v3, v5
v_cndmask_b32_e32 v3, v2, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v1
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v3, v3, v3
v_max_f32_e32 v1, v1, v3
v_xor_b32_e32 v3, 4, v4
v_cmp_lt_i32_e32 vcc, v3, v5
v_cndmask_b32_e32 v3, v2, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v1
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v3, v3, v3
v_max_f32_e32 v1, v1, v3
v_xor_b32_e32 v3, 2, v4
v_cmp_lt_i32_e32 vcc, v3, v5
v_cndmask_b32_e32 v3, v2, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v1
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v3, v3, v3
v_max_f32_e32 v1, v1, v3
v_xor_b32_e32 v3, 1, v4
v_cmp_lt_i32_e32 vcc, v3, v5
v_cndmask_b32_e32 v2, v2, v3, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v2, v2, v1
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 41
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v2, v2, v2
v_max_f32_e32 v1, v1, v1
v_max_f32_e32 v1, v1, v2
s_mov_b32 s21, 0x42fe0000
v_div_scale_f32 v2, s[16:17], s21, s21, v1
v_div_scale_f32 v3, vcc, v1, s21, v1
s_ashr_i32 s16, s20, 31
s_lshr_b32 s16, s16, 28
s_add_i32 s16, s20, s16
s_ashr_i32 s16, s16, 4
s_mul_i32 s16, s16, s2
s_add_i32 s16, s16, s6
s_ashr_i32 s17, s16, 31
s_lshl_b64 s[16:17], s[16:17], 2
s_add_u32 s14, s14, s16
s_addc_u32 s15, s15, s17
v_rcp_f32_e32 v4, v2
v_fma_f32 v5, -v2, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v2, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v2, -v2, v5, v3
v_div_fmas_f32 v2, v2, v4, v5
v_cmp_lt_f32_e32 vcc, 0, v1
v_mov_b32_e32 v3, 0
v_div_fixup_f32 v2, v2, s21, v1
v_cndmask_b32_e32 v1, 1.0, v2, vcc
ds_write_b32 v3, v1
global_store_dword v3, v1, s[14:15]
s_or_b64 exec, exec, s[8:9]
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 87
v_mov_b32_e32 v1, 0
ds_read_b32 v1, v1
s_mov_b32 s6, 0x2f800000
s_mov_b32 s8, 0xcf800000
s_movk_i32 s9, 0xff80
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v2, s[0:1], v1, v1, 1.0
v_div_scale_f32 v3, vcc, 1.0, v1, 1.0
s_load_dword s1, s[4:5], 0x34
s_lshr_b32 s0, s20, 31
s_add_i32 s20, s20, s0
s_ashr_i32 s0, s20, 1
s_mov_b64 s[4:5], 0
s_mul_hi_i32 s14, s0, s2
s_mul_i32 s2, s0, s2
s_waitcnt lgkmcnt(0)
s_and_b32 s15, s1, 0xffff
v_rcp_f32_e32 v4, v2
v_fma_f32 v5, -v2, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v2, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v2, -v2, v5, v3
v_div_fmas_f32 v2, v2, v4, v5
v_mov_b32_e32 v3, 0x7f
v_div_fixup_f32 v2, v2, v1, 1.0
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[4:5], 2, v[0:1]
v_mov_b32_e32 v6, s19
v_add_co_u32_e32 v4, vcc, s7, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_load_dword v1, v[4:5], off
v_and_b32_e32 v5, 1, v0
v_mov_b32_e32 v6, s13
v_mov_b32_e32 v7, s11
v_mov_b32_e32 v8, s12
v_mov_b32_e32 v9, s10
v_cmp_eq_u32_e32 vcc, 0, v5
v_add_u32_e32 v4, s3, v0
v_cndmask_b32_e32 v5, v6, v7, vcc
v_add_u32_e32 v0, s15, v0
v_cndmask_b32_e32 v6, v8, v9, vcc
v_ashrrev_i32_e32 v4, 1, v4
v_cmp_le_i32_e32 vcc, s18, v0
v_add_co_u32_e64 v6, s[0:1], s2, v6
v_ashrrev_i32_e32 v7, 31, v4
s_or_b64 s[4:5], vcc, s[4:5]
v_add_co_u32_e32 v4, vcc, v6, v4
v_mov_b32_e32 v10, s14
v_addc_co_u32_e64 v5, s[0:1], v5, v10, s[0:1]
v_addc_co_u32_e32 v5, vcc, v5, v7, vcc
s_waitcnt vmcnt(0)
v_mul_f32_e32 v1, v2, v1
v_rndne_f32_e32 v1, v1
v_mul_f32_e64 v6, |v1|, s6
v_floor_f32_e32 v6, v6
v_fma_f32 v6, v6, s8, |v1|
v_cvt_u32_f32_e32 v6, v6
v_ashrrev_i32_e32 v1, 31, v1
v_xor_b32_e32 v6, v6, v1
v_sub_u32_e32 v1, v6, v1
v_med3_i32 v1, v1, s9, v3
global_store_byte v[4:5], v1, off
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65489
s_endpgm
