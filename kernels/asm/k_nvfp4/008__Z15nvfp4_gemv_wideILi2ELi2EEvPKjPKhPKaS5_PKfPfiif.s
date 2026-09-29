.text
k__Z15nvfp4_gemv_wideILi2ELi2EEvPKjPKhPKaS5_PKfPfiif:
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
s_cbranch_execz 418
v_add_u32_e32 v1, 2, v10
v_sub_u32_e32 v2, s20, v10
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v11, 2, v2, vcc
s_mov_b32 s33, 0
v_cmp_lt_i32_e32 vcc, 0, v11
s_and_b64 exec, exec, vcc
s_cbranch_execz 410
s_ashr_i32 s0, s21, 31
s_lshr_b32 s1, s0, 28
s_add_i32 s1, s21, s1
s_ashr_i32 s6, s1, 4
s_lshr_b32 s1, s0, 27
s_add_i32 s1, s21, s1
s_ashr_i32 s42, s1, 5
s_lshr_b32 s1, s21, 31
s_lshr_b32 s0, s0, 29
s_add_i32 s1, s21, s1
s_add_i32 s0, s21, s0
v_and_b32_e32 v12, 63, v0
s_ashr_i32 s24, s1, 1
s_ashr_i32 s4, s0, 3
s_ashr_i32 s5, s4, 31
s_ashr_i32 s7, s6, 31
s_ashr_i32 s25, s24, 31
s_ashr_i32 s21, s20, 31
v_lshlrev_b32_e32 v0, 3, v12
s_add_u32 s22, s12, s24
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v0, vcc, s16, v0
s_addc_u32 s23, s13, s25
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
v_lshlrev_b32_e32 v2, 1, v12
s_add_u32 s24, s14, s24
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v2, vcc, s10, v2
v_mbcnt_lo_u32_b32 v4, -1, 0
v_cmp_gt_i32_e64 s[0:1], s42, v12
v_cmp_eq_u32_e64 s[2:3], 0, v12
s_addc_u32 s25, s15, s25
v_mov_b32_e32 v13, 0
s_lshl_b64 s[16:17], s[6:7], 2
v_lshlrev_b32_e32 v14, 4, v12
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_lshl_b64 s[10:11], s[4:5], 2
s_mov_b64 s[26:27], 0
v_mov_b32_e32 v15, 0xc080604
v_mov_b32_e32 v16, 0x3020100
v_mov_b32_e32 v17, 0xf4f8fafc
v_mov_b32_e32 v18, 0xfdfeff00
s_lshl_b64 s[20:21], s[20:21], 2
v_mov_b32_e32 v19, 0xff00
v_mov_b32_e32 v20, 2
s_movk_i32 s7, 0x200
v_mbcnt_hi_u32_b32 v21, -1, v4
v_mov_b32_e32 v22, v10
s_branch 7
s_or_b64 exec, exec, s[4:5]
s_add_i32 s33, s33, 1
v_cmp_ge_i32_e32 vcc, s33, v11
s_or_b64 s[26:27], vcc, s[26:27]
v_add_u32_e32 v22, 1, v22
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execz 345
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v23, 0
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 247
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s8
v_mov_b32_e32 v7, s9
v_mad_i64_i32 v[4:5], s[4:5], v22, s6, v[2:3]
v_mad_i64_i32 v[6:7], s[4:5], v22, s10, v[6:7]
v_mov_b32_e32 v9, v1
s_mov_b64 s[30:31], 0
v_mov_b32_e32 v23, 0
s_mov_b64 s[34:35], s[22:23]
s_mov_b64 s[36:37], s[12:13]
s_mov_b64 s[38:39], s[24:25]
s_mov_b64 s[40:41], s[14:15]
v_mov_b32_e32 v8, v0
v_mov_b32_e32 v25, v12
v_mov_b32_e32 v24, 0
v_add_co_u32_e32 v26, vcc, v6, v14
v_addc_co_u32_e32 v27, vcc, 0, v7, vcc
global_load_dwordx4 v[26:29], v[26:27], off
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0x7070707, v26
v_lshrrev_b32_e32 v31, 3, v26
v_lshrrev_b32_e32 v32, 4, v26
v_lshrrev_b32_e32 v26, 7, v26
v_and_b32_e32 v31, 0x1010101, v31
v_and_b32_e32 v32, 0x7070707, v32
v_and_b32_e32 v26, 0x1010101, v26
v_perm_b32 v33, v15, v16, v30
v_perm_b32 v30, v17, v18, v30
v_perm_b32 v31, v13, v19, v31
v_bfi_b32 v36, v31, v30, v33
v_perm_b32 v30, v15, v16, v32
v_perm_b32 v31, v17, v18, v32
v_perm_b32 v26, v13, v19, v26
v_bfi_b32 v37, v26, v31, v30
v_and_b32_e32 v26, 0x7070707, v27
v_lshrrev_b32_e32 v30, 3, v27
v_lshrrev_b32_e32 v31, 4, v27
v_lshrrev_b32_e32 v27, 7, v27
v_and_b32_e32 v30, 0x1010101, v30
v_and_b32_e32 v31, 0x7070707, v31
v_and_b32_e32 v27, 0x1010101, v27
v_perm_b32 v32, v15, v16, v26
v_perm_b32 v26, v17, v18, v26
v_perm_b32 v30, v13, v19, v30
v_bfi_b32 v38, v30, v26, v32
v_perm_b32 v26, v15, v16, v31
v_perm_b32 v30, v17, v18, v31
v_perm_b32 v27, v13, v19, v27
v_bfi_b32 v39, v27, v30, v26
v_and_b32_e32 v26, 0x7070707, v28
v_lshrrev_b32_e32 v27, 3, v28
v_lshrrev_b32_e32 v30, 4, v28
v_lshrrev_b32_e32 v28, 7, v28
v_and_b32_e32 v27, 0x1010101, v27
v_and_b32_e32 v30, 0x7070707, v30
v_and_b32_e32 v28, 0x1010101, v28
v_perm_b32 v31, v15, v16, v26
v_perm_b32 v26, v17, v18, v26
v_perm_b32 v27, v13, v19, v27
v_bfi_b32 v40, v27, v26, v31
v_perm_b32 v26, v15, v16, v30
v_perm_b32 v27, v17, v18, v30
v_perm_b32 v28, v13, v19, v28
v_bfi_b32 v41, v28, v27, v26
v_and_b32_e32 v26, 0x7070707, v29
v_lshrrev_b32_e32 v27, 3, v29
v_lshrrev_b32_e32 v28, 4, v29
v_lshrrev_b32_e32 v29, 7, v29
v_and_b32_e32 v27, 0x1010101, v27
v_and_b32_e32 v28, 0x7070707, v28
v_and_b32_e32 v29, 0x1010101, v29
v_perm_b32 v30, v15, v16, v26
v_perm_b32 v26, v17, v18, v26
v_perm_b32 v27, v13, v19, v27
v_bfi_b32 v42, v27, v26, v30
v_perm_b32 v34, v15, v16, v28
v_perm_b32 v35, v17, v18, v28
v_perm_b32 v43, v13, v19, v29
global_load_ushort v44, v[4:5], off
v_mov_b32_e32 v27, s37
v_add_co_u32_e32 v26, vcc, s36, v14
v_addc_co_u32_e32 v27, vcc, 0, v27, vcc
v_mov_b32_e32 v31, s41
v_add_co_u32_e32 v30, vcc, s40, v14
global_load_dwordx4 v[26:29], v[26:27], off
v_addc_co_u32_e32 v31, vcc, 0, v31, vcc
global_load_dwordx4 v[30:33], v[30:31], off
v_bfi_b32 v43, v43, v35, v34
s_waitcnt vmcnt(2)
v_lshlrev_b32_sdwa v45, v20, v44 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
v_lshlrev_b32_sdwa v44, v20, v44 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_1
ds_read_b32 v45, v45
ds_read_b32 v44, v44
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v26, v36, v26, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v26, v37, v30, v26
v_dot4_i32_i8 v26, v38, v27, v26
v_dot4_i32_i8 v46, v39, v31, v26
v_dot4_i32_i8 v26, v40, v28, v13
v_dot4_i32_i8 v26, v41, v32, v26
v_dot4_i32_i8 v26, v42, v29, v26
v_dot4_i32_i8 v47, v43, v33, v26
global_load_dwordx2 v[34:35], v[8:9], off
v_mov_b32_e32 v27, s35
v_add_co_u32_e32 v26, vcc, s34, v14
v_addc_co_u32_e32 v27, vcc, 0, v27, vcc
v_mov_b32_e32 v31, s39
v_add_co_u32_e32 v30, vcc, s38, v14
global_load_dwordx4 v[26:29], v[26:27], off
v_addc_co_u32_e32 v31, vcc, 0, v31, vcc
global_load_dwordx4 v[30:33], v[30:31], off
v_cvt_f32_i32_e32 v47, v47
v_cvt_f32_i32_e32 v46, v46
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v35, v44, v35
v_mul_f32_e32 v34, v45, v34
v_mul_f32_e32 v35, v47, v35
v_fmac_f32_e32 v35, v46, v34
v_add_f32_e32 v23, v23, v35
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v26, v36, v26, v13
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v26, v37, v30, v26
v_dot4_i32_i8 v26, v38, v27, v26
v_dot4_i32_i8 v30, v39, v31, v26
v_dot4_i32_i8 v26, v40, v28, v13
v_dot4_i32_i8 v26, v41, v32, v26
v_dot4_i32_i8 v26, v42, v29, v26
v_dot4_i32_i8 v28, v43, v33, v26
v_mov_b32_e32 v27, s17
v_add_co_u32_e32 v26, vcc, s16, v8
v_addc_co_u32_e32 v27, vcc, v9, v27, vcc
global_load_dwordx2 v[26:27], v[26:27], off
s_add_u32 s40, s40, 0x400
s_addc_u32 s41, s41, 0
v_cvt_f32_i32_e32 v28, v28
s_add_u32 s38, s38, 0x400
v_cvt_f32_i32_e32 v29, v30
v_add_co_u32_e32 v8, vcc, s7, v8
s_addc_u32 s39, s39, 0
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
s_add_u32 s36, s36, 0x400
v_add_co_u32_e32 v4, vcc, 0x80, v4
s_addc_u32 s37, s37, 0
v_add_u32_e32 v25, 64, v25
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_add_u32 s34, s34, 0x400
v_cmp_le_i32_e64 s[4:5], s42, v25
v_add_co_u32_e32 v6, vcc, 0x400, v6
s_addc_u32 s35, s35, 0
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_or_b64 s[30:31], s[4:5], s[30:31]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v27, v44, v27
v_mul_f32_e32 v26, v45, v26
v_mul_f32_e32 v27, v28, v27
v_fmac_f32_e32 v27, v29, v26
v_add_f32_e32 v24, v24, v27
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65307
s_or_b64 exec, exec, s[30:31]
s_or_b64 exec, exec, s[28:29]
s_waitcnt lgkmcnt(1)
v_and_b32_e32 v6, 63, v21
v_and_b32_e32 v4, 64, v21
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v7, 64, v4
v_xor_b32_e32 v4, 32, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v21, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v5, v4, v23
ds_bpermute_b32 v4, v4, v24
v_xor_b32_e32 v8, 16, v6
v_cmp_lt_i32_e32 vcc, v8, v7
v_cndmask_b32_e32 v8, v21, v8, vcc
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v23, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v24, v4
v_lshlrev_b32_e32 v8, 2, v8
ds_bpermute_b32 v9, v8, v5
ds_bpermute_b32 v8, v8, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v8
v_xor_b32_e32 v8, 8, v6
v_cmp_lt_i32_e32 vcc, v8, v7
v_cndmask_b32_e32 v8, v21, v8, vcc
v_lshlrev_b32_e32 v8, 2, v8
ds_bpermute_b32 v9, v8, v5
ds_bpermute_b32 v8, v8, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v8
v_xor_b32_e32 v8, 4, v6
v_cmp_lt_i32_e32 vcc, v8, v7
v_cndmask_b32_e32 v8, v21, v8, vcc
v_lshlrev_b32_e32 v8, 2, v8
ds_bpermute_b32 v9, v8, v5
ds_bpermute_b32 v8, v8, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v4, v8
v_xor_b32_e32 v4, 2, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v21, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v5
ds_bpermute_b32 v23, v4, v8
v_xor_b32_e32 v6, 1, v6
v_cmp_lt_i32_e32 vcc, v6, v7
v_cndmask_b32_e32 v6, v21, v6, vcc
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v4, v5, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v8, v23
v_lshlrev_b32_e32 v7, 2, v6
ds_bpermute_b32 v6, v7, v4
ds_bpermute_b32 v7, v7, v5
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 65202
v_add_u32_e32 v8, s33, v10
v_ashrrev_i32_e32 v9, 31, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v7, v5, v7
v_add_f32_e32 v6, v4, v6
v_lshlrev_b64 v[4:5], 2, v[8:9]
v_mov_b32_e32 v8, s19
v_add_co_u32_e32 v4, vcc, s18, v4
v_addc_co_u32_e32 v5, vcc, v8, v5, vcc
global_store_dword v[4:5], v6, off
v_mov_b32_e32 v6, s21
v_add_co_u32_e32 v4, vcc, s20, v4
v_addc_co_u32_e32 v5, vcc, v5, v6, vcc
global_store_dword v[4:5], v7, off
s_branch 65184
s_endpgm
