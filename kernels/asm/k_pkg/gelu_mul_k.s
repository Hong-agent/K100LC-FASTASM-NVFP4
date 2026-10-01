.text
k_gelu_mul_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s6
v_lshlrev_b32_e32 v1, 6, v1
v_add_u32_e32 v1, v1, v0
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_lshlrev_b32_e32 v2, 2, v1
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v5, s19
v_add_co_u32_e32 v4, vcc, s18, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dword v6, v[4:5], off
v_mov_b32_e32 v5, s21
v_add_co_u32_e32 v4, vcc, s20, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dword v7, v[4:5], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v8, v6, v6
v_mul_f32_e32 v9, v8, v6
v_mov_b32_e32 v10, 0x3d372713
v_fma_f32 v9, v9, v10, v6
v_mov_b32_e32 v10, 0x3f4c422a
v_mul_f32_e32 v9, v9, v10
v_mov_b32_e32 v10, 0x4038aa3b
v_mul_f32_e32 v9, v9, v10
s_nop 0
v_exp_f32_e32 v9, v9
s_nop 0
v_mov_b32_e32 v10, 0x3f800000
v_add_f32_e32 v9, v10, v9
s_nop 0
v_rcp_f32_e32 v9, v9
s_nop 0
v_mov_b32_e32 v10, 0x40000000
v_mul_f32_e32 v9, v9, v10
v_mov_b32_e32 v10, 0x3f800000
v_sub_f32_e32 v9, v10, v9
v_add_f32_e32 v9, v10, v9
v_mov_b32_e32 v10, 0x3f000000
v_mul_f32_e32 v9, v9, v10
v_mul_f32_e32 v9, v9, v6
v_mul_f32_e32 v9, v9, v7
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, s16, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_store_dword v[4:5], v9, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
