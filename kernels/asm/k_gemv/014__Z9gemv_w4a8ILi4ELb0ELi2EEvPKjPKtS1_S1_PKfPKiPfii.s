.text
k__Z9gemv_w4a8ILi4ELb0ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 1065
s_load_dwordx2 s[22:23], s[4:5], 0x30
v_add_u32_e32 v1, 2, v8
v_sub_u32_e32 v2, s20, v8
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v19, 2, v2, vcc
v_and_b32_e32 v23, 63, v0
s_mov_b32 s33, 0
s_cmp_lt_i32 s21, 8
v_mov_b32_e32 v34, 0
v_cmp_lt_i32_e64 s[0:1], 0, v19
v_cmp_lt_i32_e64 s[2:3], 1, v19
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v20, 0
s_cbranch_scc1 707
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_ashr_i32 s4, s21, 31
s_lshr_b32 s5, s4, 29
s_add_i32 s5, s21, s5
s_ashr_i32 s24, s5, 3
v_and_b32_e32 v2, 3, v0
v_or_b32_e32 v6, 1, v8
v_cmp_ne_u32_e64 s[6:7], 0, v2
v_mad_i64_i32 v[2:3], s[28:29], v6, s24, 0
v_mad_i64_i32 v[4:5], s[28:29], s24, v8, 0
s_lshr_b32 s4, s4, 25
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_add_i32 s4, s21, s4
s_ashr_i32 s26, s4, 7
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, s9
v_add_co_u32_e32 v30, vcc, s8, v2
s_ashr_i32 s25, s24, 31
s_ashr_i32 s27, s26, 31
v_addc_co_u32_e32 v31, vcc, v7, v3, vcc
v_lshlrev_b64 v[2:3], 2, v[4:5]
s_mul_i32 s31, s26, 12
s_mul_hi_i32 s30, s26, 12
s_add_u32 s21, s18, s31
v_add_co_u32_e32 v32, vcc, s8, v2
s_addc_u32 s34, s19, s30
s_lshl_b64 s[8:9], s[26:27], 3
s_add_u32 s35, s18, s8
s_addc_u32 s36, s19, s9
s_lshl_b64 s[28:29], s[26:27], 2
s_add_u32 s37, s18, s28
s_addc_u32 s38, s19, s29
s_add_u32 s39, s16, s31
v_addc_co_u32_e32 v33, vcc, v7, v3, vcc
s_addc_u32 s40, s17, s30
v_mad_i64_i32 v[2:3], s[30:31], s26, v8, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_lshlrev_b32_e32 v35, 2, v0
v_lshlrev_b32_e32 v0, 1, v0
s_add_u32 s41, s16, s8
v_add_co_u32_e32 v4, vcc, v2, v0
s_addc_u32 s42, s17, s9
v_addc_co_u32_e32 v5, vcc, 0, v3, vcc
v_mad_i64_i32 v[2:3], s[8:9], v6, s26, 0
v_mov_b32_e32 v7, s11
v_add_co_u32_e32 v9, vcc, s10, v4
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_addc_co_u32_e32 v10, vcc, v7, v5, vcc
v_add_co_u32_e32 v0, vcc, v2, v0
v_addc_co_u32_e32 v2, vcc, 0, v3, vcc
s_add_u32 s43, s16, s28
v_add_co_u32_e32 v11, vcc, s10, v0
v_cmp_gt_i32_e64 s[4:5], 1, v19
v_lshlrev_b32_e32 v28, 4, v23
v_mov_b32_e32 v29, 0
s_addc_u32 s44, s17, s29
v_addc_co_u32_e32 v12, vcc, v7, v2, vcc
v_lshl_add_u32 v36, v23, 2, 4
s_lshl_b64 s[10:11], s[24:25], 2
v_mbcnt_hi_u32_b32 v37, -1, v1
s_movk_i32 s25, 0x400
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v34, 0
s_branch 54
s_or_b64 exec, exec, s[26:27]
s_waitcnt vmcnt(1)
v_cvt_f32_f16_e32 v13, v13
v_sub_u32_e32 v7, v60, v7
v_cvt_f32_i32_e32 v7, v7
v_sub_u32_e32 v6, v59, v6
v_cvt_f32_i32_e32 v6, v6
v_mul_f32_e32 v0, v0, v13
v_fmac_f32_e32 v34, v7, v0
v_mul_f32_e32 v0, v1, v13
v_fmac_f32_e32 v27, v6, v0
v_sub_u32_e32 v0, v58, v5
v_cvt_f32_i32_e32 v0, v0
v_sub_u32_e32 v1, v61, v4
v_cvt_f32_i32_e32 v1, v1
v_mul_f32_e32 v2, v2, v13
v_fmac_f32_e32 v26, v0, v2
s_waitcnt vmcnt(0)
v_mul_f32_e32 v0, v3, v13
v_fmac_f32_e32 v25, v0, v1
s_or_b64 exec, exec, s[8:9]
s_addk_i32 s33, 0x100
s_add_u32 s14, s14, 0x400
s_addc_u32 s15, s15, 0
s_add_u32 s12, s12, 0x400
s_addc_u32 s13, s13, 0
s_add_u32 s21, s21, 64
s_addc_u32 s34, s34, 0
s_add_u32 s35, s35, 64
s_addc_u32 s36, s36, 0
s_add_u32 s37, s37, 64
s_addc_u32 s38, s38, 0
s_add_u32 s18, s18, 64
s_addc_u32 s19, s19, 0
s_add_u32 s39, s39, 64
v_add_co_u32_e32 v30, vcc, s25, v30
s_addc_u32 s40, s40, 0
v_addc_co_u32_e32 v31, vcc, 0, v31, vcc
s_add_u32 s41, s41, 64
v_add_co_u32_e32 v32, vcc, s25, v32
s_addc_u32 s42, s42, 0
v_addc_co_u32_e32 v33, vcc, 0, v33, vcc
s_add_u32 s43, s43, 64
s_addc_u32 s44, s44, 0
v_add_co_u32_e32 v9, vcc, 32, v9
s_add_u32 s16, s16, 64
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_addc_u32 s17, s17, 0
v_add_co_u32_e32 v11, vcc, 32, v11
s_cmp_ge_i32 s33, s24
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
s_cbranch_scc1 564
v_add_u32_e32 v0, s33, v36
v_cmp_lt_i32_e32 vcc, s24, v0
v_cmp_ge_i32_e64 s[8:9], s24, v0
s_and_saveexec_b64 s[26:27], s[0:1]
s_cbranch_execz 127
s_and_saveexec_b64 s[28:29], s[8:9]
s_xor_b64 s[28:29], exec, s[28:29]
s_cbranch_execz 89
v_add_co_u32_e64 v0, s[8:9], v32, v28
v_addc_co_u32_e64 v1, s[8:9], 0, v33, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_and_saveexec_b64 s[30:31], s[2:3]
s_cbranch_execz 43
v_add_co_u32_e64 v4, s[8:9], v30, v28
v_addc_co_u32_e64 v5, s[8:9], 0, v31, s[8:9]
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v13, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v14, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v15, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v16, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v13, 0xf0f0f0f, v13
v_xor_b32_e32 v38, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v14
v_xor_b32_e32 v39, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v15
v_xor_b32_e32 v40, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v16
v_xor_b32_e32 v42, 0x8080808, v13
v_xor_b32_e32 v43, 0x8080808, v7
v_xor_b32_e32 v44, 0x8080808, v6
v_xor_b32_e32 v45, 0x8080808, v5
v_xor_b32_e32 v41, 0x8080808, v4
s_or_b64 exec, exec, s[30:31]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v50, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v53, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v52, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v55, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v54, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v57, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v51, 0x8080808, v4
v_xor_b32_e32 v56, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[28:29]
s_cbranch_execz 32
v_mov_b32_e32 v50, 0x8080808
v_cndmask_b32_e64 v38, v38, v50, s[2:3]
v_cndmask_b32_e64 v39, v39, v50, s[2:3]
v_cndmask_b32_e64 v40, v40, v50, s[2:3]
v_cndmask_b32_e64 v41, v41, v50, s[2:3]
v_cndmask_b32_e64 v42, v42, v50, s[2:3]
v_cndmask_b32_e64 v43, v43, v50, s[2:3]
v_cndmask_b32_e64 v44, v44, v50, s[2:3]
v_cndmask_b32_e64 v45, v45, v50, s[2:3]
v_mov_b32_e32 v52, 0x8080808
v_mov_b32_e32 v54, 0x8080808
v_mov_b32_e32 v56, 0x8080808
v_mov_b32_e32 v51, 0x8080808
v_mov_b32_e32 v53, 0x8080808
v_mov_b32_e32 v55, 0x8080808
v_mov_b32_e32 v57, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[26:27]
v_mov_b32_e32 v0, s13
v_add_co_u32_e64 v13, s[8:9], s12, v28
v_addc_co_u32_e64 v14, s[8:9], 0, v0, s[8:9]
v_mov_b32_e32 v0, s15
v_add_co_u32_e64 v15, s[8:9], s14, v28
v_addc_co_u32_e64 v16, s[8:9], 0, v0, s[8:9]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 55
global_load_dwordx4 v[0:3], v[13:14], off
global_load_dwordx4 v[4:7], v[15:16], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v17, v51, v0, v29
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v18, v50, v4, v29
v_dot4_i32_i8 v60, v53, v1, v29
v_dot4_i32_i8 v62, v52, v5, v29
v_dot4_i32_i8 v63, v55, v2, v29
v_dot4_i32_i8 v64, v54, v6, v29
v_dot4_i32_i8 v65, v57, v3, v29
v_dot4_i32_i8 v66, v56, v7, v29
s_and_saveexec_b64 s[26:27], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v41, v0, v29
v_dot4_i32_i8 v4, v45, v4, v29
v_dot4_i32_i8 v1, v40, v1, v29
v_dot4_i32_i8 v5, v44, v5, v29
v_dot4_i32_i8 v2, v39, v2, v29
v_dot4_i32_i8 v6, v43, v6, v29
v_dot4_i32_i8 v3, v38, v3, v29
v_dot4_i32_i8 v7, v42, v7, v29
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v49, v0, v3, v7
s_or_b64 exec, exec, s[26:27]
v_add_u32_e32 v0, v18, v17
v_add3_u32 v0, v0, v60, v62
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v60, v0, v65, v66
s_or_b64 exec, exec, s[8:9]
v_mov_b32_e32 v0, s11
v_add_co_u32_e64 v13, s[8:9], s10, v13
v_addc_co_u32_e64 v14, s[8:9], v14, v0, s[8:9]
v_add_co_u32_e64 v17, s[8:9], s10, v15
v_addc_co_u32_e64 v18, s[8:9], v16, v0, s[8:9]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 55
global_load_dwordx4 v[0:3], v[13:14], off
global_load_dwordx4 v[4:7], v[17:18], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v15, v51, v0, v29
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v16, v50, v4, v29
v_dot4_i32_i8 v59, v53, v1, v29
v_dot4_i32_i8 v62, v52, v5, v29
v_dot4_i32_i8 v63, v55, v2, v29
v_dot4_i32_i8 v64, v54, v6, v29
v_dot4_i32_i8 v65, v57, v3, v29
v_dot4_i32_i8 v66, v56, v7, v29
s_and_saveexec_b64 s[26:27], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v41, v0, v29
v_dot4_i32_i8 v4, v45, v4, v29
v_dot4_i32_i8 v1, v40, v1, v29
v_dot4_i32_i8 v5, v44, v5, v29
v_dot4_i32_i8 v2, v39, v2, v29
v_dot4_i32_i8 v6, v43, v6, v29
v_dot4_i32_i8 v3, v38, v3, v29
v_dot4_i32_i8 v7, v42, v7, v29
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v48, v0, v3, v7
s_or_b64 exec, exec, s[26:27]
v_add_u32_e32 v0, v16, v15
v_add3_u32 v0, v0, v59, v62
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v59, v0, v65, v66
s_or_b64 exec, exec, s[8:9]
v_mov_b32_e32 v0, s11
v_add_co_u32_e64 v15, s[8:9], s10, v13
v_addc_co_u32_e64 v16, s[8:9], v14, v0, s[8:9]
v_add_co_u32_e64 v13, s[8:9], s10, v17
v_addc_co_u32_e64 v14, s[8:9], v18, v0, s[8:9]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 55
global_load_dwordx4 v[0:3], v[15:16], off
global_load_dwordx4 v[4:7], v[13:14], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v17, v51, v0, v29
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v18, v50, v4, v29
v_dot4_i32_i8 v58, v53, v1, v29
v_dot4_i32_i8 v62, v52, v5, v29
v_dot4_i32_i8 v63, v55, v2, v29
v_dot4_i32_i8 v64, v54, v6, v29
v_dot4_i32_i8 v65, v57, v3, v29
v_dot4_i32_i8 v66, v56, v7, v29
s_and_saveexec_b64 s[26:27], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v41, v0, v29
v_dot4_i32_i8 v4, v45, v4, v29
v_dot4_i32_i8 v1, v40, v1, v29
v_dot4_i32_i8 v5, v44, v5, v29
v_dot4_i32_i8 v2, v39, v2, v29
v_dot4_i32_i8 v6, v43, v6, v29
v_dot4_i32_i8 v3, v38, v3, v29
v_dot4_i32_i8 v7, v42, v7, v29
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v47, v0, v3, v7
s_or_b64 exec, exec, s[26:27]
v_add_u32_e32 v0, v18, v17
v_add3_u32 v0, v0, v58, v62
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v58, v0, v65, v66
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[26:27], s[0:1]
s_cbranch_execz 147
v_mov_b32_e32 v5, s11
v_add_co_u32_e64 v0, s[8:9], s10, v15
v_addc_co_u32_e64 v1, s[8:9], v16, v5, s[8:9]
v_add_co_u32_e64 v4, s[8:9], s10, v13
v_addc_co_u32_e64 v5, s[8:9], v14, v5, s[8:9]
global_load_dwordx4 v[0:3], v[0:1], off
s_nop 0
global_load_dwordx4 v[4:7], v[4:5], off
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v13, v51, v0, v29
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v14, v50, v4, v29
v_dot4_i32_i8 v15, v53, v1, v29
v_dot4_i32_i8 v16, v52, v5, v29
v_dot4_i32_i8 v17, v55, v2, v29
v_dot4_i32_i8 v18, v54, v6, v29
v_dot4_i32_i8 v61, v57, v3, v29
v_dot4_i32_i8 v62, v56, v7, v29
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v41, v0, v29
v_dot4_i32_i8 v4, v45, v4, v29
v_dot4_i32_i8 v1, v40, v1, v29
v_dot4_i32_i8 v5, v44, v5, v29
v_dot4_i32_i8 v2, v39, v2, v29
v_dot4_i32_i8 v6, v43, v6, v29
v_dot4_i32_i8 v3, v38, v3, v29
v_dot4_i32_i8 v7, v42, v7, v29
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v46, v0, v3, v7
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v14, v13
v_add3_u32 v0, v0, v15, v16
v_add3_u32 v0, v0, v17, v18
v_add3_u32 v3, v0, v61, v62
v_and_b32_e32 v0, 64, v37
v_and_b32_e32 v1, 63, v37
v_add_u32_e32 v0, 64, v0
v_xor_b32_e32 v2, 1, v1
v_cmp_lt_i32_e64 s[8:9], v2, v0
v_cndmask_b32_e64 v2, v37, v2, s[8:9]
v_lshlrev_b32_e32 v13, 2, v2
ds_bpermute_b32 v2, v13, v60
v_xor_b32_e32 v1, 2, v1
v_cmp_lt_i32_e64 s[8:9], v1, v0
v_cndmask_b32_e64 v0, v37, v1, s[8:9]
v_lshlrev_b32_e32 v14, 2, v0
ds_bpermute_b32 v4, v13, v59
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v0, v2, v60
ds_bpermute_b32 v2, v13, v58
ds_bpermute_b32 v7, v13, v3
ds_bpermute_b32 v1, v14, v0
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v4, v4, v59
ds_bpermute_b32 v5, v14, v4
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v2, v2, v58
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v3, v7, v3
ds_bpermute_b32 v6, v14, v2
ds_bpermute_b32 v7, v14, v3
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 32
ds_bpermute_b32 v15, v13, v49
ds_bpermute_b32 v16, v13, v48
ds_bpermute_b32 v17, v13, v47
ds_bpermute_b32 v13, v13, v46
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v15, v15, v49
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v16, v16, v48
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v17, v17, v47
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v13, v13, v46
ds_bpermute_b32 v18, v14, v15
ds_bpermute_b32 v48, v14, v16
ds_bpermute_b32 v47, v14, v17
ds_bpermute_b32 v14, v14, v13
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v49, v18, v15
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v48, v48, v16
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v47, v47, v17
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v46, v14, v13
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v60, v1, v0
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v59, v5, v4
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v58, v6, v2
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v61, v7, v3
s_or_b64 exec, exec, s[26:27]
s_or_b64 s[8:9], s[6:7], vcc
s_or_b64 s[8:9], s[8:9], s[4:5]
s_xor_b64 s[26:27], s[8:9], -1
s_and_saveexec_b64 s[8:9], s[26:27]
s_cbranch_execz 65011
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v0, vcc, s16, v35
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
global_load_dword v0, v[0:1], off
v_mov_b32_e32 v2, s19
v_add_co_u32_e32 v1, vcc, s18, v35
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dword v14, v[1:2], off
v_mov_b32_e32 v2, s44
v_add_co_u32_e32 v1, vcc, s43, v35
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dword v1, v[1:2], off
v_mov_b32_e32 v3, s38
v_add_co_u32_e32 v2, vcc, s37, v35
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
global_load_dword v15, v[2:3], off
v_mov_b32_e32 v3, s42
v_add_co_u32_e32 v2, vcc, s41, v35
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
global_load_dword v2, v[2:3], off
v_mov_b32_e32 v4, s36
v_add_co_u32_e32 v3, vcc, s35, v35
v_addc_co_u32_e32 v4, vcc, 0, v4, vcc
global_load_dword v16, v[3:4], off
v_mov_b32_e32 v3, s40
v_add_co_u32_e32 v4, vcc, s39, v35
v_addc_co_u32_e32 v5, vcc, 0, v3, vcc
v_mov_b32_e32 v3, s34
v_add_co_u32_e32 v6, vcc, s21, v35
v_addc_co_u32_e32 v7, vcc, 0, v3, vcc
global_load_dword v17, v[6:7], off
global_load_ushort v13, v[9:10], off
global_load_dword v3, v[4:5], off
s_waitcnt vmcnt(7)
v_lshlrev_b32_e32 v7, 3, v14
s_waitcnt vmcnt(5)
v_lshlrev_b32_e32 v6, 3, v15
s_waitcnt vmcnt(3)
v_lshlrev_b32_e32 v5, 3, v16
s_waitcnt vmcnt(2)
v_lshlrev_b32_e32 v4, 3, v17
s_and_saveexec_b64 s[26:27], s[2:3]
s_cbranch_execz 64939
global_load_ushort v14, v[11:12], off
v_sub_u32_e32 v15, v49, v7
v_sub_u32_e32 v16, v48, v6
v_sub_u32_e32 v17, v47, v5
v_sub_u32_e32 v18, v46, v4
v_cvt_f32_i32_e32 v15, v15
v_cvt_f32_i32_e32 v16, v16
v_cvt_f32_i32_e32 v17, v17
v_cvt_f32_i32_e32 v18, v18
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v14, v14
v_mul_f32_e32 v62, v0, v14
v_mul_f32_e32 v63, v1, v14
v_mul_f32_e32 v64, v2, v14
v_mul_f32_e32 v14, v3, v14
v_fmac_f32_e32 v24, v15, v62
v_fmac_f32_e32 v22, v16, v63
v_fmac_f32_e32 v21, v17, v64
v_fmac_f32_e32 v20, v18, v14
s_branch 64918
v_cmp_lt_i32_e32 vcc, 0, v19
s_and_b64 exec, exec, vcc
s_cbranch_execz 331
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v0, -1, v0
v_and_b32_e32 v1, 63, v0
v_and_b32_e32 v2, 64, v0
v_add_u32_e32 v7, 64, v2
v_xor_b32_e32 v2, 32, v1
v_cmp_lt_i32_e32 vcc, v2, v7
v_cndmask_b32_e32 v2, v0, v2, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v34
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v34, v4
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
v_cmp_eq_u32_e32 vcc, 0, v23
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v10, v11
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v2, v27
s_ashr_i32 s21, s20, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v27, v0
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
ds_bpermute_b32 v0, v2, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v26, v0
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
ds_bpermute_b32 v0, v2, v25
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v25, v0
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
s_cbranch_execz 13
v_mad_i64_i32 v[10:11], s[0:1], s20, 3, v[8:9]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v0, v1
v_mov_b32_e32 v13, s23
v_lshlrev_b64 v[0:1], 2, v[10:11]
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v13, v1, s[0:1]
global_store_dword v[0:1], v12, off
s_or_b64 exec, exec, s[2:3]
v_cmp_lt_i32_e64 s[0:1], 1, v19
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 136
ds_bpermute_b32 v0, v2, v24
v_mov_b32_e32 v12, s23
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v24, v0
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
ds_bpermute_b32 v8, v2, v22
s_lshl_b64 s[2:3], s[20:21], 2
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v22, v8
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
ds_bpermute_b32 v8, v2, v21
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
v_addc_co_u32_e64 v1, s[0:1], v1, v10, s[0:1]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v21, v8
ds_bpermute_b32 v9, v3, v8
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
ds_bpermute_b32 v2, v2, v20
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v20, v2
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
