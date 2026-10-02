.text
k_div_scalar_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, 64
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s20, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_lshlrev_b32_e32 v2, 2, v1
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v9, s18
v_mov_b32_e32 v10, s19
global_load_dword v6, v[9:10], off
s_waitcnt vmcnt(0)
s_nop 0
v_rcp_f32_e32 v7, v6
s_nop 0
global_load_dword v8, v[4:5], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v8, v8, v7
global_store_dword v[4:5], v8, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
