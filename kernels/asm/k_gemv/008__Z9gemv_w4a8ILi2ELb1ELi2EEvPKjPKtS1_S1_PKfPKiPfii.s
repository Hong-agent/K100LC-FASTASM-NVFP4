.text
k__Z9gemv_w4a8ILi2ELb1ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 886
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_load_dwordx2 s[22:23], s[4:5], 0x30
s_ashr_i32 s26, s21, 31
s_lshr_b32 s0, s26, 29
s_add_i32 s0, s21, s0
s_ashr_i32 s28, s0, 3
s_add_u32 s6, s4, 64
v_cmp_gt_i32_e32 vcc, s28, v0
s_addc_u32 s7, s5, 0
v_lshlrev_b32_e32 v1, 2, v0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 45
s_load_dword s0, s[6:7], 0xc
s_lshl_b32 s27, s28, 3
s_mov_b32 s29, 0
v_add_u32_e32 v2, 0, v1
v_mov_b32_e32 v3, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s30, s0, 0xffff
s_lshl_b32 s31, s30, 2
s_mov_b64 s[24:25], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[2:3], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e64 v5, s[0:1], s14, v1
v_addc_co_u32_e64 v10, s[2:3], v6, v3, s[2:3]
v_addc_co_u32_e64 v6, s[0:1], v7, v3, s[0:1]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v6, s29
v_add_co_u32_e64 v1, s[0:1], s31, v1
v_add_u32_e32 v4, s30, v4
v_addc_co_u32_e64 v3, s[0:1], v3, v6, s[0:1]
v_cmp_le_i32_e64 s[0:1], s28, v4
v_add_u32_e32 v5, s27, v2
s_or_b64 s[24:25], s[0:1], s[24:25]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s31, v2
s_andn2_b64 exec, exec, s[24:25]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[4:5]
s_lshr_b32 s0, s26, 25
s_add_i32 s0, s21, s0
s_ashr_i32 s29, s0, 7
v_cmp_gt_i32_e64 s[0:1], s29, v0
s_and_saveexec_b64 s[24:25], s[0:1]
s_cbranch_execz 48
s_load_dword s2, s[6:7], 0xc
s_lshl_b32 s3, s28, 4
v_lshlrev_b32_e32 v1, 2, v0
s_lshl_b32 s30, s29, 3
s_mov_b32 s31, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s33, s2, 0xffff
s_add_i32 s2, s3, 0
v_add_u32_e32 v2, s2, v1
s_lshl_b32 s34, s33, 2
v_mov_b32_e32 v3, 0
s_mov_b64 s[26:27], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v9, s[4:5], s16, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e64 v5, s[2:3], s18, v1
v_addc_co_u32_e64 v10, s[4:5], v6, v3, s[4:5]
v_addc_co_u32_e64 v6, s[2:3], v7, v3, s[2:3]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v6, s31
v_add_co_u32_e64 v1, s[2:3], s34, v1
v_add_u32_e32 v4, s33, v4
v_addc_co_u32_e64 v3, s[2:3], v3, v6, s[2:3]
v_cmp_le_i32_e64 s[2:3], s29, v4
v_add_u32_e32 v5, s30, v2
s_or_b64 s[26:27], s[2:3], s[26:27]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s34, v2
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[24:25]
s_ashr_i32 s2, s28, 31
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 48
s_load_dword s3, s[6:7], 0xc
v_mov_b32_e32 v2, s2
v_add_co_u32_e32 v1, vcc, s28, v0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_mul_i32 s2, s28, 12
s_waitcnt lgkmcnt(0)
s_and_b32 s27, s3, 0xffff
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_add_i32 s31, s2, 0
s_lshl_b32 s2, s28, 2
s_mov_b32 s26, 0
s_lshl_b32 s30, s27, 2
v_lshlrev_b32_e32 v3, 2, v0
s_add_i32 s33, s2, 0
s_mov_b64 s[24:25], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[2:3], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e32 v5, vcc, s14, v1
v_addc_co_u32_e64 v10, s[2:3], v6, v2, s[2:3]
v_addc_co_u32_e32 v6, vcc, v7, v2, vcc
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s26
v_add_co_u32_e32 v1, vcc, s30, v1
v_add_u32_e32 v4, s27, v4
v_addc_co_u32_e32 v2, vcc, v2, v9, vcc
v_cmp_le_i32_e32 vcc, s28, v4
v_add_u32_e32 v5, s33, v3
v_add_u32_e32 v6, s31, v3
v_add_u32_e32 v3, s30, v3
s_or_b64 s[24:25], vcc, s[24:25]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[24:25]
s_cbranch_execnz 65507
s_or_b64 exec, exec, s[4:5]
s_ashr_i32 s4, s29, 31
s_waitcnt lgkmcnt(0)
s_mul_i32 s12, s29, 12
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 50
s_load_dword s0, s[6:7], 0xc
v_mov_b32_e32 v2, s4
v_add_co_u32_e32 v1, vcc, s29, v0
s_lshl_b32 s1, s28, 3
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_add_i32 s5, s1, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s13, s0, 0xffff
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_mov_b32 s6, 0
s_add_i32 s7, s5, s1
s_lshl_b32 s14, s13, 2
v_lshl_add_u32 v3, v0, 2, s12
v_add_lshl_u32 v4, v0, s29, 2
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v5, v0
v_mov_b32_e32 v7, s17
v_add_co_u32_e64 v9, s[0:1], s16, v1
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v6, vcc, s18, v1
v_addc_co_u32_e64 v10, s[0:1], v7, v2, s[0:1]
v_addc_co_u32_e32 v7, vcc, v11, v2, vcc
global_load_dword v11, v[9:10], off
global_load_dword v12, v[6:7], off
v_mov_b32_e32 v9, s6
v_add_co_u32_e32 v1, vcc, s14, v1
v_add_u32_e32 v5, s13, v5
v_addc_co_u32_e32 v2, vcc, v2, v9, vcc
v_add_u32_e32 v6, s7, v4
v_add_u32_e32 v7, s7, v3
s_add_i32 s7, s7, s14
v_cmp_le_i32_e32 vcc, s29, v5
s_or_b64 s[4:5], vcc, s[4:5]
s_waitcnt vmcnt(1)
ds_write_b32 v6, v11
s_waitcnt vmcnt(0)
ds_write_b32 v7, v12
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65507
s_or_b64 exec, exec, s[2:3]
v_add_u32_e32 v1, 2, v8
v_sub_u32_e32 v2, s20, v8
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v20, 2, v2, vcc
v_and_b32_e32 v21, 63, v0
s_mov_b32 s14, 0
s_cmp_gt_i32 s21, 7
v_mov_b32_e32 v25, 0
v_cmp_lt_i32_e64 s[0:1], 0, v20
v_cmp_lt_i32_e64 s[2:3], 1, v20
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v22, 0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc0 453
v_or_b32_e32 v5, 1, v8
v_mad_i64_i32 v[2:3], s[6:7], v5, s28, 0
v_and_b32_e32 v4, 3, v0
v_lshlrev_b32_e32 v9, 4, v21
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_cmp_ne_u32_e64 s[6:7], 0, v4
v_add_co_u32_e32 v4, vcc, v2, v9
v_addc_co_u32_e32 v6, vcc, 0, v3, vcc
v_mad_i64_i32 v[2:3], s[16:17], s28, v8, 0
v_mov_b32_e32 v7, s9
v_add_co_u32_e32 v10, vcc, s8, v4
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_addc_co_u32_e32 v11, vcc, v7, v6, vcc
v_add_co_u32_e32 v2, vcc, v2, v9
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_add_co_u32_e32 v12, vcc, s8, v2
v_addc_co_u32_e32 v13, vcc, v7, v3, vcc
v_mad_i64_i32 v[2:3], s[8:9], s29, v8, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v0, 1, v0
v_add_co_u32_e32 v2, vcc, v2, v0
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_mov_b32_e32 v6, s11
v_add_co_u32_e32 v14, vcc, s10, v2
v_addc_co_u32_e32 v15, vcc, v6, v3, vcc
v_mad_i64_i32 v[2:3], s[8:9], v5, s29, 0
s_lshl_b32 s13, s28, 4
s_lshl_b32 s8, s29, 3
v_and_b32_e32 v4, 60, v21
s_add_i32 s8, s13, s8
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_add_u32_e32 v27, s8, v4
s_lshl_b32 s8, s29, 2
s_add_i32 s8, s13, s8
v_add_co_u32_e32 v0, vcc, v2, v0
v_add_u32_e32 v28, s8, v4
v_mad_u64_u32 v[18:19], s[8:9], s28, 12, v[9:10]
v_addc_co_u32_e32 v2, vcc, 0, v3, vcc
s_add_i32 s12, s13, s12
v_add_co_u32_e32 v16, vcc, s10, v0
v_cmp_gt_i32_e64 s[4:5], 1, v20
v_lshl_add_u32 v23, s28, 3, v9
v_add_u32_e32 v26, s12, v4
v_addc_co_u32_e32 v17, vcc, v6, v2, vcc
v_add_u32_e32 v29, s13, v4
v_mbcnt_hi_u32_b32 v30, -1, v1
v_lshl_add_u32 v31, s28, 2, v9
v_lshl_add_u32 v32, v21, 2, 4
v_mov_b32_e32 v33, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v25, 0
s_branch 38
s_or_b64 exec, exec, s[10:11]
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v3, v3
v_sub_u32_e32 v4, v51, v4
v_cvt_f32_i32_e32 v4, v4
v_sub_u32_e32 v2, v53, v2
v_cvt_f32_i32_e32 v2, v2
v_mul_f32_e32 v0, v0, v3
v_fmac_f32_e32 v25, v4, v0
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v0, v1, v3
v_fmac_f32_e32 v24, v0, v2
s_or_b64 exec, exec, s[8:9]
v_add_co_u32_e32 v10, vcc, 0x400, v10
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_add_co_u32_e32 v12, vcc, 0x400, v12
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
v_add_co_u32_e32 v14, vcc, 32, v14
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
s_addk_i32 s14, 0x100
v_add_co_u32_e32 v16, vcc, 32, v16
v_add_u32_e32 v23, 0x400, v23
v_add_u32_e32 v18, 0x400, v18
v_add_u32_e32 v9, 0x400, v9
v_add_u32_e32 v31, 0x400, v31
v_add_u32_e32 v26, 64, v26
v_add_u32_e32 v27, 64, v27
v_add_u32_e32 v28, 64, v28
v_add_u32_e32 v29, 64, v29
s_cmp_ge_i32 s14, s28
v_addc_co_u32_e32 v17, vcc, 0, v17, vcc
s_cbranch_scc1 342
v_add_u32_e32 v0, s14, v32
v_cmp_lt_i32_e32 vcc, s28, v0
v_cmp_ge_i32_e64 s[8:9], s28, v0
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 7
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execnz 126
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 183
s_branch 289
s_and_saveexec_b64 s[12:13], s[8:9]
s_xor_b64 s[8:9], exec, s[12:13]
s_cbranch_execz 81
global_load_dwordx4 v[0:3], v[12:13], off
s_and_saveexec_b64 s[12:13], s[2:3]
s_cbranch_execz 39
global_load_dwordx4 v[4:7], v[10:11], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v34, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v35, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v36, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v37, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v38, 0xf0f0f0f, v34
v_xor_b32_e32 v34, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v35
v_xor_b32_e32 v35, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v36
v_xor_b32_e32 v36, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v37
v_xor_b32_e32 v38, 0x8080808, v38
v_xor_b32_e32 v39, 0x8080808, v7
v_xor_b32_e32 v40, 0x8080808, v6
v_xor_b32_e32 v41, 0x8080808, v5
v_xor_b32_e32 v37, 0x8080808, v4
s_or_b64 exec, exec, s[12:13]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v44, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v48, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v45, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v50, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v47, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v52, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v46, 0x8080808, v4
v_xor_b32_e32 v49, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[8:9]
s_cbranch_execz 32
v_mov_b32_e32 v44, 0x8080808
v_cndmask_b32_e64 v34, v34, v44, s[2:3]
v_cndmask_b32_e64 v35, v35, v44, s[2:3]
v_cndmask_b32_e64 v36, v36, v44, s[2:3]
v_cndmask_b32_e64 v37, v37, v44, s[2:3]
v_cndmask_b32_e64 v38, v38, v44, s[2:3]
v_cndmask_b32_e64 v39, v39, v44, s[2:3]
v_cndmask_b32_e64 v40, v40, v44, s[2:3]
v_cndmask_b32_e64 v41, v41, v44, s[2:3]
v_mov_b32_e32 v45, 0x8080808
v_mov_b32_e32 v47, 0x8080808
v_mov_b32_e32 v49, 0x8080808
v_mov_b32_e32 v46, 0x8080808
v_mov_b32_e32 v48, 0x8080808
v_mov_b32_e32 v50, 0x8080808
v_mov_b32_e32 v52, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 65410
v_add_u32_e32 v0, 0, v9
v_add_u32_e32 v4, 0, v23
ds_read_b128 v[0:3], v0
ds_read_b128 v[4:7], v4
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v51, v46, v0, v33
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v54, v44, v4, v33
v_dot4_i32_i8 v55, v48, v1, v33
v_dot4_i32_i8 v56, v45, v5, v33
v_dot4_i32_i8 v57, v50, v2, v33
v_dot4_i32_i8 v58, v47, v6, v33
v_dot4_i32_i8 v59, v52, v3, v33
v_dot4_i32_i8 v60, v49, v7, v33
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v37, v0, v33
v_dot4_i32_i8 v4, v41, v4, v33
v_dot4_i32_i8 v1, v36, v1, v33
v_dot4_i32_i8 v5, v40, v5, v33
v_dot4_i32_i8 v2, v35, v2, v33
v_dot4_i32_i8 v6, v39, v6, v33
v_dot4_i32_i8 v3, v34, v3, v33
v_dot4_i32_i8 v7, v38, v7, v33
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v43, v0, v3, v7
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v54, v51
v_add3_u32 v0, v0, v55, v56
v_add3_u32 v0, v0, v57, v58
v_add3_u32 v51, v0, v59, v60
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 107
v_add_u32_e32 v0, 0, v31
v_add_u32_e32 v1, 0, v18
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v53, v46, v4, v33
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v54, v44, v0, v33
v_dot4_i32_i8 v55, v48, v5, v33
v_dot4_i32_i8 v56, v45, v1, v33
v_dot4_i32_i8 v57, v50, v6, v33
v_dot4_i32_i8 v58, v47, v2, v33
v_dot4_i32_i8 v59, v52, v7, v33
v_dot4_i32_i8 v60, v49, v3, v33
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v37, v4, v33
v_dot4_i32_i8 v0, v41, v0, v33
v_dot4_i32_i8 v5, v36, v5, v33
v_dot4_i32_i8 v1, v40, v1, v33
v_dot4_i32_i8 v6, v35, v6, v33
v_dot4_i32_i8 v2, v39, v2, v33
v_dot4_i32_i8 v7, v34, v7, v33
v_dot4_i32_i8 v3, v38, v3, v33
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v42, v0, v7, v3
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v54, v53
v_add3_u32 v0, v0, v55, v56
v_add3_u32 v0, v0, v57, v58
v_add3_u32 v2, v0, v59, v60
v_and_b32_e32 v0, 64, v30
v_and_b32_e32 v3, 63, v30
v_add_u32_e32 v1, 64, v0
v_xor_b32_e32 v0, 1, v3
v_cmp_lt_i32_e64 s[8:9], v0, v1
v_cndmask_b32_e64 v0, v30, v0, s[8:9]
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v4, v0, v51
ds_bpermute_b32 v6, v0, v2
v_xor_b32_e32 v3, 2, v3
v_cmp_lt_i32_e64 s[8:9], v3, v1
v_cndmask_b32_e64 v1, v30, v3, s[8:9]
v_lshlrev_b32_e32 v5, 2, v1
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v1, v4, v51
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v2, v6, v2
ds_bpermute_b32 v3, v5, v1
ds_bpermute_b32 v4, v5, v2
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 16
ds_bpermute_b32 v6, v0, v43
ds_bpermute_b32 v0, v0, v42
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v6, v6, v43
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v0, v42
ds_bpermute_b32 v7, v5, v6
ds_bpermute_b32 v5, v5, v0
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v43, v7, v6
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v42, v5, v0
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v51, v3, v1
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v53, v4, v2
s_or_b64 exec, exec, s[10:11]
s_or_b64 s[8:9], s[6:7], vcc
s_or_b64 s[8:9], s[8:9], s[4:5]
s_xor_b64 s[10:11], s[8:9], -1
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execz 65202
global_load_ushort v3, v[14:15], off
v_add_u32_e32 v0, 0, v29
v_add_u32_e32 v1, 0, v27
ds_read_b32 v0, v0
ds_read_b32 v2, v1
v_add_u32_e32 v1, 0, v28
v_add_u32_e32 v4, 0, v26
ds_read_b32 v5, v4
ds_read_b32 v1, v1
s_waitcnt lgkmcnt(2)
v_lshlrev_b32_e32 v4, 3, v2
s_waitcnt lgkmcnt(1)
v_lshlrev_b32_e32 v2, 3, v5
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 65170
global_load_ushort v5, v[16:17], off
v_sub_u32_e32 v6, v43, v4
v_sub_u32_e32 v7, v42, v2
v_cvt_f32_i32_e32 v6, v6
v_cvt_f32_i32_e32 v7, v7
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v5, v5
v_mul_f32_e32 v54, v0, v5
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v5, v1, v5
v_fmac_f32_e32 v19, v6, v54
v_fmac_f32_e32 v22, v7, v5
s_branch 65156
v_cmp_lt_i32_e32 vcc, 0, v20
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
ds_bpermute_b32 v4, v2, v25
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v25, v4
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
v_cmp_eq_u32_e32 vcc, 0, v21
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v10, v11
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v2, v24
s_ashr_i32 s21, s20, 31
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
v_cmp_lt_i32_e64 s[0:1], 1, v20
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 68
ds_bpermute_b32 v0, v2, v19
v_mov_b32_e32 v12, s23
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v19, v0
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
ds_bpermute_b32 v2, v2, v22
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v22, v2
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
