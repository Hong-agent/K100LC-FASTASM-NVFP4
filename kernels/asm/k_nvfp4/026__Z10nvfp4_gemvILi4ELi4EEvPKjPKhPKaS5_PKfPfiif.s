.text
k__Z10nvfp4_gemvILi4ELi4EEvPKjPKhPKaS5_PKfPfiif:
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
v_and_or_b32 v22, v1, 12, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v22
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 445
v_add_u32_e32 v1, 4, v22
v_sub_u32_e32 v2, s20, v22
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v23, 4, v2, vcc
s_mov_b32 s26, 0
v_cmp_lt_i32_e32 vcc, 0, v23
s_and_b64 exec, exec, vcc
s_cbranch_execz 437
s_ashr_i32 s0, s21, 31
s_lshr_b32 s1, s0, 29
s_lshr_b32 s0, s0, 28
s_add_i32 s0, s21, s0
v_and_b32_e32 v0, 63, v0
s_ashr_i32 s6, s0, 4
s_ashr_i32 s7, s6, 31
v_mad_u64_u32 v[4:5], s[22:23], s6, 3, v[0:1]
s_lshl_b64 s[22:23], s[6:7], 2
v_lshlrev_b32_e32 v24, 2, v0
v_mov_b32_e32 v6, s23
v_add_co_u32_e32 v25, vcc, s22, v24
v_addc_co_u32_e32 v26, vcc, 0, v6, vcc
v_lshlrev_b32_e32 v10, 3, v0
v_mov_b32_e32 v7, s15
v_add_co_u32_e32 v6, vcc, s14, v10
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
v_mov_b32_e32 v8, s9
v_add_co_u32_e32 v9, vcc, s8, v10
v_addc_co_u32_e32 v11, vcc, 0, v8, vcc
s_add_i32 s1, s21, s1
s_lshr_b32 s0, s21, 31
v_lshl_add_u32 v1, s6, 1, v0
v_add_co_u32_e32 v8, vcc, 4, v9
s_ashr_i32 s4, s1, 3
s_add_i32 s0, s21, s0
v_ashrrev_i32_e32 v2, 31, v1
v_ashrrev_i32_e32 v5, 31, v4
v_addc_co_u32_e32 v9, vcc, 0, v11, vcc
s_ashr_i32 s27, s0, 1
s_ashr_i32 s5, s4, 31
s_ashr_i32 s21, s20, 31
v_lshlrev_b64 v[2:3], 2, v[1:2]
v_lshlrev_b64 v[4:5], 2, v[4:5]
v_mov_b32_e32 v11, s13
v_add_co_u32_e32 v10, vcc, s12, v10
v_mbcnt_lo_u32_b32 v12, -1, 0
v_cmp_gt_i32_e64 s[0:1], s6, v0
s_ashr_i32 s28, s27, 31
v_cmp_eq_u32_e64 s[2:3], 0, v0
v_mov_b32_e32 v1, 0
s_lshl_b64 s[8:9], s[4:5], 2
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
s_mov_b64 s[12:13], 0
s_lshl_b64 s[14:15], s[20:21], 2
s_movk_i32 s7, 0x200
v_mbcnt_hi_u32_b32 v27, -1, v12
v_mov_b32_e32 v28, v22
s_branch 7
s_or_b64 exec, exec, s[4:5]
s_add_i32 s26, s26, 1
v_cmp_ge_i32_e32 vcc, s26, v23
s_or_b64 s[12:13], vcc, s[12:13]
v_add_u32_e32 v28, 1, v28
s_andn2_b64 exec, exec, s[12:13]
s_cbranch_execz 373
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v29, 0
s_and_saveexec_b64 s[20:21], s[0:1]
s_cbranch_execz 216
v_mov_b32_e32 v15, s11
v_mov_b32_e32 v14, s10
v_mad_i64_i32 v[12:13], s[4:5], v28, s8, v[8:9]
v_mad_i64_i32 v[14:15], s[4:5], v28, s6, v[14:15]
s_waitcnt lgkmcnt(2)
v_mov_b32_e32 v17, v11
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v19, v7
v_mov_b32_e32 v21, v1
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v16, v10
v_mov_b32_e32 v18, v6
s_mov_b64 s[24:25], s[16:17]
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v20, v0
global_load_dwordx2 v[33:34], v[12:13], off offset:-4
v_mov_b32_e32 v35, 0xc080604
v_mov_b32_e32 v36, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v37, 0x7070707, v33
v_lshrrev_b32_e32 v38, 3, v33
v_lshrrev_b32_e32 v39, 4, v33
v_lshrrev_b32_e32 v33, 7, v33
v_and_b32_e32 v38, 0x1010101, v38
v_and_b32_e32 v39, 0x7070707, v39
v_and_b32_e32 v33, 0x1010101, v33
v_perm_b32 v40, v35, v36, v37
v_mov_b32_e32 v41, 0xf4f8fafc
v_mov_b32_e32 v42, 0xfdfeff00
v_perm_b32 v37, v41, v42, v37
v_mov_b32_e32 v43, 0xff00
v_perm_b32 v38, v1, v43, v38
v_bfi_b32 v44, v38, v37, v40
v_perm_b32 v37, v35, v36, v39
v_perm_b32 v38, v41, v42, v39
v_perm_b32 v33, v1, v43, v33
v_bfi_b32 v45, v33, v38, v37
v_and_b32_e32 v33, 0x7070707, v34
v_lshrrev_b32_e32 v37, 3, v34
v_lshrrev_b32_e32 v38, 4, v34
v_lshrrev_b32_e32 v34, 7, v34
v_and_b32_e32 v37, 0x1010101, v37
v_and_b32_e32 v38, 0x7070707, v38
v_and_b32_e32 v34, 0x1010101, v34
v_perm_b32 v39, v35, v36, v33
v_perm_b32 v33, v41, v42, v33
v_perm_b32 v37, v1, v43, v37
v_bfi_b32 v46, v37, v33, v39
v_perm_b32 v39, v35, v36, v38
v_perm_b32 v40, v41, v42, v38
v_perm_b32 v41, v1, v43, v34
v_add_co_u32_e32 v33, vcc, v14, v20
v_addc_co_u32_e32 v34, vcc, v15, v21, vcc
global_load_ubyte v42, v[33:34], off
global_load_dwordx2 v[35:36], v[16:17], off
global_load_dwordx2 v[37:38], v[18:19], off
v_bfi_b32 v41, v41, v40, v39
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v33, 2, v42
ds_read_b32 v42, v33
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v33, v44, v35, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v33, v45, v37, v33
v_dot4_i32_i8 v33, v46, v36, v33
v_dot4_i32_i8 v43, v41, v38, v33
v_mov_b32_e32 v47, s25
v_add_co_u32_e32 v33, vcc, s24, v24
v_addc_co_u32_e32 v34, vcc, 0, v47, vcc
global_load_dword v48, v[33:34], off
v_mov_b32_e32 v49, s28
v_add_co_u32_e32 v33, vcc, s27, v16
v_addc_co_u32_e32 v34, vcc, v17, v49, vcc
v_add_co_u32_e32 v37, vcc, s27, v18
global_load_dwordx2 v[35:36], v[33:34], off
v_addc_co_u32_e32 v38, vcc, v19, v49, vcc
global_load_dwordx2 v[39:40], v[37:38], off
v_cvt_f32_i32_e32 v43, v43
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v48, v42, v48
v_fmac_f32_e32 v29, v43, v48
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v35, v44, v35, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v35, v45, v39, v35
v_dot4_i32_i8 v35, v46, v36, v35
v_dot4_i32_i8 v43, v41, v40, v35
v_add_co_u32_e32 v35, vcc, s24, v25
v_addc_co_u32_e32 v36, vcc, v47, v26, vcc
v_add_co_u32_e32 v33, vcc, s27, v33
global_load_dword v48, v[35:36], off
v_addc_co_u32_e32 v34, vcc, v34, v49, vcc
v_add_co_u32_e32 v37, vcc, s27, v37
global_load_dwordx2 v[35:36], v[33:34], off
v_addc_co_u32_e32 v38, vcc, v38, v49, vcc
global_load_dwordx2 v[39:40], v[37:38], off
v_cvt_f32_i32_e32 v43, v43
s_waitcnt vmcnt(2)
v_mul_f32_e32 v48, v42, v48
v_fmac_f32_e32 v32, v43, v48
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v35, v44, v35, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v35, v45, v39, v35
v_dot4_i32_i8 v35, v46, v36, v35
v_dot4_i32_i8 v39, v41, v40, v35
v_add_co_u32_e32 v35, vcc, s24, v2
v_addc_co_u32_e32 v36, vcc, v47, v3, vcc
v_add_co_u32_e32 v33, vcc, s27, v33
global_load_dword v40, v[35:36], off
v_addc_co_u32_e32 v34, vcc, v34, v49, vcc
v_add_co_u32_e32 v35, vcc, s27, v37
global_load_dwordx2 v[33:34], v[33:34], off
v_addc_co_u32_e32 v36, vcc, v38, v49, vcc
global_load_dwordx2 v[35:36], v[35:36], off
v_cvt_f32_i32_e32 v37, v39
s_waitcnt vmcnt(2)
v_mul_f32_e32 v38, v42, v40
v_fmac_f32_e32 v31, v37, v38
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v33, v44, v33, v1
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v33, v45, v35, v33
v_dot4_i32_i8 v33, v46, v34, v33
v_dot4_i32_i8 v35, v41, v36, v33
v_add_co_u32_e32 v33, vcc, s24, v4
v_addc_co_u32_e32 v34, vcc, v47, v5, vcc
global_load_dword v33, v[33:34], off
v_add_co_u32_e32 v20, vcc, 64, v20
v_addc_co_u32_e32 v21, vcc, 0, v21, vcc
v_add_co_u32_e32 v18, vcc, s7, v18
v_cvt_f32_i32_e32 v34, v35
v_addc_co_u32_e32 v19, vcc, 0, v19, vcc
v_add_co_u32_e32 v12, vcc, 0x200, v12
s_add_u32 s24, s24, 0x100
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
s_addc_u32 s25, s25, 0
v_cmp_le_i32_e64 s[4:5], s6, v20
v_add_co_u32_e32 v16, vcc, 0x200, v16
s_or_b64 s[22:23], s[4:5], s[22:23]
v_addc_co_u32_e32 v17, vcc, 0, v17, vcc
s_waitcnt vmcnt(0)
v_mul_f32_e32 v33, v42, v33
v_fmac_f32_e32 v30, v34, v33
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execnz 65341
s_or_b64 exec, exec, s[22:23]
s_or_b64 exec, exec, s[20:21]
s_waitcnt lgkmcnt(3)
v_and_b32_e32 v16, 63, v27
v_and_b32_e32 v12, 64, v27
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v17, 64, v12
v_xor_b32_e32 v12, 32, v16
v_cmp_lt_i32_e32 vcc, v12, v17
v_cndmask_b32_e32 v12, v27, v12, vcc
v_lshlrev_b32_e32 v12, 2, v12
ds_bpermute_b32 v13, v12, v29
ds_bpermute_b32 v14, v12, v32
ds_bpermute_b32 v15, v12, v31
ds_bpermute_b32 v12, v12, v30
s_waitcnt lgkmcnt(5)
v_xor_b32_e32 v18, 16, v16
v_cmp_lt_i32_e32 vcc, v18, v17
v_cndmask_b32_e32 v18, v27, v18, vcc
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v13, v29, v13
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v14, v32, v14
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v15, v31, v15
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v30, v12
v_lshlrev_b32_e32 v18, 2, v18
ds_bpermute_b32 v19, v18, v13
ds_bpermute_b32 v20, v18, v14
ds_bpermute_b32 v21, v18, v15
ds_bpermute_b32 v18, v18, v12
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v13, v13, v19
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v14, v14, v20
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v15, v15, v21
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v18
v_xor_b32_e32 v18, 8, v16
v_cmp_lt_i32_e32 vcc, v18, v17
v_cndmask_b32_e32 v18, v27, v18, vcc
v_lshlrev_b32_e32 v18, 2, v18
ds_bpermute_b32 v19, v18, v13
ds_bpermute_b32 v20, v18, v14
ds_bpermute_b32 v21, v18, v15
ds_bpermute_b32 v18, v18, v12
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v13, v13, v19
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v14, v14, v20
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v15, v15, v21
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v18
v_xor_b32_e32 v18, 4, v16
v_cmp_lt_i32_e32 vcc, v18, v17
v_cndmask_b32_e32 v18, v27, v18, vcc
v_lshlrev_b32_e32 v18, 2, v18
ds_bpermute_b32 v19, v18, v13
ds_bpermute_b32 v20, v18, v14
ds_bpermute_b32 v21, v18, v15
ds_bpermute_b32 v18, v18, v12
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v13, v13, v19
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v14, v14, v20
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v15, v15, v21
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v18, v12, v18
v_xor_b32_e32 v12, 2, v16
v_cmp_lt_i32_e32 vcc, v12, v17
v_cndmask_b32_e32 v12, v27, v12, vcc
v_lshlrev_b32_e32 v12, 2, v12
ds_bpermute_b32 v19, v12, v13
ds_bpermute_b32 v20, v12, v14
ds_bpermute_b32 v21, v12, v15
ds_bpermute_b32 v29, v12, v18
v_xor_b32_e32 v16, 1, v16
v_cmp_lt_i32_e32 vcc, v16, v17
v_cndmask_b32_e32 v16, v27, v16, vcc
s_waitcnt lgkmcnt(3)
v_add_f32_e32 v12, v13, v19
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v13, v14, v20
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v14, v15, v21
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v18, v29
v_lshlrev_b32_e32 v19, 2, v16
ds_bpermute_b32 v16, v19, v12
ds_bpermute_b32 v17, v19, v13
ds_bpermute_b32 v18, v19, v14
ds_bpermute_b32 v19, v19, v15
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 65186
v_add_u32_e32 v20, s26, v22
v_ashrrev_i32_e32 v21, 31, v20
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v17, v13, v17
v_add_f32_e32 v16, v12, v16
v_lshlrev_b64 v[12:13], 2, v[20:21]
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v14, v14, v18
v_mov_b32_e32 v18, s19
v_add_co_u32_e32 v12, vcc, s18, v12
v_addc_co_u32_e32 v13, vcc, v18, v13, vcc
global_store_dword v[12:13], v16, off
v_mov_b32_e32 v16, s15
v_add_co_u32_e32 v12, vcc, s14, v12
v_addc_co_u32_e32 v13, vcc, v13, v16, vcc
global_store_dword v[12:13], v17, off
v_add_co_u32_e32 v12, vcc, s14, v12
v_addc_co_u32_e32 v13, vcc, v13, v16, vcc
global_store_dword v[12:13], v14, off
v_add_co_u32_e32 v12, vcc, s14, v12
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v19
v_addc_co_u32_e32 v13, vcc, v13, v16, vcc
global_store_dword v[12:13], v15, off
s_branch 65156
s_endpgm
