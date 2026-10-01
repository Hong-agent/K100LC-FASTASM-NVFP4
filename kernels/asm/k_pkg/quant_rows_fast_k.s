.text
k_quant_rows_fast_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v30, 0
v_and_b32_e32 v1, 63, v0
v_lshrrev_b32_e32 v2, 6, v0
v_lshlrev_b32_e32 v4, 3, v1
s_mov_b32 s28, s6
s_mul_i32 s29, s28, s25
s_add_i32 s29, s29, s26
s_lshl_b32 s29, s29, 2
s_lshl_b32 s30, s28, 2
s_lshr_b32 s31, s22, 1
s_mul_i32 s31, s31, s28
v_mov_b32_e32 v19, 0x40e00000
L_loop:
v_cmp_gt_u32_e32 vcc, s27, v2
s_cbranch_vccz L_end
v_mul_lo_u32 v28, v2, s23
v_lshlrev_b32_e32 v28, 2, v28
v_add_u32_e32 v28, v28, v4
v_mov_b32_e32 v7, s29
v_add_u32_e32 v28, v28, v7
v_mov_b32_e32 v5, s20
v_add_co_u32_e32 v5, vcc, v5, v28
v_mov_b32_e32 v6, s21
v_addc_co_u32_e32 v6, vcc, v6, v30, vcc
global_load_dwordx2 v[8:9], v[5:6], off
s_waitcnt vmcnt(0)
v_max_f32_e64 v15, |v8|, |v9|
v_xor_b32_e32 v16, 32, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_xor_b32_e32 v16, 16, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_xor_b32_e32 v16, 8, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_xor_b32_e32 v16, 4, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_xor_b32_e32 v16, 2, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_xor_b32_e32 v16, 1, v1
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v17, v16, v15
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v15, v15, v17
v_div_scale_f32 v10, vcc, v19, v19, v15
v_div_scale_f32 v11, vcc, v15, v19, v15
v_rcp_f32_e32 v12, v10
v_fma_f32 v13, -v10, v12, 1.0
v_fmac_f32_e32 v12, v13, v12
v_fma_f32 v14, -v10, v13, v11
v_fmac_f32_e32 v13, v14, v12
v_fma_f32 v10, -v10, v13, v11
v_div_fmas_f32 v14, v10, v12, v13
v_div_fixup_f32 v18, v14, v19, v15
v_cmp_lt_f32_e32 vcc, 0, v15
v_mov_b32_e32 v7, 0x3f800000
v_cndmask_b32_e32 v20, v7, v18, vcc
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[0:1], vcc
v_mul_lo_u32 v21, v2, s24
v_lshlrev_b32_e32 v21, 2, v21
v_mov_b32_e32 v7, s30
v_add_u32_e32 v21, v21, v7
v_mov_b32_e32 v22, s18
v_add_co_u32_e32 v21, vcc, v22, v21
v_mov_b32_e32 v22, s19
v_addc_co_u32_e32 v22, vcc, v22, v30, vcc
global_store_dword v[21:22], v20, off
s_or_b64 exec, exec, s[0:1]
v_div_scale_f32 v10, vcc, v20, v20, v8
v_div_scale_f32 v11, vcc, v8, v20, v8
v_rcp_f32_e32 v12, v10
v_fma_f32 v13, -v10, v12, 1.0
v_fmac_f32_e32 v12, v13, v12
v_fma_f32 v14, -v10, v13, v11
v_fmac_f32_e32 v13, v14, v12
v_fma_f32 v10, -v10, v13, v11
v_div_fmas_f32 v14, v10, v12, v13
v_div_fixup_f32 v21, v14, v20, v8
v_rndne_f32_e32 v21, v21
v_cvt_i32_f32_e32 v21, v21
v_med3_i32 v21, v21, -8, 7
v_and_b32_e32 v21, 15, v21
v_div_scale_f32 v10, vcc, v20, v20, v9
v_div_scale_f32 v11, vcc, v9, v20, v9
v_rcp_f32_e32 v12, v10
v_fma_f32 v13, -v10, v12, 1.0
v_fmac_f32_e32 v12, v13, v12
v_fma_f32 v14, -v10, v13, v11
v_fmac_f32_e32 v13, v14, v12
v_fma_f32 v10, -v10, v13, v11
v_div_fmas_f32 v14, v10, v12, v13
v_div_fixup_f32 v22, v14, v20, v9
v_rndne_f32_e32 v22, v22
v_cvt_i32_f32_e32 v22, v22
v_med3_i32 v22, v22, -8, 7
v_and_b32_e32 v22, 15, v22
v_lshlrev_b32_e32 v22, 4, v22
v_or_b32_e32 v22, v21, v22
v_lshlrev_b32_e32 v23, 4, v1
ds_bpermute_b32 v24, v23, v22
v_add_u32_e32 v23, 4, v23
ds_bpermute_b32 v25, v23, v22
v_add_u32_e32 v23, 4, v23
ds_bpermute_b32 v26, v23, v22
v_add_u32_e32 v23, 4, v23
ds_bpermute_b32 v27, v23, v22
s_waitcnt lgkmcnt(0)
v_and_b32_e32 v24, 0xff, v24
v_and_b32_e32 v25, 0xff, v25
v_lshlrev_b32_e32 v25, 8, v25
v_or_b32_e32 v24, v24, v25
v_and_b32_e32 v26, 0xff, v26
v_lshlrev_b32_e32 v26, 16, v26
v_and_b32_e32 v27, 0xff, v27
v_lshlrev_b32_e32 v27, 24, v27
v_or_b32_e32 v26, v26, v27
v_or_b32_e32 v24, v24, v26
v_mul_lo_u32 v28, v2, s23
v_lshrrev_b32_e32 v28, 3, v28
v_lshlrev_b32_e32 v28, 2, v28
v_mov_b32_e32 v7, s31
v_add_u32_e32 v28, v28, v7
v_lshlrev_b32_e32 v29, 2, v1
v_add_u32_e32 v28, v28, v29
v_cmp_gt_u32_e32 vcc, 16, v1
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v26, s16
v_add_co_u32_e32 v26, vcc, v26, v28
v_mov_b32_e32 v27, s17
v_addc_co_u32_e32 v27, vcc, v27, v30, vcc
global_store_dword v[26:27], v24, off
s_or_b64 exec, exec, s[2:3]
v_add_u32_e32 v2, 4, v2
s_branch L_loop
L_end:
s_endpgm
