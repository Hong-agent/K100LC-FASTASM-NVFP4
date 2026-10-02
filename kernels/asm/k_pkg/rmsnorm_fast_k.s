.text
k_rmsnorm_fast_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
s_lshr_b32 s24, s22, 6
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
v_mul_lo_u32 v3, v2, s22
v_lshlrev_b32_e32 v3, 2, v3
v_mov_b32_e32 v4, s18
v_mov_b32_e32 v5, s19
v_add_co_u32_e32 v4, vcc, v4, v3
v_addc_co_u32_e32 v5, vcc, v5, v1, vcc
v_mov_b32_e32 v6, s16
v_mov_b32_e32 v7, s17
v_add_co_u32_e32 v6, vcc, v6, v3
v_addc_co_u32_e32 v7, vcc, v7, v1, vcc
v_lshlrev_b32_e32 v8, 2, v0
v_mov_b32_e32 v16, 0
s_mov_b32 s25, 0
L_sb:
s_add_i32 s26, s25, 3
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_s1
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_dword v12, v[10:11], off offset:0
global_load_dword v13, v[10:11], off offset:256
global_load_dword v14, v[10:11], off offset:512
global_load_dword v15, v[10:11], off offset:768
s_waitcnt vmcnt(0)
v_fma_f32 v16, v12, v12, v16
v_fma_f32 v16, v13, v13, v16
v_fma_f32 v16, v14, v14, v16
v_fma_f32 v16, v15, v15, v16
s_add_i32 s25, s25, 4
s_branch L_sb
L_s1:
s_cmp_lt_u32 s25, s24
s_cbranch_scc0 L_s1_done
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_dword v12, v[10:11], off
s_waitcnt vmcnt(0)
v_fma_f32 v16, v12, v12, v16
s_add_i32 s25, s25, 1
s_branch L_s1
L_s1_done:
ds_write_b32 v8, v16
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 128
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 64
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 32
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 16
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 8
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 4
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 256
ds_write_b32 v9, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_mov_b32_e32 v9, 256
ds_read_b32 v17, v9
s_waitcnt lgkmcnt(0)
v_cvt_f32_u32_e32 v18, s22
s_nop 0
v_rcp_f32_e32 v18, v18
s_nop 0
v_mul_f32_e32 v17, v17, v18
v_mov_b32_e32 v19, s23
v_add_f32_e32 v17, v17, v19
s_nop 0
v_rsq_f32_e32 v17, v17
s_nop 0
s_mov_b32 s25, 0
L_nb:
s_add_i32 s26, s25, 3
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_n1
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
v_mov_b32_e32 v19, s21
v_add_co_u32_e32 v18, vcc, s20, v9
v_addc_co_u32_e32 v19, vcc, v19, v1, vcc
v_mov_b32_e32 v25, v7
v_add_co_u32_e32 v24, vcc, v6, v9
v_addc_co_u32_e32 v25, vcc, v25, v1, vcc
global_load_dword v12, v[10:11], off offset:0
global_load_dword v13, v[10:11], off offset:256
global_load_dword v14, v[10:11], off offset:512
global_load_dword v15, v[10:11], off offset:768
global_load_dword v20, v[18:19], off offset:0
global_load_dword v21, v[18:19], off offset:256
global_load_dword v22, v[18:19], off offset:512
global_load_dword v23, v[18:19], off offset:768
s_waitcnt vmcnt(0)
v_mul_f32_e32 v12, v12, v17
v_mul_f32_e32 v13, v13, v17
v_mul_f32_e32 v14, v14, v17
v_mul_f32_e32 v15, v15, v17
v_mul_f32_e32 v12, v12, v20
v_mul_f32_e32 v13, v13, v21
v_mul_f32_e32 v14, v14, v22
v_mul_f32_e32 v15, v15, v23
global_store_dword v[24:25], v12, off offset:0
global_store_dword v[24:25], v13, off offset:256
global_store_dword v[24:25], v14, off offset:512
global_store_dword v[24:25], v15, off offset:768
s_add_i32 s25, s25, 4
s_branch L_nb
L_n1:
s_cmp_lt_u32 s25, s24
s_cbranch_scc0 L_n1_done
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
v_mov_b32_e32 v19, s21
v_add_co_u32_e32 v18, vcc, s20, v9
v_addc_co_u32_e32 v19, vcc, v19, v1, vcc
v_mov_b32_e32 v25, v7
v_add_co_u32_e32 v24, vcc, v6, v9
v_addc_co_u32_e32 v25, vcc, v25, v1, vcc
global_load_dword v12, v[10:11], off
global_load_dword v20, v[18:19], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v12, v12, v17
v_mul_f32_e32 v12, v12, v20
global_store_dword v[24:25], v12, off
s_add_i32 s25, s25, 1
s_branch L_n1
L_n1_done:
s_endpgm
