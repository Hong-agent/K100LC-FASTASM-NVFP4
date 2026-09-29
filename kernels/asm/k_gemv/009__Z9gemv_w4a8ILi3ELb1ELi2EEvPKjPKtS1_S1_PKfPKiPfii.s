.text
k__Z9gemv_w4a8ILi3ELb1ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 1186
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_load_dwordx2 s[22:23], s[4:5], 0x30
s_ashr_i32 s25, s21, 31
s_lshr_b32 s0, s25, 29
s_add_i32 s0, s21, s0
s_ashr_i32 s24, s0, 3
s_add_u32 s6, s4, 64
v_cmp_gt_i32_e32 vcc, s24, v0
s_addc_u32 s7, s5, 0
s_mul_i32 s35, s24, 12
v_lshlrev_b32_e32 v1, 2, v0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 44
s_load_dword s0, s[6:7], 0xc
s_mov_b32 s28, 0
v_add_u32_e32 v2, 0, v1
v_mov_b32_e32 v3, 0
s_mov_b64 s[26:27], 0
s_waitcnt lgkmcnt(0)
s_and_b32 s29, s0, 0xffff
s_lshl_b32 s30, s29, 2
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[2:3], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e64 v5, s[0:1], s14, v1
v_addc_co_u32_e64 v10, s[2:3], v6, v3, s[2:3]
v_addc_co_u32_e64 v6, s[0:1], v7, v3, s[0:1]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v6, s28
v_add_co_u32_e64 v1, s[0:1], s30, v1
v_add_u32_e32 v4, s29, v4
v_addc_co_u32_e64 v3, s[0:1], v3, v6, s[0:1]
v_cmp_le_i32_e64 s[0:1], s24, v4
v_add_u32_e32 v5, s35, v2
s_or_b64 s[26:27], s[0:1], s[26:27]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s30, v2
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[4:5]
s_lshr_b32 s0, s25, 25
s_add_i32 s0, s21, s0
s_ashr_i32 s26, s0, 7
v_cmp_gt_i32_e64 s[0:1], s26, v0
s_mul_i32 s34, s26, 12
s_mul_i32 s33, s24, 24
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 46
s_load_dword s2, s[6:7], 0xc
v_lshlrev_b32_e32 v1, 2, v0
s_add_i32 s3, s33, 0
s_mov_b32 s25, 0
v_add_u32_e32 v2, s3, v1
s_waitcnt lgkmcnt(0)
s_and_b32 s27, s2, 0xffff
s_lshl_b32 s36, s27, 2
v_mov_b32_e32 v3, 0
s_mov_b64 s[30:31], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v9, s[4:5], s16, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e64 v5, s[2:3], s18, v1
v_addc_co_u32_e64 v10, s[4:5], v6, v3, s[4:5]
v_addc_co_u32_e64 v6, s[2:3], v7, v3, s[2:3]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v6, s25
v_add_co_u32_e64 v1, s[2:3], s36, v1
v_add_u32_e32 v4, s27, v4
v_addc_co_u32_e64 v3, s[2:3], v3, v6, s[2:3]
v_cmp_le_i32_e64 s[2:3], s26, v4
v_add_u32_e32 v5, s34, v2
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s36, v2
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[28:29]
s_ashr_i32 s25, s24, 31
s_and_saveexec_b64 s[28:29], vcc
s_cbranch_execz 55
s_load_dword s2, s[6:7], 0xc
v_mov_b32_e32 v2, s25
s_mov_b32 s27, 0
v_lshlrev_b32_e32 v3, 2, v0
s_mov_b64 s[30:31], 0
s_waitcnt lgkmcnt(0)
s_and_b32 s36, s2, 0xffff
v_add_co_u32_e64 v1, s[2:3], s24, v0
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
s_lshl_b32 s2, s24, 4
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_add_i32 s38, s2, 0
s_lshl_b32 s2, s24, 2
s_lshl_b32 s37, s36, 2
s_add_i32 s39, s2, 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[4:5], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e64 v5, s[2:3], s14, v1
v_addc_co_u32_e64 v10, s[4:5], v6, v2, s[4:5]
v_addc_co_u32_e64 v6, s[2:3], v7, v2, s[2:3]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s27
v_add_co_u32_e64 v1, s[2:3], s37, v1
v_add_u32_e32 v4, s36, v4
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_cmp_le_i32_e64 s[2:3], s24, v4
v_add_u32_e32 v5, s39, v3
v_add_u32_e32 v6, s38, v3
v_add_u32_e32 v3, s37, v3
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_ashr_i32 s27, s26, 31
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 57
s_load_dword s2, s[6:7], 0xc
s_add_i32 s3, s35, 0
v_mov_b32_e32 v2, s27
s_add_i32 s35, s3, s35
v_lshlrev_b32_e32 v3, 2, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s37, s2, 0xffff
v_add_co_u32_e64 v1, s[2:3], s26, v0
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_mov_b32 s36, 0
s_lshl_b32 s38, s37, 2
v_lshl_add_u32 v3, s26, 4, v3
v_add_lshl_u32 v4, v0, s26, 2
s_mov_b64 s[30:31], 0
v_mov_b32_e32 v5, v0
v_mov_b32_e32 v7, s17
v_add_co_u32_e64 v9, s[4:5], s16, v1
v_mov_b32_e32 v11, s19
v_add_co_u32_e64 v6, s[2:3], s18, v1
v_addc_co_u32_e64 v10, s[4:5], v7, v2, s[4:5]
v_addc_co_u32_e64 v7, s[2:3], v11, v2, s[2:3]
global_load_dword v11, v[9:10], off
global_load_dword v12, v[6:7], off
v_mov_b32_e32 v9, s36
v_add_co_u32_e64 v1, s[2:3], s38, v1
v_add_u32_e32 v5, s37, v5
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_add_u32_e32 v6, s35, v4
v_add_u32_e32 v7, s35, v3
s_add_i32 s35, s35, s38
v_cmp_le_i32_e64 s[2:3], s26, v5
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v6, v11
s_waitcnt vmcnt(0)
ds_write_b32 v7, v12
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 46
s_load_dword s28, s[6:7], 0xc
s_lshl_b64 s[2:3], s[24:25], 3
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v2, s3
v_add_co_u32_e32 v1, vcc, s2, v3
s_waitcnt lgkmcnt(0)
s_and_b32 s30, s28, 0xffff
s_mov_b32 s25, 0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_lshl_b32 s31, s30, 2
s_mul_i32 s35, s24, 20
v_add_u32_e32 v3, 0, v3
s_lshl_b32 s36, s24, 3
s_mov_b64 s[28:29], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[2:3], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e32 v5, vcc, s14, v1
v_addc_co_u32_e64 v10, s[2:3], v6, v2, s[2:3]
v_addc_co_u32_e32 v6, vcc, v7, v2, vcc
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s25
v_add_co_u32_e32 v1, vcc, s31, v1
v_add_u32_e32 v4, s30, v4
v_addc_co_u32_e32 v2, vcc, v2, v9, vcc
v_cmp_le_i32_e32 vcc, s24, v4
v_add_u32_e32 v5, s36, v3
v_add_u32_e32 v6, s35, v3
v_add_u32_e32 v3, s31, v3
s_or_b64 s[28:29], vcc, s[28:29]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[28:29]
s_cbranch_execnz 65507
s_or_b64 exec, exec, s[4:5]
s_waitcnt lgkmcnt(0)
s_mul_i32 s12, s26, 20
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 46
s_load_dword s4, s[6:7], 0xc
s_lshl_b64 s[0:1], s[26:27], 3
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v1, vcc, s0, v3
s_waitcnt lgkmcnt(0)
s_and_b32 s7, s4, 0xffff
s_add_i32 s0, s33, 0
s_mov_b32 s6, 0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
s_lshl_b32 s13, s7, 2
v_add_u32_e32 v3, s0, v3
s_lshl_b32 s14, s26, 3
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v9, s[0:1], s16, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v5, vcc, s18, v1
v_addc_co_u32_e64 v10, s[0:1], v6, v2, s[0:1]
v_addc_co_u32_e32 v6, vcc, v7, v2, vcc
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s6
v_add_co_u32_e32 v1, vcc, s13, v1
v_add_u32_e32 v4, s7, v4
v_addc_co_u32_e32 v2, vcc, v2, v9, vcc
v_cmp_le_i32_e32 vcc, s26, v4
v_add_u32_e32 v5, s14, v3
v_add_u32_e32 v6, s12, v3
v_add_u32_e32 v3, s13, v3
s_or_b64 s[4:5], vcc, s[4:5]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65507
s_or_b64 exec, exec, s[2:3]
v_add_u32_e32 v1, 2, v8
v_sub_u32_e32 v2, s20, v8
v_cmp_lt_i32_e32 vcc, s20, v1
v_cndmask_b32_e32 v21, 2, v2, vcc
v_and_b32_e32 v24, 63, v0
s_mov_b32 s14, 0
s_cmp_gt_i32 s21, 7
v_mov_b32_e32 v28, 0
v_cmp_lt_i32_e64 s[0:1], 0, v21
v_cmp_lt_i32_e64 s[2:3], 1, v21
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v22, 0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc0 563
v_or_b32_e32 v4, 1, v8
v_mad_i64_i32 v[2:3], s[6:7], v4, s24, 0
v_and_b32_e32 v5, 3, v0
v_lshlrev_b32_e32 v9, 4, v24
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_cmp_ne_u32_e64 s[6:7], 0, v5
v_add_co_u32_e32 v5, vcc, v2, v9
v_addc_co_u32_e32 v6, vcc, 0, v3, vcc
v_mad_i64_i32 v[2:3], s[16:17], s24, v8, 0
v_mov_b32_e32 v7, s9
v_add_co_u32_e32 v10, vcc, s8, v5
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_addc_co_u32_e32 v11, vcc, v7, v6, vcc
v_add_co_u32_e32 v2, vcc, v2, v9
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_add_co_u32_e32 v12, vcc, s8, v2
v_addc_co_u32_e32 v13, vcc, v7, v3, vcc
v_mad_i64_i32 v[2:3], s[8:9], s26, v8, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v0, 1, v0
s_add_i32 s12, s33, s12
v_and_b32_e32 v5, 60, v24
s_lshl_b32 s8, s26, 4
v_add_co_u32_e32 v6, vcc, v2, v0
v_add_u32_e32 v27, s12, v5
s_add_i32 s12, s33, s8
v_addc_co_u32_e32 v7, vcc, 0, v3, vcc
v_mad_i64_i32 v[2:3], s[8:9], v4, s26, 0
s_add_i32 s8, s33, s34
v_add_u32_e32 v30, s8, v5
s_lshl_b32 s8, s26, 3
s_add_i32 s8, s33, s8
v_add_u32_e32 v31, s8, v5
s_lshl_b32 s8, s26, 2
v_mov_b32_e32 v17, s11
v_add_co_u32_e32 v14, vcc, s10, v6
v_lshlrev_b64 v[2:3], 1, v[2:3]
s_add_i32 s8, s33, s8
v_addc_co_u32_e32 v15, vcc, v17, v7, vcc
v_add_u32_e32 v32, s8, v5
v_mad_u64_u32 v[18:19], s[8:9], s24, 12, v[9:10]
v_add_co_u32_e32 v0, vcc, v2, v0
v_mad_u64_u32 v[19:20], s[8:9], s24, 20, v[9:10]
v_addc_co_u32_e32 v2, vcc, 0, v3, vcc
v_add_co_u32_e32 v16, vcc, s10, v0
v_cmp_gt_i32_e64 s[4:5], 1, v21
v_add_u32_e32 v29, s12, v5
v_addc_co_u32_e32 v17, vcc, v17, v2, vcc
v_add_u32_e32 v33, s33, v5
s_movk_i32 s15, 0x400
v_mbcnt_hi_u32_b32 v34, -1, v1
v_add_lshl_u32 v35, s24, v24, 4
v_lshl_add_u32 v36, s24, 3, v9
v_lshl_add_u32 v37, s24, 2, v9
v_lshl_add_u32 v38, v24, 2, 4
v_mov_b32_e32 v39, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v28, 0
s_branch 46
s_or_b64 exec, exec, s[10:11]
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v5, v5
v_sub_u32_e32 v6, v60, v6
v_cvt_f32_i32_e32 v6, v6
v_sub_u32_e32 v4, v59, v4
v_mul_f32_e32 v2, v2, v5
v_sub_u32_e32 v3, v61, v3
v_fmac_f32_e32 v28, v6, v2
v_cvt_f32_i32_e32 v2, v4
v_cvt_f32_i32_e32 v3, v3
v_mul_f32_e32 v0, v0, v5
v_fmac_f32_e32 v26, v2, v0
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v0, v1, v5
v_fmac_f32_e32 v20, v0, v3
s_or_b64 exec, exec, s[8:9]
v_add_co_u32_e32 v10, vcc, s15, v10
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_add_co_u32_e32 v12, vcc, s15, v12
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
v_add_co_u32_e32 v14, vcc, 32, v14
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
s_addk_i32 s14, 0x100
v_add_co_u32_e32 v16, vcc, 32, v16
v_add_u32_e32 v18, 0x400, v18
v_add_u32_e32 v19, 0x400, v19
v_add_u32_e32 v35, 0x400, v35
v_add_u32_e32 v9, 0x400, v9
v_add_u32_e32 v36, 0x400, v36
v_add_u32_e32 v37, 0x400, v37
v_add_u32_e32 v27, 64, v27
v_add_u32_e32 v29, 64, v29
v_add_u32_e32 v30, 64, v30
v_add_u32_e32 v31, 64, v31
v_add_u32_e32 v32, 64, v32
v_add_u32_e32 v33, 64, v33
s_cmp_ge_i32 s14, s24
v_addc_co_u32_e32 v17, vcc, 0, v17, vcc
s_cbranch_scc1 433
v_add_u32_e32 v0, s14, v38
v_cmp_lt_i32_e32 vcc, s24, v0
v_cmp_ge_i32_e64 s[8:9], s24, v0
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 10
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execnz 129
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execnz 186
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execnz 243
s_branch 365
s_and_saveexec_b64 s[12:13], s[8:9]
s_xor_b64 s[8:9], exec, s[12:13]
s_cbranch_execz 81
global_load_dwordx4 v[0:3], v[12:13], off
s_and_saveexec_b64 s[12:13], s[2:3]
s_cbranch_execz 39
global_load_dwordx4 v[4:7], v[10:11], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v40, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v41, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v42, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v43, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v44, 0xf0f0f0f, v40
v_xor_b32_e32 v40, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v41
v_xor_b32_e32 v41, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v42
v_xor_b32_e32 v42, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v43
v_xor_b32_e32 v44, 0x8080808, v44
v_xor_b32_e32 v45, 0x8080808, v7
v_xor_b32_e32 v46, 0x8080808, v6
v_xor_b32_e32 v47, 0x8080808, v5
v_xor_b32_e32 v43, 0x8080808, v4
s_or_b64 exec, exec, s[12:13]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v51, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v55, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v52, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v57, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v54, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v58, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v53, 0x8080808, v4
v_xor_b32_e32 v56, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[8:9]
s_cbranch_execz 32
v_mov_b32_e32 v51, 0x8080808
v_cndmask_b32_e64 v40, v40, v51, s[2:3]
v_cndmask_b32_e64 v41, v41, v51, s[2:3]
v_cndmask_b32_e64 v42, v42, v51, s[2:3]
v_cndmask_b32_e64 v43, v43, v51, s[2:3]
v_cndmask_b32_e64 v44, v44, v51, s[2:3]
v_cndmask_b32_e64 v45, v45, v51, s[2:3]
v_cndmask_b32_e64 v46, v46, v51, s[2:3]
v_cndmask_b32_e64 v47, v47, v51, s[2:3]
v_mov_b32_e32 v52, 0x8080808
v_mov_b32_e32 v54, 0x8080808
v_mov_b32_e32 v56, 0x8080808
v_mov_b32_e32 v53, 0x8080808
v_mov_b32_e32 v55, 0x8080808
v_mov_b32_e32 v57, 0x8080808
v_mov_b32_e32 v58, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 65407
v_add_u32_e32 v0, 0, v9
v_add_u32_e32 v4, 0, v18
ds_read_b128 v[0:3], v0
ds_read_b128 v[4:7], v4
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v60, v53, v0, v39
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v62, v51, v4, v39
v_dot4_i32_i8 v63, v55, v1, v39
v_dot4_i32_i8 v64, v52, v5, v39
v_dot4_i32_i8 v65, v57, v2, v39
v_dot4_i32_i8 v66, v54, v6, v39
v_dot4_i32_i8 v67, v58, v3, v39
v_dot4_i32_i8 v68, v56, v7, v39
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v43, v0, v39
v_dot4_i32_i8 v4, v47, v4, v39
v_dot4_i32_i8 v1, v42, v1, v39
v_dot4_i32_i8 v5, v46, v5, v39
v_dot4_i32_i8 v2, v41, v2, v39
v_dot4_i32_i8 v6, v45, v6, v39
v_dot4_i32_i8 v3, v40, v3, v39
v_dot4_i32_i8 v7, v44, v7, v39
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v50, v0, v3, v7
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v62, v60
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v0, v0, v65, v66
v_add3_u32 v60, v0, v67, v68
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 65350
v_add_u32_e32 v0, 0, v37
v_add_u32_e32 v1, 0, v35
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v59, v53, v4, v39
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v62, v51, v0, v39
v_dot4_i32_i8 v63, v55, v5, v39
v_dot4_i32_i8 v64, v52, v1, v39
v_dot4_i32_i8 v65, v57, v6, v39
v_dot4_i32_i8 v66, v54, v2, v39
v_dot4_i32_i8 v67, v58, v7, v39
v_dot4_i32_i8 v68, v56, v3, v39
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v43, v4, v39
v_dot4_i32_i8 v0, v47, v0, v39
v_dot4_i32_i8 v5, v42, v5, v39
v_dot4_i32_i8 v1, v46, v1, v39
v_dot4_i32_i8 v6, v41, v6, v39
v_dot4_i32_i8 v2, v45, v2, v39
v_dot4_i32_i8 v7, v40, v7, v39
v_dot4_i32_i8 v3, v44, v3, v39
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v49, v0, v7, v3
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v62, v59
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v0, v0, v65, v66
v_add3_u32 v59, v0, v67, v68
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 123
v_add_u32_e32 v0, 0, v36
v_add_u32_e32 v1, 0, v19
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v61, v53, v4, v39
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v62, v51, v0, v39
v_dot4_i32_i8 v63, v55, v5, v39
v_dot4_i32_i8 v64, v52, v1, v39
v_dot4_i32_i8 v65, v57, v6, v39
v_dot4_i32_i8 v66, v54, v2, v39
v_dot4_i32_i8 v67, v58, v7, v39
v_dot4_i32_i8 v68, v56, v3, v39
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v43, v4, v39
v_dot4_i32_i8 v0, v47, v0, v39
v_dot4_i32_i8 v5, v42, v5, v39
v_dot4_i32_i8 v1, v46, v1, v39
v_dot4_i32_i8 v6, v41, v6, v39
v_dot4_i32_i8 v2, v45, v2, v39
v_dot4_i32_i8 v7, v40, v7, v39
v_dot4_i32_i8 v3, v44, v3, v39
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v48, v0, v7, v3
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v62, v61
v_add3_u32 v0, v0, v63, v64
v_add3_u32 v0, v0, v65, v66
v_add3_u32 v1, v0, v67, v68
v_and_b32_e32 v0, 64, v34
v_and_b32_e32 v2, 63, v34
v_add_u32_e32 v0, 64, v0
v_xor_b32_e32 v3, 1, v2
v_cmp_lt_i32_e64 s[8:9], v3, v0
v_cndmask_b32_e64 v3, v34, v3, s[8:9]
v_lshlrev_b32_e32 v6, 2, v3
ds_bpermute_b32 v3, v6, v60
ds_bpermute_b32 v4, v6, v59
ds_bpermute_b32 v5, v6, v1
v_xor_b32_e32 v2, 2, v2
v_cmp_lt_i32_e64 s[8:9], v2, v0
v_cndmask_b32_e64 v0, v34, v2, s[8:9]
v_lshlrev_b32_e32 v7, 2, v0
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v2, v3, v60
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v0, v4, v59
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v1, v5, v1
ds_bpermute_b32 v3, v7, v2
ds_bpermute_b32 v4, v7, v0
ds_bpermute_b32 v5, v7, v1
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 24
ds_bpermute_b32 v59, v6, v50
ds_bpermute_b32 v60, v6, v49
ds_bpermute_b32 v6, v6, v48
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v50, v59, v50
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v49, v60, v49
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v6, v6, v48
ds_bpermute_b32 v48, v7, v50
ds_bpermute_b32 v59, v7, v49
ds_bpermute_b32 v7, v7, v6
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v50, v48, v50
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v49, v59, v49
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v48, v7, v6
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v60, v3, v2
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v59, v4, v0
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v61, v5, v1
s_or_b64 exec, exec, s[10:11]
s_or_b64 s[8:9], s[6:7], vcc
s_or_b64 s[8:9], s[8:9], s[4:5]
s_xor_b64 s[10:11], s[8:9], -1
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execz 65119
global_load_ushort v5, v[14:15], off
v_add_u32_e32 v0, 0, v33
v_add_u32_e32 v1, 0, v30
v_add_u32_e32 v3, 0, v32
v_add_u32_e32 v4, 0, v29
ds_read_b32 v2, v0
ds_read_b32 v6, v1
ds_read_b32 v0, v3
ds_read_b32 v3, v4
v_add_u32_e32 v1, 0, v31
v_add_u32_e32 v4, 0, v27
ds_read_b32 v7, v4
ds_read_b32 v1, v1
s_waitcnt lgkmcnt(4)
v_lshlrev_b32_e32 v6, 3, v6
s_waitcnt lgkmcnt(2)
v_lshlrev_b32_e32 v4, 3, v3
s_waitcnt lgkmcnt(1)
v_lshlrev_b32_e32 v3, 3, v7
s_and_saveexec_b64 s[10:11], s[2:3]
s_cbranch_execz 65075
global_load_ushort v7, v[16:17], off
v_sub_u32_e32 v62, v50, v6
v_sub_u32_e32 v63, v49, v4
v_sub_u32_e32 v64, v48, v3
v_cvt_f32_i32_e32 v62, v62
v_cvt_f32_i32_e32 v63, v63
v_cvt_f32_i32_e32 v64, v64
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v7, v7
v_mul_f32_e32 v65, v2, v7
v_mul_f32_e32 v66, v0, v7
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v7, v1, v7
v_fmac_f32_e32 v25, v62, v65
v_fmac_f32_e32 v23, v63, v66
v_fmac_f32_e32 v22, v64, v7
s_branch 65057
v_cmp_lt_i32_e32 vcc, 0, v21
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
ds_bpermute_b32 v4, v2, v28
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v28, v4
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
v_cmp_eq_u32_e32 vcc, 0, v24
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v10, v11
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v2, v26
s_ashr_i32 s21, s20, 31
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
ds_bpermute_b32 v0, v2, v20
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v20, v0
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
v_cmp_lt_i32_e64 s[0:1], 1, v21
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 102
ds_bpermute_b32 v0, v2, v25
v_mov_b32_e32 v12, s23
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
ds_bpermute_b32 v8, v2, v23
s_lshl_b64 s[2:3], s[20:21], 2
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v23, v8
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
s_cbranch_execz 7
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
global_store_dword v[0:1], v2, off offset:4
s_endpgm
