.text
k_q2_0_dequant_k:
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
v_mul_lo_u32 v2, v1, 18
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_lshlrev_b32_e32 v6, 8, v1
v_mov_b32_e32 v7, s19
v_add_co_u32_e32 v6, vcc, s18, v6
v_addc_co_u32_e32 v7, vcc, v7, v3, vcc
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
v_and_b32_e32 v24, 3, v48
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v48
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v48
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v48
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:0
v_and_b32_e32 v24, 3, v49
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v49
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v49
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v49
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:16
v_and_b32_e32 v24, 3, v50
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v50
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v50
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v50
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:32
v_and_b32_e32 v24, 3, v51
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v51
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v51
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v51
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:48
v_and_b32_e32 v24, 3, v52
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v52
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v52
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v52
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:64
v_and_b32_e32 v24, 3, v53
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v53
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v53
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v53
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:80
v_and_b32_e32 v24, 3, v54
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v54
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v54
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v54
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:96
v_and_b32_e32 v24, 3, v55
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v55
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v55
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v55
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:112
v_and_b32_e32 v24, 3, v56
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v56
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v56
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v56
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:128
v_and_b32_e32 v24, 3, v57
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v57
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v57
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v57
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:144
v_and_b32_e32 v24, 3, v58
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v58
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v58
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v58
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:160
v_and_b32_e32 v24, 3, v59
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v59
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v59
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v59
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:176
v_and_b32_e32 v24, 3, v60
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v60
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v60
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v60
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:192
v_and_b32_e32 v24, 3, v61
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v61
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v61
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v61
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:208
v_and_b32_e32 v24, 3, v62
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v62
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v62
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v62
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:224
v_and_b32_e32 v24, 3, v63
v_cvt_f32_u32_e32 v24, v24
v_add_f32_e32 v24, -1.0, v24
v_mul_f32_e32 v24, v8, v24
v_lshrrev_b32_e32 v25, 2, v63
v_and_b32_e32 v25, 3, v25
v_cvt_f32_u32_e32 v25, v25
v_add_f32_e32 v25, -1.0, v25
v_mul_f32_e32 v25, v8, v25
v_lshrrev_b32_e32 v26, 4, v63
v_and_b32_e32 v26, 3, v26
v_cvt_f32_u32_e32 v26, v26
v_add_f32_e32 v26, -1.0, v26
v_mul_f32_e32 v26, v8, v26
v_lshrrev_b32_e32 v27, 6, v63
v_and_b32_e32 v27, 3, v27
v_cvt_f32_u32_e32 v27, v27
v_add_f32_e32 v27, -1.0, v27
v_mul_f32_e32 v27, v8, v27
global_store_dwordx4 v[6:7], v[24:27], off offset:240
L_end:
s_or_b64 exec, exec, s[0:1]
s_endpgm
