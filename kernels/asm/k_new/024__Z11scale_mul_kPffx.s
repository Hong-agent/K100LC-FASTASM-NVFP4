.text
k__Z11scale_mul_kPffx:
s_load_dword s2, s[4:5], 0x24
s_load_dwordx2 s[0:1], s[4:5], 0x10
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
s_waitcnt lgkmcnt(0)
s_and_b32 s2, s2, 0xffff
v_mad_u64_u32 v[0:1], s[2:3], s2, v2, v[0:1]
v_cmp_gt_i64_e32 vcc, s[0:1], v[0:1]
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 16
s_load_dwordx2 s[0:1], s[4:5], 0x0
s_load_dword s2, s[4:5], 0x8
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
global_load_dword v2, v[0:1], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v2, s2, v2
global_store_dword v[0:1], v2, off
s_endpgm
