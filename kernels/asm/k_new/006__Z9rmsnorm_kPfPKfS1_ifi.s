.text
k__Z9rmsnorm_kPfPKfS1_ifi:
s_load_dwordx4 s[8:11], s[4:5], 0x18
s_load_dwordx4 s[12:15], s[4:5], 0x0
s_load_dwordx2 s[16:17], s[4:5], 0x10
v_mov_b32_e32 v3, 0
s_waitcnt lgkmcnt(0)
s_mul_hi_i32 s1, s8, s6
s_mul_i32 s0, s8, s6
s_lshl_b64 s[2:3], s[0:1], 2
s_add_u32 s11, s14, s2
s_addc_u32 s18, s15, s3
v_cmp_gt_i32_e64 s[0:1], s8, v0
s_and_saveexec_b64 s[6:7], s[0:1]
s_cbranch_execz 24
s_load_dword s19, s[4:5], 0x34
s_mov_b64 s[14:15], 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s19, s19, 0xffff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[4:5], 2, v[1:2]
v_mov_b32_e32 v2, s18
v_add_co_u32_e32 v4, vcc, s11, v4
v_addc_co_u32_e32 v5, vcc, v2, v5, vcc
global_load_dword v2, v[4:5], off
v_add_u32_e32 v1, s19, v1
v_cmp_le_i32_e32 vcc, s8, v1
s_or_b64 s[14:15], vcc, s[14:15]
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v3, v2, v2
s_andn2_b64 exec, exec, s[14:15]
s_cbranch_execnz 65521
s_or_b64 exec, exec, s[14:15]
s_or_b64 exec, exec, s[6:7]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v5, -1, v1
v_and_b32_e32 v6, 63, v5
v_and_b32_e32 v1, 64, v5
v_add_u32_e32 v7, 64, v1
v_xor_b32_e32 v1, 16, v6
v_cmp_lt_i32_e32 vcc, v1, v7
v_cndmask_b32_e32 v1, v5, v1, vcc
v_lshlrev_b32_e32 v1, 2, v1
ds_bpermute_b32 v2, v1, v3
v_xor_b32_e32 v4, 8, v6
v_cmp_lt_i32_e32 vcc, v4, v7
v_xor_b32_e32 v8, 4, v6
v_xor_b32_e32 v9, 2, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v2
v_cndmask_b32_e32 v2, v5, v4, vcc
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v3
v_cmp_lt_i32_e32 vcc, v8, v7
v_xor_b32_e32 v10, 1, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v3, v4
v_cndmask_b32_e32 v3, v5, v8, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v8, v3, v4
v_cmp_lt_i32_e32 vcc, v9, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v4, v8
v_cndmask_b32_e32 v4, v5, v9, vcc
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v8
v_cmp_lt_i32_e32 vcc, v10, v7
v_cndmask_b32_e32 v5, v5, v10, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v8, v9
ds_bpermute_b32 v7, v5, v6
v_and_b32_e32 v8, 31, v0
v_cmp_eq_u32_e32 vcc, 0, v8
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
v_lshrrev_b32_e32 v7, 3, v0
v_and_b32_e32 v7, 28, v7
ds_write_b32 v7, v6
s_or_b64 exec, exec, s[6:7]
v_cmp_gt_u32_e32 vcc, 32, v0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 72
s_load_dword s14, s[4:5], 0x34
s_waitcnt lgkmcnt(0)
v_lshrrev_b16_e64 v6, 5, s14
v_cmp_lt_u32_e32 vcc, v0, v6
v_mov_b32_e32 v6, 0
s_and_saveexec_b64 s[14:15], vcc
s_cbranch_execz 3
v_lshlrev_b32_e32 v6, 2, v0
ds_read_b32 v6, v6
s_or_b64 exec, exec, s[14:15]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v1, v1, v6
v_cmp_eq_u32_e32 vcc, 0, v0
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v6, v1
ds_bpermute_b32 v2, v2, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v1, v2
ds_bpermute_b32 v2, v3, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v1, v2
ds_bpermute_b32 v2, v4, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v1, v2
ds_bpermute_b32 v2, v5, v1
s_and_b64 exec, exec, vcc
s_cbranch_execz 37
v_cvt_f32_i32_e32 v3, s8
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v1, v2
v_div_scale_f32 v2, s[14:15], v3, v3, v1
v_div_scale_f32 v4, vcc, v1, v3, v1
s_mov_b32 s14, 0xd800000
v_rcp_f32_e32 v5, v2
v_fma_f32 v6, -v2, v5, 1.0
v_fmac_f32_e32 v5, v6, v5
v_mul_f32_e32 v6, v4, v5
v_fma_f32 v7, -v2, v6, v4
v_fmac_f32_e32 v6, v7, v5
v_fma_f32 v2, -v2, v6, v4
v_div_fmas_f32 v2, v2, v5, v6
v_mov_b32_e32 v5, 0x71800000
v_mov_b32_e32 v4, 0x58800000
v_div_fixup_f32 v1, v2, v3, v1
v_add_f32_e32 v1, s9, v1
v_cmp_gt_f32_e32 vcc, s14, v1
v_cndmask_b32_e32 v3, 1.0, v5, vcc
v_mul_f32_e32 v1, v1, v3
v_cndmask_b32_e32 v2, 1.0, v4, vcc
v_rsq_f32_e32 v1, v1
v_mul_f32_e32 v1, v2, v1
v_mov_b32_e32 v2, 0
ds_write_b32 v2, v1
s_or_b64 exec, exec, s[6:7]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[6:7], s[0:1]
s_cbranch_execz 49
v_mov_b32_e32 v1, 0
s_load_dword s0, s[4:5], 0x34
ds_read_b32 v2, v1
s_add_u32 s6, s12, s2
s_addc_u32 s7, s13, s3
s_cmp_eq_u32 s10, 0
s_cselect_b64 vcc, -1, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s9, s0, 0xffff
s_mov_b64 s[4:5], 0
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[3:4], 2, v[0:1]
v_mov_b32_e32 v1, s18
v_add_co_u32_e64 v5, s[0:1], s11, v3
v_addc_co_u32_e64 v6, s[0:1], v1, v4, s[0:1]
global_load_dword v1, v[5:6], off
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v5, s[0:1], s16, v3
v_addc_co_u32_e64 v6, s[0:1], v6, v4, s[0:1]
global_load_dword v5, v[5:6], off
v_mov_b32_e32 v6, s7
v_add_co_u32_e64 v3, s[2:3], s6, v3
v_add_u32_e32 v0, s9, v0
v_addc_co_u32_e64 v4, s[2:3], v6, v4, s[2:3]
v_cmp_le_i32_e64 s[0:1], s8, v0
s_or_b64 s[4:5], s[0:1], s[4:5]
s_waitcnt vmcnt(1)
v_mul_f32_e32 v1, v2, v1
s_waitcnt vmcnt(0)
v_add_f32_e32 v6, 1.0, v5
v_cndmask_b32_e32 v5, v6, v5, vcc
v_mul_f32_e32 v1, v1, v5
global_store_dword v[3:4], v1, off
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65500
s_endpgm
