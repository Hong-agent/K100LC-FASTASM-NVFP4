.text
k_gemv_f32_gated_acc_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s26, s[4:5], 0x20
s_load_dword s27, s[4:5], 0x24
s_waitcnt lgkmcnt(0)
s_cmp_ge_u32 s6, s26
s_cbranch_scc1 L_end
v_mov_b32_e32 v1, s6
v_mov_b32_e32 v2, s27
v_lshlrev_b32_e32 v2, 2, v2
v_mul_lo_u32 v1, v1, v2
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v1
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_mov_b32_e32 v18, s20
v_mov_b32_e32 v19, s21
v_mov_b32_e32 v8, 0
v_lshlrev_b32_e32 v9, 2, v0
v_mov_b32_e32 v10, 256
v_mov_b32_e32 v20, 0x3fb8aa3b
v_mul_f32_e32 v20, -1.0, v20
v_mov_b32_e32 v21, 1.0
s_lshr_b32 s28, s27, 6
s_mov_b32 s29, 0
L_loop:
v_add_co_u32_e32 v12, vcc, v4, v9
v_addc_co_u32_e32 v13, vcc, v5, v3, vcc
global_load_dword v14, v[12:13], off
v_add_co_u32_e32 v12, vcc, v6, v9
v_addc_co_u32_e32 v13, vcc, v7, v3, vcc
global_load_dword v15, v[12:13], off
v_add_co_u32_e32 v16, vcc, v18, v9
v_addc_co_u32_e32 v17, vcc, v19, v3, vcc
global_load_dword v22, v[16:17], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v23, v15, v20
s_nop 0
v_exp_f32_e32 v23, v23
s_nop 0
v_add_f32_e32 v23, v21, v23
s_nop 0
v_rcp_f32_e32 v23, v23
s_nop 0
v_mul_f32_e32 v23, v23, v15
v_mul_f32_e32 v23, v23, v22
v_fma_f32 v8, v14, v23, v8
v_add_u32_e32 v9, v10, v9
s_add_i32 s29, s29, 1
s_cmp_lt_u32 s29, s28
s_cbranch_scc1 L_loop
v_lshlrev_b32_e32 v11, 2, v0
ds_write_b32 v11, v8
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 128
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 64
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 32
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 16
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 8
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 4
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v16, s6
v_lshlrev_b32_e32 v16, 2, v16
v_mov_b32_e32 v17, s23
v_add_co_u32_e32 v16, vcc, s22, v16
v_addc_co_u32_e32 v17, vcc, v17, v3, vcc
v_mov_b32_e32 v11, 0
ds_read_b32 v18, v11
s_waitcnt lgkmcnt(0)
global_load_dword v24, v[16:17], off
s_waitcnt vmcnt(0)
v_add_f32_e32 v18, v18, v24
global_store_dword v[16:17], v18, off
s_or_b64 exec, exec, s[2:3]
L_end:
s_endpgm
