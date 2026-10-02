.text
k_softmax_vec_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_load_dword s21, s[4:5], 0x14
v_mov_b32_e32 v1, 0
s_waitcnt lgkmcnt(0)
s_lshr_b32 s22, s21, 8
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s21
v_lshlrev_b32_e32 v1, 2, v1
v_mov_b32_e32 v5, s19
v_add_co_u32_e32 v4, vcc, s18, v1
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v7, s17
v_add_co_u32_e32 v6, vcc, s16, v1
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_lshlrev_b32_e32 v9, 4, v0
v_mov_b32_e32 v8, 0xff800000
s_mov_b32 s23, 0
L_max:
v_mov_b32_e32 v10, s23
v_lshlrev_b32_e32 v10, 10, v10
v_add_u32_e32 v10, v10, v9
v_mov_b32_e32 v12, s19
v_add_co_u32_e32 v11, vcc, s18, v10
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
v_mov_b32_e32 v12, v5
v_add_co_u32_e32 v11, vcc, v4, v10
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
global_load_dwordx4 v[20:23], v[11:12], off
s_waitcnt vmcnt(0)
v_max_f32_e32 v20, v20, v21
v_max_f32_e32 v22, v22, v23
v_max_f32_e32 v20, v20, v22
v_max_f32_e32 v8, v8, v20
s_add_i32 s23, s23, 1
s_cmp_lt_u32 s23, s22
s_cbranch_scc1 L_max
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
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 64
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 32
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 16
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 8
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 4
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v16, 256
ds_write_b32 v16, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_mov_b32_e32 v16, 256
ds_read_b32 v14, v16
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v17, 0x3fb8aa3b
s_mov_b32 s23, 0
L_exp:
v_mov_b32_e32 v10, s23
v_lshlrev_b32_e32 v10, 10, v10
v_add_u32_e32 v10, v10, v9
v_mov_b32_e32 v12, v5
v_add_co_u32_e32 v11, vcc, v4, v10
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
global_load_dwordx4 v[20:23], v[11:12], off
s_waitcnt vmcnt(0)
v_sub_f32_e32 v20, v20, v14
v_mul_f32_e32 v20, v20, v17
s_nop 0
v_exp_f32_e32 v20, v20
v_sub_f32_e32 v21, v21, v14
v_mul_f32_e32 v21, v21, v17
s_nop 0
v_exp_f32_e32 v21, v21
v_sub_f32_e32 v22, v22, v14
v_mul_f32_e32 v22, v22, v17
s_nop 0
v_exp_f32_e32 v22, v22
v_sub_f32_e32 v23, v23, v14
v_mul_f32_e32 v23, v23, v17
s_nop 0
v_exp_f32_e32 v23, v23
v_add_f32_e32 v15, v15, v20
v_add_f32_e32 v15, v15, v21
v_add_f32_e32 v15, v15, v22
v_add_f32_e32 v15, v15, v23
v_mov_b32_e32 v12, v7
v_add_co_u32_e32 v11, vcc, v6, v10
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
global_store_dwordx4 v[11:12], v[20:23], off
s_add_i32 s23, s23, 1
s_cmp_lt_u32 s23, s22
s_cbranch_scc1 L_exp
v_lshlrev_b32_e32 v11, 2, v0
ds_write_b32 v11, v15
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 128
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 64
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 32
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 16
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 8
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 4
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v18
ds_write_b32 v11, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v16, 260
ds_write_b32 v16, v15
s_or_b64 exec, exec, s[2:3]
s_barrier
v_mov_b32_e32 v16, 260
ds_read_b32 v15, v16
s_waitcnt lgkmcnt(0)
s_nop 0
v_rcp_f32_e32 v17, v15
s_nop 0
s_mov_b32 s23, 0
L_norm:
v_mov_b32_e32 v10, s23
v_lshlrev_b32_e32 v10, 10, v10
v_add_u32_e32 v10, v10, v9
v_mov_b32_e32 v12, v7
v_add_co_u32_e32 v11, vcc, v6, v10
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
global_load_dwordx4 v[20:23], v[11:12], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v20, v20, v17
v_mul_f32_e32 v21, v21, v17
v_mul_f32_e32 v22, v22, v17
v_mul_f32_e32 v23, v23, v17
global_store_dwordx4 v[11:12], v[20:23], off
s_add_i32 s23, s23, 1
s_cmp_lt_u32 s23, s22
s_cbranch_scc1 L_norm
s_endpgm
