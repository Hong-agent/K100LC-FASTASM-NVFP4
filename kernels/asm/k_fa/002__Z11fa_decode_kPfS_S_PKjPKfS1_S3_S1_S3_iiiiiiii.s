.text
k__Z11fa_decode_kPfS_S_PKjPKfS1_S3_S1_S3_iiiiiiii:
s_load_dwordx8 s[12:19], s[4:5], 0x48
v_cmp_gt_u32_e32 vcc, 64, v0
v_lshlrev_b32_e32 v2, 2, v0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s3, s14, 31
s_add_i32 s0, s14, s3
s_xor_b32 s2, s0, s3
v_cvt_f32_u32_e32 v1, s2
s_nop 0
v_rcp_iflag_f32_e32 v1, v1
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s8, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 17
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v3, s6
v_mad_i64_i32 v[3:4], s[14:15], s15, v3, v[0:1]
s_load_dwordx2 s[10:11], s[4:5], 0x18
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s11
v_add_co_u32_e32 v3, vcc, s10, v3
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
global_load_dword v1, v[3:4], off
s_waitcnt vmcnt(0)
ds_write_b32 v2, v1 offset:256
s_or_b64 exec, exec, s[0:1]
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 19
s_mul_hi_i32 s9, s16, s6
s_mul_i32 s14, s16, s6
v_mov_b32_e32 v3, s14
v_mov_b32_e32 v4, s9
v_mad_i64_i32 v[3:4], s[14:15], s17, v0, v[3:4]
s_load_dwordx2 s[10:11], s[4:5], 0x20
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s11
v_add_co_u32_e32 v3, vcc, s10, v3
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
global_load_dword v1, v[3:4], off
s_waitcnt vmcnt(0)
ds_write_b32 v2, v1 offset:640
s_or_b64 exec, exec, s[0:1]
s_ashr_i32 s9, s18, 31
s_add_i32 s10, s18, s9
s_xor_b32 s10, s10, s9
v_cvt_f32_u32_e32 v1, s10
s_add_i32 s0, s12, 63
s_ashr_i32 s1, s0, 31
s_lshr_b32 s1, s1, 26
v_rcp_iflag_f32_e32 v1, v1
s_add_i32 s0, s0, s1
s_ashr_i32 s0, s0, 6
s_add_i32 s1, s0, s18
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
s_add_i32 s1, s1, -1
s_ashr_i32 s11, s1, 31
s_add_i32 s1, s1, s11
s_xor_b32 s9, s11, s9
s_xor_b32 s1, s1, s11
s_sub_i32 s11, 0, s10
v_readfirstlane_b32 s16, v1
s_mul_i32 s11, s11, s16
s_mul_hi_u32 s11, s16, s11
s_add_i32 s16, s16, s11
s_mul_hi_u32 s11, s1, s16
s_mul_i32 s16, s11, s10
s_sub_i32 s1, s1, s16
s_add_i32 s16, s11, 1
s_sub_i32 s17, s1, s10
s_cmp_ge_u32 s1, s10
s_cselect_b32 s11, s16, s11
s_cselect_b32 s1, s17, s1
s_add_i32 s16, s11, 1
s_cmp_ge_u32 s1, s10
s_cselect_b32 s1, s16, s11
s_xor_b32 s1, s1, s9
s_load_dwordx4 s[28:31], s[4:5], 0x0
s_load_dwordx2 s[14:15], s[4:5], 0x10
s_sub_i32 s1, s1, s9
s_mul_i32 s16, s1, s7
s_add_i32 s1, s16, s1
s_min_i32 s33, s0, s1
s_cmp_ge_i32 s16, s33
v_mov_b32_e32 v29, 0xf149f2ca
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v2, 0
s_cbranch_scc1 1187
s_sub_i32 s0, 0, s2
s_ashr_i32 s1, s6, 31
s_mul_i32 s0, s0, s8
s_add_i32 s9, s6, s1
s_mul_hi_u32 s0, s8, s0
s_xor_b32 s9, s9, s1
s_add_i32 s8, s8, s0
s_mul_hi_u32 s0, s9, s8
s_xor_b32 s1, s1, s3
s_mul_i32 s3, s0, s2
s_sub_i32 s3, s9, s3
s_load_dwordx8 s[20:27], s[4:5], 0x28
s_add_i32 s4, s0, 1
s_sub_i32 s5, s3, s2
s_cmp_ge_u32 s3, s2
s_cselect_b32 s0, s4, s0
s_cselect_b32 s3, s5, s3
s_add_i32 s4, s0, 1
s_cmp_ge_u32 s3, s2
s_cselect_b32 s0, s4, s0
s_xor_b32 s0, s0, s1
s_sub_i32 s17, s0, s1
s_mul_hi_i32 s9, s13, s17
s_mul_i32 s8, s13, s17
s_lshl_b64 s[0:1], s[8:9], 3
s_waitcnt lgkmcnt(0)
s_add_u32 s34, s22, s0
s_addc_u32 s35, s23, s1
s_ashr_i32 s2, s13, 31
s_lshr_b32 s0, s2, 30
s_add_i32 s0, s13, s0
s_ashr_i32 s0, s0, 2
s_mul_hi_i32 s1, s0, s17
s_mul_i32 s0, s0, s17
s_lshl_b64 s[0:1], s[0:1], 10
s_add_u32 s38, s24, s0
s_addc_u32 s24, s25, s1
s_lshr_b32 s0, s2, 26
s_add_i32 s0, s13, s0
s_ashr_i32 s36, s0, 6
s_cmp_lg_u32 s19, 0
s_cselect_b64 s[22:23], -1, 0
v_mov_b32_e32 v5, s24
s_mul_hi_i32 s25, s36, s17
s_mul_i32 s24, s36, s17
s_ashr_i32 s17, s16, 31
v_lshrrev_b32_e32 v1, 2, v0
v_bfe_u32 v3, v0, 1, 1
s_lshl_b64 s[24:25], s[24:25], 10
s_lshl_b64 s[36:37], s[16:17], 10
v_mul_lo_u32 v17, v3, s13
s_add_u32 s13, s24, s36
v_lshl_or_b32 v9, s16, 6, v1
v_and_b32_e32 v2, 3, v0
v_mov_b32_e32 v4, 0x280
s_addc_u32 s17, s25, s37
v_ashrrev_i32_e32 v10, 31, v9
v_lshl_or_b32 v16, v3, 2, v4
v_and_b32_e32 v3, 31, v0
v_cmp_eq_u32_e64 s[2:3], 0, v2
v_lshlrev_b32_e32 v4, 6, v2
s_add_u32 s13, s26, s13
v_lshlrev_b64 v[1:2], 8, v[9:10]
v_cmp_eq_u32_e64 s[0:1], 0, v3
v_lshrrev_b32_e32 v3, 3, v0
s_addc_u32 s17, s27, s17
s_lshl_b64 s[8:9], s[8:9], 8
v_and_b32_e32 v3, 28, v3
v_mov_b32_e32 v6, s9
v_add_co_u32_e32 v1, vcc, s8, v1
v_or_b32_e32 v18, 0x240, v3
v_or_b32_e32 v19, 0x260, v3
v_lshlrev_b32_e32 v3, 2, v0
v_addc_co_u32_e32 v2, vcc, v6, v2, vcc
v_add_co_u32_e32 v26, vcc, s38, v3
v_addc_co_u32_e32 v27, vcc, 0, v5, vcc
v_or_b32_e32 v1, v1, v4
v_or_b32_e32 v22, 0x100, v4
v_mov_b32_e32 v4, s21
v_add_co_u32_e32 v10, vcc, s20, v1
v_addc_co_u32_e32 v11, vcc, v4, v2, vcc
s_movk_i32 s10, 0x100
v_mov_b32_e32 v1, s17
v_add_co_u32_e32 v12, vcc, s13, v3
v_and_b32_e32 v20, 0xfc, v0
v_cmp_gt_u32_e64 s[4:5], 16, v0
v_add_u32_e32 v21, 0x200, v3
v_cmp_gt_u32_e64 s[10:11], s10, v0
v_lshlrev_b32_e32 v23, 4, v0
v_mov_b32_e32 v24, 0
v_addc_co_u32_e32 v13, vcc, 0, v1, vcc
s_lshl_b32 s20, s16, 4
v_mov_b32_e32 v1, 0xf149f2ca
s_mov_b32 s13, 0xefa18f08
s_mov_b32 s17, 0xc2fc0000
s_mov_b32 s19, 0x42fe0000
s_mov_b32 s26, 0x2f800000
s_mov_b32 s27, 0xcf800000
s_movk_i32 s36, 0x7f
s_movk_i32 s37, 0x1000
s_movk_i32 s38, 0x2000
s_movk_i32 s39, 0x3000
s_mov_b32 s40, 0x7060503
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v28, 0
v_cmp_gt_i32_e32 vcc, s12, v9
v_mov_b32_e32 v2, 0xf149f2ca
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 128
global_load_dword v2, v[10:11], off
ds_read_b32 v3, v22
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v3, v2, v24
global_load_dword v3, v[10:11], off offset:4
ds_read_b32 v4, v22 offset:4
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:8
ds_read_b32 v4, v22 offset:8
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:12
ds_read_b32 v4, v22 offset:12
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:16
ds_read_b32 v4, v22 offset:16
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:20
ds_read_b32 v4, v22 offset:20
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:24
ds_read_b32 v4, v22 offset:24
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:28
ds_read_b32 v4, v22 offset:28
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:32
ds_read_b32 v4, v22 offset:32
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:36
ds_read_b32 v4, v22 offset:36
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:40
ds_read_b32 v4, v22 offset:40
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:44
ds_read_b32 v4, v22 offset:44
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:48
ds_read_b32 v4, v22 offset:48
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:52
ds_read_b32 v4, v22 offset:52
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:56
ds_read_b32 v4, v22 offset:56
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v2, v4, v3, v2
global_load_dword v3, v[10:11], off offset:60
ds_read_b32 v4, v22 offset:60
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v4, v4, v3, v2
v_add_u32_e32 v2, v9, v17
v_ashrrev_i32_e32 v3, 31, v2
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_mov_b32_e32 v5, s35
v_add_co_u32_e32 v2, vcc, s34, v2
v_addc_co_u32_e32 v3, vcc, v5, v3, vcc
global_load_dword v2, v[2:3], off
ds_read_b32 v3, v16
v_cvt_f32_i32_e32 v4, v4
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v3, v3, v4
s_waitcnt vmcnt(0)
v_mul_f32_e32 v2, v3, v2
s_or_b64 exec, exec, s[8:9]
v_mbcnt_lo_u32_b32 v3, -1, 0
v_mbcnt_hi_u32_b32 v4, -1, v3
v_and_b32_e32 v3, 64, v4
v_and_b32_e32 v6, 63, v4
v_add_u32_e32 v7, 64, v3
v_xor_b32_e32 v3, 1, v6
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v4, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v2
v_xor_b32_e32 v5, 2, v6
v_cmp_lt_i32_e32 vcc, v5, v7
v_xor_b32_e32 v8, 4, v6
v_xor_b32_e32 v15, 16, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v3
v_cndmask_b32_e32 v3, v4, v5, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v3, v3, v2
v_cmp_lt_i32_e32 vcc, v8, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v5, v2, v3
v_cndmask_b32_e32 v2, v4, v8, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v3, v2, v5
v_xor_b32_e32 v8, 8, v6
v_cmp_lt_i32_e32 vcc, v8, v7
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v3, v3, v3
v_max_f32_e32 v14, v5, v3
v_cndmask_b32_e32 v3, v4, v8, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v8, v3, v14
v_cmp_lt_i32_e32 vcc, v15, v7
v_cndmask_b32_e32 v4, v4, v15, vcc
v_lshlrev_b32_e32 v4, 2, v4
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v6, v8, v8
v_max_f32_e32 v6, v14, v6
ds_bpermute_b32 v7, v4, v6
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 6
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v7, v7, v7
v_max_f32_e32 v6, v6, v6
v_max_f32_e32 v6, v6, v7
ds_write_b32 v18, v6
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_read_b128 v[29:32], v24 offset:576
ds_read_b128 v[33:36], v24 offset:592
v_mov_b32_e32 v14, 0x1f800000
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v6, v30, v30
v_max_f32_e32 v7, v29, v29
v_max_f32_e32 v6, v7, v6
v_max3_f32 v6, v6, v31, v32
s_waitcnt lgkmcnt(0)
v_max3_f32 v6, v6, v33, v34
v_max3_f32 v6, v6, v35, v36
v_cmp_gt_f32_e32 vcc, s13, v6
v_cndmask_b32_e32 v6, v6, v1, vcc
v_max_f32_e32 v6, v6, v6
v_max_f32_e32 v7, v1, v1
v_max_f32_e32 v29, v7, v6
v_sub_f32_e32 v5, v5, v29
v_mul_f32_e32 v5, 0x3fb8aa3b, v5
v_cmp_gt_f32_e32 vcc, s17, v5
v_mov_b32_e32 v30, 0x42800000
v_cndmask_b32_e32 v7, 0, v30, vcc
v_add_f32_e32 v5, v5, v7
v_cndmask_b32_e32 v6, 1.0, v14, vcc
v_cmp_gt_f32_e32 vcc, s17, v5
v_cndmask_b32_e32 v7, 0, v30, vcc
v_add_f32_e32 v5, v5, v7
v_cndmask_b32_e32 v7, 1.0, v14, vcc
v_exp_f32_e32 v5, v5
v_mul_f32_e32 v5, v5, v7
v_mul_f32_e32 v31, v6, v5
ds_bpermute_b32 v2, v2, v31
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v31
ds_bpermute_b32 v3, v3, v2
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v3, v2
ds_bpermute_b32 v3, v4, v2
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 4
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v3, v2
ds_write_b32 v19, v2
s_or_b64 exec, exec, s[8:9]
v_sub_f32_e32 v1, v1, v29
v_mul_f32_e32 v15, 0x3fb8aa3b, v1
v_cmp_gt_f32_e64 s[8:9], s17, v15
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_read_b128 v[5:8], v24 offset:608
ds_read_b128 v[1:4], v24 offset:624
v_cndmask_b32_e64 v32, 0, v30, s[8:9]
v_add_f32_e32 v15, v15, v32
v_cmp_gt_f32_e32 vcc, s17, v15
v_cndmask_b32_e32 v30, 0, v30, vcc
v_cndmask_b32_e32 v14, 1.0, v14, vcc
s_and_saveexec_b64 s[24:25], s[2:3]
s_cbranch_execz 2
ds_write_b32 v20, v31
s_or_b64 exec, exec, s[24:25]
s_andn2_b64 vcc, exec, s[22:23]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccnz 75
s_and_saveexec_b64 s[24:25], s[4:5]
s_cbranch_execz 69
ds_read_b128 v[31:34], v23
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v31, 0x42fe0000, v31
v_mul_f32_e32 v32, 0x42fe0000, v32
v_rndne_f32_e32 v31, v31
v_rndne_f32_e32 v32, v32
v_mul_f32_e64 v35, |v31|, s26
v_mul_f32_e64 v37, |v32|, s26
v_floor_f32_e32 v35, v35
v_ashrrev_i32_e32 v36, 31, v31
v_fma_f32 v31, v35, s27, |v31|
v_floor_f32_e32 v35, v37
v_fma_f32 v35, v35, s27, |v32|
v_cvt_u32_f32_e32 v35, v35
v_ashrrev_i32_e32 v32, 31, v32
v_mul_f32_e32 v33, 0x42fe0000, v33
v_cvt_u32_f32_e32 v31, v31
v_xor_b32_e32 v35, v35, v32
v_rndne_f32_e32 v33, v33
v_sub_u32_e32 v32, v35, v32
v_mul_f32_e64 v35, |v33|, s26
v_floor_f32_e32 v35, v35
v_fma_f32 v35, v35, s27, |v33|
v_xor_b32_e32 v31, v31, v36
v_cvt_u32_f32_e32 v35, v35
v_sub_u32_e32 v31, v31, v36
v_med3_i32 v31, v31, 0, s36
v_med3_i32 v32, v32, 0, s36
v_lshl_or_b32 v31, v32, 8, v31
v_ashrrev_i32_e32 v32, 31, v33
v_xor_b32_e32 v33, v35, v32
v_sub_u32_e32 v32, v33, v32
v_mul_f32_e32 v33, 0x42fe0000, v34
v_rndne_f32_e32 v33, v33
v_mul_f32_e64 v34, |v33|, s26
v_floor_f32_e32 v34, v34
v_fma_f32 v34, v34, s27, |v33|
v_cvt_u32_f32_e32 v34, v34
v_mov_b32_e32 v36, 0x7f
v_med3_i32 v32, v32, 0, v36
v_lshl_or_b32 v31, v32, 16, v31
v_ashrrev_i32_e32 v32, 31, v33
v_xor_b32_e32 v33, v34, v32
v_sub_u32_e32 v32, v33, v32
v_med3_i32 v32, v32, 0, v36
v_lshl_or_b32 v31, v32, 24, v31
ds_write_b32 v21, v31
s_or_b64 exec, exec, s[24:25]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v15, v15, v30
v_mov_b32_e32 v30, 0x1f800000
v_exp_f32_e32 v15, v15
v_mul_f32_e32 v14, v15, v14
v_cndmask_b32_e64 v15, 1.0, v30, s[8:9]
v_mul_f32_e32 v30, v15, v14
v_mul_f32_e32 v25, v25, v30
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execz 669
s_ashr_i32 s21, s20, 31
s_lshl_b64 s[24:25], s[20:21], 10
v_mov_b32_e32 v15, s25
v_add_co_u32_e32 v14, vcc, s24, v26
v_addc_co_u32_e32 v15, vcc, v27, v15, vcc
global_load_dword v31, v[12:13], off
global_load_dword v34, v[14:15], off
s_andn2_b64 vcc, exec, s[22:23]
s_cbranch_vccnz 682
ds_read_b32 v32, v24 offset:512
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v32, v32, v34, v24
global_load_dword v33, v[14:15], off offset:1024
ds_read_b32 v35, v24 offset:516
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v32, v35, v33, v32
global_load_dword v33, v[14:15], off offset:2048
ds_read_b32 v35, v24 offset:520
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v32, v35, v33, v32
global_load_dword v33, v[14:15], off offset:3072
ds_read_b32 v35, v24 offset:524
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v35, v33, v32
v_add_co_u32_e32 v32, vcc, 0x1000, v14
v_addc_co_u32_e32 v33, vcc, 0, v15, vcc
global_load_dword v36, v[32:33], off
ds_read_b32 v37, v24 offset:528
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v36, v[32:33], off offset:1024
ds_read_b32 v37, v24 offset:532
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v36, v[32:33], off offset:2048
ds_read_b32 v37, v24 offset:536
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v32, v[32:33], off offset:3072
ds_read_b32 v33, v24 offset:540
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v37, v33, v32, v35
v_add_co_u32_e32 v32, vcc, s39, v14
v_addc_co_u32_e32 v33, vcc, 0, v15, vcc
global_load_dword v38, v[32:33], off offset:-4096
ds_read_b32 v39, v24 offset:544
v_add_co_u32_e32 v35, vcc, s38, v14
v_addc_co_u32_e32 v36, vcc, 0, v15, vcc
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v37, v39, v38, v37
global_load_dword v38, v[35:36], off offset:1024
ds_read_b32 v39, v24 offset:548
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v37, v39, v38, v37
global_load_dword v38, v[35:36], off offset:2048
ds_read_b32 v39, v24 offset:552
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v37, v39, v38, v37
global_load_dword v35, v[35:36], off offset:3072
ds_read_b32 v36, v24 offset:556
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v36, v35, v37
global_load_dword v36, v[32:33], off
ds_read_b32 v37, v24 offset:560
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v36, v[32:33], off offset:1024
ds_read_b32 v37, v24 offset:564
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v36, v[32:33], off offset:2048
ds_read_b32 v37, v24 offset:568
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v35, v37, v36, v35
global_load_dword v32, v[32:33], off offset:3072
ds_read_b32 v33, v24 offset:572
s_waitcnt vmcnt(0) lgkmcnt(0)
v_dot4_i32_i8 v32, v33, v32, v35
v_cvt_f32_i32_e32 v32, v32
v_div_scale_f32 v33, s[24:25], s19, s19, v32
v_div_scale_f32 v35, vcc, v32, s19, v32
v_rcp_f32_e32 v36, v33
v_fma_f32 v37, -v33, v36, 1.0
v_fmac_f32_e32 v36, v37, v36
v_mul_f32_e32 v37, v35, v36
v_fma_f32 v38, -v33, v37, v35
v_fmac_f32_e32 v37, v38, v36
v_fma_f32 v33, -v33, v37, v35
v_div_fmas_f32 v33, v33, v36, v37
v_div_fixup_f32 v32, v33, s19, v32
s_cbranch_execnz 519
s_waitcnt vmcnt(0)
v_and_b32_e32 v32, 0xff, v34
v_cmp_lt_u32_e32 vcc, s36, v32
v_mov_b32_e32 v33, 0xffffff00
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v32, v35, v32
v_cvt_f32_i32_e32 v32, v32
ds_read_b128 v[35:38], v24
ds_read_b128 v[39:42], v24 offset:16
ds_read_b128 v[43:46], v24 offset:32
ds_read_b128 v[47:50], v24 offset:48
s_waitcnt lgkmcnt(3)
v_fma_f32 v32, v35, v32, 0
v_bfe_u32 v35, v34, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v51, 0, v33, vcc
v_or_b32_e32 v35, v51, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v36, v35
v_bfe_u32 v35, v34, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v37, v35
v_ashrrev_i32_e32 v35, 31, v34
v_perm_b32 v34, v35, v34, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v38, v34
global_load_dword v34, v[14:15], off offset:1024
s_waitcnt vmcnt(0)
v_and_b32_e32 v35, 0xff, v34
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
s_waitcnt lgkmcnt(2)
v_fmac_f32_e32 v32, v39, v35
v_bfe_u32 v35, v34, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v40, v35
v_bfe_u32 v35, v34, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v41, v35
v_ashrrev_i32_e32 v35, 31, v34
v_perm_b32 v34, v35, v34, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v42, v34
global_load_dword v34, v[14:15], off offset:2048
s_waitcnt vmcnt(0)
v_and_b32_e32 v35, 0xff, v34
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
s_waitcnt lgkmcnt(1)
v_fmac_f32_e32 v32, v43, v35
v_bfe_u32 v35, v34, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v44, v35
v_bfe_u32 v35, v34, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v45, v35
v_ashrrev_i32_e32 v35, 31, v34
v_perm_b32 v34, v35, v34, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v46, v34
global_load_dword v34, v[14:15], off offset:3072
s_waitcnt vmcnt(0)
v_and_b32_e32 v35, 0xff, v34
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v47, v35
v_bfe_u32 v35, v34, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v48, v35
v_bfe_u32 v35, v34, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v35
v_cndmask_b32_e32 v36, 0, v33, vcc
v_add_co_u32_e32 v38, vcc, s37, v14
v_addc_co_u32_e32 v39, vcc, 0, v15, vcc
v_add_co_u32_e32 v40, vcc, s38, v14
v_addc_co_u32_e32 v41, vcc, 0, v15, vcc
global_load_dword v42, v[40:41], off offset:-4096
v_or_b32_e32 v35, v36, v35
v_cvt_f32_i32_e32 v35, v35
v_fmac_f32_e32 v32, v49, v35
v_ashrrev_i32_e32 v35, 31, v34
v_perm_b32 v34, v35, v34, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v50, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v42
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v43, v35, v34
ds_read_b128 v[34:37], v24 offset:64
v_cvt_f32_i32_e32 v43, v43
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v43
v_bfe_u32 v34, v42, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v43, 0, v33, vcc
v_or_b32_e32 v34, v43, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v42, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v42
v_perm_b32 v34, v34, v42, s40
global_load_dword v42, v[38:39], off offset:1024
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v42
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v43, v35, v34
ds_read_b128 v[34:37], v24 offset:80
v_cvt_f32_i32_e32 v43, v43
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v43
v_bfe_u32 v34, v42, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v43, 0, v33, vcc
v_or_b32_e32 v34, v43, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v42, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v42
v_perm_b32 v34, v34, v42, s40
global_load_dword v42, v[38:39], off offset:2048
v_cvt_f32_i32_e32 v34, v34
global_load_dword v38, v[38:39], off offset:3072
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(1)
v_and_b32_e32 v34, 0xff, v42
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v43, v35, v34
ds_read_b128 v[34:37], v24 offset:96
v_cvt_f32_i32_e32 v43, v43
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v43
v_bfe_u32 v34, v42, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v43, 0, v33, vcc
v_or_b32_e32 v34, v43, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v42, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v42
v_perm_b32 v34, v34, v42, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:112
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[40:41], off
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:128
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[40:41], off offset:1024
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:144
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[40:41], off offset:2048
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:160
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[40:41], off offset:3072
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:176
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_add_co_u32_e32 v14, vcc, s39, v14
v_addc_co_u32_e32 v15, vcc, 0, v15, vcc
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[14:15], off
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:192
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[14:15], off offset:1024
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(0)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:208
v_cvt_f32_i32_e32 v39, v39
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
global_load_dword v38, v[14:15], off offset:2048
v_cvt_f32_i32_e32 v34, v34
global_load_dword v14, v[14:15], off offset:3072
v_fmac_f32_e32 v32, v37, v34
s_waitcnt vmcnt(1)
v_and_b32_e32 v34, 0xff, v38
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v39, v35, v34
ds_read_b128 v[34:37], v24 offset:224
v_cvt_f32_i32_e32 v39, v39
s_waitcnt vmcnt(0)
v_and_b32_e32 v15, 0xff, v14
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v39
v_bfe_u32 v34, v38, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v39, 0, v33, vcc
v_or_b32_e32 v34, v39, v34
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v35, v34
v_bfe_u32 v34, v38, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v34
v_cndmask_b32_e32 v35, 0, v33, vcc
v_or_b32_e32 v34, v35, v34
v_cvt_f32_i32_e32 v34, v34
v_cmp_lt_u32_e32 vcc, s36, v15
v_fmac_f32_e32 v32, v36, v34
v_ashrrev_i32_e32 v34, 31, v38
v_perm_b32 v34, v34, v38, s40
v_cvt_f32_i32_e32 v34, v34
v_fmac_f32_e32 v32, v37, v34
v_cndmask_b32_e32 v34, 0, v33, vcc
v_or_b32_e32 v15, v34, v15
ds_read_b128 v[34:37], v24 offset:240
v_cvt_f32_i32_e32 v15, v15
s_waitcnt lgkmcnt(0)
v_fmac_f32_e32 v32, v34, v15
v_bfe_u32 v15, v14, 8, 8
v_cmp_lt_u32_e32 vcc, s36, v15
v_cndmask_b32_e32 v34, 0, v33, vcc
v_or_b32_e32 v15, v34, v15
v_cvt_f32_i32_e32 v15, v15
v_fmac_f32_e32 v32, v35, v15
v_bfe_u32 v15, v14, 16, 8
v_cmp_lt_u32_e32 vcc, s36, v15
v_cndmask_b32_e32 v33, 0, v33, vcc
v_or_b32_e32 v15, v33, v15
v_cvt_f32_i32_e32 v15, v15
v_fmac_f32_e32 v32, v36, v15
v_ashrrev_i32_e32 v15, 31, v14
v_perm_b32 v14, v15, v14, s40
v_cvt_f32_i32_e32 v14, v14
v_fmac_f32_e32 v32, v37, v14
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v25, v31, v32
s_or_b64 exec, exec, s[8:9]
v_add_f32_e32 v5, 0, v5
v_add_f32_e32 v5, v5, v6
v_add_f32_e32 v5, v5, v7
v_add_f32_e32 v5, v5, v8
v_add_f32_e32 v1, v5, v1
v_add_f32_e32 v1, v1, v2
v_add_co_u32_e32 v12, vcc, 0x400, v12
v_add_f32_e32 v1, v1, v3
v_addc_co_u32_e32 v13, vcc, 0, v13, vcc
v_add_f32_e32 v2, v1, v4
s_add_i32 s16, s16, 1
s_add_i32 s20, s20, 16
v_add_co_u32_e32 v10, vcc, 0x4000, v10
v_fmac_f32_e32 v2, v28, v30
v_add_u32_e32 v9, 64, v9
s_cmp_ge_i32 s16, s33
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
s_cbranch_scc1 4
v_mov_b32_e32 v1, v29
v_mov_b32_e32 v28, v2
s_branch 64478
s_branch 64990
s_movk_i32 s0, 0x100
v_cmp_gt_u32_e32 vcc, s0, v0
s_mul_hi_i32 s2, s18, s6
s_mul_i32 s3, s18, s6
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execnz 5
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execnz 18
s_endpgm
s_ashr_i32 s5, s7, 31
s_add_u32 s4, s3, s7
s_addc_u32 s5, s2, s5
s_lshl_b64 s[4:5], s[4:5], 10
v_lshl_or_b32 v1, v0, 2, s4
v_mov_b32_e32 v4, s5
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s29
v_add_co_u32_e32 v3, vcc, s28, v1
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v25, off
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 65518
s_ashr_i32 s1, s7, 31
s_add_u32 s0, s3, s7
s_addc_u32 s1, s2, s1
s_lshl_b64 s[0:1], s[0:1], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s2, s30, s0
s_addc_u32 s3, s31, s1
s_add_u32 s0, s14, s0
v_mov_b32_e32 v0, 0
s_addc_u32 s1, s15, s1
global_store_dword v0, v29, s[2:3]
global_store_dword v0, v2, s[0:1]
s_endpgm
