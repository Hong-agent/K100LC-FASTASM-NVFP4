.text
k_gemv_i8_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_load_dword s28, s[4:5], 0x30
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s28
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s24, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v2, s26
v_mul_lo_u32 v2, v1, v2
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v2, s27
v_mul_lo_u32 v2, v1, v2
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, v6, v2
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mov_b32_e32 v8, s20
v_mov_b32_e32 v9, s21
v_lshlrev_b32_e32 v44, 2, v1
v_mov_b32_e32 v45, s23
v_add_co_u32_e32 v44, vcc, s22, v44
v_addc_co_u32_e32 v45, vcc, v45, v3, vcc
v_mov_b32_e32 v46, 32
v_mov_b32_e32 v47, 4
v_mov_b32_e32 v48, 128
s_mov_b32 s29, 0
v_mov_b32_e32 v49, 4
v_mov_b32_e32 v102, 0
L_loop:
global_load_dword v23, v[4:5], off offset:0
global_load_dword v24, v[4:5], off offset:4
global_load_dword v25, v[4:5], off offset:8
global_load_dword v26, v[4:5], off offset:12
global_load_dword v27, v[4:5], off offset:16
global_load_dword v28, v[4:5], off offset:20
global_load_dword v29, v[4:5], off offset:24
global_load_dword v30, v[4:5], off offset:28
global_load_dwordx4 v[64:67], v[8:9], off offset:0
global_load_dwordx4 v[68:71], v[8:9], off offset:16
global_load_dwordx4 v[72:75], v[8:9], off offset:32
global_load_dwordx4 v[76:79], v[8:9], off offset:48
global_load_dwordx4 v[80:83], v[8:9], off offset:64
global_load_dwordx4 v[84:87], v[8:9], off offset:80
global_load_dwordx4 v[88:91], v[8:9], off offset:96
global_load_dwordx4 v[92:95], v[8:9], off offset:112
s_waitcnt vmcnt(0)
v_mov_b32_e32 v96, 0
v_mov_b32_e32 v97, 0
v_mov_b32_e32 v98, 0
v_mov_b32_e32 v99, 0
v_lshrrev_b32_e32 v100, 0, v23
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v64, v96
v_lshrrev_b32_e32 v100, 8, v23
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v65, v97
v_lshrrev_b32_e32 v100, 16, v23
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v66, v98
v_lshrrev_b32_e32 v100, 24, v23
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v67, v99
v_lshrrev_b32_e32 v100, 0, v24
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v68, v96
v_lshrrev_b32_e32 v100, 8, v24
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v69, v97
v_lshrrev_b32_e32 v100, 16, v24
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v70, v98
v_lshrrev_b32_e32 v100, 24, v24
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v71, v99
v_lshrrev_b32_e32 v100, 0, v25
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v72, v96
v_lshrrev_b32_e32 v100, 8, v25
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v73, v97
v_lshrrev_b32_e32 v100, 16, v25
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v74, v98
v_lshrrev_b32_e32 v100, 24, v25
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v75, v99
v_lshrrev_b32_e32 v100, 0, v26
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v76, v96
v_lshrrev_b32_e32 v100, 8, v26
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v77, v97
v_lshrrev_b32_e32 v100, 16, v26
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v78, v98
v_lshrrev_b32_e32 v100, 24, v26
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v79, v99
v_lshrrev_b32_e32 v100, 0, v27
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v80, v96
v_lshrrev_b32_e32 v100, 8, v27
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v81, v97
v_lshrrev_b32_e32 v100, 16, v27
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v82, v98
v_lshrrev_b32_e32 v100, 24, v27
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v83, v99
v_lshrrev_b32_e32 v100, 0, v28
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v84, v96
v_lshrrev_b32_e32 v100, 8, v28
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v85, v97
v_lshrrev_b32_e32 v100, 16, v28
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v86, v98
v_lshrrev_b32_e32 v100, 24, v28
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v87, v99
v_lshrrev_b32_e32 v100, 0, v29
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v88, v96
v_lshrrev_b32_e32 v100, 8, v29
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v89, v97
v_lshrrev_b32_e32 v100, 16, v29
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v90, v98
v_lshrrev_b32_e32 v100, 24, v29
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v91, v99
v_lshrrev_b32_e32 v100, 0, v30
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v96, v100, v92, v96
v_lshrrev_b32_e32 v100, 8, v30
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v97, v100, v93, v97
v_lshrrev_b32_e32 v100, 16, v30
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v98, v100, v94, v98
v_lshrrev_b32_e32 v100, 24, v30
v_lshlrev_b32_e32 v100, 24, v100
v_ashrrev_i32_e32 v100, 24, v100
v_cvt_f32_i32_e32 v100, v100
v_fma_f32 v99, v100, v95, v99
v_add_f32_e32 v96, v96, v97
v_add_f32_e32 v98, v98, v99
v_add_f32_e32 v96, v96, v98
global_load_dword v101, v[6:7], off
s_waitcnt vmcnt(0)
v_mul_f32_e32 v96, v101, v96
v_add_f32_e32 v102, v102, v96
v_add_co_u32_e32 v4, vcc, v4, v46
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_add_co_u32_e32 v8, vcc, v8, v48
v_addc_co_u32_e32 v9, vcc, v9, v3, vcc
v_add_co_u32_e32 v6, vcc, v6, v49
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
s_add_i32 s29, s29, 1
s_cmp_lt_u32 s29, s25
s_cbranch_scc1 L_loop
global_store_dword v[44:45], v102, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
