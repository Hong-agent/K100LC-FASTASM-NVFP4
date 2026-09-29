.text
k__Z13add_inplace_kPfPKfx:
s_load_dword s7, s[4:5], 0x24
s_load_dwordx2 s[2:3], s[4:5], 0x10
s_add_u32 s0, s4, 24
s_addc_u32 s1, s5, 0
v_mov_b32_e32 v1, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s7, s7, 0xffff
v_mov_b32_e32 v2, s6
v_mad_u64_u32 v[0:1], s[8:9], s7, v2, v[0:1]
v_cmp_gt_i64_e32 vcc, s[2:3], v[0:1]
s_and_saveexec_b64 s[8:9], vcc
s_cbranch_execz 39
s_load_dword s6, s[0:1], 0x0
s_load_dwordx4 s[8:11], s[4:5], 0x0
v_lshlrev_b64 v[2:3], 2, v[0:1]
s_mov_b64 s[12:13], 0
s_waitcnt lgkmcnt(0)
s_mul_hi_u32 s5, s7, s6
s_mul_i32 s4, s7, s6
s_lshl_b64 s[6:7], s[4:5], 2
v_mov_b32_e32 v5, s11
v_add_co_u32_e64 v6, s[0:1], s10, v2
v_mov_b32_e32 v8, s9
v_add_co_u32_e32 v4, vcc, s8, v2
v_addc_co_u32_e64 v7, s[0:1], v5, v3, s[0:1]
v_addc_co_u32_e32 v5, vcc, v8, v3, vcc
global_load_dword v8, v[6:7], off
global_load_dword v9, v[4:5], off
v_mov_b32_e32 v6, s5
v_mov_b32_e32 v7, s7
v_add_co_u32_e32 v2, vcc, s6, v2
v_add_co_u32_e64 v0, s[0:1], s4, v0
v_addc_co_u32_e64 v1, s[0:1], v1, v6, s[0:1]
v_addc_co_u32_e32 v3, vcc, v3, v7, vcc
v_cmp_le_i64_e32 vcc, s[2:3], v[0:1]
s_or_b64 s[12:13], vcc, s[12:13]
s_waitcnt vmcnt(0)
v_add_f32_e32 v6, v8, v9
global_store_dword v[4:5], v6, off
s_andn2_b64 exec, exec, s[12:13]
s_cbranch_execnz 65508
s_endpgm
