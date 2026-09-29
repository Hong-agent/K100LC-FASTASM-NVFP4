.text
k__Z9gemv_w4a8ILi4ELb1ELi2EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[20:21], s[4:5], 0x38
s_lshl_b32 s0, s6, 3
v_lshrrev_b32_e32 v1, 5, v0
v_and_or_b32 v8, v1, 6, s0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s20, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 1509
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
v_lshlrev_b32_e32 v1, 2, v0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 45
s_load_dword s0, s[6:7], 0xc
s_lshl_b32 s28, s24, 4
s_mov_b32 s29, 0
v_add_u32_e32 v2, 0, v1
v_mov_b32_e32 v3, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s30, s0, 0xffff
s_lshl_b32 s31, s30, 2
s_mov_b64 s[26:27], 0
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
v_cmp_le_i32_e64 s[0:1], s24, v4
v_add_u32_e32 v5, s28, v2
s_or_b64 s[26:27], s[0:1], s[26:27]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s31, v2
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[4:5]
s_lshr_b32 s0, s25, 25
s_add_i32 s0, s21, s0
s_ashr_i32 s26, s0, 7
v_cmp_gt_i32_e64 s[0:1], s26, v0
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 48
s_load_dword s2, s[6:7], 0xc
s_lshl_b32 s3, s24, 5
v_lshlrev_b32_e32 v1, 2, v0
s_lshl_b32 s25, s26, 4
s_mov_b32 s27, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s33, s2, 0xffff
s_add_i32 s2, s3, 0
v_add_u32_e32 v2, s2, v1
s_lshl_b32 s34, s33, 2
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
v_mov_b32_e32 v6, s27
v_add_co_u32_e64 v1, s[2:3], s34, v1
v_add_u32_e32 v4, s33, v4
v_addc_co_u32_e64 v3, s[2:3], v3, v6, s[2:3]
v_cmp_le_i32_e64 s[2:3], s26, v4
v_add_u32_e32 v5, s25, v2
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v2, v7
s_waitcnt vmcnt(0)
ds_write_b32 v5, v11
v_add_u32_e32 v2, s34, v2
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65503
s_or_b64 exec, exec, s[28:29]
s_ashr_i32 s25, s24, 31
s_lshl_b32 s33, s24, 2
s_and_saveexec_b64 s[28:29], vcc
s_cbranch_execz 54
s_load_dword s2, s[6:7], 0xc
v_mov_b32_e32 v2, s25
s_mov_b32 s27, 0
v_lshlrev_b32_e32 v3, 2, v0
s_add_i32 s37, s33, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s34, s2, 0xffff
v_add_co_u32_e64 v1, s[2:3], s24, v0
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_mul_i32 s2, s24, 20
s_lshl_b32 s35, s34, 2
s_add_i32 s36, s2, 0
s_mov_b64 s[30:31], 0
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
v_add_co_u32_e64 v1, s[2:3], s35, v1
v_add_u32_e32 v4, s34, v4
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_cmp_le_i32_e64 s[2:3], s24, v4
v_add_u32_e32 v5, s37, v3
v_add_u32_e32 v6, s36, v3
v_add_u32_e32 v3, s35, v3
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_ashr_i32 s27, s26, 31
s_mul_i32 s34, s26, 20
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 57
s_load_dword s2, s[6:7], 0xc
s_lshl_b32 s3, s33, 2
s_add_i32 s4, s3, 0
s_add_i32 s36, s4, s3
v_mov_b32_e32 v2, s27
s_waitcnt lgkmcnt(0)
s_and_b32 s37, s2, 0xffff
v_add_co_u32_e64 v1, s[2:3], s26, v0
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_mov_b32 s35, 0
s_lshl_b32 s38, s37, 2
v_lshl_add_u32 v3, v0, 2, s34
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
v_mov_b32_e32 v9, s35
v_add_co_u32_e64 v1, s[2:3], s38, v1
v_add_u32_e32 v5, s37, v5
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_add_u32_e32 v6, s36, v4
v_add_u32_e32 v7, s36, v3
s_add_i32 s36, s36, s38
v_cmp_le_i32_e64 s[2:3], s26, v5
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v6, v11
s_waitcnt vmcnt(0)
ds_write_b32 v7, v12
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_and_saveexec_b64 s[28:29], vcc
s_cbranch_execz 53
s_load_dword s4, s[6:7], 0xc
s_lshl_b64 s[2:3], s[24:25], 3
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v2, s3
v_add_co_u32_e64 v1, s[2:3], s2, v3
s_waitcnt lgkmcnt(0)
s_and_b32 s35, s4, 0xffff
s_mov_b32 s25, 0
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
s_lshl_b32 s36, s35, 2
s_mul_i32 s37, s24, 24
v_add_u32_e32 v3, 0, v3
s_lshl_b32 s38, s24, 3
s_mov_b64 s[30:31], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s13
v_add_co_u32_e64 v9, s[4:5], s12, v1
v_mov_b32_e32 v7, s15
v_add_co_u32_e64 v5, s[2:3], s14, v1
v_addc_co_u32_e64 v10, s[4:5], v6, v2, s[4:5]
v_addc_co_u32_e64 v6, s[2:3], v7, v2, s[2:3]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s25
v_add_co_u32_e64 v1, s[2:3], s36, v1
v_add_u32_e32 v4, s35, v4
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_cmp_le_i32_e64 s[2:3], s24, v4
v_add_u32_e32 v5, s38, v3
v_add_u32_e32 v6, s37, v3
v_add_u32_e32 v3, s36, v3
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_mul_i32 s25, s26, 24
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 54
s_load_dword s4, s[6:7], 0xc
s_lshl_b64 s[2:3], s[26:27], 3
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v2, s3
v_add_co_u32_e64 v1, s[2:3], s2, v3
v_addc_co_u32_e64 v2, s[2:3], 0, v2, s[2:3]
s_lshl_b32 s2, s24, 5
s_waitcnt lgkmcnt(0)
s_and_b32 s35, s4, 0xffff
s_add_i32 s2, s2, 0
s_mov_b32 s27, 0
s_lshl_b32 s36, s35, 2
v_add_u32_e32 v3, s2, v3
s_lshl_b32 s37, s26, 3
s_mov_b64 s[30:31], 0
v_mov_b32_e32 v4, v0
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v9, s[4:5], s16, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e64 v5, s[2:3], s18, v1
v_addc_co_u32_e64 v10, s[4:5], v6, v2, s[4:5]
v_addc_co_u32_e64 v6, s[2:3], v7, v2, s[2:3]
global_load_dword v7, v[9:10], off
global_load_dword v11, v[5:6], off
v_mov_b32_e32 v9, s27
v_add_co_u32_e64 v1, s[2:3], s36, v1
v_add_u32_e32 v4, s35, v4
v_addc_co_u32_e64 v2, s[2:3], v2, v9, s[2:3]
v_cmp_le_i32_e64 s[2:3], s26, v4
v_add_u32_e32 v5, s37, v3
v_add_u32_e32 v6, s25, v3
v_add_u32_e32 v3, s36, v3
s_or_b64 s[30:31], s[2:3], s[30:31]
s_waitcnt vmcnt(1)
ds_write_b32 v5, v7
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
s_andn2_b64 exec, exec, s[30:31]
s_cbranch_execnz 65502
s_or_b64 exec, exec, s[28:29]
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 45
s_load_dword s2, s[6:7], 0xc
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v4, 0
s_mov_b32 s27, 0
s_mul_i32 s35, s24, 28
s_waitcnt lgkmcnt(0)
s_and_b32 s30, s2, 0xffff
v_mad_i64_i32 v[1:2], s[2:3], s24, 12, v[3:4]
s_lshl_b32 s31, s30, 2
v_add_u32_e32 v3, 0, v3
s_mul_i32 s36, s24, 12
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
v_mov_b32_e32 v9, s27
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
s_mul_i32 s13, s26, 28
s_mul_i32 s12, s26, 12
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 45
s_load_dword s0, s[6:7], 0xc
v_lshlrev_b32_e32 v3, 2, v0
v_mov_b32_e32 v4, 0
s_mov_b32 s6, 0
s_mov_b64 s[4:5], 0
s_waitcnt lgkmcnt(0)
s_and_b32 s7, s0, 0xffff
v_mad_i64_i32 v[1:2], s[0:1], s26, 12, v[3:4]
s_lshl_b32 s0, s24, 5
s_add_i32 s0, s0, 0
s_lshl_b32 s14, s7, 2
v_add_u32_e32 v3, s0, v3
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
v_add_co_u32_e32 v1, vcc, s14, v1
v_add_u32_e32 v4, s7, v4
v_addc_co_u32_e32 v2, vcc, v2, v9, vcc
v_cmp_le_i32_e32 vcc, s26, v4
v_add_u32_e32 v5, s12, v3
v_add_u32_e32 v6, s13, v3
v_add_u32_e32 v3, s14, v3
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
v_cndmask_b32_e32 v23, 2, v2, vcc
v_and_b32_e32 v27, 63, v0
s_mov_b32 s14, 0
s_cmp_gt_i32 s21, 7
v_mov_b32_e32 v33, 0
v_cmp_lt_i32_e32 vcc, 0, v23
v_cmp_lt_i32_e64 s[0:1], 1, v23
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v28, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v24, 0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc0 699
v_or_b32_e32 v4, 1, v8
v_mad_i64_i32 v[2:3], s[4:5], v4, s24, 0
v_and_b32_e32 v5, 3, v0
v_lshlrev_b32_e32 v9, 4, v27
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_cmp_ne_u32_e64 s[4:5], 0, v5
v_add_co_u32_e64 v5, s[6:7], v2, v9
v_addc_co_u32_e64 v6, s[6:7], 0, v3, s[6:7]
v_mad_i64_i32 v[2:3], s[6:7], s24, v8, 0
v_mov_b32_e32 v7, s9
v_add_co_u32_e64 v10, s[6:7], s8, v5
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_addc_co_u32_e64 v11, s[6:7], v7, v6, s[6:7]
v_add_co_u32_e64 v2, s[6:7], v2, v9
v_addc_co_u32_e64 v3, s[6:7], 0, v3, s[6:7]
v_add_co_u32_e64 v12, s[6:7], s8, v2
v_addc_co_u32_e64 v13, s[6:7], v7, v3, s[6:7]
v_mad_i64_i32 v[2:3], s[6:7], s26, v8, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v0, 1, v0
v_add_co_u32_e64 v6, s[6:7], v2, v0
v_addc_co_u32_e64 v7, s[6:7], 0, v3, s[6:7]
v_mad_i64_i32 v[2:3], s[6:7], v4, s26, 0
v_mov_b32_e32 v17, s11
v_add_co_u32_e64 v14, s[6:7], s10, v6
v_lshlrev_b64 v[2:3], 1, v[2:3]
v_addc_co_u32_e64 v15, s[6:7], v17, v7, s[6:7]
v_add_co_u32_e64 v0, s[6:7], v2, v0
v_addc_co_u32_e64 v2, s[6:7], 0, v3, s[6:7]
v_add_co_u32_e64 v16, s[6:7], s10, v0
v_addc_co_u32_e64 v17, s[6:7], v17, v2, s[6:7]
s_lshl_b32 s8, s24, 5
s_lshl_b32 s6, s26, 4
v_and_b32_e32 v5, 60, v27
s_add_i32 s6, s8, s6
s_lshl_b32 s7, s26, 3
v_add_u32_e32 v35, s6, v5
s_add_i32 s6, s8, s12
s_add_i32 s7, s8, s7
v_add_u32_e32 v36, s6, v5
v_add_u32_e32 v37, s7, v5
v_mad_u64_u32 v[18:19], s[6:7], s24, 24, v[9:10]
v_mad_u64_u32 v[19:20], s[6:7], s24, 28, v[9:10]
s_add_i32 s9, s8, s13
v_mad_u64_u32 v[20:21], s[6:7], s24, 20, v[9:10]
v_add_u32_e32 v31, s9, v5
s_add_i32 s9, s8, s25
v_mad_u64_u32 v[21:22], s[6:7], s24, 12, v[9:10]
s_lshl_b32 s15, s26, 2
v_add_u32_e32 v32, s9, v5
s_add_i32 s9, s8, s34
v_add_u32_e32 v34, s9, v5
s_add_i32 s9, s8, s15
v_cmp_gt_i32_e64 s[2:3], 1, v23
v_add_u32_e32 v38, s9, v5
v_add_u32_e32 v39, s8, v5
s_movk_i32 s15, 0x400
v_mbcnt_hi_u32_b32 v40, -1, v1
v_lshl_add_u32 v41, s24, 4, v9
v_lshl_add_u32 v42, s24, 3, v9
v_add_u32_e32 v43, s33, v9
v_lshl_add_u32 v44, v27, 2, 4
v_mov_b32_e32 v45, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v28, 0
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v33, 0
s_branch 64
s_or_b64 exec, exec, s[8:9]
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v6, v6
v_sub_u32_e32 v70, v68, v70
v_cvt_f32_i32_e32 v70, v70
v_sub_u32_e32 v7, v67, v7
v_cvt_f32_i32_e32 v7, v7
v_mul_f32_e32 v3, v3, v6
v_fmac_f32_e32 v33, v70, v3
v_mul_f32_e32 v3, v4, v6
v_fmac_f32_e32 v30, v7, v3
v_sub_u32_e32 v3, v66, v5
v_cvt_f32_i32_e32 v3, v3
v_sub_u32_e32 v2, v69, v2
v_cvt_f32_i32_e32 v2, v2
v_mul_f32_e32 v0, v0, v6
v_fmac_f32_e32 v22, v3, v0
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v0, v1, v6
v_fmac_f32_e32 v29, v0, v2
s_or_b64 exec, exec, s[6:7]
v_add_co_u32_e64 v10, s[6:7], s15, v10
v_addc_co_u32_e64 v11, s[6:7], 0, v11, s[6:7]
v_add_co_u32_e64 v12, s[6:7], s15, v12
v_addc_co_u32_e64 v13, s[6:7], 0, v13, s[6:7]
v_add_co_u32_e64 v14, s[6:7], 32, v14
v_addc_co_u32_e64 v15, s[6:7], 0, v15, s[6:7]
s_addk_i32 s14, 0x100
v_add_co_u32_e64 v16, s[6:7], 32, v16
v_add_u32_e32 v41, 0x400, v41
v_add_u32_e32 v18, 0x400, v18
v_add_u32_e32 v19, 0x400, v19
v_add_u32_e32 v20, 0x400, v20
v_add_u32_e32 v9, 0x400, v9
v_add_u32_e32 v42, 0x400, v42
v_add_u32_e32 v21, 0x400, v21
v_add_u32_e32 v43, 0x400, v43
v_add_u32_e32 v31, 64, v31
v_add_u32_e32 v32, 64, v32
v_add_u32_e32 v34, 64, v34
v_add_u32_e32 v35, 64, v35
v_add_u32_e32 v36, 64, v36
v_add_u32_e32 v37, 64, v37
v_add_u32_e32 v38, 64, v38
v_add_u32_e32 v39, 64, v39
s_cmp_ge_i32 s14, s24
v_addc_co_u32_e64 v17, s[6:7], 0, v17, s[6:7]
s_cbranch_scc1 525
v_add_u32_e32 v0, s14, v44
v_cmp_lt_i32_e64 s[6:7], s24, v0
v_cmp_ge_i32_e64 s[8:9], s24, v0
s_and_saveexec_b64 s[10:11], vcc
s_cbranch_execnz 13
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execnz 132
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execnz 189
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execnz 246
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], vcc
s_cbranch_execnz 303
s_branch 441
s_and_saveexec_b64 s[12:13], s[8:9]
s_xor_b64 s[8:9], exec, s[12:13]
s_cbranch_execz 81
global_load_dwordx4 v[0:3], v[12:13], off
s_and_saveexec_b64 s[12:13], s[0:1]
s_cbranch_execz 39
global_load_dwordx4 v[4:7], v[10:11], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v46, 4, v7
v_and_b32_e32 v7, 0xf0f0f0f, v7
v_lshrrev_b32_e32 v47, 4, v6
v_and_b32_e32 v6, 0xf0f0f0f, v6
v_lshrrev_b32_e32 v48, 4, v5
v_and_b32_e32 v5, 0xf0f0f0f, v5
v_lshrrev_b32_e32 v49, 4, v4
v_and_b32_e32 v4, 0xf0f0f0f, v4
v_and_b32_e32 v50, 0xf0f0f0f, v46
v_xor_b32_e32 v46, 0x8080808, v7
v_and_b32_e32 v7, 0xf0f0f0f, v47
v_xor_b32_e32 v47, 0x8080808, v6
v_and_b32_e32 v6, 0xf0f0f0f, v48
v_xor_b32_e32 v48, 0x8080808, v5
v_and_b32_e32 v5, 0xf0f0f0f, v49
v_xor_b32_e32 v50, 0x8080808, v50
v_xor_b32_e32 v51, 0x8080808, v7
v_xor_b32_e32 v52, 0x8080808, v6
v_xor_b32_e32 v53, 0x8080808, v5
v_xor_b32_e32 v49, 0x8080808, v4
s_or_b64 exec, exec, s[12:13]
s_waitcnt vmcnt(0)
v_and_b32_e32 v4, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v58, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v62, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v59, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v64, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v61, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v3
v_xor_b32_e32 v65, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v60, 0x8080808, v4
v_xor_b32_e32 v63, 0x8080808, v0
s_andn2_saveexec_b64 s[8:9], s[8:9]
s_cbranch_execz 32
v_mov_b32_e32 v58, 0x8080808
v_cndmask_b32_e64 v46, v46, v58, s[0:1]
v_cndmask_b32_e64 v47, v47, v58, s[0:1]
v_cndmask_b32_e64 v48, v48, v58, s[0:1]
v_cndmask_b32_e64 v49, v49, v58, s[0:1]
v_cndmask_b32_e64 v50, v50, v58, s[0:1]
v_cndmask_b32_e64 v51, v51, v58, s[0:1]
v_cndmask_b32_e64 v52, v52, v58, s[0:1]
v_cndmask_b32_e64 v53, v53, v58, s[0:1]
v_mov_b32_e32 v59, 0x8080808
v_mov_b32_e32 v61, 0x8080808
v_mov_b32_e32 v63, 0x8080808
v_mov_b32_e32 v60, 0x8080808
v_mov_b32_e32 v62, 0x8080808
v_mov_b32_e32 v64, 0x8080808
v_mov_b32_e32 v65, 0x8080808
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[10:11]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 65404
v_add_u32_e32 v0, 0, v9
v_add_u32_e32 v4, 0, v41
ds_read_b128 v[0:3], v0
ds_read_b128 v[4:7], v4
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v68, v60, v0, v45
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v70, v58, v4, v45
v_dot4_i32_i8 v71, v62, v1, v45
v_dot4_i32_i8 v72, v59, v5, v45
v_dot4_i32_i8 v73, v64, v2, v45
v_dot4_i32_i8 v74, v61, v6, v45
v_dot4_i32_i8 v75, v65, v3, v45
v_dot4_i32_i8 v76, v63, v7, v45
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 23
v_dot4_i32_i8 v0, v49, v0, v45
v_dot4_i32_i8 v4, v53, v4, v45
v_dot4_i32_i8 v1, v48, v1, v45
v_dot4_i32_i8 v5, v52, v5, v45
v_dot4_i32_i8 v2, v47, v2, v45
v_dot4_i32_i8 v6, v51, v6, v45
v_dot4_i32_i8 v3, v46, v3, v45
v_dot4_i32_i8 v7, v50, v7, v45
v_add_u32_e32 v0, v4, v0
v_add3_u32 v0, v0, v1, v5
v_add3_u32 v0, v0, v2, v6
v_add3_u32 v57, v0, v3, v7
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v70, v68
v_add3_u32 v0, v0, v71, v72
v_add3_u32 v0, v0, v73, v74
v_add3_u32 v68, v0, v75, v76
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 65347
v_add_u32_e32 v0, 0, v43
v_add_u32_e32 v1, 0, v20
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v67, v60, v4, v45
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v70, v58, v0, v45
v_dot4_i32_i8 v71, v62, v5, v45
v_dot4_i32_i8 v72, v59, v1, v45
v_dot4_i32_i8 v73, v64, v6, v45
v_dot4_i32_i8 v74, v61, v2, v45
v_dot4_i32_i8 v75, v65, v7, v45
v_dot4_i32_i8 v76, v63, v3, v45
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v49, v4, v45
v_dot4_i32_i8 v0, v53, v0, v45
v_dot4_i32_i8 v5, v48, v5, v45
v_dot4_i32_i8 v1, v52, v1, v45
v_dot4_i32_i8 v6, v47, v6, v45
v_dot4_i32_i8 v2, v51, v2, v45
v_dot4_i32_i8 v7, v46, v7, v45
v_dot4_i32_i8 v3, v50, v3, v45
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v56, v0, v7, v3
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v70, v67
v_add3_u32 v0, v0, v71, v72
v_add3_u32 v0, v0, v73, v74
v_add3_u32 v67, v0, v75, v76
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 65290
v_add_u32_e32 v0, 0, v42
v_add_u32_e32 v1, 0, v18
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v66, v60, v4, v45
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v70, v58, v0, v45
v_dot4_i32_i8 v71, v62, v5, v45
v_dot4_i32_i8 v72, v59, v1, v45
v_dot4_i32_i8 v73, v64, v6, v45
v_dot4_i32_i8 v74, v61, v2, v45
v_dot4_i32_i8 v75, v65, v7, v45
v_dot4_i32_i8 v76, v63, v3, v45
s_and_saveexec_b64 s[10:11], s[0:1]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v49, v4, v45
v_dot4_i32_i8 v0, v53, v0, v45
v_dot4_i32_i8 v5, v48, v5, v45
v_dot4_i32_i8 v1, v52, v1, v45
v_dot4_i32_i8 v6, v47, v6, v45
v_dot4_i32_i8 v2, v51, v2, v45
v_dot4_i32_i8 v7, v46, v7, v45
v_dot4_i32_i8 v3, v50, v3, v45
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v55, v0, v7, v3
s_or_b64 exec, exec, s[10:11]
v_add_u32_e32 v0, v70, v66
v_add3_u32 v0, v0, v71, v72
v_add3_u32 v0, v0, v73, v74
v_add3_u32 v66, v0, v75, v76
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[10:11], vcc
s_cbranch_execz 139
v_add_u32_e32 v0, 0, v21
v_add_u32_e32 v1, 0, v19
ds_read_b128 v[4:7], v0
ds_read_b128 v[0:3], v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v69, v60, v4, v45
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v70, v58, v0, v45
v_dot4_i32_i8 v71, v62, v5, v45
v_dot4_i32_i8 v72, v59, v1, v45
v_dot4_i32_i8 v73, v64, v6, v45
v_dot4_i32_i8 v74, v61, v2, v45
v_dot4_i32_i8 v75, v65, v7, v45
v_dot4_i32_i8 v76, v63, v3, v45
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 23
v_dot4_i32_i8 v4, v49, v4, v45
v_dot4_i32_i8 v0, v53, v0, v45
v_dot4_i32_i8 v5, v48, v5, v45
v_dot4_i32_i8 v1, v52, v1, v45
v_dot4_i32_i8 v6, v47, v6, v45
v_dot4_i32_i8 v2, v51, v2, v45
v_dot4_i32_i8 v7, v46, v7, v45
v_dot4_i32_i8 v3, v50, v3, v45
v_add_u32_e32 v0, v0, v4
v_add3_u32 v0, v0, v5, v1
v_add3_u32 v0, v0, v6, v2
v_add3_u32 v54, v0, v7, v3
s_or_b64 exec, exec, s[8:9]
v_add_u32_e32 v0, v70, v69
v_add3_u32 v0, v0, v71, v72
v_add3_u32 v0, v0, v73, v74
v_add3_u32 v3, v0, v75, v76
v_and_b32_e32 v0, 64, v40
v_and_b32_e32 v1, 63, v40
v_add_u32_e32 v0, 64, v0
v_xor_b32_e32 v2, 1, v1
v_cmp_lt_i32_e64 s[8:9], v2, v0
v_cndmask_b32_e64 v2, v40, v2, s[8:9]
v_lshlrev_b32_e32 v69, 2, v2
ds_bpermute_b32 v2, v69, v68
v_xor_b32_e32 v1, 2, v1
v_cmp_lt_i32_e64 s[8:9], v1, v0
v_cndmask_b32_e64 v0, v40, v1, s[8:9]
v_lshlrev_b32_e32 v70, 2, v0
ds_bpermute_b32 v4, v69, v67
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v0, v2, v68
ds_bpermute_b32 v2, v69, v66
ds_bpermute_b32 v7, v69, v3
ds_bpermute_b32 v1, v70, v0
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v4, v4, v67
ds_bpermute_b32 v5, v70, v4
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v2, v2, v66
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v3, v7, v3
ds_bpermute_b32 v6, v70, v2
ds_bpermute_b32 v7, v70, v3
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 32
ds_bpermute_b32 v66, v69, v57
ds_bpermute_b32 v67, v69, v56
ds_bpermute_b32 v68, v69, v55
ds_bpermute_b32 v69, v69, v54
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v57, v66, v57
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v56, v67, v56
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v55, v68, v55
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v54, v69, v54
ds_bpermute_b32 v66, v70, v57
ds_bpermute_b32 v67, v70, v56
ds_bpermute_b32 v68, v70, v55
ds_bpermute_b32 v69, v70, v54
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v57, v66, v57
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v56, v67, v56
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v55, v68, v55
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v54, v69, v54
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v68, v1, v0
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v67, v5, v4
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v66, v6, v2
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v69, v7, v3
s_or_b64 exec, exec, s[10:11]
s_or_b64 s[6:7], s[4:5], s[6:7]
s_or_b64 s[6:7], s[6:7], s[2:3]
s_xor_b64 s[8:9], s[6:7], -1
s_and_saveexec_b64 s[6:7], s[8:9]
s_cbranch_execz 65025
global_load_ushort v6, v[14:15], off
v_add_u32_e32 v0, 0, v39
v_add_u32_e32 v1, 0, v35
v_add_u32_e32 v2, 0, v38
v_add_u32_e32 v5, 0, v34
v_add_u32_e32 v7, 0, v37
v_add_u32_e32 v70, 0, v32
ds_read_b32 v3, v0
ds_read_b32 v71, v1
ds_read_b32 v4, v2
ds_read_b32 v2, v5
ds_read_b32 v0, v7
ds_read_b32 v5, v70
v_add_u32_e32 v1, 0, v36
v_add_u32_e32 v7, 0, v31
ds_read_b32 v72, v7
ds_read_b32 v1, v1
s_waitcnt lgkmcnt(6)
v_lshlrev_b32_e32 v70, 3, v71
s_waitcnt lgkmcnt(4)
v_lshlrev_b32_e32 v7, 3, v2
s_waitcnt lgkmcnt(2)
v_lshlrev_b32_e32 v5, 3, v5
s_waitcnt lgkmcnt(1)
v_lshlrev_b32_e32 v2, 3, v72
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 64969
global_load_ushort v71, v[16:17], off
v_sub_u32_e32 v72, v57, v70
v_sub_u32_e32 v73, v56, v7
v_sub_u32_e32 v74, v55, v5
v_sub_u32_e32 v75, v54, v2
v_cvt_f32_i32_e32 v72, v72
v_cvt_f32_i32_e32 v73, v73
v_cvt_f32_i32_e32 v74, v74
v_cvt_f32_i32_e32 v75, v75
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v71, v71
v_mul_f32_e32 v76, v3, v71
v_mul_f32_e32 v77, v4, v71
v_mul_f32_e32 v78, v0, v71
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v71, v1, v71
v_fmac_f32_e32 v28, v72, v76
v_fmac_f32_e32 v26, v73, v77
v_fmac_f32_e32 v25, v74, v78
v_fmac_f32_e32 v24, v75, v71
s_branch 64947
v_cmp_lt_i32_e32 vcc, 0, v23
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
ds_bpermute_b32 v4, v2, v33
v_xor_b32_e32 v3, 16, v1
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v0, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v33, v4
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
v_cmp_eq_u32_e32 vcc, 0, v27
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v10, v11
v_mov_b32_e32 v11, s23
v_add_co_u32_e64 v0, s[0:1], s22, v0
v_addc_co_u32_e64 v1, s[0:1], v11, v1, s[0:1]
global_store_dword v[0:1], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v2, v30
s_ashr_i32 s21, s20, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v30, v0
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
ds_bpermute_b32 v0, v2, v22
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v22, v0
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
ds_bpermute_b32 v0, v2, v29
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v29, v0
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
v_cmp_lt_i32_e64 s[0:1], 1, v23
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 136
ds_bpermute_b32 v0, v2, v28
v_mov_b32_e32 v12, s23
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v28, v0
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
ds_bpermute_b32 v8, v2, v26
s_lshl_b64 s[2:3], s[20:21], 2
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v26, v8
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
ds_bpermute_b32 v8, v2, v25
v_mov_b32_e32 v10, s3
v_add_co_u32_e64 v0, s[0:1], s2, v0
v_addc_co_u32_e64 v1, s[0:1], v1, v10, s[0:1]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v25, v8
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
ds_bpermute_b32 v2, v2, v24
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v24, v2
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
