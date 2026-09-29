.text
k__Z10nvfp4_gemvILi1ELi2EEvPKjPKhPKaS5_PKfPfiif:
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
v_and_or_b32 v22, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v22
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 253
v_add_u32_e32 v1, 2, v22
v_sub_u32_e32 v2, s20, v22
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v23, 2, v2, vcc
s_mov_b32 s20, 0
v_cmp_lt_i32_e32 vcc, 0, v23
s_and_b64 exec, exec, vcc
s_cbranch_execz 245
v_and_b32_e32 v0, 63, v0
v_lshlrev_b32_e32 v2, 2, v0
v_mov_b32_e32 v3, s17
v_add_co_u32_e32 v2, vcc, s16, v2
s_ashr_i32 s0, s21, 31
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_lshl_or_b32 v8, v0, 3, 4
s_lshr_b32 s1, s0, 29
v_mov_b32_e32 v5, s15
v_add_co_u32_e32 v4, vcc, s14, v8
s_add_i32 s1, s21, s1
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
s_ashr_i32 s4, s1, 3
s_lshr_b32 s0, s0, 28
v_mov_b32_e32 v7, s9
v_add_co_u32_e32 v6, vcc, s8, v8
s_add_i32 s0, s21, s0
s_ashr_i32 s5, s4, 31
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
s_ashr_i32 s21, s0, 4
s_lshl_b64 s[6:7], s[4:5], 2
v_mov_b32_e32 v9, s13
v_add_co_u32_e32 v8, vcc, s12, v8
v_mbcnt_lo_u32_b32 v10, -1, 0
v_cmp_gt_i32_e64 s[0:1], s21, v0
v_cmp_eq_u32_e64 s[2:3], 0, v0
v_mov_b32_e32 v1, 0
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
s_mov_b64 s[8:9], 0
v_mov_b32_e32 v24, 0xc080604
v_mov_b32_e32 v25, 0x3020100
v_mov_b32_e32 v26, 0xf4f8fafc
s_movk_i32 s7, 0x100
s_movk_i32 s16, 0x200
v_mbcnt_hi_u32_b32 v27, -1, v10
v_mov_b32_e32 v28, v22
s_branch 7
s_or_b64 exec, exec, s[4:5]
s_add_i32 s20, s20, 1
v_cmp_ge_i32_e32 vcc, s20, v23
s_or_b64 s[8:9], vcc, s[8:9]
v_add_u32_e32 v28, 1, v28
s_andn2_b64 exec, exec, s[8:9]
s_cbranch_execz 193
v_mov_b32_e32 v29, 0
s_and_saveexec_b64 s[12:13], s[0:1]
s_cbranch_execz 125
v_mov_b32_e32 v13, s11
v_mov_b32_e32 v12, s10
s_waitcnt lgkmcnt(0)
v_mad_i64_i32 v[10:11], s[4:5], v28, s6, v[6:7]
v_mad_i64_i32 v[12:13], s[4:5], v28, s21, v[12:13]
v_mov_b32_e32 v15, v9
v_mov_b32_e32 v17, v5
v_mov_b32_e32 v19, v3
v_mov_b32_e32 v21, v1
s_mov_b64 s[14:15], 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v14, v8
v_mov_b32_e32 v16, v4
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v18, v2
v_mov_b32_e32 v20, v0
global_load_dwordx2 v[31:32], v[10:11], off offset:-4
s_waitcnt vmcnt(0)
v_and_b32_e32 v33, 0x7070707, v31
v_lshrrev_b32_e32 v34, 3, v31
v_lshrrev_b32_e32 v35, 4, v31
v_lshrrev_b32_e32 v31, 7, v31
v_and_b32_e32 v34, 0x1010101, v34
v_and_b32_e32 v35, 0x7070707, v35
v_and_b32_e32 v31, 0x1010101, v31
v_perm_b32 v36, v24, v25, v33
v_mov_b32_e32 v37, 0xfdfeff00
v_perm_b32 v33, v26, v37, v33
v_mov_b32_e32 v38, 0xff00
v_perm_b32 v34, v1, v38, v34
v_bfi_b32 v39, v34, v33, v36
v_perm_b32 v33, v24, v25, v35
v_perm_b32 v34, v26, v37, v35
v_perm_b32 v31, v1, v38, v31
v_bfi_b32 v40, v31, v34, v33
v_and_b32_e32 v31, 0x7070707, v32
v_lshrrev_b32_e32 v33, 3, v32
v_lshrrev_b32_e32 v34, 4, v32
v_lshrrev_b32_e32 v32, 7, v32
v_and_b32_e32 v33, 0x1010101, v33
v_and_b32_e32 v34, 0x7070707, v34
v_and_b32_e32 v32, 0x1010101, v32
v_perm_b32 v35, v24, v25, v31
v_perm_b32 v31, v26, v37, v31
v_perm_b32 v33, v1, v38, v33
v_bfi_b32 v41, v33, v31, v35
v_perm_b32 v42, v24, v25, v34
v_perm_b32 v37, v26, v37, v34
v_perm_b32 v38, v1, v38, v32
v_add_co_u32_e32 v31, vcc, v12, v20
v_addc_co_u32_e32 v32, vcc, v13, v21, vcc
global_load_ubyte v43, v[31:32], off
global_load_dwordx2 v[33:34], v[14:15], off offset:-4
global_load_dwordx2 v[35:36], v[16:17], off offset:-4
v_bfi_b32 v32, v38, v37, v42
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v31, 2, v43
ds_read_b32 v31, v31
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v33, v39, v33, v30
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v33, v40, v35, v33
v_dot4_i32_i8 v33, v41, v34, v33
v_dot4_i32_i8 v32, v32, v36, v33
global_load_dword v33, v[18:19], off
v_add_co_u32_e32 v20, vcc, 64, v20
v_addc_co_u32_e32 v21, vcc, 0, v21, vcc
v_add_co_u32_e32 v18, vcc, s7, v18
v_addc_co_u32_e32 v19, vcc, 0, v19, vcc
v_add_co_u32_e32 v16, vcc, s16, v16
v_cvt_f32_i32_e32 v32, v32
v_addc_co_u32_e32 v17, vcc, 0, v17, vcc
v_add_co_u32_e32 v10, vcc, 0x200, v10
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_cmp_le_i32_e64 s[4:5], s21, v20
v_add_co_u32_e32 v14, vcc, 0x200, v14
s_or_b64 s[14:15], s[4:5], s[14:15]
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
s_waitcnt vmcnt(0) lgkmcnt(0)
v_mul_f32_e32 v31, v31, v33
v_fmac_f32_e32 v29, v32, v31
s_andn2_b64 exec, exec, s[14:15]
s_cbranch_execnz 65430
s_or_b64 exec, exec, s[14:15]
s_or_b64 exec, exec, s[12:13]
v_and_b32_e32 v10, 63, v27
s_waitcnt lgkmcnt(0)
v_and_b32_e32 v11, 64, v27
v_add_u32_e32 v11, 64, v11
v_xor_b32_e32 v12, 32, v10
v_cmp_lt_i32_e32 vcc, v12, v11
v_cndmask_b32_e32 v12, v27, v12, vcc
v_lshlrev_b32_e32 v12, 2, v12
ds_bpermute_b32 v12, v12, v29
v_xor_b32_e32 v13, 16, v10
v_cmp_lt_i32_e32 vcc, v13, v11
v_cndmask_b32_e32 v13, v27, v13, vcc
v_lshlrev_b32_e32 v13, 2, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v29, v12
ds_bpermute_b32 v13, v13, v12
v_xor_b32_e32 v14, 8, v10
v_cmp_lt_i32_e32 vcc, v14, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v13
v_cndmask_b32_e32 v13, v27, v14, vcc
v_lshlrev_b32_e32 v13, 2, v13
ds_bpermute_b32 v13, v13, v12
v_xor_b32_e32 v14, 4, v10
v_cmp_lt_i32_e32 vcc, v14, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v13
v_cndmask_b32_e32 v13, v27, v14, vcc
v_lshlrev_b32_e32 v13, 2, v13
ds_bpermute_b32 v13, v13, v12
v_xor_b32_e32 v14, 2, v10
v_cmp_lt_i32_e32 vcc, v14, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v13
v_cndmask_b32_e32 v13, v27, v14, vcc
v_lshlrev_b32_e32 v13, 2, v13
ds_bpermute_b32 v13, v13, v12
v_xor_b32_e32 v14, 1, v10
v_cmp_lt_i32_e32 vcc, v14, v11
v_cndmask_b32_e32 v11, v27, v14, vcc
v_lshlrev_b32_e32 v11, 2, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v12, v13
ds_bpermute_b32 v11, v11, v10
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 65348
v_add_u32_e32 v12, s20, v22
v_ashrrev_i32_e32 v13, 31, v12
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v14, v10, v11
v_lshlrev_b64 v[10:11], 2, v[12:13]
v_mov_b32_e32 v12, s19
v_add_co_u32_e32 v10, vcc, s18, v10
v_addc_co_u32_e32 v11, vcc, v12, v11, vcc
global_store_dword v[10:11], v14, off
s_branch 65336
s_endpgm
