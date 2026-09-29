.text
k__Z10nvfp4_gemvILi3ELi4EEvPKjPKhPKaS5_PKfPfiif:
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
s_lshl_b32 s0, s6, 4
v_lshrrev_b32_e32 v1, 4, v0
v_and_or_b32 v16, v1, 12, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v16
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 414
v_add_u32_e32 v1, 4, v16
v_sub_u32_e32 v2, s20, v16
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v17, 4, v2, vcc
s_mov_b32 s33, 0
v_cmp_lt_i32_e32 vcc, 0, v17
s_and_b64 exec, exec, vcc
s_cbranch_execz 406
s_ashr_i32 s0, s21, 31
s_lshr_b32 s1, s0, 29
s_lshr_b32 s0, s0, 28
s_add_i32 s0, s21, s0
s_ashr_i32 s4, s0, 4
s_lshr_b32 s0, s21, 31
s_add_i32 s1, s21, s1
s_add_i32 s0, s21, s0
s_ashr_i32 s30, s1, 3
s_ashr_i32 s26, s0, 1
s_ashr_i32 s31, s30, 31
s_ashr_i32 s5, s4, 31
s_ashr_i32 s27, s26, 31
s_ashr_i32 s21, s20, 31
s_add_u32 s6, s12, s26
s_addc_u32 s7, s13, s27
s_add_u32 s22, s14, s26
v_and_b32_e32 v0, 63, v0
s_addc_u32 s23, s15, s27
s_add_u32 s24, s6, s26
v_lshl_add_u32 v1, s4, 1, v0
s_addc_u32 s25, s7, s27
v_ashrrev_i32_e32 v2, 31, v1
s_add_u32 s26, s22, s26
v_lshlrev_b64 v[2:3], 2, v[1:2]
s_addc_u32 s27, s23, s27
s_lshl_b64 s[28:29], s[4:5], 2
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v2, vcc, s16, v2
s_add_u32 s14, s14, 4
v_addc_co_u32_e32 v3, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v4, 2, v0
s_addc_u32 s15, s15, 0
v_add_co_u32_e32 v4, vcc, s16, v4
s_add_u32 s12, s12, 4
v_mbcnt_lo_u32_b32 v6, -1, 0
v_cmp_gt_i32_e64 s[0:1], s4, v0
v_cmp_eq_u32_e64 s[2:3], 0, v0
v_mov_b32_e32 v1, 0
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_lshlrev_b32_e32 v18, 3, v0
s_addc_u32 s13, s13, 0
s_lshl_b64 s[16:17], s[30:31], 2
s_mov_b64 s[30:31], 0
s_lshl_b64 s[20:21], s[20:21], 2
v_mov_b32_e32 v19, 0xc080604
v_mov_b32_e32 v20, 0x3020100
v_mov_b32_e32 v21, 0xf4f8fafc
s_movk_i32 s5, 0x100
v_mbcnt_hi_u32_b32 v22, -1, v6
v_mov_b32_e32 v23, v16
s_branch 7
s_or_b64 exec, exec, s[34:35]
s_add_i32 s33, s33, 1
v_cmp_ge_i32_e32 vcc, s33, v17
s_or_b64 s[30:31], vcc, s[30:31]
v_add_u32_e32 v23, 1, v23
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execz 338
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v24, 0
s_and_saveexec_b64 s[34:35], s[0:1]
s_cbranch_execz 210
v_mov_b32_e32 v6, s10
s_waitcnt lgkmcnt(2)
v_mov_b32_e32 v8, s8
v_mov_b32_e32 v7, s11
v_mov_b32_e32 v9, s9
v_mad_i64_i32 v[6:7], s[36:37], v23, s4, v[6:7]
v_mad_i64_i32 v[8:9], s[36:37], v23, s16, v[8:9]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v11, v5
v_mov_b32_e32 v13, v1
v_mov_b32_e32 v15, v3
s_mov_b64 s[36:37], 0
v_mov_b32_e32 v24, 0
s_mov_b64 s[38:39], s[6:7]
s_mov_b64 s[40:41], s[22:23]
s_mov_b64 s[42:43], s[24:25]
s_mov_b64 s[44:45], s[12:13]
s_mov_b64 s[46:47], s[26:27]
s_mov_b64 s[48:49], s[14:15]
v_mov_b32_e32 v10, v4
v_mov_b32_e32 v12, v0
v_mov_b32_e32 v14, v2
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_add_co_u32_e32 v27, vcc, v8, v18
v_addc_co_u32_e32 v28, vcc, 0, v9, vcc
global_load_dwordx2 v[27:28], v[27:28], off
s_waitcnt vmcnt(0)
v_and_b32_e32 v29, 0x7070707, v27
v_lshrrev_b32_e32 v30, 3, v27
v_lshrrev_b32_e32 v31, 4, v27
v_lshrrev_b32_e32 v27, 7, v27
v_and_b32_e32 v30, 0x1010101, v30
v_and_b32_e32 v31, 0x7070707, v31
v_and_b32_e32 v27, 0x1010101, v27
v_perm_b32 v32, v19, v20, v29
v_mov_b32_e32 v33, 0xfdfeff00
v_perm_b32 v29, v21, v33, v29
v_mov_b32_e32 v34, 0xff00
v_perm_b32 v30, v1, v34, v30
v_bfi_b32 v32, v30, v29, v32
v_perm_b32 v29, v19, v20, v31
v_perm_b32 v30, v21, v33, v31
v_perm_b32 v27, v1, v34, v27
v_bfi_b32 v31, v27, v30, v29
v_and_b32_e32 v27, 0x7070707, v28
v_lshrrev_b32_e32 v29, 3, v28
v_lshrrev_b32_e32 v30, 4, v28
v_lshrrev_b32_e32 v28, 7, v28
v_and_b32_e32 v29, 0x1010101, v29
v_and_b32_e32 v30, 0x7070707, v30
v_and_b32_e32 v28, 0x1010101, v28
v_perm_b32 v35, v19, v20, v27
v_perm_b32 v27, v21, v33, v27
v_perm_b32 v29, v1, v34, v29
v_bfi_b32 v35, v29, v27, v35
v_perm_b32 v36, v19, v20, v30
v_perm_b32 v33, v21, v33, v30
v_perm_b32 v34, v1, v34, v28
v_add_co_u32_e32 v27, vcc, v6, v12
v_addc_co_u32_e32 v28, vcc, v7, v13, vcc
global_load_ubyte v37, v[27:28], off
v_mov_b32_e32 v28, s45
v_add_co_u32_e32 v27, vcc, s44, v18
v_addc_co_u32_e32 v28, vcc, 0, v28, vcc
v_mov_b32_e32 v30, s49
v_add_co_u32_e32 v29, vcc, s48, v18
global_load_dwordx2 v[27:28], v[27:28], off offset:-4
v_addc_co_u32_e32 v30, vcc, 0, v30, vcc
global_load_dwordx2 v[29:30], v[29:30], off offset:-4
v_bfi_b32 v33, v34, v33, v36
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v37, 2, v37
ds_read_b32 v37, v37
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v27, v32, v27, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v27, v31, v29, v27
v_dot4_i32_i8 v27, v35, v28, v27
v_dot4_i32_i8 v34, v33, v30, v27
v_mov_b32_e32 v28, s39
v_add_co_u32_e32 v27, vcc, s38, v18
global_load_dword v36, v[10:11], off
v_addc_co_u32_e32 v28, vcc, 0, v28, vcc
v_mov_b32_e32 v30, s41
v_add_co_u32_e32 v29, vcc, s40, v18
global_load_dwordx2 v[27:28], v[27:28], off
v_addc_co_u32_e32 v30, vcc, 0, v30, vcc
global_load_dwordx2 v[29:30], v[29:30], off
v_cvt_f32_i32_e32 v34, v34
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v36, v37, v36
v_fmac_f32_e32 v24, v34, v36
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v27, v32, v27, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v27, v31, v29, v27
v_dot4_i32_i8 v27, v35, v28, v27
v_dot4_i32_i8 v34, v33, v30, v27
v_mov_b32_e32 v28, s29
v_add_co_u32_e32 v27, vcc, s28, v10
v_addc_co_u32_e32 v28, vcc, v11, v28, vcc
global_load_dword v36, v[27:28], off
v_mov_b32_e32 v28, s43
v_add_co_u32_e32 v27, vcc, s42, v18
v_addc_co_u32_e32 v28, vcc, 0, v28, vcc
v_mov_b32_e32 v30, s47
v_add_co_u32_e32 v29, vcc, s46, v18
global_load_dwordx2 v[27:28], v[27:28], off
v_addc_co_u32_e32 v30, vcc, 0, v30, vcc
global_load_dwordx2 v[29:30], v[29:30], off
v_cvt_f32_i32_e32 v34, v34
s_waitcnt vmcnt(2)
v_mul_f32_e32 v36, v37, v36
v_fmac_f32_e32 v26, v34, v36
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v27, v32, v27, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v27, v31, v29, v27
v_dot4_i32_i8 v27, v35, v28, v27
v_dot4_i32_i8 v27, v33, v30, v27
global_load_dword v28, v[14:15], off
s_add_u32 s48, s48, 0x200
s_addc_u32 s49, s49, 0
s_add_u32 s46, s46, 0x200
v_add_co_u32_e32 v14, vcc, s5, v14
s_addc_u32 s47, s47, 0
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
s_add_u32 s44, s44, 0x200
v_add_co_u32_e32 v12, vcc, 64, v12
s_addc_u32 s45, s45, 0
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
s_add_u32 s42, s42, 0x200
v_add_co_u32_e32 v10, vcc, s5, v10
s_addc_u32 s43, s43, 0
v_cvt_f32_i32_e32 v27, v27
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
s_add_u32 s40, s40, 0x200
v_add_co_u32_e32 v8, vcc, 0x200, v8
s_addc_u32 s41, s41, 0
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
s_add_u32 s38, s38, 0x200
v_cmp_le_i32_e32 vcc, s4, v12
s_addc_u32 s39, s39, 0
s_or_b64 s[36:37], vcc, s[36:37]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v28, v37, v28
v_fmac_f32_e32 v25, v27, v28
s_andn2_b64 exec, exec, s[36:37]
s_cbranch_execnz 65353
s_or_b64 exec, exec, s[36:37]
s_or_b64 exec, exec, s[34:35]
s_waitcnt lgkmcnt(2)
v_and_b32_e32 v9, 63, v22
v_and_b32_e32 v6, 64, v22
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v10, 64, v6
v_xor_b32_e32 v6, 32, v9
v_cmp_lt_i32_e32 vcc, v6, v10
v_cndmask_b32_e32 v6, v22, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v7, v6, v24
ds_bpermute_b32 v8, v6, v26
ds_bpermute_b32 v6, v6, v25
s_waitcnt lgkmcnt(3)
v_xor_b32_e32 v11, 16, v9
v_cmp_lt_i32_e32 vcc, v11, v10
v_cndmask_b32_e32 v11, v22, v11, vcc
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v7, v24, v7
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v26, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v25, v6
v_lshlrev_b32_e32 v11, 2, v11
ds_bpermute_b32 v12, v11, v7
ds_bpermute_b32 v13, v11, v8
ds_bpermute_b32 v11, v11, v6
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v7, v7, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v11
v_xor_b32_e32 v11, 8, v9
v_cmp_lt_i32_e32 vcc, v11, v10
v_cndmask_b32_e32 v11, v22, v11, vcc
v_lshlrev_b32_e32 v11, 2, v11
ds_bpermute_b32 v12, v11, v7
ds_bpermute_b32 v13, v11, v8
ds_bpermute_b32 v11, v11, v6
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v7, v7, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v11
v_xor_b32_e32 v11, 4, v9
v_cmp_lt_i32_e32 vcc, v11, v10
v_cndmask_b32_e32 v11, v22, v11, vcc
v_lshlrev_b32_e32 v11, 2, v11
ds_bpermute_b32 v12, v11, v7
ds_bpermute_b32 v13, v11, v8
ds_bpermute_b32 v11, v11, v6
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v7, v7, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v11, v6, v11
v_xor_b32_e32 v6, 2, v9
v_cmp_lt_i32_e32 vcc, v6, v10
v_cndmask_b32_e32 v6, v22, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v12, v6, v7
ds_bpermute_b32 v13, v6, v8
ds_bpermute_b32 v14, v6, v11
v_xor_b32_e32 v9, 1, v9
v_cmp_lt_i32_e32 vcc, v9, v10
v_cndmask_b32_e32 v9, v22, v9, vcc
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v7, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v7, v8, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v11, v14
v_lshlrev_b32_e32 v11, 2, v9
ds_bpermute_b32 v9, v11, v6
ds_bpermute_b32 v10, v11, v7
ds_bpermute_b32 v11, v11, v8
s_and_saveexec_b64 s[34:35], s[2:3]
s_cbranch_execz 65215
v_add_u32_e32 v12, s33, v16
v_ashrrev_i32_e32 v13, 31, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v10, v7, v10
v_add_f32_e32 v9, v6, v9
v_lshlrev_b64 v[6:7], 2, v[12:13]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v11
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v6, vcc, s18, v6
v_addc_co_u32_e32 v7, vcc, v11, v7, vcc
global_store_dword v[6:7], v9, off
v_mov_b32_e32 v9, s21
v_add_co_u32_e32 v6, vcc, s20, v6
v_addc_co_u32_e32 v7, vcc, v7, v9, vcc
global_store_dword v[6:7], v10, off
v_add_co_u32_e32 v6, vcc, s20, v6
v_addc_co_u32_e32 v7, vcc, v7, v9, vcc
global_store_dword v[6:7], v8, off
s_branch 65191
s_endpgm
