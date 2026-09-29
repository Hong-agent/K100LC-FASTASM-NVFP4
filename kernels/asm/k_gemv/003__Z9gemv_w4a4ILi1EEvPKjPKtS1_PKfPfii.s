.text
k__Z9gemv_w4a4ILi1EEvPKjPKtS1_PKfPfii:
s_load_dwordx2 s[10:11], s[4:5], 0x28
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v8, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s10, v8
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 180
s_load_dwordx2 s[8:9], s[4:5], 0x20
s_cmp_lt_i32 s11, 8
v_mov_b32_e32 v18, 0
v_and_b32_e32 v15, 63, v0
s_cbranch_scc1 108
s_load_dwordx8 s[0:7], s[4:5], 0x0
s_ashr_i32 s12, s11, 31
s_lshr_b32 s10, s12, 29
s_add_i32 s10, s11, s10
v_lshlrev_b32_e32 v2, 2, v15
s_ashr_i32 s10, s10, 3
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v0, s7
v_add_co_u32_e32 v16, vcc, s6, v2
v_addc_co_u32_e32 v17, vcc, 0, v0, vcc
v_mad_i64_i32 v[0:1], s[6:7], s10, v8, 0
v_lshlrev_b32_e32 v3, 4, v15
s_lshr_b32 s12, s12, 25
v_mov_b32_e32 v4, s5
v_add_co_u32_e32 v9, vcc, s4, v3
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_add_i32 s11, s11, s12
v_addc_co_u32_e32 v10, vcc, 0, v4, vcc
s_ashr_i32 s11, s11, 7
v_add_co_u32_e32 v3, vcc, v0, v3
v_addc_co_u32_e32 v4, vcc, 0, v1, vcc
v_mad_i64_i32 v[0:1], s[4:5], s11, v8, 0
v_mov_b32_e32 v5, s1
v_add_co_u32_e32 v11, vcc, s0, v3
v_lshlrev_b64 v[0:1], 1, v[0:1]
v_alignbit_b32 v3, 0, v2, 4
v_addc_co_u32_e32 v12, vcc, v5, v4, vcc
v_lshlrev_b32_e32 v3, 1, v3
v_add_co_u32_e32 v0, vcc, v0, v3
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
v_mov_b32_e32 v3, s3
v_add_co_u32_e32 v13, vcc, s2, v0
v_addc_co_u32_e32 v14, vcc, v3, v1, vcc
v_add_co_u32_e32 v19, vcc, 4, v2
s_mov_b64 s[2:3], 0
v_mov_b32_e32 v18, 0
s_branch 18
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v0, v0, v22
v_add_co_u32_e32 v9, vcc, 0x400, v9
v_cvt_f32_i32_e32 v0, v0
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_add_co_u32_e32 v11, vcc, 0x400, v11
s_add_u32 s2, s2, 0x100
v_addc_co_u32_e32 v12, vcc, 0, v12, vcc
v_mul_f32_e32 v1, v20, v21
s_addc_u32 s3, s3, 0
v_add_co_u32_e32 v13, vcc, 32, v13
v_fmac_f32_e32 v18, v0, v1
s_cmp_ge_i32 s2, s10
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
s_cbranch_scc1 47
v_add_u32_e32 v0, s2, v19
v_cmp_ge_i32_e32 vcc, s10, v0
v_mov_b32_e32 v20, 0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 7
v_mov_b32_e32 v1, s3
v_add_co_u32_e64 v0, s[0:1], s2, v16
v_addc_co_u32_e64 v1, s[0:1], v17, v1, s[0:1]
global_load_dword v20, v[0:1], off
s_or_b64 exec, exec, s[4:5]
v_mov_b32_e32 v21, 0
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
global_load_dwordx4 v[0:3], v[11:12], off
global_load_dwordx4 v[4:7], v[9:10], off
s_or_b64 exec, exec, s[0:1]
v_mov_b32_e32 v22, 0
s_waitcnt vmcnt(0)
v_dot8_i32_i4 v22, v0, v4, v22
v_mov_b32_e32 v0, 0
v_dot8_i32_i4 v0, v1, v5, v0
v_dot8_i32_i4 v22, v2, v6, v22
v_dot8_i32_i4 v0, v3, v7, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 65476
global_load_ushort v1, v[13:14], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v21, v1
s_branch 65471
v_mbcnt_lo_u32_b32 v0, -1, 0
v_mbcnt_hi_u32_b32 v1, -1, v0
v_and_b32_e32 v0, 63, v1
v_and_b32_e32 v2, 64, v1
v_add_u32_e32 v2, 64, v2
v_xor_b32_e32 v3, 32, v0
v_cmp_lt_i32_e32 vcc, v3, v2
v_cndmask_b32_e32 v3, v1, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v18
v_xor_b32_e32 v4, 16, v0
v_cmp_lt_i32_e32 vcc, v4, v2
v_cndmask_b32_e32 v4, v1, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v18, v3
ds_bpermute_b32 v4, v4, v3
v_xor_b32_e32 v5, 8, v0
v_cmp_lt_i32_e32 vcc, v5, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v4
v_cndmask_b32_e32 v4, v1, v5, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v4, v4, v3
v_xor_b32_e32 v5, 4, v0
v_cmp_lt_i32_e32 vcc, v5, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v4
v_cndmask_b32_e32 v4, v1, v5, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v4, v4, v3
v_xor_b32_e32 v5, 2, v0
v_cmp_lt_i32_e32 vcc, v5, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v4
v_cndmask_b32_e32 v4, v1, v5, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v4, v4, v3
v_xor_b32_e32 v5, 1, v0
v_cmp_lt_i32_e32 vcc, v5, v2
v_cndmask_b32_e32 v1, v1, v5, vcc
v_lshlrev_b32_e32 v1, 2, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v3, v4
ds_bpermute_b32 v1, v1, v0
v_cmp_eq_u32_e32 vcc, 0, v15
s_and_b64 exec, exec, vcc
s_cbranch_execz 10
v_ashrrev_i32_e32 v9, 31, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v0, v1
v_lshlrev_b64 v[0:1], 2, v[8:9]
v_mov_b32_e32 v3, s9
v_add_co_u32_e32 v0, vcc, s8, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
