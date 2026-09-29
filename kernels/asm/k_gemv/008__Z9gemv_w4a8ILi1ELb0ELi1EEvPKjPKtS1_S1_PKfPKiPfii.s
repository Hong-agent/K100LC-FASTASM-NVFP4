.text
k__Z9gemv_w4a8ILi1ELb0ELi1EEvPKjPKtS1_S1_PKfPKiPfii:
s_load_dwordx2 s[0:1], s[4:5], 0x38
v_lshrrev_b32_e32 v1, 6, v0
v_lshl_or_b32 v4, s6, 2, v1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s0, v4
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 285
s_cmp_gt_i32 s1, 7
v_mbcnt_lo_u32_b32 v1, -1, 0
s_cbranch_scc1 10
v_mbcnt_hi_u32_b32 v12, -1, v1
v_and_b32_e32 v1, 64, v12
v_and_b32_e32 v3, 63, v12
s_mov_b32 s0, 0
v_add_u32_e32 v1, 64, v1
v_xor_b32_e32 v19, 2, v3
v_xor_b32_e32 v2, 1, v3
s_mov_b64 s[2:3], 0
s_branch 1
s_mov_b64 s[2:3], -1
s_load_dwordx2 s[6:7], s[4:5], 0x30
v_and_b32_e32 v11, 63, v0
s_andn2_b64 vcc, exec, s[2:3]
v_mov_b32_e32 v15, s0
s_cbranch_vccnz 207
s_ashr_i32 s0, s1, 31
s_lshr_b32 s2, s0, 29
s_add_i32 s2, s1, s2
s_ashr_i32 s20, s2, 3
v_mad_i64_i32 v[1:2], s[2:3], s20, v4, 0
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[16:19], s[4:5], 0x20
s_lshr_b32 s0, s0, 25
v_lshlrev_b64 v[1:2], 2, v[1:2]
s_add_i32 s0, s1, s0
s_ashr_i32 s2, s0, 7
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, s9
v_add_co_u32_e32 v13, vcc, s8, v1
v_and_b32_e32 v1, 3, v0
v_addc_co_u32_e32 v14, vcc, v3, v2, vcc
v_cmp_eq_u32_e64 s[0:1], 0, v1
v_mad_i64_i32 v[1:2], s[2:3], s2, v4, 0
v_and_b32_e32 v0, 60, v0
v_lshlrev_b32_e32 v0, 2, v0
v_lshlrev_b64 v[1:2], 1, v[1:2]
v_alignbit_b32 v0, 0, v0, 4
v_lshlrev_b32_e32 v3, 1, v0
v_add_co_u32_e32 v1, vcc, v1, v3
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v5, vcc, s10, v1
v_addc_co_u32_e32 v6, vcc, v3, v2, vcc
v_lshlrev_b32_e32 v0, 2, v0
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v7, vcc, s16, v0
v_addc_co_u32_e32 v8, vcc, 0, v1, vcc
v_mov_b32_e32 v1, s19
v_add_co_u32_e32 v9, vcc, s18, v0
v_mbcnt_lo_u32_b32 v0, -1, 0
s_mov_b32 s8, 0
v_lshlrev_b32_e32 v16, 4, v11
v_mov_b32_e32 v17, 0
v_lshl_add_u32 v18, v11, 2, 4
v_addc_co_u32_e32 v10, vcc, 0, v1, vcc
v_mbcnt_hi_u32_b32 v12, -1, v0
v_mov_b32_e32 v15, 0
s_branch 19
s_or_b64 exec, exec, s[2:3]
v_add_co_u32_e32 v13, vcc, 0x400, v13
v_addc_co_u32_e32 v14, vcc, 0, v14, vcc
s_addk_i32 s8, 0x100
v_add_co_u32_e32 v5, vcc, 32, v5
s_add_u32 s12, s12, 0x400
v_addc_co_u32_e32 v6, vcc, 0, v6, vcc
s_addc_u32 s13, s13, 0
v_add_co_u32_e32 v7, vcc, 64, v7
s_add_u32 s14, s14, 0x400
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_addc_u32 s15, s15, 0
v_add_co_u32_e32 v9, vcc, 64, v9
s_cmp_ge_i32 s8, s20
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
s_cbranch_scc1 134
v_add_u32_e32 v0, s8, v18
v_cmp_ge_i32_e32 vcc, s20, v0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 6
v_add_co_u32_e64 v0, s[2:3], v13, v16
v_addc_co_u32_e64 v1, s[2:3], 0, v14, s[2:3]
global_load_dwordx4 v[0:3], v[0:1], off
s_or_b64 exec, exec, s[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v20, s13
v_add_co_u32_e64 v19, s[2:3], s12, v16
v_addc_co_u32_e64 v20, s[2:3], 0, v20, s[2:3]
v_mov_b32_e32 v24, s15
v_add_co_u32_e64 v23, s[2:3], s14, v16
global_load_dwordx4 v[19:22], v[19:20], off
v_addc_co_u32_e64 v24, s[2:3], 0, v24, s[2:3]
global_load_dwordx4 v[23:26], v[23:24], off
s_waitcnt vmcnt(2)
v_and_b32_e32 v27, 0xf0f0f0f, v0
v_lshrrev_b32_e32 v0, 4, v0
v_and_b32_e32 v28, 0xf0f0f0f, v1
v_lshrrev_b32_e32 v1, 4, v1
v_and_b32_e32 v29, 0xf0f0f0f, v2
v_lshrrev_b32_e32 v2, 4, v2
v_and_b32_e32 v30, 0xf0f0f0f, v3
v_lshrrev_b32_e32 v3, 4, v3
v_and_b32_e32 v0, 0xf0f0f0f, v0
v_and_b32_e32 v1, 0xf0f0f0f, v1
v_and_b32_e32 v2, 0xf0f0f0f, v2
v_and_b32_e32 v3, 0xf0f0f0f, v3
v_xor_b32_e32 v27, 0x8080808, v27
v_xor_b32_e32 v0, 0x8080808, v0
v_xor_b32_e32 v1, 0x8080808, v1
v_xor_b32_e32 v2, 0x8080808, v2
v_xor_b32_e32 v3, 0x8080808, v3
v_xor_b32_e32 v28, 0x8080808, v28
v_xor_b32_e32 v29, 0x8080808, v29
v_xor_b32_e32 v30, 0x8080808, v30
s_waitcnt vmcnt(1)
v_dot4_i32_i8 v19, v27, v19, v17
s_waitcnt vmcnt(0)
v_dot4_i32_i8 v0, v0, v23, v17
v_dot4_i32_i8 v20, v28, v20, v17
v_dot4_i32_i8 v1, v1, v24, v17
v_dot4_i32_i8 v21, v29, v21, v17
v_dot4_i32_i8 v2, v2, v25, v17
v_dot4_i32_i8 v22, v30, v22, v17
v_dot4_i32_i8 v3, v3, v26, v17
v_add_u32_e32 v0, v0, v19
v_add3_u32 v0, v0, v20, v1
v_add3_u32 v0, v0, v21, v2
v_add3_u32 v0, v0, v22, v3
v_and_b32_e32 v1, 64, v12
v_and_b32_e32 v3, 63, v12
v_add_u32_e32 v1, 64, v1
v_xor_b32_e32 v2, 1, v3
v_cmp_lt_i32_e64 s[2:3], v2, v1
v_cndmask_b32_e64 v19, v12, v2, s[2:3]
v_lshlrev_b32_e32 v19, 2, v19
ds_bpermute_b32 v19, v19, v0
s_and_b64 s[4:5], s[0:1], vcc
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v19, v0
v_xor_b32_e32 v19, 2, v3
v_cmp_lt_i32_e64 s[2:3], v19, v1
v_cndmask_b32_e64 v20, v12, v19, s[2:3]
v_lshlrev_b32_e32 v20, 2, v20
ds_bpermute_b32 v20, v20, v0
s_and_saveexec_b64 s[2:3], s[4:5]
s_cbranch_execz 65401
global_load_ushort v21, v[5:6], off
global_load_dword v22, v[9:10], off
global_load_dword v23, v[7:8], off
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v0, v20, v0
s_waitcnt vmcnt(2)
v_cvt_f32_f16_e32 v20, v21
s_waitcnt vmcnt(1)
v_lshlrev_b32_e32 v21, 3, v22
v_sub_u32_e32 v0, v0, v21
v_cvt_f32_i32_e32 v0, v0
s_waitcnt vmcnt(0)
v_mul_f32_e32 v20, v23, v20
v_fmac_f32_e32 v15, v20, v0
s_branch 65383
v_xor_b32_e32 v0, 32, v3
v_cmp_lt_i32_e32 vcc, v0, v1
v_cndmask_b32_e32 v0, v12, v0, vcc
v_lshlrev_b32_e32 v0, 2, v0
ds_bpermute_b32 v0, v0, v15
v_xor_b32_e32 v5, 16, v3
v_cmp_lt_i32_e32 vcc, v5, v1
v_cndmask_b32_e32 v5, v12, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v15, v0
ds_bpermute_b32 v5, v5, v0
v_xor_b32_e32 v6, 8, v3
v_cmp_lt_i32_e32 vcc, v6, v1
v_cndmask_b32_e32 v6, v12, v6, vcc
v_xor_b32_e32 v3, 4, v3
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v5
v_lshlrev_b32_e32 v5, 2, v6
ds_bpermute_b32 v5, v5, v0
v_cmp_lt_i32_e32 vcc, v3, v1
v_cndmask_b32_e32 v3, v12, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
v_cmp_lt_i32_e32 vcc, v19, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v5
ds_bpermute_b32 v3, v3, v0
v_cndmask_b32_e32 v5, v12, v19, vcc
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_lt_i32_e32 vcc, v2, v1
v_cndmask_b32_e32 v1, v12, v2, vcc
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v3
ds_bpermute_b32 v3, v5, v0
v_lshlrev_b32_e32 v1, 2, v1
v_cmp_eq_u32_e32 vcc, 0, v11
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
