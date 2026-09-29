.text
k__Z13ssm_ab_gate_kPfS_S_PKfS1_S1_S1_S1_ii:
s_load_dwordx2 s[16:17], s[4:5], 0x40
s_mov_b32 s0, s7
s_ashr_i32 s7, s6, 31
s_add_u32 s20, s4, 0x48
s_mov_b32 s1, 0
s_waitcnt lgkmcnt(0)
v_cmp_le_i32_e32 vcc, s17, v0
s_addc_u32 s21, s5, 0
s_and_saveexec_b64 s[2:3], vcc
s_xor_b64 s[2:3], exec, s[2:3]
s_cbranch_execz 2
s_load_dword s22, s[20:21], 0xc
s_or_saveexec_b64 s[18:19], s[2:3]
s_load_dwordx4 s[12:15], s[4:5], 0x0
s_load_dwordx2 s[2:3], s[4:5], 0x10
s_load_dwordx4 s[8:11], s[4:5], 0x30
v_mov_b32_e32 v3, s1
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s22
v_mov_b32_e32 v4, s1
s_xor_b64 exec, exec, s[18:19]
s_cbranch_execz 55
s_load_dwordx2 s[22:23], s[4:5], 0x28
s_load_dwordx4 s[24:27], s[4:5], 0x18
s_mul_hi_i32 s5, s17, s0
s_mul_i32 s4, s17, s0
s_lshl_b64 s[4:5], s[4:5], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s1, s22, s4
s_addc_u32 s22, s23, s5
s_mul_hi_i32 s5, s17, s6
s_mul_i32 s4, s17, s6
s_load_dword s20, s[20:21], 0xc
s_lshl_b64 s[4:5], s[4:5], 2
s_add_u32 s21, s24, s4
s_addc_u32 s23, s25, s5
s_add_u32 s24, s26, s4
s_addc_u32 s25, s27, s5
s_waitcnt lgkmcnt(0)
s_and_b32 s26, s20, 0xffff
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v1, v0
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[5:6], 2, v[1:2]
v_mov_b32_e32 v2, s22
v_add_co_u32_e32 v7, vcc, s1, v5
v_addc_co_u32_e32 v8, vcc, v2, v6, vcc
global_load_dword v2, v[7:8], off
v_mov_b32_e32 v8, s23
v_add_co_u32_e32 v7, vcc, s21, v5
v_addc_co_u32_e32 v8, vcc, v8, v6, vcc
global_load_dword v7, v[7:8], off
v_mov_b32_e32 v8, s25
v_add_co_u32_e32 v5, vcc, s24, v5
v_addc_co_u32_e32 v6, vcc, v8, v6, vcc
global_load_dword v5, v[5:6], off
v_add_u32_e32 v1, s26, v1
v_cmp_le_i32_e32 vcc, s17, v1
s_or_b64 s[4:5], vcc, s[4:5]
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v3, v7, v2
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v4, v5, v2
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65509
s_or_b64 exec, exec, s[4:5]
v_mov_b32_e32 v2, s20
s_or_b64 exec, exec, s[18:19]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v1, -1, v1
v_and_b32_e32 v5, 63, v1
v_and_b32_e32 v6, 64, v1
v_add_u32_e32 v6, 64, v6
v_xor_b32_e32 v7, 16, v5
v_cmp_lt_i32_e32 vcc, v7, v6
v_cndmask_b32_e32 v7, v1, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v8, v7, v3
ds_bpermute_b32 v7, v7, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v3, v3, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v7
v_xor_b32_e32 v7, 8, v5
v_cmp_lt_i32_e32 vcc, v7, v6
v_cndmask_b32_e32 v7, v1, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v8, v7, v3
ds_bpermute_b32 v7, v7, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v3, v3, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v7
v_xor_b32_e32 v7, 4, v5
v_cmp_lt_i32_e32 vcc, v7, v6
v_cndmask_b32_e32 v7, v1, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v8, v7, v3
ds_bpermute_b32 v7, v7, v4
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v3, v3, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v7
v_xor_b32_e32 v7, 2, v5
v_cmp_lt_i32_e32 vcc, v7, v6
v_cndmask_b32_e32 v7, v1, v7, vcc
v_lshlrev_b32_e32 v7, 2, v7
ds_bpermute_b32 v8, v7, v3
ds_bpermute_b32 v7, v7, v4
v_xor_b32_e32 v5, 1, v5
v_cmp_lt_i32_e32 vcc, v5, v6
v_cndmask_b32_e32 v1, v1, v5, vcc
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v3, v3, v8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v7
v_lshlrev_b32_e32 v1, 2, v1
ds_bpermute_b32 v5, v1, v3
ds_bpermute_b32 v6, v1, v4
v_and_b32_e32 v7, 31, v0
v_lshrrev_b16_e32 v1, 5, v2
v_cmp_eq_u32_e32 vcc, 0, v7
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 12
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v3, v3, v5
v_lshrrev_b32_e32 v5, 3, v0
v_and_b32_e32 v5, 28, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v4, v6
ds_write_b32 v5, v3
v_lshl_add_u32 v3, v1, 2, v5
ds_write_b32 v3, v4
s_or_b64 exec, exec, s[4:5]
v_cmp_eq_u32_e32 vcc, 0, v0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 294
v_cmp_lt_u16_e32 vcc, 31, v2
v_bfrev_b32_e32 v2, 1
v_mov_b32_e32 v0, 0
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 84
v_sub_u32_e64 v0, v1, 1 clamp
v_max_u32_e32 v4, 1, v1
v_cmp_lt_u32_e32 vcc, 6, v0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v3, 0
v_lshlrev_b32_e32 v5, 2, v1
v_mov_b32_e32 v2, 0
s_and_saveexec_b64 s[18:19], vcc
s_cbranch_execz 47
v_and_b32_e32 v3, 0x7f8, v4
s_mov_b32 s1, 0
s_mov_b32 s17, 0
s_mov_b64 s[20:21], 0
v_mov_b32_e32 v0, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v10, s1
v_add_u32_e32 v11, s1, v5
ds_read_b128 v[6:9], v10
ds_read2_b32 v[14:15], v11 offset0:6 offset1:7
ds_read2_b32 v[16:17], v11 offset0:4 offset1:5
ds_read2_b32 v[18:19], v11 offset0:2 offset1:3
ds_read2_b32 v[20:21], v11 offset1:1
ds_read_b128 v[10:13], v10 offset:16
s_waitcnt lgkmcnt(5)
v_add_f32_e32 v0, v0, v6
v_add_f32_e32 v0, v0, v7
v_add_f32_e32 v0, v0, v8
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v2, v2, v20
v_add_f32_e32 v2, v2, v21
v_add_f32_e32 v2, v2, v18
v_add_f32_e32 v0, v0, v9
v_add_f32_e32 v2, v2, v19
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, v0, v10
v_add_f32_e32 v2, v2, v16
s_add_i32 s17, s17, 8
v_add_f32_e32 v0, v0, v11
v_add_f32_e32 v2, v2, v17
s_add_i32 s1, s1, 32
v_cmp_eq_u32_e32 vcc, s17, v3
v_add_f32_e32 v0, v0, v12
v_add_f32_e32 v2, v2, v14
s_or_b64 s[20:21], vcc, s[20:21]
v_add_f32_e32 v0, v0, v13
v_add_f32_e32 v2, v2, v15
s_andn2_b64 exec, exec, s[20:21]
s_cbranch_execnz 65497
s_or_b64 exec, exec, s[20:21]
s_or_b64 exec, exec, s[18:19]
v_and_b32_e32 v4, 7, v4
v_cmp_ne_u32_e32 vcc, 0, v4
s_and_saveexec_b64 s[18:19], vcc
s_cbranch_execz 19
v_lshlrev_b32_e32 v1, 2, v1
v_lshlrev_b32_e32 v3, 2, v3
s_mov_b64 s[20:21], 0
v_add_u32_e32 v5, v3, v1
ds_read_b32 v6, v3
ds_read_b32 v5, v5
v_add_u32_e32 v4, -1, v4
v_cmp_eq_u32_e32 vcc, 0, v4
v_add_u32_e32 v3, 4, v3
s_or_b64 s[20:21], vcc, s[20:21]
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v0, v0, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v2, v2, v5
s_andn2_b64 exec, exec, s[20:21]
s_cbranch_execnz 65521
s_or_b64 exec, exec, s[20:21]
s_or_b64 exec, exec, s[18:19]
v_mul_f32_e32 v2, 0xbfb8aa3b, v2
s_or_b64 exec, exec, s[4:5]
v_exp_f32_e32 v1, v2
s_mul_hi_i32 s1, s16, s0
s_mul_i32 s0, s16, s0
s_add_u32 s0, s0, s6
v_add_f32_e32 v2, 1.0, v1
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
s_addc_u32 s1, s1, s7
s_lshl_b64 s[0:1], s[0:1], 2
s_add_u32 s12, s12, s0
s_addc_u32 s13, s13, s1
s_add_u32 s14, s14, s0
s_addc_u32 s15, s15, s1
s_lshl_b64 s[4:5], s[6:7], 2
s_add_u32 s6, s8, s4
s_addc_u32 s7, s9, s5
s_load_dword s6, s[6:7], 0x0
s_mov_b32 s7, 0x41a00000
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_mov_b32_e32 v1, 0
global_store_dword v1, v0, s[12:13]
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v0, s6, v0
v_cmp_nlt_f32_e32 vcc, s7, v0
v_div_fixup_f32 v2, v3, v2, 1.0
global_store_dword v1, v2, s[14:15]
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 141
v_mul_f32_e32 v0, 0x3fb8aa3b, v0
s_mov_b32 s8, 0x3f2aaaab
v_exp_f32_e32 v0, v0
v_add_f32_e32 v2, 1.0, v0
v_add_f32_e32 v3, -1.0, v2
v_sub_f32_e32 v5, v3, v2
v_frexp_mant_f32_e32 v4, v2
v_sub_f32_e32 v3, v0, v3
v_add_f32_e32 v5, 1.0, v5
v_add_f32_e32 v3, v3, v5
v_frexp_exp_i32_f32_e32 v5, v2
v_cmp_gt_f32_e32 vcc, s8, v4
v_subbrev_co_u32_e32 v4, vcc, 0, v5, vcc
v_sub_u32_e32 v5, 0, v4
v_ldexp_f32 v2, v2, v5
v_ldexp_f32 v3, v3, v5
v_add_f32_e32 v5, -1.0, v2
v_add_f32_e32 v8, 1.0, v2
v_add_f32_e32 v6, 1.0, v5
v_add_f32_e32 v9, -1.0, v8
v_sub_f32_e32 v6, v2, v6
v_sub_f32_e32 v2, v2, v9
v_add_f32_e32 v2, v3, v2
v_add_f32_e32 v6, v3, v6
v_add_f32_e32 v3, v8, v2
v_add_f32_e32 v7, v5, v6
v_rcp_f32_e32 v9, v3
v_sub_f32_e32 v5, v7, v5
v_sub_f32_e32 v5, v6, v5
v_sub_f32_e32 v6, v3, v8
v_sub_f32_e32 v2, v2, v6
v_mul_f32_e32 v6, v7, v9
v_mul_f32_e32 v8, v3, v6
v_fma_f32 v10, v6, v3, -v8
v_fmac_f32_e32 v10, v6, v2
v_add_f32_e32 v11, v8, v10
v_sub_f32_e32 v8, v11, v8
v_sub_f32_e32 v8, v10, v8
v_sub_f32_e32 v10, v7, v11
v_sub_f32_e32 v7, v7, v10
v_sub_f32_e32 v7, v7, v11
v_add_f32_e32 v5, v5, v7
v_sub_f32_e32 v5, v5, v8
v_add_f32_e32 v7, v10, v5
v_mul_f32_e32 v8, v9, v7
v_mul_f32_e32 v11, v3, v8
v_fma_f32 v3, v8, v3, -v11
v_fmac_f32_e32 v3, v8, v2
v_sub_f32_e32 v2, v7, v10
v_sub_f32_e32 v2, v5, v2
v_add_f32_e32 v5, v11, v3
v_sub_f32_e32 v10, v5, v11
v_sub_f32_e32 v3, v3, v10
v_sub_f32_e32 v10, v7, v5
v_sub_f32_e32 v7, v7, v10
v_sub_f32_e32 v5, v7, v5
v_add_f32_e32 v2, v2, v5
v_sub_f32_e32 v2, v2, v3
v_add_f32_e32 v3, v6, v8
v_add_f32_e32 v2, v10, v2
v_sub_f32_e32 v5, v3, v6
v_mul_f32_e32 v2, v9, v2
v_sub_f32_e32 v5, v8, v5
v_add_f32_e32 v2, v5, v2
v_cvt_f32_i32_e32 v4, v4
v_add_f32_e32 v5, v3, v2
v_mul_f32_e32 v6, v5, v5
v_mov_b32_e32 v7, 0x3ecc95a3
v_fmac_f32_e32 v7, 0x3e9b6dac, v6
v_mov_b32_e32 v8, 0x3f2aaada
v_fmac_f32_e32 v8, v6, v7
s_mov_b32 s8, 0x3f317218
v_mul_f32_e32 v7, 0x3f317218, v4
v_fma_f32 v9, v4, s8, -v7
v_fmac_f32_e32 v9, 0xb102e308, v4
v_sub_f32_e32 v3, v5, v3
v_sub_f32_e32 v2, v2, v3
v_add_f32_e32 v3, v7, v9
v_sub_f32_e32 v4, v3, v7
v_ldexp_f32 v7, v5, 1
v_mul_f32_e32 v5, v5, v6
v_mul_f32_e32 v5, v5, v8
v_add_f32_e32 v6, v7, v5
v_sub_f32_e32 v7, v6, v7
v_ldexp_f32 v2, v2, 1
v_sub_f32_e32 v5, v5, v7
v_add_f32_e32 v2, v2, v5
v_add_f32_e32 v5, v6, v2
v_sub_f32_e32 v6, v5, v6
v_sub_f32_e32 v2, v2, v6
v_add_f32_e32 v6, v3, v5
v_sub_f32_e32 v7, v6, v3
v_sub_f32_e32 v8, v6, v7
v_sub_f32_e32 v4, v9, v4
v_sub_f32_e32 v3, v3, v8
v_sub_f32_e32 v5, v5, v7
v_add_f32_e32 v3, v5, v3
v_add_f32_e32 v5, v4, v2
v_sub_f32_e32 v7, v5, v4
v_sub_f32_e32 v8, v5, v7
v_sub_f32_e32 v4, v4, v8
v_sub_f32_e32 v2, v2, v7
v_add_f32_e32 v3, v5, v3
v_add_f32_e32 v2, v2, v4
v_add_f32_e32 v4, v6, v3
v_sub_f32_e32 v5, v4, v6
v_sub_f32_e32 v3, v3, v5
v_add_f32_e32 v2, v2, v3
s_mov_b32 s8, 0x7f800000
v_add_f32_e32 v2, v4, v2
v_cmp_eq_f32_e32 vcc, s8, v0
v_cndmask_b32_e32 v2, v2, v0, vcc
v_mov_b32_e32 v3, 0x7fc00000
v_cmp_ngt_f32_e32 vcc, -1.0, v0
v_cndmask_b32_e32 v2, v3, v2, vcc
v_mov_b32_e32 v3, 0xff800000
v_cmp_neq_f32_e32 vcc, -1.0, v0
s_mov_b32 s8, 0x33800000
v_cndmask_b32_e32 v2, v3, v2, vcc
v_cmp_lt_f32_e64 vcc, |v0|, s8
v_cndmask_b32_e32 v0, v2, v0, vcc
s_or_b64 exec, exec, s[6:7]
s_add_u32 s4, s10, s4
s_addc_u32 s5, s11, s5
s_load_dword s4, s[4:5], 0x0
v_mov_b32_e32 v2, 0x3fb8aa3b
s_add_u32 s0, s2, s0
s_addc_u32 s1, s3, s1
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v2, s4, v2
s_nop 0
v_exp_f32_e32 v2, v2
v_mul_f32_e64 v0, v0, -v2
global_store_dword v1, v0, s[0:1]
s_endpgm
