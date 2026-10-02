.text
k_block_max_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_load_dword s21, s[4:5], 0x14
s_waitcnt lgkmcnt(0)
s_lshl_b32 s22, s20, 2
s_lshr_b32 s22, s22, s21
s_add_i32 s24, s21, 8
s_lshr_b32 s23, s20, s24
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s22
v_lshlrev_b32_e32 v2, 4, v0
v_add_u32_e32 v1, v1, v2
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v5, s19
v_add_co_u32_e32 v4, vcc, s18, v1
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v8, 0xff800000
v_mov_b32_e32 v10, 1024
s_mov_b32 s26, 0
L_max:
s_cmp_lt_u32 s26, s23
s_cbranch_scc0 L_done
global_load_dwordx4 v[20:23], v[4:5], off
s_waitcnt vmcnt(0)
v_max_f32_e32 v20, v20, v21
v_max_f32_e32 v22, v22, v23
v_max_f32_e32 v20, v20, v22
v_max_f32_e32 v8, v8, v20
v_add_co_u32_e32 v4, vcc, v4, v10
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
s_add_i32 s26, s26, 1
s_branch L_max
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
v_mov_b32_e32 v12, s6
v_lshlrev_b32_e32 v12, 2, v12
v_mov_b32_e32 v13, s17
v_mov_b32_e32 v14, 0
v_add_co_u32_e32 v12, vcc, s16, v12
v_addc_co_u32_e32 v13, vcc, v13, v14, vcc
global_store_dword v[12:13], v8, off
s_or_b64 exec, exec, s[2:3]
s_endpgm
