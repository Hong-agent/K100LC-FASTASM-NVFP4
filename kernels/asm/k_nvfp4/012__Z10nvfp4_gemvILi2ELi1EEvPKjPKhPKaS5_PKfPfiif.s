.text
k__Z10nvfp4_gemvILi2ELi1EEvPKjPKhPKaS5_PKfPfiif:
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
s_cbranch_execz 306
s_ashr_i32 s0, s13, 31
s_lshr_b32 s1, s0, 28
s_add_i32 s1, s13, s1
v_and_b32_e32 v3, 63, v0
s_ashr_i32 s2, s1, 4
v_cmp_gt_i32_e32 vcc, s2, v3
v_ashrrev_i32_e32 v2, 31, v1
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v12, 0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 199
s_lshr_b32 s0, s0, 29
s_lshr_b32 s1, s13, 31
s_add_i32 s0, s13, s0
s_add_i32 s1, s13, s1
s_ashr_i32 s24, s0, 3
s_ashr_i32 s6, s1, 1
v_mad_i64_i32 v[9:10], s[0:1], s24, v1, 0
s_ashr_i32 s3, s2, 31
s_ashr_i32 s7, s6, 31
s_add_u32 s13, s20, s6
s_addc_u32 s14, s21, s7
v_lshlrev_b32_e32 v0, 2, v3
v_mov_b32_e32 v4, s18
s_add_u32 s15, s22, s6
v_mov_b32_e32 v8, s9
v_add_co_u32_e32 v7, vcc, s8, v0
v_lshlrev_b64 v[9:10], 2, v[9:10]
v_mov_b32_e32 v5, s19
s_addc_u32 s18, s23, s7
s_lshl_b64 s[6:7], s[2:3], 2
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
v_mad_i64_i32 v[5:6], s[0:1], v1, s2, v[4:5]
s_add_u32 s3, s22, 4
v_mov_b32_e32 v0, s17
v_add_co_u32_e32 v9, vcc, s16, v9
v_mov_b32_e32 v4, 0
s_addc_u32 s19, s23, 0
v_addc_co_u32_e32 v0, vcc, v10, v0, vcc
s_add_u32 s20, s20, 4
v_add_co_u32_e32 v13, vcc, 4, v9
v_mov_b32_e32 v10, v4
v_lshlrev_b32_e32 v11, 3, v3
s_addc_u32 s21, s21, 0
v_addc_co_u32_e32 v14, vcc, 0, v0, vcc
s_mov_b64 s[8:9], 0
s_movk_i32 s16, 0x100
v_mov_b32_e32 v9, v3
v_mov_b32_e32 v12, 0
v_mov_b32_e32 v0, 0
v_add_co_u32_e32 v15, vcc, v13, v11
v_addc_co_u32_e32 v16, vcc, 0, v14, vcc
global_load_dwordx2 v[15:16], v[15:16], off offset:-4
v_mov_b32_e32 v17, 0xc080604
v_mov_b32_e32 v18, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v19, 0x7070707, v15
v_lshrrev_b32_e32 v20, 3, v15
v_lshrrev_b32_e32 v21, 4, v15
v_lshrrev_b32_e32 v15, 7, v15
v_and_b32_e32 v20, 0x1010101, v20
v_and_b32_e32 v21, 0x7070707, v21
v_and_b32_e32 v15, 0x1010101, v15
v_perm_b32 v22, v17, v18, v19
v_mov_b32_e32 v23, 0xf4f8fafc
v_mov_b32_e32 v24, 0xfdfeff00
v_perm_b32 v19, v23, v24, v19
v_mov_b32_e32 v25, 0xff00
v_perm_b32 v20, v4, v25, v20
v_bfi_b32 v19, v20, v19, v22
v_perm_b32 v20, v17, v18, v21
v_perm_b32 v21, v23, v24, v21
v_perm_b32 v15, v4, v25, v15
v_bfi_b32 v20, v15, v21, v20
v_and_b32_e32 v15, 0x7070707, v16
v_lshrrev_b32_e32 v21, 3, v16
v_lshrrev_b32_e32 v22, 4, v16
v_lshrrev_b32_e32 v16, 7, v16
v_and_b32_e32 v21, 0x1010101, v21
v_and_b32_e32 v22, 0x7070707, v22
v_and_b32_e32 v16, 0x1010101, v16
v_perm_b32 v26, v17, v18, v15
v_perm_b32 v15, v23, v24, v15
v_perm_b32 v21, v4, v25, v21
v_bfi_b32 v21, v21, v15, v26
v_perm_b32 v26, v17, v18, v22
v_perm_b32 v22, v23, v24, v22
v_perm_b32 v23, v4, v25, v16
v_add_co_u32_e32 v15, vcc, v5, v9
v_addc_co_u32_e32 v16, vcc, v6, v10, vcc
global_load_ubyte v24, v[15:16], off
v_mov_b32_e32 v16, s21
v_add_co_u32_e32 v15, vcc, s20, v11
v_addc_co_u32_e32 v16, vcc, 0, v16, vcc
v_mov_b32_e32 v18, s19
v_add_co_u32_e32 v17, vcc, s3, v11
global_load_dwordx2 v[15:16], v[15:16], off offset:-4
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
global_load_dwordx2 v[17:18], v[17:18], off offset:-4
v_bfi_b32 v22, v23, v22, v26
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v24, 2, v24
ds_read_b32 v24, v24
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v15, v19, v15, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v15, v20, v17, v15
v_dot4_i32_i8 v15, v21, v16, v15
v_dot4_i32_i8 v23, v22, v18, v15
v_mov_b32_e32 v16, s14
v_add_co_u32_e32 v15, vcc, s13, v11
global_load_dword v25, v[7:8], off
v_addc_co_u32_e32 v16, vcc, 0, v16, vcc
v_mov_b32_e32 v18, s18
v_add_co_u32_e32 v17, vcc, s15, v11
global_load_dwordx2 v[15:16], v[15:16], off
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
global_load_dwordx2 v[17:18], v[17:18], off
v_cvt_f32_i32_e32 v23, v23
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v25, v24, v25
v_fmac_f32_e32 v12, v23, v25
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v15, v19, v15, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v15, v20, v17, v15
v_dot4_i32_i8 v15, v21, v16, v15
v_dot4_i32_i8 v17, v22, v18, v15
v_mov_b32_e32 v16, s7
v_add_co_u32_e32 v15, vcc, s6, v7
v_addc_co_u32_e32 v16, vcc, v8, v16, vcc
global_load_dword v15, v[15:16], off
s_add_u32 s3, s3, 0x200
s_addc_u32 s19, s19, 0
s_add_u32 s15, s15, 0x200
v_add_co_u32_e32 v9, vcc, 64, v9
s_addc_u32 s18, s18, 0
v_cvt_f32_i32_e32 v16, v17
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_add_u32 s20, s20, 0x200
v_add_co_u32_e32 v7, vcc, s16, v7
s_addc_u32 s21, s21, 0
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_add_u32 s13, s13, 0x200
v_add_co_u32_e32 v13, vcc, 0x200, v13
v_cmp_le_i32_e64 s[0:1], s2, v9
s_addc_u32 s14, s14, 0
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
s_or_b64 s[8:9], s[0:1], s[8:9]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v15, v24, v15
v_fmac_f32_e32 v0, v16, v15
s_andn2_b64 exec, exec, s[8:9]
s_cbranch_execnz 65380
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[4:5]
v_mbcnt_lo_u32_b32 v4, -1, 0
v_mbcnt_hi_u32_b32 v5, -1, v4
v_and_b32_e32 v6, 63, v5
v_and_b32_e32 v4, 64, v5
v_add_u32_e32 v7, 64, v4
v_xor_b32_e32 v4, 32, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v5, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v8, v4, v12
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v12, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 16, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v5, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v8
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 8, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v5, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v8
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v4
v_xor_b32_e32 v4, 4, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v5, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v8
ds_bpermute_b32 v4, v4, v0
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v8, v8, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v0, v4
v_xor_b32_e32 v0, 2, v6
v_cmp_lt_i32_e32 vcc, v0, v7
v_cndmask_b32_e32 v0, v5, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v9, v0, v8
ds_bpermute_b32 v10, v0, v4
v_xor_b32_e32 v6, 1, v6
v_cmp_lt_i32_e32 vcc, v6, v7
v_cndmask_b32_e32 v5, v5, v6, vcc
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v0, v8, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v10
v_lshlrev_b32_e32 v6, 2, v5
ds_bpermute_b32 v5, v6, v0
ds_bpermute_b32 v6, v6, v4
v_cmp_eq_u32_e32 vcc, 0, v3
s_and_b64 exec, exec, vcc
s_cbranch_execz 17
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v4, v6
v_add_f32_e32 v4, v0, v5
v_lshlrev_b64 v[0:1], 2, v[1:2]
s_ashr_i32 s13, s12, 31
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
s_lshl_b64 s[0:1], s[12:13], 2
global_store_dword v[0:1], v4, off
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v3, off
s_endpgm
