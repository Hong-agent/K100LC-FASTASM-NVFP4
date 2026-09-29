.text
k__Z13vit_ln_kernelPfPKfS1_S1_iif:
s_load_dwordx4 s[8:11], s[4:5], 0x20
s_waitcnt lgkmcnt(0)
s_cmp_ge_i32 s6, s8
s_cbranch_scc1 245
s_load_dwordx2 s[0:1], s[4:5], 0x8
s_mul_hi_i32 s3, s9, s6
s_mul_i32 s2, s9, s6
s_lshl_b64 s[6:7], s[2:3], 2
v_cmp_gt_i32_e32 vcc, s9, v0
s_waitcnt lgkmcnt(0)
s_add_u32 s8, s0, s6
s_addc_u32 s11, s1, s7
s_add_u32 s18, s4, 48
v_cmp_le_i32_e64 s[0:1], s9, v0
s_addc_u32 s19, s5, 0
s_and_saveexec_b64 s[2:3], s[0:1]
s_xor_b64 s[0:1], exec, s[2:3]
s_cbranch_execz 6
s_load_dword s20, s[18:19], 0xc
s_mov_b32 s22, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s21, s20, 0xffff
s_or_saveexec_b64 s[2:3], s[0:1]
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx4 s[12:15], s[4:5], 0x10
v_mov_b32_e32 v4, s22
v_mov_b32_e32 v5, s20
v_mov_b32_e32 v2, s21
v_mov_b32_e32 v3, s22
s_xor_b64 exec, exec, s[2:3]
s_cbranch_execz 31
s_load_dword s18, s[18:19], 0xc
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s19, s18, 0xffff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[5:6], 2, v[1:2]
v_mov_b32_e32 v2, s11
v_add_co_u32_e64 v5, s[0:1], s8, v5
v_addc_co_u32_e64 v6, s[0:1], v2, v6, s[0:1]
global_load_dword v2, v[5:6], off
v_add_u32_e32 v1, s19, v1
v_cmp_le_i32_e64 s[0:1], s9, v1
s_or_b64 s[4:5], s[0:1], s[4:5]
s_waitcnt vmcnt(0)
v_add_f32_e32 v4, v4, v2
v_fmac_f32_e32 v3, v2, v2
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execnz 65517
s_or_b64 exec, exec, s[4:5]
v_mov_b32_e32 v5, s18
v_mov_b32_e32 v2, s19
s_or_b64 exec, exec, s[2:3]
v_lshlrev_b32_e32 v1, 2, v0
v_cmp_lt_u16_e64 s[0:1], 1, v5
ds_write_b32 v1, v4
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[4:5], s[0:1]
s_cbranch_execz 29
s_mov_b64 s[18:19], 0
v_mov_b32_e32 v4, v2
s_branch 10
s_or_b64 exec, exec, s[20:21]
v_cmp_gt_u32_e64 s[2:3], 4, v4
s_or_b64 s[18:19], s[2:3], s[18:19]
v_mov_b32_e32 v4, v5
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_andn2_b64 exec, exec, s[18:19]
s_cbranch_execz 16
v_lshrrev_b32_e32 v5, 1, v4
v_cmp_lt_u32_e64 s[2:3], v0, v5
s_and_saveexec_b64 s[20:21], s[2:3]
s_cbranch_execz 65521
v_lshl_add_u32 v6, v5, 2, v1
ds_read_b32 v6, v6
ds_read_b32 v7, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_write_b32 v1, v6
s_branch 65510
s_or_b64 exec, exec, s[4:5]
v_mov_b32_e32 v4, 0
ds_read_b32 v4, v4
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_write_b32 v1, v3
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 29
s_mov_b64 s[4:5], 0
v_mov_b32_e32 v3, v2
s_branch 10
s_or_b64 exec, exec, s[18:19]
v_cmp_gt_u32_e64 s[0:1], 4, v3
s_or_b64 s[4:5], s[0:1], s[4:5]
v_mov_b32_e32 v3, v5
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_andn2_b64 exec, exec, s[4:5]
s_cbranch_execz 16
v_lshrrev_b32_e32 v5, 1, v3
v_cmp_lt_u32_e64 s[0:1], v0, v5
s_and_saveexec_b64 s[18:19], s[0:1]
s_cbranch_execz 65521
v_lshl_add_u32 v6, v5, 2, v1
ds_read_b32 v6, v6
ds_read_b32 v7, v1
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v6, v6, v7
ds_write_b32 v1, v6
s_branch 65510
s_or_b64 exec, exec, s[2:3]
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 95
v_cvt_f32_i32_e32 v1, s9
v_mov_b32_e32 v3, 0
ds_read_b32 v5, v3
s_add_u32 s4, s16, s6
v_div_scale_f32 v3, s[0:1], v1, v1, v4
v_div_scale_f32 v7, vcc, v4, v1, v4
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v6, s[0:1], v1, v1, v5
v_div_scale_f32 v8, s[0:1], v5, v1, v5
s_addc_u32 s5, s17, s7
s_mov_b64 s[2:3], 0
v_rcp_f32_e32 v9, v3
v_rcp_f32_e32 v10, v6
v_fma_f32 v11, -v3, v9, 1.0
v_fmac_f32_e32 v9, v11, v9
v_mul_f32_e32 v11, v7, v9
v_fma_f32 v12, -v6, v10, 1.0
v_fma_f32 v13, -v3, v11, v7
v_fmac_f32_e32 v10, v12, v10
v_fmac_f32_e32 v11, v13, v9
v_mul_f32_e32 v12, v8, v10
v_fma_f32 v3, -v3, v11, v7
v_fma_f32 v7, -v6, v12, v8
v_fmac_f32_e32 v12, v7, v10
v_div_fmas_f32 v3, v3, v9, v11
v_fma_f32 v6, -v6, v12, v8
s_mov_b64 vcc, s[0:1]
v_div_fmas_f32 v6, v6, v10, v12
s_mov_b32 s0, 0xd800000
v_mov_b32_e32 v8, 0x71800000
v_mov_b32_e32 v7, 0x58800000
v_div_fixup_f32 v3, v3, v1, v4
v_div_fixup_f32 v1, v6, v1, v5
v_fma_f32 v1, -v3, v3, v1
v_add_f32_e32 v1, s10, v1
v_cmp_gt_f32_e32 vcc, s0, v1
v_cndmask_b32_e32 v5, 1.0, v8, vcc
v_mul_f32_e32 v1, v1, v5
v_cndmask_b32_e32 v4, 1.0, v7, vcc
v_rsq_f32_e32 v1, v1
v_mul_f32_e32 v4, v4, v1
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[5:6], 2, v[0:1]
v_mov_b32_e32 v1, s11
v_add_co_u32_e32 v7, vcc, s8, v5
v_addc_co_u32_e32 v8, vcc, v1, v6, vcc
global_load_dword v1, v[7:8], off
v_mov_b32_e32 v8, s13
v_add_co_u32_e32 v7, vcc, s12, v5
v_addc_co_u32_e32 v8, vcc, v8, v6, vcc
global_load_dword v9, v[7:8], off
v_mov_b32_e32 v8, s15
v_add_co_u32_e32 v7, vcc, s14, v5
v_addc_co_u32_e32 v8, vcc, v8, v6, vcc
global_load_dword v7, v[7:8], off
v_add_u32_e32 v0, v0, v2
v_mov_b32_e32 v8, s5
v_cmp_le_i32_e32 vcc, s9, v0
v_add_co_u32_e64 v5, s[0:1], s4, v5
v_addc_co_u32_e64 v6, s[0:1], v8, v6, s[0:1]
s_or_b64 s[2:3], vcc, s[2:3]
s_waitcnt vmcnt(2)
v_sub_f32_e32 v1, v1, v3
v_mul_f32_e32 v1, v4, v1
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v7, v9, v1
global_store_dword v[5:6], v7, off
s_andn2_b64 exec, exec, s[2:3]
s_cbranch_execnz 65501
s_endpgm
