.text
k_reduce_blocks_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_load_dword s21, s[4:5], 0x14
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, 64
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s20, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mul_lo_u32 v2, v1, s21
v_lshlrev_b32_e32 v2, 2, v2
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v8, 4
s_mov_b32 s22, 0
L_loop:
s_cmp_lt_u32 s22, s21
s_cbranch_scc0 L_done
global_load_dword v7, v[4:5], off
s_waitcnt vmcnt(0)
v_add_f32_e32 v6, v6, v7
v_add_co_u32_e32 v4, vcc, v4, v8
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
s_add_i32 s22, s22, 1
s_branch L_loop
L_done:
v_lshlrev_b32_e32 v9, 2, v1
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v10, vcc, s18, v9
v_addc_co_u32_e32 v11, vcc, v11, v3, vcc
global_store_dword v[10:11], v6, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
