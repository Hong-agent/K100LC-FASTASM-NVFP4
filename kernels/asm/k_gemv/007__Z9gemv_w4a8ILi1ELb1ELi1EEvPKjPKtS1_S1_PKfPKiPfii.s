.text
k__Z9gemv_w4a8ILi1ELb1ELi1EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[2:3], s[4:5], 0x38
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v4, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s2, v4
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 364
s_load_dwordx4 s[8:11], s[4:5], 0x0
s_load_dwordx4 s[12:15], s[4:5], 0x20
s_load_dwordx2 s[6:7], s[4:5], 0x30
s_ashr_i32 s2, s3, 31
s_lshr_b32 s0, s2, 29
s_add_i32 s0, s3, s0
s_ashr_i32 s24, s0, 3
v_cmp_gt_i32_e32 vcc, s24, v0
v_lshlrev_b32_e32 v1, 2, v0
s_and_saveexec_b64 s[20:21], vcc
s_cbranch_execz 42
s_load_dword s0, s[4:5], 0x4c
s_load_dwordx4 s[16:19], s[4:5], 0x10
s_mov_b32 s25, 0
v_mov_b32_e32 v2, 0
v_add_u32_e32 v3, 0, v1
s_waitcnt lgkmcnt(0)
s_and_b32 s26, s0, 0xffff
s_lshl_b32 s27, s26, 2
s_lshl_b32 s28, s24, 2
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v5, v0
v_mov_b32_e32 v7, s17
v_add_co_u32_e64 v8, s[0:1], s16, v1
v_mov_b32_e32 v10, s19
v_add_co_u32_e32 v6, vcc, s18, v1
v_addc_co_u32_e64 v9, s[0:1], v7, v2, s[0:1]
v_addc_co_u32_e32 v7, vcc, v10, v2, vcc
global_load_dword v10, v[8:9], off
global_load_dword v11, v[6:7], off
v_mov_b32_e32 v7, s25
v_add_co_u32_e32 v1, vcc, s27, v1
v_add_u32_e32 v5, s26, v5
v_addc_co_u32_e32 v2, vcc, v2, v7, vcc
v_cmp_le_i32_e32 vcc, s24, v5
v_add_u32_e32 v6, s28, v3
s_or_b64 s[22:23], vcc, s[22:23]
s_waitcnt vmcnt(1)
ds_write_b32 v3, v10
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
v_add_u32_e32 v3, s27, v3
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execnz 65508
s_or_b64 exec, exec, s[20:21]
s_lshr_b32 s0, s2, 25
s_add_i32 s0, s3, s0
s_ashr_i32 s2, s0, 7
v_cmp_gt_i32_e32 vcc, s2, v0
s_and_saveexec_b64 s[16:17], vcc
s_cbranch_execz 43
s_load_dword s0, s[4:5], 0x4c
s_lshl_b32 s1, s24, 3
v_lshlrev_b32_e32 v1, 2, v0
s_mov_b32 s18, 0
v_mov_b32_e32 v2, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s19, s0, 0xffff
s_add_i32 s0, s1, 0
s_lshl_b32 s20, s19, 2
v_add_u32_e32 v3, s0, v1
s_lshl_b32 s21, s2, 2
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v5, v0
v_mov_b32_e32 v7, s13
v_add_co_u32_e64 v8, s[0:1], s12, v1
v_mov_b32_e32 v10, s15
v_add_co_u32_e32 v6, vcc, s14, v1
v_addc_co_u32_e64 v9, s[0:1], v7, v2, s[0:1]
v_addc_co_u32_e32 v7, vcc, v10, v2, vcc
global_load_dword v10, v[8:9], off
global_load_dword v11, v[6:7], off
v_mov_b32_e32 v7, s18
v_add_co_u32_e32 v1, vcc, s20, v1
v_add_u32_e32 v5, s19, v5
v_addc_co_u32_e32 v2, vcc, v2, v7, vcc
v_cmp_le_i32_e32 vcc, s2, v5
v_add_u32_e32 v6, s21, v3
s_or_b64 s[4:5], vcc, s[4:5]
s_waitcnt vmcnt(1)
ds_write_b32 v3, v10
s_waitcnt vmcnt(0)
ds_write_b32 v6, v11
v_add_u32_e32 v3, s20, v3
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65508
s_or_b64 exec, exec, s[16:17]
s_cmp_gt_i32 s3, 7
v_mbcnt_lo_u32_b32 v1, -1, 0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 12
v_mbcnt_hi_u32_b32 v10, -1, v1
v_and_b32_e32 v1, 64, v10
v_and_b32_e32 v3, 63, v10
s_mov_b32 s3, 0
v_add_u32_e32 v1, 64, v1
v_xor_b32_e32 v16, 2, v3
v_xor_b32_e32 v2, 1, v3
v_and_b32_e32 v9, 63, v0
v_mov_b32_e32 v12, s3
s_cbranch_execz 3
s_branch 181
v_and_b32_e32 v9, 63, v0
v_mov_b32_e32 v12, s3
v_mad_i64_i32 v[1:2], s[0:1], s24, v4, 0
v_and_b32_e32 v3, 3, v0
v_cmp_eq_u32_e64 s[0:1], 0, v3
v_lshlrev_b64 v[1:2], 2, v[1:2]
v_lshlrev_b32_e32 v3, 4, v9
v_add_co_u32_e32 v1, vcc, v1, v3
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_mov_b32_e32 v3, s9
v_add_co_u32_e32 v5, vcc, s8, v1
v_addc_co_u32_e32 v6, vcc, v3, v2, vcc
s_lshl_b32 s8, s2, 2
v_mad_i64_i32 v[1:2], s[2:3], s2, v4, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[1:2], 1, v[1:2]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v0, 1, v0
v_add_co_u32_e32 v0, vcc, v1, v0
s_lshl_b32 s9, s24, 3
v_addc_co_u32_e32 v1, vcc, 0, v2, vcc
v_and_b32_e32 v3, 60, v9
s_add_i32 s2, s9, 0
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v7, vcc, s10, v0
v_mbcnt_lo_u32_b32 v0, -1, 0
s_mov_b32 s4, 0
s_lshl_b32 s5, s24, 2
v_lshl_add_u32 v11, v9, 4, 0
v_add_u32_e32 v13, s2, v3
v_addc_co_u32_e32 v8, vcc, v2, v1, vcc
v_lshl_add_u32 v14, v9, 2, 4
v_mov_b32_e32 v15, 0
v_mbcnt_hi_u32_b32 v10, -1, v0
v_mov_b32_e32 v12, 0
s_branch 12
s_or_b64 exec, exec, s[2:3]
v_add_co_u32_e32 v5, vcc, 0x400, v5
v_addc_co_u32_e32 v6, vcc, 0, v6, vcc
s_addk_i32 s4, 0x100
v_add_co_u32_e32 v7, vcc, 32, v7
v_add_u32_e32 v11, 0x400, v11
v_add_u32_e32 v13, 64, v13
s_cmp_ge_i32 s4, s24
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_cbranch_scc1 122
v_add_u32_e32 v0, s4, v14
v_cmp_ge_i32_e32 vcc, s24, v0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 2
global_load_dwordx4 v[0:3], v[5:6], off
s_or_b64 exec, exec, s[2:3]
s_waitcnt vmcnt(0)
v_and_b32_e32 v16, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v21, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v1
v_xor_b32_e32 v22, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v1
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_xor_b32_e32 v23, 0x8080808, v0
v_and_b32_e32 v0, 0xf0f0f0f, v2
v_xor_b32_e32 v20, 0x8080808, v16
v_xor_b32_e32 v24, 0x8080808, v0
v_lshrrev_b32_e32 v0, 4, v2
v_add_u32_e32 v16, s5, v11
v_and_b32_e32 v25, 0xf0f0f0f, v0
v_and_b32_e32 v26, 0xf0f0f0f, v3
v_lshrrev_b32_e32 v27, 4, v3
ds_read_b128 v[0:3], v11
s_waitcnt lgkmcnt(1)
ds_read_b128 v[16:19], v16
v_and_b32_e32 v27, 0xf0f0f0f, v27
v_xor_b32_e32 v25, 0x8080808, v25
v_xor_b32_e32 v26, 0x8080808, v26
v_xor_b32_e32 v27, 0x8080808, v27
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v0, v20, v0, v15
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v16, v21, v16, v15
v_dot4_i32_i8 v1, v22, v1, v15
v_dot4_i32_i8 v17, v23, v17, v15
v_dot4_i32_i8 v2, v24, v2, v15
v_dot4_i32_i8 v18, v25, v18, v15
v_dot4_i32_i8 v3, v26, v3, v15
v_dot4_i32_i8 v19, v27, v19, v15
v_add_u32_e32 v0, v16, v0
v_add3_u32 v0, v0, v1, v17
v_add3_u32 v0, v0, v2, v18
v_add3_u32 v0, v0, v3, v19
v_and_b32_e32 v1, 64, v10
v_and_b32_e32 v3, 63, v10
v_add_u32_e32 v1, 64, v1
v_xor_b32_e32 v2, 1, v3
v_cmp_lt_i32_e64 s[2:3], v2, v1
v_cndmask_b32_e64 v16, v10, v2, s[2:3]
v_lshlrev_b32_e32 v16, 2, v16
ds_bpermute_b32 v16, v16, v0
s_and_b64 s[10:11], s[0:1], vcc
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v16, v0
v_xor_b32_e32 v16, 2, v3
v_cmp_lt_i32_e64 s[2:3], v16, v1
v_cndmask_b32_e64 v17, v10, v16, s[2:3]
v_lshlrev_b32_e32 v17, 2, v17
ds_bpermute_b32 v17, v17, v0
s_and_saveexec_b64 s[2:3], s[10:11]
s_cbranch_execz 65421
global_load_ushort v18, v[7:8], off
v_add_u32_e32 v19, s8, v13
ds_read_b32 v19, v19
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v0, v17, v0
ds_read_b32 v17, v13
s_waitcnt lgkmcnt(1)
v_lshlrev_b32_e32 v19, 3, v19
v_sub_u32_e32 v0, v0, v19
v_cvt_f32_i32_e32 v0, v0
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v18, v18
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v17, v17, v18
v_fmac_f32_e32 v12, v17, v0
s_branch 65402
v_xor_b32_e32 v0, 32, v3
v_cmp_lt_i32_e32 vcc, v0, v1
v_cndmask_b32_e32 v0, v10, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v0, v0, v12
v_xor_b32_e32 v5, 16, v3
v_cmp_lt_i32_e32 vcc, v5, v1
v_cndmask_b32_e32 v5, v10, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v12, v0
ds_bpermute_b32 v5, v5, v0
v_xor_b32_e32 v6, 8, v3
v_cmp_lt_i32_e32 vcc, v6, v1
v_cndmask_b32_e32 v6, v10, v6, vcc
v_xor_b32_e32 v3, 4, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v5
v_lshlrev_b32_e32 v5, 2, v6
ds_bpermute_b32 v5, v5, v0
v_cmp_lt_i32_e32 vcc, v3, v1
v_cndmask_b32_e32 v3, v10, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
v_cmp_lt_i32_e32 vcc, v16, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v5
ds_bpermute_b32 v3, v3, v0
v_cndmask_b32_e32 v5, v10, v16, vcc
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_lt_i32_e32 vcc, v2, v1
v_cndmask_b32_e32 v1, v10, v2, vcc
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v3
ds_bpermute_b32 v3, v5, v0
v_lshlrev_b32_e32 v1, 2, v1
v_cmp_eq_u32_e32 vcc, 0, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v3
ds_bpermute_b32 v1, v1, v0
s_and_b64 exec, exec, vcc
s_cbranch_execz 10
v_ashrrev_i32_e32 v5, 31, v4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v0, v1
v_lshlrev_b64 v[0:1], 2, v[4:5]
v_mov_b32_e32 v3, s7
v_add_co_u32_e32 v0, vcc, s6, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
