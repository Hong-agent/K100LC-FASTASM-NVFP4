.text
k__Z10nvfp4_gemvILi1ELi1EEvPKjPKhPKaS5_PKfPfiif:
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
s_cbranch_execz 226
s_ashr_i32 s0, s13, 31
s_lshr_b32 s1, s0, 28
s_add_i32 s1, s13, s1
v_and_b32_e32 v3, 63, v0
s_ashr_i32 s6, s1, 4
v_cmp_gt_i32_e32 vcc, s6, v3
v_ashrrev_i32_e32 v2, 31, v1
v_mov_b32_e32 v0, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 150
s_lshr_b32 s0, s0, 29
s_add_i32 s0, s13, s0
s_ashr_i32 s4, s0, 3
v_mad_i64_i32 v[11:12], s[0:1], s4, v1, 0
v_lshlrev_b32_e32 v0, 2, v3
v_mov_b32_e32 v8, s9
v_add_co_u32_e32 v7, vcc, s8, v0
v_lshlrev_b32_e32 v0, 3, v3
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
v_or_b32_e32 v13, 4, v0
v_mov_b32_e32 v10, s23
v_add_co_u32_e32 v9, vcc, s22, v13
v_lshlrev_b64 v[11:12], 2, v[11:12]
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_add_co_u32_e32 v0, vcc, v11, v0
v_addc_co_u32_e32 v11, vcc, 0, v12, vcc
v_mov_b32_e32 v4, s18
v_mov_b32_e32 v12, s17
v_add_co_u32_e32 v0, vcc, s16, v0
v_mov_b32_e32 v5, s19
v_addc_co_u32_e32 v12, vcc, v11, v12, vcc
v_mad_i64_i32 v[5:6], s[0:1], v1, s6, v[4:5]
v_add_co_u32_e32 v11, vcc, 4, v0
v_mov_b32_e32 v4, 0
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
v_mov_b32_e32 v0, s21
v_add_co_u32_e32 v13, vcc, s20, v13
v_mov_b32_e32 v16, v4
v_addc_co_u32_e32 v14, vcc, 0, v0, vcc
s_mov_b64 s[4:5], 0
s_movk_i32 s7, 0x100
s_movk_i32 s8, 0x200
v_mov_b32_e32 v15, v3
v_mov_b32_e32 v0, 0
global_load_dwordx2 v[17:18], v[11:12], off offset:-4
v_mov_b32_e32 v19, 0xc080604
v_mov_b32_e32 v20, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v21, 0x7070707, v17
v_lshrrev_b32_e32 v22, 3, v17
v_lshrrev_b32_e32 v23, 4, v17
v_lshrrev_b32_e32 v17, 7, v17
v_and_b32_e32 v22, 0x1010101, v22
v_and_b32_e32 v23, 0x7070707, v23
v_and_b32_e32 v17, 0x1010101, v17
v_perm_b32 v24, v19, v20, v21
v_mov_b32_e32 v25, 0xf4f8fafc
v_mov_b32_e32 v26, 0xfdfeff00
v_perm_b32 v21, v25, v26, v21
v_mov_b32_e32 v27, 0xff00
v_perm_b32 v22, v4, v27, v22
v_bfi_b32 v24, v22, v21, v24
v_perm_b32 v21, v19, v20, v23
v_perm_b32 v22, v25, v26, v23
v_perm_b32 v17, v4, v27, v17
v_bfi_b32 v23, v17, v22, v21
v_and_b32_e32 v17, 0x7070707, v18
v_lshrrev_b32_e32 v21, 3, v18
v_lshrrev_b32_e32 v22, 4, v18
v_lshrrev_b32_e32 v18, 7, v18
v_and_b32_e32 v21, 0x1010101, v21
v_and_b32_e32 v22, 0x7070707, v22
v_and_b32_e32 v18, 0x1010101, v18
v_perm_b32 v28, v19, v20, v17
v_perm_b32 v17, v25, v26, v17
v_perm_b32 v21, v4, v27, v21
v_bfi_b32 v28, v21, v17, v28
v_perm_b32 v29, v19, v20, v22
v_perm_b32 v25, v25, v26, v22
v_perm_b32 v26, v4, v27, v18
v_add_co_u32_e32 v17, vcc, v5, v15
v_addc_co_u32_e32 v18, vcc, v6, v16, vcc
global_load_ubyte v27, v[17:18], off
global_load_dwordx2 v[19:20], v[13:14], off offset:-4
global_load_dwordx2 v[21:22], v[9:10], off offset:-4
v_bfi_b32 v18, v26, v25, v29
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v17, 2, v27
ds_read_b32 v17, v17
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v19, v24, v19, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v19, v23, v21, v19
v_dot4_i32_i8 v19, v28, v20, v19
v_dot4_i32_i8 v18, v18, v22, v19
global_load_dword v19, v[7:8], off
v_add_co_u32_e32 v15, vcc, 64, v15
v_addc_co_u32_e32 v16, vcc, 0, v16, vcc
v_add_co_u32_e32 v7, vcc, s7, v7
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
v_add_co_u32_e32 v9, vcc, s8, v9
v_cvt_f32_i32_e32 v18, v18
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_add_co_u32_e32 v11, vcc, 0x200, v11
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
v_cmp_le_i32_e64 s[0:1], s6, v15
v_add_co_u32_e32 v13, vcc, 0x200, v13
s_or_b64 s[4:5], s[0:1], s[4:5]
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
s_waitcnt vmcnt(0) lgkmcnt(0)
v_mul_f32_e32 v17, v17, v19
v_fmac_f32_e32 v0, v18, v17
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65424
s_or_b64 exec, exec, s[4:5]
s_or_b64 exec, exec, s[2:3]
v_mbcnt_lo_u32_b32 v4, -1, 0
v_mbcnt_hi_u32_b32 v4, -1, v4
v_and_b32_e32 v5, 63, v4
v_and_b32_e32 v6, 64, v4
v_add_u32_e32 v6, 64, v6
v_xor_b32_e32 v7, 32, v5
v_cmp_lt_i32_e32 vcc, v7, v6
v_cndmask_b32_e32 v7, v4, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v7, v7, v0
v_xor_b32_e32 v8, 16, v5
v_cmp_lt_i32_e32 vcc, v8, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v7
v_cndmask_b32_e32 v7, v4, v8, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v7, v7, v0
v_xor_b32_e32 v8, 8, v5
v_cmp_lt_i32_e32 vcc, v8, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v7
v_cndmask_b32_e32 v7, v4, v8, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v7, v7, v0
v_xor_b32_e32 v8, 4, v5
v_cmp_lt_i32_e32 vcc, v8, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v7
v_cndmask_b32_e32 v7, v4, v8, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v7, v7, v0
v_xor_b32_e32 v8, 2, v5
v_cmp_lt_i32_e32 vcc, v8, v6
v_xor_b32_e32 v5, 1, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v7
v_cndmask_b32_e32 v7, v4, v8, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v7, v7, v0
v_cmp_lt_i32_e32 vcc, v5, v6
v_cndmask_b32_e32 v4, v4, v5, vcc
v_lshlrev_b32_e32 v4, 2, v4
v_cmp_eq_u32_e32 vcc, 0, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v7
ds_bpermute_b32 v4, v4, v0
s_and_b64 exec, exec, vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v0, v4
v_lshlrev_b64 v[0:1], 2, v[1:2]
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
global_store_dword v[0:1], v3, off
s_endpgm
