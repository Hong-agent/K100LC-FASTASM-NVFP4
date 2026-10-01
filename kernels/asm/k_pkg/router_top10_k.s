.text
k_router_top10_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v38, 0
v_mov_b32_e32 v1, s6
v_lshlrev_b32_e32 v1, 6, v1
v_add_u32_e32 v1, v1, v0
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v3, s23
v_mul_lo_u32 v2, v1, v3
v_lshlrev_b32_e32 v2, 2, v2
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, s16, v2
v_addc_co_u32_e32 v5, vcc, v5, v38, vcc
v_mov_b32_e32 v10, 0xff800000
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v11, 0xff800000
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v12, 0xff800000
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v13, 0xff800000
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v14, 0xff800000
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v15, 0xff800000
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v16, 0xff800000
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v17, 0xff800000
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v18, 0xff800000
v_mov_b32_e32 v28, 0
v_mov_b32_e32 v19, 0xff800000
v_mov_b32_e32 v29, 0
s_mov_b32 s24, 0
L_col:
s_cmp_lt_u32 s24, s23
s_cbranch_scc0 L_done_col
v_mov_b32_e32 v7, s24
v_lshlrev_b32_e32 v7, 2, v7
v_mov_b32_e32 v251, v5
v_add_co_u32_e32 v250, vcc, v4, v7
v_addc_co_u32_e32 v251, vcc, v251, v38, vcc
global_load_dword v6, v[250:251], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v7, s24
v_cmp_lt_f32_e32 vcc, v10, v6
v_cndmask_b32_e32 v8, v10, v6, vcc
v_cndmask_b32_e32 v6, v6, v10, vcc
v_mov_b32_e32 v10, v8
v_cndmask_b32_e32 v9, v20, v7, vcc
v_cndmask_b32_e32 v7, v7, v20, vcc
v_mov_b32_e32 v20, v9
v_cmp_lt_f32_e32 vcc, v11, v6
v_cndmask_b32_e32 v8, v11, v6, vcc
v_cndmask_b32_e32 v6, v6, v11, vcc
v_mov_b32_e32 v11, v8
v_cndmask_b32_e32 v9, v21, v7, vcc
v_cndmask_b32_e32 v7, v7, v21, vcc
v_mov_b32_e32 v21, v9
v_cmp_lt_f32_e32 vcc, v12, v6
v_cndmask_b32_e32 v8, v12, v6, vcc
v_cndmask_b32_e32 v6, v6, v12, vcc
v_mov_b32_e32 v12, v8
v_cndmask_b32_e32 v9, v22, v7, vcc
v_cndmask_b32_e32 v7, v7, v22, vcc
v_mov_b32_e32 v22, v9
v_cmp_lt_f32_e32 vcc, v13, v6
v_cndmask_b32_e32 v8, v13, v6, vcc
v_cndmask_b32_e32 v6, v6, v13, vcc
v_mov_b32_e32 v13, v8
v_cndmask_b32_e32 v9, v23, v7, vcc
v_cndmask_b32_e32 v7, v7, v23, vcc
v_mov_b32_e32 v23, v9
v_cmp_lt_f32_e32 vcc, v14, v6
v_cndmask_b32_e32 v8, v14, v6, vcc
v_cndmask_b32_e32 v6, v6, v14, vcc
v_mov_b32_e32 v14, v8
v_cndmask_b32_e32 v9, v24, v7, vcc
v_cndmask_b32_e32 v7, v7, v24, vcc
v_mov_b32_e32 v24, v9
v_cmp_lt_f32_e32 vcc, v15, v6
v_cndmask_b32_e32 v8, v15, v6, vcc
v_cndmask_b32_e32 v6, v6, v15, vcc
v_mov_b32_e32 v15, v8
v_cndmask_b32_e32 v9, v25, v7, vcc
v_cndmask_b32_e32 v7, v7, v25, vcc
v_mov_b32_e32 v25, v9
v_cmp_lt_f32_e32 vcc, v16, v6
v_cndmask_b32_e32 v8, v16, v6, vcc
v_cndmask_b32_e32 v6, v6, v16, vcc
v_mov_b32_e32 v16, v8
v_cndmask_b32_e32 v9, v26, v7, vcc
v_cndmask_b32_e32 v7, v7, v26, vcc
v_mov_b32_e32 v26, v9
v_cmp_lt_f32_e32 vcc, v17, v6
v_cndmask_b32_e32 v8, v17, v6, vcc
v_cndmask_b32_e32 v6, v6, v17, vcc
v_mov_b32_e32 v17, v8
v_cndmask_b32_e32 v9, v27, v7, vcc
v_cndmask_b32_e32 v7, v7, v27, vcc
v_mov_b32_e32 v27, v9
v_cmp_lt_f32_e32 vcc, v18, v6
v_cndmask_b32_e32 v8, v18, v6, vcc
v_cndmask_b32_e32 v6, v6, v18, vcc
v_mov_b32_e32 v18, v8
v_cndmask_b32_e32 v9, v28, v7, vcc
v_cndmask_b32_e32 v7, v7, v28, vcc
v_mov_b32_e32 v28, v9
v_cmp_lt_f32_e32 vcc, v19, v6
v_cndmask_b32_e32 v8, v19, v6, vcc
v_cndmask_b32_e32 v6, v6, v19, vcc
v_mov_b32_e32 v19, v8
v_cndmask_b32_e32 v9, v29, v7, vcc
v_cndmask_b32_e32 v7, v7, v29, vcc
v_mov_b32_e32 v29, v9
s_add_i32 s24, s24, 1
s_branch L_col
L_done_col:
v_mov_b32_e32 v30, v10
v_max_f32_e32 v30, v30, v11
v_max_f32_e32 v30, v30, v12
v_max_f32_e32 v30, v30, v13
v_max_f32_e32 v30, v30, v14
v_max_f32_e32 v30, v30, v15
v_max_f32_e32 v30, v30, v16
v_max_f32_e32 v30, v30, v17
v_max_f32_e32 v30, v30, v18
v_max_f32_e32 v30, v30, v19
v_mov_b32_e32 v31, 0x3fb8aa3b
v_mov_b32_e32 v32, 0
v_sub_f32_e32 v33, v10, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v40, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v11, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v41, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v12, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v42, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v13, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v43, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v14, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v44, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v15, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v45, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v16, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v46, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v17, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v47, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v18, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v48, v33
v_add_f32_e32 v32, v32, v33
v_sub_f32_e32 v33, v19, v30
v_mul_f32_e32 v33, v33, v31
s_nop 0
v_exp_f32_e32 v33, v33
s_nop 0
v_mov_b32_e32 v49, v33
v_add_f32_e32 v32, v32, v33
s_nop 0
v_rcp_f32_e32 v32, v32
s_nop 0
v_mov_b32_e32 v34, 10
v_mul_lo_u32 v35, v1, v34
v_mul_f32_e32 v40, v40, v32
v_add_u32_e32 v36, 0, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v40, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v20, off
v_mul_f32_e32 v41, v41, v32
v_add_u32_e32 v36, 1, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v41, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v21, off
v_mul_f32_e32 v42, v42, v32
v_add_u32_e32 v36, 2, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v42, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v22, off
v_mul_f32_e32 v43, v43, v32
v_add_u32_e32 v36, 3, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v43, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v23, off
v_mul_f32_e32 v44, v44, v32
v_add_u32_e32 v36, 4, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v44, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v24, off
v_mul_f32_e32 v45, v45, v32
v_add_u32_e32 v36, 5, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v45, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v25, off
v_mul_f32_e32 v46, v46, v32
v_add_u32_e32 v36, 6, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v46, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v26, off
v_mul_f32_e32 v47, v47, v32
v_add_u32_e32 v36, 7, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v47, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v27, off
v_mul_f32_e32 v48, v48, v32
v_add_u32_e32 v36, 8, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v48, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v28, off
v_mul_f32_e32 v49, v49, v32
v_add_u32_e32 v36, 9, v35
v_lshlrev_b32_e32 v36, 2, v36
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v49, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v36
v_addc_co_u32_e32 v253, vcc, v253, v38, vcc
global_store_dword v[252:253], v29, off
L_end:
s_or_b64 exec, exec, s[2:3]
s_endpgm
