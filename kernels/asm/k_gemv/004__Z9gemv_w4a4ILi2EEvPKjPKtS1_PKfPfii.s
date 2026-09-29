.text
k__Z9gemv_w4a4ILi2EEvPKjPKtS1_PKfPfii:
s_load_dwordx2 s[8:9], s[4:5], 0x28
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v8, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s8, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 284
s_cmp_gt_i32 s9, 7
v_ashrrev_i32_e32 v9, 31, v8
s_cbranch_scc1 3
s_mov_b64 s[0:1], 0
s_mov_b32 s2, 0
s_branch 1
s_mov_b64 s[0:1], -1
s_load_dwordx2 s[10:11], s[4:5], 0x20
v_and_b32_e32 v16, 63, v0
s_andn2_b64 vcc, exec, s[0:1]
v_mov_b32_e32 v19, s2
v_mov_b32_e32 v17, s2
s_cbranch_vccnz 165
s_ashr_i32 s12, s9, 31
s_lshr_b32 s13, s12, 29
s_lshr_b32 s12, s12, 25
s_add_i32 s12, s9, s12
s_ashr_i32 s12, s12, 7
s_add_i32 s14, s9, s13
v_mad_i64_i32 v[0:1], s[12:13], s12, v8, 0
s_load_dwordx8 s[0:7], s[4:5], 0x0
s_ashr_i32 s12, s14, 3
v_lshlrev_b32_e32 v18, 2, v16
s_mov_b32 s14, 0
v_lshlrev_b64 v[0:1], 1, v[0:1]
v_alignbit_b32 v2, s14, v18, 4
v_lshlrev_b32_e32 v2, 1, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_lshr_b32 s9, s9, 5
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s3
v_add_co_u32_e32 v10, vcc, s2, v0
v_addc_co_u32_e32 v11, vcc, v2, v1, vcc
v_add_lshl_u32 v0, s9, v16, 2
v_mov_b32_e32 v1, s7
v_add_co_u32_e32 v20, vcc, s6, v0
v_addc_co_u32_e32 v21, vcc, 0, v1, vcc
v_add_co_u32_e32 v22, vcc, s6, v18
v_addc_co_u32_e32 v23, vcc, 0, v1, vcc
v_mad_i64_i32 v[0:1], s[6:7], s12, v8, 0
v_lshlrev_b32_e32 v2, 4, v16
v_mov_b32_e32 v3, s5
v_add_co_u32_e32 v12, vcc, s4, v2
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_addc_co_u32_e32 v13, vcc, 0, v3, vcc
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
s_ashr_i32 s13, s12, 31
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v14, vcc, s0, v0
v_mov_b32_e32 v17, 0
s_lshl_b64 s[2:3], s[12:13], 2
v_addc_co_u32_e32 v15, vcc, v2, v1, vcc
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v19, 0
s_branch 22
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v1, v28, v27
v_cvt_f32_i32_e32 v1, v1
v_add_u32_e32 v0, v0, v30
v_add_co_u32_e32 v10, vcc, 32, v10
v_cvt_f32_i32_e32 v0, v0
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_add_co_u32_e32 v12, vcc, 0x400, v12
v_mul_f32_e32 v2, v24, v26
s_add_u32 s4, s4, 0x100
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
v_fmac_f32_e32 v19, v1, v2
v_mul_f32_e32 v1, v25, v29
s_addc_u32 s5, s5, 0
v_add_co_u32_e32 v14, vcc, 0x400, v14
v_fmac_f32_e32 v17, v0, v1
s_cmp_ge_i32 s4, s12
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
s_cbranch_scc1 92
v_add3_u32 v0, v18, s4, 4
v_cmp_ge_i32_e32 vcc, s12, v0
v_mov_b32_e32 v24, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s5
v_add_co_u32_e64 v0, s[0:1], s4, v22
v_addc_co_u32_e64 v1, s[0:1], v23, v1, s[0:1]
global_load_dword v24, v[0:1], off
s_or_b64 exec, exec, s[6:7]
v_mov_b32_e32 v25, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s5
v_add_co_u32_e64 v0, s[0:1], s4, v20
v_addc_co_u32_e64 v1, s[0:1], v21, v1, s[0:1]
global_load_dword v25, v[0:1], off
s_or_b64 exec, exec, s[6:7]
v_mov_b32_e32 v26, 0
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
global_load_dwordx4 v[0:3], v[14:15], off
global_load_dwordx4 v[4:7], v[12:13], off
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v27, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v27, v0, v4, v27
v_mov_b32_e32 v28, 0
v_dot8_i32_i4 v28, v1, v5, v28
v_dot8_i32_i4 v27, v2, v6, v27
v_dot8_i32_i4 v28, v3, v7, v28
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
global_load_ushort v4, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v26, v4
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v7, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_mov_b32_e32 v5, s3
v_add_co_u32_e64 v4, s[0:1], s2, v12
v_addc_co_u32_e64 v5, s[0:1], v13, v5, s[0:1]
global_load_dwordx4 v[4:7], v[4:5], off
s_or_b64 exec, exec, s[6:7]
v_mov_b32_e32 v30, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v30, v0, v4, v30
v_mov_b32_e32 v0, 0
v_dot8_i32_i4 v0, v1, v5, v0
v_dot8_i32_i4 v30, v2, v6, v30
v_dot8_i32_i4 v0, v3, v7, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 65427
global_load_ushort v1, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v29, v1
s_branch 65422
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v5, -1, v0
v_and_b32_e32 v6, 63, v5
v_and_b32_e32 v0, 64, v5
v_add_u32_e32 v7, 64, v0
v_xor_b32_e32 v0, 32, v6
v_cmp_lt_i32_e32 vcc, v0, v7
v_cndmask_b32_e32 v0, v5, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v1, v0, v19
v_xor_b32_e32 v2, 16, v6
v_cmp_lt_i32_e32 vcc, v2, v7
v_xor_b32_e32 v4, 8, v6
v_xor_b32_e32 v10, 4, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v19, v1
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
v_cmp_eq_u32_e32 vcc, 0, v16
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
ds_bpermute_b32 v0, v0, v17
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v17, v0
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
s_cbranch_execz 13
s_ashr_i32 s0, s8, 31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v0, v1
v_mov_b32_e32 v1, s0
v_add_co_u32_e32 v0, vcc, s8, v8
v_addc_co_u32_e32 v1, vcc, v9, v1, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v0, vcc, s10, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
