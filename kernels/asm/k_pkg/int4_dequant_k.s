.text
k_int4_dequant_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s23
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_lshrrev_b32_e32 v2, 4, v1
v_lshlrev_b32_e32 v2, 1, v2
v_mov_b32_e32 v8, s18
v_mov_b32_e32 v9, s19
v_add_co_u32_e32 v8, vcc, v8, v2
v_addc_co_u32_e32 v9, vcc, v9, v3, vcc
v_lshlrev_b32_e32 v2, 2, v1
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v2, 5, v1
v_mov_b32_e32 v6, s20
v_mov_b32_e32 v7, s21
v_add_co_u32_e32 v6, vcc, v6, v2
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
global_load_dword v11, v[4:5], off
global_load_ushort v10, v[8:9], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v10, 16, v10
v_mov_b32_e32 v20, 0xc1000000
v_and_b32_e32 v21, 0x0f, v11
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v12, v21, v10
v_lshrrev_b32_e32 v21, 4, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v13, v21, v10
v_lshrrev_b32_e32 v21, 8, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v14, v21, v10
v_lshrrev_b32_e32 v21, 12, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v15, v21, v10
v_lshrrev_b32_e32 v21, 16, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v16, v21, v10
v_lshrrev_b32_e32 v21, 20, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v17, v21, v10
v_lshrrev_b32_e32 v21, 24, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v18, v21, v10
v_lshrrev_b32_e32 v21, 28, v11
v_and_b32_e32 v21, 0x0f, v21
v_cvt_f32_u32_e32 v21, v21
v_add_f32_e32 v21, v20, v21
v_mul_f32_e32 v19, v21, v10
global_store_dwordx4 v[6:7], v[12:15], off
global_store_dwordx4 v[6:7], v[16:19], off offset:16
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
