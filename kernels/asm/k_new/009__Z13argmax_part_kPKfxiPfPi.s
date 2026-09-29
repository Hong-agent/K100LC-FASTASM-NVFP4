.text
k__Z13argmax_part_kPKfxiPfPi:
s_load_dword s8, s[4:5], 0x10
s_load_dwordx2 s[2:3], s[4:5], 0x8
s_mov_b64 s[12:13], -1
s_waitcnt lgkmcnt(0)
s_ashr_i32 s9, s8, 31
s_add_u32 s0, s2, s8
s_addc_u32 s1, s3, s9
s_add_u32 s10, s0, -1
s_addc_u32 s11, s1, -1
s_or_b64 s[0:1], s[10:11], s[8:9]
s_mov_b32 s0, 0
s_cmp_lg_u64 s[0:1], 0
s_cbranch_scc0 572
s_add_u32 s0, s8, s9
s_mov_b32 s14, s9
s_mov_b32 s15, s9
s_addc_u32 s1, s9, s9
s_xor_b64 s[16:17], s[0:1], s[14:15]
v_cvt_f32_u32_e32 v1, s16
v_cvt_f32_u32_e32 v2, s17
s_sub_u32 s0, 0, s16
s_subb_u32 s1, 0, s17
v_mac_f32_e32 v1, 0x4f800000, v2
s_nop 0
v_rcp_f32_e32 v1, v1
v_mul_f32_e32 v1, 0x5f7ffffc, v1
v_mul_f32_e32 v2, 0x2f800000, v1
v_trunc_f32_e32 v2, v2
v_mac_f32_e32 v1, 0xcf800000, v2
v_cvt_u32_f32_e32 v2, v2
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s7, v2
v_readfirstlane_b32 s9, v1
s_mul_i32 s18, s0, s7
s_mul_hi_u32 s20, s0, s9
s_mul_i32 s19, s1, s9
s_add_i32 s18, s20, s18
s_add_i32 s18, s18, s19
s_mul_i32 s21, s0, s9
s_mul_hi_u32 s19, s9, s18
s_mul_i32 s20, s9, s18
s_mul_hi_u32 s9, s9, s21
s_add_u32 s9, s9, s20
s_addc_u32 s19, 0, s19
s_mul_hi_u32 s22, s7, s21
s_mul_i32 s21, s7, s21
s_add_u32 s9, s9, s21
s_mul_hi_u32 s20, s7, s18
s_addc_u32 s9, s19, s22
s_addc_u32 s19, s20, 0
s_mul_i32 s18, s7, s18
s_add_u32 s9, s9, s18
s_addc_u32 s18, 0, s19
v_add_co_u32_e32 v1, vcc, s9, v1
s_cmp_lg_u64 vcc, 0
s_addc_u32 s7, s7, s18
v_readfirstlane_b32 s18, v1
s_mul_i32 s9, s0, s7
s_mul_hi_u32 s19, s0, s18
s_add_i32 s9, s19, s9
s_mul_i32 s1, s1, s18
s_add_i32 s9, s9, s1
s_mul_i32 s0, s0, s18
s_mul_hi_u32 s19, s7, s0
s_mul_i32 s20, s7, s0
s_mul_i32 s22, s18, s9
s_mul_hi_u32 s0, s18, s0
s_mul_hi_u32 s21, s18, s9
s_add_u32 s0, s0, s22
s_addc_u32 s18, 0, s21
s_add_u32 s0, s0, s20
s_mul_hi_u32 s1, s7, s9
s_addc_u32 s0, s18, s19
s_addc_u32 s1, s1, 0
s_mul_i32 s9, s7, s9
s_add_u32 s0, s0, s9
s_addc_u32 s1, 0, s1
v_add_co_u32_e32 v1, vcc, s0, v1
s_cmp_lg_u64 vcc, 0
s_addc_u32 s7, s7, s1
s_ashr_i32 s18, s11, 31
s_add_u32 s0, s10, s18
s_mov_b32 s19, s18
s_addc_u32 s1, s11, s18
s_xor_b64 s[20:21], s[0:1], s[18:19]
v_readfirstlane_b32 s9, v1
s_mul_i32 s1, s20, s7
s_mul_hi_u32 s11, s20, s9
s_mul_hi_u32 s0, s20, s7
s_add_u32 s1, s11, s1
s_addc_u32 s0, 0, s0
s_mul_hi_u32 s22, s21, s9
s_mul_i32 s9, s21, s9
s_add_u32 s1, s1, s9
s_mul_hi_u32 s11, s21, s7
s_addc_u32 s0, s0, s22
s_addc_u32 s1, s11, 0
s_mul_i32 s7, s21, s7
s_add_u32 s7, s0, s7
s_addc_u32 s9, 0, s1
s_mul_i32 s0, s16, s9
s_mul_hi_u32 s1, s16, s7
s_add_i32 s0, s1, s0
s_mul_i32 s1, s17, s7
s_add_i32 s11, s0, s1
s_mul_i32 s1, s16, s7
v_mov_b32_e32 v1, s1
s_sub_i32 s0, s21, s11
v_sub_co_u32_e32 v1, vcc, s20, v1
s_cmp_lg_u64 vcc, 0
s_subb_u32 s20, s0, s17
v_subrev_co_u32_e64 v2, s[0:1], s16, v1
s_cmp_lg_u64 s[0:1], 0
s_subb_u32 s0, s20, 0
s_cmp_ge_u32 s0, s17
v_readfirstlane_b32 s20, v2
s_cselect_b32 s1, -1, 0
s_cmp_ge_u32 s20, s16
s_cselect_b32 s20, -1, 0
s_cmp_eq_u32 s0, s17
s_cselect_b32 s0, s20, s1
s_add_u32 s1, s7, 1
s_addc_u32 s20, s9, 0
s_add_u32 s22, s7, 2
s_addc_u32 s23, s9, 0
s_cmp_lg_u32 s0, 0
s_cselect_b32 s0, s22, s1
s_cselect_b32 s1, s23, s20
s_cmp_lg_u64 vcc, 0
s_subb_u32 s11, s21, s11
s_cmp_ge_u32 s11, s17
v_readfirstlane_b32 s21, v1
s_cselect_b32 s20, -1, 0
s_cmp_ge_u32 s21, s16
s_cselect_b32 s16, -1, 0
s_cmp_eq_u32 s11, s17
s_cselect_b32 s11, s16, s20
s_cmp_lg_u32 s11, 0
s_cselect_b32 s1, s1, s9
s_cselect_b32 s0, s0, s7
s_xor_b64 s[14:15], s[18:19], s[14:15]
s_xor_b64 s[0:1], s[0:1], s[14:15]
s_sub_u32 s0, s0, s14
s_subb_u32 s1, s1, s15
s_cbranch_execnz 22
v_cvt_f32_u32_e32 v1, s8
s_sub_i32 s0, 0, s8
s_mov_b32 s1, 0
v_rcp_iflag_f32_e32 v1, v1
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s7, v1
s_mul_i32 s0, s0, s7
s_mul_hi_u32 s0, s7, s0
s_add_i32 s7, s7, s0
s_mul_hi_u32 s0, s10, s7
s_mul_i32 s9, s0, s8
s_sub_i32 s9, s10, s9
s_add_i32 s7, s0, 1
s_sub_i32 s10, s9, s8
s_cmp_ge_u32 s9, s8
s_cselect_b32 s0, s7, s0
s_cselect_b32 s9, s10, s9
s_add_i32 s7, s0, 1
s_cmp_ge_u32 s9, s8
s_cselect_b32 s0, s7, s0
s_mul_i32 s7, s1, s6
s_mul_hi_u32 s12, s0, s6
s_add_i32 s18, s12, s7
s_mul_i32 s19, s0, s6
s_add_u32 s12, s19, s0
v_mov_b32_e32 v1, s2
s_addc_u32 s13, s18, s1
v_mov_b32_e32 v2, s3
v_cmp_lt_i64_e32 vcc, s[12:13], v[1:2]
s_load_dwordx4 s[8:11], s[4:5], 0x18
s_and_b64 s[14:15], vcc, exec
v_mov_b32_e32 v3, s18
v_add_co_u32_e32 v2, vcc, s19, v0
s_cselect_b32 s3, s13, s3
s_cselect_b32 s2, s12, s2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
v_cmp_gt_i64_e32 vcc, s[2:3], v[2:3]
s_mov_b32 s7, 0
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v8, 0xff800000
v_mov_b32_e32 v9, -1
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 71
s_load_dword s1, s[4:5], 0x34
s_load_dwordx2 s[14:15], s[4:5], 0x0
v_lshlrev_b64 v[4:5], 2, v[2:3]
s_mov_b32 s20, s7
s_mul_i32 s21, s6, s0
s_waitcnt lgkmcnt(0)
s_and_b32 s22, s1, 0xffff
v_mov_b32_e32 v6, s15
v_add_co_u32_e32 v4, vcc, s14, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
v_mov_b32_e32 v7, v1
s_lshl_b32 s23, s22, 2
s_mov_b32 s24, s7
s_mov_b64 s[14:15], 0
v_mov_b32_e32 v8, 0xff800000
v_mov_b32_e32 v9, -1
v_mov_b32_e32 v6, v0
s_branch 16
s_or_b64 exec, exec, s[16:17]
v_mov_b32_e32 v1, s20
v_add_co_u32_e32 v2, vcc, s22, v2
v_addc_co_u32_e32 v3, vcc, v3, v1, vcc
v_add_co_u32_e32 v6, vcc, s22, v6
v_addc_co_u32_e32 v7, vcc, v7, v1, vcc
v_mov_b32_e32 v1, s18
v_add_co_u32_e32 v10, vcc, s19, v6
v_addc_co_u32_e32 v11, vcc, v7, v1, vcc
v_cmp_le_i64_e32 vcc, s[2:3], v[10:11]
v_mov_b32_e32 v1, s24
s_or_b64 s[14:15], vcc, s[14:15]
v_add_co_u32_e32 v4, vcc, s23, v4
v_addc_co_u32_e32 v5, vcc, v5, v1, vcc
s_andn2_b64 exec, exec, s[14:15]
s_cbranch_execz 31
global_load_dword v1, v[4:5], off
s_mov_b64 s[0:1], 0
s_waitcnt vmcnt(0)
v_cmp_ngt_f32_e32 vcc, v1, v8
s_and_saveexec_b64 s[16:17], vcc
s_xor_b64 s[16:17], exec, s[16:17]
s_cbranch_execnz 6
s_andn2_saveexec_b64 s[16:17], s[16:17]
s_cbranch_execnz 13
s_or_b64 exec, exec, s[16:17]
s_and_saveexec_b64 s[16:17], s[0:1]
s_cbranch_execz 65507
s_branch 14
v_add_u32_e32 v10, s21, v6
v_cmp_eq_f32_e32 vcc, v1, v8
v_cmp_gt_i32_e64 s[0:1], v9, v10
s_and_b64 s[0:1], vcc, s[0:1]
s_and_b64 s[0:1], s[0:1], exec
v_mov_b32_e32 v10, v2
s_andn2_saveexec_b64 s[16:17], s[16:17]
s_cbranch_execz 65523
v_add_u32_e32 v10, s21, v6
s_or_b64 s[0:1], s[0:1], exec
s_or_b64 exec, exec, s[16:17]
s_and_saveexec_b64 s[16:17], s[0:1]
s_cbranch_execz 65492
v_mov_b32_e32 v9, v10
v_mov_b32_e32 v8, v1
s_branch 65489
s_or_b64 exec, exec, s[14:15]
s_or_b64 exec, exec, s[12:13]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v1, -1, v1
v_and_b32_e32 v2, 63, v1
v_and_b32_e32 v3, 64, v1
v_add_u32_e32 v7, 64, v3
v_xor_b32_e32 v3, 16, v2
v_cmp_lt_i32_e32 vcc, v3, v7
v_cndmask_b32_e32 v3, v1, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v4, v3, v8
ds_bpermute_b32 v5, v3, v9
s_waitcnt lgkmcnt(0)
v_cmp_lt_f32_e64 s[2:3], v8, v4
v_cmp_nlt_f32_e32 vcc, v8, v4
s_and_saveexec_b64 s[12:13], vcc
v_cmp_eq_f32_e32 vcc, v8, v4
v_cmp_lt_i32_e64 s[0:1], v5, v9
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[0:1], s[2:3]
v_mov_b32_e32 v8, v4
v_mov_b32_e32 v9, v5
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v4, 8, v2
v_cmp_lt_i32_e32 vcc, v4, v7
v_cndmask_b32_e32 v4, v1, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v5, v4, v8
ds_bpermute_b32 v6, v4, v9
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v8, v5
v_cmp_nlt_f32_e32 vcc, v8, v5
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v8, v5
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v6, v9
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v8, v5
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v9, v6
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v5, 4, v2
v_cmp_lt_i32_e32 vcc, v5, v7
v_cndmask_b32_e32 v5, v1, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v6, v5, v8
ds_bpermute_b32 v10, v5, v9
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v8, v6
v_cmp_nlt_f32_e32 vcc, v8, v6
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v8, v6
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v10, v9
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v8, v6
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v9, v10
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v6, 2, v2
v_cmp_lt_i32_e32 vcc, v6, v7
v_cndmask_b32_e32 v6, v1, v6, vcc
v_lshlrev_b32_e32 v6, 2, v6
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v10, v6, v8
ds_bpermute_b32 v11, v6, v9
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v8, v10
v_cmp_nlt_f32_e32 vcc, v8, v10
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v8, v10
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v11, v9
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v8, v10
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v9, v11
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v2, 1, v2
v_cmp_lt_i32_e32 vcc, v2, v7
v_cndmask_b32_e32 v1, v1, v2, vcc
v_lshlrev_b32_e32 v7, 2, v1
ds_bpermute_b32 v1, v7, v8
ds_bpermute_b32 v2, v7, v9
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v8, v1
v_cmp_nlt_f32_e32 vcc, v8, v1
s_and_saveexec_b64 s[12:13], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v8, v1
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v2, v9
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v9, v2
v_mov_b32_e32 v8, v1
s_or_b64 exec, exec, s[0:1]
v_and_b32_e32 v1, 31, v0
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
v_lshrrev_b32_e32 v1, 3, v0
v_and_b32_e32 v1, 28, v1
ds_write2_b32 v1, v9, v8 offset1:32
s_or_b64 exec, exec, s[0:1]
v_cmp_gt_u32_e32 vcc, 32, v0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 150
s_load_dword s0, s[4:5], 0x34
v_mov_b32_e32 v2, 0xff800000
s_waitcnt lgkmcnt(0)
v_lshrrev_b16_e64 v1, 5, s0
v_cmp_lt_u32_e32 vcc, v0, v1
v_mov_b32_e32 v1, -1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 3
v_lshlrev_b32_e32 v1, 2, v0
ds_read2_b32 v[1:2], v1 offset1:32
s_or_b64 exec, exec, s[0:1]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v8, v3, v2
ds_bpermute_b32 v9, v3, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v8
v_cmp_nlt_f32_e32 vcc, v2, v8
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 9
v_cmp_eq_f32_e32 vcc, v2, v8
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v9, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
v_mov_b32_e32 v3, v2
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v8
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v9
v_mov_b32_e32 v2, v8
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v8, v4, v3
ds_bpermute_b32 v4, v4, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v8
v_cmp_nlt_f32_e32 vcc, v2, v8
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v8
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v4, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v8
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v4
v_mov_b32_e32 v2, v8
s_or_b64 exec, exec, s[0:1]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v4, v5, v3
ds_bpermute_b32 v5, v5, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v4
v_cmp_nlt_f32_e32 vcc, v2, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v5, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v4
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v5
v_mov_b32_e32 v2, v4
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v4, v6, v3
s_waitcnt lgkmcnt(1)
ds_bpermute_b32 v5, v6, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v4
v_cmp_nlt_f32_e32 vcc, v2, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v5, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v4
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v5
v_mov_b32_e32 v2, v4
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v3, v7, v3
ds_bpermute_b32 v4, v7, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v3
v_cmp_nlt_f32_e32 vcc, v2, v3
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execnz 21
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execnz 29
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_b64 exec, exec, vcc
s_cbranch_execz 10
s_lshl_b64 s[0:1], s[6:7], 2
s_add_u32 s2, s8, s0
s_addc_u32 s3, s9, s1
s_add_u32 s0, s10, s0
v_mov_b32_e32 v0, 0
s_addc_u32 s1, s11, s1
global_store_dword v0, v2, s[2:3]
global_store_dword v0, v1, s[0:1]
s_endpgm
s_andn2_b64 vcc, exec, s[12:13]
s_cbranch_vccz 65099
s_branch 65120
v_cmp_eq_f32_e32 vcc, v2, v3
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v4, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 65507
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v4
v_mov_b32_e32 v2, v3
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_b64 exec, exec, vcc
s_cbranch_execnz 65504
s_branch 65513
