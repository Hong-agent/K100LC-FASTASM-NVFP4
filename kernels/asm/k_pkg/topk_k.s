.text
k_topk_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v1, s6
v_lshlrev_b32_e32 v1, 6, v1
v_add_u32_e32 v1, v1, v0
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v3, s23
v_mul_lo_u32 v2, v1, v3
v_lshlrev_b32_e32 v2, 2, v2
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, s16, v2
v_addc_co_u32_e32 v5, vcc, v5, v26, vcc
v_mov_b32_e32 v10, 0xff800000
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v11, 0xff800000
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v12, 0xff800000
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v13, 0xff800000
v_mov_b32_e32 v33, 0
v_mov_b32_e32 v14, 0xff800000
v_mov_b32_e32 v34, 0
v_mov_b32_e32 v15, 0xff800000
v_mov_b32_e32 v35, 0
v_mov_b32_e32 v16, 0xff800000
v_mov_b32_e32 v36, 0
v_mov_b32_e32 v17, 0xff800000
v_mov_b32_e32 v37, 0
v_mov_b32_e32 v18, 0xff800000
v_mov_b32_e32 v38, 0
v_mov_b32_e32 v19, 0xff800000
v_mov_b32_e32 v39, 0
v_mov_b32_e32 v20, 0xff800000
v_mov_b32_e32 v40, 0
v_mov_b32_e32 v21, 0xff800000
v_mov_b32_e32 v41, 0
v_mov_b32_e32 v22, 0xff800000
v_mov_b32_e32 v42, 0
v_mov_b32_e32 v23, 0xff800000
v_mov_b32_e32 v43, 0
v_mov_b32_e32 v24, 0xff800000
v_mov_b32_e32 v44, 0
v_mov_b32_e32 v25, 0xff800000
v_mov_b32_e32 v45, 0
s_mov_b32 s25, 0
L_col:
s_cmp_lt_u32 s25, s23
s_cbranch_scc0 L_done_col
v_mov_b32_e32 v7, s25
v_lshlrev_b32_e32 v7, 2, v7
v_mov_b32_e32 v251, v5
v_add_co_u32_e32 v250, vcc, v4, v7
v_addc_co_u32_e32 v251, vcc, v251, v26, vcc
global_load_dword v6, v[250:251], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v7, s25
v_cmp_lt_f32_e32 vcc, v10, v6
v_cndmask_b32_e32 v8, v10, v6, vcc
v_cndmask_b32_e32 v6, v6, v10, vcc
v_mov_b32_e32 v10, v8
v_cndmask_b32_e32 v9, v30, v7, vcc
v_cndmask_b32_e32 v7, v7, v30, vcc
v_mov_b32_e32 v30, v9
v_cmp_lt_f32_e32 vcc, v11, v6
v_cndmask_b32_e32 v8, v11, v6, vcc
v_cndmask_b32_e32 v6, v6, v11, vcc
v_mov_b32_e32 v11, v8
v_cndmask_b32_e32 v9, v31, v7, vcc
v_cndmask_b32_e32 v7, v7, v31, vcc
v_mov_b32_e32 v31, v9
v_cmp_lt_f32_e32 vcc, v12, v6
v_cndmask_b32_e32 v8, v12, v6, vcc
v_cndmask_b32_e32 v6, v6, v12, vcc
v_mov_b32_e32 v12, v8
v_cndmask_b32_e32 v9, v32, v7, vcc
v_cndmask_b32_e32 v7, v7, v32, vcc
v_mov_b32_e32 v32, v9
v_cmp_lt_f32_e32 vcc, v13, v6
v_cndmask_b32_e32 v8, v13, v6, vcc
v_cndmask_b32_e32 v6, v6, v13, vcc
v_mov_b32_e32 v13, v8
v_cndmask_b32_e32 v9, v33, v7, vcc
v_cndmask_b32_e32 v7, v7, v33, vcc
v_mov_b32_e32 v33, v9
v_cmp_lt_f32_e32 vcc, v14, v6
v_cndmask_b32_e32 v8, v14, v6, vcc
v_cndmask_b32_e32 v6, v6, v14, vcc
v_mov_b32_e32 v14, v8
v_cndmask_b32_e32 v9, v34, v7, vcc
v_cndmask_b32_e32 v7, v7, v34, vcc
v_mov_b32_e32 v34, v9
v_cmp_lt_f32_e32 vcc, v15, v6
v_cndmask_b32_e32 v8, v15, v6, vcc
v_cndmask_b32_e32 v6, v6, v15, vcc
v_mov_b32_e32 v15, v8
v_cndmask_b32_e32 v9, v35, v7, vcc
v_cndmask_b32_e32 v7, v7, v35, vcc
v_mov_b32_e32 v35, v9
v_cmp_lt_f32_e32 vcc, v16, v6
v_cndmask_b32_e32 v8, v16, v6, vcc
v_cndmask_b32_e32 v6, v6, v16, vcc
v_mov_b32_e32 v16, v8
v_cndmask_b32_e32 v9, v36, v7, vcc
v_cndmask_b32_e32 v7, v7, v36, vcc
v_mov_b32_e32 v36, v9
v_cmp_lt_f32_e32 vcc, v17, v6
v_cndmask_b32_e32 v8, v17, v6, vcc
v_cndmask_b32_e32 v6, v6, v17, vcc
v_mov_b32_e32 v17, v8
v_cndmask_b32_e32 v9, v37, v7, vcc
v_cndmask_b32_e32 v7, v7, v37, vcc
v_mov_b32_e32 v37, v9
v_cmp_lt_f32_e32 vcc, v18, v6
v_cndmask_b32_e32 v8, v18, v6, vcc
v_cndmask_b32_e32 v6, v6, v18, vcc
v_mov_b32_e32 v18, v8
v_cndmask_b32_e32 v9, v38, v7, vcc
v_cndmask_b32_e32 v7, v7, v38, vcc
v_mov_b32_e32 v38, v9
v_cmp_lt_f32_e32 vcc, v19, v6
v_cndmask_b32_e32 v8, v19, v6, vcc
v_cndmask_b32_e32 v6, v6, v19, vcc
v_mov_b32_e32 v19, v8
v_cndmask_b32_e32 v9, v39, v7, vcc
v_cndmask_b32_e32 v7, v7, v39, vcc
v_mov_b32_e32 v39, v9
v_cmp_lt_f32_e32 vcc, v20, v6
v_cndmask_b32_e32 v8, v20, v6, vcc
v_cndmask_b32_e32 v6, v6, v20, vcc
v_mov_b32_e32 v20, v8
v_cndmask_b32_e32 v9, v40, v7, vcc
v_cndmask_b32_e32 v7, v7, v40, vcc
v_mov_b32_e32 v40, v9
v_cmp_lt_f32_e32 vcc, v21, v6
v_cndmask_b32_e32 v8, v21, v6, vcc
v_cndmask_b32_e32 v6, v6, v21, vcc
v_mov_b32_e32 v21, v8
v_cndmask_b32_e32 v9, v41, v7, vcc
v_cndmask_b32_e32 v7, v7, v41, vcc
v_mov_b32_e32 v41, v9
v_cmp_lt_f32_e32 vcc, v22, v6
v_cndmask_b32_e32 v8, v22, v6, vcc
v_cndmask_b32_e32 v6, v6, v22, vcc
v_mov_b32_e32 v22, v8
v_cndmask_b32_e32 v9, v42, v7, vcc
v_cndmask_b32_e32 v7, v7, v42, vcc
v_mov_b32_e32 v42, v9
v_cmp_lt_f32_e32 vcc, v23, v6
v_cndmask_b32_e32 v8, v23, v6, vcc
v_cndmask_b32_e32 v6, v6, v23, vcc
v_mov_b32_e32 v23, v8
v_cndmask_b32_e32 v9, v43, v7, vcc
v_cndmask_b32_e32 v7, v7, v43, vcc
v_mov_b32_e32 v43, v9
v_cmp_lt_f32_e32 vcc, v24, v6
v_cndmask_b32_e32 v8, v24, v6, vcc
v_cndmask_b32_e32 v6, v6, v24, vcc
v_mov_b32_e32 v24, v8
v_cndmask_b32_e32 v9, v44, v7, vcc
v_cndmask_b32_e32 v7, v7, v44, vcc
v_mov_b32_e32 v44, v9
v_cmp_lt_f32_e32 vcc, v25, v6
v_cndmask_b32_e32 v8, v25, v6, vcc
v_cndmask_b32_e32 v6, v6, v25, vcc
v_mov_b32_e32 v25, v8
v_cndmask_b32_e32 v9, v45, v7, vcc
v_cndmask_b32_e32 v7, v7, v45, vcc
v_mov_b32_e32 v45, v9
s_add_i32 s25, s25, 1
s_branch L_col
L_done_col:
v_mov_b32_e32 v27, s24
v_mul_lo_u32 v28, v1, v27
s_mov_b32 s26, 0
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_0
v_mov_b32_e32 v29, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v10, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v30, off
L_skip_0:
s_mov_b32 s26, 1
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_1
v_add_u32_e32 v29, 1, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v11, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v31, off
L_skip_1:
s_mov_b32 s26, 2
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_2
v_add_u32_e32 v29, 2, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v12, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v32, off
L_skip_2:
s_mov_b32 s26, 3
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_3
v_add_u32_e32 v29, 3, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v13, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v33, off
L_skip_3:
s_mov_b32 s26, 4
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_4
v_add_u32_e32 v29, 4, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v14, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v34, off
L_skip_4:
s_mov_b32 s26, 5
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_5
v_add_u32_e32 v29, 5, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v15, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v35, off
L_skip_5:
s_mov_b32 s26, 6
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_6
v_add_u32_e32 v29, 6, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v16, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v36, off
L_skip_6:
s_mov_b32 s26, 7
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_7
v_add_u32_e32 v29, 7, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v17, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v37, off
L_skip_7:
s_mov_b32 s26, 8
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_8
v_add_u32_e32 v29, 8, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v18, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v38, off
L_skip_8:
s_mov_b32 s26, 9
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_9
v_add_u32_e32 v29, 9, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v19, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v39, off
L_skip_9:
s_mov_b32 s26, 10
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_10
v_add_u32_e32 v29, 10, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v20, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v40, off
L_skip_10:
s_mov_b32 s26, 11
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_11
v_add_u32_e32 v29, 11, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v21, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v41, off
L_skip_11:
s_mov_b32 s26, 12
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_12
v_add_u32_e32 v29, 12, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v22, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v42, off
L_skip_12:
s_mov_b32 s26, 13
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_13
v_add_u32_e32 v29, 13, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v23, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v43, off
L_skip_13:
s_mov_b32 s26, 14
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_14
v_add_u32_e32 v29, 14, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v24, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v44, off
L_skip_14:
s_mov_b32 s26, 15
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_skip_15
v_add_u32_e32 v29, 15, v28
v_lshlrev_b32_e32 v29, 2, v29
v_mov_b32_e32 v253, s21
v_add_co_u32_e32 v252, vcc, s20, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v25, off
v_mov_b32_e32 v253, s19
v_add_co_u32_e32 v252, vcc, s18, v29
v_addc_co_u32_e32 v253, vcc, v253, v26, vcc
global_store_dword v[252:253], v45, off
L_skip_15:
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
