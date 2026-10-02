.text
k_gemv_f32_rows8_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
s_lshl_b32 s24, s23, 2
s_lshr_b32 s26, s23, 7
v_lshrrev_b32_e32 v1, 3, v0
v_and_b32_e32 v2, 7, v0
v_mov_b32_e32 v3, s6
v_lshlrev_b32_e32 v3, 3, v3
v_add_u32_e32 v4, v1, v3
v_mov_b32_e32 v5, s22
v_cmp_lt_u32_e64 vcc, v4, v5
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_lshlrev_b32_e32 v6, 6, v2
v_mul_lo_u32 v7, v4, s24
v_add_u32_e32 v7, v7, v6
v_mov_b32_e32 v8, s16
v_mov_b32_e32 v9, s17
v_mov_b32_e32 v10, 0
v_add_co_u32_e32 v8, vcc, v8, v7
v_addc_co_u32_e32 v9, vcc, v9, v10, vcc
v_mov_b32_e32 v11, s18
v_mov_b32_e32 v12, s19
v_add_co_u32_e32 v11, vcc, v11, v6
v_addc_co_u32_e32 v12, vcc, v12, v10, vcc
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v23, 0
s_mov_b32 s25, 0
L_loop:
global_load_dwordx4 v[28:31], v[8:9], off
global_load_dwordx4 v[32:35], v[8:9], off offset:16
global_load_dwordx4 v[36:39], v[8:9], off offset:32
global_load_dwordx4 v[40:43], v[8:9], off offset:48
global_load_dwordx4 v[44:47], v[11:12], off
global_load_dwordx4 v[48:51], v[11:12], off offset:16
global_load_dwordx4 v[52:55], v[11:12], off offset:32
global_load_dwordx4 v[56:59], v[11:12], off offset:48
s_waitcnt vmcnt(0)
v_fma_f32 v20, v28, v44, v20
v_fma_f32 v21, v29, v45, v21
v_fma_f32 v22, v30, v46, v22
v_fma_f32 v23, v31, v47, v23
v_fma_f32 v20, v32, v48, v20
v_fma_f32 v21, v33, v49, v21
v_fma_f32 v22, v34, v50, v22
v_fma_f32 v23, v35, v51, v23
v_fma_f32 v20, v36, v52, v20
v_fma_f32 v21, v37, v53, v21
v_fma_f32 v22, v38, v54, v22
v_fma_f32 v23, v39, v55, v23
v_fma_f32 v20, v40, v56, v20
v_fma_f32 v21, v41, v57, v21
v_fma_f32 v22, v42, v58, v22
v_fma_f32 v23, v43, v59, v23
v_mov_b32_e32 v60, 512
v_add_co_u32_e32 v8, vcc, v8, v60
v_addc_co_u32_e32 v9, vcc, v9, v10, vcc
v_add_co_u32_e32 v11, vcc, v11, v60
v_addc_co_u32_e32 v12, vcc, v12, v10, vcc
s_add_i32 s25, s25, 1
s_cmp_lt_u32 s25, s26
s_cbranch_scc1 L_loop
v_add_f32_e32 v20, v20, v21
v_add_f32_e32 v22, v22, v23
v_add_f32_e32 v24, v20, v22
v_lshlrev_b32_e32 v25, 2, v0
ds_write_b32 v25, v24
s_waitcnt lgkmcnt(0)
s_barrier
v_cmp_gt_u32_e32 vcc, 4, v2
s_and_saveexec_b64 s[2:3], vcc
v_lshlrev_b32_e32 v26, 2, v0
v_add_u32_e32 v26, 16, v26
ds_read_b32 v27, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v24, v24, v27
ds_write_b32 v25, v24
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 2, v2
s_and_saveexec_b64 s[2:3], vcc
v_lshlrev_b32_e32 v26, 2, v0
v_add_u32_e32 v26, 8, v26
ds_read_b32 v27, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v24, v24, v27
ds_write_b32 v25, v24
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_gt_u32_e32 vcc, 1, v2
s_and_saveexec_b64 s[2:3], vcc
v_lshlrev_b32_e32 v26, 2, v0
v_add_u32_e32 v26, 4, v26
ds_read_b32 v27, v26
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v24, v24, v27
ds_write_b32 v25, v24
s_or_b64 exec, exec, s[2:3]
s_barrier
v_cmp_eq_u32_e32 vcc, 0, v2
s_and_saveexec_b64 s[2:3], vcc
v_mov_b32_e32 v28, s6
v_lshlrev_b32_e32 v28, 3, v28
v_add_u32_e32 v28, v28, v1
v_lshlrev_b32_e32 v28, 2, v28
v_mov_b32_e32 v29, s20
v_mov_b32_e32 v30, s21
v_mov_b32_e32 v31, 0
v_add_co_u32_e32 v29, vcc, v29, v28
v_addc_co_u32_e32 v30, vcc, v30, v31, vcc
ds_read_b32 v27, v25
s_waitcnt lgkmcnt(0)
global_store_dword v[29:30], v27, off
s_or_b64 exec, exec, s[2:3]
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
