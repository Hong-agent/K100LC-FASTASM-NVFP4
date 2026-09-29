.text
k__Z14gather_heads_kPfPKfiiiiix:
s_load_dword s2, s[4:5], 0x3c
s_load_dwordx2 s[0:1], s[4:5], 0x28
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v1, v2
v_mov_b32_e32 v3, s6
s_waitcnt lgkmcnt(0)
s_and_b32 s2, s2, 0xffff
v_mad_u64_u32 v[0:1], s[2:3], s2, v3, v[0:1]
v_cmp_gt_i64_e32 vcc, s[0:1], v[0:1]
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 465
s_load_dwordx4 s[8:11], s[4:5], 0x10
s_load_dword s14, s[4:5], 0x20
s_waitcnt lgkmcnt(0)
s_ashr_i32 s15, s9, 31
v_or_b32_e32 v3, s15, v1
v_cmp_ne_u64_e32 vcc, 0, v[2:3]
s_and_saveexec_b64 s[0:1], vcc
s_xor_b64 s[2:3], exec, s[0:1]
s_cbranch_execz 169
s_add_u32 s0, s9, s15
s_mov_b32 s6, s15
s_mov_b32 s7, s15
s_addc_u32 s1, s15, s15
s_xor_b64 s[12:13], s[0:1], s[6:7]
v_cvt_f32_u32_e32 v2, s12
v_cvt_f32_u32_e32 v3, s13
s_sub_u32 s0, 0, s12
s_subb_u32 s1, 0, s13
v_mac_f32_e32 v2, 0x4f800000, v3
s_nop 0
v_rcp_f32_e32 v2, v2
v_mul_f32_e32 v2, 0x5f7ffffc, v2
v_mul_f32_e32 v3, 0x2f800000, v2
v_trunc_f32_e32 v3, v3
v_mac_f32_e32 v2, 0xcf800000, v3
v_cvt_u32_f32_e32 v3, v3
v_cvt_u32_f32_e32 v2, v2
v_mul_lo_u32 v4, s0, v3
v_mul_hi_u32 v5, s0, v2
v_mul_lo_u32 v7, s1, v2
v_mul_lo_u32 v6, s0, v2
v_add_u32_e32 v4, v5, v4
v_add_u32_e32 v4, v4, v7
v_mul_hi_u32 v5, v2, v6
v_mul_lo_u32 v7, v2, v4
v_mul_hi_u32 v9, v2, v4
v_mul_lo_u32 v8, v3, v6
v_mul_hi_u32 v6, v3, v6
v_mul_hi_u32 v10, v3, v4
v_add_co_u32_e32 v5, vcc, v5, v7
v_addc_co_u32_e32 v7, vcc, 0, v9, vcc
v_mul_lo_u32 v4, v3, v4
v_add_co_u32_e32 v5, vcc, v5, v8
v_addc_co_u32_e32 v5, vcc, v7, v6, vcc
v_addc_co_u32_e32 v6, vcc, 0, v10, vcc
v_add_co_u32_e32 v4, vcc, v5, v4
v_addc_co_u32_e32 v5, vcc, 0, v6, vcc
v_add_co_u32_e32 v2, vcc, v2, v4
v_addc_co_u32_e32 v3, vcc, v3, v5, vcc
v_mul_lo_u32 v4, s0, v3
v_mul_hi_u32 v5, s0, v2
v_mul_lo_u32 v6, s1, v2
v_mul_lo_u32 v7, s0, v2
v_add_u32_e32 v4, v5, v4
v_add_u32_e32 v4, v4, v6
v_mul_lo_u32 v8, v2, v4
v_mul_hi_u32 v9, v2, v7
v_mul_hi_u32 v10, v2, v4
v_mul_hi_u32 v6, v3, v7
v_mul_lo_u32 v7, v3, v7
v_mul_hi_u32 v5, v3, v4
v_add_co_u32_e32 v8, vcc, v9, v8
v_addc_co_u32_e32 v9, vcc, 0, v10, vcc
v_mul_lo_u32 v4, v3, v4
v_add_co_u32_e32 v7, vcc, v8, v7
v_addc_co_u32_e32 v6, vcc, v9, v6, vcc
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_add_co_u32_e32 v4, vcc, v6, v4
v_addc_co_u32_e32 v5, vcc, 0, v5, vcc
v_add_co_u32_e32 v4, vcc, v2, v4
v_addc_co_u32_e32 v5, vcc, v3, v5, vcc
v_ashrrev_i32_e32 v6, 31, v1
v_add_co_u32_e32 v2, vcc, v0, v6
v_xor_b32_e32 v8, v2, v6
v_mad_u64_u32 v[2:3], s[0:1], v8, v5, 0
v_mul_hi_u32 v9, v8, v4
v_addc_co_u32_e32 v7, vcc, v1, v6, vcc
v_xor_b32_e32 v7, v7, v6
v_add_co_u32_e32 v9, vcc, v9, v2
v_addc_co_u32_e32 v10, vcc, 0, v3, vcc
v_mad_u64_u32 v[2:3], s[0:1], v7, v4, 0
v_mad_u64_u32 v[4:5], s[0:1], v7, v5, 0
v_add_co_u32_e32 v2, vcc, v9, v2
v_addc_co_u32_e32 v2, vcc, v10, v3, vcc
v_addc_co_u32_e32 v3, vcc, 0, v5, vcc
v_add_co_u32_e32 v4, vcc, v2, v4
v_addc_co_u32_e32 v5, vcc, 0, v3, vcc
v_mul_lo_u32 v9, s13, v4
v_mul_lo_u32 v10, s12, v5
v_mad_u64_u32 v[2:3], s[0:1], s12, v4, 0
v_add3_u32 v3, v3, v10, v9
v_sub_u32_e32 v9, v7, v3
v_mov_b32_e32 v10, s13
v_sub_co_u32_e32 v2, vcc, v8, v2
v_subb_co_u32_e64 v8, s[0:1], v9, v10, vcc
v_subrev_co_u32_e64 v9, s[0:1], s12, v2
v_subbrev_co_u32_e64 v8, s[0:1], 0, v8, s[0:1]
v_cmp_le_u32_e64 s[0:1], s13, v8
v_cndmask_b32_e64 v10, 0, -1, s[0:1]
v_cmp_le_u32_e64 s[0:1], s12, v9
v_cndmask_b32_e64 v9, 0, -1, s[0:1]
v_cmp_eq_u32_e64 s[0:1], s13, v8
v_cndmask_b32_e64 v8, v10, v9, s[0:1]
v_add_co_u32_e64 v9, s[0:1], 2, v4
v_subb_co_u32_e32 v3, vcc, v7, v3, vcc
v_addc_co_u32_e64 v10, s[0:1], 0, v5, s[0:1]
v_cmp_le_u32_e32 vcc, s13, v3
v_add_co_u32_e64 v11, s[0:1], 1, v4
v_cndmask_b32_e64 v7, 0, -1, vcc
v_cmp_le_u32_e32 vcc, s12, v2
v_addc_co_u32_e64 v12, s[0:1], 0, v5, s[0:1]
v_cndmask_b32_e64 v2, 0, -1, vcc
v_cmp_eq_u32_e32 vcc, s13, v3
v_cmp_ne_u32_e64 s[0:1], 0, v8
v_cndmask_b32_e32 v2, v7, v2, vcc
v_cndmask_b32_e64 v8, v12, v10, s[0:1]
v_cmp_ne_u32_e32 vcc, 0, v2
v_cndmask_b32_e64 v3, v11, v9, s[0:1]
v_cndmask_b32_e32 v2, v5, v8, vcc
v_cndmask_b32_e32 v3, v4, v3, vcc
v_xor_b32_e32 v4, s7, v6
v_xor_b32_e32 v5, s6, v6
v_xor_b32_e32 v6, v2, v4
v_xor_b32_e32 v2, v3, v5
v_sub_co_u32_e32 v2, vcc, v2, v5
v_subb_co_u32_e32 v3, vcc, v6, v4, vcc
s_andn2_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 25
v_cvt_f32_u32_e32 v2, s9
s_sub_i32 s2, 0, s9
v_rcp_iflag_f32_e32 v2, v2
v_mul_f32_e32 v2, 0x4f7ffffe, v2
v_cvt_u32_f32_e32 v2, v2
v_mul_lo_u32 v3, s2, v2
v_mul_hi_u32 v3, v2, v3
v_add_u32_e32 v2, v2, v3
v_mul_hi_u32 v2, v0, v2
v_mul_lo_u32 v3, v2, s9
v_add_u32_e32 v4, 1, v2
v_sub_u32_e32 v3, v0, v3
v_subrev_u32_e32 v5, s9, v3
v_cmp_le_u32_e32 vcc, s9, v3
v_cndmask_b32_e32 v3, v3, v5, vcc
v_cndmask_b32_e32 v2, v2, v4, vcc
v_add_u32_e32 v4, 1, v2
v_cmp_le_u32_e32 vcc, s9, v3
v_cndmask_b32_e32 v2, v2, v4, vcc
v_mov_b32_e32 v3, 0
s_or_b64 exec, exec, s[0:1]
s_ashr_i32 s16, s8, 31
v_or_b32_e32 v5, s16, v3
v_mov_b32_e32 v4, 0
v_cmp_ne_u64_e32 vcc, 0, v[4:5]
s_and_saveexec_b64 s[0:1], vcc
s_xor_b64 s[2:3], exec, s[0:1]
s_cbranch_execz 169
s_add_u32 s0, s8, s16
s_mov_b32 s6, s16
s_mov_b32 s7, s16
s_addc_u32 s1, s16, s16
s_xor_b64 s[12:13], s[0:1], s[6:7]
v_cvt_f32_u32_e32 v4, s12
v_cvt_f32_u32_e32 v5, s13
s_sub_u32 s0, 0, s12
s_subb_u32 s1, 0, s13
v_mac_f32_e32 v4, 0x4f800000, v5
s_nop 0
v_rcp_f32_e32 v4, v4
v_mul_f32_e32 v4, 0x5f7ffffc, v4
v_mul_f32_e32 v5, 0x2f800000, v4
v_trunc_f32_e32 v5, v5
v_mac_f32_e32 v4, 0xcf800000, v5
v_cvt_u32_f32_e32 v5, v5
v_cvt_u32_f32_e32 v4, v4
v_mul_lo_u32 v6, s0, v5
v_mul_hi_u32 v7, s0, v4
v_mul_lo_u32 v9, s1, v4
v_mul_lo_u32 v8, s0, v4
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
v_mul_lo_u32 v6, s0, v5
v_mul_hi_u32 v7, s0, v4
v_mul_lo_u32 v8, s1, v4
v_mul_lo_u32 v9, s0, v4
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
v_ashrrev_i32_e32 v8, 31, v3
v_add_co_u32_e32 v4, vcc, v2, v8
v_xor_b32_e32 v10, v4, v8
v_mad_u64_u32 v[4:5], s[0:1], v10, v7, 0
v_mul_hi_u32 v11, v10, v6
v_addc_co_u32_e32 v9, vcc, v3, v8, vcc
v_xor_b32_e32 v9, v9, v8
v_add_co_u32_e32 v11, vcc, v11, v4
v_addc_co_u32_e32 v12, vcc, 0, v5, vcc
v_mad_u64_u32 v[4:5], s[0:1], v9, v6, 0
v_mad_u64_u32 v[6:7], s[0:1], v9, v7, 0
v_add_co_u32_e32 v4, vcc, v11, v4
v_addc_co_u32_e32 v4, vcc, v12, v5, vcc
v_addc_co_u32_e32 v5, vcc, 0, v7, vcc
v_add_co_u32_e32 v6, vcc, v4, v6
v_addc_co_u32_e32 v7, vcc, 0, v5, vcc
v_mul_lo_u32 v11, s13, v6
v_mul_lo_u32 v12, s12, v7
v_mad_u64_u32 v[4:5], s[0:1], s12, v6, 0
v_add3_u32 v5, v5, v12, v11
v_sub_u32_e32 v11, v9, v5
v_mov_b32_e32 v12, s13
v_sub_co_u32_e32 v4, vcc, v10, v4
v_subb_co_u32_e64 v10, s[0:1], v11, v12, vcc
v_subrev_co_u32_e64 v11, s[0:1], s12, v4
v_subbrev_co_u32_e64 v10, s[0:1], 0, v10, s[0:1]
v_cmp_le_u32_e64 s[0:1], s13, v10
v_cndmask_b32_e64 v12, 0, -1, s[0:1]
v_cmp_le_u32_e64 s[0:1], s12, v11
v_cndmask_b32_e64 v11, 0, -1, s[0:1]
v_cmp_eq_u32_e64 s[0:1], s13, v10
v_cndmask_b32_e64 v10, v12, v11, s[0:1]
v_add_co_u32_e64 v11, s[0:1], 2, v6
v_subb_co_u32_e32 v5, vcc, v9, v5, vcc
v_addc_co_u32_e64 v12, s[0:1], 0, v7, s[0:1]
v_cmp_le_u32_e32 vcc, s13, v5
v_add_co_u32_e64 v13, s[0:1], 1, v6
v_cndmask_b32_e64 v9, 0, -1, vcc
v_cmp_le_u32_e32 vcc, s12, v4
v_addc_co_u32_e64 v14, s[0:1], 0, v7, s[0:1]
v_cndmask_b32_e64 v4, 0, -1, vcc
v_cmp_eq_u32_e32 vcc, s13, v5
v_cmp_ne_u32_e64 s[0:1], 0, v10
v_cndmask_b32_e32 v4, v9, v4, vcc
v_cndmask_b32_e64 v10, v14, v12, s[0:1]
v_cmp_ne_u32_e32 vcc, 0, v4
v_cndmask_b32_e64 v5, v13, v11, s[0:1]
v_cndmask_b32_e32 v4, v7, v10, vcc
v_cndmask_b32_e32 v5, v6, v5, vcc
v_xor_b32_e32 v6, s7, v8
v_xor_b32_e32 v7, s6, v8
v_xor_b32_e32 v8, v4, v6
v_xor_b32_e32 v4, v5, v7
v_sub_co_u32_e32 v4, vcc, v4, v7
v_subb_co_u32_e32 v5, vcc, v8, v6, vcc
s_andn2_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 25
v_cvt_f32_u32_e32 v4, s8
s_sub_i32 s2, 0, s8
v_rcp_iflag_f32_e32 v4, v4
v_mul_f32_e32 v4, 0x4f7ffffe, v4
v_cvt_u32_f32_e32 v4, v4
v_mul_lo_u32 v5, s2, v4
v_mul_hi_u32 v5, v4, v5
v_add_u32_e32 v4, v4, v5
v_mul_hi_u32 v4, v2, v4
v_mul_lo_u32 v5, v4, s8
v_add_u32_e32 v6, 1, v4
v_sub_u32_e32 v5, v2, v5
v_subrev_u32_e32 v7, s8, v5
v_cmp_le_u32_e32 vcc, s8, v5
v_cndmask_b32_e32 v5, v5, v7, vcc
v_cndmask_b32_e32 v4, v4, v6, vcc
v_add_u32_e32 v6, 1, v4
v_cmp_le_u32_e32 vcc, s8, v5
v_cndmask_b32_e32 v4, v4, v6, vcc
v_mov_b32_e32 v5, 0
s_or_b64 exec, exec, s[0:1]
v_mul_lo_u32 v8, v3, s9
v_mul_lo_u32 v9, v2, s15
v_mad_u64_u32 v[6:7], s[0:1], v2, s9, 0
v_mul_lo_u32 v5, v5, s8
v_mul_lo_u32 v10, v4, s16
v_add3_u32 v9, v7, v9, v8
v_mad_u64_u32 v[7:8], s[0:1], v4, s8, 0
v_sub_co_u32_e32 v6, vcc, v0, v6
v_subb_co_u32_e32 v9, vcc, v1, v9, vcc
v_add3_u32 v5, v8, v10, v5
v_sub_co_u32_e32 v7, vcc, v2, v7
v_subb_co_u32_e32 v5, vcc, v3, v5, vcc
s_ashr_i32 s0, s11, 31
v_mov_b32_e32 v3, s0
v_add_co_u32_e32 v2, vcc, s11, v6
s_ashr_i32 s2, s14, 31
v_addc_co_u32_e32 v3, vcc, v9, v3, vcc
v_mad_u64_u32 v[2:3], s[0:1], v7, s14, v[2:3]
v_mul_lo_u32 v6, v7, s2
v_mul_lo_u32 v5, v5, s14
s_load_dwordx4 s[0:3], s[4:5], 0x0
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_add3_u32 v3, v5, v3, v6
v_mad_i64_i32 v[2:3], s[4:5], v4, s10, v[2:3]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s3
v_lshlrev_b64 v[2:3], 2, v[2:3]
v_add_co_u32_e32 v2, vcc, s2, v2
v_addc_co_u32_e32 v3, vcc, v4, v3, vcc
global_load_dword v2, v[2:3], off
v_mov_b32_e32 v3, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
s_waitcnt vmcnt(0)
global_store_dword v[0:1], v2, off
s_endpgm
