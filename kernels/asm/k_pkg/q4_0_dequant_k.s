.text
k_q4_0_dequant_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_load_dword s21, s[4:5], 0x14
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_lshlrev_b32_e32 v1, 6, v1
v_add_u32_e32 v1, v1, v0
v_cmp_gt_u32_e32 vcc, s20, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mul_lo_u32 v2, v1, 18
v_add_u32_e32 v2, 2, v2
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, s16, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v2, 7, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, s18, v2
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mov_b32_e32 v17, -1
v_add_co_u32_e32 v8, vcc, 0xfffffffe, v4
v_addc_co_u32_e32 v9, vcc, v17, v5, vcc
global_load_ushort v10, v[8:9], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v10, v10
v_mov_b32_e32 v12, 8
s_mov_b32 s22, 0
L_loop:
global_load_ubyte v11, v[4:5], off
s_waitcnt vmcnt(0)
v_and_b32_e32 v13, 0x0f, v11
v_sub_u32_e32 v13, v13, v12
v_cvt_f32_i32_e32 v13, v13
v_mul_f32_e32 v13, v13, v10
global_store_dword v[6:7], v13, off
v_lshrrev_b32_e32 v14, 4, v11
v_sub_u32_e32 v14, v14, v12
v_cvt_f32_i32_e32 v14, v14
v_mul_f32_e32 v14, v14, v10
v_add_co_u32_e32 v15, vcc, 64, v6
v_addc_co_u32_e32 v16, vcc, 0, v7, vcc
global_store_dword v[15:16], v14, off
v_add_co_u32_e32 v4, vcc, 1, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_add_co_u32_e32 v6, vcc, 4, v6
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_add_i32 s22, s22, 1
s_cmp_lt_u32 s22, 16
s_cbranch_scc1 L_loop
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
