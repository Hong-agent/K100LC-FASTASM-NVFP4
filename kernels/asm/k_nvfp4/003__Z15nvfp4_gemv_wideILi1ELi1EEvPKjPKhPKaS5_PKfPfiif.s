.text
k__Z15nvfp4_gemv_wideILi1ELi1EEvPKjPKhPKaS5_PKfPfiif:
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
s_cbranch_execz 302
s_ashr_i32 s0, s13, 31
s_lshr_b32 s1, s0, 27
s_add_i32 s1, s13, s1
v_and_b32_e32 v9, 63, v0
s_ashr_i32 s6, s1, 5
v_cmp_gt_i32_e32 vcc, s6, v9
v_ashrrev_i32_e32 v2, 31, v1
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 226
s_lshr_b32 s1, s0, 29
s_add_i32 s1, s13, s1
s_ashr_i32 s1, s1, 3
v_mad_i64_i32 v[3:4], s[4:5], v1, s1, 0
v_mov_b32_e32 v5, s17
v_and_b32_e32 v0, 63, v0
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_lshr_b32 s0, s0, 28
v_add_co_u32_e32 v10, vcc, s16, v3
v_addc_co_u32_e32 v11, vcc, v5, v4, vcc
v_lshlrev_b32_e32 v3, 3, v0
v_mov_b32_e32 v5, s9
v_add_co_u32_e32 v3, vcc, s8, v3
s_add_i32 s0, s13, s0
v_addc_co_u32_e32 v6, vcc, 0, v5, vcc
s_ashr_i32 s0, s0, 4
v_mov_b32_e32 v4, 0
v_add_co_u32_e32 v5, vcc, 4, v3
v_lshlrev_b32_e32 v3, 1, v0
v_mad_i64_i32 v[7:8], s[0:1], v1, s0, v[3:4]
v_addc_co_u32_e32 v6, vcc, 0, v6, vcc
v_mov_b32_e32 v3, s19
v_add_co_u32_e32 v7, vcc, s18, v7
v_lshlrev_b32_e32 v0, 4, v0
v_addc_co_u32_e32 v8, vcc, v3, v8, vcc
s_mov_b64 s[4:5], 0
s_movk_i32 s7, 0x200
s_movk_i32 s8, 0x400
s_movk_i32 s9, 0x80
v_mov_b32_e32 v12, v9
v_mov_b32_e32 v3, 0
v_add_co_u32_e32 v13, vcc, v10, v0
v_addc_co_u32_e32 v14, vcc, 0, v11, vcc
global_load_dwordx4 v[13:16], v[13:14], off
v_mov_b32_e32 v17, 0xc080604
v_mov_b32_e32 v18, 0x3020100
s_waitcnt vmcnt(0)
v_and_b32_e32 v19, 0x7070707, v13
v_lshrrev_b32_e32 v20, 3, v13
v_lshrrev_b32_e32 v21, 4, v13
v_lshrrev_b32_e32 v13, 7, v13
v_and_b32_e32 v20, 0x1010101, v20
v_and_b32_e32 v21, 0x7070707, v21
v_and_b32_e32 v13, 0x1010101, v13
v_perm_b32 v22, v17, v18, v19
v_mov_b32_e32 v23, 0xf4f8fafc
v_mov_b32_e32 v24, 0xfdfeff00
v_perm_b32 v19, v23, v24, v19
v_mov_b32_e32 v25, 0xff00
v_perm_b32 v20, v4, v25, v20
v_bfi_b32 v22, v20, v19, v22
v_perm_b32 v19, v17, v18, v21
v_perm_b32 v20, v23, v24, v21
v_perm_b32 v13, v4, v25, v13
v_bfi_b32 v21, v13, v20, v19
v_and_b32_e32 v13, 0x7070707, v14
v_lshrrev_b32_e32 v19, 3, v14
v_lshrrev_b32_e32 v20, 4, v14
v_lshrrev_b32_e32 v14, 7, v14
v_and_b32_e32 v19, 0x1010101, v19
v_and_b32_e32 v20, 0x7070707, v20
v_and_b32_e32 v14, 0x1010101, v14
v_perm_b32 v26, v17, v18, v13
v_perm_b32 v13, v23, v24, v13
v_perm_b32 v19, v4, v25, v19
v_bfi_b32 v26, v19, v13, v26
v_perm_b32 v13, v17, v18, v20
v_perm_b32 v19, v23, v24, v20
v_perm_b32 v14, v4, v25, v14
v_bfi_b32 v27, v14, v19, v13
v_and_b32_e32 v13, 0x7070707, v15
v_lshrrev_b32_e32 v14, 3, v15
v_lshrrev_b32_e32 v19, 4, v15
v_lshrrev_b32_e32 v15, 7, v15
v_and_b32_e32 v14, 0x1010101, v14
v_and_b32_e32 v19, 0x7070707, v19
v_and_b32_e32 v15, 0x1010101, v15
v_perm_b32 v20, v17, v18, v13
v_perm_b32 v13, v23, v24, v13
v_perm_b32 v14, v4, v25, v14
v_bfi_b32 v28, v14, v13, v20
v_perm_b32 v13, v17, v18, v19
v_perm_b32 v14, v23, v24, v19
v_perm_b32 v15, v4, v25, v15
v_bfi_b32 v29, v15, v14, v13
v_and_b32_e32 v13, 0x7070707, v16
v_lshrrev_b32_e32 v14, 3, v16
v_lshrrev_b32_e32 v15, 4, v16
v_lshrrev_b32_e32 v16, 7, v16
v_and_b32_e32 v14, 0x1010101, v14
v_and_b32_e32 v15, 0x7070707, v15
v_and_b32_e32 v16, 0x1010101, v16
v_perm_b32 v19, v17, v18, v13
v_perm_b32 v13, v23, v24, v13
v_perm_b32 v14, v4, v25, v14
v_bfi_b32 v30, v14, v13, v19
v_perm_b32 v31, v17, v18, v15
v_perm_b32 v23, v23, v24, v15
v_perm_b32 v24, v4, v25, v16
global_load_ushort v25, v[7:8], off
v_mov_b32_e32 v14, s21
v_add_co_u32_e32 v13, vcc, s20, v0
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
v_mov_b32_e32 v18, s23
v_add_co_u32_e32 v17, vcc, s22, v0
global_load_dwordx4 v[13:16], v[13:14], off
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
global_load_dwordx4 v[17:20], v[17:18], off
v_mov_b32_e32 v32, 2
v_bfi_b32 v23, v24, v23, v31
s_waitcnt vmcnt(2)
v_lshlrev_b32_sdwa v33, v32, v25 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
v_lshlrev_b32_sdwa v25, v32, v25 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_1
ds_read_b32 v32, v33
ds_read_b32 v25, v25
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v13, v22, v13, v4
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v13, v21, v17, v13
v_dot4_i32_i8 v13, v26, v14, v13
v_dot4_i32_i8 v17, v27, v18, v13
v_dot4_i32_i8 v13, v28, v15, v4
v_dot4_i32_i8 v13, v29, v19, v13
v_dot4_i32_i8 v13, v30, v16, v13
v_dot4_i32_i8 v15, v23, v20, v13
global_load_dwordx2 v[13:14], v[5:6], off offset:-4
v_cvt_f32_i32_e32 v15, v15
v_cvt_f32_i32_e32 v16, v17
v_add_co_u32_e32 v5, vcc, s7, v5
v_addc_co_u32_e32 v6, vcc, 0, v6, vcc
s_add_u32 s22, s22, 0x400
v_add_co_u32_e32 v10, vcc, s8, v10
s_addc_u32 s23, s23, 0
v_add_u32_e32 v12, 64, v12
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
s_add_u32 s20, s20, 0x400
v_add_co_u32_e32 v7, vcc, s9, v7
v_cmp_le_i32_e64 s[0:1], s6, v12
s_addc_u32 s21, s21, 0
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_or_b64 s[4:5], s[0:1], s[4:5]
s_waitcnt vmcnt(0) lgkmcnt(0)
v_mul_f32_e32 v14, v25, v14
v_mul_f32_e32 v13, v32, v13
v_mul_f32_e32 v14, v15, v14
v_fmac_f32_e32 v14, v16, v13
v_add_f32_e32 v3, v3, v14
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65345
s_or_b64 exec, exec, s[4:5]
s_or_b64 exec, exec, s[2:3]
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v4, -1, v0
v_and_b32_e32 v0, 63, v4
v_and_b32_e32 v5, 64, v4
v_add_u32_e32 v5, 64, v5
v_xor_b32_e32 v6, 32, v0
v_cmp_lt_i32_e32 vcc, v6, v5
v_cndmask_b32_e32 v6, v4, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v6, v6, v3
v_xor_b32_e32 v7, 16, v0
v_cmp_lt_i32_e32 vcc, v7, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v6
v_cndmask_b32_e32 v6, v4, v7, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v6, v6, v3
v_xor_b32_e32 v7, 8, v0
v_cmp_lt_i32_e32 vcc, v7, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v6
v_cndmask_b32_e32 v6, v4, v7, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v6, v6, v3
v_xor_b32_e32 v7, 4, v0
v_cmp_lt_i32_e32 vcc, v7, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v6
v_cndmask_b32_e32 v6, v4, v7, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v6, v6, v3
v_xor_b32_e32 v7, 2, v0
v_cmp_lt_i32_e32 vcc, v7, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v6
v_cndmask_b32_e32 v6, v4, v7, vcc
v_lshlrev_b32_e32 v6, 2, v6
ds_bpermute_b32 v6, v6, v3
v_xor_b32_e32 v7, 1, v0
v_cmp_lt_i32_e32 vcc, v7, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v3, v6
v_cndmask_b32_e32 v3, v4, v7, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v0
v_cmp_eq_u32_e32 vcc, 0, v9
s_and_b64 exec, exec, vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v0, v3
v_lshlrev_b64 v[0:1], 2, v[1:2]
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
global_store_dword v[0:1], v3, off
s_endpgm
