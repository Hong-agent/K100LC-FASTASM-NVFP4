.text
k_iq3xxs_dot_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_load_dword s28, s[4:5], 0x30
s_load_dword s29, s[4:5], 0x34
s_load_dword s30, s[4:5], 0x38
s_load_dword s31, s[4:5], 0x3c
s_load_dword s32, s[4:5], 0x40
s_load_dword s33, s[4:5], 0x44
s_load_dword s34, s[4:5], 0x48
s_load_dword s35, s[4:5], 0x4c
s_load_dword s36, s[4:5], 0x50
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s23
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mul_hi_u32 v50, v1, s25
v_mul_lo_u32 v51, v50, s24
v_sub_u32_e32 v52, v1, v51
v_mul_hi_u32 v53, v50, s27
v_mul_lo_u32 v54, v53, s26
v_sub_u32_e32 v55, v50, v54
v_mul_lo_u32 v56, v53, s24
v_add_u32_e32 v56, v56, v52
v_mul_hi_u32 v125, v50, s36
v_mul_lo_u32 v127, v125, s35
v_sub_u32_e32 v126, v50, v127
v_mul_lo_u32 v124, v126, s24
v_add_u32_e32 v124, v124, v52
v_lshlrev_b32_e32 v121, 2, v125
v_mov_b32_e32 v122, s32
v_mov_b32_e32 v123, s33
v_add_co_u32_e32 v122, vcc, v122, v121
v_addc_co_u32_e32 v123, vcc, v123, v3, vcc
global_load_dword v121, v[122:123], off
s_waitcnt vmcnt(0)
v_mul_lo_u32 v120, v121, s34
v_mov_b32_e32 v70, 0
v_mov_b32_e32 v71, 0
v_mov_b32_e32 v72, 0
v_mov_b32_e32 v73, 0
v_lshlrev_b32_e32 v56, 10, v56
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, v6, v56
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mov_b32_e32 v9, s28
v_mov_b32_e32 v10, s29
v_mov_b32_e32 v11, s30
v_mov_b32_e32 v12, s31
v_mov_b32_e32 v80, 98
v_mul_lo_u32 v2, v124, v80
v_add_u32_e32 v2, v2, v120
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_ushort v8, v[4:5], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v8, v8
global_load_ubyte v15, v[4:5], off offset:66
global_load_ubyte v16, v[4:5], off offset:67
global_load_ubyte v17, v[4:5], off offset:68
global_load_ubyte v18, v[4:5], off offset:69
global_load_ubyte v20, v[4:5], off offset:2
global_load_ubyte v21, v[4:5], off offset:3
global_load_ubyte v22, v[4:5], off offset:4
global_load_ubyte v23, v[4:5], off offset:5
global_load_ubyte v24, v[4:5], off offset:6
global_load_ubyte v25, v[4:5], off offset:7
global_load_ubyte v26, v[4:5], off offset:8
global_load_ubyte v27, v[4:5], off offset:9
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:0
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:16
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:32
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:48
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:64
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:80
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:96
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:112
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:70
global_load_ubyte v16, v[4:5], off offset:71
global_load_ubyte v17, v[4:5], off offset:72
global_load_ubyte v18, v[4:5], off offset:73
global_load_ubyte v20, v[4:5], off offset:10
global_load_ubyte v21, v[4:5], off offset:11
global_load_ubyte v22, v[4:5], off offset:12
global_load_ubyte v23, v[4:5], off offset:13
global_load_ubyte v24, v[4:5], off offset:14
global_load_ubyte v25, v[4:5], off offset:15
global_load_ubyte v26, v[4:5], off offset:16
global_load_ubyte v27, v[4:5], off offset:17
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:128
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:144
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:160
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:176
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:192
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:208
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:224
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:240
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:74
global_load_ubyte v16, v[4:5], off offset:75
global_load_ubyte v17, v[4:5], off offset:76
global_load_ubyte v18, v[4:5], off offset:77
global_load_ubyte v20, v[4:5], off offset:18
global_load_ubyte v21, v[4:5], off offset:19
global_load_ubyte v22, v[4:5], off offset:20
global_load_ubyte v23, v[4:5], off offset:21
global_load_ubyte v24, v[4:5], off offset:22
global_load_ubyte v25, v[4:5], off offset:23
global_load_ubyte v26, v[4:5], off offset:24
global_load_ubyte v27, v[4:5], off offset:25
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:256
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:272
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:288
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:304
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:320
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:336
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:352
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:368
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:78
global_load_ubyte v16, v[4:5], off offset:79
global_load_ubyte v17, v[4:5], off offset:80
global_load_ubyte v18, v[4:5], off offset:81
global_load_ubyte v20, v[4:5], off offset:26
global_load_ubyte v21, v[4:5], off offset:27
global_load_ubyte v22, v[4:5], off offset:28
global_load_ubyte v23, v[4:5], off offset:29
global_load_ubyte v24, v[4:5], off offset:30
global_load_ubyte v25, v[4:5], off offset:31
global_load_ubyte v26, v[4:5], off offset:32
global_load_ubyte v27, v[4:5], off offset:33
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:384
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:400
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:416
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:432
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:448
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:464
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:480
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:496
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:82
global_load_ubyte v16, v[4:5], off offset:83
global_load_ubyte v17, v[4:5], off offset:84
global_load_ubyte v18, v[4:5], off offset:85
global_load_ubyte v20, v[4:5], off offset:34
global_load_ubyte v21, v[4:5], off offset:35
global_load_ubyte v22, v[4:5], off offset:36
global_load_ubyte v23, v[4:5], off offset:37
global_load_ubyte v24, v[4:5], off offset:38
global_load_ubyte v25, v[4:5], off offset:39
global_load_ubyte v26, v[4:5], off offset:40
global_load_ubyte v27, v[4:5], off offset:41
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:512
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:528
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:544
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:560
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:576
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:592
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:608
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:624
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:86
global_load_ubyte v16, v[4:5], off offset:87
global_load_ubyte v17, v[4:5], off offset:88
global_load_ubyte v18, v[4:5], off offset:89
global_load_ubyte v20, v[4:5], off offset:42
global_load_ubyte v21, v[4:5], off offset:43
global_load_ubyte v22, v[4:5], off offset:44
global_load_ubyte v23, v[4:5], off offset:45
global_load_ubyte v24, v[4:5], off offset:46
global_load_ubyte v25, v[4:5], off offset:47
global_load_ubyte v26, v[4:5], off offset:48
global_load_ubyte v27, v[4:5], off offset:49
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:640
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:656
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:672
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:688
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:704
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:720
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:736
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:752
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:90
global_load_ubyte v16, v[4:5], off offset:91
global_load_ubyte v17, v[4:5], off offset:92
global_load_ubyte v18, v[4:5], off offset:93
global_load_ubyte v20, v[4:5], off offset:50
global_load_ubyte v21, v[4:5], off offset:51
global_load_ubyte v22, v[4:5], off offset:52
global_load_ubyte v23, v[4:5], off offset:53
global_load_ubyte v24, v[4:5], off offset:54
global_load_ubyte v25, v[4:5], off offset:55
global_load_ubyte v26, v[4:5], off offset:56
global_load_ubyte v27, v[4:5], off offset:57
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:768
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:784
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:800
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:816
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:832
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:848
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:864
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:880
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
global_load_ubyte v15, v[4:5], off offset:94
global_load_ubyte v16, v[4:5], off offset:95
global_load_ubyte v17, v[4:5], off offset:96
global_load_ubyte v18, v[4:5], off offset:97
global_load_ubyte v20, v[4:5], off offset:58
global_load_ubyte v21, v[4:5], off offset:59
global_load_ubyte v22, v[4:5], off offset:60
global_load_ubyte v23, v[4:5], off offset:61
global_load_ubyte v24, v[4:5], off offset:62
global_load_ubyte v25, v[4:5], off offset:63
global_load_ubyte v26, v[4:5], off offset:64
global_load_ubyte v27, v[4:5], off offset:65
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v16, 8, v16
v_or_b32_e32 v15, v15, v16
v_lshlrev_b32_e32 v18, 8, v18
v_or_b32_e32 v17, v17, v18
v_lshlrev_b32_e32 v18, 16, v17
v_or_b32_e32 v13, v15, v18
v_lshrrev_b32_e32 v15, 28, v13
v_cvt_f32_u32_e32 v15, v15
v_add_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v15, 0.5, v15
v_mul_f32_e32 v14, v8, v15
v_and_b32_e32 v17, 127, v13
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v20
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:896
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v21
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:912
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 7, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v22
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:928
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v23
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:944
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 14, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v24
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:960
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v25
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:976
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshrrev_b32_e32 v17, 21, v13
v_and_b32_e32 v17, 127, v17
v_mov_b32_e32 v29, v11
v_mov_b32_e32 v30, v12
v_add_co_u32_e32 v29, vcc, v29, v17
v_addc_co_u32_e32 v30, vcc, v30, v3, vcc
global_load_ubyte v28, v[29:30], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v17, 2, v26
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v33, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 0, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 1, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 2, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v33
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 3, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:992
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_lshlrev_b32_e32 v17, 2, v27
v_mov_b32_e32 v31, v9
v_mov_b32_e32 v32, v10
v_add_co_u32_e32 v31, vcc, v31, v17
v_addc_co_u32_e32 v32, vcc, v32, v3, vcc
global_load_dword v34, v[31:32], off
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v35, 0, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 4, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v40, v14, v35
v_lshrrev_b32_e32 v35, 8, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 5, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v41, v14, v35
v_lshrrev_b32_e32 v35, 16, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 6, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v42, v14, v35
v_lshrrev_b32_e32 v35, 24, v34
v_and_b32_e32 v35, 0xff, v35
v_cvt_f32_u32_e32 v35, v35
v_lshrrev_b32_e32 v36, 7, v28
v_and_b32_e32 v36, 1, v36
v_cvt_f32_u32_e32 v36, v36
v_fma_f32 v36, v36, -2.0, 1.0
v_mul_f32_e32 v35, v35, v36
v_mul_f32_e32 v43, v14, v35
global_load_dwordx4 v[64:67], v[6:7], off offset:1008
s_waitcnt vmcnt(0)
v_fma_f32 v70, v40, v64, v70
v_fma_f32 v71, v41, v65, v71
v_fma_f32 v72, v42, v66, v72
v_fma_f32 v73, v43, v67, v73
v_add_f32_e32 v70, v70, v71
v_add_f32_e32 v72, v72, v73
v_add_f32_e32 v70, v70, v72
v_lshlrev_b32_e32 v57, 2, v1
v_mov_b32_e32 v59, s21
v_add_co_u32_e32 v58, vcc, s20, v57
v_addc_co_u32_e32 v59, vcc, v59, v3, vcc
global_store_dword v[58:59], v70, off
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
