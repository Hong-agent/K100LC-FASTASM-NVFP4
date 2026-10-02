.text
k_block_exp_sum_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s28, s[4:5], 0x20
s_load_dword s29, s[4:5], 0x24
s_load_dword s31, s[4:5], 0x28
s_waitcnt lgkmcnt(0)
s_lshl_b32 s24, s28, 2
s_lshr_b32 s24, s24, s29
s_add_i32 s30, s29, 8
s_lshr_b32 s25, s28, s30
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s24
v_lshlrev_b32_e32 v2, 4, v0
v_add_u32_e32 v1, v1, v2
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v5, s21
v_add_co_u32_e32 v4, vcc, s20, v1
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, s18, v1
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v17, s22
v_mov_b32_e32 v18, s23
global_load_dword v9, v[17:18], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v10, s31
v_mov_b32_e32 v16, 0x3fb8aa3b
v_mov_b32_e32 v15, 1024
s_mov_b32 s26, 0
L_exp:
s_cmp_lt_u32 s26, s25
s_cbranch_scc0 L_done
global_load_dwordx4 v[20:23], v[4:5], off
s_waitcnt vmcnt(0)
v_sub_f32_e32 v20, v20, v9
v_mul_f32_e32 v20, v20, v10
v_mul_f32_e32 v20, v20, v16
s_nop 0
v_exp_f32_e32 v20, v20
s_nop 0
v_add_f32_e32 v8, v8, v20
v_sub_f32_e32 v21, v21, v9
v_mul_f32_e32 v21, v21, v10
v_mul_f32_e32 v21, v21, v16
s_nop 0
v_exp_f32_e32 v21, v21
s_nop 0
v_add_f32_e32 v8, v8, v21
v_sub_f32_e32 v22, v22, v9
v_mul_f32_e32 v22, v22, v10
v_mul_f32_e32 v22, v22, v16
s_nop 0
v_exp_f32_e32 v22, v22
s_nop 0
v_add_f32_e32 v8, v8, v22
v_sub_f32_e32 v23, v23, v9
v_mul_f32_e32 v23, v23, v10
v_mul_f32_e32 v23, v23, v16
s_nop 0
v_exp_f32_e32 v23, v23
s_nop 0
v_add_f32_e32 v8, v8, v23
global_store_dwordx4 v[6:7], v[20:23], off
v_add_co_u32_e32 v4, vcc, v4, v15
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_add_co_u32_e32 v6, vcc, v6, v15
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
s_add_i32 s26, s26, 1
s_branch L_exp
L_done:
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
v_mov_b32_e32 v12, s6
v_lshlrev_b32_e32 v12, 2, v12
v_mov_b32_e32 v13, s17
v_mov_b32_e32 v14, 0
v_add_co_u32_e32 v12, vcc, s16, v12
v_addc_co_u32_e32 v13, vcc, v13, v14, vcc
global_store_dword v[12:13], v8, off
s_or_b64 exec, exec, s[2:3]
s_endpgm
