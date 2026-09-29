.text
k__Z17nvfp4_gemm_kernelPKjPKhPKaS4_PKfPfiiif:
s_load_dwordx4 s[16:19], s[4:5], 0x30
v_and_b32_e32 v1, 15, v0
v_lshrrev_b32_e32 v2, 4, v0
s_mov_b32 s8, 0
v_lshlrev_b32_e32 v21, 2, v2
s_waitcnt lgkmcnt(0)
s_cmp_gt_i32 s18, 0
v_lshlrev_b32_e32 v22, 2, v1
s_cbranch_scc1 2
s_mov_b64 s[0:1], 0
s_branch 1
s_mov_b64 s[0:1], -1
s_load_dwordx2 s[2:3], s[4:5], 0x28
s_lshl_b32 s30, s7, 6
s_lshl_b32 s31, s6, 6
s_andn2_b64 vcc, exec, s[0:1]
v_mov_b32_e32 v24, s8
v_mov_b32_e32 v23, s8
v_mov_b32_e32 v20, s8
v_mov_b32_e32 v19, s8
v_mov_b32_e32 v18, s8
v_mov_b32_e32 v17, s8
v_mov_b32_e32 v16, s8
v_mov_b32_e32 v15, s8
v_mov_b32_e32 v14, s8
v_mov_b32_e32 v13, s8
v_mov_b32_e32 v12, s8
v_mov_b32_e32 v11, s8
v_mov_b32_e32 v10, s8
v_mov_b32_e32 v9, s8
v_mov_b32_e32 v8, s8
v_mov_b32_e32 v7, s8
s_cbranch_vccnz 1183
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx2 s[6:7], s[4:5], 0x20
v_lshlrev_b32_e32 v3, 4, v1
s_lshr_b32 s33, s18, 4
s_lshr_b32 s34, s18, 3
s_lshr_b32 s35, s18, 1
v_or_b32_e32 v28, 0x1000, v3
v_or_b32_e32 v29, 0x1800, v3
v_mov_b32_e32 v3, 0x2000
s_movk_i32 s0, 0x100
s_add_u32 s4, s4, 64
v_lshlrev_b32_e32 v21, 2, v2
v_lshlrev_b32_e32 v26, 4, v2
v_lshl_or_b32 v30, v2, 6, v3
v_mov_b32_e32 v2, 0x2400
v_cmp_gt_u32_e32 vcc, s0, v0
s_mov_b32 s36, 0
s_addc_u32 s5, s5, 0
v_mul_f32_e64 v25, s19, 0.5
v_lshlrev_b32_e32 v22, 2, v1
v_or_b32_e32 v27, 0x800, v26
v_lshl_or_b32 v31, v1, 6, v2
v_mov_b32_e32 v2, 0
s_movk_i32 s19, 0xff
s_mov_b32 s37, 0x3e000000
s_brev_b32 s38, 1
v_mov_b32_e32 v32, 0xc080604
v_mov_b32_e32 v33, 0x3020100
v_mov_b32_e32 v34, 0xf4f8fafc
v_mov_b32_e32 v35, 0xfdfeff00
v_mov_b32_e32 v36, 0xff00
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v9, 0
v_mov_b32_e32 v10, 0
v_mov_b32_e32 v11, 0
v_mov_b32_e32 v12, 0
v_mov_b32_e32 v13, 0
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v24, 0
s_branch 834
s_or_b64 exec, exec, s[20:21]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_read_b128 v[3:6], v26
ds_read_b128 v[37:40], v27
ds_read_b128 v[41:44], v28
ds_read_b128 v[45:48], v29
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v2
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v2
v_dot4_i32_i8 v49, v37, v46, v49
v_dot4_i32_i8 v50, v3, v43, v2
v_dot4_i32_i8 v50, v37, v47, v50
v_dot4_i32_i8 v3, v3, v44, v2
v_dot4_i32_i8 v51, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v2
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v2
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v2
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v2
v_dot4_i32_i8 v55, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v2
v_dot4_i32_i8 v56, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v2
v_dot4_i32_i8 v57, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v2
v_dot4_i32_i8 v58, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v2
v_dot4_i32_i8 v59, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v2
v_dot4_i32_i8 v60, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v2
v_dot4_i32_i8 v61, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v2
v_dot4_i32_i8 v62, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v2
v_dot4_i32_i8 v63, v40, v48, v3
ds_read_b128 v[3:6], v26 offset:256
ds_read_b128 v[37:40], v27 offset:256
ds_read_b128 v[41:44], v28 offset:256
ds_read_b128 v[45:48], v29 offset:256
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v1
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v49
v_dot4_i32_i8 v64, v37, v46, v49
v_dot4_i32_i8 v49, v3, v43, v50
v_dot4_i32_i8 v65, v37, v47, v49
v_dot4_i32_i8 v3, v3, v44, v51
v_dot4_i32_i8 v37, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v52
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v53
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v54
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v55
v_dot4_i32_i8 v38, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v56
v_dot4_i32_i8 v55, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v57
v_dot4_i32_i8 v56, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v58
v_dot4_i32_i8 v57, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v59
v_dot4_i32_i8 v39, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v60
v_dot4_i32_i8 v41, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v61
v_dot4_i32_i8 v42, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v62
v_dot4_i32_i8 v43, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v63
v_dot4_i32_i8 v40, v40, v48, v3
ds_read2_b32 v[3:4], v30 offset1:4
ds_read2_b32 v[5:6], v31 offset1:4
ds_read2_b32 v[48:49], v30 offset0:8 offset1:12
v_cvt_f32_i32_e32 v1, v1
ds_read2_b32 v[50:51], v31 offset0:8 offset1:12
v_cvt_f32_i32_e32 v45, v64
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v44, v3, v5
v_fmac_f32_e32 v24, v1, v44
v_cvt_f32_i32_e32 v44, v65
v_mul_f32_e32 v1, v3, v6
v_fmac_f32_e32 v23, v45, v1
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v1, v3, v50
v_cvt_f32_i32_e32 v37, v37
v_fmac_f32_e32 v20, v44, v1
v_mul_f32_e32 v1, v3, v51
v_cvt_f32_i32_e32 v3, v52
v_fmac_f32_e32 v19, v37, v1
v_mul_f32_e32 v1, v4, v5
v_cvt_f32_i32_e32 v37, v53
v_fmac_f32_e32 v18, v3, v1
v_cvt_f32_i32_e32 v3, v54
v_mul_f32_e32 v1, v4, v6
v_fmac_f32_e32 v17, v37, v1
v_mul_f32_e32 v1, v4, v50
v_cvt_f32_i32_e32 v37, v38
v_fmac_f32_e32 v16, v3, v1
v_cvt_f32_i32_e32 v3, v55
v_mul_f32_e32 v1, v4, v51
v_cvt_f32_i32_e32 v4, v56
v_fmac_f32_e32 v15, v37, v1
v_mul_f32_e32 v1, v48, v5
v_fmac_f32_e32 v14, v3, v1
v_mul_f32_e32 v1, v48, v6
v_cvt_f32_i32_e32 v3, v57
v_fmac_f32_e32 v13, v4, v1
v_cvt_f32_i32_e32 v4, v39
v_mul_f32_e32 v1, v48, v50
v_fmac_f32_e32 v12, v3, v1
v_mul_f32_e32 v1, v48, v51
v_cvt_f32_i32_e32 v3, v41
v_fmac_f32_e32 v11, v4, v1
v_cvt_f32_i32_e32 v1, v42
v_mul_f32_e32 v4, v49, v5
v_fmac_f32_e32 v10, v3, v4
v_mul_f32_e32 v3, v49, v6
v_fmac_f32_e32 v9, v1, v3
v_cvt_f32_i32_e32 v1, v43
v_cvt_f32_i32_e32 v52, v40
ds_read_b128 v[3:6], v26 offset:512
ds_read_b128 v[37:40], v27 offset:512
ds_read_b128 v[41:44], v28 offset:512
ds_read_b128 v[45:48], v29 offset:512
v_mul_f32_e32 v50, v49, v50
v_fmac_f32_e32 v8, v1, v50
v_mul_f32_e32 v1, v49, v51
v_fmac_f32_e32 v7, v52, v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v2
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v2
v_dot4_i32_i8 v49, v37, v46, v49
v_dot4_i32_i8 v50, v3, v43, v2
v_dot4_i32_i8 v50, v37, v47, v50
v_dot4_i32_i8 v3, v3, v44, v2
v_dot4_i32_i8 v51, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v2
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v2
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v2
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v2
v_dot4_i32_i8 v55, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v2
v_dot4_i32_i8 v56, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v2
v_dot4_i32_i8 v57, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v2
v_dot4_i32_i8 v58, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v2
v_dot4_i32_i8 v59, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v2
v_dot4_i32_i8 v60, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v2
v_dot4_i32_i8 v61, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v2
v_dot4_i32_i8 v62, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v2
v_dot4_i32_i8 v63, v40, v48, v3
ds_read_b128 v[3:6], v26 offset:768
ds_read_b128 v[37:40], v27 offset:768
ds_read_b128 v[41:44], v28 offset:768
ds_read_b128 v[45:48], v29 offset:768
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v1
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v49
v_dot4_i32_i8 v64, v37, v46, v49
v_dot4_i32_i8 v49, v3, v43, v50
v_dot4_i32_i8 v65, v37, v47, v49
v_dot4_i32_i8 v3, v3, v44, v51
v_dot4_i32_i8 v37, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v52
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v53
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v54
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v55
v_dot4_i32_i8 v38, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v56
v_dot4_i32_i8 v55, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v57
v_dot4_i32_i8 v56, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v58
v_dot4_i32_i8 v57, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v59
v_dot4_i32_i8 v39, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v60
v_dot4_i32_i8 v41, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v61
v_dot4_i32_i8 v42, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v62
v_dot4_i32_i8 v43, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v63
v_dot4_i32_i8 v40, v40, v48, v3
ds_read2_b32 v[3:4], v30 offset0:1 offset1:5
ds_read2_b32 v[5:6], v31 offset0:1 offset1:5
ds_read2_b32 v[48:49], v30 offset0:9 offset1:13
v_cvt_f32_i32_e32 v1, v1
ds_read2_b32 v[50:51], v31 offset0:9 offset1:13
v_cvt_f32_i32_e32 v45, v64
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v44, v3, v5
v_fmac_f32_e32 v24, v1, v44
v_cvt_f32_i32_e32 v44, v65
v_mul_f32_e32 v1, v3, v6
v_fmac_f32_e32 v23, v45, v1
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v1, v3, v50
v_cvt_f32_i32_e32 v37, v37
v_fmac_f32_e32 v20, v44, v1
v_mul_f32_e32 v1, v3, v51
v_cvt_f32_i32_e32 v3, v52
v_fmac_f32_e32 v19, v37, v1
v_mul_f32_e32 v1, v4, v5
v_cvt_f32_i32_e32 v37, v53
v_fmac_f32_e32 v18, v3, v1
v_cvt_f32_i32_e32 v3, v54
v_mul_f32_e32 v1, v4, v6
v_fmac_f32_e32 v17, v37, v1
v_mul_f32_e32 v1, v4, v50
v_cvt_f32_i32_e32 v37, v38
v_fmac_f32_e32 v16, v3, v1
v_cvt_f32_i32_e32 v3, v55
v_mul_f32_e32 v1, v4, v51
v_cvt_f32_i32_e32 v4, v56
v_fmac_f32_e32 v15, v37, v1
v_mul_f32_e32 v1, v48, v5
v_fmac_f32_e32 v14, v3, v1
v_mul_f32_e32 v1, v48, v6
v_cvt_f32_i32_e32 v3, v57
v_fmac_f32_e32 v13, v4, v1
v_cvt_f32_i32_e32 v4, v39
v_mul_f32_e32 v1, v48, v50
v_fmac_f32_e32 v12, v3, v1
v_mul_f32_e32 v1, v48, v51
v_cvt_f32_i32_e32 v3, v41
v_fmac_f32_e32 v11, v4, v1
v_cvt_f32_i32_e32 v1, v42
v_mul_f32_e32 v4, v49, v5
v_fmac_f32_e32 v10, v3, v4
v_mul_f32_e32 v3, v49, v6
v_fmac_f32_e32 v9, v1, v3
v_cvt_f32_i32_e32 v1, v43
v_cvt_f32_i32_e32 v52, v40
ds_read_b128 v[3:6], v26 offset:1024
ds_read_b128 v[37:40], v27 offset:1024
ds_read_b128 v[41:44], v28 offset:1024
ds_read_b128 v[45:48], v29 offset:1024
v_mul_f32_e32 v50, v49, v50
v_fmac_f32_e32 v8, v1, v50
v_mul_f32_e32 v1, v49, v51
v_fmac_f32_e32 v7, v52, v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v2
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v2
v_dot4_i32_i8 v49, v37, v46, v49
v_dot4_i32_i8 v50, v3, v43, v2
v_dot4_i32_i8 v50, v37, v47, v50
v_dot4_i32_i8 v3, v3, v44, v2
v_dot4_i32_i8 v51, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v2
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v2
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v2
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v2
v_dot4_i32_i8 v55, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v2
v_dot4_i32_i8 v56, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v2
v_dot4_i32_i8 v57, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v2
v_dot4_i32_i8 v58, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v2
v_dot4_i32_i8 v59, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v2
v_dot4_i32_i8 v60, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v2
v_dot4_i32_i8 v61, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v2
v_dot4_i32_i8 v62, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v2
v_dot4_i32_i8 v63, v40, v48, v3
ds_read_b128 v[3:6], v26 offset:1280
ds_read_b128 v[37:40], v27 offset:1280
ds_read_b128 v[41:44], v28 offset:1280
ds_read_b128 v[45:48], v29 offset:1280
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v1
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v49
v_dot4_i32_i8 v64, v37, v46, v49
v_dot4_i32_i8 v49, v3, v43, v50
v_dot4_i32_i8 v65, v37, v47, v49
v_dot4_i32_i8 v3, v3, v44, v51
v_dot4_i32_i8 v37, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v52
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v53
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v54
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v55
v_dot4_i32_i8 v38, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v56
v_dot4_i32_i8 v55, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v57
v_dot4_i32_i8 v56, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v58
v_dot4_i32_i8 v57, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v59
v_dot4_i32_i8 v39, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v60
v_dot4_i32_i8 v41, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v61
v_dot4_i32_i8 v42, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v62
v_dot4_i32_i8 v43, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v63
v_dot4_i32_i8 v40, v40, v48, v3
ds_read2_b32 v[3:4], v30 offset0:2 offset1:6
ds_read2_b32 v[5:6], v31 offset0:2 offset1:6
ds_read2_b32 v[48:49], v30 offset0:10 offset1:14
v_cvt_f32_i32_e32 v1, v1
ds_read2_b32 v[50:51], v31 offset0:10 offset1:14
v_cvt_f32_i32_e32 v45, v64
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v44, v3, v5
v_fmac_f32_e32 v24, v1, v44
v_cvt_f32_i32_e32 v44, v65
v_mul_f32_e32 v1, v3, v6
v_fmac_f32_e32 v23, v45, v1
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v1, v3, v50
v_cvt_f32_i32_e32 v37, v37
v_fmac_f32_e32 v20, v44, v1
v_mul_f32_e32 v1, v3, v51
v_cvt_f32_i32_e32 v3, v52
v_fmac_f32_e32 v19, v37, v1
v_mul_f32_e32 v1, v4, v5
v_cvt_f32_i32_e32 v37, v53
v_fmac_f32_e32 v18, v3, v1
v_cvt_f32_i32_e32 v3, v54
v_mul_f32_e32 v1, v4, v6
v_fmac_f32_e32 v17, v37, v1
v_mul_f32_e32 v1, v4, v50
v_cvt_f32_i32_e32 v37, v38
v_fmac_f32_e32 v16, v3, v1
v_cvt_f32_i32_e32 v3, v55
v_mul_f32_e32 v1, v4, v51
v_cvt_f32_i32_e32 v4, v56
v_fmac_f32_e32 v15, v37, v1
v_mul_f32_e32 v1, v48, v5
v_fmac_f32_e32 v14, v3, v1
v_mul_f32_e32 v1, v48, v6
v_cvt_f32_i32_e32 v3, v57
v_fmac_f32_e32 v13, v4, v1
v_cvt_f32_i32_e32 v4, v39
v_mul_f32_e32 v1, v48, v50
v_fmac_f32_e32 v12, v3, v1
v_mul_f32_e32 v1, v48, v51
v_cvt_f32_i32_e32 v3, v41
v_fmac_f32_e32 v11, v4, v1
v_cvt_f32_i32_e32 v1, v42
v_mul_f32_e32 v4, v49, v5
v_fmac_f32_e32 v10, v3, v4
v_mul_f32_e32 v3, v49, v6
v_fmac_f32_e32 v9, v1, v3
v_cvt_f32_i32_e32 v1, v43
v_cvt_f32_i32_e32 v52, v40
ds_read_b128 v[3:6], v26 offset:1536
ds_read_b128 v[37:40], v27 offset:1536
ds_read_b128 v[41:44], v28 offset:1536
ds_read_b128 v[45:48], v29 offset:1536
v_mul_f32_e32 v50, v49, v50
v_fmac_f32_e32 v8, v1, v50
v_mul_f32_e32 v1, v49, v51
v_fmac_f32_e32 v7, v52, v1
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v2
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v2
v_dot4_i32_i8 v49, v37, v46, v49
v_dot4_i32_i8 v50, v3, v43, v2
v_dot4_i32_i8 v50, v37, v47, v50
v_dot4_i32_i8 v3, v3, v44, v2
v_dot4_i32_i8 v51, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v2
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v2
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v2
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v2
v_dot4_i32_i8 v55, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v2
v_dot4_i32_i8 v56, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v2
v_dot4_i32_i8 v57, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v2
v_dot4_i32_i8 v58, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v2
v_dot4_i32_i8 v59, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v2
v_dot4_i32_i8 v60, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v2
v_dot4_i32_i8 v61, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v2
v_dot4_i32_i8 v62, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v2
v_dot4_i32_i8 v63, v40, v48, v3
ds_read_b128 v[3:6], v26 offset:1792
ds_read_b128 v[37:40], v27 offset:1792
ds_read_b128 v[41:44], v28 offset:1792
ds_read_b128 v[45:48], v29 offset:1792
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v1, v3, v41, v1
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v1, v37, v45, v1
v_dot4_i32_i8 v49, v3, v42, v49
v_dot4_i32_i8 v49, v37, v46, v49
v_dot4_i32_i8 v50, v3, v43, v50
v_dot4_i32_i8 v50, v37, v47, v50
v_dot4_i32_i8 v3, v3, v44, v51
v_dot4_i32_i8 v51, v37, v48, v3
v_dot4_i32_i8 v3, v4, v41, v52
v_dot4_i32_i8 v52, v38, v45, v3
v_dot4_i32_i8 v3, v4, v42, v53
v_dot4_i32_i8 v53, v38, v46, v3
v_dot4_i32_i8 v3, v4, v43, v54
v_dot4_i32_i8 v54, v38, v47, v3
v_dot4_i32_i8 v3, v4, v44, v55
v_dot4_i32_i8 v55, v38, v48, v3
v_dot4_i32_i8 v3, v5, v41, v56
v_dot4_i32_i8 v56, v39, v45, v3
v_dot4_i32_i8 v3, v5, v42, v57
v_dot4_i32_i8 v57, v39, v46, v3
v_dot4_i32_i8 v3, v5, v43, v58
v_dot4_i32_i8 v58, v39, v47, v3
v_dot4_i32_i8 v3, v5, v44, v59
v_dot4_i32_i8 v59, v39, v48, v3
v_dot4_i32_i8 v3, v6, v41, v60
v_dot4_i32_i8 v41, v40, v45, v3
v_dot4_i32_i8 v3, v6, v42, v61
v_dot4_i32_i8 v42, v40, v46, v3
v_dot4_i32_i8 v3, v6, v43, v62
v_dot4_i32_i8 v43, v40, v47, v3
v_dot4_i32_i8 v3, v6, v44, v63
v_dot4_i32_i8 v44, v40, v48, v3
ds_read2_b32 v[3:4], v30 offset0:3 offset1:7
ds_read2_b32 v[5:6], v31 offset0:3 offset1:7
ds_read2_b32 v[37:38], v30 offset0:11 offset1:15
v_cvt_f32_i32_e32 v1, v1
ds_read2_b32 v[39:40], v31 offset0:11 offset1:15
v_cvt_f32_i32_e32 v46, v49
s_waitcnt lgkmcnt(2)
v_mul_f32_e32 v45, v3, v5
v_fmac_f32_e32 v24, v1, v45
v_cvt_f32_i32_e32 v45, v50
v_mul_f32_e32 v1, v3, v6
v_fmac_f32_e32 v23, v46, v1
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v1, v3, v39
v_cvt_f32_i32_e32 v46, v51
v_fmac_f32_e32 v20, v45, v1
v_mul_f32_e32 v1, v3, v40
v_cvt_f32_i32_e32 v3, v52
v_fmac_f32_e32 v19, v46, v1
v_mul_f32_e32 v1, v4, v5
v_cvt_f32_i32_e32 v45, v53
v_fmac_f32_e32 v18, v3, v1
v_cvt_f32_i32_e32 v3, v54
v_mul_f32_e32 v1, v4, v6
v_fmac_f32_e32 v17, v45, v1
v_mul_f32_e32 v1, v4, v39
v_cvt_f32_i32_e32 v45, v55
v_fmac_f32_e32 v16, v3, v1
v_cvt_f32_i32_e32 v3, v56
v_mul_f32_e32 v1, v4, v40
v_cvt_f32_i32_e32 v4, v57
v_fmac_f32_e32 v15, v45, v1
v_mul_f32_e32 v1, v37, v5
v_fmac_f32_e32 v14, v3, v1
v_mul_f32_e32 v1, v37, v6
v_cvt_f32_i32_e32 v3, v58
v_fmac_f32_e32 v13, v4, v1
v_cvt_f32_i32_e32 v4, v59
v_mul_f32_e32 v1, v37, v39
v_fmac_f32_e32 v12, v3, v1
v_mul_f32_e32 v1, v37, v40
v_cvt_f32_i32_e32 v3, v41
v_fmac_f32_e32 v11, v4, v1
v_cvt_f32_i32_e32 v4, v42
v_mul_f32_e32 v1, v38, v5
v_fmac_f32_e32 v10, v3, v1
v_mul_f32_e32 v1, v38, v6
v_cvt_f32_i32_e32 v3, v43
v_fmac_f32_e32 v9, v4, v1
v_cvt_f32_i32_e32 v1, v44
v_mul_f32_e32 v4, v38, v39
v_fmac_f32_e32 v8, v3, v4
v_mul_f32_e32 v3, v38, v40
s_add_i32 s36, s36, 64
v_fmac_f32_e32 v7, v1, v3
s_cmp_ge_i32 s36, s18
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 285
s_and_saveexec_b64 s[20:21], vcc
s_cbranch_execz 64700
s_load_dword s0, s[4:5], 0xc
s_lshr_b32 s1, s36, 1
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v1, v0
s_waitcnt lgkmcnt(0)
s_and_b32 s39, s0, 0xffff
s_add_u32 s24, s12, s1
s_addc_u32 s25, s13, 0
s_add_u32 s26, s14, s1
s_addc_u32 s27, s15, 0
s_branch 16
s_or_b64 exec, exec, s[28:29]
v_add_u32_e32 v1, s39, v1
v_lshlrev_b32_e32 v37, 2, v37
v_cmp_lt_u32_e64 s[0:1], s19, v1
v_lshl_add_u32 v37, v38, 9, v37
s_or_b64 s[22:23], s[0:1], s[22:23]
s_waitcnt vmcnt(1)
ds_write2st64_b32 v37, v5, v6 offset1:1
s_waitcnt vmcnt(0)
ds_write2st64_b32 v37, v3, v4 offset0:8 offset1:9
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execz 33
v_lshrrev_b32_e32 v37, 2, v1
v_add_u32_e32 v39, s30, v37
v_and_b32_e32 v38, 3, v1
v_cmp_gt_i32_e64 s[0:1], s16, v39
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v5, 0
v_mov_b32_e32 v6, 0
s_and_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 65509
v_mov_b32_e32 v3, s24
v_mov_b32_e32 v4, s25
v_mad_i64_i32 v[3:4], s[0:1], v39, s35, v[3:4]
v_mov_b32_e32 v5, s26
v_mov_b32_e32 v6, s27
v_mad_i64_i32 v[39:40], s[0:1], v39, s35, v[5:6]
v_lshlrev_b32_e32 v41, 3, v38
v_add_co_u32_e64 v3, s[0:1], v3, v41
v_addc_co_u32_e64 v4, s[0:1], 0, v4, s[0:1]
global_load_dwordx2 v[5:6], v[3:4], off
v_add_co_u32_e64 v3, s[0:1], v39, v41
v_addc_co_u32_e64 v4, s[0:1], 0, v40, s[0:1]
global_load_dwordx2 v[3:4], v[3:4], off
s_branch 65487
s_or_b64 exec, exec, s[22:23]
s_lshr_b32 s40, s36, 4
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v1, v0
s_branch 69
s_or_b64 exec, exec, s[24:25]
s_waitcnt vmcnt(0)
v_and_b32_e32 v37, 0x7070707, v3
v_lshrrev_b32_e32 v38, 3, v3
v_lshrrev_b32_e32 v39, 4, v3
v_lshrrev_b32_e32 v3, 7, v3
v_and_b32_e32 v38, 0x1010101, v38
v_and_b32_e32 v39, 0x7070707, v39
v_and_b32_e32 v3, 0x1010101, v3
v_perm_b32 v40, v32, v33, v37
v_perm_b32 v37, v34, v35, v37
v_perm_b32 v38, v2, v36, v38
v_bfi_b32 v37, v38, v37, v40
v_perm_b32 v38, v32, v33, v39
v_perm_b32 v39, v34, v35, v39
v_perm_b32 v3, v2, v36, v3
v_bfi_b32 v3, v3, v39, v38
v_and_b32_e32 v38, 0x7070707, v4
v_lshrrev_b32_e32 v39, 3, v4
v_lshrrev_b32_e32 v40, 4, v4
v_lshrrev_b32_e32 v4, 7, v4
v_and_b32_e32 v39, 0x1010101, v39
v_and_b32_e32 v40, 0x7070707, v40
v_and_b32_e32 v4, 0x1010101, v4
v_perm_b32 v41, v32, v33, v38
v_perm_b32 v38, v34, v35, v38
v_perm_b32 v39, v2, v36, v39
v_bfi_b32 v38, v39, v38, v41
v_perm_b32 v39, v32, v33, v40
v_perm_b32 v40, v34, v35, v40
v_perm_b32 v4, v2, v36, v4
v_add_u32_e32 v1, s39, v1
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_lt_u32_e64 s[0:1], s19, v1
v_bfi_b32 v4, v4, v40, v39
v_lshl_add_u32 v5, v6, 9, v5
s_or_b64 s[22:23], s[0:1], s[22:23]
ds_write2st64_b32 v5, v37, v38 offset0:16 offset1:17
ds_write2st64_b32 v5, v3, v4 offset0:24 offset1:25
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execz 27
v_lshrrev_b32_e32 v5, 2, v1
v_add_u32_e32 v37, s31, v5
v_and_b32_e32 v6, 3, v1
v_cmp_gt_i32_e64 s[0:1], s17, v37
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v3, 0
s_and_saveexec_b64 s[24:25], s[0:1]
s_cbranch_execz 65458
v_mad_i64_i32 v[3:4], s[0:1], v37, s34, 0
v_mov_b32_e32 v37, s9
v_lshlrev_b64 v[3:4], 2, v[3:4]
v_add_co_u32_e64 v3, s[0:1], s8, v3
v_addc_co_u32_e64 v4, s[0:1], v37, v4, s[0:1]
v_or_b32_e32 v37, s40, v6
v_lshlrev_b32_e32 v37, 3, v37
v_add_co_u32_e64 v3, s[0:1], v3, v37
v_addc_co_u32_e64 v4, s[0:1], 0, v4, s[0:1]
global_load_dwordx2 v[3:4], v[3:4], off
s_branch 65440
s_or_b64 exec, exec, s[22:23]
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v3, v0
s_branch 13
s_or_b64 exec, exec, s[24:25]
v_add_u32_e32 v3, s39, v3
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_lt_u32_e64 s[0:1], s19, v3
v_lshl_or_b32 v4, v4, 4, v5
s_or_b64 s[22:23], s[0:1], s[22:23]
s_waitcnt vmcnt(0)
ds_write_b32 v4, v1 offset:8192
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execz 21
v_lshrrev_b32_e32 v4, 2, v3
v_add_u32_e32 v6, s30, v4
v_and_b32_e32 v5, 3, v3
v_cmp_gt_i32_e64 s[0:1], s16, v6
v_mov_b32_e32 v1, 0
s_and_saveexec_b64 s[24:25], s[0:1]
s_cbranch_execz 65515
v_or_b32_e32 v1, s40, v5
v_mad_i64_i32 v[37:38], s[0:1], v6, s33, v[1:2]
v_mov_b32_e32 v1, s7
v_lshlrev_b64 v[37:38], 2, v[37:38]
v_add_co_u32_e64 v37, s[0:1], s6, v37
v_addc_co_u32_e64 v38, s[0:1], v1, v38, s[0:1]
global_load_dword v1, v[37:38], off
s_branch 65502
s_or_b64 exec, exec, s[22:23]
s_mov_b64 s[22:23], 0
v_mov_b32_e32 v3, v0
s_branch 15
s_or_b64 exec, exec, s[28:29]
s_or_b64 exec, exec, s[26:27]
v_mul_f32_e32 v1, v25, v6
s_or_b64 exec, exec, s[24:25]
v_add_u32_e32 v3, s39, v3
v_lshlrev_b32_e32 v5, 2, v5
v_cmp_lt_u32_e64 s[0:1], s19, v3
v_lshl_or_b32 v4, v4, 4, v5
s_or_b64 s[22:23], s[0:1], s[22:23]
ds_write_b32 v4, v1 offset:9216
s_andn2_b64 exec, exec, s[22:23]
s_cbranch_execz 64480
v_lshrrev_b32_e32 v4, 2, v3
v_add_u32_e32 v6, s31, v4
v_and_b32_e32 v5, 3, v3
v_cmp_gt_i32_e64 s[0:1], s17, v6
v_mov_b32_e32 v1, 0
s_and_saveexec_b64 s[24:25], s[0:1]
s_cbranch_execz 65516
v_or_b32_e32 v1, s40, v5
v_mad_i64_i32 v[37:38], s[0:1], v6, s33, v[1:2]
v_mov_b32_e32 v1, s11
v_add_co_u32_e64 v37, s[0:1], s10, v37
v_addc_co_u32_e64 v38, s[0:1], v1, v38, s[0:1]
global_load_sbyte v37, v[37:38], off
s_waitcnt vmcnt(0)
v_bfe_u32 v38, v37, 3, 4
v_and_b32_e32 v1, 7, v37
v_cmp_lt_i32_e64 s[0:1], 14, v38
s_and_saveexec_b64 s[26:27], s[0:1]
s_xor_b64 s[26:27], exec, s[26:27]
v_cvt_f32_ubyte0_e32 v6, v1
v_fma_f32 v6, v6, s37, 1.0
v_mul_f32_e32 v6, 0x43800000, v6
v_cmp_gt_i16_e64 s[0:1], 0, v37
v_cndmask_b32_e64 v6, v6, -v6, s[0:1]
v_cmp_ne_u32_e64 s[0:1], 7, v1
v_cndmask_b32_e64 v6, 0, v6, s[0:1]
s_andn2_saveexec_b64 s[26:27], s[26:27]
s_cbranch_execz 65481
v_cmp_ne_u32_e64 s[0:1], 0, v38
s_and_saveexec_b64 s[28:29], s[0:1]
s_xor_b64 s[0:1], exec, s[28:29]
v_and_b32_sdwa v6, sext(v37), s38 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
v_lshlrev_b32_e32 v37, 23, v38
v_lshlrev_b32_e32 v1, 20, v1
v_or3_b32 v1, v37, v6, v1
v_add_u32_e32 v6, 0x3c000000, v1
s_andn2_saveexec_b64 s[28:29], s[0:1]
s_cbranch_execz 65466
v_cvt_f32_ubyte0_e32 v1, v1
v_mul_f32_e32 v1, 0x3b000000, v1
v_cmp_gt_i16_e64 s[0:1], 0, v37
v_cndmask_b32_e64 v6, v1, -v1, s[0:1]
s_branch 65458
v_add_u32_e32 v3, s30, v21
v_or_b32_e32 v2, s31, v22
v_cmp_gt_i32_e32 vcc, s16, v3
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 64
v_mad_i64_i32 v[0:1], s[4:5], v3, s17, 0
v_cmp_gt_i32_e32 vcc, s17, v2
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v24, off
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 1, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v23, off offset:4
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 2, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v20, off offset:8
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 3, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_b64 exec, exec, vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v4, v1, vcc
global_store_dword v[0:1], v19, off offset:12
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v0, 1, v3
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 64
v_mad_i64_i32 v[0:1], s[4:5], v0, s17, 0
v_cmp_gt_i32_e32 vcc, s17, v2
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v18, off
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 1, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v17, off offset:4
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 2, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v16, off offset:8
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 3, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_b64 exec, exec, vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v4, v1, vcc
global_store_dword v[0:1], v15, off offset:12
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v0, 2, v3
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 64
v_mad_i64_i32 v[0:1], s[4:5], v0, s17, 0
v_cmp_gt_i32_e32 vcc, s17, v2
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v14, off
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 1, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v13, off offset:4
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 2, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[4:5], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v5, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v12, off offset:8
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 3, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_b64 exec, exec, vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, v1, v4, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v4, v1, vcc
global_store_dword v[0:1], v11, off offset:12
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v0, 3, v3
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 63
v_mad_i64_i32 v[0:1], s[0:1], v0, s17, 0
v_cmp_gt_i32_e32 vcc, s17, v2
v_ashrrev_i32_e32 v3, 31, v2
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 10
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v3, vcc
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s3
v_add_co_u32_e32 v4, vcc, s2, v4
v_addc_co_u32_e32 v5, vcc, v6, v5, vcc
global_store_dword v[4:5], v10, off
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v4, 1, v2
v_cmp_gt_i32_e32 vcc, s17, v4
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 10
v_add_co_u32_e32 v4, vcc, v0, v2
v_addc_co_u32_e32 v5, vcc, v1, v3, vcc
v_lshlrev_b64 v[3:4], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s3
v_add_co_u32_e32 v3, vcc, s2, v3
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v9, off offset:4
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v3, 2, v2
v_cmp_gt_i32_e32 vcc, s17, v3
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v3, vcc, v0, v2
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s3
v_add_co_u32_e32 v3, vcc, s2, v3
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v8, off offset:8
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v3, 3, v2
v_cmp_gt_i32_e32 vcc, s17, v3
s_and_b64 exec, exec, vcc
s_cbranch_execz 11
v_ashrrev_i32_e32 v3, 31, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, v1, v3, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s3
v_add_co_u32_e32 v0, vcc, s2, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
global_store_dword v[0:1], v7, off offset:12
s_endpgm
