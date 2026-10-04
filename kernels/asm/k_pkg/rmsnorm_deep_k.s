.text
k_rmsnorm_deep_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
s_lshr_b32 s24, s22, 6
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
v_mul_lo_u32 v3, v2, s22
v_lshlrev_b32_e32 v3, 2, v3
v_mov_b32_e32 v4, s18
v_mov_b32_e32 v5, s19
v_add_co_u32_e32 v4, vcc, v4, v3
v_addc_co_u32_e32 v5, vcc, v5, v1, vcc
v_mov_b32_e32 v6, s16
v_mov_b32_e32 v7, s17
v_add_co_u32_e32 v6, vcc, v6, v3
v_addc_co_u32_e32 v7, vcc, v7, v1, vcc
v_lshlrev_b32_e32 v8, 2, v0
v_mov_b32_e32 v16, 0
s_mov_b32 s25, 0
L_sb:
s_add_i32 s26, s25, 15
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_s1
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_dword v100, v[10:11], off offset:0
global_load_dword v101, v[10:11], off offset:256
global_load_dword v102, v[10:11], off offset:512
global_load_dword v103, v[10:11], off offset:768
global_load_dword v104, v[10:11], off offset:1024
global_load_dword v105, v[10:11], off offset:1280
global_load_dword v106, v[10:11], off offset:1536
global_load_dword v107, v[10:11], off offset:1792
global_load_dword v108, v[10:11], off offset:2048
global_load_dword v109, v[10:11], off offset:2304
global_load_dword v110, v[10:11], off offset:2560
global_load_dword v111, v[10:11], off offset:2816
global_load_dword v112, v[10:11], off offset:3072
global_load_dword v113, v[10:11], off offset:3328
global_load_dword v114, v[10:11], off offset:3584
global_load_dword v115, v[10:11], off offset:3840
s_waitcnt vmcnt(0)
v_fma_f32 v16, v100, v100, v16
v_fma_f32 v16, v101, v101, v16
v_fma_f32 v16, v102, v102, v16
v_fma_f32 v16, v103, v103, v16
v_fma_f32 v16, v104, v104, v16
v_fma_f32 v16, v105, v105, v16
v_fma_f32 v16, v106, v106, v16
v_fma_f32 v16, v107, v107, v16
v_fma_f32 v16, v108, v108, v16
v_fma_f32 v16, v109, v109, v16
v_fma_f32 v16, v110, v110, v16
v_fma_f32 v16, v111, v111, v16
v_fma_f32 v16, v112, v112, v16
v_fma_f32 v16, v113, v113, v16
v_fma_f32 v16, v114, v114, v16
v_fma_f32 v16, v115, v115, v16
s_add_i32 s25, s25, 16
s_branch L_sb
L_s1:
s_cmp_lt_u32 s25, s24
s_cbranch_scc0 L_s1_done
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_dword v100, v[10:11], off
s_waitcnt vmcnt(0)
v_fma_f32 v16, v100, v100, v16
s_add_i32 s25, s25, 1
s_branch L_s1
L_s1_done:
ds_write_b32 v8, v16
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 32, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 128
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 16, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 64
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 8, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 32
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 16
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 8
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 4
v_add_u32_e32 v9, v9, v8
ds_read_b32 v26, v9
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v16, v16, v26
ds_write_b32 v8, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v0
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v9, 256
ds_write_b32 v9, v16
s_or_b64 exec, exec, s[2:3]
s_barrier
v_mov_b32_e32 v9, 256
ds_read_b32 v17, v9
s_waitcnt lgkmcnt(0)
v_cvt_f32_u32_e32 v18, s22
s_nop 0
v_rcp_f32_e32 v18, v18
s_nop 0
v_mul_f32_e32 v17, v17, v18
v_mov_b32_e32 v19, s23
v_add_f32_e32 v17, v17, v19
s_nop 0
v_rsq_f32_e32 v17, v17
s_nop 0
s_mov_b32 s25, 0
L_nb:
s_add_i32 s26, s25, 15
s_cmp_lt_u32 s26, s24
s_cbranch_scc0 L_n1
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
v_mov_b32_e32 v19, s21
v_add_co_u32_e32 v18, vcc, s20, v9
v_addc_co_u32_e32 v19, vcc, v19, v1, vcc
v_mov_b32_e32 v25, v7
v_add_co_u32_e32 v24, vcc, v6, v9
v_addc_co_u32_e32 v25, vcc, v25, v1, vcc
global_load_dword v100, v[10:11], off offset:0
global_load_dword v101, v[10:11], off offset:256
global_load_dword v102, v[10:11], off offset:512
global_load_dword v103, v[10:11], off offset:768
global_load_dword v104, v[10:11], off offset:1024
global_load_dword v105, v[10:11], off offset:1280
global_load_dword v106, v[10:11], off offset:1536
global_load_dword v107, v[10:11], off offset:1792
global_load_dword v108, v[10:11], off offset:2048
global_load_dword v109, v[10:11], off offset:2304
global_load_dword v110, v[10:11], off offset:2560
global_load_dword v111, v[10:11], off offset:2816
global_load_dword v112, v[10:11], off offset:3072
global_load_dword v113, v[10:11], off offset:3328
global_load_dword v114, v[10:11], off offset:3584
global_load_dword v115, v[10:11], off offset:3840
global_load_dword v120, v[18:19], off offset:0
global_load_dword v121, v[18:19], off offset:256
global_load_dword v122, v[18:19], off offset:512
global_load_dword v123, v[18:19], off offset:768
global_load_dword v124, v[18:19], off offset:1024
global_load_dword v125, v[18:19], off offset:1280
global_load_dword v126, v[18:19], off offset:1536
global_load_dword v127, v[18:19], off offset:1792
global_load_dword v128, v[18:19], off offset:2048
global_load_dword v129, v[18:19], off offset:2304
global_load_dword v130, v[18:19], off offset:2560
global_load_dword v131, v[18:19], off offset:2816
global_load_dword v132, v[18:19], off offset:3072
global_load_dword v133, v[18:19], off offset:3328
global_load_dword v134, v[18:19], off offset:3584
global_load_dword v135, v[18:19], off offset:3840
s_waitcnt vmcnt(0)
v_mul_f32_e32 v100, v100, v17
v_mul_f32_e32 v101, v101, v17
v_mul_f32_e32 v102, v102, v17
v_mul_f32_e32 v103, v103, v17
v_mul_f32_e32 v104, v104, v17
v_mul_f32_e32 v105, v105, v17
v_mul_f32_e32 v106, v106, v17
v_mul_f32_e32 v107, v107, v17
v_mul_f32_e32 v108, v108, v17
v_mul_f32_e32 v109, v109, v17
v_mul_f32_e32 v110, v110, v17
v_mul_f32_e32 v111, v111, v17
v_mul_f32_e32 v112, v112, v17
v_mul_f32_e32 v113, v113, v17
v_mul_f32_e32 v114, v114, v17
v_mul_f32_e32 v115, v115, v17
v_mul_f32_e32 v100, v100, v120
v_mul_f32_e32 v101, v101, v121
v_mul_f32_e32 v102, v102, v122
v_mul_f32_e32 v103, v103, v123
v_mul_f32_e32 v104, v104, v124
v_mul_f32_e32 v105, v105, v125
v_mul_f32_e32 v106, v106, v126
v_mul_f32_e32 v107, v107, v127
v_mul_f32_e32 v108, v108, v128
v_mul_f32_e32 v109, v109, v129
v_mul_f32_e32 v110, v110, v130
v_mul_f32_e32 v111, v111, v131
v_mul_f32_e32 v112, v112, v132
v_mul_f32_e32 v113, v113, v133
v_mul_f32_e32 v114, v114, v134
v_mul_f32_e32 v115, v115, v135
global_store_dword v[24:25], v100, off offset:0
global_store_dword v[24:25], v101, off offset:256
global_store_dword v[24:25], v102, off offset:512
global_store_dword v[24:25], v103, off offset:768
global_store_dword v[24:25], v104, off offset:1024
global_store_dword v[24:25], v105, off offset:1280
global_store_dword v[24:25], v106, off offset:1536
global_store_dword v[24:25], v107, off offset:1792
global_store_dword v[24:25], v108, off offset:2048
global_store_dword v[24:25], v109, off offset:2304
global_store_dword v[24:25], v110, off offset:2560
global_store_dword v[24:25], v111, off offset:2816
global_store_dword v[24:25], v112, off offset:3072
global_store_dword v[24:25], v113, off offset:3328
global_store_dword v[24:25], v114, off offset:3584
global_store_dword v[24:25], v115, off offset:3840
s_add_i32 s25, s25, 16
s_branch L_nb
L_n1:
s_cmp_lt_u32 s25, s24
s_cbranch_scc0 L_n1_done
v_mov_b32_e32 v9, s25
v_lshlrev_b32_e32 v9, 8, v9
v_add_u32_e32 v9, v9, v8
v_mov_b32_e32 v11, v5
v_add_co_u32_e32 v10, vcc, v4, v9
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
v_mov_b32_e32 v19, s21
v_add_co_u32_e32 v18, vcc, s20, v9
v_addc_co_u32_e32 v19, vcc, v19, v1, vcc
v_mov_b32_e32 v25, v7
v_add_co_u32_e32 v24, vcc, v6, v9
v_addc_co_u32_e32 v25, vcc, v25, v1, vcc
global_load_dword v100, v[10:11], off
global_load_dword v120, v[18:19], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v100, v100, v17
v_mul_f32_e32 v100, v100, v120
global_store_dword v[24:25], v100, off
s_add_i32 s25, s25, 1
s_branch L_n1
L_n1_done:
s_endpgm
