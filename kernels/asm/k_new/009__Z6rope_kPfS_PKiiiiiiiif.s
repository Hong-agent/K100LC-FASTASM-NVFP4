.text
k__Z6rope_kPfS_PKiiiiiiiif:
s_load_dwordx8 s[8:15], s[4:5], 0x18
s_load_dword s2, s[4:5], 0x44
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
s_waitcnt lgkmcnt(0)
s_mul_i32 s22, s11, s9
s_mul_i32 s0, s12, s10
s_ashr_i32 s20, s14, 1
s_add_i32 s10, s0, s22
s_add_u32 s0, s4, 56
s_addc_u32 s1, s5, 0
s_and_b32 s7, s2, 0xffff
v_mad_u64_u32 v[0:1], s[2:3], s7, v2, v[0:1]
s_mul_hi_i32 s25, s20, s10
s_mul_i32 s24, s20, s10
v_cmp_gt_i64_e32 vcc, s[24:25], v[0:1]
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 1320
s_load_dwordx4 s[16:19], s[4:5], 0x0
s_load_dwordx2 s[26:27], s[4:5], 0x10
s_load_dword s6, s[0:1], 0x0
v_frexp_mant_f32_e64 v2, |s15|
s_mov_b32 s0, 0x3f2aaaab
v_cmp_gt_f32_e32 vcc, s0, v2
v_cndmask_b32_e64 v3, 0, 1, vcc
v_ldexp_f32 v2, v2, v3
v_add_f32_e32 v4, 1.0, v2
v_add_f32_e32 v6, -1.0, v2
v_rcp_f32_e32 v5, v4
v_add_f32_e32 v7, -1.0, v4
v_sub_f32_e32 v2, v2, v7
v_frexp_exp_i32_f32_e64 v3, |s15|
v_mul_f32_e32 v7, v6, v5
v_mul_f32_e32 v8, v4, v7
v_fma_f32 v4, v7, v4, -v8
v_fmac_f32_e32 v4, v7, v2
v_add_f32_e32 v2, v8, v4
v_sub_f32_e32 v8, v2, v8
v_sub_f32_e32 v4, v4, v8
v_sub_f32_e32 v8, v6, v2
v_sub_f32_e32 v6, v6, v8
v_sub_f32_e32 v2, v6, v2
v_sub_f32_e32 v2, v2, v4
v_add_f32_e32 v2, v8, v2
v_mul_f32_e32 v2, v5, v2
v_add_f32_e32 v4, v7, v2
v_sub_f32_e32 v5, v4, v7
v_sub_f32_e32 v2, v2, v5
v_mul_f32_e32 v5, v4, v4
v_fma_f32 v6, v4, v4, -v5
v_add_f32_e32 v7, v2, v2
v_subbrev_co_u32_e32 v3, vcc, 0, v3, vcc
v_fmac_f32_e32 v6, v4, v7
v_add_f32_e32 v7, v5, v6
v_cvt_f32_i32_e32 v3, v3
v_sub_f32_e32 v5, v7, v5
v_sub_f32_e32 v5, v6, v5
v_mov_b32_e32 v6, 0x3e91f4c4
v_fmac_f32_e32 v6, 0x3e76c4e1, v7
v_mov_b32_e32 v8, 0x3ecccdef
v_fmac_f32_e32 v8, v7, v6
s_mov_b32 s0, 0x3f317218
v_mul_f32_e32 v6, 0x3f317218, v3
v_fma_f32 v9, v3, s0, -v6
v_mul_f32_e32 v10, v4, v7
v_fmac_f32_e32 v9, 0xb102e308, v3
v_fma_f32 v11, v7, v4, -v10
v_add_f32_e32 v3, v6, v9
v_fmac_f32_e32 v11, v7, v2
v_sub_f32_e32 v6, v3, v6
v_fmac_f32_e32 v11, v5, v4
v_sub_f32_e32 v6, v9, v6
v_ldexp_f32 v9, v4, 1
v_add_f32_e32 v4, v10, v11
v_sub_f32_e32 v10, v4, v10
v_sub_f32_e32 v10, v11, v10
v_mul_f32_e32 v11, v7, v8
v_fma_f32 v7, v7, v8, -v11
v_fmac_f32_e32 v7, v5, v8
v_add_f32_e32 v5, v11, v7
v_sub_f32_e32 v8, v5, v11
v_sub_f32_e32 v7, v7, v8
v_add_f32_e32 v8, 0x3f2aaaaa, v5
v_add_f32_e32 v11, 0xbf2aaaaa, v8
v_sub_f32_e32 v5, v5, v11
v_add_f32_e32 v7, 0x31739010, v7
v_add_f32_e32 v5, v7, v5
v_add_f32_e32 v7, v8, v5
v_sub_f32_e32 v8, v7, v8
v_sub_f32_e32 v5, v5, v8
v_mul_f32_e32 v8, v4, v7
v_fma_f32 v11, v4, v7, -v8
v_fmac_f32_e32 v11, v4, v5
v_fmac_f32_e32 v11, v10, v7
v_add_f32_e32 v4, v8, v11
v_sub_f32_e32 v5, v4, v8
v_add_f32_e32 v7, v9, v4
v_ldexp_f32 v2, v2, 1
v_sub_f32_e32 v5, v11, v5
v_sub_f32_e32 v8, v7, v9
v_sub_f32_e32 v4, v4, v8
v_add_f32_e32 v2, v2, v5
v_add_f32_e32 v2, v2, v4
v_add_f32_e32 v4, v7, v2
v_sub_f32_e32 v5, v4, v7
v_sub_f32_e32 v2, v2, v5
v_add_f32_e32 v5, v3, v4
v_sub_f32_e32 v7, v5, v3
v_sub_f32_e32 v8, v5, v7
v_sub_f32_e32 v3, v3, v8
v_sub_f32_e32 v4, v4, v7
v_add_f32_e32 v3, v4, v3
v_add_f32_e32 v4, v6, v2
v_sub_f32_e32 v7, v4, v6
v_add_f32_e32 v3, v4, v3
v_sub_f32_e32 v8, v4, v7
v_add_f32_e32 v4, v5, v3
v_sub_f32_e32 v6, v6, v8
v_sub_f32_e32 v2, v2, v7
v_sub_f32_e32 v5, v4, v5
v_add_f32_e32 v2, v2, v6
v_sub_f32_e32 v3, v3, v5
v_add_f32_e32 v2, v2, v3
v_add_f32_e32 v17, v4, v2
v_cvt_f32_i32_e32 v16, s14
v_sub_f32_e32 v3, v17, v4
s_ashr_i32 s21, s20, 31
s_ashr_i32 s29, s11, 31
s_mov_b32 s28, s11
s_mul_hi_i32 s23, s11, s9
s_ashr_i32 s11, s12, 31
s_ashr_i32 s31, s13, 31
v_sub_f32_e32 v18, v2, v3
v_mov_b32_e32 v2, 0x204
s_mov_b32 s30, s13
s_waitcnt lgkmcnt(0)
s_cmp_lg_u64 s[26:27], 0
v_cmp_class_f32_e32 vcc, s15, v2
v_cmp_eq_f32_e64 s[40:41], s15, 0
s_mul_hi_u32 s45, s7, s6
s_mul_i32 s44, s7, s6
v_lshlrev_b64 v[2:3], 2, v[0:1]
s_mov_b32 s10, s12
s_mov_b64 s[12:13], 0
s_cselect_b64 s[34:35], -1, 0
s_brev_b32 s9, -2
s_and_b32 s14, s15, 0x7fffffff
v_cmp_lt_f32_e64 s[36:37], s15, 0
v_cmp_nlt_f32_e64 s[38:39], s15, 0
v_cmp_eq_f32_e64 s[0:1], |s15|, 1.0
v_add_f32_e64 v19, |s15|, -1.0
s_movk_i32 s33, 0x204
s_or_b64 s[2:3], s[40:41], vcc
v_cmp_eq_f32_e64 s[42:43], s15, 1.0
s_sub_u32 s58, 0, s20
s_mov_b32 s59, 0x7f800000
s_mov_b32 s60, 0x42b17218
s_mov_b32 s61, 0x3fb8aa3b
s_mov_b32 s62, 0xc2fc0000
s_mov_b32 s63, 0xc2ce8ed0
s_brev_b32 s64, 18
s_mov_b32 s65, 0xfe5163ab
s_mov_b32 s66, 0x3c439041
s_mov_b32 s67, 0xdb629599
s_mov_b32 s68, 0xf534ddc0
s_mov_b32 s69, 0xfc2757d1
s_mov_b32 s70, 0x4e441529
s_mov_b32 s71, 0xa2f9836e
s_mov_b32 s72, 0x3fc90fda
s_movk_i32 s73, 0x1f8
s_lshl_b64 s[46:47], s[30:31], 2
s_lshl_b64 s[48:49], s[20:21], 2
s_lshl_b64 s[50:51], s[44:45], 2
s_branch 84
s_or_b64 exec, exec, s[6:7]
v_mad_u64_u32 v[8:9], s[6:7], v6, v12, v[8:9]
v_mul_lo_u32 v6, v6, v13
v_mul_lo_u32 v7, v7, v12
v_mul_lo_u32 v12, v8, s31
v_mul_lo_u32 v21, v5, s48
v_mul_lo_u32 v27, v4, s49
v_add3_u32 v9, v7, v9, v6
v_mad_u64_u32 v[6:7], s[6:7], v8, s30, 0
v_mul_lo_u32 v13, v9, s30
v_mad_u64_u32 v[4:5], s[6:7], v4, s48, 0
v_add3_u32 v7, v7, v12, v13
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_mul_lo_u32 v12, v8, s47
v_mul_lo_u32 v13, v9, s46
v_mad_u64_u32 v[8:9], s[6:7], v8, s46, 0
v_add_co_u32_e32 v28, vcc, v10, v6
v_addc_co_u32_e32 v29, vcc, v11, v7, vcc
v_add3_u32 v6, v9, v12, v13
v_add3_u32 v5, v5, v27, v21
v_sub_co_u32_e32 v4, vcc, v8, v4
v_subb_co_u32_e32 v5, vcc, v6, v5, vcc
v_add_co_u32_e32 v4, vcc, v10, v4
v_add3_u32 v6, v14, v0, s20
v_addc_co_u32_e32 v5, vcc, v11, v5, vcc
v_ashrrev_i32_e32 v7, 31, v6
v_add_co_u32_e32 v4, vcc, v4, v2
v_lshlrev_b64 v[6:7], 2, v[6:7]
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_add_co_u32_e32 v6, vcc, v28, v6
v_addc_co_u32_e32 v7, vcc, v29, v7, vcc
global_load_dword v8, v[4:5], off
global_load_dword v9, v[6:7], off
v_cmp_eq_u32_e32 vcc, 0, v25
v_cndmask_b32_e32 v10, v24, v22, vcc
v_xor_b32_e32 v11, v26, v20
v_mov_b32_e32 v13, s45
v_add_co_u32_e32 v0, vcc, s44, v0
v_xor_b32_e32 v10, v11, v10
v_addc_co_u32_e32 v1, vcc, v1, v13, vcc
v_mov_b32_e32 v12, 0x7fc00000
v_xor_b32_e32 v10, v10, v15
v_cmp_le_i64_e32 vcc, s[24:25], v[0:1]
v_cndmask_b32_e64 v10, v12, v10, s[4:5]
v_mov_b32_e32 v14, s51
s_or_b64 s[12:13], vcc, s[12:13]
v_add_co_u32_e32 v2, vcc, s50, v2
v_addc_co_u32_e32 v3, vcc, v3, v14, vcc
s_waitcnt vmcnt(1)
v_mul_f32_e32 v11, v8, v10
s_waitcnt vmcnt(0)
v_mul_f32_e32 v10, v9, v10
v_fma_f32 v8, v23, v8, -v10
v_fmac_f32_e32 v11, v23, v9
global_store_dword v[4:5], v8, off
global_store_dword v[6:7], v11, off
s_andn2_b64 exec, exec, s[12:13]
s_cbranch_execz 1033
v_or_b32_e32 v5, s21, v1
v_mov_b32_e32 v4, 0
v_cmp_ne_u64_e32 vcc, 0, v[4:5]
s_and_saveexec_b64 s[4:5], vcc
s_xor_b64 s[6:7], exec, s[4:5]
s_cbranch_execz 168
s_ashr_i32 s52, s21, 31
s_add_u32 s4, s20, s52
s_mov_b32 s53, s52
s_addc_u32 s5, s21, s52
s_xor_b64 s[54:55], s[4:5], s[52:53]
v_cvt_f32_u32_e32 v4, s54
v_cvt_f32_u32_e32 v5, s55
s_sub_u32 s4, 0, s54
s_subb_u32 s5, 0, s55
v_mac_f32_e32 v4, 0x4f800000, v5
s_nop 0
v_rcp_f32_e32 v4, v4
v_mul_f32_e32 v4, 0x5f7ffffc, v4
v_mul_f32_e32 v5, 0x2f800000, v4
v_trunc_f32_e32 v5, v5
v_mac_f32_e32 v4, 0xcf800000, v5
v_cvt_u32_f32_e32 v5, v5
v_cvt_u32_f32_e32 v4, v4
v_mul_lo_u32 v6, s4, v5
v_mul_hi_u32 v7, s4, v4
v_mul_lo_u32 v9, s5, v4
v_mul_lo_u32 v8, s4, v4
v_add_u32_e32 v6, v7, v6
v_add_u32_e32 v6, v6, v9
v_mul_hi_u32 v7, v4, v8
v_mul_lo_u32 v9, v4, v6
v_mul_hi_u32 v11, v4, v6
v_mul_lo_u32 v10, v5, v8
v_mul_hi_u32 v8, v5, v8
v_mul_hi_u32 v12, v5, v6
v_add_co_u32_e32 v7, vcc, v7, v9
v_addc_co_u32_e32 v9, vcc, 0, v11, vcc
v_mul_lo_u32 v6, v5, v6
v_add_co_u32_e32 v7, vcc, v7, v10
v_addc_co_u32_e32 v7, vcc, v9, v8, vcc
v_addc_co_u32_e32 v8, vcc, 0, v12, vcc
v_add_co_u32_e32 v6, vcc, v7, v6
v_addc_co_u32_e32 v7, vcc, 0, v8, vcc
v_add_co_u32_e32 v4, vcc, v4, v6
v_addc_co_u32_e32 v5, vcc, v5, v7, vcc
v_mul_lo_u32 v6, s4, v5
v_mul_hi_u32 v7, s4, v4
v_mul_lo_u32 v8, s5, v4
v_mul_lo_u32 v9, s4, v4
v_add_u32_e32 v6, v7, v6
v_add_u32_e32 v6, v6, v8
v_mul_lo_u32 v10, v4, v6
v_mul_hi_u32 v11, v4, v9
v_mul_hi_u32 v12, v4, v6
v_mul_hi_u32 v8, v5, v9
v_mul_lo_u32 v9, v5, v9
v_mul_hi_u32 v7, v5, v6
v_add_co_u32_e32 v10, vcc, v11, v10
v_addc_co_u32_e32 v11, vcc, 0, v12, vcc
v_mul_lo_u32 v6, v5, v6
v_add_co_u32_e32 v9, vcc, v10, v9
v_addc_co_u32_e32 v8, vcc, v11, v8, vcc
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
v_add_co_u32_e32 v6, vcc, v8, v6
v_addc_co_u32_e32 v7, vcc, 0, v7, vcc
v_add_co_u32_e32 v6, vcc, v4, v6
v_addc_co_u32_e32 v7, vcc, v5, v7, vcc
v_ashrrev_i32_e32 v8, 31, v1
v_add_co_u32_e32 v4, vcc, v0, v8
v_xor_b32_e32 v10, v4, v8
v_mad_u64_u32 v[4:5], s[4:5], v10, v7, 0
v_mul_hi_u32 v11, v10, v6
v_addc_co_u32_e32 v9, vcc, v1, v8, vcc
v_xor_b32_e32 v9, v9, v8
v_add_co_u32_e32 v11, vcc, v11, v4
v_addc_co_u32_e32 v12, vcc, 0, v5, vcc
v_mad_u64_u32 v[4:5], s[4:5], v9, v6, 0
v_mad_u64_u32 v[6:7], s[4:5], v9, v7, 0
v_add_co_u32_e32 v4, vcc, v11, v4
v_addc_co_u32_e32 v4, vcc, v12, v5, vcc
v_addc_co_u32_e32 v5, vcc, 0, v7, vcc
v_add_co_u32_e32 v6, vcc, v4, v6
v_addc_co_u32_e32 v7, vcc, 0, v5, vcc
v_mul_lo_u32 v11, s55, v6
v_mul_lo_u32 v12, s54, v7
v_mad_u64_u32 v[4:5], s[4:5], s54, v6, 0
v_add3_u32 v5, v5, v12, v11
v_sub_u32_e32 v11, v9, v5
v_mov_b32_e32 v12, s55
v_sub_co_u32_e32 v4, vcc, v10, v4
v_subb_co_u32_e64 v10, s[4:5], v11, v12, vcc
v_subrev_co_u32_e64 v11, s[4:5], s54, v4
v_subbrev_co_u32_e64 v10, s[4:5], 0, v10, s[4:5]
v_cmp_le_u32_e64 s[4:5], s55, v10
v_cndmask_b32_e64 v12, 0, -1, s[4:5]
v_cmp_le_u32_e64 s[4:5], s54, v11
v_cndmask_b32_e64 v11, 0, -1, s[4:5]
v_cmp_eq_u32_e64 s[4:5], s55, v10
v_cndmask_b32_e64 v10, v12, v11, s[4:5]
v_add_co_u32_e64 v11, s[4:5], 2, v6
v_subb_co_u32_e32 v5, vcc, v9, v5, vcc
v_addc_co_u32_e64 v12, s[4:5], 0, v7, s[4:5]
v_cmp_le_u32_e32 vcc, s55, v5
v_add_co_u32_e64 v13, s[4:5], 1, v6
v_cndmask_b32_e64 v9, 0, -1, vcc
v_cmp_le_u32_e32 vcc, s54, v4
v_addc_co_u32_e64 v14, s[4:5], 0, v7, s[4:5]
v_cndmask_b32_e64 v4, 0, -1, vcc
v_cmp_eq_u32_e32 vcc, s55, v5
v_cmp_ne_u32_e64 s[4:5], 0, v10
v_cndmask_b32_e32 v4, v9, v4, vcc
v_cndmask_b32_e64 v10, v14, v12, s[4:5]
v_cmp_ne_u32_e32 vcc, 0, v4
v_cndmask_b32_e64 v5, v13, v11, s[4:5]
v_cndmask_b32_e32 v4, v7, v10, vcc
v_cndmask_b32_e32 v5, v6, v5, vcc
v_xor_b32_e32 v6, s52, v8
v_xor_b32_e32 v7, v4, v6
v_xor_b32_e32 v4, v5, v6
v_sub_co_u32_e32 v4, vcc, v4, v6
v_subb_co_u32_e32 v5, vcc, v7, v6, vcc
s_andn2_saveexec_b64 s[4:5], s[6:7]
s_cbranch_execz 25
v_cvt_f32_u32_e32 v4, s20
s_sub_i32 s6, 0, s20
v_rcp_iflag_f32_e32 v4, v4
v_mul_f32_e32 v4, 0x4f7ffffe, v4
v_cvt_u32_f32_e32 v4, v4
v_mul_lo_u32 v5, s6, v4
v_mul_hi_u32 v5, v4, v5
v_add_u32_e32 v4, v4, v5
v_mul_hi_u32 v4, v0, v4
v_mul_lo_u32 v5, v4, s20
v_add_u32_e32 v6, 1, v4
v_sub_u32_e32 v5, v0, v5
v_subrev_u32_e32 v7, s20, v5
v_cmp_le_u32_e32 vcc, s20, v5
v_cndmask_b32_e32 v5, v5, v7, vcc
v_cndmask_b32_e32 v4, v4, v6, vcc
v_add_u32_e32 v6, 1, v4
v_cmp_le_u32_e32 vcc, s20, v5
v_cndmask_b32_e32 v4, v4, v6, vcc
v_mov_b32_e32 v5, 0
s_or_b64 exec, exec, s[4:5]
v_cmp_le_i64_e32 vcc, s[22:23], v[4:5]
s_and_saveexec_b64 s[4:5], vcc
s_xor_b64 s[6:7], exec, s[4:5]
s_cbranch_execz 215
v_mov_b32_e32 v6, s23
v_subrev_co_u32_e32 v8, vcc, s22, v4
v_subb_co_u32_e32 v9, vcc, v5, v6, vcc
v_or_b32_e32 v7, s11, v9
v_mov_b32_e32 v6, 0
v_cmp_ne_u64_e32 vcc, 0, v[6:7]
s_and_saveexec_b64 s[4:5], vcc
s_xor_b64 s[52:53], exec, s[4:5]
s_cbranch_execz 168
s_ashr_i32 s54, s11, 31
s_add_u32 s4, s10, s54
s_mov_b32 s55, s54
s_addc_u32 s5, s11, s54
s_xor_b64 s[56:57], s[4:5], s[54:55]
v_cvt_f32_u32_e32 v6, s56
v_cvt_f32_u32_e32 v7, s57
s_sub_u32 s4, 0, s56
s_subb_u32 s5, 0, s57
v_mac_f32_e32 v6, 0x4f800000, v7
s_nop 0
v_rcp_f32_e32 v6, v6
v_mul_f32_e32 v6, 0x5f7ffffc, v6
v_mul_f32_e32 v7, 0x2f800000, v6
v_trunc_f32_e32 v7, v7
v_mac_f32_e32 v6, 0xcf800000, v7
v_cvt_u32_f32_e32 v7, v7
v_cvt_u32_f32_e32 v6, v6
v_mul_lo_u32 v10, s4, v7
v_mul_hi_u32 v11, s4, v6
v_mul_lo_u32 v13, s5, v6
v_mul_lo_u32 v12, s4, v6
v_add_u32_e32 v10, v11, v10
v_add_u32_e32 v10, v10, v13
v_mul_hi_u32 v11, v6, v12
v_mul_lo_u32 v13, v6, v10
v_mul_hi_u32 v15, v6, v10
v_mul_lo_u32 v14, v7, v12
v_mul_hi_u32 v12, v7, v12
v_mul_hi_u32 v20, v7, v10
v_add_co_u32_e32 v11, vcc, v11, v13
v_addc_co_u32_e32 v13, vcc, 0, v15, vcc
v_mul_lo_u32 v10, v7, v10
v_add_co_u32_e32 v11, vcc, v11, v14
v_addc_co_u32_e32 v11, vcc, v13, v12, vcc
v_addc_co_u32_e32 v12, vcc, 0, v20, vcc
v_add_co_u32_e32 v10, vcc, v11, v10
v_addc_co_u32_e32 v11, vcc, 0, v12, vcc
v_add_co_u32_e32 v6, vcc, v6, v10
v_addc_co_u32_e32 v7, vcc, v7, v11, vcc
v_mul_lo_u32 v10, s4, v7
v_mul_hi_u32 v11, s4, v6
v_mul_lo_u32 v12, s5, v6
v_mul_lo_u32 v13, s4, v6
v_add_u32_e32 v10, v11, v10
v_add_u32_e32 v10, v10, v12
v_mul_lo_u32 v14, v6, v10
v_mul_hi_u32 v15, v6, v13
v_mul_hi_u32 v20, v6, v10
v_mul_hi_u32 v12, v7, v13
v_mul_lo_u32 v13, v7, v13
v_mul_hi_u32 v11, v7, v10
v_add_co_u32_e32 v14, vcc, v15, v14
v_addc_co_u32_e32 v15, vcc, 0, v20, vcc
v_mul_lo_u32 v10, v7, v10
v_add_co_u32_e32 v13, vcc, v14, v13
v_addc_co_u32_e32 v12, vcc, v15, v12, vcc
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_add_co_u32_e32 v10, vcc, v12, v10
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
v_add_co_u32_e32 v10, vcc, v6, v10
v_addc_co_u32_e32 v11, vcc, v7, v11, vcc
v_ashrrev_i32_e32 v12, 31, v9
v_add_co_u32_e32 v6, vcc, v8, v12
v_xor_b32_e32 v14, v6, v12
v_mad_u64_u32 v[6:7], s[4:5], v14, v11, 0
v_mul_hi_u32 v15, v14, v10
v_addc_co_u32_e32 v13, vcc, v9, v12, vcc
v_xor_b32_e32 v13, v13, v12
v_add_co_u32_e32 v15, vcc, v15, v6
v_addc_co_u32_e32 v20, vcc, 0, v7, vcc
v_mad_u64_u32 v[6:7], s[4:5], v13, v10, 0
v_mad_u64_u32 v[10:11], s[4:5], v13, v11, 0
v_add_co_u32_e32 v6, vcc, v15, v6
v_addc_co_u32_e32 v6, vcc, v20, v7, vcc
v_addc_co_u32_e32 v7, vcc, 0, v11, vcc
v_add_co_u32_e32 v10, vcc, v6, v10
v_addc_co_u32_e32 v11, vcc, 0, v7, vcc
v_mul_lo_u32 v15, s57, v10
v_mul_lo_u32 v20, s56, v11
v_mad_u64_u32 v[6:7], s[4:5], s56, v10, 0
v_add3_u32 v7, v7, v20, v15
v_sub_u32_e32 v15, v13, v7
v_mov_b32_e32 v20, s57
v_sub_co_u32_e32 v6, vcc, v14, v6
v_subb_co_u32_e64 v14, s[4:5], v15, v20, vcc
v_subrev_co_u32_e64 v15, s[4:5], s56, v6
v_subbrev_co_u32_e64 v14, s[4:5], 0, v14, s[4:5]
v_cmp_le_u32_e64 s[4:5], s57, v14
v_cndmask_b32_e64 v20, 0, -1, s[4:5]
v_cmp_le_u32_e64 s[4:5], s56, v15
v_cndmask_b32_e64 v15, 0, -1, s[4:5]
v_cmp_eq_u32_e64 s[4:5], s57, v14
v_cndmask_b32_e64 v14, v20, v15, s[4:5]
v_add_co_u32_e64 v15, s[4:5], 2, v10
v_subb_co_u32_e32 v7, vcc, v13, v7, vcc
v_addc_co_u32_e64 v20, s[4:5], 0, v11, s[4:5]
v_cmp_le_u32_e32 vcc, s57, v7
v_add_co_u32_e64 v21, s[4:5], 1, v10
v_cndmask_b32_e64 v13, 0, -1, vcc
v_cmp_le_u32_e32 vcc, s56, v6
v_addc_co_u32_e64 v22, s[4:5], 0, v11, s[4:5]
v_cndmask_b32_e64 v6, 0, -1, vcc
v_cmp_eq_u32_e32 vcc, s57, v7
v_cmp_ne_u32_e64 s[4:5], 0, v14
v_cndmask_b32_e32 v6, v13, v6, vcc
v_cndmask_b32_e64 v14, v22, v20, s[4:5]
v_cmp_ne_u32_e32 vcc, 0, v6
v_cndmask_b32_e64 v7, v21, v15, s[4:5]
v_cndmask_b32_e32 v6, v11, v14, vcc
v_cndmask_b32_e32 v7, v10, v7, vcc
v_xor_b32_e32 v10, s54, v12
v_xor_b32_e32 v11, v6, v10
v_xor_b32_e32 v6, v7, v10
v_sub_co_u32_e32 v6, vcc, v6, v10
v_subb_co_u32_e32 v7, vcc, v11, v10, vcc
s_andn2_saveexec_b64 s[4:5], s[52:53]
s_cbranch_execz 25
v_cvt_f32_u32_e32 v6, s10
s_sub_i32 s52, 0, s10
v_rcp_iflag_f32_e32 v6, v6
v_mul_f32_e32 v6, 0x4f7ffffe, v6
v_cvt_u32_f32_e32 v6, v6
v_mul_lo_u32 v7, s52, v6
v_mul_hi_u32 v7, v6, v7
v_add_u32_e32 v6, v6, v7
v_mul_hi_u32 v6, v8, v6
v_mul_lo_u32 v7, v6, s10
v_add_u32_e32 v10, 1, v6
v_sub_u32_e32 v7, v8, v7
v_subrev_u32_e32 v11, s10, v7
v_cmp_le_u32_e32 vcc, s10, v7
v_cndmask_b32_e32 v7, v7, v11, vcc
v_cndmask_b32_e32 v6, v6, v10, vcc
v_add_u32_e32 v10, 1, v6
v_cmp_le_u32_e32 vcc, s10, v7
v_cndmask_b32_e32 v6, v6, v10, vcc
v_mov_b32_e32 v7, 0
s_or_b64 exec, exec, s[4:5]
v_mul_lo_u32 v7, v7, s10
v_mul_lo_u32 v12, v6, s11
v_mad_u64_u32 v[10:11], s[4:5], v6, s10, 0
v_add3_u32 v7, v11, v12, v7
v_sub_co_u32_e32 v8, vcc, v8, v10
v_subb_co_u32_e32 v9, vcc, v9, v7, vcc
s_or_saveexec_b64 s[6:7], s[6:7]
v_mov_b32_e32 v13, s11
v_mov_b32_e32 v10, s18
v_mov_b32_e32 v12, s10
v_mov_b32_e32 v11, s19
s_xor_b64 exec, exec, s[6:7]
s_cbranch_execz 216
v_or_b32_e32 v7, s29, v5
v_mov_b32_e32 v6, 0
v_cmp_ne_u64_e32 vcc, 0, v[6:7]
s_and_saveexec_b64 s[4:5], vcc
s_xor_b64 s[52:53], exec, s[4:5]
s_cbranch_execz 168
s_ashr_i32 s54, s29, 31
s_add_u32 s4, s28, s54
s_mov_b32 s55, s54
s_addc_u32 s5, s29, s54
s_xor_b64 s[56:57], s[4:5], s[54:55]
v_cvt_f32_u32_e32 v6, s56
v_cvt_f32_u32_e32 v7, s57
s_sub_u32 s4, 0, s56
s_subb_u32 s5, 0, s57
v_mac_f32_e32 v6, 0x4f800000, v7
s_nop 0
v_rcp_f32_e32 v6, v6
v_mul_f32_e32 v6, 0x5f7ffffc, v6
v_mul_f32_e32 v7, 0x2f800000, v6
v_trunc_f32_e32 v7, v7
v_mac_f32_e32 v6, 0xcf800000, v7
v_cvt_u32_f32_e32 v7, v7
v_cvt_u32_f32_e32 v6, v6
v_mul_lo_u32 v8, s4, v7
v_mul_hi_u32 v9, s4, v6
v_mul_lo_u32 v11, s5, v6
v_mul_lo_u32 v10, s4, v6
v_add_u32_e32 v8, v9, v8
v_add_u32_e32 v8, v8, v11
v_mul_hi_u32 v9, v6, v10
v_mul_lo_u32 v11, v6, v8
v_mul_hi_u32 v13, v6, v8
v_mul_lo_u32 v12, v7, v10
v_mul_hi_u32 v10, v7, v10
v_mul_hi_u32 v14, v7, v8
v_add_co_u32_e32 v9, vcc, v9, v11
v_addc_co_u32_e32 v11, vcc, 0, v13, vcc
v_mul_lo_u32 v8, v7, v8
v_add_co_u32_e32 v9, vcc, v9, v12
v_addc_co_u32_e32 v9, vcc, v11, v10, vcc
v_addc_co_u32_e32 v10, vcc, 0, v14, vcc
v_add_co_u32_e32 v8, vcc, v9, v8
v_addc_co_u32_e32 v9, vcc, 0, v10, vcc
v_add_co_u32_e32 v6, vcc, v6, v8
v_addc_co_u32_e32 v7, vcc, v7, v9, vcc
v_mul_lo_u32 v8, s4, v7
v_mul_hi_u32 v9, s4, v6
v_mul_lo_u32 v10, s5, v6
v_mul_lo_u32 v11, s4, v6
v_add_u32_e32 v8, v9, v8
v_add_u32_e32 v8, v8, v10
v_mul_lo_u32 v12, v6, v8
v_mul_hi_u32 v13, v6, v11
v_mul_hi_u32 v14, v6, v8
v_mul_hi_u32 v10, v7, v11
v_mul_lo_u32 v11, v7, v11
v_mul_hi_u32 v9, v7, v8
v_add_co_u32_e32 v12, vcc, v13, v12
v_addc_co_u32_e32 v13, vcc, 0, v14, vcc
v_mul_lo_u32 v8, v7, v8
v_add_co_u32_e32 v11, vcc, v12, v11
v_addc_co_u32_e32 v10, vcc, v13, v10, vcc
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
v_add_co_u32_e32 v8, vcc, v10, v8
v_addc_co_u32_e32 v9, vcc, 0, v9, vcc
v_add_co_u32_e32 v8, vcc, v6, v8
v_addc_co_u32_e32 v9, vcc, v7, v9, vcc
v_ashrrev_i32_e32 v10, 31, v5
v_add_co_u32_e32 v6, vcc, v4, v10
v_xor_b32_e32 v12, v6, v10
v_mad_u64_u32 v[6:7], s[4:5], v12, v9, 0
v_mul_hi_u32 v13, v12, v8
v_addc_co_u32_e32 v11, vcc, v5, v10, vcc
v_xor_b32_e32 v11, v11, v10
v_add_co_u32_e32 v13, vcc, v13, v6
v_addc_co_u32_e32 v14, vcc, 0, v7, vcc
v_mad_u64_u32 v[6:7], s[4:5], v11, v8, 0
v_mad_u64_u32 v[8:9], s[4:5], v11, v9, 0
v_add_co_u32_e32 v6, vcc, v13, v6
v_addc_co_u32_e32 v6, vcc, v14, v7, vcc
v_addc_co_u32_e32 v7, vcc, 0, v9, vcc
v_add_co_u32_e32 v8, vcc, v6, v8
v_addc_co_u32_e32 v9, vcc, 0, v7, vcc
v_mul_lo_u32 v13, s57, v8
v_mul_lo_u32 v14, s56, v9
v_mad_u64_u32 v[6:7], s[4:5], s56, v8, 0
v_add3_u32 v7, v7, v14, v13
v_sub_u32_e32 v13, v11, v7
v_mov_b32_e32 v14, s57
v_sub_co_u32_e32 v6, vcc, v12, v6
v_subb_co_u32_e64 v12, s[4:5], v13, v14, vcc
v_subrev_co_u32_e64 v13, s[4:5], s56, v6
v_subbrev_co_u32_e64 v12, s[4:5], 0, v12, s[4:5]
v_cmp_le_u32_e64 s[4:5], s57, v12
v_cndmask_b32_e64 v14, 0, -1, s[4:5]
v_cmp_le_u32_e64 s[4:5], s56, v13
v_cndmask_b32_e64 v13, 0, -1, s[4:5]
v_cmp_eq_u32_e64 s[4:5], s57, v12
v_cndmask_b32_e64 v12, v14, v13, s[4:5]
v_add_co_u32_e64 v13, s[4:5], 2, v8
v_subb_co_u32_e32 v7, vcc, v11, v7, vcc
v_addc_co_u32_e64 v14, s[4:5], 0, v9, s[4:5]
v_cmp_le_u32_e32 vcc, s57, v7
v_add_co_u32_e64 v15, s[4:5], 1, v8
v_cndmask_b32_e64 v11, 0, -1, vcc
v_cmp_le_u32_e32 vcc, s56, v6
v_addc_co_u32_e64 v20, s[4:5], 0, v9, s[4:5]
v_cndmask_b32_e64 v6, 0, -1, vcc
v_cmp_eq_u32_e32 vcc, s57, v7
v_cmp_ne_u32_e64 s[4:5], 0, v12
v_cndmask_b32_e32 v6, v11, v6, vcc
v_cndmask_b32_e64 v12, v20, v14, s[4:5]
v_cmp_ne_u32_e32 vcc, 0, v6
v_cndmask_b32_e64 v7, v15, v13, s[4:5]
v_cndmask_b32_e32 v6, v9, v12, vcc
v_cndmask_b32_e32 v7, v8, v7, vcc
v_xor_b32_e32 v8, s54, v10
v_xor_b32_e32 v9, v6, v8
v_xor_b32_e32 v6, v7, v8
v_sub_co_u32_e32 v6, vcc, v6, v8
v_subb_co_u32_e32 v7, vcc, v9, v8, vcc
s_andn2_saveexec_b64 s[4:5], s[52:53]
s_cbranch_execz 25
v_cvt_f32_u32_e32 v6, s28
s_sub_i32 s52, 0, s28
v_rcp_iflag_f32_e32 v6, v6
v_mul_f32_e32 v6, 0x4f7ffffe, v6
v_cvt_u32_f32_e32 v6, v6
v_mul_lo_u32 v7, s52, v6
v_mul_hi_u32 v7, v6, v7
v_add_u32_e32 v6, v6, v7
v_mul_hi_u32 v6, v4, v6
v_mul_lo_u32 v7, v6, s28
v_add_u32_e32 v8, 1, v6
v_sub_u32_e32 v7, v4, v7
v_subrev_u32_e32 v9, s28, v7
v_cmp_le_u32_e32 vcc, s28, v7
v_cndmask_b32_e32 v7, v7, v9, vcc
v_cndmask_b32_e32 v6, v6, v8, vcc
v_add_u32_e32 v8, 1, v6
v_cmp_le_u32_e32 vcc, s28, v7
v_cndmask_b32_e32 v6, v6, v8, vcc
v_mov_b32_e32 v7, 0
s_or_b64 exec, exec, s[4:5]
v_mul_lo_u32 v9, v7, s28
v_mul_lo_u32 v10, v6, s29
v_mad_u64_u32 v[7:8], s[4:5], v6, s28, 0
v_mov_b32_e32 v12, s28
v_mov_b32_e32 v13, s29
v_add3_u32 v9, v8, v10, v9
v_sub_co_u32_e32 v8, vcc, v4, v7
v_mov_b32_e32 v10, s16
v_subb_co_u32_e32 v9, vcc, v5, v9, vcc
v_mov_b32_e32 v11, s17
s_or_b64 exec, exec, s[6:7]
s_andn2_b64 vcc, exec, s[34:35]
v_ashrrev_i32_e32 v7, 31, v6
s_cbranch_vccnz 384
v_lshlrev_b64 v[14:15], 2, v[6:7]
v_mov_b32_e32 v20, s27
v_add_co_u32_e32 v14, vcc, s26, v14
v_addc_co_u32_e32 v15, vcc, v20, v15, vcc
global_load_dword v20, v[14:15], off
s_cbranch_execnz 2
s_waitcnt vmcnt(0)
v_add_u32_e32 v20, s8, v6
v_mad_u64_u32 v[14:15], s[4:5], s58, v4, 0
v_mov_b32_e32 v28, s15
v_bfrev_b32_e32 v27, 1
v_add_lshl_u32 v15, v14, v0, 1
v_cvt_f32_i32_e32 v15, v15
v_mov_b32_e32 v26, 0x7f800000
s_waitcnt vmcnt(0)
v_cvt_f32_i32_e32 v20, v20
v_div_scale_f32 v21, s[4:5], v16, v16, v15
v_div_scale_f32 v22, vcc, v15, v16, v15
v_rcp_f32_e32 v23, v21
v_fma_f32 v24, -v21, v23, 1.0
v_fmac_f32_e32 v23, v24, v23
v_mul_f32_e32 v24, v22, v23
v_fma_f32 v25, -v21, v24, v22
v_fmac_f32_e32 v24, v25, v23
v_fma_f32 v21, -v21, v24, v22
v_div_fmas_f32 v22, v21, v23, v24
v_mov_b32_e32 v23, 0x37000000
v_mov_b32_e32 v24, 0x42800000
v_mov_b32_e32 v25, 0x1f800000
v_mov_b32_e32 v21, 0x7fc00000
v_div_fixup_f32 v15, v22, v16, v15
v_mul_f32_e32 v22, v17, v15
v_trunc_f32_e64 v29, |v15|
v_fma_f32 v30, v15, v17, -v22
v_mul_f32_e32 v31, 0.5, v29
v_fmac_f32_e32 v30, v15, v18
v_fract_f32_e32 v32, v31
v_cmp_neq_f32_e32 vcc, s59, v31
v_add_f32_e32 v33, v22, v30
v_cndmask_b32_e32 v31, 0, v32, vcc
v_cmp_class_f32_e64 vcc, v22, s33
v_cmp_eq_f32_e64 s[6:7], |v15|, v29
v_sub_f32_e32 v32, v33, v22
v_cndmask_b32_e32 v22, v33, v22, vcc
v_cmp_eq_f32_e32 vcc, 0, v31
v_cndmask_b32_e64 v29, 0, 1, s[6:7]
v_cmp_eq_f32_e64 s[4:5], s60, v22
s_and_b64 vcc, s[6:7], vcc
v_cndmask_b32_e64 v23, 0, v23, s[4:5]
v_addc_co_u32_e32 v29, vcc, 0, v29, vcc
v_sub_f32_e32 v30, v30, v32
v_cmp_neq_f32_e64 vcc, |v22|, s59
v_sub_f32_e32 v22, v22, v23
v_cndmask_b32_e32 v30, 0, v30, vcc
v_cmp_ne_u32_e32 vcc, 0, v29
v_cmp_eq_u32_e64 s[4:5], 1, v29
v_mul_f32_e32 v29, 0x3fb8aa3b, v22
v_add_f32_e32 v23, v23, v30
v_fma_f32 v30, v22, s61, -v29
v_rndne_f32_e32 v31, v29
v_fmac_f32_e32 v30, 0x32a5705f, v22
v_sub_f32_e32 v29, v29, v31
v_add_f32_e32 v29, v30, v29
v_cmp_gt_f32_e64 s[6:7], s62, v29
v_cndmask_b32_e64 v24, 0, v24, s[6:7]
v_add_f32_e32 v24, v29, v24
v_cvt_i32_f32_e32 v31, v31
v_exp_f32_e32 v24, v24
v_cndmask_b32_e64 v25, 1.0, v25, s[6:7]
v_cndmask_b32_e64 v28, 0, v28, s[4:5]
s_and_b64 s[4:5], s[36:37], s[4:5]
v_mul_f32_e32 v24, v24, v25
v_cndmask_b32_e64 v27, 0, v27, s[4:5]
v_ldexp_f32 v24, v24, v31
v_cmp_ngt_f32_e64 s[4:5], s63, v22
v_cndmask_b32_e64 v24, 0, v24, s[4:5]
v_cmp_nlt_f32_e64 s[4:5], s60, v22
v_cndmask_b32_e64 v22, v26, v24, s[4:5]
v_fma_f32 v23, v22, v23, v22
v_cmp_class_f32_e64 s[4:5], v22, s33
v_cndmask_b32_e64 v22, v23, v22, s[4:5]
v_bfi_b32 v22, s9, v22, v27
s_or_b64 vcc, s[38:39], vcc
v_xor_b32_e32 v23, v15, v19
v_cndmask_b32_e32 v22, v21, v22, vcc
v_cmp_lt_i32_e32 vcc, -1, v23
v_cndmask_b32_e32 v23, 0, v26, vcc
v_mov_b32_e32 v24, s14
v_cndmask_b32_e64 v23, v23, v24, s[0:1]
v_cmp_class_f32_e64 vcc, v15, s33
v_cndmask_b32_e32 v22, v22, v23, vcc
v_cmp_gt_f32_e32 vcc, 0, v15
s_xor_b64 s[4:5], s[40:41], vcc
v_cndmask_b32_e64 v23, v26, 0, s[4:5]
v_bfi_b32 v23, s9, v23, v28
v_cndmask_b32_e64 v22, v22, v23, s[2:3]
v_cmp_o_f32_e32 vcc, s15, v15
v_cndmask_b32_e32 v22, v21, v22, vcc
v_cmp_eq_f32_e32 vcc, 0, v15
s_or_b64 s[4:5], s[42:43], vcc
v_cndmask_b32_e64 v15, v22, 1.0, s[4:5]
v_div_scale_f32 v22, s[4:5], v15, v15, v20
v_div_scale_f32 v23, vcc, v20, v15, v20
v_rcp_f32_e32 v24, v22
v_fma_f32 v25, -v22, v24, 1.0
v_fmac_f32_e32 v24, v25, v24
v_mul_f32_e32 v25, v23, v24
v_fma_f32 v26, -v22, v25, v23
v_fmac_f32_e32 v25, v26, v24
v_fma_f32 v22, -v22, v25, v23
v_div_fmas_f32 v22, v22, v24, v25
v_div_fixup_f32 v20, v22, v15, v20
v_and_b32_e32 v15, 0x7fffffff, v20
v_cmp_nlt_f32_e64 s[6:7], |v20|, s64
s_and_saveexec_b64 s[52:53], s[6:7]
s_xor_b64 s[6:7], exec, s[52:53]
s_cbranch_execz 158
v_and_b32_e32 v22, 0x7fffff, v15
v_or_b32_e32 v31, 0x800000, v22
v_mad_u64_u32 v[22:23], s[4:5], v31, s65, 0
v_mov_b32_e32 v24, 0
v_lshrrev_b32_e32 v30, 23, v15
v_mad_u64_u32 v[25:26], s[4:5], v31, s66, v[23:24]
v_add_u32_e32 v33, 0xffffff88, v30
v_mov_b32_e32 v32, 0xffffffc0
v_mov_b32_e32 v23, v26
v_mad_u64_u32 v[26:27], s[4:5], v31, s67, v[23:24]
v_cmp_lt_u32_e32 vcc, 63, v33
v_cndmask_b32_e32 v32, 0, v32, vcc
v_mov_b32_e32 v23, v27
v_mad_u64_u32 v[27:28], s[4:5], v31, s68, v[23:24]
v_add_u32_e32 v32, v32, v33
v_cndmask_b32_e32 v33, v26, v22, vcc
v_mov_b32_e32 v23, v28
v_mad_u64_u32 v[28:29], s[4:5], v31, s69, v[23:24]
v_mov_b32_e32 v23, v29
v_mad_u64_u32 v[29:30], s[4:5], v31, s70, v[23:24]
v_cmp_lt_u32_e64 s[4:5], 31, v32
v_mov_b32_e32 v23, v30
v_mad_u64_u32 v[22:23], s[52:53], v31, s71, v[23:24]
v_cndmask_b32_e32 v24, v27, v25, vcc
v_cndmask_b32_e32 v25, v28, v26, vcc
v_cndmask_b32_e32 v26, v29, v27, vcc
v_mov_b32_e32 v27, 0xffffffe0
v_cndmask_b32_e32 v22, v22, v28, vcc
v_cndmask_b32_e64 v28, 0, v27, s[4:5]
v_cndmask_b32_e32 v23, v23, v29, vcc
v_add_u32_e32 v28, v28, v32
v_cndmask_b32_e64 v23, v23, v22, s[4:5]
v_cndmask_b32_e64 v22, v22, v26, s[4:5]
v_cndmask_b32_e64 v26, v26, v25, s[4:5]
v_cndmask_b32_e64 v25, v25, v24, s[4:5]
v_cndmask_b32_e64 v24, v24, v33, s[4:5]
v_cmp_lt_u32_e32 vcc, 31, v28
v_cndmask_b32_e32 v23, v23, v22, vcc
v_cndmask_b32_e32 v22, v22, v26, vcc
v_cndmask_b32_e32 v26, v26, v25, vcc
v_cndmask_b32_e32 v24, v25, v24, vcc
v_cndmask_b32_e32 v25, 0, v27, vcc
v_add_u32_e32 v25, v25, v28
v_sub_u32_e32 v27, 32, v25
v_alignbit_b32 v28, v23, v22, v27
v_alignbit_b32 v29, v22, v26, v27
v_alignbit_b32 v27, v26, v24, v27
v_cmp_eq_u32_e32 vcc, 0, v25
v_cndmask_b32_e32 v23, v28, v23, vcc
v_cndmask_b32_e32 v22, v29, v22, vcc
v_cndmask_b32_e32 v25, v27, v26, vcc
v_alignbit_b32 v27, v23, v22, 30
v_alignbit_b32 v22, v22, v25, 30
v_alignbit_b32 v24, v25, v24, 30
v_bfe_u32 v25, v23, 29, 1
v_sub_u32_e32 v28, 0, v25
v_xor_b32_e32 v27, v28, v27
v_xor_b32_e32 v22, v28, v22
v_xor_b32_e32 v24, v28, v24
v_ffbh_u32_e32 v28, v27
v_min_u32_e32 v28, 32, v28
v_lshrrev_b32_e32 v26, 29, v23
v_sub_u32_e32 v29, 31, v28
v_lshlrev_b32_e32 v26, 31, v26
v_alignbit_b32 v27, v27, v22, v29
v_alignbit_b32 v22, v22, v24, v29
v_lshlrev_b32_e32 v29, 23, v28
v_lshrrev_b32_e32 v24, 9, v27
v_sub_u32_e32 v29, v26, v29
v_alignbit_b32 v27, v27, v22, 9
v_or_b32_e32 v24, v29, v24
v_ffbh_u32_e32 v29, v27
v_min_u32_e32 v29, 32, v29
v_sub_u32_e32 v31, 31, v29
v_alignbit_b32 v22, v27, v22, v31
v_lshrrev_b32_e32 v22, 9, v22
v_add_lshl_u32 v27, v29, v28, 23
v_add_u32_e32 v24, 0.5, v24
v_sub_u32_e32 v22, v22, v27
v_mul_f32_e32 v30, 0x3fc90fda, v24
v_add_u32_e32 v22, 0x33000000, v22
v_or_b32_e32 v22, v22, v26
v_fma_f32 v26, v24, s72, -v30
v_fmac_f32_e32 v26, 0x33a22168, v24
v_fmac_f32_e32 v26, 0x3fc90fda, v22
v_add_f32_e32 v22, v30, v26
v_lshrrev_b32_e32 v23, 30, v23
v_add_u32_e32 v23, v25, v23
v_mul_f32_e32 v24, v22, v22
v_mov_b32_e32 v25, 0x3c0881c4
v_fmac_f32_e32 v25, 0xb94c1982, v24
v_mov_b32_e32 v26, 0xbe2aaa9d
v_fmac_f32_e32 v26, v24, v25
v_mul_f32_e32 v25, v24, v26
v_fmac_f32_e32 v22, v22, v25
v_mov_b32_e32 v25, 0xbab64f3b
v_fmac_f32_e32 v25, 0x37d75334, v24
v_mov_b32_e32 v26, 0x3d2aabf7
v_fmac_f32_e32 v26, v24, v25
v_mov_b32_e32 v25, 0xbf000004
v_fmac_f32_e32 v25, v24, v26
v_fma_f32 v24, v24, v25, 1.0
v_and_b32_e32 v25, 1, v23
v_cmp_eq_u32_e32 vcc, 0, v25
v_lshlrev_b32_e32 v23, 30, v23
v_cndmask_b32_e64 v27, -v22, v24, vcc
v_and_b32_e32 v26, 0x80000000, v23
v_xor_b32_e32 v23, v27, v26
v_cmp_class_f32_e64 vcc, v15, s73
v_cndmask_b32_e32 v23, v21, v23, vcc
s_and_b64 s[4:5], vcc, exec
s_andn2_saveexec_b64 s[6:7], s[6:7]
s_cbranch_execz 64470
v_mul_f32_e32 v21, 0x3f22f983, v15
v_rndne_f32_e32 v21, v21
v_mov_b32_e32 v22, v15
v_fmac_f32_e32 v22, 0xbfc90fda, v21
v_fmac_f32_e32 v22, 0xb3a22168, v21
v_fmac_f32_e32 v22, 0xa7c234c4, v21
v_mul_f32_e32 v23, v22, v22
v_mov_b32_e32 v24, 0x3c0881c4
v_fmac_f32_e32 v24, 0xb94c1982, v23
v_mov_b32_e32 v25, 0xbe2aaa9d
v_fmac_f32_e32 v25, v23, v24
v_cvt_i32_f32_e32 v21, v21
v_mul_f32_e32 v24, v23, v25
v_fmac_f32_e32 v22, v22, v24
v_mov_b32_e32 v24, 0xbab64f3b
v_fmac_f32_e32 v24, 0x37d75334, v23
v_mov_b32_e32 v25, 0x3d2aabf7
v_fmac_f32_e32 v25, v23, v24
v_mov_b32_e32 v24, 0xbf000004
v_fmac_f32_e32 v24, v23, v25
v_and_b32_e32 v25, 1, v21
v_fma_f32 v24, v23, v24, 1.0
v_cmp_eq_u32_e32 vcc, 0, v25
v_lshlrev_b32_e32 v21, 30, v21
v_cndmask_b32_e64 v23, -v22, v24, vcc
v_and_b32_e32 v26, 0x80000000, v21
v_cmp_class_f32_e64 vcc, v15, s73
v_xor_b32_e32 v21, v23, v26
v_mov_b32_e32 v23, 0x7fc00000
s_andn2_b64 s[4:5], s[4:5], exec
s_and_b64 s[52:53], vcc, exec
v_cndmask_b32_e32 v23, v23, v21, vcc
s_or_b64 s[4:5], s[4:5], s[52:53]
s_branch 64420
s_branch 65159
s_endpgm
