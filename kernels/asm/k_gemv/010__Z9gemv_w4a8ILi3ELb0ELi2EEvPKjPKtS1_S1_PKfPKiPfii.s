.text
k__Z9gemv_w4a8ILi3ELb0ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 912
s_load_dwordx2 s[22:23], s[4:5], 0x30
v_add_u32_e32 v1, 2, v8
v_sub_u32_e32 v2, s20, v8
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v13, 2, v2, vcc
v_and_b32_e32 v14, 63, v0
s_mov_b32 s30, 0
s_cmp_lt_i32 s21, 8
v_mov_b32_e32 v23, 0
v_cmp_lt_i32_e64 s[0:1], 0, v13
v_cmp_lt_i32_e64 s[2:3], 1, v13
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v15, 0
s_cbranch_scc1 628
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_ashr_i32 s4, s21, 31
s_lshr_b32 s5, s4, 29
s_lshr_b32 s4, s4, 25
s_add_i32 s4, s21, s4
s_ashr_i32 s26, s4, 7
v_and_b32_e32 v2, 3, v0
v_or_b32_e32 v4, 1, v8
v_cmp_ne_u32_e64 s[6:7], 0, v2
v_mad_i64_i32 v[2:3], s[34:35], v4, s26, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v5, 1, v0
v_add_co_u32_e32 v6, vcc, v2, v5
v_addc_co_u32_e32 v7, vcc, 0, v3, vcc
v_mad_i64_i32 v[2:3], s[34:35], s26, v8, 0
s_add_i32 s5, s21, s5
s_ashr_i32 s24, s5, 3
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v12, s11
v_add_co_u32_e32 v9, vcc, s10, v6
v_lshlrev_b64 v[2:3], 1, v[2:3]
s_ashr_i32 s25, s24, 31
v_addc_co_u32_e32 v10, vcc, v12, v7, vcc
s_ashr_i32 s27, s26, 31
s_lshl_b64 s[28:29], s[24:25], 3
v_add_co_u32_e32 v2, vcc, v2, v5
s_add_u32 s21, s14, s28
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_addc_u32 s31, s15, s29
v_add_co_u32_e32 v11, vcc, s10, v2
s_lshl_b64 s[10:11], s[24:25], 2
s_add_u32 s25, s14, s10
s_addc_u32 s33, s15, s11
s_lshl_b64 s[40:41], s[26:27], 2
s_add_u32 s34, s16, s40
s_addc_u32 s35, s17, s41
s_add_u32 s36, s12, s28
s_addc_u32 s37, s13, s29
s_lshl_b64 s[26:27], s[26:27], 3
s_add_u32 s38, s16, s26
s_addc_u32 s39, s17, s27
v_addc_co_u32_e32 v12, vcc, v12, v3, vcc
s_add_u32 s40, s18, s40
v_mad_i64_i32 v[2:3], s[28:29], v4, s24, 0
s_addc_u32 s41, s19, s41
s_add_u32 s42, s12, s10
s_addc_u32 s43, s13, s11
v_mad_i64_i32 v[4:5], s[10:11], s24, v8, 0
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_lshlrev_b32_e32 v24, 2, v0
v_mov_b32_e32 v0, s9
v_add_co_u32_e32 v25, vcc, s8, v2
v_addc_co_u32_e32 v26, vcc, v0, v3, vcc
v_lshlrev_b64 v[2:3], 2, v[4:5]
s_add_u32 s44, s18, s26
v_add_co_u32_e32 v27, vcc, s8, v2
v_cmp_gt_i32_e64 s[4:5], 1, v13
v_lshlrev_b32_e32 v19, 4, v14
v_mov_b32_e32 v20, 0
v_lshl_add_u32 v22, v14, 2, 4
s_addc_u32 s45, s19, s27
v_addc_co_u32_e32 v28, vcc, v0, v3, vcc
v_mbcnt_hi_u32_b32 v29, -1, v1
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v23, 0
s_branch 60
s_or_b64 exec, exec, s[10:11]
s_waitcnt vmcnt(1)
v_cvt_f32_f16_e32 v6, v6
v_sub_u32_e32 v5, v50, v5
v_cvt_f32_i32_e32 v5, v5
v_sub_u32_e32 v4, v49, v4
v_mul_f32_e32 v0, v0, v6
v_sub_u32_e32 v3, v51, v3
v_fmac_f32_e32 v23, v5, v0
v_cvt_f32_i32_e32 v0, v4
v_cvt_f32_i32_e32 v3, v3
v_mul_f32_e32 v1, v1, v6
v_fmac_f32_e32 v21, v0, v1
s_waitcnt vmcnt(0)
v_mul_f32_e32 v0, v2, v6
v_fmac_f32_e32 v18, v0, v3
s_or_b64 exec, exec, s[8:9]
s_addk_i32 s30, 0x100
s_add_u32 s21, s21, 0x400
s_addc_u32 s31, s31, 0
s_add_u32 s25, s25, 0x400
s_addc_u32 s33, s33, 0
s_add_u32 s14, s14, 0x400
s_addc_u32 s15, s15, 0
s_add_u32 s16, s16, 64
s_addc_u32 s17, s17, 0
s_add_u32 s34, s34, 64
s_addc_u32 s35, s35, 0
s_add_u32 s36, s36, 0x400
s_addc_u32 s37, s37, 0
s_add_u32 s38, s38, 64
s_addc_u32 s39, s39, 0
s_add_u32 s18, s18, 64
s_addc_u32 s19, s19, 0
s_add_u32 s40, s40, 64
v_add_co_u32_e32 v9, vcc, 32, v9
s_addc_u32 s41, s41, 0
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_add_u32 s42, s42, 0x400
v_add_co_u32_e32 v11, vcc, 32, v11
s_addc_u32 s43, s43, 0
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
s_add_u32 s12, s12, 0x400
s_addc_u32 s13, s13, 0
v_add_co_u32_e32 v25, vcc, 0x400, v25
s_add_u32 s44, s44, 64
v_addc_co_u32_e32 v26, vcc, 0, v26, vcc
s_addc_u32 s45, s45, 0
v_add_co_u32_e32 v27, vcc, 0x400, v27
s_cmp_ge_i32 s30, s24
v_addc_co_u32_e32 v28, vcc, 0, v28, vcc
s_cbranch_scc1 479
v_add_u32_e32 v0, s30, v22
v_cmp_lt_i32_e32 vcc, s24, v0
v_cmp_ge_i32_e64 s[8:9], s24, v0
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 10
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 137
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 203
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 269
s_branch 400
s_and_saveexec_b64 s[26:27], s[8:9]
s_xor_b64 s[26:27], exec, s[26:27]
s_cbranch_execz 89
v_add_co_u32_e64 v0, s[8:9], v27, v19
v_addc_co_u32_e64 v1, s[8:9], 0, v28, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_and_saveexec_b64 s[28:29], s[2:3]
s_cbranch_execz 43
v_add_co_u32_e64 v4, s[8:9], v25, v19
v_addc_co_u32_e64 v5, s[8:9], 0, v26, s[8:9]
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v31, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v32, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v33, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v34, 0xf0f0f0f, v30
v_xor_b32_e32 v30, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v31
v_xor_b32_e32 v31, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v32
v_xor_b32_e32 v32, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v33
v_xor_b32_e32 v34, 0x8080808, v34
v_xor_b32_e32 v35, 0x8080808, v7
v_xor_b32_e32 v36, 0x8080808, v6
v_xor_b32_e32 v37, 0x8080808, v5
v_xor_b32_e32 v33, 0x8080808, v4
s_or_b64 exec, exec, s[28:29]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v41, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v44, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v43, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v46, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v45, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v48, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v42, 0x8080808, v4
v_xor_b32_e32 v47, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[26:27]
s_cbranch_execz 32
v_mov_b32_e32 v41, 0x8080808
v_cndmask_b32_e64 v30, v30, v41, s[2:3]
v_cndmask_b32_e64 v31, v31, v41, s[2:3]
v_cndmask_b32_e64 v32, v32, v41, s[2:3]
v_cndmask_b32_e64 v33, v33, v41, s[2:3]
v_cndmask_b32_e64 v34, v34, v41, s[2:3]
v_cndmask_b32_e64 v35, v35, v41, s[2:3]
v_cndmask_b32_e64 v36, v36, v41, s[2:3]
v_cndmask_b32_e64 v37, v37, v41, s[2:3]
v_mov_b32_e32 v43, 0x8080808
v_mov_b32_e32 v45, 0x8080808
v_mov_b32_e32 v47, 0x8080808
v_mov_b32_e32 v42, 0x8080808
v_mov_b32_e32 v44, 0x8080808
v_mov_b32_e32 v46, 0x8080808
v_mov_b32_e32 v48, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 65399
v_mov_b32_e32 v1, s13
v_add_co_u32_e64 v0, s[8:9], s12, v19
v_addc_co_u32_e64 v1, s[8:9], 0, v1, s[8:9]
v_mov_b32_e32 v5, s15
v_add_co_u32_e64 v4, s[8:9], s14, v19
v_addc_co_u32_e64 v5, s[8:9], 0, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v50, v42, v0, v20
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v52, v41, v4, v20
v_dot4_i32_i8 v53, v44, v1, v20
v_dot4_i32_i8 v54, v43, v5, v20
v_dot4_i32_i8 v55, v46, v2, v20
v_dot4_i32_i8 v56, v45, v6, v20
v_dot4_i32_i8 v57, v48, v3, v20
v_dot4_i32_i8 v58, v47, v7, v20
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v33, v0, v20
v_dot4_i32_i8 v4, v37, v4, v20
v_dot4_i32_i8 v1, v32, v1, v20
v_dot4_i32_i8 v5, v36, v5, v20
v_dot4_i32_i8 v2, v31, v2, v20
v_dot4_i32_i8 v6, v35, v6, v20
v_dot4_i32_i8 v3, v30, v3, v20
v_dot4_i32_i8 v7, v34, v7, v20
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v40, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v52, v50
v_add3_u32 v0, v0, v53, v54
v_add3_u32 v0, v0, v55, v56
v_add3_u32 v50, v0, v57, v58
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 65333
v_mov_b32_e32 v1, s43
v_add_co_u32_e64 v0, s[8:9], s42, v19
v_addc_co_u32_e64 v1, s[8:9], 0, v1, s[8:9]
v_mov_b32_e32 v5, s33
v_add_co_u32_e64 v4, s[8:9], s25, v19
v_addc_co_u32_e64 v5, s[8:9], 0, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v49, v42, v0, v20
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v52, v41, v4, v20
v_dot4_i32_i8 v53, v44, v1, v20
v_dot4_i32_i8 v54, v43, v5, v20
v_dot4_i32_i8 v55, v46, v2, v20
v_dot4_i32_i8 v56, v45, v6, v20
v_dot4_i32_i8 v57, v48, v3, v20
v_dot4_i32_i8 v58, v47, v7, v20
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v33, v0, v20
v_dot4_i32_i8 v4, v37, v4, v20
v_dot4_i32_i8 v1, v32, v1, v20
v_dot4_i32_i8 v5, v36, v5, v20
v_dot4_i32_i8 v2, v31, v2, v20
v_dot4_i32_i8 v6, v35, v6, v20
v_dot4_i32_i8 v3, v30, v3, v20
v_dot4_i32_i8 v7, v34, v7, v20
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v39, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v52, v49
v_add3_u32 v0, v0, v53, v54
v_add3_u32 v0, v0, v55, v56
v_add3_u32 v49, v0, v57, v58
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 132
v_mov_b32_e32 v1, s37
v_add_co_u32_e64 v0, s[8:9], s36, v19
v_addc_co_u32_e64 v1, s[8:9], 0, v1, s[8:9]
v_mov_b32_e32 v5, s31
v_add_co_u32_e64 v4, s[8:9], s21, v19
v_addc_co_u32_e64 v5, s[8:9], 0, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v51, v42, v0, v20
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v52, v41, v4, v20
v_dot4_i32_i8 v53, v44, v1, v20
v_dot4_i32_i8 v54, v43, v5, v20
v_dot4_i32_i8 v55, v46, v2, v20
v_dot4_i32_i8 v56, v45, v6, v20
v_dot4_i32_i8 v57, v48, v3, v20
v_dot4_i32_i8 v58, v47, v7, v20
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v33, v0, v20
v_dot4_i32_i8 v4, v37, v4, v20
v_dot4_i32_i8 v1, v32, v1, v20
v_dot4_i32_i8 v5, v36, v5, v20
v_dot4_i32_i8 v2, v31, v2, v20
v_dot4_i32_i8 v6, v35, v6, v20
v_dot4_i32_i8 v3, v30, v3, v20
v_dot4_i32_i8 v7, v34, v7, v20
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v38, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v52, v51
v_add3_u32 v0, v0, v53, v54
v_add3_u32 v0, v0, v55, v56
v_add3_u32 v1, v0, v57, v58
v_and_b32_e32 v0, 64, v29
v_and_b32_e32 v2, 63, v29
v_add_u32_e32 v0, 64, v0
v_xor_b32_e32 v3, 1, v2
v_cmp_lt_i32_e64 s[8:9], v3, v0
v_cndmask_b32_e64 v3, v29, v3, s[8:9]
v_lshlrev_b32_e32 v6, 2, v3
ds_bpermute_b32 v3, v6, v50
ds_bpermute_b32 v4, v6, v49
ds_bpermute_b32 v5, v6, v1
v_xor_b32_e32 v2, 2, v2
v_cmp_lt_i32_e64 s[8:9], v2, v0
v_cndmask_b32_e64 v0, v29, v2, s[8:9]
v_lshlrev_b32_e32 v7, 2, v0
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v2, v3, v50
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v0, v4, v49
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v1, v5, v1
ds_bpermute_b32 v3, v7, v2
ds_bpermute_b32 v4, v7, v0
ds_bpermute_b32 v5, v7, v1
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 24
ds_bpermute_b32 v49, v6, v40
ds_bpermute_b32 v50, v6, v39
ds_bpermute_b32 v6, v6, v38
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v40, v49, v40
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v39, v50, v39
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v6, v6, v38
ds_bpermute_b32 v38, v7, v40
ds_bpermute_b32 v49, v7, v39
ds_bpermute_b32 v7, v7, v6
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v40, v38, v40
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v39, v49, v39
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v38, v7, v6
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v50, v3, v2
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v49, v4, v0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v51, v5, v1
s_or_b64 exec, exec, s[10:11]
s_or_b64 s[8:9], s[6:7], vcc
s_or_b64 s[8:9], s[8:9], s[4:5]
s_xor_b64 s[10:11], s[8:9], -1
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execz 65070
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v0, vcc, s16, v24
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
global_load_dword v0, v[0:1], off
v_mov_b32_e32 v2, s19
v_add_co_u32_e32 v1, vcc, s18, v24
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dword v5, v[1:2], off
v_mov_b32_e32 v2, s35
v_add_co_u32_e32 v1, vcc, s34, v24
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dword v1, v[1:2], off
v_mov_b32_e32 v3, s41
v_add_co_u32_e32 v2, vcc, s40, v24
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
global_load_dword v7, v[2:3], off
v_mov_b32_e32 v2, s39
v_add_co_u32_e32 v3, vcc, s38, v24
v_addc_co_u32_e32 v4, vcc, 0, v2, vcc
v_mov_b32_e32 v2, s45
v_add_co_u32_e32 v52, vcc, s44, v24
v_addc_co_u32_e32 v53, vcc, 0, v2, vcc
global_load_dword v54, v[52:53], off
global_load_ushort v6, v[11:12], off
global_load_dword v2, v[3:4], off
s_waitcnt vmcnt(5)
v_lshlrev_b32_e32 v5, 3, v5
s_waitcnt vmcnt(3)
v_lshlrev_b32_e32 v4, 3, v7
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v3, 3, v54
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 65014
global_load_ushort v7, v[9:10], off
v_sub_u32_e32 v52, v40, v5
v_sub_u32_e32 v53, v39, v4
v_sub_u32_e32 v54, v38, v3
v_cvt_f32_i32_e32 v52, v52
v_cvt_f32_i32_e32 v53, v53
v_cvt_f32_i32_e32 v54, v54
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v7, v7
v_mul_f32_e32 v55, v0, v7
v_mul_f32_e32 v56, v1, v7
v_mul_f32_e32 v7, v2, v7
v_fmac_f32_e32 v17, v52, v55
v_fmac_f32_e32 v16, v53, v56
v_fmac_f32_e32 v15, v54, v7
s_branch 64997
v_cmp_lt_i32_e32 vcc, 0, v13
s_and_b64 exec, exec, vcc
s_cbranch_execz 259
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v0, -1, v0
v_and_b32_e32 v1, 63, v0
v_and_b32_e32 v2, 64, v0
v_add_u32_e32 v7, 64, v2
v_xor_b32_e32 v2, 32, v1
v_cmp_lt_i32_e32 vcc, v2, v7
v_cndmask_b32_e32 v2, v0, v2, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v23
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v23, v4
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
ds_bpermute_b32 v0, v2, v21
s_ashr_i32 s21, s20, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v21, v0
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
ds_bpermute_b32 v0, v2, v18
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v18, v0
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
s_cbranch_execz 17
s_lshl_b64 s[0:1], s[20:21], 1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v0, v1
v_mov_b32_e32 v1, s1
v_add_co_u32_e64 v0, s[0:1], s0, v8
v_addc_co_u32_e64 v1, s[0:1], v1, v9, s[0:1]
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
v_cmp_lt_i32_e64 s[0:1], 1, v13
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 102
ds_bpermute_b32 v0, v2, v17
v_mov_b32_e32 v12, s23
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
ds_bpermute_b32 v8, v2, v16
s_lshl_b64 s[2:3], s[20:21], 2
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v16, v8
ds_bpermute_b32 v9, v3, v8
v_addc_co_u32_e64 v1, s[0:1], v1, v10, s[0:1]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v9
ds_bpermute_b32 v9, v4, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v9
ds_bpermute_b32 v9, v5, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v9
ds_bpermute_b32 v9, v6, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v8, v9
ds_bpermute_b32 v9, v7, v8
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
s_cbranch_execz 7
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
global_store_dword v[0:1], v2, off offset:4
s_endpgm
