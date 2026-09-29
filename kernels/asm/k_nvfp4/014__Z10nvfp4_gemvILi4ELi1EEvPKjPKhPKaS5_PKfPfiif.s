.text
k__Z10nvfp4_gemvILi4ELi1EEvPKjPKhPKaS5_PKfPfiif:
s_load_dwordx8 s[16:23], s[4:5], 0x0
s_load_dwordx8 s[8:15], s[4:5], 0x20
s_movk_i32 s0, 0x100
v_cmp_gt_u32_e32 vcc, s0, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 68
s_load_dword s2, s[4:5], 0x4c
s_waitcnt lgkmcnt(0)
v_mul_f32_e64 v1, s14, 0.5
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
s_or_b64 exec, exec, s[14:15]
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
s_and_saveexec_b64 s[14:15], vcc
s_xor_b64 s[14:15], exec, s[14:15]
v_and_b32_e32 v6, 0x80000000, v3
v_lshlrev_b32_e32 v7, 23, v7
v_lshlrev_b32_e32 v5, 20, v5
v_or3_b32 v5, v7, v6, v5
v_add_u32_e32 v6, 0x3c000000, v5
s_andn2_saveexec_b64 s[14:15], s[14:15]
s_cbranch_execz 65493
v_cvt_f32_ubyte0_e32 v5, v5
v_mul_f32_e32 v5, 0x3b000000, v5
v_cmp_gt_u32_e32 vcc, s27, v4
v_cndmask_b32_e64 v6, -v5, v5, vcc
s_branch 65486
s_or_b64 exec, exec, s[0:1]
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v1, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s12, v1
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 413
s_ashr_i32 s0, s13, 31
s_lshr_b32 s1, s0, 28
s_add_i32 s1, s13, s1
v_and_b32_e32 v3, 63, v0
s_ashr_i32 s2, s1, 4
v_cmp_gt_i32_e32 vcc, s2, v3
v_ashrrev_i32_e32 v2, 31, v1
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v21, 0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 250
s_lshr_b32 s1, s13, 31
s_lshr_b32 s0, s0, 29
v_mov_b32_e32 v4, s18
s_add_i32 s1, s13, s1
s_add_i32 s0, s13, s0
v_mov_b32_e32 v5, s19
s_ashr_i32 s14, s1, 1
s_ashr_i32 s6, s0, 3
s_ashr_i32 s3, s2, 31
v_mad_i64_i32 v[5:6], s[0:1], v1, s2, v[4:5]
v_mad_u64_u32 v[9:10], s[0:1], s2, 3, v[3:4]
s_lshl_b64 s[0:1], s[2:3], 2
v_lshlrev_b32_e32 v22, 2, v3
v_mov_b32_e32 v0, s1
v_add_co_u32_e32 v23, vcc, s0, v22
v_mad_i64_i32 v[13:14], s[0:1], s6, v1, 0
v_addc_co_u32_e32 v24, vcc, 0, v0, vcc
v_lshlrev_b32_e32 v0, 3, v3
v_mov_b32_e32 v12, s23
v_add_co_u32_e32 v11, vcc, s22, v0
v_lshlrev_b64 v[13:14], 2, v[13:14]
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
v_add_co_u32_e32 v13, vcc, v13, v0
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
v_mov_b32_e32 v15, s17
v_add_co_u32_e32 v13, vcc, s16, v13
v_addc_co_u32_e32 v14, vcc, v14, v15, vcc
v_lshl_add_u32 v7, s2, 1, v3
v_add_co_u32_e32 v13, vcc, 4, v13
v_ashrrev_i32_e32 v8, 31, v7
v_ashrrev_i32_e32 v10, 31, v9
v_mov_b32_e32 v4, 0
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
v_lshlrev_b64 v[7:8], 2, v[7:8]
v_lshlrev_b64 v[9:10], 2, v[9:10]
v_mov_b32_e32 v16, s21
v_add_co_u32_e32 v15, vcc, s20, v0
v_mov_b32_e32 v18, v4
s_ashr_i32 s13, s14, 31
v_addc_co_u32_e32 v16, vcc, 0, v16, vcc
s_mov_b64 s[6:7], 0
s_movk_i32 s3, 0x200
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v17, v3
global_load_dwordx2 v[25:26], v[13:14], off offset:-4
v_mov_b32_e32 v27, 0xc080604
v_mov_b32_e32 v28, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v29, 0x7070707, v25
v_lshrrev_b32_e32 v30, 3, v25
v_lshrrev_b32_e32 v31, 4, v25
v_lshrrev_b32_e32 v25, 7, v25
v_and_b32_e32 v30, 0x1010101, v30
v_and_b32_e32 v31, 0x7070707, v31
v_and_b32_e32 v25, 0x1010101, v25
v_perm_b32 v32, v27, v28, v29
v_mov_b32_e32 v33, 0xf4f8fafc
v_mov_b32_e32 v34, 0xfdfeff00
v_perm_b32 v29, v33, v34, v29
v_mov_b32_e32 v35, 0xff00
v_perm_b32 v30, v4, v35, v30
v_bfi_b32 v36, v30, v29, v32
v_perm_b32 v29, v27, v28, v31
v_perm_b32 v30, v33, v34, v31
v_perm_b32 v25, v4, v35, v25
v_bfi_b32 v37, v25, v30, v29
v_and_b32_e32 v25, 0x7070707, v26
v_lshrrev_b32_e32 v29, 3, v26
v_lshrrev_b32_e32 v30, 4, v26
v_lshrrev_b32_e32 v26, 7, v26
v_and_b32_e32 v29, 0x1010101, v29
v_and_b32_e32 v30, 0x7070707, v30
v_and_b32_e32 v26, 0x1010101, v26
v_perm_b32 v31, v27, v28, v25
v_perm_b32 v25, v33, v34, v25
v_perm_b32 v29, v4, v35, v29
v_bfi_b32 v38, v29, v25, v31
v_perm_b32 v31, v27, v28, v30
v_perm_b32 v32, v33, v34, v30
v_perm_b32 v33, v4, v35, v26
v_add_co_u32_e32 v25, vcc, v5, v17
v_addc_co_u32_e32 v26, vcc, v6, v18, vcc
global_load_ubyte v34, v[25:26], off
global_load_dwordx2 v[27:28], v[15:16], off
global_load_dwordx2 v[29:30], v[11:12], off
v_bfi_b32 v33, v33, v32, v31
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v25, 2, v34
ds_read_b32 v34, v25
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v25, v36, v27, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v25, v37, v29, v25
v_dot4_i32_i8 v25, v38, v28, v25
v_dot4_i32_i8 v35, v33, v30, v25
v_mov_b32_e32 v39, s9
v_add_co_u32_e32 v25, vcc, s8, v22
v_addc_co_u32_e32 v26, vcc, 0, v39, vcc
global_load_dword v40, v[25:26], off
v_mov_b32_e32 v41, s13
v_add_co_u32_e32 v25, vcc, s14, v15
v_addc_co_u32_e32 v26, vcc, v16, v41, vcc
v_add_co_u32_e32 v29, vcc, s14, v11
global_load_dwordx2 v[27:28], v[25:26], off
v_addc_co_u32_e32 v30, vcc, v12, v41, vcc
global_load_dwordx2 v[31:32], v[29:30], off
v_cvt_f32_i32_e32 v35, v35
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v40, v34, v40
v_fmac_f32_e32 v21, v35, v40
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v27, v36, v27, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v27, v37, v31, v27
v_dot4_i32_i8 v27, v38, v28, v27
v_dot4_i32_i8 v35, v33, v32, v27
v_add_co_u32_e32 v27, vcc, s8, v23
v_addc_co_u32_e32 v28, vcc, v39, v24, vcc
v_add_co_u32_e32 v25, vcc, s14, v25
global_load_dword v40, v[27:28], off
v_addc_co_u32_e32 v26, vcc, v26, v41, vcc
v_add_co_u32_e32 v29, vcc, s14, v29
global_load_dwordx2 v[27:28], v[25:26], off
v_addc_co_u32_e32 v30, vcc, v30, v41, vcc
global_load_dwordx2 v[31:32], v[29:30], off
v_cvt_f32_i32_e32 v35, v35
s_waitcnt vmcnt(2)
v_mul_f32_e32 v40, v34, v40
v_fmac_f32_e32 v20, v35, v40
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v27, v36, v27, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v27, v37, v31, v27
v_dot4_i32_i8 v27, v38, v28, v27
v_dot4_i32_i8 v31, v33, v32, v27
v_add_co_u32_e32 v27, vcc, s8, v7
v_addc_co_u32_e32 v28, vcc, v39, v8, vcc
v_add_co_u32_e32 v25, vcc, s14, v25
global_load_dword v32, v[27:28], off
v_addc_co_u32_e32 v26, vcc, v26, v41, vcc
v_add_co_u32_e32 v27, vcc, s14, v29
global_load_dwordx2 v[25:26], v[25:26], off
v_addc_co_u32_e32 v28, vcc, v30, v41, vcc
global_load_dwordx2 v[27:28], v[27:28], off
v_cvt_f32_i32_e32 v29, v31
s_waitcnt vmcnt(2)
v_mul_f32_e32 v30, v34, v32
v_fmac_f32_e32 v19, v29, v30
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v25, v36, v25, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v25, v37, v27, v25
v_dot4_i32_i8 v25, v38, v26, v25
v_dot4_i32_i8 v27, v33, v28, v25
v_add_co_u32_e32 v25, vcc, s8, v9
v_addc_co_u32_e32 v26, vcc, v39, v10, vcc
global_load_dword v25, v[25:26], off
v_add_co_u32_e32 v17, vcc, 64, v17
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
v_add_co_u32_e32 v11, vcc, s3, v11
v_cvt_f32_i32_e32 v26, v27
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
v_add_co_u32_e32 v13, vcc, 0x200, v13
s_add_u32 s8, s8, 0x100
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
s_addc_u32 s9, s9, 0
v_cmp_le_i32_e64 s[0:1], s2, v17
v_add_co_u32_e32 v15, vcc, 0x200, v15
s_or_b64 s[6:7], s[0:1], s[6:7]
v_addc_co_u32_e32 v16, vcc, 0, v16, vcc
s_waitcnt vmcnt(0)
v_mul_f32_e32 v25, v34, v25
v_fmac_f32_e32 v0, v26, v25
s_andn2_b64 exec, exec, s[6:7]
s_cbranch_execnz 65341
s_or_b64 exec, exec, s[6:7]
s_or_b64 exec, exec, s[4:5]
v_mbcnt_lo_u32_b32 v4, -1, 0
v_mbcnt_hi_u32_b32 v7, -1, v4
v_and_b32_e32 v8, 63, v7
v_and_b32_e32 v4, 64, v7
v_add_u32_e32 v9, 64, v4
v_xor_b32_e32 v4, 32, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v7, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v5, v4, v21
ds_bpermute_b32 v6, v4, v20
ds_bpermute_b32 v10, v4, v19
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v21, v5
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v20, v6
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v10, v19, v10
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 16, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v7, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v11, v4, v5
ds_bpermute_b32 v12, v4, v6
ds_bpermute_b32 v13, v4, v10
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v10, v10, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 8, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v7, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v11, v4, v5
ds_bpermute_b32 v12, v4, v6
ds_bpermute_b32 v13, v4, v10
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v10, v10, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 4, v8
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v7, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v11, v4, v5
ds_bpermute_b32 v12, v4, v6
ds_bpermute_b32 v13, v4, v10
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v6, v6, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v10, v10, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v11, v0, v4
v_xor_b32_e32 v0, 2, v8
v_cmp_lt_i32_e32 vcc, v0, v9
v_cndmask_b32_e32 v0, v7, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v4, v0, v5
ds_bpermute_b32 v12, v0, v6
ds_bpermute_b32 v13, v0, v10
ds_bpermute_b32 v14, v0, v11
v_xor_b32_e32 v8, 1, v8
v_cmp_lt_i32_e32 vcc, v8, v9
v_cndmask_b32_e32 v7, v7, v8, vcc
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v0, v5, v4
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v4, v6, v12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v10, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v11, v14
v_lshlrev_b32_e32 v10, 2, v7
ds_bpermute_b32 v7, v10, v0
ds_bpermute_b32 v8, v10, v4
ds_bpermute_b32 v9, v10, v5
ds_bpermute_b32 v10, v10, v6
v_cmp_eq_u32_e32 vcc, 0, v3
s_and_b64 exec, exec, vcc
s_cbranch_execz 27
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v6, v10
v_add_f32_e32 v6, v0, v7
v_lshlrev_b64 v[0:1], 2, v[1:2]
s_ashr_i32 s13, s12, 31
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
s_lshl_b64 s[0:1], s[12:13], 2
global_store_dword v[0:1], v6, off
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_add_f32_e32 v4, v4, v8
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v4, off
v_add_co_u32_e32 v0, vcc, s0, v0
v_add_f32_e32 v5, v5, v9
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v5, off
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v3, off
s_endpgm
