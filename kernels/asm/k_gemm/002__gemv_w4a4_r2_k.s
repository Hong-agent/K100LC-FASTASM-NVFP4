.text
k_gemv_w4a4_r2_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dwordx2 s[24:25], s[4:5], 0x20
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_waitcnt lgkmcnt(0)
s_lshr_b32 s28, s27, 3
s_lshr_b32 s29, s27, 7
s_lshl_b32 s30, s28, 2
s_lshl_b32 s31, s29, 1
s_lshr_b32 s32, s27, 5
s_lshl_b32 s33, s32, 2
v_mov_b32_e32 v4, 0
v_and_b32_e32 v1, 63, v0
v_lshrrev_b32_e32 v2, 6, v0
v_lshl_or_b32 v2, s6, 2, v2
v_lshlrev_b32_e32 v2, 1, v2
v_cmp_gt_i32_e32 vcc, s26, v2
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v4, s26
v_sub_u32_e32 v3, v4, v2
v_cmp_gt_u32_e32 vcc, 1, v3
v_mov_b32_e32 v4, 2
v_mov_b32_e32 v5, 1
v_cndmask_b32_e32 v3, v4, v5, vcc
v_mov_b32_e32 v4, 0
v_mul_lo_u32 v5, v2, s30
v_mov_b32_e32 v6, s16
v_add_co_u32_e32 v6, vcc, v6, v5
v_mov_b32_e32 v7, s17
v_addc_co_u32_e32 v7, vcc, v7, v4, vcc
v_mul_lo_u32 v5, v2, s31
v_mov_b32_e32 v8, s18
v_add_co_u32_e32 v8, vcc, v8, v5
v_mov_b32_e32 v9, s19
v_addc_co_u32_e32 v9, vcc, v9, v4, vcc
v_mov_b32_e32 v10, s20
v_mov_b32_e32 v11, s21
v_mov_b32_e32 v12, s22
v_mov_b32_e32 v13, s23
v_lshlrev_b32_e32 v5, 2, v2
v_mov_b32_e32 v14, s24
v_add_co_u32_e32 v14, vcc, v14, v5
v_mov_b32_e32 v15, s25
v_addc_co_u32_e32 v15, vcc, v15, v4, vcc
v_lshlrev_b32_e32 v19, 4, v1
v_lshlrev_b32_e32 v20, 2, v1
v_lshrrev_b32_e32 v21, 2, v1
v_lshlrev_b32_e32 v21, 1, v21
v_mov_b32_e32 v40, 0
v_mov_b32_e32 v41, 0
v_mov_b32_e32 v42, 0
v_mov_b32_e32 v43, 0
v_mov_b32_e32 v44, 0
v_mov_b32_e32 v45, 0
v_mov_b32_e32 v46, 0
v_mov_b32_e32 v47, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v22, s28
L_loop:
v_cmp_lt_u32_e32 vcc, v16, v22
s_cbranch_vccz L_done
v_lshlrev_b32_e32 v23, 2, v1
v_add_u32_e32 v23, v16, v23
v_cmp_lt_u32_e32 vcc, v23, v22
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz L_skip
v_lshlrev_b32_e32 v17, 2, v16
v_lshrrev_b32_e32 v18, 4, v16
v_lshlrev_b32_e32 v18, 1, v18
v_add_u32_e32 v57, v17, v19
v_mov_b32_e32 v50, v6
v_add_co_u32_e32 v50, vcc, v50, v57
v_mov_b32_e32 v51, v7
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[24:27], v[50:51], off
v_mov_b32_e32 v52, s30
v_add_u32_e32 v56, v57, v52
v_mov_b32_e32 v50, v6
v_add_co_u32_e32 v50, vcc, v50, v56
v_mov_b32_e32 v51, v7
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[28:31], v[50:51], off
v_add_u32_e32 v53, v18, v21
v_mov_b32_e32 v50, v8
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v9
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_ushort v36, v[50:51], off
v_mov_b32_e32 v54, s31
v_add_u32_e32 v53, v53, v54
v_mov_b32_e32 v50, v8
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v9
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_ushort v37, v[50:51], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v36, v36
v_cvt_f32_f16_e32 v37, v37
v_add_u32_e32 v56, v17, v19
v_mov_b32_e32 v50, v10
v_add_co_u32_e32 v50, vcc, v50, v56
v_mov_b32_e32 v51, v11
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[32:35], v[50:51], off
v_add_u32_e32 v53, v16, v20
v_mov_b32_e32 v50, v12
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v13
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dword v38, v[50:51], off
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v48, v24, v32, v4
v_dot8_i32_i4 v49, v25, v33, v4
v_dot8_i32_i4 v48, v26, v34, v48
v_dot8_i32_i4 v49, v27, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v36, v38
v_fma_f32 v40, v52, v49, v40
v_dot8_i32_i4 v48, v28, v32, v4
v_dot8_i32_i4 v49, v29, v33, v4
v_dot8_i32_i4 v48, v30, v34, v48
v_dot8_i32_i4 v49, v31, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v37, v38
v_fma_f32 v44, v52, v49, v44
v_mov_b32_e32 v52, s30
v_mov_b32_e32 v54, 1
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v56, v17, v19
v_add_u32_e32 v56, v56, v52
v_mov_b32_e32 v50, v10
v_add_co_u32_e32 v50, vcc, v50, v56
v_mov_b32_e32 v51, v11
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[32:35], v[50:51], off
v_mov_b32_e32 v52, s33
v_mov_b32_e32 v54, 1
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v53, v16, v20
v_add_u32_e32 v53, v53, v52
v_mov_b32_e32 v50, v12
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v13
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dword v38, v[50:51], off
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v48, v24, v32, v4
v_dot8_i32_i4 v49, v25, v33, v4
v_dot8_i32_i4 v48, v26, v34, v48
v_dot8_i32_i4 v49, v27, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v36, v38
v_fma_f32 v41, v52, v49, v41
v_dot8_i32_i4 v48, v28, v32, v4
v_dot8_i32_i4 v49, v29, v33, v4
v_dot8_i32_i4 v48, v30, v34, v48
v_dot8_i32_i4 v49, v31, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v37, v38
v_fma_f32 v45, v52, v49, v45
v_mov_b32_e32 v52, s30
v_mov_b32_e32 v54, 2
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v56, v17, v19
v_add_u32_e32 v56, v56, v52
v_mov_b32_e32 v50, v10
v_add_co_u32_e32 v50, vcc, v50, v56
v_mov_b32_e32 v51, v11
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[32:35], v[50:51], off
v_mov_b32_e32 v52, s33
v_mov_b32_e32 v54, 2
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v53, v16, v20
v_add_u32_e32 v53, v53, v52
v_mov_b32_e32 v50, v12
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v13
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dword v38, v[50:51], off
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v48, v24, v32, v4
v_dot8_i32_i4 v49, v25, v33, v4
v_dot8_i32_i4 v48, v26, v34, v48
v_dot8_i32_i4 v49, v27, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v36, v38
v_fma_f32 v42, v52, v49, v42
v_dot8_i32_i4 v48, v28, v32, v4
v_dot8_i32_i4 v49, v29, v33, v4
v_dot8_i32_i4 v48, v30, v34, v48
v_dot8_i32_i4 v49, v31, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v37, v38
v_fma_f32 v46, v52, v49, v46
v_mov_b32_e32 v52, s30
v_mov_b32_e32 v54, 3
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v56, v17, v19
v_add_u32_e32 v56, v56, v52
v_mov_b32_e32 v50, v10
v_add_co_u32_e32 v50, vcc, v50, v56
v_mov_b32_e32 v51, v11
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dwordx4 v[32:35], v[50:51], off
v_mov_b32_e32 v52, s33
v_mov_b32_e32 v54, 3
v_mul_lo_u32 v52, v52, v54
v_add_u32_e32 v53, v16, v20
v_add_u32_e32 v53, v53, v52
v_mov_b32_e32 v50, v12
v_add_co_u32_e32 v50, vcc, v50, v53
v_mov_b32_e32 v51, v13
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_load_dword v38, v[50:51], off
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v48, v24, v32, v4
v_dot8_i32_i4 v49, v25, v33, v4
v_dot8_i32_i4 v48, v26, v34, v48
v_dot8_i32_i4 v49, v27, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v36, v38
v_fma_f32 v43, v52, v49, v43
v_dot8_i32_i4 v48, v28, v32, v4
v_dot8_i32_i4 v49, v29, v33, v4
v_dot8_i32_i4 v48, v30, v34, v48
v_dot8_i32_i4 v49, v31, v35, v49
v_add_u32_e32 v48, v48, v49
v_cvt_f32_i32_e32 v49, v48
v_mul_f32_e32 v52, v37, v38
v_fma_f32 v47, v52, v49, v47
L_skip:
s_or_b64 exec, exec, s[2:3]
v_add_u32_e32 v16, 256, v16
s_branch L_loop
L_done:
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v40
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v40, v40, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 0, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 0
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 0, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v40, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v41
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v41, v41, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 0, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 1
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 0, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v41, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v42
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v42, v42, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 0, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 2
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 0, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v42, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v43
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v43, v43, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 0, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 3
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 0, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v43, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v44
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v44, v44, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 1, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 0
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 4, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v44, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v45
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v45, v45, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 1, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 1
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 4, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v45, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v46
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v46, v46, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 1, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 2
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 4, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v46, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
v_xor_b32_e32 v53, 32, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_xor_b32_e32 v53, 16, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_xor_b32_e32 v53, 8, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_xor_b32_e32 v53, 4, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_xor_b32_e32 v53, 2, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_xor_b32_e32 v53, 1, v1
v_lshlrev_b32_e32 v53, 2, v53
ds_bpermute_b32 v54, v53, v47
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v47, v47, v54
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[2:3], vcc
v_cmp_lt_u32_e32 vcc, 1, v3
s_and_saveexec_b64 s[8:9], vcc
v_mov_b32_e32 v52, s26
v_mov_b32_e32 v54, 3
v_mul_lo_u32 v52, v52, v54
v_lshlrev_b32_e32 v52, 2, v52
v_add_u32_e32 v52, 4, v52
v_mov_b32_e32 v50, v14
v_add_co_u32_e32 v50, vcc, v50, v52
v_mov_b32_e32 v51, v15
v_addc_co_u32_e32 v51, vcc, v51, v4, vcc
global_store_dword v[50:51], v47, off
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[2:3]
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
