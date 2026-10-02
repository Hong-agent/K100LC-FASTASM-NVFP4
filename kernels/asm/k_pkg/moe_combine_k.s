.text
k_moe_combine_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_waitcnt lgkmcnt(0)
s_cmp_lt_u32 s6, s23
s_cbranch_scc0 L_end
s_mul_i32 s25, s23, s24
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v15, 64
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s22
v_lshlrev_b32_e32 v1, 2, v1
v_mov_b32_e32 v2, s6
v_mul_lo_u32 v2, v2, s24
v_lshlrev_b32_e32 v2, 2, v2
v_mov_b32_e32 v3, s16
v_mov_b32_e32 v4, s17
v_add_co_u32_e32 v3, vcc, v3, v2
v_addc_co_u32_e32 v4, vcc, v4, v7, vcc
v_mov_b32_e32 v5, s18
v_mov_b32_e32 v6, s19
v_add_co_u32_e32 v5, vcc, v5, v2
v_addc_co_u32_e32 v6, vcc, v6, v7, vcc
v_mov_b32_e32 v8, v0
L_d:
v_cmp_gt_u32_e32 vcc, s24, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_dend
v_mov_b32_e32 v9, 0
s_mov_b32 s26, 0
L_e:
s_cmp_lt_u32 s26, s22
s_cbranch_scc0 L_estore
v_mov_b32_e32 v10, s26
v_lshlrev_b32_e32 v10, 2, v10
v_add_u32_e32 v10, v1, v10
v_mov_b32_e32 v11, s20
v_mov_b32_e32 v12, s21
v_add_co_u32_e32 v11, vcc, v11, v10
v_addc_co_u32_e32 v12, vcc, v12, v7, vcc
global_load_dword v13, v[11:12], off
v_mov_b32_e32 v14, s26
v_mul_lo_u32 v14, v14, s25
v_add_u32_e32 v14, v14, v8
v_lshlrev_b32_e32 v14, 2, v14
v_mov_b32_e32 v11, v5
v_mov_b32_e32 v12, v6
v_add_co_u32_e32 v11, vcc, v11, v14
v_addc_co_u32_e32 v12, vcc, v12, v7, vcc
global_load_dword v14, v[11:12], off
s_waitcnt vmcnt(0)
v_fma_f32 v9, v13, v14, v9
s_add_i32 s26, s26, 1
s_branch L_e
L_estore:
v_lshlrev_b32_e32 v10, 2, v8
v_mov_b32_e32 v11, v3
v_mov_b32_e32 v12, v4
v_add_co_u32_e32 v11, vcc, v11, v10
v_addc_co_u32_e32 v12, vcc, v12, v7, vcc
global_store_dword v[11:12], v9, off
L_dend:
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v8, v8, v15
v_cmp_gt_u32_e32 vcc, s24, v8
s_cbranch_vccnz L_d
L_end:
s_endpgm
