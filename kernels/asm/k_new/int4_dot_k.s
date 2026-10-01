.text
k_int4_dot_k:
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
v_mul_hi_u32 v125, v50, s34
v_mul_lo_u32 v127, v125, s33
v_sub_u32_e32 v126, v50, v127
v_mul_lo_u32 v124, v126, s24
v_add_u32_e32 v124, v124, v52
v_lshlrev_b32_e32 v121, 2, v125
v_mov_b32_e32 v122, s30
v_mov_b32_e32 v123, s31
v_add_co_u32_e32 v122, vcc, v122, v121
v_addc_co_u32_e32 v123, vcc, v123, v3, vcc
global_load_dword v121, v[122:123], off
s_waitcnt vmcnt(0)
v_mul_lo_u32 v120, v121, s32
v_mov_b32_e32 v70, 0
v_mov_b32_e32 v71, 0
v_mov_b32_e32 v72, 0
v_mov_b32_e32 v73, 0
v_lshlrev_b32_e32 v56, 9, v56
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, v6, v56
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mul_lo_u32 v2, v124, 64
v_add_u32_e32 v2, v2, v120
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
global_load_dwordx4 v[8:11], v[4:5], off offset:0
global_load_dwordx4 v[12:15], v[4:5], off offset:16
global_load_dwordx4 v[16:19], v[4:5], off offset:32
global_load_dwordx4 v[20:23], v[4:5], off offset:48
v_lshrrev_b32_e32 v2, 5, v120
v_lshlrev_b32_e32 v44, 1, v124
v_add_u32_e32 v2, v2, v44
v_mov_b32_e32 v44, s28
v_mov_b32_e32 v45, s29
v_add_co_u32_e32 v44, vcc, v44, v2
v_addc_co_u32_e32 v45, vcc, v45, v3, vcc
global_load_ushort v24, v[44:45], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v25, 16, v24
v_mov_b32_e32 v26, 0xc1000000
global_load_dwordx4 v[100:103], v[6:7], off offset:0
global_load_dwordx4 v[104:107], v[6:7], off offset:16
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v8
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v8
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:32
global_load_dwordx4 v[104:107], v[6:7], off offset:48
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v9
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v9
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:64
global_load_dwordx4 v[104:107], v[6:7], off offset:80
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v10
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v10
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:96
global_load_dwordx4 v[104:107], v[6:7], off offset:112
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v11
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v11
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:128
global_load_dwordx4 v[104:107], v[6:7], off offset:144
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v12
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v12
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:160
global_load_dwordx4 v[104:107], v[6:7], off offset:176
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v13
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v13
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:192
global_load_dwordx4 v[104:107], v[6:7], off offset:208
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v14
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v14
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:224
global_load_dwordx4 v[104:107], v[6:7], off offset:240
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v15
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v15
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:256
global_load_dwordx4 v[104:107], v[6:7], off offset:272
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v16
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v16
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:288
global_load_dwordx4 v[104:107], v[6:7], off offset:304
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v17
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v17
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:320
global_load_dwordx4 v[104:107], v[6:7], off offset:336
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v18
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v18
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:352
global_load_dwordx4 v[104:107], v[6:7], off offset:368
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v19
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v19
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:384
global_load_dwordx4 v[104:107], v[6:7], off offset:400
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v20
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v20
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:416
global_load_dwordx4 v[104:107], v[6:7], off offset:432
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v21
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v21
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:448
global_load_dwordx4 v[104:107], v[6:7], off offset:464
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v22
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v22
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
global_load_dwordx4 v[100:103], v[6:7], off offset:480
global_load_dwordx4 v[104:107], v[6:7], off offset:496
s_waitcnt vmcnt(0)
v_and_b32_e32 v27, 0x0f, v23
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v100, v70
v_lshrrev_b32_e32 v27, 4, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v101, v71
v_lshrrev_b32_e32 v27, 8, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v102, v72
v_lshrrev_b32_e32 v27, 12, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v103, v73
v_lshrrev_b32_e32 v27, 16, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v70, v27, v104, v70
v_lshrrev_b32_e32 v27, 20, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v71, v27, v105, v71
v_lshrrev_b32_e32 v27, 24, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v72, v27, v106, v72
v_lshrrev_b32_e32 v27, 28, v23
v_and_b32_e32 v27, 0x0f, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, v26, v27
v_fma_f32 v73, v27, v107, v73
v_mul_f32_e32 v70, v70, v25
v_mul_f32_e32 v71, v71, v25
v_mul_f32_e32 v72, v72, v25
v_mul_f32_e32 v73, v73, v25
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
