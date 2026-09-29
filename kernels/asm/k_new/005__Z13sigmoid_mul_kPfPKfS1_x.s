.text
k__Z13sigmoid_mul_kPfPKfS1_x:
s_load_dword s2, s[4:5], 0x2c
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_add_u32 s0, s4, 32
s_addc_u32 s1, s5, 0
v_mov_b32_e32 v1, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s2, s2, 0xffff
v_mov_b32_e32 v2, s6
v_mad_u64_u32 v[0:1], s[4:5], s2, v2, v[0:1]
v_cmp_gt_i64_e32 vcc, s[14:15], v[0:1]
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 63
s_load_dword s0, s[0:1], 0x0
v_lshlrev_b64 v[2:3], 2, v[0:1]
s_mov_b64 s[16:17], 0
s_waitcnt lgkmcnt(0)
s_mul_hi_u32 s5, s2, s0
s_mul_i32 s4, s2, s0
s_lshl_b64 s[6:7], s[4:5], 2
v_mov_b32_e32 v5, s13
v_add_co_u32_e32 v4, vcc, s12, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dword v7, v[4:5], off
v_mov_b32_e32 v6, s11
v_add_co_u32_e32 v4, vcc, s10, v2
v_addc_co_u32_e32 v5, vcc, v6, v3, vcc
global_load_dword v6, v[4:5], off
v_mov_b32_e32 v8, s9
v_mov_b32_e32 v10, s5
s_waitcnt vmcnt(1)
v_mul_f32_e32 v4, 0xbfb8aa3b, v7
s_nop 0
v_exp_f32_e32 v4, v4
v_add_f32_e32 v7, 1.0, v4
s_waitcnt vmcnt(0)
v_div_scale_f32 v4, s[0:1], v7, v7, v6
v_div_scale_f32 v5, vcc, v6, v7, v6
v_rcp_f32_e32 v9, v4
v_fma_f32 v11, -v4, v9, 1.0
v_fmac_f32_e32 v9, v11, v9
v_mul_f32_e32 v11, v5, v9
v_fma_f32 v12, -v4, v11, v5
v_fmac_f32_e32 v11, v12, v9
v_fma_f32 v4, -v4, v11, v5
v_div_fmas_f32 v9, v4, v9, v11
v_add_co_u32_e32 v0, vcc, s4, v0
v_mov_b32_e32 v11, s7
v_add_co_u32_e64 v4, s[0:1], s8, v2
v_add_co_u32_e64 v2, s[2:3], s6, v2
v_addc_co_u32_e64 v5, s[0:1], v8, v3, s[0:1]
v_addc_co_u32_e32 v1, vcc, v1, v10, vcc
v_addc_co_u32_e64 v3, vcc, v3, v11, s[2:3]
v_cmp_le_i64_e32 vcc, s[14:15], v[0:1]
s_or_b64 s[16:17], vcc, s[16:17]
v_div_fixup_f32 v6, v9, v7, v6
global_store_dword v[4:5], v6, off
s_andn2_b64 exec, exec, s[16:17]
s_cbranch_execnz 65482
s_endpgm
