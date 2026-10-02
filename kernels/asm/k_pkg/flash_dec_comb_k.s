.text
k_flash_dec_comb_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s28, s[4:5], 0x20
s_load_dword s29, s[4:5], 0x24
s_load_dword s30, s[4:5], 0x28
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
v_mov_b32_e32 v25, s28
v_cmp_lt_u32_e64 vcc, v0, v25
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mul_lo_u32 v4, v2, s29
v_lshlrev_b32_e32 v5, 2, v4
v_mov_b32_e32 v6, s20
v_mov_b32_e32 v7, s21
v_add_co_u32_e32 v6, vcc, v6, v5
v_addc_co_u32_e32 v7, vcc, v7, v1, vcc
v_mov_b32_e32 v3, 0xff800000
s_mov_b32 s31, 0
L_m:
s_cmp_lt_u32 s31, s29
s_cbranch_scc0 L_m_done
s_add_i32 s33, s31, 3
s_cmp_lt_u32 s33, s29
s_cbranch_scc0 L_m_one
v_mov_b32_e32 v4, s31
v_lshlrev_b32_e32 v4, 2, v4
v_add_co_u32_e32 v8, vcc, v6, v4
v_addc_co_u32_e32 v9, vcc, v7, v1, vcc
global_load_dword v12, v[8:9], off offset:0
global_load_dword v13, v[8:9], off offset:4
global_load_dword v14, v[8:9], off offset:8
global_load_dword v15, v[8:9], off offset:12
s_waitcnt vmcnt(0)
v_max_f32_e32 v3, v3, v12
v_max_f32_e32 v3, v3, v13
v_max_f32_e32 v3, v3, v14
v_max_f32_e32 v3, v3, v15
s_add_i32 s31, s31, 4
s_branch L_m
L_m_one:
v_mov_b32_e32 v4, s31
v_lshlrev_b32_e32 v4, 2, v4
v_add_co_u32_e32 v8, vcc, v6, v4
v_addc_co_u32_e32 v9, vcc, v7, v1, vcc
global_load_dword v12, v[8:9], off
s_waitcnt vmcnt(0)
v_max_f32_e32 v3, v3, v12
s_add_i32 s31, s31, 1
s_branch L_m
L_m_done:
v_mov_b32_e32 v10, 0x3fb8aa3b
v_mov_b32_e32 v11, s30
s_mov_b32 s32, 0
L_i:
s_cmp_lt_u32 s32, s28
s_cbranch_scc0 L_i_done
v_mov_b32_e32 v20, s32
v_add_u32_e32 v20, v20, v0
v_mov_b32_e32 v25, s28
v_cmp_lt_u32_e64 vcc, v20, v25
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz L_i_next
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v9, 0
s_mov_b32 s31, 0
L_s:
s_cmp_lt_u32 s31, s29
s_cbranch_scc0 L_s_done
s_add_i32 s33, s31, 3
s_cmp_lt_u32 s33, s29
s_cbranch_scc0 L_s_one
v_mul_lo_u32 v25, v2, s29
v_mov_b32_e32 v27, s31
v_add_u32_e32 v25, v25, v27
v_lshlrev_b32_e32 v26, 2, v25
v_mov_b32_e32 v28, s20
v_mov_b32_e32 v29, s21
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v12, v[28:29], off offset:0
global_load_dword v13, v[28:29], off offset:4
global_load_dword v14, v[28:29], off offset:8
global_load_dword v15, v[28:29], off offset:12
v_mov_b32_e32 v28, s22
v_mov_b32_e32 v29, s23
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v16, v[28:29], off offset:0
global_load_dword v17, v[28:29], off offset:4
global_load_dword v18, v[28:29], off offset:8
global_load_dword v19, v[28:29], off offset:12
v_mul_lo_u32 v26, v25, s28
v_add_u32_e32 v26, v26, v20
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, s28
v_lshlrev_b32_e32 v27, 2, v27
v_mov_b32_e32 v28, s18
v_mov_b32_e32 v29, s19
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v21, v[28:29], off
v_add_u32_e32 v28, v28, v27
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v22, v[28:29], off
v_add_u32_e32 v28, v28, v27
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v23, v[28:29], off
v_add_u32_e32 v28, v28, v27
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v24, v[28:29], off
s_waitcnt vmcnt(0)
v_sub_f32_e32 v30, v12, v3
v_mul_f32_e32 v30, v30, v11
v_mul_f32_e32 v30, v30, v10
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
v_fma_f32 v8, v30, v21, v8
v_fma_f32 v9, v30, v16, v9
v_sub_f32_e32 v30, v13, v3
v_mul_f32_e32 v30, v30, v11
v_mul_f32_e32 v30, v30, v10
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
v_fma_f32 v8, v30, v22, v8
v_fma_f32 v9, v30, v17, v9
v_sub_f32_e32 v30, v14, v3
v_mul_f32_e32 v30, v30, v11
v_mul_f32_e32 v30, v30, v10
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
v_fma_f32 v8, v30, v23, v8
v_fma_f32 v9, v30, v18, v9
v_sub_f32_e32 v30, v15, v3
v_mul_f32_e32 v30, v30, v11
v_mul_f32_e32 v30, v30, v10
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
v_fma_f32 v8, v30, v24, v8
v_fma_f32 v9, v30, v19, v9
s_add_i32 s31, s31, 4
s_branch L_s
L_s_one:
v_mul_lo_u32 v25, v2, s29
v_mov_b32_e32 v27, s31
v_add_u32_e32 v25, v25, v27
v_lshlrev_b32_e32 v26, 2, v25
v_mov_b32_e32 v28, s20
v_mov_b32_e32 v29, s21
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v12, v[28:29], off
v_mov_b32_e32 v28, s22
v_mov_b32_e32 v29, s23
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v16, v[28:29], off
v_mul_lo_u32 v26, v25, s28
v_add_u32_e32 v26, v26, v20
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v28, s18
v_mov_b32_e32 v29, s19
v_add_co_u32_e32 v28, vcc, v28, v26
v_addc_co_u32_e32 v29, vcc, v29, v1, vcc
global_load_dword v21, v[28:29], off
s_waitcnt vmcnt(0)
v_sub_f32_e32 v30, v12, v3
v_mul_f32_e32 v30, v30, v11
v_mul_f32_e32 v30, v30, v10
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
v_fma_f32 v8, v30, v21, v8
v_fma_f32 v9, v30, v16, v9
s_add_i32 s31, s31, 1
s_branch L_s
L_s_done:
s_nop 0
v_rcp_f32_e32 v19, v9
s_nop 0
v_mul_f32_e32 v21, v8, v19
v_mul_lo_u32 v22, v2, s28
v_add_u32_e32 v22, v22, v20
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, s16
v_mov_b32_e32 v24, s17
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_store_dword v[23:24], v21, off
L_i_next:
s_or_b64 exec, exec, s[6:7]
s_add_i32 s32, s32, 64
s_branch L_i
L_i_done:
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
