.text
k__Z15vit_rope_kernelPfPKfS1_iiii:
s_load_dwordx4 s[0:3], s[4:5], 0x18
s_waitcnt lgkmcnt(0)
s_cmp_ge_i32 s6, s0
s_cbranch_scc1 157
s_lshr_b32 s0, s2, 31
s_add_i32 s0, s2, s0
s_ashr_i32 s8, s0, 1
s_mul_i32 s7, s8, s1
v_cmp_gt_i32_e32 vcc, s7, v0
s_and_saveexec_b64 s[10:11], vcc
s_cbranch_execz 150
s_load_dwordx4 s[12:15], s[4:5], 0x0
s_load_dwordx2 s[16:17], s[4:5], 0x10
s_mul_hi_i32 s11, s3, s6
s_mul_i32 s10, s3, s6
s_lshl_b64 s[10:11], s[10:11], 2
s_waitcnt lgkmcnt(0)
s_add_u32 s3, s12, s10
s_addc_u32 s10, s13, s11
s_mul_hi_i32 s13, s2, s6
s_mul_i32 s12, s2, s6
s_lshl_b64 s[12:13], s[12:13], 2
s_add_u32 s6, s14, s12
s_addc_u32 s11, s15, s13
s_add_u32 s12, s16, s12
s_addc_u32 s13, s17, s13
s_ashr_i32 s9, s8, 31
s_add_i32 s0, s9, s8
s_xor_b32 s14, s0, s9
v_cvt_f32_u32_e32 v1, s14
s_load_dword s0, s[4:5], 0x34
s_mul_i32 s4, s2, s1
s_sub_i32 s2, s2, s8
v_rcp_iflag_f32_e32 v1, v1
s_waitcnt lgkmcnt(0)
s_and_b32 s5, s0, 0xffff
s_mov_b64 s[0:1], 0
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_mul_lo_u32 v2, s14, v1
v_sub_u32_e32 v2, 0, v2
v_mul_hi_u32 v2, v2, v1
v_add_u32_e32 v1, v2, v1
v_ashrrev_i32_e32 v2, 31, v0
v_add_u32_e32 v4, v2, v0
v_xor_b32_e32 v3, s9, v2
v_xor_b32_e32 v2, v4, v2
v_mul_hi_u32 v4, v2, v1
v_mov_b32_e32 v12, s10
v_mov_b32_e32 v10, s11
v_mov_b32_e32 v11, s13
v_mul_lo_u32 v5, v4, s14
v_add_u32_e32 v6, 1, v4
v_mov_b32_e32 v13, s10
s_lshl_b64 s[16:17], s[8:9], 2
v_sub_u32_e32 v2, v2, v5
v_cmp_le_u32_e32 vcc, s14, v2
v_subrev_u32_e32 v5, s14, v2
v_cndmask_b32_e32 v4, v4, v6, vcc
v_cndmask_b32_e32 v2, v2, v5, vcc
v_add_u32_e32 v5, 1, v4
v_cmp_le_u32_e32 vcc, s14, v2
v_cndmask_b32_e32 v2, v4, v5, vcc
v_xor_b32_e32 v2, v2, v3
v_sub_u32_e32 v2, v2, v3
v_mul_lo_u32 v4, v2, s8
v_mad_u64_u32 v[2:3], s[18:19], v2, s2, v[0:1]
v_mov_b32_e32 v14, s17
v_sub_u32_e32 v4, v0, v4
v_ashrrev_i32_e32 v3, 31, v2
v_add_u32_e32 v6, s8, v2
v_lshlrev_b64 v[8:9], 2, v[2:3]
v_ashrrev_i32_e32 v5, 31, v4
v_ashrrev_i32_e32 v7, 31, v6
v_lshlrev_b64 v[3:4], 2, v[4:5]
v_lshlrev_b64 v[5:6], 2, v[6:7]
v_add_co_u32_e32 v7, vcc, s3, v8
v_addc_co_u32_e32 v8, vcc, v12, v9, vcc
v_add_co_u32_e32 v9, vcc, s6, v3
v_addc_co_u32_e32 v10, vcc, v10, v4, vcc
v_add_co_u32_e32 v3, vcc, s12, v3
v_addc_co_u32_e32 v4, vcc, v11, v4, vcc
v_add_co_u32_e32 v5, vcc, s3, v5
v_addc_co_u32_e32 v6, vcc, v13, v6, vcc
global_load_dword v11, v[7:8], off
global_load_dword v12, v[9:10], off
global_load_dword v13, v[3:4], off
v_add_co_u32_e32 v9, vcc, s16, v9
v_addc_co_u32_e32 v10, vcc, v10, v14, vcc
global_load_dword v15, v[5:6], off
v_add_co_u32_e32 v3, vcc, s16, v3
v_addc_co_u32_e32 v4, vcc, v4, v14, vcc
global_load_dword v14, v[9:10], off
global_load_dword v16, v[3:4], off
v_add_u32_e32 v2, s4, v2
v_ashrrev_i32_e32 v3, 31, v2
v_lshlrev_b64 v[3:4], 2, v[2:3]
v_mov_b32_e32 v9, s10
v_add_co_u32_e32 v3, vcc, s3, v3
v_addc_co_u32_e32 v4, vcc, v9, v4, vcc
v_add_u32_e32 v9, s8, v2
v_ashrrev_i32_e32 v10, 31, v9
v_lshlrev_b64 v[9:10], 2, v[9:10]
v_mov_b32_e32 v17, s10
v_add_co_u32_e32 v9, vcc, s3, v9
v_addc_co_u32_e32 v10, vcc, v17, v10, vcc
v_add_u32_e32 v0, s5, v0
v_cmp_le_i32_e32 vcc, s7, v0
s_or_b64 s[0:1], vcc, s[0:1]
s_waitcnt vmcnt(2)
v_mul_f32_e32 v2, v13, v15
v_fma_f32 v2, v12, v11, -v2
global_store_dword v[7:8], v2, off
s_waitcnt vmcnt(2)
v_mul_f32_e32 v15, v14, v15
s_waitcnt vmcnt(1)
v_fmac_f32_e32 v15, v16, v11
global_store_dword v[5:6], v15, off
global_load_dword v2, v[9:10], off
s_nop 0
global_load_dword v5, v[3:4], off
s_waitcnt vmcnt(1)
v_mul_f32_e32 v6, v13, v2
v_mul_f32_e32 v2, v14, v2
s_waitcnt vmcnt(0)
v_fma_f32 v6, v12, v5, -v6
v_fmac_f32_e32 v2, v16, v5
global_store_dword v[3:4], v6, off
global_store_dword v[9:10], v2, off
s_andn2_b64 exec, exec, s[0:1]
s_cbranch_execnz 65425
s_endpgm
