.text
k__Z8argmax_kPKfxPi:
s_load_dwordx4 s[8:11], s[4:5], 0x8
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v6, 0xff800000
v_mov_b32_e32 v7, -1
s_waitcnt lgkmcnt(0)
v_cmp_gt_i64_e32 vcc, s[8:9], v[0:1]
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 61
s_load_dword s6, s[4:5], 0x24
s_load_dwordx2 s[0:1], s[4:5], 0x0
v_lshlrev_b32_e32 v2, 2, v0
s_mov_b32 s14, 0
v_mov_b32_e32 v5, v1
s_waitcnt lgkmcnt(0)
s_and_b32 s15, s6, 0xffff
v_mov_b32_e32 v3, s1
v_add_co_u32_e32 v2, vcc, s0, v2
v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
s_lshl_b32 s16, s15, 2
s_mov_b32 s17, s14
s_mov_b64 s[6:7], 0
v_mov_b32_e32 v6, 0xff800000
v_mov_b32_e32 v7, -1
v_mov_b32_e32 v4, v0
s_branch 11
s_or_b64 exec, exec, s[12:13]
v_mov_b32_e32 v1, s14
v_add_co_u32_e32 v4, vcc, s15, v4
v_addc_co_u32_e32 v5, vcc, v5, v1, vcc
v_cmp_le_i64_e32 vcc, s[8:9], v[4:5]
v_mov_b32_e32 v1, s17
s_or_b64 s[6:7], vcc, s[6:7]
v_add_co_u32_e32 v2, vcc, s16, v2
v_addc_co_u32_e32 v3, vcc, v3, v1, vcc
s_andn2_b64 exec, exec, s[6:7]
s_cbranch_execz 28
global_load_dword v1, v[2:3], off
s_mov_b64 s[0:1], 0
s_waitcnt vmcnt(0)
v_cmp_ngt_f32_e32 vcc, v1, v6
s_and_saveexec_b64 s[12:13], vcc
s_xor_b64 s[12:13], exec, s[12:13]
s_cbranch_execnz 6
s_andn2_saveexec_b64 s[12:13], s[12:13]
s_cbranch_execnz 11
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[12:13], s[0:1]
s_cbranch_execz 65512
s_branch 11
v_cmp_eq_f32_e32 vcc, v1, v6
v_cmp_gt_i32_e64 s[0:1], v7, v4
s_and_b64 s[0:1], vcc, s[0:1]
s_and_b64 s[0:1], s[0:1], exec
s_andn2_saveexec_b64 s[12:13], s[12:13]
s_cbranch_execz 65525
s_or_b64 s[0:1], s[0:1], exec
s_or_b64 exec, exec, s[12:13]
s_and_saveexec_b64 s[12:13], s[0:1]
s_cbranch_execz 65500
v_mov_b32_e32 v7, v4
v_mov_b32_e32 v6, v1
s_branch 65497
s_or_b64 exec, exec, s[6:7]
s_or_b64 exec, exec, s[2:3]
v_mbcnt_lo_u32_b32 v1, -1, 0
v_mbcnt_hi_u32_b32 v1, -1, v1
v_and_b32_e32 v2, 63, v1
v_and_b32_e32 v3, 64, v1
v_add_u32_e32 v9, 64, v3
v_xor_b32_e32 v3, 16, v2
v_cmp_lt_i32_e32 vcc, v3, v9
v_cndmask_b32_e32 v3, v1, v3, vcc
v_lshlrev_b32_e32 v3, 2, v3
ds_bpermute_b32 v4, v3, v6
ds_bpermute_b32 v5, v3, v7
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v6, v4
v_cmp_nlt_f32_e32 vcc, v6, v4
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v6, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v5, v7
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[6:7]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v6, v4
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, v5
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v4, 8, v2
v_cmp_lt_i32_e32 vcc, v4, v9
v_cndmask_b32_e32 v4, v1, v4, vcc
v_lshlrev_b32_e32 v4, 2, v4
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v5, v4, v6
ds_bpermute_b32 v8, v4, v7
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v6, v5
v_cmp_nlt_f32_e32 vcc, v6, v5
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v6, v5
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v8, v7
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[6:7]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v6, v5
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, v8
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v5, 4, v2
v_cmp_lt_i32_e32 vcc, v5, v9
v_cndmask_b32_e32 v5, v1, v5, vcc
v_lshlrev_b32_e32 v5, 2, v5
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v8, v5, v6
ds_bpermute_b32 v10, v5, v7
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v6, v8
v_cmp_nlt_f32_e32 vcc, v6, v8
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v6, v8
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v10, v7
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[6:7]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v6, v8
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, v10
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v8, 2, v2
v_cmp_lt_i32_e32 vcc, v8, v9
v_cndmask_b32_e32 v8, v1, v8, vcc
v_lshlrev_b32_e32 v8, 2, v8
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v10, v8, v6
ds_bpermute_b32 v11, v8, v7
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v6, v10
v_cmp_nlt_f32_e32 vcc, v6, v10
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v6, v10
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v11, v7
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[6:7]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
v_mov_b32_e32 v6, v10
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, v11
s_or_b64 exec, exec, s[0:1]
v_xor_b32_e32 v2, 1, v2
v_cmp_lt_i32_e32 vcc, v2, v9
v_cndmask_b32_e32 v1, v1, v2, vcc
v_lshlrev_b32_e32 v9, 2, v1
ds_bpermute_b32 v1, v9, v6
ds_bpermute_b32 v2, v9, v7
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v6, v1
v_cmp_nlt_f32_e32 vcc, v6, v1
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v6, v1
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v2, v7
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[6:7]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 3
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, v2
v_mov_b32_e32 v6, v1
s_or_b64 exec, exec, s[0:1]
v_and_b32_e32 v1, 31, v0
v_cmp_eq_u32_e32 vcc, 0, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 4
v_lshrrev_b32_e32 v1, 3, v0
v_and_b32_e32 v1, 28, v1
ds_write2_b32 v1, v7, v6 offset1:32
s_or_b64 exec, exec, s[0:1]
v_cmp_gt_u32_e32 vcc, 32, v0
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 143
s_load_dword s0, s[4:5], 0x24
v_mov_b32_e32 v2, 0xff800000
s_waitcnt lgkmcnt(0)
v_lshrrev_b16_e64 v1, 5, s0
v_cmp_lt_u32_e32 vcc, v0, v1
v_mov_b32_e32 v1, -1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 3
v_lshlrev_b32_e32 v1, 2, v0
ds_read2_b32 v[1:2], v1 offset1:32
s_or_b64 exec, exec, s[0:1]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v6, v3, v2
ds_bpermute_b32 v7, v3, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v6
v_cmp_nlt_f32_e32 vcc, v2, v6
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 9
v_cmp_eq_f32_e32 vcc, v2, v6
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v7, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
v_mov_b32_e32 v3, v2
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v6
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v7
v_mov_b32_e32 v2, v6
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v6, v4, v3
ds_bpermute_b32 v4, v4, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v6
v_cmp_nlt_f32_e32 vcc, v2, v6
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v6
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v4, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v6
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v4
v_mov_b32_e32 v2, v6
s_or_b64 exec, exec, s[0:1]
s_waitcnt lgkmcnt(0)
ds_bpermute_b32 v4, v5, v3
ds_bpermute_b32 v5, v5, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v4
v_cmp_nlt_f32_e32 vcc, v2, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v5, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v4
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v5
v_mov_b32_e32 v2, v4
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v4, v8, v3
s_waitcnt lgkmcnt(1)
ds_bpermute_b32 v5, v8, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v4
v_cmp_nlt_f32_e32 vcc, v2, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 8
v_cmp_eq_f32_e32 vcc, v2, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v5, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 4
v_mov_b32_e32 v3, v4
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v5
v_mov_b32_e32 v2, v4
s_or_b64 exec, exec, s[0:1]
ds_bpermute_b32 v4, v9, v3
ds_bpermute_b32 v3, v9, v1
s_waitcnt lgkmcnt(1)
v_cmp_lt_f32_e64 s[2:3], v2, v4
v_cmp_nlt_f32_e32 vcc, v2, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execnz 11
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execnz 19
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_b64 exec, exec, vcc
s_cbranch_execz 3
v_mov_b32_e32 v0, 0
global_store_dword v0, v1, s[10:11]
s_endpgm
v_cmp_eq_f32_e32 vcc, v2, v4
s_waitcnt lgkmcnt(0)
v_cmp_lt_i32_e64 s[0:1], v3, v1
s_and_b64 s[0:1], vcc, s[0:1]
s_andn2_b64 s[2:3], s[2:3], exec
s_and_b64 s[0:1], s[0:1], exec
s_or_b64 s[2:3], s[2:3], s[0:1]
s_or_b64 exec, exec, s[4:5]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 65517
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, v3
s_or_b64 exec, exec, s[0:1]
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_b64 exec, exec, vcc
s_cbranch_execnz 65515
s_branch 65517
