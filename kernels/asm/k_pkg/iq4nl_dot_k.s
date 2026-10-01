.text
k_iq4nl_dot_k:
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
v_lshlrev_b32_e32 v56, 7, v56
v_mov_b32_e32 v6, s18
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, v6, v56
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_mul_lo_u32 v2, v124, 18
v_add_u32_e32 v2, v2, v120
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v9, 0xf6eaddcf
v_mov_b32_e32 v10, 0xbfad9881
v_mov_b32_e32 v11, 0x71594535
v_mov_b32_e32 v12, 0x26190d01
v_mov_b32_e32 v13, 0x0000ff00
global_load_ushort v8, v[4:5], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v8, v8
global_load_ubyte v14, v[4:5], off offset:2
global_load_ubyte v15, v[4:5], off offset:3
global_load_ubyte v16, v[4:5], off offset:4
global_load_ubyte v17, v[4:5], off offset:5
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v22, 8, v15
v_or_b32_e32 v22, v14, v22
v_lshlrev_b32_e32 v23, 8, v17
v_or_b32_e32 v23, v16, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:0
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:64
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
global_load_ubyte v14, v[4:5], off offset:6
global_load_ubyte v15, v[4:5], off offset:7
global_load_ubyte v16, v[4:5], off offset:8
global_load_ubyte v17, v[4:5], off offset:9
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v22, 8, v15
v_or_b32_e32 v22, v14, v22
v_lshlrev_b32_e32 v23, 8, v17
v_or_b32_e32 v23, v16, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:16
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:80
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
global_load_ubyte v14, v[4:5], off offset:10
global_load_ubyte v15, v[4:5], off offset:11
global_load_ubyte v16, v[4:5], off offset:12
global_load_ubyte v17, v[4:5], off offset:13
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v22, 8, v15
v_or_b32_e32 v22, v14, v22
v_lshlrev_b32_e32 v23, 8, v17
v_or_b32_e32 v23, v16, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:32
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:96
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
global_load_ubyte v14, v[4:5], off offset:14
global_load_ubyte v15, v[4:5], off offset:15
global_load_ubyte v16, v[4:5], off offset:16
global_load_ubyte v17, v[4:5], off offset:17
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v22, 8, v15
v_or_b32_e32 v22, v14, v22
v_lshlrev_b32_e32 v23, 8, v17
v_or_b32_e32 v23, v16, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:48
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v28, 0x07070707, v24
v_perm_b32 v25, v9, v10, v28
v_perm_b32 v26, v11, v12, v28
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v29, v28, v26, v25
global_load_dwordx4 v[44:47], v[6:7], off offset:112
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v30, 0, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v70, v30, v44, v70
v_lshrrev_b32_e32 v30, 8, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v71, v30, v45, v71
v_lshrrev_b32_e32 v30, 16, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v72, v30, v46, v72
v_lshrrev_b32_e32 v30, 24, v29
v_lshlrev_b32_e32 v30, 24, v30
v_ashrrev_i32_e32 v30, 24, v30
v_cvt_f32_i32_e32 v30, v30
v_mul_f32_e32 v30, v8, v30
v_fma_f32 v73, v30, v47, v73
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
