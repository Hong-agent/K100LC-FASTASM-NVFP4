.text
k__Z6gdn_k2ILi32EEvPfPKfS2_S2_S2_S2_S0_S0_iiiii:
s_load_dwordx4 s[36:39], s[4:5], 0x40
v_and_b32_e32 v96, 31, v0
s_add_u32 s0, s0, s10
v_lshl_or_b32 v45, s9, 5, v96
s_addc_u32 s1, s1, 0
s_waitcnt lgkmcnt(0)
v_cmp_gt_i32_e32 vcc, s39, v45
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 668
s_mul_hi_i32 s11, s39, s8
s_mul_i32 s10, s39, s8
v_and_b32_e32 v1, 0xe0, v0
v_mov_b32_e32 v2, s11
v_add_co_u32_e32 v1, vcc, s10, v1
s_ashr_i32 s15, s39, 31
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_mul_lo_u32 v3, v2, s39
v_mul_lo_u32 v4, v1, s15
v_mad_u64_u32 v[1:2], s[6:7], v1, s39, 0
s_load_dwordx16 s[16:31], s[4:5], 0x0
v_ashrrev_i32_e32 v46, 31, v45
v_add3_u32 v2, v2, v4, v3
v_lshlrev_b64 v[93:94], 2, v[1:2]
v_lshlrev_b64 v[59:60], 2, v[45:46]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v1, s29
v_add_co_u32_e32 v2, vcc, s28, v93
v_addc_co_u32_e32 v1, vcc, v1, v94, vcc
s_mov_b32 s14, s39
v_add_co_u32_e32 v25, vcc, v2, v59
v_addc_co_u32_e32 v26, vcc, v1, v60, vcc
s_lshl_b64 s[6:7], s[14:15], 2
v_mov_b32_e32 v1, s7
v_add_co_u32_e32 v27, vcc, s6, v25
v_addc_co_u32_e32 v28, vcc, v26, v1, vcc
v_add_co_u32_e32 v29, vcc, s6, v27
v_addc_co_u32_e32 v30, vcc, v28, v1, vcc
v_add_co_u32_e32 v31, vcc, s6, v29
v_addc_co_u32_e32 v32, vcc, v30, v1, vcc
v_add_co_u32_e32 v33, vcc, s6, v31
v_addc_co_u32_e32 v34, vcc, v32, v1, vcc
v_add_co_u32_e32 v35, vcc, s6, v33
v_addc_co_u32_e32 v36, vcc, v34, v1, vcc
v_add_co_u32_e32 v37, vcc, s6, v35
v_addc_co_u32_e32 v38, vcc, v36, v1, vcc
v_add_co_u32_e32 v39, vcc, s6, v37
v_addc_co_u32_e32 v40, vcc, v38, v1, vcc
v_add_co_u32_e32 v41, vcc, s6, v39
v_addc_co_u32_e32 v42, vcc, v40, v1, vcc
v_add_co_u32_e32 v43, vcc, s6, v41
v_addc_co_u32_e32 v44, vcc, v42, v1, vcc
v_add_co_u32_e32 v47, vcc, s6, v43
v_addc_co_u32_e32 v48, vcc, v44, v1, vcc
v_add_co_u32_e32 v49, vcc, s6, v47
v_addc_co_u32_e32 v50, vcc, v48, v1, vcc
v_add_co_u32_e32 v51, vcc, s6, v49
v_addc_co_u32_e32 v52, vcc, v50, v1, vcc
v_add_co_u32_e32 v53, vcc, s6, v51
v_addc_co_u32_e32 v54, vcc, v52, v1, vcc
v_add_co_u32_e32 v55, vcc, s6, v53
v_addc_co_u32_e32 v56, vcc, v54, v1, vcc
v_add_co_u32_e32 v57, vcc, s6, v55
v_addc_co_u32_e32 v58, vcc, v56, v1, vcc
v_add_co_u32_e32 v61, vcc, s6, v57
v_addc_co_u32_e32 v62, vcc, v58, v1, vcc
v_add_co_u32_e32 v63, vcc, s6, v61
v_addc_co_u32_e32 v64, vcc, v62, v1, vcc
v_add_co_u32_e32 v65, vcc, s6, v63
v_addc_co_u32_e32 v66, vcc, v64, v1, vcc
v_add_co_u32_e32 v67, vcc, s6, v65
v_addc_co_u32_e32 v68, vcc, v66, v1, vcc
v_add_co_u32_e32 v69, vcc, s6, v67
v_addc_co_u32_e32 v70, vcc, v68, v1, vcc
v_add_co_u32_e32 v71, vcc, s6, v69
v_addc_co_u32_e32 v72, vcc, v70, v1, vcc
v_add_co_u32_e32 v73, vcc, s6, v71
v_addc_co_u32_e32 v74, vcc, v72, v1, vcc
v_add_co_u32_e32 v75, vcc, s6, v73
v_addc_co_u32_e32 v76, vcc, v74, v1, vcc
v_add_co_u32_e32 v77, vcc, s6, v75
v_addc_co_u32_e32 v78, vcc, v76, v1, vcc
v_add_co_u32_e32 v79, vcc, s6, v77
v_addc_co_u32_e32 v80, vcc, v78, v1, vcc
v_add_co_u32_e32 v81, vcc, s6, v79
v_addc_co_u32_e32 v82, vcc, v80, v1, vcc
v_add_co_u32_e32 v83, vcc, s6, v81
v_addc_co_u32_e32 v84, vcc, v82, v1, vcc
v_add_co_u32_e32 v85, vcc, s6, v83
v_addc_co_u32_e32 v86, vcc, v84, v1, vcc
v_add_co_u32_e32 v87, vcc, s6, v85
v_addc_co_u32_e32 v88, vcc, v86, v1, vcc
v_add_co_u32_e32 v89, vcc, s6, v87
v_addc_co_u32_e32 v90, vcc, v88, v1, vcc
v_add_co_u32_e32 v91, vcc, s6, v89
global_load_dword v97, v[25:26], off
global_load_dword v98, v[27:28], off
global_load_dword v99, v[29:30], off
global_load_dword v100, v[31:32], off
global_load_dword v101, v[33:34], off
global_load_dword v102, v[35:36], off
global_load_dword v103, v[37:38], off
global_load_dword v104, v[39:40], off
v_addc_co_u32_e32 v92, vcc, v90, v1, vcc
global_load_dword v13, v[41:42], off
global_load_dword v14, v[43:44], off
global_load_dword v15, v[47:48], off
global_load_dword v16, v[49:50], off
global_load_dword v9, v[51:52], off
global_load_dword v10, v[53:54], off
global_load_dword v11, v[55:56], off
global_load_dword v12, v[57:58], off
global_load_dword v5, v[61:62], off
global_load_dword v6, v[63:64], off
global_load_dword v7, v[65:66], off
global_load_dword v8, v[67:68], off
global_load_dword v1, v[69:70], off
global_load_dword v2, v[71:72], off
global_load_dword v3, v[73:74], off
global_load_dword v4, v[75:76], off
global_load_dword v17, v[77:78], off
global_load_dword v18, v[79:80], off
global_load_dword v19, v[81:82], off
global_load_dword v20, v[83:84], off
global_load_dword v21, v[85:86], off
global_load_dword v22, v[87:88], off
global_load_dword v23, v[89:90], off
global_load_dword v24, v[91:92], off
s_load_dword s12, s[4:5], 0x50
s_cmp_lt_i32 s36, 1
v_mov_b32_e32 v95, 0
s_waitcnt vmcnt(28)
buffer_store_dwordx4 v[97:100], off, s[0:3], 0 offset:16
s_waitcnt vmcnt(25)
buffer_store_dwordx4 v[101:104], off, s[0:3], 0 offset:32
s_waitcnt vmcnt(22)
buffer_store_dwordx4 v[13:16], off, s[0:3], 0 offset:48
s_waitcnt vmcnt(19)
buffer_store_dwordx4 v[9:12], off, s[0:3], 0 offset:64
s_waitcnt vmcnt(16)
buffer_store_dwordx4 v[5:8], off, s[0:3], 0 offset:80
s_waitcnt vmcnt(13)
buffer_store_dwordx4 v[1:4], off, s[0:3], 0 offset:96
s_waitcnt vmcnt(10)
buffer_store_dwordx4 v[17:20], off, s[0:3], 0 offset:112
s_waitcnt vmcnt(7)
buffer_store_dwordx4 v[21:24], off, s[0:3], 0 offset:128
s_cbranch_scc1 411
s_ashr_i32 s9, s8, 31
v_cvt_f32_i32_e32 v1, s39
s_cmp_lt_i32 s39, 1
v_mov_b32_e32 v2, 0x4f800000
s_cselect_b64 vcc, -1, 0
v_cndmask_b32_e32 v2, 1.0, v2, vcc
v_mul_f32_e32 v1, v2, v1
s_mov_b32 s4, 0xf800000
v_mul_f32_e32 v2, 0x4f800000, v1
v_cmp_gt_f32_e64 s[4:5], s4, v1
v_cndmask_b32_e64 v2, v1, v2, s[4:5]
v_lshlrev_b32_e32 v19, 2, v96
v_sqrt_f32_e32 v3, v2
v_mov_b32_e32 v8, s19
s_mov_b32 s33, 0
v_add_u32_e32 v4, -1, v3
v_fma_f32 v5, -v4, v3, v2
v_cmp_ge_f32_e64 s[6:7], 0, v5
v_add_u32_e32 v5, 1, v3
v_cndmask_b32_e64 v4, v3, v4, s[6:7]
v_fma_f32 v3, -v5, v3, v2
v_cmp_lt_f32_e64 s[6:7], 0, v3
v_cndmask_b32_e64 v3, v4, v5, s[6:7]
v_mul_f32_e32 v4, 0x37800000, v3
v_cndmask_b32_e64 v3, v3, v4, s[4:5]
v_mov_b32_e32 v4, 0x260
v_cmp_class_f32_e64 s[4:5], v2, v4
v_cndmask_b32_e64 v2, v3, v2, s[4:5]
v_add_u32_e32 v3, -1, v2
v_add_u32_e32 v4, 1, v2
v_mov_b32_e32 v5, 0x37800000
v_fma_f32 v7, -v3, v2, v1
v_cndmask_b32_e32 v5, 1.0, v5, vcc
v_fma_f32 v6, -v4, v2, v1
v_cmp_ge_f32_e32 vcc, 0, v7
v_cndmask_b32_e32 v2, v2, v3, vcc
v_cmp_lt_f32_e32 vcc, 0, v6
s_movk_i32 s4, 0x260
v_cndmask_b32_e32 v2, v2, v4, vcc
v_mul_f32_e32 v2, v5, v2
v_cmp_class_f32_e64 vcc, v1, s4
v_cndmask_b32_e32 v1, v2, v1, vcc
v_div_scale_f32 v2, s[4:5], v1, v1, 1.0
v_div_scale_f32 v3, vcc, 1.0, v1, 1.0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s4, s12, 31
s_add_i32 s12, s12, s4
s_xor_b32 s5, s12, s4
s_sub_i32 s7, 0, s5
s_add_i32 s6, s8, s9
s_xor_b32 s6, s6, s9
s_xor_b32 s4, s9, s4
v_rcp_f32_e32 v4, v2
v_fma_f32 v5, -v2, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v2, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v2, -v2, v5, v3
v_cvt_f32_u32_e32 v3, s5
v_div_fmas_f32 v2, v2, v4, v5
v_mov_b32_e32 v6, s30
v_mov_b32_e32 v7, s31
v_rcp_iflag_f32_e32 v3, v3
v_mul_f32_e32 v3, 0x4f7ffffe, v3
v_cvt_u32_f32_e32 v3, v3
v_readfirstlane_b32 s12, v3
s_mul_i32 s7, s7, s12
s_mul_hi_u32 s7, s12, s7
s_add_i32 s12, s12, s7
s_mul_hi_u32 s7, s6, s12
s_mul_i32 s12, s7, s5
s_sub_i32 s6, s6, s12
s_add_i32 s12, s7, 1
s_sub_i32 s13, s6, s5
s_cmp_ge_u32 s6, s5
s_cselect_b32 s7, s12, s7
s_cselect_b32 s6, s13, s6
s_add_i32 s12, s7, 1
s_cmp_ge_u32 s6, s5
s_cselect_b32 s5, s12, s7
s_xor_b32 s5, s5, s4
s_sub_i32 s6, s5, s4
s_ashr_i32 s39, s38, 31
v_div_fixup_f32 v18, v2, v1, 1.0
v_lshlrev_b32_e32 v1, 2, v0
s_cmp_lg_u64 s[30:31], 0
s_mul_hi_i32 s7, s14, s6
s_mul_i32 s6, s14, s6
v_and_b32_e32 v2, 0x380, v1
s_cselect_b64 s[28:29], -1, 0
s_lshl_b64 s[6:7], s[6:7], 2
v_cmp_gt_u32_e64 s[4:5], 32, v0
v_mov_b32_e32 v0, s7
v_add_co_u32_e32 v4, vcc, s6, v2
v_addc_co_u32_e32 v5, vcc, 0, v0, vcc
v_mov_b32_e32 v0, s21
v_add_co_u32_e32 v21, vcc, s20, v4
v_addc_co_u32_e32 v22, vcc, v0, v5, vcc
v_add_co_u32_e32 v0, vcc, 8, v21
s_mul_hi_i32 s7, s14, s37
s_mul_i32 s6, s14, s37
v_addc_co_u32_e32 v1, vcc, 0, v22, vcc
s_lshl_b64 s[20:21], s[6:7], 2
s_lshl_b64 s[6:7], s[10:11], 2
v_mov_b32_e32 v3, s7
v_add_co_u32_e32 v9, vcc, s6, v2
v_addc_co_u32_e32 v10, vcc, 0, v3, vcc
v_or_b32_e32 v20, v19, v2
v_add_co_u32_e32 v2, vcc, 8, v9
v_addc_co_u32_e32 v3, vcc, 0, v10, vcc
v_add_co_u32_e32 v23, vcc, s18, v4
v_mul_lo_u32 v11, v2, s15
v_mul_lo_u32 v12, v3, s14
v_mad_u64_u32 v[2:3], s[6:7], v2, s14, v[6:7]
v_addc_co_u32_e32 v24, vcc, v8, v5, vcc
s_mul_i32 s10, s14, s14
v_add_co_u32_e32 v4, vcc, 4, v9
s_mul_hi_i32 s6, s14, s14
s_mul_hi_u32 s7, s10, s38
s_mul_i32 s11, s10, s39
v_addc_co_u32_e32 v5, vcc, 0, v10, vcc
s_add_i32 s7, s7, s11
s_mul_i32 s6, s6, s38
v_add_co_u32_e32 v9, vcc, 12, v9
v_add3_u32 v3, v12, v3, v11
s_add_i32 s7, s7, s6
s_mul_i32 s6, s10, s38
v_mul_lo_u32 v8, v4, s15
v_mul_lo_u32 v11, v5, s14
v_mad_u64_u32 v[4:5], s[10:11], v4, s14, v[6:7]
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_mul_lo_u32 v12, v9, s15
v_mul_lo_u32 v10, v10, s14
v_mad_u64_u32 v[6:7], s[10:11], v9, s14, v[6:7]
v_add3_u32 v5, v11, v5, v8
v_mov_b32_e32 v9, s31
v_add_co_u32_e32 v8, vcc, s30, v93
s_lshl_b64 s[18:19], s[6:7], 2
s_lshl_b64 s[34:35], s[14:15], 4
v_add3_u32 v7, v10, v7, v12
v_addc_co_u32_e32 v9, vcc, v9, v94, vcc
s_branch 19
v_mov_b32_e32 v10, s21
v_add_co_u32_e32 v0, vcc, s20, v0
v_addc_co_u32_e32 v1, vcc, v1, v10, vcc
v_add_co_u32_e32 v23, vcc, s20, v23
v_addc_co_u32_e32 v24, vcc, v24, v10, vcc
v_add_co_u32_e32 v21, vcc, s20, v21
v_addc_co_u32_e32 v22, vcc, v22, v10, vcc
v_mov_b32_e32 v10, s19
v_add_co_u32_e32 v2, vcc, s18, v2
v_addc_co_u32_e32 v3, vcc, v3, v10, vcc
v_add_co_u32_e32 v4, vcc, s18, v4
v_addc_co_u32_e32 v5, vcc, v5, v10, vcc
v_add_co_u32_e32 v6, vcc, s18, v6
v_addc_co_u32_e32 v7, vcc, v7, v10, vcc
s_add_i32 s33, s33, 1
v_add_co_u32_e32 v8, vcc, s18, v8
s_cmp_eq_u32 s33, s36
v_addc_co_u32_e32 v9, vcc, v9, v10, vcc
s_cbranch_scc1 195
s_mul_i32 s6, s33, s39
s_mul_hi_u32 s7, s33, s38
s_add_i32 s7, s7, s6
s_mul_i32 s6, s33, s38
s_add_u32 s6, s6, s8
s_addc_u32 s7, s7, s9
s_lshl_b64 s[10:11], s[6:7], 2
s_add_u32 s12, s24, s10
s_addc_u32 s13, s25, s11
global_load_dword v10, v95, s[12:13]
s_add_u32 s10, s26, s10
s_addc_u32 s11, s27, s11
global_load_dword v13, v95, s[10:11]
v_mov_b32_e32 v14, 0
s_mov_b32 s10, 0
s_waitcnt vmcnt(1)
v_mul_f32_e32 v10, 0x3fb8aa3b, v10
s_nop 0
v_exp_f32_e32 v15, v10
v_mov_b32_e32 v11, v1
v_mov_b32_e32 v10, v0
v_mov_b32_e32 v12, 16
v_add_u32_e32 v16, s10, v12
buffer_load_dwordx4 v[96:99], v16, s[0:3], 0 offen
global_load_dwordx4 v[100:103], v[10:11], off offset:-8
v_add_co_u32_e32 v10, vcc, 16, v10
s_add_i32 s10, s10, 16
v_addc_co_u32_e32 v11, vcc, 0, v11, vcc
s_cmpk_eq_i32 s10, 0x80
s_waitcnt vmcnt(1)
v_mul_f32_e32 v96, v15, v96
v_mul_f32_e32 v97, v15, v97
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v14, v96, v100
v_mul_f32_e32 v98, v15, v98
v_fmac_f32_e32 v14, v97, v101
v_mul_f32_e32 v99, v15, v99
v_fmac_f32_e32 v14, v98, v102
v_fmac_f32_e32 v14, v99, v103
buffer_store_dwordx4 v[96:99], v16, s[0:3], 0 offen
s_cbranch_scc0 65513
v_mov_b32_e32 v10, s14
v_mad_u64_u32 v[10:11], s[10:11], s6, v10, v[45:46]
s_mul_i32 s7, s7, s14
s_mul_i32 s6, s6, s15
v_add_u32_e32 v11, s7, v11
v_add_u32_e32 v11, s6, v11
v_lshlrev_b64 v[93:94], 2, v[10:11]
v_mov_b32_e32 v96, s23
v_add_co_u32_e32 v93, vcc, s22, v93
v_addc_co_u32_e32 v94, vcc, v96, v94, vcc
ds_write_b32 v20, v14
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_read2_b32 v[14:15], v19 offset1:32
ds_read2_b32 v[16:17], v19 offset0:64 offset1:96
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
global_load_dword v93, v[93:94], off
v_add_f32_e32 v14, 0, v14
v_add_f32_e32 v14, v14, v15
v_add_f32_e32 v14, v14, v16
v_add_f32_e32 v14, v14, v17
s_mov_b64 s[10:11], 0
s_waitcnt vmcnt(0)
v_sub_f32_e32 v14, v93, v14
v_mul_f32_e32 v14, v13, v14
v_mov_b32_e32 v13, 0
v_mov_b32_e32 v16, s11
v_add_co_u32_e64 v93, s[6:7], s10, v21
buffer_load_dwordx4 v[96:99], v12, s[0:3], 0 offen
v_add_co_u32_e32 v15, vcc, s10, v23
v_addc_co_u32_e64 v94, s[6:7], v22, v16, s[6:7]
v_addc_co_u32_e32 v16, vcc, v24, v16, vcc
global_load_dwordx4 v[100:103], v[93:94], off
global_load_dwordx4 v[104:107], v[15:16], off
s_add_u32 s10, s10, 16
s_addc_u32 s11, s11, 0
s_cmpk_eq_i32 s10, 0x80
s_waitcnt vmcnt(1)
v_fma_f32 v96, v100, v14, v96
v_fma_f32 v97, v101, v14, v97
s_waitcnt vmcnt(0)
v_fmac_f32_e32 v13, v96, v104
v_fma_f32 v98, v102, v14, v98
v_fmac_f32_e32 v13, v97, v105
v_fmac_f32_e32 v99, v103, v14
v_fmac_f32_e32 v13, v98, v106
buffer_store_dwordx4 v[96:99], v12, s[0:3], 0 offen
v_add_u32_e32 v12, 16, v12
v_fmac_f32_e32 v13, v99, v107
s_cbranch_scc0 65503
ds_write_b32 v20, v13
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_and_saveexec_b64 s[6:7], s[4:5]
s_cbranch_execz 18
ds_read2_b32 v[12:13], v19 offset1:32
ds_read2_b32 v[14:15], v19 offset0:64 offset1:96
v_lshlrev_b64 v[10:11], 2, v[10:11]
v_mov_b32_e32 v16, s17
v_add_co_u32_e32 v10, vcc, s16, v10
s_waitcnt lgkmcnt(1)
v_add_f32_e32 v12, 0, v12
v_add_f32_e32 v12, v12, v13
s_waitcnt lgkmcnt(0)
v_add_f32_e32 v12, v12, v14
v_add_f32_e32 v12, v12, v15
v_mul_f32_e32 v12, v18, v12
v_addc_co_u32_e32 v11, vcc, v16, v11, vcc
global_store_dword v[10:11], v12, off
s_or_b64 exec, exec, s[6:7]
s_andn2_b64 vcc, exec, s[28:29]
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccnz 65371
v_mov_b32_e32 v11, v9
v_mov_b32_e32 v13, v7
v_mov_b32_e32 v15, v5
v_mov_b32_e32 v17, v3
s_mov_b32 s30, 0
v_mov_b32_e32 v10, v8
v_mov_b32_e32 v12, v6
v_mov_b32_e32 v14, v4
v_mov_b32_e32 v16, v2
v_mov_b32_e32 v93, 16
v_add_u32_e32 v93, s30, v93
buffer_load_dwordx4 v[96:99], v93, s[0:3], 0 offen
v_add_co_u32_e32 v93, vcc, v10, v59
v_addc_co_u32_e32 v94, vcc, v11, v60, vcc
v_add_co_u32_e32 v100, vcc, v14, v59
v_addc_co_u32_e32 v101, vcc, v15, v60, vcc
v_add_co_u32_e32 v102, vcc, v16, v59
v_addc_co_u32_e32 v103, vcc, v17, v60, vcc
v_add_co_u32_e32 v104, vcc, v12, v59
v_addc_co_u32_e32 v105, vcc, v13, v60, vcc
v_mov_b32_e32 v106, s35
v_add_co_u32_e32 v14, vcc, s34, v14
v_add_co_u32_e64 v12, s[6:7], s34, v12
v_add_co_u32_e64 v10, s[10:11], s34, v10
v_add_co_u32_e64 v16, s[12:13], s34, v16
s_add_i32 s30, s30, 16
v_addc_co_u32_e64 v17, s[12:13], v17, v106, s[12:13]
v_addc_co_u32_e32 v15, vcc, v15, v106, vcc
v_addc_co_u32_e64 v13, vcc, v13, v106, s[6:7]
v_addc_co_u32_e64 v11, vcc, v11, v106, s[10:11]
s_cmpk_lg_i32 s30, 0x80
s_waitcnt vmcnt(0)
global_store_dword v[93:94], v96, off
global_store_dword v[100:101], v97, off
global_store_dword v[102:103], v98, off
global_store_dword v[104:105], v99, off
s_cbranch_scc1 65497
s_branch 65322
buffer_load_dwordx4 v[13:16], off, s[0:3], 0 offset:48
buffer_load_dwordx4 v[9:12], off, s[0:3], 0 offset:64
buffer_load_dwordx4 v[5:8], off, s[0:3], 0 offset:80
buffer_load_dwordx4 v[1:4], off, s[0:3], 0 offset:96
buffer_load_dwordx4 v[17:20], off, s[0:3], 0 offset:112
buffer_load_dwordx4 v[21:24], off, s[0:3], 0 offset:128
buffer_load_dwordx4 v[93:96], off, s[0:3], 0 offset:16
buffer_load_dwordx4 v[97:100], off, s[0:3], 0 offset:32
s_waitcnt vmcnt(1)
global_store_dword v[25:26], v93, off
global_store_dword v[27:28], v94, off
global_store_dword v[29:30], v95, off
global_store_dword v[31:32], v96, off
s_waitcnt vmcnt(4)
global_store_dword v[33:34], v97, off
global_store_dword v[35:36], v98, off
global_store_dword v[37:38], v99, off
global_store_dword v[39:40], v100, off
global_store_dword v[41:42], v13, off
global_store_dword v[43:44], v14, off
global_store_dword v[47:48], v15, off
global_store_dword v[49:50], v16, off
global_store_dword v[51:52], v9, off
global_store_dword v[53:54], v10, off
global_store_dword v[55:56], v11, off
global_store_dword v[57:58], v12, off
global_store_dword v[61:62], v5, off
global_store_dword v[63:64], v6, off
global_store_dword v[65:66], v7, off
global_store_dword v[67:68], v8, off
global_store_dword v[69:70], v1, off
global_store_dword v[71:72], v2, off
global_store_dword v[73:74], v3, off
global_store_dword v[75:76], v4, off
global_store_dword v[77:78], v17, off
global_store_dword v[79:80], v18, off
global_store_dword v[81:82], v19, off
global_store_dword v[83:84], v20, off
global_store_dword v[85:86], v21, off
global_store_dword v[87:88], v22, off
global_store_dword v[89:90], v23, off
global_store_dword v[91:92], v24, off
s_endpgm
