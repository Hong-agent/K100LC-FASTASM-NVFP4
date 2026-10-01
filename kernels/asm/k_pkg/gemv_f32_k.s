.text
k_gemv_f32_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s24
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v2, s23
v_lshlrev_b32_e32 v2, 4, v2
v_mul_lo_u32 v2, v1, v2
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_lshlrev_b32_e32 v44, 2, v1
v_mov_b32_e32 v45, s21
v_add_co_u32_e32 v44, vcc, s20, v44
v_addc_co_u32_e32 v45, vcc, v45, v3, vcc
v_mov_b32_e32 v46, 16
s_mov_b32 s25, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v23, 0
L_loop:
global_load_dwordx4 v[24:27], v[4:5], off
global_load_dwordx4 v[28:31], v[6:7], off
s_waitcnt vmcnt(0)
v_fma_f32 v20, v24, v28, v20
v_fma_f32 v21, v25, v29, v21
v_fma_f32 v22, v26, v30, v22
v_fma_f32 v23, v27, v31, v23
v_add_co_u32_e32 v4, vcc, v4, v46
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_add_co_u32_e32 v6, vcc, v6, v46
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
s_add_i32 s25, s25, 1
s_cmp_lt_u32 s25, s23
s_cbranch_scc1 L_loop
v_add_f32_e32 v20, v20, v21
v_add_f32_e32 v22, v22, v23
v_add_f32_e32 v20, v20, v22
global_store_dword v[44:45], v20, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
