.text
k__Z15nvfp4_gemv_wideILi4ELi2EEvPKjPKhPKaS5_PKfPfiif:
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx8 s[16:23], s[4:5], 0x20
s_movk_i32 s0, 0x100
v_cmp_gt_u32_e32 vcc, s0, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 68
s_load_dword s2, s[4:5], 0x4c
s_waitcnt lgkmcnt(0)
v_mul_f32_e64 v1, s22, 0.5
v_lshlrev_b32_e32 v2, 2, v0
v_lshlrev_b32_e32 v3, 24, v0
s_mov_b32 s26, 0x3e000000
s_and_b32 s7, s2, 0xffff
s_lshl_b32 s24, s2, 24
s_lshl_b32 s25, s7, 2
s_mov_b64 s[2:3], 0
s_movk_i32 s27, 0x80
s_movk_i32 s28, 0xff
v_mov_b32_e32 v4, v0
s_branch 12
s_or_b64 exec, exec, s[22:23]
s_or_b64 exec, exec, s[4:5]
v_add_u32_e32 v4, s7, v4
v_mul_f32_e32 v5, v1, v6
v_cmp_lt_u32_e32 vcc, s28, v4
ds_write_b32 v2, v5
v_add_u32_e32 v2, s25, v2
s_or_b64 s[2:3], vcc, s[2:3]
v_add_u32_e32 v3, s24, v3
s_andn2_b64 exec, exec, s[2:3]
s_cbranch_execz 38
v_bfe_u32 v7, v4, 3, 4
v_and_b32_e32 v5, 7, v4
v_cmp_lt_i32_e32 vcc, 14, v7
s_and_saveexec_b64 s[4:5], vcc
s_xor_b64 s[4:5], exec, s[4:5]
v_cvt_f32_ubyte0_e32 v6, v5
v_fma_f32 v6, v6, s26, 1.0
v_mul_f32_e32 v6, 0x43800000, v6
v_cmp_gt_u32_e32 vcc, s27, v4
v_cndmask_b32_e64 v6, -v6, v6, vcc
v_cmp_ne_u32_e32 vcc, 7, v5
v_cndmask_b32_e32 v6, 0, v6, vcc
s_andn2_saveexec_b64 s[4:5], s[4:5]
s_cbranch_execz 65507
v_cmp_ne_u32_e32 vcc, 0, v7
s_and_saveexec_b64 s[22:23], vcc
s_xor_b64 s[22:23], exec, s[22:23]
v_and_b32_e32 v6, 0x80000000, v3
v_lshlrev_b32_e32 v7, 23, v7
v_lshlrev_b32_e32 v5, 20, v5
v_or3_b32 v5, v7, v6, v5
v_add_u32_e32 v6, 0x3c000000, v5
s_andn2_saveexec_b64 s[22:23], s[22:23]
s_cbranch_execz 65493
v_cvt_f32_ubyte0_e32 v5, v5
v_mul_f32_e32 v5, 0x3b000000, v5
v_cmp_gt_u32_e32 vcc, s27, v4
v_cndmask_b32_e64 v6, -v5, v5, vcc
s_branch 65486
s_or_b64 exec, exec, s[0:1]
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v10, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v10
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 539
v_add_u32_e32 v1, 2, v10
v_sub_u32_e32 v2, s20, v10
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v11, 2, v2, vcc
s_mov_b32 s33, 0
v_cmp_lt_i32_e32 vcc, 0, v11
s_and_b64 exec, exec, vcc
s_cbranch_execz 531
s_ashr_i32 s0, s21, 31
s_lshr_b32 s1, s0, 28
s_add_i32 s1, s21, s1
v_and_b32_e32 v12, 63, v0
s_ashr_i32 s6, s1, 4
s_lshr_b32 s1, s0, 27
s_lshr_b32 s0, s0, 29
s_add_i32 s1, s21, s1
s_add_i32 s0, s21, s0
v_lshlrev_b32_e32 v0, 3, v12
s_ashr_i32 s34, s1, 5
s_lshr_b32 s1, s21, 31
s_ashr_i32 s4, s0, 3
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v0, vcc, s16, v0
s_add_i32 s1, s21, s1
s_ashr_i32 s5, s4, 31
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
v_lshlrev_b32_e32 v2, 1, v12
s_ashr_i32 s35, s1, 1
s_ashr_i32 s7, s6, 31
s_ashr_i32 s21, s20, 31
s_lshl_b64 s[16:17], s[4:5], 2
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v2, vcc, s10, v2
v_mbcnt_lo_u32_b32 v4, -1, 0
v_cmp_gt_i32_e64 s[0:1], s34, v12
s_ashr_i32 s36, s35, 31
v_cmp_eq_u32_e64 s[2:3], 0, v12
v_mov_b32_e32 v13, 0
v_lshlrev_b32_e32 v14, 4, v12
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_lshl_b64 s[10:11], s[6:7], 2
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v15, 0xc080604
v_mov_b32_e32 v16, 0x3020100
v_mov_b32_e32 v17, 0xf4f8fafc
v_mov_b32_e32 v18, 0xfdfeff00
s_lshl_b64 s[20:21], s[20:21], 2
v_mov_b32_e32 v19, 0xff00
v_mov_b32_e32 v20, 2
s_movk_i32 s7, 0x200
s_movk_i32 s17, 0x400
s_movk_i32 s37, 0x80
v_mbcnt_hi_u32_b32 v21, -1, v4
v_mov_b32_e32 v22, v10
s_branch 7
s_or_b64 exec, exec, s[4:5]
s_add_i32 s33, s33, 1
v_cmp_ge_i32_e32 vcc, s33, v11
s_or_b64 s[22:23], vcc, s[22:23]
v_add_u32_e32 v22, 1, v22
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execz 468
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v23, 0
s_and_saveexec_b64 s[24:25], s[0:1]
s_cbranch_execz 313
v_mov_b32_e32 v4, s8
v_mov_b32_e32 v5, s9
v_mad_i64_i32 v[4:5], s[4:5], v22, s16, v[4:5]
v_mad_i64_i32 v[6:7], s[4:5], v22, s6, v[2:3]
v_mov_b32_e32 v9, v1
s_mov_b64 s[26:27], 0
v_mov_b32_e32 v23, 0
s_mov_b64 s[28:29], s[14:15]
s_mov_b64 s[30:31], s[12:13]
v_mov_b32_e32 v8, v0
v_mov_b32_e32 v27, v12
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v24, 0
v_add_co_u32_e32 v28, vcc, v4, v14
v_addc_co_u32_e32 v29, vcc, 0, v5, vcc
global_load_dwordx4 v[28:31], v[28:29], off
s_waitcnt vmcnt(0)
v_and_b32_e32 v32, 0x7070707, v28
v_lshrrev_b32_e32 v33, 3, v28
v_lshrrev_b32_e32 v34, 4, v28
v_lshrrev_b32_e32 v28, 7, v28
v_and_b32_e32 v33, 0x1010101, v33
v_and_b32_e32 v34, 0x7070707, v34
v_and_b32_e32 v28, 0x1010101, v28
v_perm_b32 v35, v15, v16, v32
v_perm_b32 v32, v17, v18, v32
v_perm_b32 v33, v13, v19, v33
v_bfi_b32 v44, v33, v32, v35
v_perm_b32 v32, v15, v16, v34
v_perm_b32 v33, v17, v18, v34
v_perm_b32 v28, v13, v19, v28
v_bfi_b32 v45, v28, v33, v32
v_and_b32_e32 v28, 0x7070707, v29
v_lshrrev_b32_e32 v32, 3, v29
v_lshrrev_b32_e32 v33, 4, v29
v_lshrrev_b32_e32 v29, 7, v29
v_and_b32_e32 v32, 0x1010101, v32
v_and_b32_e32 v33, 0x7070707, v33
v_and_b32_e32 v29, 0x1010101, v29
v_perm_b32 v34, v15, v16, v28
v_perm_b32 v28, v17, v18, v28
v_perm_b32 v32, v13, v19, v32
v_bfi_b32 v46, v32, v28, v34
v_perm_b32 v28, v15, v16, v33
v_perm_b32 v32, v17, v18, v33
v_perm_b32 v29, v13, v19, v29
v_bfi_b32 v47, v29, v32, v28
v_and_b32_e32 v28, 0x7070707, v30
v_lshrrev_b32_e32 v29, 3, v30
v_lshrrev_b32_e32 v32, 4, v30
v_lshrrev_b32_e32 v30, 7, v30
v_and_b32_e32 v29, 0x1010101, v29
v_and_b32_e32 v32, 0x7070707, v32
v_and_b32_e32 v30, 0x1010101, v30
v_perm_b32 v33, v15, v16, v28
v_perm_b32 v28, v17, v18, v28
v_perm_b32 v29, v13, v19, v29
v_bfi_b32 v48, v29, v28, v33
v_perm_b32 v28, v15, v16, v32
v_perm_b32 v29, v17, v18, v32
v_perm_b32 v30, v13, v19, v30
v_bfi_b32 v49, v30, v29, v28
v_and_b32_e32 v28, 0x7070707, v31
v_lshrrev_b32_e32 v29, 3, v31
v_lshrrev_b32_e32 v30, 4, v31
v_lshrrev_b32_e32 v31, 7, v31
v_and_b32_e32 v29, 0x1010101, v29
v_and_b32_e32 v30, 0x7070707, v30
v_and_b32_e32 v31, 0x1010101, v31
v_perm_b32 v32, v15, v16, v28
v_perm_b32 v28, v17, v18, v28
v_perm_b32 v29, v13, v19, v29
v_bfi_b32 v50, v29, v28, v32
v_perm_b32 v40, v15, v16, v30
v_perm_b32 v41, v17, v18, v30
v_perm_b32 v42, v13, v19, v31
global_load_ushort v43, v[6:7], off
v_mov_b32_e32 v28, s31
v_add_co_u32_e32 v36, vcc, s30, v14
v_addc_co_u32_e32 v37, vcc, 0, v28, vcc
v_mov_b32_e32 v32, s29
v_add_co_u32_e32 v38, vcc, s28, v14
global_load_dwordx4 v[28:31], v[36:37], off
v_addc_co_u32_e32 v39, vcc, 0, v32, vcc
global_load_dwordx4 v[32:35], v[38:39], off
v_bfi_b32 v53, v42, v41, v40
s_waitcnt vmcnt(2)
v_lshlrev_b32_sdwa v51, v20, v43 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
v_lshlrev_b32_sdwa v43, v20, v43 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_1
ds_read_b32 v51, v51
ds_read_b32 v52, v43
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v28, v44, v28, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v28, v45, v32, v28
v_dot4_i32_i8 v28, v46, v29, v28
v_dot4_i32_i8 v42, v47, v33, v28
v_dot4_i32_i8 v28, v48, v30, v13
v_dot4_i32_i8 v28, v49, v34, v28
v_dot4_i32_i8 v28, v50, v31, v28
v_dot4_i32_i8 v43, v53, v35, v28
global_load_dwordx2 v[40:41], v[8:9], off
v_mov_b32_e32 v54, s36
v_add_co_u32_e32 v36, vcc, s35, v36
v_addc_co_u32_e32 v37, vcc, v37, v54, vcc
v_add_co_u32_e32 v38, vcc, s35, v38
global_load_dwordx4 v[28:31], v[36:37], off
v_addc_co_u32_e32 v39, vcc, v39, v54, vcc
global_load_dwordx4 v[32:35], v[38:39], off
v_cvt_f32_i32_e32 v43, v43
v_cvt_f32_i32_e32 v42, v42
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v41, v52, v41
v_mul_f32_e32 v40, v51, v40
v_mul_f32_e32 v41, v43, v41
v_fmac_f32_e32 v41, v42, v40
v_add_f32_e32 v23, v23, v41
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v28, v44, v28, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v28, v45, v32, v28
v_dot4_i32_i8 v28, v46, v29, v28
v_dot4_i32_i8 v55, v47, v33, v28
v_dot4_i32_i8 v28, v48, v30, v13
v_dot4_i32_i8 v28, v49, v34, v28
v_dot4_i32_i8 v28, v50, v31, v28
v_dot4_i32_i8 v56, v53, v35, v28
v_mov_b32_e32 v57, s11
v_add_co_u32_e32 v40, vcc, s10, v8
v_addc_co_u32_e32 v41, vcc, v9, v57, vcc
global_load_dwordx2 v[42:43], v[40:41], off
v_add_co_u32_e32 v36, vcc, s35, v36
v_addc_co_u32_e32 v37, vcc, v37, v54, vcc
v_add_co_u32_e32 v38, vcc, s35, v38
global_load_dwordx4 v[28:31], v[36:37], off
v_addc_co_u32_e32 v39, vcc, v39, v54, vcc
global_load_dwordx4 v[32:35], v[38:39], off
v_cvt_f32_i32_e32 v56, v56
v_cvt_f32_i32_e32 v55, v55
s_waitcnt vmcnt(2)
v_mul_f32_e32 v43, v52, v43
v_mul_f32_e32 v42, v51, v42
v_mul_f32_e32 v43, v56, v43
v_fmac_f32_e32 v43, v55, v42
v_add_f32_e32 v26, v26, v43
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v28, v44, v28, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v28, v45, v32, v28
v_dot4_i32_i8 v28, v46, v29, v28
v_dot4_i32_i8 v55, v47, v33, v28
v_dot4_i32_i8 v28, v48, v30, v13
v_dot4_i32_i8 v28, v49, v34, v28
v_dot4_i32_i8 v28, v50, v31, v28
v_dot4_i32_i8 v56, v53, v35, v28
v_add_co_u32_e32 v40, vcc, s10, v40
v_addc_co_u32_e32 v41, vcc, v41, v57, vcc
global_load_dwordx2 v[42:43], v[40:41], off
v_add_co_u32_e32 v28, vcc, s35, v36
v_addc_co_u32_e32 v29, vcc, v37, v54, vcc
v_add_co_u32_e32 v32, vcc, s35, v38
global_load_dwordx4 v[28:31], v[28:29], off
v_addc_co_u32_e32 v33, vcc, v39, v54, vcc
global_load_dwordx4 v[32:35], v[32:33], off
v_cvt_f32_i32_e32 v36, v56
v_cvt_f32_i32_e32 v37, v55
s_waitcnt vmcnt(2)
v_mul_f32_e32 v39, v52, v43
v_mul_f32_e32 v38, v51, v42
v_mul_f32_e32 v36, v36, v39
v_fmac_f32_e32 v36, v37, v38
v_add_f32_e32 v25, v25, v36
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v28, v44, v28, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v28, v45, v32, v28
v_dot4_i32_i8 v28, v46, v29, v28
v_dot4_i32_i8 v32, v47, v33, v28
v_dot4_i32_i8 v28, v48, v30, v13
v_dot4_i32_i8 v28, v49, v34, v28
v_dot4_i32_i8 v28, v50, v31, v28
v_dot4_i32_i8 v30, v53, v35, v28
v_add_co_u32_e32 v28, vcc, s10, v40
v_addc_co_u32_e32 v29, vcc, v41, v57, vcc
global_load_dwordx2 v[28:29], v[28:29], off
v_cvt_f32_i32_e32 v30, v30
v_cvt_f32_i32_e32 v31, v32
v_add_co_u32_e32 v8, vcc, s7, v8
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
s_add_u32 s30, s30, 0x400
v_add_co_u32_e32 v4, vcc, s17, v4
s_addc_u32 s31, s31, 0
v_add_u32_e32 v27, 64, v27
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_add_u32 s28, s28, 0x400
v_add_co_u32_e32 v6, vcc, s37, v6
v_cmp_le_i32_e64 s[4:5], s34, v27
s_addc_u32 s29, s29, 0
s_or_b64 s[26:27], s[4:5], s[26:27]
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_waitcnt vmcnt(0)
v_mul_f32_e32 v29, v52, v29
v_mul_f32_e32 v28, v51, v28
v_mul_f32_e32 v29, v30, v29
v_fmac_f32_e32 v29, v31, v28
v_add_f32_e32 v24, v24, v29
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execnz 65240
s_or_b64 exec, exec, s[26:27]
s_or_b64 exec, exec, s[24:25]
v_and_b32_e32 v8, 63, v21
v_and_b32_e32 v4, 64, v21
v_add_u32_e32 v9, 64, v4
v_xor_b32_e32 v4, 32, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v21, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v5, v4, v23
ds_bpermute_b32 v6, v4, v26
ds_bpermute_b32 v7, v4, v25
ds_bpermute_b32 v4, v4, v24
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v23, v5
v_xor_b32_e32 v23, 16, v8
v_cmp_lt_i32_e32 vcc, v23, v9
v_cndmask_b32_e32 v23, v21, v23, vcc
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v26, v6
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v7, v25, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v24, v4
v_lshlrev_b32_e32 v23, 2, v23
ds_bpermute_b32 v24, v23, v5
ds_bpermute_b32 v25, v23, v6
ds_bpermute_b32 v26, v23, v7
ds_bpermute_b32 v23, v23, v4
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v24
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v25
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v7, v7, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v23
v_xor_b32_e32 v23, 8, v8
v_cmp_lt_i32_e32 vcc, v23, v9
v_cndmask_b32_e32 v23, v21, v23, vcc
v_lshlrev_b32_e32 v23, 2, v23
ds_bpermute_b32 v24, v23, v5
ds_bpermute_b32 v25, v23, v6
ds_bpermute_b32 v26, v23, v7
ds_bpermute_b32 v23, v23, v4
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v24
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v25
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v7, v7, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v23
v_xor_b32_e32 v23, 4, v8
v_cmp_lt_i32_e32 vcc, v23, v9
v_cndmask_b32_e32 v23, v21, v23, vcc
v_lshlrev_b32_e32 v23, 2, v23
ds_bpermute_b32 v24, v23, v5
ds_bpermute_b32 v25, v23, v6
ds_bpermute_b32 v26, v23, v7
ds_bpermute_b32 v23, v23, v4
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v24
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v25
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v7, v7, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v23, v4, v23
v_xor_b32_e32 v4, 2, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v21, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v24, v4, v5
ds_bpermute_b32 v25, v4, v6
ds_bpermute_b32 v26, v4, v7
ds_bpermute_b32 v27, v4, v23
v_xor_b32_e32 v8, 1, v8
v_cmp_lt_i32_e32 vcc, v8, v9
v_cndmask_b32_e32 v8, v21, v8, vcc
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v4, v5, v24
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v5, v6, v25
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v6, v7, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v7, v23, v27
v_lshlrev_b32_e32 v24, 2, v8
ds_bpermute_b32 v8, v24, v4
ds_bpermute_b32 v9, v24, v5
ds_bpermute_b32 v23, v24, v6
ds_bpermute_b32 v24, v24, v7
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 65091
v_add_u32_e32 v25, s33, v10
v_ashrrev_i32_e32 v26, 31, v25
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v9, v5, v9
v_add_f32_e32 v8, v4, v8
v_lshlrev_b64 v[4:5], 2, v[25:26]
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v6, v6, v23
v_mov_b32_e32 v23, s19
v_add_co_u32_e32 v4, vcc, s18, v4
v_addc_co_u32_e32 v5, vcc, v23, v5, vcc
global_store_dword v[4:5], v8, off
v_mov_b32_e32 v8, s21
v_add_co_u32_e32 v4, vcc, s20, v4
v_addc_co_u32_e32 v5, vcc, v5, v8, vcc
global_store_dword v[4:5], v9, off
v_add_co_u32_e32 v4, vcc, s20, v4
v_addc_co_u32_e32 v5, vcc, v5, v8, vcc
global_store_dword v[4:5], v6, off
v_add_co_u32_e32 v4, vcc, s20, v4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v7, v7, v24
v_addc_co_u32_e32 v5, vcc, v5, v8, vcc
global_store_dword v[4:5], v7, off
s_branch 65061
s_endpgm
