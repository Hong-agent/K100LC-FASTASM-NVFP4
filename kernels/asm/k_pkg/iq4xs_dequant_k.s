.text
k_iq4xs_dequant_k:
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_load_dword s21, s[4:5], 0x14
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v1, s6
v_mul_lo_u32 v1, v1, s21
v_add_u32_e32 v1, v0, v1
v_cmp_gt_u32_e32 vcc, s20, v1
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz L_end
v_mov_b32_e32 v9, 0xf6eaddcf
v_mov_b32_e32 v10, 0xbfad9881
v_mov_b32_e32 v11, 0x71594535
v_mov_b32_e32 v12, 0x26190d01
v_mov_b32_e32 v13, 0x0000ff00
v_mov_b32_e32 v47, 0xc2000000
v_mov_b32_e32 v80, 136
v_mul_lo_u32 v2, v1, v80
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v6, 10, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, s18, v6
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
global_load_ushort v8, v[4:5], off
global_load_ubyte v16, v[4:5], off offset:2
global_load_ubyte v17, v[4:5], off offset:3
global_load_dword v14, v[4:5], off offset:4
global_load_dwordx2 v[48:49], v[4:5], off offset:8
global_load_dwordx2 v[50:51], v[4:5], off offset:16
global_load_dwordx2 v[52:53], v[4:5], off offset:24
global_load_dwordx2 v[54:55], v[4:5], off offset:32
global_load_dwordx2 v[56:57], v[4:5], off offset:40
global_load_dwordx2 v[58:59], v[4:5], off offset:48
global_load_dwordx2 v[60:61], v[4:5], off offset:56
global_load_dwordx2 v[62:63], v[4:5], off offset:64
global_load_dwordx2 v[64:65], v[4:5], off offset:72
global_load_dwordx2 v[66:67], v[4:5], off offset:80
global_load_dwordx2 v[68:69], v[4:5], off offset:88
global_load_dwordx2 v[70:71], v[4:5], off offset:96
global_load_dwordx2 v[72:73], v[4:5], off offset:104
global_load_dwordx2 v[74:75], v[4:5], off offset:112
global_load_dwordx2 v[76:77], v[4:5], off offset:120
global_load_dwordx2 v[78:79], v[4:5], off offset:128
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v8, v8
v_lshlrev_b32_e32 v17, 8, v17
v_or_b32_e32 v15, v16, v17
v_lshrrev_b32_e32 v44, 0, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 0, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v48
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:0
v_and_b32_e32 v20, 0xf0f0f0f0, v48
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:64
v_and_b32_e32 v20, 0x0f0f0f0f, v49
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:16
v_and_b32_e32 v20, 0xf0f0f0f0, v49
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:80
v_and_b32_e32 v20, 0x0f0f0f0f, v50
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:32
v_and_b32_e32 v20, 0xf0f0f0f0, v50
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:96
v_and_b32_e32 v20, 0x0f0f0f0f, v51
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:48
v_and_b32_e32 v20, 0xf0f0f0f0, v51
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:112
v_lshrrev_b32_e32 v44, 4, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 2, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v52
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:128
v_and_b32_e32 v20, 0xf0f0f0f0, v52
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:192
v_and_b32_e32 v20, 0x0f0f0f0f, v53
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:144
v_and_b32_e32 v20, 0xf0f0f0f0, v53
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:208
v_and_b32_e32 v20, 0x0f0f0f0f, v54
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:160
v_and_b32_e32 v20, 0xf0f0f0f0, v54
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:224
v_and_b32_e32 v20, 0x0f0f0f0f, v55
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:176
v_and_b32_e32 v20, 0xf0f0f0f0, v55
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:240
v_lshrrev_b32_e32 v44, 8, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 4, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v56
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:256
v_and_b32_e32 v20, 0xf0f0f0f0, v56
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:320
v_and_b32_e32 v20, 0x0f0f0f0f, v57
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:272
v_and_b32_e32 v20, 0xf0f0f0f0, v57
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:336
v_and_b32_e32 v20, 0x0f0f0f0f, v58
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:288
v_and_b32_e32 v20, 0xf0f0f0f0, v58
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:352
v_and_b32_e32 v20, 0x0f0f0f0f, v59
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:304
v_and_b32_e32 v20, 0xf0f0f0f0, v59
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:368
v_lshrrev_b32_e32 v44, 12, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 6, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v60
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:384
v_and_b32_e32 v20, 0xf0f0f0f0, v60
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:448
v_and_b32_e32 v20, 0x0f0f0f0f, v61
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:400
v_and_b32_e32 v20, 0xf0f0f0f0, v61
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:464
v_and_b32_e32 v20, 0x0f0f0f0f, v62
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:416
v_and_b32_e32 v20, 0xf0f0f0f0, v62
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:480
v_and_b32_e32 v20, 0x0f0f0f0f, v63
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:432
v_and_b32_e32 v20, 0xf0f0f0f0, v63
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:496
v_lshrrev_b32_e32 v44, 16, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 8, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v64
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:512
v_and_b32_e32 v20, 0xf0f0f0f0, v64
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:576
v_and_b32_e32 v20, 0x0f0f0f0f, v65
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:528
v_and_b32_e32 v20, 0xf0f0f0f0, v65
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:592
v_and_b32_e32 v20, 0x0f0f0f0f, v66
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:544
v_and_b32_e32 v20, 0xf0f0f0f0, v66
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:608
v_and_b32_e32 v20, 0x0f0f0f0f, v67
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:560
v_and_b32_e32 v20, 0xf0f0f0f0, v67
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:624
v_lshrrev_b32_e32 v44, 20, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 10, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v68
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:640
v_and_b32_e32 v20, 0xf0f0f0f0, v68
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:704
v_and_b32_e32 v20, 0x0f0f0f0f, v69
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:656
v_and_b32_e32 v20, 0xf0f0f0f0, v69
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:720
v_and_b32_e32 v20, 0x0f0f0f0f, v70
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:672
v_and_b32_e32 v20, 0xf0f0f0f0, v70
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:736
v_and_b32_e32 v20, 0x0f0f0f0f, v71
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:688
v_and_b32_e32 v20, 0xf0f0f0f0, v71
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:752
v_lshrrev_b32_e32 v44, 24, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 12, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v72
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:768
v_and_b32_e32 v20, 0xf0f0f0f0, v72
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:832
v_and_b32_e32 v20, 0x0f0f0f0f, v73
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:784
v_and_b32_e32 v20, 0xf0f0f0f0, v73
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:848
v_and_b32_e32 v20, 0x0f0f0f0f, v74
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:800
v_and_b32_e32 v20, 0xf0f0f0f0, v74
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:864
v_and_b32_e32 v20, 0x0f0f0f0f, v75
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:816
v_and_b32_e32 v20, 0xf0f0f0f0, v75
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:880
v_lshrrev_b32_e32 v44, 28, v14
v_and_b32_e32 v44, 0xf, v44
v_lshrrev_b32_e32 v45, 14, v15
v_and_b32_e32 v45, 3, v45
v_lshlrev_b32_e32 v45, 4, v45
v_or_b32_e32 v44, v44, v45
v_cvt_f32_u32_e32 v46, v44
v_add_f32_e32 v46, v47, v46
v_mul_f32_e32 v46, v8, v46
v_and_b32_e32 v20, 0x0f0f0f0f, v76
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:896
v_and_b32_e32 v20, 0xf0f0f0f0, v76
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:960
v_and_b32_e32 v20, 0x0f0f0f0f, v77
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:912
v_and_b32_e32 v20, 0xf0f0f0f0, v77
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:976
v_and_b32_e32 v20, 0x0f0f0f0f, v78
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:928
v_and_b32_e32 v20, 0xf0f0f0f0, v78
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:992
v_and_b32_e32 v20, 0x0f0f0f0f, v79
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:944
v_and_b32_e32 v20, 0xf0f0f0f0, v79
v_lshrrev_b32_e32 v20, 4, v20
v_and_b32_e32 v20, 0x0f0f0f0f, v20
v_and_b32_e32 v31, 0x07070707, v20
v_perm_b32 v25, v9, v10, v31
v_perm_b32 v26, v11, v12, v31
v_and_b32_e32 v28, 0x08080808, v20
v_lshrrev_b32_e32 v28, 3, v28
v_perm_b32 v27, v3, v13, v28
v_bfi_b32 v30, v27, v26, v25
v_lshrrev_b32_e32 v40, 0, v30
v_lshlrev_b32_e32 v40, 24, v40
v_ashrrev_i32_e32 v40, 24, v40
v_cvt_f32_i32_e32 v40, v40
v_mul_f32_e32 v40, v46, v40
v_lshrrev_b32_e32 v41, 8, v30
v_lshlrev_b32_e32 v41, 24, v41
v_ashrrev_i32_e32 v41, 24, v41
v_cvt_f32_i32_e32 v41, v41
v_mul_f32_e32 v41, v46, v41
v_lshrrev_b32_e32 v42, 16, v30
v_lshlrev_b32_e32 v42, 24, v42
v_ashrrev_i32_e32 v42, 24, v42
v_cvt_f32_i32_e32 v42, v42
v_mul_f32_e32 v42, v46, v42
v_lshrrev_b32_e32 v43, 24, v30
v_lshlrev_b32_e32 v43, 24, v43
v_ashrrev_i32_e32 v43, 24, v43
v_cvt_f32_i32_e32 v43, v43
v_mul_f32_e32 v43, v46, v43
global_store_dwordx4 v[6:7], v[40:43], off offset:1008
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
