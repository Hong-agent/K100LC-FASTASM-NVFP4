.text
k_iq4nl_to_i8_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s23
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s22, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mul_lo_u32 v2, v1, 18
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v6, 5, v1
v_lshlrev_b32_e32 v7, 0, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, s18, v6
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
v_lshlrev_b32_e32 v44, 2, v1
v_mov_b32_e32 v45, s21
v_add_co_u32_e32 v44, vcc, s20, v44
v_addc_co_u32_e32 v45, vcc, v45, v3, vcc
v_mov_b32_e32 v9, 0xf6eaddcf
v_mov_b32_e32 v10, 0xbfad9881
v_mov_b32_e32 v11, 0x71594535
v_mov_b32_e32 v12, 0x26190d01
v_mov_b32_e32 v13, 0x0000ff00
global_load_ushort v8, v[4:5], off
global_load_ubyte v48, v[4:5], off offset:2
global_load_ubyte v49, v[4:5], off offset:3
global_load_ubyte v50, v[4:5], off offset:4
global_load_ubyte v51, v[4:5], off offset:5
global_load_ubyte v52, v[4:5], off offset:6
global_load_ubyte v53, v[4:5], off offset:7
global_load_ubyte v54, v[4:5], off offset:8
global_load_ubyte v55, v[4:5], off offset:9
global_load_ubyte v56, v[4:5], off offset:10
global_load_ubyte v57, v[4:5], off offset:11
global_load_ubyte v58, v[4:5], off offset:12
global_load_ubyte v59, v[4:5], off offset:13
global_load_ubyte v60, v[4:5], off offset:14
global_load_ubyte v61, v[4:5], off offset:15
global_load_ubyte v62, v[4:5], off offset:16
global_load_ubyte v63, v[4:5], off offset:17
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v8, v8
global_store_dword v[44:45], v8, off
v_lshlrev_b32_e32 v22, 8, v49
v_or_b32_e32 v22, v48, v22
v_lshlrev_b32_e32 v23, 8, v51
v_or_b32_e32 v23, v50, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:0
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:16
v_lshlrev_b32_e32 v22, 8, v53
v_or_b32_e32 v22, v52, v22
v_lshlrev_b32_e32 v23, 8, v55
v_or_b32_e32 v23, v54, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:4
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:20
v_lshlrev_b32_e32 v22, 8, v57
v_or_b32_e32 v22, v56, v22
v_lshlrev_b32_e32 v23, 8, v59
v_or_b32_e32 v23, v58, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:8
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:24
v_lshlrev_b32_e32 v22, 8, v61
v_or_b32_e32 v22, v60, v22
v_lshlrev_b32_e32 v23, 8, v63
v_or_b32_e32 v23, v62, v23
v_lshlrev_b32_e32 v23, 16, v23
v_or_b32_e32 v18, v22, v23
v_and_b32_e32 v24, 0x0f0f0f0f, v18
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:12
v_and_b32_e32 v24, 0xf0f0f0f0, v18
v_lshrrev_b32_e32 v24, 4, v24
v_and_b32_e32 v24, 0x0f0f0f0f, v24
v_and_b32_e32 v31, 0x07070707, v24
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v27, 0x08080808, v24
v_lshrrev_b32_e32 v27, 3, v27
v_perm_b32 v28, v3, v13, v27
v_bfi_b32 v30, v28, v26, v25
global_store_dword v[6:7], v30, off offset:28
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
