.text
k__Z10quant_act4PKfPhPfii:
s_load_dword s2, s[4:5], 0x1c
s_lshl_b32 s0, s6, 5
v_add_u32_e32 v1, s0, v0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s2, v1
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 181
s_load_dwordx2 s[8:9], s[4:5], 0x0
s_mul_hi_i32 s11, s2, s7
s_mul_i32 s10, s2, s7
s_lshl_b64 s[10:11], s[10:11], 2
v_lshlrev_b32_e32 v2, 2, v0
s_waitcnt lgkmcnt(0)
s_add_u32 s3, s8, s10
s_addc_u32 s8, s9, s11
s_ashr_i32 s1, s0, 31
s_lshl_b64 s[0:1], s[0:1], 2
s_add_u32 s0, s3, s0
s_addc_u32 s1, s8, s1
global_load_dword v4, v2, s[0:1]
v_mbcnt_lo_u32_b32 v2, -1, 0
v_mbcnt_hi_u32_b32 v2, -1, v2
v_and_b32_e32 v3, 63, v2
v_and_b32_e32 v5, 64, v2
v_add_u32_e32 v5, 64, v5
v_xor_b32_e32 v6, 16, v3
v_cmp_lt_i32_e32 vcc, v6, v5
v_cndmask_b32_e32 v6, v2, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
v_xor_b32_e32 v7, 8, v3
v_cmp_lt_i32_e32 vcc, v7, v5
v_cndmask_b32_e32 v7, v2, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
s_mov_b32 s3, 0x40e00000
s_waitcnt vmcnt(0)
v_and_b32_e32 v8, 0x7fffffff, v4
ds_bpermute_b32 v6, v6, v8
v_max_f32_e64 v8, |v4|, |v4|
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v6, v6, v6
v_max_f32_e32 v6, v8, v6
ds_bpermute_b32 v7, v7, v6
v_xor_b32_e32 v8, 4, v3
v_cmp_lt_i32_e32 vcc, v8, v5
v_cndmask_b32_e32 v8, v2, v8, vcc
v_lshlrev_b32_e32 v8, 2, v8
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v7, v7, v7
v_max_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v8, v6
v_xor_b32_e32 v8, 2, v3
v_cmp_lt_i32_e32 vcc, v8, v5
v_cndmask_b32_e32 v8, v2, v8, vcc
v_lshlrev_b32_e32 v8, 2, v8
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v7, v7, v7
v_max_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v8, v6
v_xor_b32_e32 v8, 1, v3
v_cmp_lt_i32_e32 vcc, v8, v5
v_cndmask_b32_e32 v5, v2, v8, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v7, v7, v7
v_max_f32_e32 v6, v6, v7
ds_bpermute_b32 v5, v5, v6
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v5, v5, v5
v_max_f32_e32 v5, v6, v5
v_div_scale_f32 v6, s[0:1], s3, s3, v5
v_div_scale_f32 v7, vcc, v5, s3, v5
v_rcp_f32_e32 v8, v6
v_fma_f32 v9, -v6, v8, 1.0
v_fmac_f32_e32 v8, v9, v8
v_mul_f32_e32 v9, v7, v8
v_fma_f32 v10, -v6, v9, v7
v_fmac_f32_e32 v9, v10, v8
v_fma_f32 v6, -v6, v9, v7
v_div_fmas_f32 v6, v6, v8, v9
v_cmp_lt_f32_e32 vcc, 0, v5
v_div_fixup_f32 v6, v6, s3, v5
v_cndmask_b32_e32 v5, 1.0, v6, vcc
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 18
s_ashr_i32 s3, s2, 31
s_lshr_b32 s3, s3, 27
s_add_i32 s3, s2, s3
s_load_dwordx2 s[8:9], s[4:5], 0x10
s_ashr_i32 s3, s3, 5
s_mul_hi_i32 s11, s3, s7
s_mul_i32 s3, s3, s7
s_ashr_i32 s12, s6, 31
s_add_u32 s10, s3, s6
s_addc_u32 s11, s11, s12
s_lshl_b64 s[10:11], s[10:11], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s8, s8, s10
s_addc_u32 s9, s9, s11
v_mov_b32_e32 v6, 0
global_store_dword v6, v5, s[8:9]
s_or_b64 exec, exec, s[0:1]
v_div_scale_f32 v6, s[0:1], v5, v5, v4
v_div_scale_f32 v7, vcc, v4, v5, v4
s_mov_b32 s0, 0x2f800000
s_mov_b32 s1, 0xcf800000
v_and_b32_e32 v0, 1, v0
v_rcp_f32_e32 v8, v6
v_fma_f32 v9, -v6, v8, 1.0
v_fmac_f32_e32 v8, v9, v8
v_mul_f32_e32 v9, v7, v8
v_fma_f32 v10, -v6, v9, v7
v_fmac_f32_e32 v9, v10, v8
v_fma_f32 v6, -v6, v9, v7
v_div_fmas_f32 v6, v6, v8, v9
v_cmp_ne_u32_e32 vcc, 63, v3
v_addc_co_u32_e32 v3, vcc, 0, v2, vcc
v_lshlrev_b32_e32 v3, 2, v3
v_cmp_eq_u32_e32 vcc, 0, v0
v_div_fixup_f32 v4, v6, v5, v4
v_rndne_f32_e32 v4, v4
v_mul_f32_e64 v5, |v4|, s0
v_floor_f32_e32 v5, v5
v_fma_f32 v5, v5, s1, |v4|
v_cvt_u32_f32_e32 v5, v5
v_ashrrev_i32_e32 v2, 31, v4
v_xor_b32_e32 v4, v5, v2
v_sub_u32_e32 v2, v4, v2
v_med3_i32 v2, v2, -8, 7
ds_bpermute_b32 v3, v3, v2
s_and_b64 exec, exec, vcc
s_cbranch_execz 22
s_load_dwordx2 s[0:1], s[4:5], 0x8
s_lshr_b32 s3, s2, 31
s_add_i32 s2, s2, s3
v_and_b32_e32 v0, 15, v2
s_ashr_i32 s2, s2, 1
s_waitcnt lgkmcnt(0)
v_lshl_or_b32 v2, v3, 4, v0
s_mul_hi_i32 s3, s2, s7
s_mul_i32 s2, s2, s7
v_lshrrev_b32_e32 v0, 31, v1
v_add_u32_e32 v0, v1, v0
s_add_u32 s0, s0, s2
v_ashrrev_i32_e32 v0, 1, v0
s_addc_u32 s1, s1, s3
v_ashrrev_i32_e32 v1, 31, v0
v_mov_b32_e32 v3, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_byte v[0:1], v2, off
s_endpgm
