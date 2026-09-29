.text
k__Z8l2norm_kPfif:
s_load_dwordx4 s[0:3], s[4:5], 0x0
v_mov_b32_e32 v3, 0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s7, s2, 31
s_mul_hi_u32 s9, s2, s6
s_mul_i32 s7, s7, s6
s_mul_i32 s8, s2, s6
s_add_i32 s9, s9, s7
s_lshl_b64 s[6:7], s[8:9], 2
s_add_u32 s10, s0, s6
s_addc_u32 s11, s1, s7
v_cmp_gt_i32_e32 vcc, s2, v0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 27
s_load_dword s0, s[4:5], 0x1c
s_mov_b64 s[8:9], 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s12, s0, 0xffff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[4:5], 2, v[1:2]
v_mov_b32_e32 v2, s11
v_add_co_u32_e64 v4, s[0:1], s10, v4
v_addc_co_u32_e64 v5, s[0:1], v2, v5, s[0:1]
global_load_dword v2, v[4:5], off
v_add_u32_e32 v1, s12, v1
v_cmp_le_i32_e64 s[0:1], s2, v1
s_or_b64 s[8:9], s[0:1], s[8:9]
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v3, v2, v2
s_andn2_b64 exec, exec, s[8:9]
s_cbranch_execnz 65518
s_or_b64 exec, exec, s[8:9]
s_or_b64 exec, exec, s[6:7]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v5, -1, v1
v_and_b32_e32 v6, 63, v5
v_and_b32_e32 v1, 64, v5
v_add_u32_e32 v7, 64, v1
v_xor_b32_e32 v1, 16, v6
v_cmp_lt_i32_e64 s[0:1], v1, v7
v_cndmask_b32_e64 v1, v5, v1, s[0:1]
v_lshlrev_b32_e32 v1, 2, v1
ds_bpermute_b32 v2, v1, v3
v_xor_b32_e32 v4, 8, v6
v_cmp_lt_i32_e64 s[0:1], v4, v7
v_xor_b32_e32 v8, 4, v6
v_xor_b32_e32 v9, 2, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v3, v3, v2
v_cndmask_b32_e64 v2, v5, v4, s[0:1]
v_lshlrev_b32_e32 v2, 2, v2
ds_bpermute_b32 v4, v2, v3
v_cmp_lt_i32_e64 s[0:1], v8, v7
v_xor_b32_e32 v10, 1, v6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v4, v3, v4
v_cndmask_b32_e64 v3, v5, v8, s[0:1]
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v8, v3, v4
v_cmp_lt_i32_e64 s[0:1], v9, v7
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v8, v4, v8
v_cndmask_b32_e64 v4, v5, v9, s[0:1]
v_lshlrev_b32_e32 v4, 2, v4
ds_bpermute_b32 v9, v4, v8
v_cmp_lt_i32_e64 s[0:1], v10, v7
v_cndmask_b32_e64 v5, v5, v10, s[0:1]
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v8, v9
ds_bpermute_b32 v7, v5, v6
v_and_b32_e32 v8, 31, v0
v_cmp_eq_u32_e64 s[0:1], 0, v8
s_and_saveexec_b64 s[6:7], s[0:1]
s_cbranch_execz 6
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
v_lshrrev_b32_e32 v7, 3, v0
v_and_b32_e32 v7, 28, v7
ds_write_b32 v7, v6
s_or_b64 exec, exec, s[6:7]
v_cmp_gt_u32_e64 s[0:1], 32, v0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[6:7], s[0:1]
s_cbranch_execz 58
s_load_dword s0, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
v_lshrrev_b16_e64 v6, 5, s0
v_cmp_lt_u32_e64 s[0:1], v0, v6
v_mov_b32_e32 v6, 0
s_and_saveexec_b64 s[8:9], s[0:1]
s_cbranch_execz 3
v_lshlrev_b32_e32 v6, 2, v0
ds_read_b32 v6, v6
s_or_b64 exec, exec, s[8:9]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v1, v1, v6
v_cmp_eq_u32_e64 s[0:1], 0, v0
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
s_and_b64 exec, exec, s[0:1]
s_cbranch_execz 21
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v1, v1, v2
v_add_f32_e32 v1, s3, v1
s_mov_b32 s0, 0xd800000
v_cmp_gt_f32_e64 s[0:1], s0, v1
v_mov_b32_e32 v3, 0x71800000
v_cndmask_b32_e64 v3, 1.0, v3, s[0:1]
v_mul_f32_e32 v1, v1, v3
v_mov_b32_e32 v2, 0x58800000
v_rsq_f32_e32 v1, v1
v_cndmask_b32_e64 v2, 1.0, v2, s[0:1]
v_mul_f32_e32 v1, v2, v1
v_mov_b32_e32 v2, 0
ds_write_b32 v2, v1
s_or_b64 exec, exec, s[6:7]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 26
s_load_dword s0, s[4:5], 0x1c
v_mov_b32_e32 v1, 0
ds_read_b32 v2, v1
s_waitcnt lgkmcnt(0)
s_and_b32 s3, s0, 0xffff
s_mov_b64 s[0:1], 0
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[3:4], 2, v[0:1]
v_mov_b32_e32 v1, s11
v_add_co_u32_e32 v3, vcc, s10, v3
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
global_load_dword v1, v[3:4], off
v_add_u32_e32 v0, s3, v0
v_cmp_le_i32_e32 vcc, s2, v0
s_or_b64 s[0:1], vcc, s[0:1]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v1, v2, v1
global_store_dword v[3:4], v1, off
s_andn2_b64 exec, exec, s[0:1]
s_cbranch_execnz 65519
s_endpgm
