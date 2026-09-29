.text
k__Z14attn_q_quant_kPjPfPKfiiiii:
s_load_dwordx4 s[8:11], s[4:5], 0x18
s_load_dword s0, s[4:5], 0x3c
s_mov_b32 s7, 0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s1, s11, 31
s_add_i32 s2, s11, s1
s_xor_b32 s2, s2, s1
v_cvt_f32_u32_e32 v1, s2
s_sub_i32 s14, 0, s2
s_ashr_i32 s3, s10, 31
s_add_i32 s13, s10, s3
v_rcp_iflag_f32_e32 v1, v1
s_xor_b32 s13, s13, s3
s_xor_b32 s12, s3, s1
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s15, v1
s_mul_i32 s14, s14, s15
s_mul_hi_u32 s14, s15, s14
s_add_i32 s15, s15, s14
s_mul_hi_u32 s14, s13, s15
s_mul_i32 s15, s14, s2
s_sub_i32 s13, s13, s15
s_add_i32 s16, s14, 1
s_sub_i32 s15, s13, s2
s_cmp_ge_u32 s13, s2
s_cselect_b32 s14, s16, s14
s_cselect_b32 s13, s15, s13
s_add_i32 s15, s14, 1
s_cmp_ge_u32 s13, s2
s_cselect_b32 s2, s15, s14
s_xor_b32 s2, s2, s12
s_sub_i32 s30, s2, s12
s_add_u32 s18, s4, 48
s_addc_u32 s19, s5, 0
s_and_b32 s20, s0, 0xffff
s_mul_i32 s31, s30, s8
s_mul_i32 s6, s6, s20
s_mul_i32 s33, s31, s9
v_add_u32_e32 v9, s6, v0
v_cmp_gt_i32_e32 vcc, s33, v9
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 457
s_cmp_gt_i32 s11, 0
s_load_dword s34, s[4:5], 0x28
s_load_dwordx4 s[12:15], s[4:5], 0x0
s_load_dwordx2 s[16:17], s[4:5], 0x10
s_load_dword s38, s[18:19], 0x0
s_cselect_b64 s[4:5], -1, 0
s_lshr_b32 s6, s3, 30
s_add_i32 s6, s10, s6
s_mov_b32 s2, s10
s_ashr_i32 s10, s6, 2
s_ashr_i32 s35, s30, 31
s_waitcnt lgkmcnt(0)
s_ashr_i32 s36, s34, 31
s_ashr_i32 s37, s10, 31
s_and_b32 s39, s11, 3
s_cmp_gt_u32 s11, 3
s_cselect_b64 s[18:19], -1, 0
s_and_b32 s40, s11, -4
s_cmp_lg_u32 s39, 0
s_mov_b32 s0, s11
s_mul_i32 s38, s38, s20
s_cselect_b64 s[20:21], -1, 0
s_add_u32 s41, s16, 8
s_addc_u32 s42, s17, 0
s_lshl_b64 s[22:23], s[2:3], 2
s_lshl_b64 s[24:25], s[0:1], 2
s_mov_b64 s[26:27], 0
s_mov_b32 s43, 0x42fe0000
s_mov_b32 s44, 0x2f800000
s_mov_b32 s45, 0xcf800000
s_movk_i32 s46, 0xff80
s_mov_b32 s47, 0xc0c0500
v_mov_b32_e32 v10, 0x7f
s_branch 5
v_add_u32_e32 v9, s38, v9
v_cmp_le_i32_e32 vcc, s33, v9
s_or_b64 s[26:27], vcc, s[26:27]
s_andn2_b64 exec, exec, s[26:27]
s_cbranch_execz 409
s_add_i32 s0, s35, s30
s_xor_b32 s0, s0, s35
v_cvt_f32_u32_e32 v0, s0
s_ashr_i32 s1, s8, 31
s_add_i32 s3, s1, s8
s_xor_b32 s1, s3, s1
v_rcp_iflag_f32_e32 v0, v0
v_cvt_f32_u32_e32 v5, s1
v_ashrrev_i32_e32 v1, 31, v9
v_add_u32_e32 v3, v1, v9
v_mul_f32_e32 v0, 0x4f7ffffe, v0
v_cvt_u32_f32_e32 v0, v0
v_rcp_iflag_f32_e32 v5, v5
v_xor_b32_e32 v3, v3, v1
s_ashr_i32 s2, s31, 31
v_mul_lo_u32 v4, s0, v0
s_add_i32 s3, s2, s31
s_xor_b32 s3, s3, s2
v_cvt_f32_u32_e32 v6, s3
v_sub_u32_e32 v4, 0, v4
v_mul_hi_u32 v4, v4, v0
v_xor_b32_e32 v2, s35, v1
v_rcp_iflag_f32_e32 v6, v6
v_xor_b32_e32 v1, s2, v1
v_add_u32_e32 v0, v4, v0
v_mul_hi_u32 v0, v3, v0
v_mul_f32_e32 v4, 0x4f7ffffe, v5
v_cvt_u32_f32_e32 v4, v4
v_mul_lo_u32 v5, v0, s0
v_add_u32_e32 v8, 1, v0
v_mul_lo_u32 v7, s1, v4
v_sub_u32_e32 v5, v3, v5
v_cmp_le_u32_e32 vcc, s0, v5
v_cndmask_b32_e32 v0, v0, v8, vcc
v_subrev_u32_e32 v8, s0, v5
v_cndmask_b32_e32 v5, v5, v8, vcc
v_cmp_le_u32_e32 vcc, s0, v5
v_sub_u32_e32 v5, 0, v7
v_mul_hi_u32 v5, v5, v4
v_add_u32_e32 v8, 1, v0
v_cndmask_b32_e32 v0, v0, v8, vcc
v_xor_b32_e32 v0, v0, v2
v_add_u32_e32 v4, v5, v4
v_mul_f32_e32 v5, 0x4f7ffffe, v6
v_cvt_u32_f32_e32 v5, v5
v_sub_u32_e32 v0, v0, v2
v_ashrrev_i32_e32 v2, 31, v0
v_add_u32_e32 v7, v2, v0
v_mul_lo_u32 v6, s3, v5
v_xor_b32_e32 v7, v7, v2
v_mul_hi_u32 v4, v7, v4
v_mul_lo_u32 v0, v0, s30
v_sub_u32_e32 v6, 0, v6
v_mul_hi_u32 v6, v6, v5
v_mul_lo_u32 v4, v4, s1
v_sub_u32_e32 v0, v9, v0
v_add_u32_e32 v5, v6, v5
v_sub_u32_e32 v4, v7, v4
v_mul_hi_u32 v5, v3, v5
v_subrev_u32_e32 v7, s1, v4
v_cmp_le_u32_e32 vcc, s1, v4
v_cndmask_b32_e32 v4, v4, v7, vcc
v_subrev_u32_e32 v6, s1, v4
v_cmp_le_u32_e32 vcc, s1, v4
v_cndmask_b32_e32 v4, v4, v6, vcc
v_mul_lo_u32 v6, v5, s3
v_xor_b32_e32 v4, v4, v2
v_sub_u32_e32 v4, v4, v2
v_sub_u32_e32 v2, v3, v6
v_add_u32_e32 v3, 1, v5
v_cmp_le_u32_e32 vcc, s3, v2
v_cndmask_b32_e32 v3, v5, v3, vcc
v_subrev_u32_e32 v5, s3, v2
v_cndmask_b32_e32 v2, v2, v5, vcc
v_add_u32_e32 v5, 1, v3
v_cmp_le_u32_e32 vcc, s3, v2
v_cndmask_b32_e32 v2, v3, v5, vcc
v_xor_b32_e32 v2, v2, v1
v_sub_u32_e32 v6, v2, v1
v_ashrrev_i32_e32 v7, 31, v6
v_mad_i64_i32 v[2:3], s[0:1], v4, s9, v[6:7]
s_andn2_b64 vcc, exec, s[4:5]
v_ashrrev_i32_e32 v1, 31, v0
s_cbranch_vccnz 39
s_andn2_b64 vcc, exec, s[18:19]
s_cbranch_vccnz 39
v_mul_lo_u32 v5, v1, s24
v_mul_lo_u32 v11, v0, s25
v_mad_u64_u32 v[7:8], s[0:1], v0, s24, 0
v_add3_u32 v8, v8, v11, v5
v_mul_lo_u32 v5, v2, s23
v_mul_lo_u32 v11, v3, s22
v_mad_u64_u32 v[7:8], s[0:1], v2, s22, v[7:8]
s_mov_b32 s0, 0
v_add3_u32 v5, v11, v8, v5
v_mov_b32_e32 v8, s42
v_add_co_u32_e32 v7, vcc, s41, v7
v_addc_co_u32_e32 v8, vcc, v8, v5, vcc
v_mov_b32_e32 v11, 0
global_load_dwordx4 v[12:15], v[7:8], off offset:-8
s_add_i32 s0, s0, 4
v_add_co_u32_e32 v7, vcc, 16, v7
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_cmp_eq_u32 s40, s0
s_waitcnt vmcnt(0)
v_max3_f32 v5, v11, |v12|, |v13|
v_max3_f32 v11, v5, |v14|, |v15|
s_cbranch_scc0 65524
s_mov_b32 s6, s40
s_andn2_b64 vcc, exec, s[20:21]
s_cbranch_vccz 7
s_branch 41
v_mov_b32_e32 v11, 0
s_branch 39
s_mov_b32 s6, 0
v_mov_b32_e32 v11, 0
s_andn2_b64 vcc, exec, s[20:21]
s_cbranch_vccnz 35
v_mul_lo_u32 v5, v1, s24
v_mul_lo_u32 v12, v0, s25
v_mad_u64_u32 v[7:8], s[0:1], v0, s24, 0
v_add3_u32 v8, v8, v12, v5
v_mul_lo_u32 v5, v2, s23
v_mul_lo_u32 v12, v3, s22
v_mad_u64_u32 v[7:8], s[0:1], v2, s22, v[7:8]
s_lshl_b64 s[0:1], s[6:7], 2
s_add_u32 s0, s16, s0
s_addc_u32 s1, s17, s1
v_add3_u32 v5, v12, v8, v5
v_mov_b32_e32 v8, s1
v_add_co_u32_e32 v7, vcc, s0, v7
v_addc_co_u32_e32 v8, vcc, v8, v5, vcc
s_mov_b32 s0, s39
global_load_dword v5, v[7:8], off
v_max_f32_e32 v11, v11, v11
v_add_co_u32_e32 v7, vcc, 4, v7
s_add_i32 s0, s0, -1
v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
s_cmp_lg_u32 s0, 0
s_waitcnt vmcnt(0)
v_max_f32_e64 v5, |v5|, |v5|
v_max_f32_e32 v11, v11, v5
s_cbranch_scc1 65524
v_div_scale_f32 v12, s[0:1], s43, s43, v11
v_div_scale_f32 v13, vcc, v11, s43, v11
v_mad_i64_i32 v[7:8], s[0:1], v6, s30, v[0:1]
v_ashrrev_i32_e32 v5, 31, v4
v_rcp_f32_e32 v14, v12
v_fma_f32 v15, -v12, v14, 1.0
v_fmac_f32_e32 v14, v15, v14
v_mul_f32_e32 v15, v13, v14
v_fma_f32 v16, -v12, v15, v13
v_fmac_f32_e32 v15, v16, v14
v_fma_f32 v12, -v12, v15, v13
v_div_fmas_f32 v14, v12, v14, v15
v_mul_lo_u32 v12, v7, s36
v_mul_lo_u32 v13, v8, s34
v_mad_u64_u32 v[7:8], s[0:1], v7, s34, v[4:5]
v_mov_b32_e32 v15, s15
v_add3_u32 v8, v13, v8, v12
v_lshlrev_b64 v[7:8], 2, v[7:8]
v_add_co_u32_e32 v12, vcc, s14, v7
v_addc_co_u32_e32 v13, vcc, v15, v8, vcc
v_cmp_lt_f32_e32 vcc, 0, v11
v_div_fixup_f32 v7, v14, s43, v11
v_cndmask_b32_e32 v7, 1.0, v7, vcc
s_andn2_b64 vcc, exec, s[4:5]
global_store_dword v[12:13], v7, off
s_cbranch_vccnz 65310
v_mad_i64_i32 v[4:5], s[0:1], v6, s34, v[4:5]
v_mul_lo_u32 v12, v0, s11
v_mov_b32_e32 v11, s13
v_mul_lo_u32 v6, v5, s10
v_mul_lo_u32 v8, v4, s37
v_mad_u64_u32 v[4:5], s[0:1], v4, s10, 0
s_mov_b64 s[28:29], 0
v_add3_u32 v5, v5, v8, v6
v_mul_lo_u32 v6, v1, s24
v_mul_lo_u32 v8, v0, s25
v_mad_u64_u32 v[0:1], s[0:1], v0, s24, 0
v_lshlrev_b64 v[4:5], 2, v[4:5]
v_add3_u32 v1, v1, v8, v6
v_add_co_u32_e32 v4, vcc, s12, v4
v_mad_u64_u32 v[0:1], s[0:1], v2, s22, v[0:1]
v_mul_lo_u32 v6, v2, s23
v_mul_lo_u32 v8, v3, s22
v_addc_co_u32_e32 v5, vcc, v11, v5, vcc
v_ashrrev_i32_e32 v11, 31, v12
v_and_b32_e32 v12, -4, v12
v_add_co_u32_e32 v2, vcc, v4, v12
v_addc_co_u32_e32 v3, vcc, v5, v11, vcc
v_add3_u32 v1, v8, v1, v6
v_mov_b32_e32 v4, s42
v_add_co_u32_e32 v0, vcc, s41, v0
v_addc_co_u32_e32 v1, vcc, v4, v1, vcc
global_load_dwordx4 v[11:14], v[0:1], off offset:-8
v_mov_b32_e32 v5, s29
v_add_co_u32_e32 v4, vcc, s28, v2
v_addc_co_u32_e32 v5, vcc, v3, v5, vcc
s_add_u32 s28, s28, 4
s_addc_u32 s29, s29, 0
s_cmp_lt_i32 s28, s11
s_waitcnt vmcnt(0)
v_div_scale_f32 v6, s[0:1], v7, v7, v11
v_div_scale_f32 v8, s[0:1], v7, v7, v12
v_div_scale_f32 v15, vcc, v11, v7, v11
v_div_scale_f32 v16, s[0:1], v12, v7, v12
v_rcp_f32_e32 v17, v6
v_rcp_f32_e32 v18, v8
v_fma_f32 v19, -v6, v17, 1.0
v_fmac_f32_e32 v17, v19, v17
v_fma_f32 v20, -v8, v18, 1.0
v_mul_f32_e32 v19, v15, v17
v_fmac_f32_e32 v18, v20, v18
v_fma_f32 v20, -v6, v19, v15
v_fmac_f32_e32 v19, v20, v17
v_div_scale_f32 v20, s[2:3], v7, v7, v13
v_fma_f32 v6, -v6, v19, v15
v_div_scale_f32 v15, s[2:3], v7, v7, v14
v_div_fmas_f32 v6, v6, v17, v19
v_mul_f32_e32 v17, v16, v18
v_fma_f32 v19, -v8, v17, v16
v_fmac_f32_e32 v17, v19, v18
v_div_scale_f32 v19, s[2:3], v13, v7, v13
v_fma_f32 v8, -v8, v17, v16
s_mov_b64 vcc, s[0:1]
v_div_fmas_f32 v8, v8, v18, v17
v_add_co_u32_e32 v0, vcc, 16, v0
v_rcp_f32_e32 v16, v20
v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
v_rcp_f32_e32 v17, v15
v_fma_f32 v18, -v20, v16, 1.0
v_fmac_f32_e32 v16, v18, v16
s_mov_b64 vcc, s[2:3]
v_fma_f32 v18, -v15, v17, 1.0
v_fmac_f32_e32 v17, v18, v17
v_mul_f32_e32 v18, v19, v16
v_fma_f32 v21, -v20, v18, v19
v_fmac_f32_e32 v18, v21, v16
v_div_scale_f32 v21, s[0:1], v14, v7, v14
v_fma_f32 v19, -v20, v18, v19
v_div_fmas_f32 v16, v19, v16, v18
s_mov_b64 vcc, s[0:1]
v_div_fixup_f32 v6, v6, v7, v11
v_rndne_f32_e32 v6, v6
v_div_fixup_f32 v8, v8, v7, v12
v_mul_f32_e64 v11, |v6|, s44
v_rndne_f32_e32 v8, v8
v_floor_f32_e32 v11, v11
v_ashrrev_i32_e32 v12, 31, v6
v_fma_f32 v6, v11, s45, |v6|
v_cvt_u32_f32_e32 v6, v6
v_mul_f32_e32 v22, v21, v17
v_fma_f32 v23, -v15, v22, v21
v_fmac_f32_e32 v22, v23, v17
v_fma_f32 v15, -v15, v22, v21
v_div_fmas_f32 v15, v15, v17, v22
v_div_fixup_f32 v13, v16, v7, v13
v_mul_f32_e64 v16, |v8|, s44
v_rndne_f32_e32 v13, v13
v_floor_f32_e32 v11, v16
v_ashrrev_i32_e32 v17, 31, v8
v_fma_f32 v8, v11, s45, |v8|
v_ashrrev_i32_e32 v16, 31, v13
v_cvt_u32_f32_e32 v8, v8
v_xor_b32_e32 v6, v6, v12
v_sub_u32_e32 v6, v6, v12
v_med3_i32 v6, v6, s46, v10
v_xor_b32_e32 v8, v8, v17
v_sub_u32_e32 v8, v8, v17
v_med3_i32 v8, v8, s46, v10
v_lshlrev_b32_e32 v8, 8, v8
v_div_fixup_f32 v14, v15, v7, v14
v_mul_f32_e64 v15, |v13|, s44
v_rndne_f32_e32 v14, v14
v_floor_f32_e32 v11, v15
v_mul_f32_e64 v15, |v14|, s44
v_fma_f32 v11, v11, s45, |v13|
v_floor_f32_e32 v13, v15
v_cvt_u32_f32_e32 v11, v11
v_fma_f32 v13, v13, s45, |v14|
v_cvt_u32_f32_e32 v13, v13
v_ashrrev_i32_e32 v18, 31, v14
v_xor_b32_e32 v11, v11, v16
v_sub_u32_e32 v11, v11, v16
v_xor_b32_e32 v12, v13, v18
v_med3_i32 v11, v11, s46, v10
v_sub_u32_e32 v12, v12, v18
v_perm_b32 v6, v8, v6, s47
v_lshlrev_b32_e32 v8, 16, v11
v_med3_i32 v11, v12, s46, v10
v_and_b32_e32 v8, 0xff0000, v8
v_lshlrev_b32_e32 v11, 24, v11
v_or3_b32 v6, v6, v8, v11
global_store_dword v[4:5], v6, off
s_cbranch_scc1 65390
s_branch 65122
s_endpgm
