.text
k_flash_dec_part_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dwordx2 s[24:25], s[4:5], 0x20
s_load_dwordx2 s[26:27], s[4:5], 0x28
s_load_dword s28, s[4:5], 0x30
s_load_dword s29, s[4:5], 0x34
s_load_dword s30, s[4:5], 0x38
s_load_dword s31, s[4:5], 0x3c
s_load_dword s32, s[4:5], 0x40
s_load_dword s33, s[4:5], 0x44
s_load_dword s39, s[4:5], 0x48
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
v_lshrrev_b32_e32 v3, s32, v2
v_mov_b32_e32 v4, 1
v_lshlrev_b32_e32 v4, s32, v4
v_add_u32_e32 v4, -1, v4
v_and_b32_e32 v4, v4, v2
s_lshr_b32 s34, s30, s32
s_lshr_b32 s38, s34, 6
v_mov_b32_e32 v34, s34
v_mov_b32_e32 v35, s29
v_mov_b32_e32 v36, s31
v_mul_lo_u32 v5, s34, v4
v_mul_lo_u32 v7, v3, s29
v_mul_lo_u32 v7, v7, s31
v_lshlrev_b32_e32 v7, 2, v7
v_mov_b32_e32 v8, s24
v_mov_b32_e32 v9, s25
v_add_co_u32_e32 v8, vcc, v8, v7
v_addc_co_u32_e32 v9, vcc, v9, v1, vcc
v_mul_lo_u32 v7, v3, s29
v_lshlrev_b32_e32 v7, 2, v7
v_mov_b32_e32 v10, s26
v_mov_b32_e32 v11, s27
v_add_co_u32_e32 v10, vcc, v10, v7
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
v_mul_lo_u32 v7, v3, s29
v_lshlrev_b32_e32 v7, 2, v7
v_mov_b32_e32 v12, s22
v_mov_b32_e32 v13, s23
v_add_co_u32_e32 v12, vcc, v12, v7
v_addc_co_u32_e32 v13, vcc, v13, v1, vcc
v_shl_add:
v_lshlrev_b32_e32 v15, s32, v3
v_add_u32_e32 v15, v15, v4
v_mul_lo_u32 v15, v15, s29
v_lshlrev_b32_e32 v15, 2, v15
v_mov_b32_e32 v16, s16
v_mov_b32_e32 v17, s17
v_add_co_u32_e32 v16, vcc, v16, v15
v_addc_co_u32_e32 v17, vcc, v17, v1, vcc
v_lshlrev_b32_e32 v18, 2, v0
v_lshlrev_b32_e32 v41, 2, v34
v_add_u32_e32 v19, v41, v18
s_mov_b32 s42, 1
s_lshl_b32 s42, s42, s32
s_mov_b32 s43, 1
s_sub_u32 s43, s42, s43
s_and_b32 s44, s6, s43
s_mul_i32 s45, s44, s34
s_cmp_lt_u32 s45, s28
s_cbranch_scc0 L_masked
s_sub_u32 s46, s28, s45
s_cmp_lt_u32 s46, s34
s_cbranch_scc1 L_reff_ok
s_mov_b32 s46, s34
L_reff_ok:
s_add_u32 s47, s46, 63
s_lshr_b32 s47, s47, 6
s_mov_b32 s36, 0
L_c1:
s_cmp_lt_u32 s36, s47
s_cbranch_scc0 L_c1_done
v_mov_b32_e32 v20, 0
s_mov_b32 s37, 0
v_mov_b32_e32 v21, s36
v_lshlrev_b32_e32 v21, 6, v21
v_add_u32_e32 v21, v21, v5
v_add_u32_e32 v21, v21, v0
L_d4:
s_add_i32 s41, s37, 8
s_cmp_lt_u32 s41, s29
s_cbranch_scc0 L_d1
v_mov_b32_e32 v60, s37
v_mul_lo_u32 v22, v60, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v44, v[23:24], off
v_lshlrev_b32_e32 v26, 2, v60
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v52, v[27:28], off
v_add_u32_e32 v22, 1, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v45, v[23:24], off
v_add_u32_e32 v26, 1, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v53, v[27:28], off
v_add_u32_e32 v22, 2, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v46, v[23:24], off
v_add_u32_e32 v26, 2, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v54, v[27:28], off
v_add_u32_e32 v22, 3, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v47, v[23:24], off
v_add_u32_e32 v26, 3, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v55, v[27:28], off
v_add_u32_e32 v22, 4, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v48, v[23:24], off
v_add_u32_e32 v26, 4, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v56, v[27:28], off
v_add_u32_e32 v22, 5, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v49, v[23:24], off
v_add_u32_e32 v26, 5, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v57, v[27:28], off
v_add_u32_e32 v22, 6, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v50, v[23:24], off
v_add_u32_e32 v26, 6, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v58, v[27:28], off
v_add_u32_e32 v22, 7, v60
v_mul_lo_u32 v22, v22, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v51, v[23:24], off
v_add_u32_e32 v26, 7, v60
v_lshlrev_b32_e32 v26, 2, v26
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v59, v[27:28], off
s_waitcnt vmcnt(0)
v_fma_f32 v20, v44, v52, v20
v_fma_f32 v20, v45, v53, v20
v_fma_f32 v20, v46, v54, v20
v_fma_f32 v20, v47, v55, v20
v_fma_f32 v20, v48, v56, v20
v_fma_f32 v20, v49, v57, v20
v_fma_f32 v20, v50, v58, v20
v_fma_f32 v20, v51, v59, v20
s_add_i32 s37, s37, 8
s_branch L_d4
L_d1:
s_cmp_lt_u32 s37, s29
s_cbranch_scc0 L_d1_done
v_mov_b32_e32 v40, s37
v_mul_lo_u32 v22, v40, s31
v_add_u32_e32 v22, v22, v21
v_lshlrev_b32_e32 v22, 2, v22
v_mov_b32_e32 v23, v8
v_mov_b32_e32 v24, v9
v_add_co_u32_e32 v23, vcc, v23, v22
v_addc_co_u32_e32 v24, vcc, v24, v1, vcc
global_load_dword v25, v[23:24], off
v_lshlrev_b32_e32 v26, 2, v40
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v28, v13
v_add_co_u32_e32 v27, vcc, v27, v26
v_addc_co_u32_e32 v28, vcc, v28, v1, vcc
global_load_dword v29, v[27:28], off
s_waitcnt vmcnt(0)
v_fma_f32 v20, v25, v29, v20
s_add_i32 s37, s37, 1
s_branch L_d1
L_d1_done:
v_mov_b32_e32 v37, s28
v_cmp_lt_u32_e64 vcc, v21, v37
v_mov_b32_e32 v31, 0xff800000
v_cndmask_b32_e32 v20, v31, v20, vcc
v_mov_b32_e32 v32, s36
v_lshlrev_b32_e32 v32, 6, v32
v_add_u32_e32 v32, v32, v0
v_lshlrev_b32_e32 v32, 2, v32
ds_write_b32 v32, v20
s_add_i32 s36, s36, 1
s_branch L_c1
L_c1_done:
s_waitcnt lgkmcnt(0)
s_barrier
v_mov_b32_e32 v20, 0xff800000
s_mov_b32 s36, 0
L_c2:
s_cmp_lt_u32 s36, s47
s_cbranch_scc0 L_c2_done
v_mov_b32_e32 v32, s36
v_lshlrev_b32_e32 v32, 6, v32
v_add_u32_e32 v32, v32, v0
v_lshlrev_b32_e32 v32, 2, v32
ds_read_b32 v30, v32
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v30
s_add_i32 s36, s36, 1
s_branch L_c2
L_c2_done:
ds_write_b32 v19, v20
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 128
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 64
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 32
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 16
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 8
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 4
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v20, v20, v63
ds_write_b32 v19, v20
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[4:5], vcc
ds_write_b32 v41, v20
s_or_b64 exec, exec, s[4:5]
s_barrier
ds_read_b32 v20, v41
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v31, 0xff800000
v_cmp_eq_f32_e32 vcc, v20, v31
v_mov_b32_e32 v30, 0
v_cndmask_b32_e32 v20, v20, v30, vcc
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v22, 0x3fb8aa3b
v_mov_b32_e32 v23, s33
s_mov_b32 s36, 0
L_c3:
s_cmp_lt_u32 s36, s47
s_cbranch_scc0 L_c3_done
v_mov_b32_e32 v32, s36
v_lshlrev_b32_e32 v32, 6, v32
v_add_u32_e32 v32, v32, v0
v_lshlrev_b32_e32 v32, 2, v32
ds_read_b32 v30, v32
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v30, v30, v20
v_mul_f32_e32 v30, v30, v23
v_mul_f32_e32 v30, v30, v22
s_nop 0
v_exp_f32_e32 v30, v30
s_nop 0
ds_write_b32 v32, v30
v_add_f32_e32 v21, v21, v30
s_add_i32 s36, s36, 1
s_branch L_c3
L_c3_done:
ds_write_b32 v19, v21
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 128
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 64
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 32
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 16
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 8
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v62, 4
v_add_u32_e32 v62, v19, v62
ds_read_b32 v63, v62
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v21, v21, v63
ds_write_b32 v19, v21
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[4:5], vcc
ds_write_b32 v41, v21
s_or_b64 exec, exec, s[4:5]
s_barrier
ds_read_b32 v21, v41
s_waitcnt lgkmcnt(0)
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[4:5], vcc
v_lshlrev_b32_e32 v30, s32, v3
v_add_u32_e32 v30, v30, v4
v_lshlrev_b32_e32 v31, 2, v30
v_mov_b32_e32 v32, s18
v_mov_b32_e32 v33, s19
v_add_co_u32_e32 v32, vcc, v32, v31
v_addc_co_u32_e32 v33, vcc, v33, v1, vcc
global_store_dword v[32:33], v20, off
v_mov_b32_e32 v32, s20
v_mov_b32_e32 v33, s21
v_add_co_u32_e32 v32, vcc, v32, v31
v_addc_co_u32_e32 v33, vcc, v33, v1, vcc
global_store_dword v[32:33], v21, off
s_or_b64 exec, exec, s[4:5]
s_mov_b32 s36, 0
L_i:
s_cmp_lt_u32 s36, s29
s_cbranch_scc0 L_i_done
v_mov_b32_e32 v22, s36
v_add_u32_e32 v22, v22, v0
v_cmp_lt_u32_e64 vcc, v22, v35
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz L_i_next
v_mov_b32_e32 v23, 0
s_mov_b32 s37, 0
L_j4:
s_add_i32 s41, s37, 8
s_cmp_lt_u32 s41, s46
s_cbranch_scc0 L_j
v_mov_b32_e32 v42, s37
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v44, v[26:27], off
ds_read_b32 v54, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 1, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v45, v[26:27], off
ds_read_b32 v55, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 2, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v46, v[26:27], off
ds_read_b32 v56, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 3, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v47, v[26:27], off
ds_read_b32 v57, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 4, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v48, v[26:27], off
ds_read_b32 v58, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 5, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v49, v[26:27], off
ds_read_b32 v59, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 6, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v50, v[26:27], off
ds_read_b32 v60, v24
v_mov_b32_e32 v52, s37
v_add_u32_e32 v42, 7, v52
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v53, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v51, v[26:27], off
ds_read_b32 v61, v24
s_waitcnt vmcnt(0)
v_fma_f32 v23, v44, v54, v23
v_fma_f32 v23, v45, v55, v23
v_fma_f32 v23, v46, v56, v23
v_fma_f32 v23, v47, v57, v23
v_fma_f32 v23, v48, v58, v23
v_fma_f32 v23, v49, v59, v23
v_fma_f32 v23, v50, v60, v23
v_fma_f32 v23, v51, v61, v23
s_add_i32 s37, s37, 8
s_branch L_j4
L_j:
s_cmp_lt_u32 s37, s46
s_cbranch_scc0 L_j_done
v_mov_b32_e32 v42, s37
v_lshlrev_b32_e32 v24, 2, v42
ds_read_b32 v30, v24
v_add_u32_e32 v25, v5, v42
v_mul_lo_u32 v25, v25, s39
v_add_u32_e32 v25, v25, v22
v_lshlrev_b32_e32 v25, 2, v25
v_mov_b32_e32 v26, v10
v_mov_b32_e32 v27, v11
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_load_dword v31, v[26:27], off
s_waitcnt vmcnt(0)
v_fma_f32 v23, v30, v31, v23
s_add_i32 s37, s37, 1
s_branch L_j
L_j_done:
v_lshlrev_b32_e32 v25, 2, v22
v_mov_b32_e32 v26, v16
v_mov_b32_e32 v27, v17
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
global_store_dword v[26:27], v23, off
L_i_next:
s_or_b64 exec, exec, s[6:7]
s_add_i32 s36, s36, 64
s_branch L_i
L_i_done:
s_endpgm
L_masked:
v_mov_b32_e32 v20, 0xff800000
v_mov_b32_e32 v21, 0
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[4:5], vcc
v_lshlrev_b32_e32 v30, s32, v3
v_add_u32_e32 v30, v30, v4
v_lshlrev_b32_e32 v31, 2, v30
v_mov_b32_e32 v32, s18
v_mov_b32_e32 v33, s19
v_add_co_u32_e32 v32, vcc, v32, v31
v_addc_co_u32_e32 v33, vcc, v33, v1, vcc
global_store_dword v[32:33], v20, off
v_mov_b32_e32 v32, s20
v_mov_b32_e32 v33, s21
v_add_co_u32_e32 v32, vcc, v32, v31
v_addc_co_u32_e32 v33, vcc, v33, v1, vcc
global_store_dword v[32:33], v21, off
s_or_b64 exec, exec, s[4:5]
s_mov_b32 s36, 0
L_mz:
s_cmp_lt_u32 s36, s29
s_cbranch_scc0 L_mz_done
v_mov_b32_e32 v22, s36
v_add_u32_e32 v22, v22, v0
v_cmp_lt_u32_e64 vcc, v22, v35
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz L_mz_next
v_lshlrev_b32_e32 v25, 2, v22
v_mov_b32_e32 v26, v16
v_mov_b32_e32 v27, v17
v_add_co_u32_e32 v26, vcc, v26, v25
v_addc_co_u32_e32 v27, vcc, v27, v1, vcc
v_mov_b32_e32 v23, 0
global_store_dword v[26:27], v23, off
L_mz_next:
s_or_b64 exec, exec, s[6:7]
s_add_i32 s36, s36, 64
s_branch L_mz
L_mz_done:
s_endpgm
