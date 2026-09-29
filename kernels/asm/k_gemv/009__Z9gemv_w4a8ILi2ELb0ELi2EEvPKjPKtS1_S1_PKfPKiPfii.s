.text
k__Z9gemv_w4a8ILi2ELb0ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 704
s_load_dwordx2 s[22:23], s[4:5], 0x30
v_add_u32_e32 v1, 2, v8
v_sub_u32_e32 v2, s20, v8
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v13, 2, v2, vcc
v_and_b32_e32 v14, 63, v0
s_mov_b32 s30, 0
s_cmp_lt_i32 s21, 8
v_mov_b32_e32 v20, 0
v_cmp_lt_i32_e64 s[0:1], 0, v13
v_cmp_lt_i32_e64 s[2:3], 1, v13
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v15, 0
s_cbranch_scc1 498
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_ashr_i32 s4, s21, 31
s_lshr_b32 s5, s4, 29
s_lshr_b32 s4, s4, 25
s_add_i32 s4, s21, s4
s_ashr_i32 s26, s4, 7
v_or_b32_e32 v5, 1, v8
v_mad_i64_i32 v[2:3], s[6:7], v5, s26, 0
v_and_b32_e32 v4, 3, v0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_alignbit_b32 v0, 0, v0, 4
v_cmp_ne_u32_e64 s[6:7], 0, v4
v_lshlrev_b32_e32 v4, 1, v0
v_add_co_u32_e32 v2, vcc, v2, v4
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s11
v_add_co_u32_e32 v9, vcc, s10, v2
v_addc_co_u32_e32 v10, vcc, v6, v3, vcc
v_mad_i64_i32 v[2:3], s[28:29], s26, v8, 0
s_add_i32 s5, s21, s5
s_ashr_i32 s24, s5, 3
v_lshlrev_b64 v[2:3], 1, v[2:3]
s_ashr_i32 s25, s24, 31
s_ashr_i32 s27, s26, 31
s_lshl_b64 s[28:29], s[24:25], 2
v_add_co_u32_e32 v2, vcc, v2, v4
s_add_u32 s21, s14, s28
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_addc_u32 s25, s15, s29
v_add_co_u32_e32 v11, vcc, s10, v2
s_lshl_b64 s[10:11], s[26:27], 2
s_add_u32 s31, s16, s10
s_addc_u32 s33, s17, s11
v_addc_co_u32_e32 v12, vcc, v6, v3, vcc
s_add_u32 s34, s12, s28
v_mad_i64_i32 v[2:3], s[26:27], v5, s24, 0
s_addc_u32 s35, s13, s29
s_add_u32 s36, s18, s10
s_addc_u32 s37, s19, s11
v_mad_i64_i32 v[4:5], s[10:11], s24, v8, 0
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_lshlrev_b32_e32 v22, 2, v0
v_mov_b32_e32 v0, s9
v_add_co_u32_e32 v23, vcc, s8, v2
v_addc_co_u32_e32 v24, vcc, v0, v3, vcc
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_cmp_gt_i32_e64 s[4:5], 1, v13
v_add_co_u32_e32 v25, vcc, s8, v2
v_lshl_add_u32 v18, v14, 2, 4
v_mov_b32_e32 v19, 0
v_lshlrev_b32_e32 v21, 4, v14
v_addc_co_u32_e32 v26, vcc, v0, v3, vcc
v_mbcnt_hi_u32_b32 v27, -1, v1
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v20, 0
s_branch 46
s_or_b64 exec, exec, s[10:11]
s_waitcnt vmcnt(1)
v_cvt_f32_f16_e32 v4, v4
v_sub_u32_e32 v3, v46, v3
v_cvt_f32_i32_e32 v3, v3
v_sub_u32_e32 v2, v47, v2
v_cvt_f32_i32_e32 v2, v2
v_mul_f32_e32 v0, v0, v4
v_fmac_f32_e32 v20, v3, v0
s_waitcnt vmcnt(0)
v_mul_f32_e32 v0, v1, v4
v_fmac_f32_e32 v17, v0, v2
s_or_b64 exec, exec, s[8:9]
s_addk_i32 s30, 0x100
s_add_u32 s21, s21, 0x400
s_addc_u32 s25, s25, 0
s_add_u32 s14, s14, 0x400
s_addc_u32 s15, s15, 0
s_add_u32 s16, s16, 64
s_addc_u32 s17, s17, 0
s_add_u32 s31, s31, 64
s_addc_u32 s33, s33, 0
s_add_u32 s18, s18, 64
v_add_co_u32_e32 v9, vcc, 32, v9
s_addc_u32 s19, s19, 0
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_add_u32 s34, s34, 0x400
v_add_co_u32_e32 v11, vcc, 32, v11
s_addc_u32 s35, s35, 0
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
s_add_u32 s12, s12, 0x400
s_addc_u32 s13, s13, 0
v_add_co_u32_e32 v23, vcc, 0x400, v23
s_add_u32 s36, s36, 64
v_addc_co_u32_e32 v24, vcc, 0, v24, vcc
s_addc_u32 s37, s37, 0
v_add_co_u32_e32 v25, vcc, 0x400, v25
s_cmp_ge_i32 s30, s24
v_addc_co_u32_e32 v26, vcc, 0, v26, vcc
s_cbranch_scc1 375
v_add_u32_e32 v0, s30, v18
v_cmp_lt_i32_e32 vcc, s24, v0
v_cmp_ge_i32_e64 s[8:9], s24, v0
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 7
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 134
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 200
s_branch 315
s_and_saveexec_b64 s[26:27], s[8:9]
s_xor_b64 s[26:27], exec, s[26:27]
s_cbranch_execz 89
v_add_co_u32_e64 v0, s[8:9], v25, v21
v_addc_co_u32_e64 v1, s[8:9], 0, v26, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_and_saveexec_b64 s[28:29], s[2:3]
s_cbranch_execz 43
v_add_co_u32_e64 v4, s[8:9], v23, v21
v_addc_co_u32_e64 v5, s[8:9], 0, v24, s[8:9]
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v28, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v29, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v30, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v31, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v32, 0xf0f0f0f, v28
v_xor_b32_e32 v28, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v29
v_xor_b32_e32 v29, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v30
v_xor_b32_e32 v30, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v31
v_xor_b32_e32 v32, 0x8080808, v32
v_xor_b32_e32 v33, 0x8080808, v7
v_xor_b32_e32 v34, 0x8080808, v6
v_xor_b32_e32 v35, 0x8080808, v5
v_xor_b32_e32 v31, 0x8080808, v4
s_or_b64 exec, exec, s[28:29]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v38, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v41, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v40, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v43, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v42, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v45, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v39, 0x8080808, v4
v_xor_b32_e32 v44, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[26:27]
s_cbranch_execz 32
v_mov_b32_e32 v38, 0x8080808
v_cndmask_b32_e64 v28, v28, v38, s[2:3]
v_cndmask_b32_e64 v29, v29, v38, s[2:3]
v_cndmask_b32_e64 v30, v30, v38, s[2:3]
v_cndmask_b32_e64 v31, v31, v38, s[2:3]
v_cndmask_b32_e64 v32, v32, v38, s[2:3]
v_cndmask_b32_e64 v33, v33, v38, s[2:3]
v_cndmask_b32_e64 v34, v34, v38, s[2:3]
v_cndmask_b32_e64 v35, v35, v38, s[2:3]
v_mov_b32_e32 v40, 0x8080808
v_mov_b32_e32 v42, 0x8080808
v_mov_b32_e32 v44, 0x8080808
v_mov_b32_e32 v39, 0x8080808
v_mov_b32_e32 v41, 0x8080808
v_mov_b32_e32 v43, 0x8080808
v_mov_b32_e32 v45, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 65402
v_mov_b32_e32 v1, s13
v_add_co_u32_e64 v0, s[8:9], s12, v21
v_addc_co_u32_e64 v1, s[8:9], 0, v1, s[8:9]
v_mov_b32_e32 v5, s15
v_add_co_u32_e64 v4, s[8:9], s14, v21
v_addc_co_u32_e64 v5, s[8:9], 0, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v46, v39, v0, v19
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v48, v38, v4, v19
v_dot4_i32_i8 v49, v41, v1, v19
v_dot4_i32_i8 v50, v40, v5, v19
v_dot4_i32_i8 v51, v43, v2, v19
v_dot4_i32_i8 v52, v42, v6, v19
v_dot4_i32_i8 v53, v45, v3, v19
v_dot4_i32_i8 v54, v44, v7, v19
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v31, v0, v19
v_dot4_i32_i8 v4, v35, v4, v19
v_dot4_i32_i8 v1, v30, v1, v19
v_dot4_i32_i8 v5, v34, v5, v19
v_dot4_i32_i8 v2, v29, v2, v19
v_dot4_i32_i8 v6, v33, v6, v19
v_dot4_i32_i8 v3, v28, v3, v19
v_dot4_i32_i8 v7, v32, v7, v19
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v37, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v48, v46
v_add3_u32 v0, v0, v49, v50
v_add3_u32 v0, v0, v51, v52
v_add3_u32 v46, v0, v53, v54
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 116
v_mov_b32_e32 v1, s35
v_add_co_u32_e64 v0, s[8:9], s34, v21
v_addc_co_u32_e64 v1, s[8:9], 0, v1, s[8:9]
v_mov_b32_e32 v5, s25
v_add_co_u32_e64 v4, s[8:9], s21, v21
v_addc_co_u32_e64 v5, s[8:9], 0, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v47, v39, v0, v19
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v48, v38, v4, v19
v_dot4_i32_i8 v49, v41, v1, v19
v_dot4_i32_i8 v50, v40, v5, v19
v_dot4_i32_i8 v51, v43, v2, v19
v_dot4_i32_i8 v52, v42, v6, v19
v_dot4_i32_i8 v53, v45, v3, v19
v_dot4_i32_i8 v54, v44, v7, v19
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v31, v0, v19
v_dot4_i32_i8 v4, v35, v4, v19
v_dot4_i32_i8 v1, v30, v1, v19
v_dot4_i32_i8 v5, v34, v5, v19
v_dot4_i32_i8 v2, v29, v2, v19
v_dot4_i32_i8 v6, v33, v6, v19
v_dot4_i32_i8 v3, v28, v3, v19
v_dot4_i32_i8 v7, v32, v7, v19
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v36, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v48, v47
v_add3_u32 v0, v0, v49, v50
v_add3_u32 v0, v0, v51, v52
v_add3_u32 v2, v0, v53, v54
v_and_b32_e32 v0, 64, v27
v_and_b32_e32 v3, 63, v27
v_add_u32_e32 v1, 64, v0
v_xor_b32_e32 v0, 1, v3
v_cmp_lt_i32_e64 s[8:9], v0, v1
v_cndmask_b32_e64 v0, v27, v0, s[8:9]
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v4, v0, v46
ds_bpermute_b32 v6, v0, v2
v_xor_b32_e32 v3, 2, v3
v_cmp_lt_i32_e64 s[8:9], v3, v1
v_cndmask_b32_e64 v1, v27, v3, s[8:9]
v_lshlrev_b32_e32 v5, 2, v1
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v1, v4, v46
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v2, v6, v2
ds_bpermute_b32 v3, v5, v1
ds_bpermute_b32 v4, v5, v2
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 16
ds_bpermute_b32 v6, v0, v37
ds_bpermute_b32 v0, v0, v36
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v6, v6, v37
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v0, v36
ds_bpermute_b32 v7, v5, v6
ds_bpermute_b32 v5, v5, v0
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v37, v7, v6
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v36, v5, v0
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v46, v3, v1
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v47, v4, v2
s_or_b64 exec, exec, s[10:11]
s_or_b64 s[8:9], s[6:7], vcc
s_or_b64 s[8:9], s[8:9], s[4:5]
s_xor_b64 s[10:11], s[8:9], -1
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execz 65168
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v0, vcc, s16, v22
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
global_load_dword v0, v[0:1], off
v_mov_b32_e32 v2, s19
v_add_co_u32_e32 v1, vcc, s18, v22
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dword v7, v[1:2], off
v_mov_b32_e32 v1, s33
v_add_co_u32_e32 v2, vcc, s31, v22
v_addc_co_u32_e32 v3, vcc, 0, v1, vcc
v_mov_b32_e32 v1, s37
v_add_co_u32_e32 v5, vcc, s36, v22
v_addc_co_u32_e32 v6, vcc, 0, v1, vcc
global_load_dword v48, v[5:6], off
global_load_ushort v4, v[11:12], off
global_load_dword v1, v[2:3], off
s_waitcnt vmcnt(3)
v_lshlrev_b32_e32 v3, 3, v7
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v2, 3, v48
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 65128
global_load_ushort v5, v[9:10], off
v_sub_u32_e32 v6, v37, v3
v_sub_u32_e32 v7, v36, v2
v_cvt_f32_i32_e32 v6, v6
v_cvt_f32_i32_e32 v7, v7
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v5, v5
v_mul_f32_e32 v48, v0, v5
v_mul_f32_e32 v5, v1, v5
v_fmac_f32_e32 v16, v6, v48
v_fmac_f32_e32 v15, v7, v5
s_branch 65115
v_cmp_lt_i32_e32 vcc, 0, v13
s_and_b64 exec, exec, vcc
s_cbranch_execz 183
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v0, -1, v0
v_and_b32_e32 v1, 63, v0
v_and_b32_e32 v2, 64, v0
v_add_u32_e32 v7, 64, v2
v_xor_b32_e32 v2, 32, v1
v_cmp_lt_i32_e32 vcc, v2, v7
v_cndmask_b32_e32 v2, v0, v2, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v20
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v20, v4
ds_bpermute_b32 v6, v3, v5
v_xor_b32_e32 v4, 8, v1
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v0, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v5, v6
ds_bpermute_b32 v9, v4, v6
v_xor_b32_e32 v5, 4, v1
v_cmp_lt_i32_e32 vcc, v5, v7
v_cndmask_b32_e32 v5, v0, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v9, v6, v9
ds_bpermute_b32 v10, v5, v9
v_xor_b32_e32 v6, 2, v1
v_cmp_lt_i32_e32 vcc, v6, v7
v_cndmask_b32_e32 v6, v0, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v9, v9, v10
ds_bpermute_b32 v10, v6, v9
v_xor_b32_e32 v1, 1, v1
v_cmp_lt_i32_e32 vcc, v1, v7
v_cndmask_b32_e32 v0, v0, v1, vcc
v_lshlrev_b32_e32 v7, 2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v9, v10
ds_bpermute_b32 v11, v7, v10
v_ashrrev_i32_e32 v9, 31, v8
v_lshlrev_b64 v[0:1], 2, v[8:9]
v_cmp_eq_u32_e32 vcc, 0, v14
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v10, v11
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v2, v17
s_ashr_i32 s21, s20, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v17, v0
ds_bpermute_b32 v1, v3, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v4, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v5, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v6, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v7, v0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 16
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v0, v1
v_mov_b32_e32 v1, s21
v_add_co_u32_e64 v0, s[0:1], s20, v8
v_addc_co_u32_e64 v1, s[0:1], v1, v9, s[0:1]
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
v_cmp_lt_i32_e64 s[0:1], 1, v13
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 68
ds_bpermute_b32 v0, v2, v16
v_mov_b32_e32 v12, s23
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v16, v0
ds_bpermute_b32 v1, v3, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v4, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v5, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v0, v1
ds_bpermute_b32 v11, v6, v10
v_lshlrev_b64 v[0:1], 2, v[8:9]
v_add_co_u32_e64 v0, s[0:1], s22, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v10, v11
ds_bpermute_b32 v9, v7, v8
v_addc_co_u32_e64 v1, s[0:1], v12, v1, s[0:1]
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v9
global_store_dword v[0:1], v8, off offset:4
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v2, v2, v15
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v15, v2
ds_bpermute_b32 v3, v3, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
ds_bpermute_b32 v3, v4, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
ds_bpermute_b32 v3, v5, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
ds_bpermute_b32 v3, v6, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
ds_bpermute_b32 v3, v7, v2
s_and_b64 exec, exec, vcc
s_cbranch_execz 8
s_lshl_b64 s[0:1], s[20:21], 2
v_mov_b32_e32 v4, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
global_store_dword v[0:1], v2, off offset:4
s_endpgm
