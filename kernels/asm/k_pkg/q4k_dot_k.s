.text
k_q4k_dot_k:
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
v_mul_hi_u32 v125, v50, s32
v_mul_lo_u32 v127, v125, s31
v_sub_u32_e32 v126, v50, v127
v_mul_lo_u32 v124, v126, s24
v_add_u32_e32 v124, v124, v52
v_lshlrev_b32_e32 v121, 2, v125
v_mov_b32_e32 v122, s28
v_mov_b32_e32 v123, s29
v_add_co_u32_e32 v122, vcc, v122, v121
v_addc_co_u32_e32 v123, vcc, v123, v3, vcc
global_load_dword v121, v[122:123], off
s_waitcnt vmcnt(0)
v_mul_lo_u32 v120, v121, s30
v_mov_b32_e32 v70, 0
v_mov_b32_e32 v71, 0
v_mov_b32_e32 v72, 0
v_mov_b32_e32 v73, 0
v_lshlrev_b32_e32 v56, 10, v56
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, v6, v56
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mov_b32_e32 v48, 144
v_mul_lo_u32 v2, v124, v48
v_add_u32_e32 v2, v2, v120
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dword v8, v[4:5], off
global_load_dword v16, v[4:5], off offset:4
global_load_dword v17, v[4:5], off offset:8
global_load_dword v18, v[4:5], off offset:12
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v9, v8
v_lshrrev_b32_e32 v10, 16, v8
v_cvt_f32_f16_e32 v10, v10
global_load_dwordx4 v[20:23], v[4:5], off offset:16
global_load_dwordx4 v[24:27], v[4:5], off offset:32
s_waitcnt vmcnt(0)
v_mov_b32_e32 v60, v16
v_and_b32_e32 v60, 0xff, v60
v_and_b32_e32 v60, 63, v60
v_mov_b32_e32 v61, v17
v_and_b32_e32 v61, 0xff, v61
v_and_b32_e32 v61, 63, v61
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v92, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v93, v10, v61
v_mul_f32_e32 v93, -1.0, v93
v_lshrrev_b32_e32 v60, 8, v16
v_and_b32_e32 v60, 0xff, v60
v_and_b32_e32 v60, 63, v60
v_lshrrev_b32_e32 v61, 8, v17
v_and_b32_e32 v61, 0xff, v61
v_and_b32_e32 v61, 63, v61
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v94, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v95, v10, v61
v_mul_f32_e32 v95, -1.0, v95
global_load_dwordx4 v[40:43], v[6:7], off offset:0
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v20
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:16
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v21
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:32
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v22
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:48
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v23
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:64
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v24
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:80
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v25
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:96
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v26
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:112
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v27
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:128
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:144
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:160
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:176
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:192
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:208
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:224
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:240
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[20:23], v[4:5], off offset:48
global_load_dwordx4 v[24:27], v[4:5], off offset:64
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v60, 16, v16
v_and_b32_e32 v60, 0xff, v60
v_and_b32_e32 v60, 63, v60
v_lshrrev_b32_e32 v61, 16, v17
v_and_b32_e32 v61, 0xff, v61
v_and_b32_e32 v61, 63, v61
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v92, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v93, v10, v61
v_mul_f32_e32 v93, -1.0, v93
v_lshrrev_b32_e32 v60, 24, v16
v_and_b32_e32 v60, 0xff, v60
v_and_b32_e32 v60, 63, v60
v_lshrrev_b32_e32 v61, 24, v17
v_and_b32_e32 v61, 0xff, v61
v_and_b32_e32 v61, 63, v61
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v94, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v95, v10, v61
v_mul_f32_e32 v95, -1.0, v95
global_load_dwordx4 v[40:43], v[6:7], off offset:256
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v20
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:272
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v21
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:288
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v22
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:304
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v23
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:320
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v24
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:336
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v25
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:352
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v26
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:368
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v27
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:384
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:400
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:416
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:432
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:448
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:464
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:480
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:496
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[20:23], v[4:5], off offset:80
global_load_dwordx4 v[24:27], v[4:5], off offset:96
s_waitcnt vmcnt(0)
v_mov_b32_e32 v62, v18
v_and_b32_e32 v62, 0xff, v62
v_and_b32_e32 v60, 15, v62
v_mov_b32_e32 v63, v16
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v60, v60, v63
v_lshrrev_b32_e32 v61, 4, v62
v_mov_b32_e32 v63, v17
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v61, v61, v63
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v92, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v93, v10, v61
v_mul_f32_e32 v93, -1.0, v93
v_lshrrev_b32_e32 v62, 8, v18
v_and_b32_e32 v62, 0xff, v62
v_and_b32_e32 v60, 15, v62
v_lshrrev_b32_e32 v63, 8, v16
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v60, v60, v63
v_lshrrev_b32_e32 v61, 4, v62
v_lshrrev_b32_e32 v63, 8, v17
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v61, v61, v63
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v94, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v95, v10, v61
v_mul_f32_e32 v95, -1.0, v95
global_load_dwordx4 v[40:43], v[6:7], off offset:512
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v20
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:528
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v21
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:544
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v22
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:560
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v23
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:576
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v24
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:592
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v25
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:608
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v26
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:624
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v27
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:640
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:656
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:672
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:688
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:704
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:720
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:736
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:752
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[20:23], v[4:5], off offset:112
global_load_dwordx4 v[24:27], v[4:5], off offset:128
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v62, 16, v18
v_and_b32_e32 v62, 0xff, v62
v_and_b32_e32 v60, 15, v62
v_lshrrev_b32_e32 v63, 16, v16
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v60, v60, v63
v_lshrrev_b32_e32 v61, 4, v62
v_lshrrev_b32_e32 v63, 16, v17
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v61, v61, v63
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v92, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v93, v10, v61
v_mul_f32_e32 v93, -1.0, v93
v_lshrrev_b32_e32 v62, 24, v18
v_and_b32_e32 v62, 0xff, v62
v_and_b32_e32 v60, 15, v62
v_lshrrev_b32_e32 v63, 24, v16
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v60, v60, v63
v_lshrrev_b32_e32 v61, 4, v62
v_lshrrev_b32_e32 v63, 24, v17
v_and_b32_e32 v63, 0xff, v63
v_lshrrev_b32_e32 v63, 6, v63
v_lshlrev_b32_e32 v63, 4, v63
v_or_b32_e32 v61, v61, v63
v_cvt_f32_u32_e32 v60, v60
v_mul_f32_e32 v94, v9, v60
v_cvt_f32_u32_e32 v61, v61
v_mul_f32_e32 v95, v10, v61
v_mul_f32_e32 v95, -1.0, v95
global_load_dwordx4 v[40:43], v[6:7], off offset:768
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v20
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:784
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v21
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:800
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v22
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:816
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v23
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:832
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v24
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:848
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v25
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:864
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v26
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:880
s_waitcnt vmcnt(0)
v_and_b32_e32 v30, 0xf, v27
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 8, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 16, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 24, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v92, v93
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:896
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v20
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:912
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v21
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:928
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v22
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:944
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v23
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:960
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v24
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:976
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v25
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:992
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v26
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
global_load_dwordx4 v[40:43], v[6:7], off offset:1008
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 4, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v70, v30, v40, v70
v_lshrrev_b32_e32 v30, 12, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v71, v30, v41, v71
v_lshrrev_b32_e32 v30, 20, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v72, v30, v42, v72
v_lshrrev_b32_e32 v30, 28, v27
v_and_b32_e32 v30, 0xf, v30
v_cvt_f32_u32_e32 v30, v30
v_fma_f32 v30, v30, v94, v95
v_fma_f32 v73, v30, v43, v73
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
