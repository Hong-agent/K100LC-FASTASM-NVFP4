.text
k__Z6fill_kPffx:
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
s_cbranch_execz 30
s_load_dword s6, s[0:1], 0x0
s_load_dwordx2 s[8:9], s[4:5], 0x0
s_load_dword s10, s[4:5], 0x8
v_lshlrev_b64 v[2:3], 2, v[0:1]
s_waitcnt lgkmcnt(0)
s_mul_hi_u32 s5, s7, s6
s_mul_i32 s4, s7, s6
v_mov_b32_e32 v4, s9
v_add_co_u32_e32 v2, vcc, s8, v2
v_addc_co_u32_e32 v3, vcc, v4, v3, vcc
s_lshl_b64 s[6:7], s[4:5], 2
s_mov_b64 s[8:9], 0
v_mov_b32_e32 v5, s5
v_add_co_u32_e32 v0, vcc, s4, v0
v_addc_co_u32_e32 v1, vcc, v1, v5, vcc
v_mov_b32_e32 v4, s10
v_cmp_le_i64_e64 s[0:1], s[2:3], v[0:1]
v_mov_b32_e32 v6, s7
global_store_dword v[2:3], v4, off
v_add_co_u32_e32 v2, vcc, s6, v2
s_or_b64 s[8:9], s[0:1], s[8:9]
v_addc_co_u32_e32 v3, vcc, v3, v6, vcc
s_andn2_b64 exec, exec, s[8:9]
s_cbranch_execnz 65522
s_endpgm
