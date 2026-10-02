.text
k_gather_rows_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
s_cmp_lt_u32 s6, s22
s_cbranch_scc0 L_end
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v24, 256
v_mov_b32_e32 v1, s6
v_lshlrev_b32_e32 v1, 2, v1
v_mov_b32_e32 v2, s20
v_mov_b32_e32 v3, s21
v_add_co_u32_e32 v2, vcc, v2, v1
v_addc_co_u32_e32 v3, vcc, v3, v8, vcc
global_load_dword v4, v[2:3], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v5, s6
v_mul_lo_u32 v5, v5, s23
v_lshlrev_b32_e32 v5, 2, v5
v_mov_b32_e32 v6, s16
v_mov_b32_e32 v7, s17
v_add_co_u32_e32 v6, vcc, v6, v5
v_addc_co_u32_e32 v7, vcc, v7, v8, vcc
v_mul_lo_u32 v9, v4, s23
v_lshlrev_b32_e32 v9, 2, v9
v_mov_b32_e32 v10, s18
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v10, vcc, v10, v9
v_addc_co_u32_e32 v11, vcc, v11, v8, vcc
v_lshlrev_b32_e32 v12, 2, v0
L_loop:
v_cmp_gt_u32_e32 vcc, s23, v12
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_next
v_lshlrev_b32_e32 v13, 2, v12
v_mov_b32_e32 v14, v10
v_mov_b32_e32 v15, v11
v_add_co_u32_e32 v14, vcc, v14, v13
v_addc_co_u32_e32 v15, vcc, v15, v16, vcc
global_load_dwordx4 v[20:23], v[14:15], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v14, v6
v_mov_b32_e32 v15, v7
v_add_co_u32_e32 v14, vcc, v14, v13
v_addc_co_u32_e32 v15, vcc, v15, v16, vcc
global_store_dwordx4 v[14:15], v[20:23], off
L_next:
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v12, v12, v24
v_cmp_gt_u32_e32 vcc, s23, v12
s_cbranch_vccnz L_loop
L_end:
s_endpgm
