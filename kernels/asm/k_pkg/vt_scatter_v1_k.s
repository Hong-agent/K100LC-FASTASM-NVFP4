.text
k_vt_scatter_v1_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
v_lshlrev_b32_e32 v2, 6, v2
v_add_u32_e32 v2, v2, v0
v_mov_b32_e32 v3, s24
v_cmp_lt_u32_e64 vcc, v2, v3
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_lshlrev_b32_e32 v4, 2, v2
v_mov_b32_e32 v5, s20
v_mov_b32_e32 v6, s21
v_add_co_u32_e32 v5, vcc, v5, v4
v_addc_co_u32_e32 v6, vcc, v6, v1, vcc
global_load_dword v7, v[5:6], off
v_mov_b32_e32 v5, s22
v_mov_b32_e32 v6, s23
v_add_co_u32_e32 v5, vcc, v5, v4
v_addc_co_u32_e32 v6, vcc, v6, v1, vcc
global_load_dword v8, v[5:6], off
s_waitcnt vmcnt(0)
v_mul_lo_u32 v9, v2, s25
v_mov_b32_e32 v15, s26
v_add_u32_e32 v9, v9, v15
v_lshlrev_b32_e32 v9, 2, v9
v_mov_b32_e32 v10, s16
v_mov_b32_e32 v11, s17
v_add_co_u32_e32 v10, vcc, v10, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_store_dword v[10:11], v7, off
s_mul_i32 s27, s26, s24
v_mov_b32_e32 v15, s27
v_add_u32_e32 v12, v15, v2
v_lshlrev_b32_e32 v12, 2, v12
v_mov_b32_e32 v13, s18
v_mov_b32_e32 v14, s19
v_add_co_u32_e32 v13, vcc, v13, v12
v_addc_co_u32_e32 v14, vcc, v14, v1, vcc
global_store_dword v[13:14], v8, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
