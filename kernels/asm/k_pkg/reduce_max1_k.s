.text
k_reduce_max1_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v8, 0xff800000
v_cmp_gt_u32_e32 vcc, s20, v0
s_and_saveexec_b64 s[0:1], vcc
v_lshlrev_b32_e32 v2, 2, v0
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_mov_b32_e32 v3, 0
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dword v8, v[4:5], off
s_waitcnt vmcnt(0)
s_or_b64 exec, exec, s[0:1]
v_lshlrev_b32_e32 v11, 2, v0
ds_write_b32 v11, v8
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 128
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 64
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 32
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 16
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 8
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v19, 4
v_add_u32_e32 v19, v11, v19
ds_read_b32 v18, v19
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v8, v8, v18
ds_write_b32 v11, v8
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v12, s18
v_mov_b32_e32 v13, s19
global_store_dword v[12:13], v8, off
s_or_b64 exec, exec, s[2:3]
s_endpgm
