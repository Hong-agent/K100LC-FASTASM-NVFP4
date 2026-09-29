.text
k__Z9gemv_w4a4ILi4EEvPKjPKtS1_PKfPfii:
s_load_dwordx2 s[8:9], s[4:5], 0x28
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v8, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s8, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 481
s_cmp_gt_i32 s9, 7
v_ashrrev_i32_e32 v9, 31, v8
s_cbranch_scc1 3
s_mov_b64 s[0:1], 0
s_mov_b32 s2, 0
s_branch 1
s_mov_b64 s[0:1], -1
s_load_dwordx2 s[10:11], s[4:5], 0x20
s_andn2_b64 vcc, exec, s[0:1]
v_mov_b32_e32 v25, s2
v_and_b32_e32 v17, 63, v0
v_mov_b32_e32 v19, s2
v_mov_b32_e32 v18, s2
v_mov_b32_e32 v16, s2
s_cbranch_vccnz 278
s_ashr_i32 s12, s9, 31
s_lshr_b32 s13, s12, 29
s_lshr_b32 s12, s12, 25
s_add_i32 s12, s9, s12
s_ashr_i32 s12, s12, 7
s_add_i32 s14, s9, s13
v_mad_i64_i32 v[0:1], s[12:13], s12, v8, 0
s_load_dwordx8 s[0:7], s[4:5], 0x0
s_ashr_i32 s12, s14, 3
v_lshlrev_b32_e32 v20, 2, v17
s_mov_b32 s14, 0
v_lshlrev_b64 v[0:1], 1, v[0:1]
v_alignbit_b32 v2, s14, v20, 4
v_lshlrev_b32_e32 v2, 1, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s3
v_add_co_u32_e32 v10, vcc, s2, v0
s_lshr_b32 s9, s9, 5
v_addc_co_u32_e32 v11, vcc, v2, v1, vcc
s_ashr_i32 s13, s12, 31
v_mov_b32_e32 v0, s7
v_add_co_u32_e32 v21, vcc, s6, v20
s_mul_i32 s2, s9, 12
v_addc_co_u32_e32 v22, vcc, 0, v0, vcc
s_add_u32 s2, s6, s2
s_addc_u32 s3, s7, 0
v_add_co_u32_e32 v23, vcc, s2, v20
s_lshl_b32 s2, s9, 3
v_mov_b32_e32 v1, s3
s_add_u32 s2, s6, s2
v_addc_co_u32_e32 v24, vcc, 0, v1, vcc
s_addc_u32 s3, s7, 0
v_mov_b32_e32 v1, s3
v_add_co_u32_e32 v26, vcc, s2, v20
v_addc_co_u32_e32 v27, vcc, 0, v1, vcc
v_add_lshl_u32 v1, s9, v17, 2
v_add_co_u32_e32 v28, vcc, s6, v1
v_addc_co_u32_e32 v29, vcc, 0, v0, vcc
v_mad_i64_i32 v[0:1], s[2:3], s12, v8, 0
v_lshlrev_b32_e32 v2, 4, v17
v_mov_b32_e32 v3, s1
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_mov_b32_e32 v16, 0
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
v_add_co_u32_e32 v12, vcc, s0, v0
v_addc_co_u32_e32 v13, vcc, v3, v1, vcc
v_mov_b32_e32 v0, s5
v_add_co_u32_e32 v14, vcc, s4, v2
s_mul_hi_i32 s9, s12, 12
s_mul_i32 s16, s12, 12
v_addc_co_u32_e32 v15, vcc, 0, v0, vcc
s_lshl_b64 s[2:3], s[12:13], 3
s_lshl_b64 s[4:5], s[12:13], 2
s_mov_b64 s[6:7], 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v25, 0
s_branch 30
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v1, v42, v41
v_cvt_f32_i32_e32 v1, v1
v_mul_f32_e32 v2, v33, v40
v_add_u32_e32 v3, v39, v38
v_add_u32_e32 v0, v0, v44
v_fmac_f32_e32 v18, v1, v2
v_cvt_f32_i32_e32 v1, v3
v_add_u32_e32 v3, v36, v35
v_cvt_f32_i32_e32 v3, v3
v_add_co_u32_e32 v10, vcc, 32, v10
v_cvt_f32_i32_e32 v0, v0
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_mul_f32_e32 v2, v31, v37
v_add_co_u32_e32 v14, vcc, 0x400, v14
v_fmac_f32_e32 v19, v1, v2
v_mul_f32_e32 v1, v30, v34
s_add_u32 s6, s6, 0x100
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
v_fmac_f32_e32 v25, v3, v1
v_mul_f32_e32 v1, v32, v43
s_addc_u32 s7, s7, 0
v_add_co_u32_e32 v12, vcc, 0x400, v12
v_fmac_f32_e32 v16, v0, v1
s_cmp_ge_i32 s6, s12
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
s_cbranch_scc1 180
v_add3_u32 v0, v20, s6, 4
v_cmp_ge_i32_e32 vcc, s12, v0
v_mov_b32_e32 v30, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s7
v_add_co_u32_e64 v0, s[0:1], s6, v21
v_addc_co_u32_e64 v1, s[0:1], v22, v1, s[0:1]
global_load_dword v30, v[0:1], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v31, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s7
v_add_co_u32_e64 v0, s[0:1], s6, v28
v_addc_co_u32_e64 v1, s[0:1], v29, v1, s[0:1]
global_load_dword v31, v[0:1], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v33, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s7
v_add_co_u32_e64 v0, s[0:1], s6, v26
v_addc_co_u32_e64 v1, s[0:1], v27, v1, s[0:1]
global_load_dword v33, v[0:1], off
s_or_b64 exec, exec, s[14:15]
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s7
v_add_co_u32_e64 v0, s[0:1], s6, v23
v_addc_co_u32_e64 v1, s[0:1], v24, v1, s[0:1]
global_load_dword v32, v[0:1], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v34, 0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
global_load_dwordx4 v[0:3], v[12:13], off
global_load_dwordx4 v[4:7], v[14:15], off
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v35, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v35, v0, v4, v35
v_mov_b32_e32 v36, 0
v_dot8_i32_i4 v36, v1, v5, v36
v_dot8_i32_i4 v35, v2, v6, v35
v_dot8_i32_i4 v36, v3, v7, v36
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
global_load_ushort v4, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v34, v4
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v37, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v5, s5
v_add_co_u32_e64 v4, s[0:1], s4, v14
v_addc_co_u32_e64 v5, s[0:1], v15, v5, s[0:1]
global_load_dwordx4 v[4:7], v[4:5], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v38, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v38, v0, v4, v38
v_mov_b32_e32 v39, 0
v_dot8_i32_i4 v39, v1, v5, v39
v_dot8_i32_i4 v38, v2, v6, v38
v_dot8_i32_i4 v39, v3, v7, v39
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
global_load_ushort v4, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v37, v4
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v40, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v5, s3
v_add_co_u32_e64 v4, s[0:1], s2, v14
v_addc_co_u32_e64 v5, s[0:1], v15, v5, s[0:1]
global_load_dwordx4 v[4:7], v[4:5], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v41, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v41, v0, v4, v41
v_mov_b32_e32 v42, 0
v_dot8_i32_i4 v42, v1, v5, v42
v_dot8_i32_i4 v41, v2, v6, v41
v_dot8_i32_i4 v42, v3, v7, v42
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
global_load_ushort v4, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v40, v4
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v43, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 7
v_mov_b32_e32 v5, s9
v_add_co_u32_e64 v4, s[0:1], s16, v14
v_addc_co_u32_e64 v5, s[0:1], v15, v5, s[0:1]
global_load_dwordx4 v[4:7], v[4:5], off
s_or_b64 exec, exec, s[14:15]
v_mov_b32_e32 v44, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v44, v0, v4, v44
v_mov_b32_e32 v0, 0
v_dot8_i32_i4 v0, v1, v5, v0
v_dot8_i32_i4 v44, v2, v6, v44
v_dot8_i32_i4 v0, v3, v7, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 65331
global_load_ushort v1, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v43, v1
s_branch 65326
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v5, -1, v0
v_and_b32_e32 v6, 63, v5
v_and_b32_e32 v0, 64, v5
v_add_u32_e32 v7, 64, v0
v_xor_b32_e32 v0, 32, v6
v_cmp_lt_i32_e32 vcc, v0, v7
v_cndmask_b32_e32 v0, v5, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v1, v0, v25
v_xor_b32_e32 v2, 16, v6
v_cmp_lt_i32_e32 vcc, v2, v7
v_xor_b32_e32 v4, 8, v6
v_xor_b32_e32 v10, 4, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v25, v1
v_cndmask_b32_e32 v1, v5, v2, vcc
v_lshlrev_b32_e32 v1, 2, v1
ds_bpermute_b32 v2, v1, v3
v_cmp_lt_i32_e32 vcc, v4, v7
v_xor_b32_e32 v11, 2, v6
v_xor_b32_e32 v12, 1, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v2
v_cndmask_b32_e32 v2, v5, v4, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v3
v_cmp_lt_i32_e32 vcc, v10, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v3, v4
v_cndmask_b32_e32 v3, v5, v10, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v10, v3, v4
v_cmp_lt_i32_e32 vcc, v11, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v4, v10
v_cndmask_b32_e32 v4, v5, v11, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v11, v4, v10
v_cmp_lt_i32_e32 vcc, v12, v7
v_cndmask_b32_e32 v5, v5, v12, vcc
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_eq_u32_e32 vcc, 0, v17
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v10, v11
ds_bpermute_b32 v7, v5, v6
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 11
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v6, v7
v_lshlrev_b64 v[6:7], 2, v[8:9]
v_mov_b32_e32 v11, s11
v_add_co_u32_e64 v6, s[0:1], s10, v6
v_addc_co_u32_e64 v7, s[0:1], v11, v7, s[0:1]
global_store_dword v[6:7], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v6, v0, v19
s_ashr_i32 s9, s8, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v19, v6
ds_bpermute_b32 v7, v1, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v2, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v3, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v4, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v5, v6
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 16
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v6, v7
v_mov_b32_e32 v7, s9
v_add_co_u32_e64 v6, s[0:1], s8, v8
v_addc_co_u32_e64 v7, s[0:1], v9, v7, s[0:1]
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_mov_b32_e32 v11, s11
v_add_co_u32_e64 v6, s[0:1], s10, v6
v_addc_co_u32_e64 v7, s[0:1], v11, v7, s[0:1]
global_store_dword v[6:7], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v6, v0, v18
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v18, v6
ds_bpermute_b32 v7, v1, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v2, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v3, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v4, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_bpermute_b32 v7, v5, v6
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 17
s_lshl_b64 s[0:1], s[8:9], 1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v10, v6, v7
v_mov_b32_e32 v7, s1
v_add_co_u32_e64 v6, s[0:1], s0, v8
v_addc_co_u32_e64 v7, s[0:1], v7, v9, s[0:1]
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_mov_b32_e32 v11, s11
v_add_co_u32_e64 v6, s[0:1], s10, v6
v_addc_co_u32_e64 v7, s[0:1], v11, v7, s[0:1]
global_store_dword v[6:7], v10, off
s_or_b64 exec, exec, s[2:3]
ds_bpermute_b32 v0, v0, v16
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v16, v0
ds_bpermute_b32 v1, v1, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v2, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v3, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v4, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v1
ds_bpermute_b32 v1, v5, v0
s_and_b64 exec, exec, vcc
s_cbranch_execz 11
v_mad_i64_i32 v[2:3], s[0:1], s8, 3, v[8:9]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v0, v1
v_mov_b32_e32 v5, s11
v_lshlrev_b64 v[0:1], 2, v[2:3]
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v5, v1, vcc
global_store_dword v[0:1], v4, off
s_endpgm
