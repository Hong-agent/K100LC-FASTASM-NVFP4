.text
k__Z10nvfp4_gemvILi3ELi1EEvPKjPKhPKaS5_PKfPfiif:
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
s_cbranch_execz 377
s_ashr_i32 s1, s13, 31
s_lshr_b32 s0, s1, 28
s_add_i32 s0, s13, s0
v_and_b32_e32 v3, 63, v0
s_ashr_i32 s0, s0, 4
v_cmp_gt_i32_e32 vcc, s0, v3
v_ashrrev_i32_e32 v2, 31, v1
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 242
s_lshr_b32 s1, s1, 29
s_add_i32 s1, s13, s1
s_lshr_b32 s4, s13, 31
s_ashr_i32 s1, s1, 3
s_add_i32 s6, s13, s4
v_mad_i64_i32 v[4:5], s[4:5], v1, s1, 0
s_ashr_i32 s6, s6, 1
s_ashr_i32 s1, s0, 31
s_ashr_i32 s7, s6, 31
s_add_u32 s13, s20, s6
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_addc_u32 s14, s21, s7
s_add_u32 s15, s22, s6
v_mov_b32_e32 v6, s17
v_add_co_u32_e32 v0, vcc, s16, v4
s_addc_u32 s16, s23, s7
v_lshl_add_u32 v7, s0, 1, v3
v_addc_co_u32_e32 v13, vcc, v6, v5, vcc
v_mov_b32_e32 v4, s18
s_add_u32 s17, s13, s6
v_ashrrev_i32_e32 v8, 31, v7
v_mov_b32_e32 v5, s19
s_addc_u32 s18, s14, s7
v_lshlrev_b64 v[7:8], 2, v[7:8]
v_mad_i64_i32 v[5:6], s[4:5], v1, s0, v[4:5]
s_add_u32 s19, s15, s6
s_addc_u32 s24, s16, s7
v_mov_b32_e32 v10, s9
v_add_co_u32_e32 v7, vcc, s8, v7
s_lshl_b64 s[4:5], s[0:1], 2
v_addc_co_u32_e32 v8, vcc, v10, v8, vcc
v_lshlrev_b32_e32 v9, 2, v3
s_add_u32 s1, s22, 4
v_mov_b32_e32 v4, 0
v_add_co_u32_e32 v9, vcc, s8, v9
s_addc_u32 s8, s23, 0
s_add_u32 s9, s20, 4
v_mov_b32_e32 v12, v4
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_lshlrev_b32_e32 v17, 3, v3
s_addc_u32 s20, s21, 0
s_mov_b64 s[6:7], 0
s_movk_i32 s21, 0x100
v_mov_b32_e32 v11, v3
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v14, 0
v_add_co_u32_e32 v18, vcc, v0, v17
v_addc_co_u32_e32 v19, vcc, 0, v13, vcc
global_load_dwordx2 v[18:19], v[18:19], off
v_mov_b32_e32 v20, 0xc080604
v_mov_b32_e32 v21, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v22, 0x7070707, v18
v_lshrrev_b32_e32 v23, 3, v18
v_lshrrev_b32_e32 v24, 4, v18
v_lshrrev_b32_e32 v18, 7, v18
v_and_b32_e32 v23, 0x1010101, v23
v_and_b32_e32 v24, 0x7070707, v24
v_and_b32_e32 v18, 0x1010101, v18
v_perm_b32 v25, v20, v21, v22
v_mov_b32_e32 v26, 0xf4f8fafc
v_mov_b32_e32 v27, 0xfdfeff00
v_perm_b32 v22, v26, v27, v22
v_mov_b32_e32 v28, 0xff00
v_perm_b32 v23, v4, v28, v23
v_bfi_b32 v22, v23, v22, v25
v_perm_b32 v23, v20, v21, v24
v_perm_b32 v24, v26, v27, v24
v_perm_b32 v18, v4, v28, v18
v_bfi_b32 v23, v18, v24, v23
v_and_b32_e32 v18, 0x7070707, v19
v_lshrrev_b32_e32 v24, 3, v19
v_lshrrev_b32_e32 v25, 4, v19
v_lshrrev_b32_e32 v19, 7, v19
v_and_b32_e32 v24, 0x1010101, v24
v_and_b32_e32 v25, 0x7070707, v25
v_and_b32_e32 v19, 0x1010101, v19
v_perm_b32 v29, v20, v21, v18
v_perm_b32 v18, v26, v27, v18
v_perm_b32 v24, v4, v28, v24
v_bfi_b32 v24, v24, v18, v29
v_perm_b32 v29, v20, v21, v25
v_perm_b32 v25, v26, v27, v25
v_perm_b32 v26, v4, v28, v19
v_add_co_u32_e32 v18, vcc, v5, v11
v_addc_co_u32_e32 v19, vcc, v6, v12, vcc
global_load_ubyte v27, v[18:19], off
v_mov_b32_e32 v19, s20
v_add_co_u32_e32 v18, vcc, s9, v17
v_addc_co_u32_e32 v19, vcc, 0, v19, vcc
v_mov_b32_e32 v21, s8
v_add_co_u32_e32 v20, vcc, s1, v17
global_load_dwordx2 v[18:19], v[18:19], off offset:-4
v_addc_co_u32_e32 v21, vcc, 0, v21, vcc
global_load_dwordx2 v[20:21], v[20:21], off offset:-4
v_bfi_b32 v25, v26, v25, v29
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v27, 2, v27
ds_read_b32 v27, v27
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v18, v22, v18, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v18, v23, v20, v18
v_dot4_i32_i8 v18, v24, v19, v18
v_dot4_i32_i8 v26, v25, v21, v18
v_mov_b32_e32 v19, s14
v_add_co_u32_e32 v18, vcc, s13, v17
global_load_dword v28, v[9:10], off
v_addc_co_u32_e32 v19, vcc, 0, v19, vcc
v_mov_b32_e32 v21, s16
v_add_co_u32_e32 v20, vcc, s15, v17
global_load_dwordx2 v[18:19], v[18:19], off
v_addc_co_u32_e32 v21, vcc, 0, v21, vcc
global_load_dwordx2 v[20:21], v[20:21], off
v_cvt_f32_i32_e32 v26, v26
s_waitcnt vmcnt(2) lgkmcnt(0)
v_mul_f32_e32 v28, v27, v28
v_fmac_f32_e32 v16, v26, v28
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v18, v22, v18, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v18, v23, v20, v18
v_dot4_i32_i8 v18, v24, v19, v18
v_dot4_i32_i8 v26, v25, v21, v18
v_mov_b32_e32 v19, s5
v_add_co_u32_e32 v18, vcc, s4, v9
v_addc_co_u32_e32 v19, vcc, v10, v19, vcc
global_load_dword v28, v[18:19], off
v_mov_b32_e32 v19, s18
v_add_co_u32_e32 v18, vcc, s17, v17
v_addc_co_u32_e32 v19, vcc, 0, v19, vcc
v_mov_b32_e32 v21, s24
v_add_co_u32_e32 v20, vcc, s19, v17
global_load_dwordx2 v[18:19], v[18:19], off
v_addc_co_u32_e32 v21, vcc, 0, v21, vcc
global_load_dwordx2 v[20:21], v[20:21], off
v_cvt_f32_i32_e32 v26, v26
s_waitcnt vmcnt(2)
v_mul_f32_e32 v28, v27, v28
v_fmac_f32_e32 v15, v26, v28
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v18, v22, v18, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v18, v23, v20, v18
v_dot4_i32_i8 v18, v24, v19, v18
v_dot4_i32_i8 v18, v25, v21, v18
global_load_dword v19, v[7:8], off
s_add_u32 s1, s1, 0x200
s_addc_u32 s8, s8, 0
s_add_u32 s19, s19, 0x200
v_add_co_u32_e32 v7, vcc, s21, v7
s_addc_u32 s24, s24, 0
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_add_u32 s9, s9, 0x200
v_add_co_u32_e32 v11, vcc, 64, v11
s_addc_u32 s20, s20, 0
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
s_add_u32 s17, s17, 0x200
v_add_co_u32_e32 v9, vcc, s21, v9
s_addc_u32 s18, s18, 0
v_cvt_f32_i32_e32 v18, v18
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_add_u32 s15, s15, 0x200
v_add_co_u32_e32 v0, vcc, 0x200, v0
s_addc_u32 s16, s16, 0
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
s_add_u32 s13, s13, 0x200
v_cmp_le_i32_e32 vcc, s0, v11
s_addc_u32 s14, s14, 0
s_or_b64 s[6:7], vcc, s[6:7]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v19, v27, v19
v_fmac_f32_e32 v14, v18, v19
s_andn2_b64 exec, exec, s[6:7]
s_cbranch_execnz 65347
s_or_b64 exec, exec, s[6:7]
s_or_b64 exec, exec, s[2:3]
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v6, -1, v0
v_and_b32_e32 v7, 63, v6
v_and_b32_e32 v0, 64, v6
v_add_u32_e32 v8, 64, v0
v_xor_b32_e32 v0, 32, v7
v_cmp_lt_i32_e32 vcc, v0, v8
v_cndmask_b32_e32 v0, v6, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v4, v0, v16
ds_bpermute_b32 v5, v0, v15
ds_bpermute_b32 v0, v0, v14
v_xor_b32_e32 v9, 16, v7
v_cmp_lt_i32_e32 vcc, v9, v8
v_cndmask_b32_e32 v9, v6, v9, vcc
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v4, v16, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v15, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v14, v0
v_lshlrev_b32_e32 v9, 2, v9
ds_bpermute_b32 v10, v9, v4
ds_bpermute_b32 v11, v9, v5
ds_bpermute_b32 v9, v9, v0
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v4, v4, v10
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v9
v_xor_b32_e32 v9, 8, v7
v_cmp_lt_i32_e32 vcc, v9, v8
v_cndmask_b32_e32 v9, v6, v9, vcc
v_lshlrev_b32_e32 v9, 2, v9
ds_bpermute_b32 v10, v9, v4
ds_bpermute_b32 v11, v9, v5
ds_bpermute_b32 v9, v9, v0
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v4, v4, v10
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v9
v_xor_b32_e32 v9, 4, v7
v_cmp_lt_i32_e32 vcc, v9, v8
v_cndmask_b32_e32 v9, v6, v9, vcc
v_lshlrev_b32_e32 v9, 2, v9
ds_bpermute_b32 v10, v9, v4
ds_bpermute_b32 v11, v9, v5
ds_bpermute_b32 v9, v9, v0
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v4, v4, v10
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v5, v5, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v9, v0, v9
v_xor_b32_e32 v0, 2, v7
v_cmp_lt_i32_e32 vcc, v0, v8
v_cndmask_b32_e32 v0, v6, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v10, v0, v4
ds_bpermute_b32 v11, v0, v5
ds_bpermute_b32 v12, v0, v9
v_xor_b32_e32 v7, 1, v7
v_cmp_lt_i32_e32 vcc, v7, v8
v_cndmask_b32_e32 v6, v6, v7, vcc
s_waitcnt lgkmcnt(2)
v_add_f32_e32 v0, v4, v10
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v4, v5, v11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v9, v12
v_lshlrev_b32_e32 v8, 2, v6
ds_bpermute_b32 v6, v8, v0
ds_bpermute_b32 v7, v8, v4
ds_bpermute_b32 v8, v8, v5
v_cmp_eq_u32_e32 vcc, 0, v3
s_and_b64 exec, exec, vcc
s_cbranch_execz 22
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v5, v8
v_add_f32_e32 v5, v0, v6
v_lshlrev_b64 v[0:1], 2, v[1:2]
s_ashr_i32 s13, s12, 31
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
s_lshl_b64 s[0:1], s[12:13], 2
global_store_dword v[0:1], v5, off
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_add_f32_e32 v4, v4, v7
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v4, off
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v1, v2, vcc
global_store_dword v[0:1], v3, off
s_endpgm
