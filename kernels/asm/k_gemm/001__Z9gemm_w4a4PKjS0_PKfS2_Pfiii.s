.text
k__Z9gemm_w4a4PKjS0_PKfS2_Pfiii:
s_load_dwordx4 s[16:19], s[4:5], 0x28
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_lshl_b32 s30, s7, 7
v_lshrrev_b32_e32 v65, 1, v0
v_lshlrev_b32_e32 v1, 3, v0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s2, s18, 3
v_and_b32_e32 v66, 8, v1
v_or_b32_e32 v1, s30, v65
v_mad_i64_i32 v[1:2], s[0:1], s2, v1, 0
s_lshl_b32 s31, s6, 6
v_lshrrev_b32_e32 v67, 2, v0
v_or_b32_e32 v3, s31, v67
v_lshlrev_b64 v[1:2], 2, v[1:2]
v_mad_i64_i32 v[3:4], s[0:1], s2, v3, 0
v_mov_b32_e32 v5, s9
v_add_co_u32_e32 v1, vcc, s8, v1
v_addc_co_u32_e32 v2, vcc, v5, v2, vcc
v_lshlrev_b32_e32 v5, 2, v66
v_add_co_u32_e32 v61, vcc, v1, v5
v_addc_co_u32_e32 v62, vcc, 0, v2, vcc
v_lshlrev_b64 v[1:2], 2, v[3:4]
v_lshlrev_b32_e32 v68, 2, v0
v_and_b32_e32 v69, 12, v68
v_mov_b32_e32 v3, s11
v_add_co_u32_e32 v1, vcc, s10, v1
v_addc_co_u32_e32 v2, vcc, v3, v2, vcc
v_lshlrev_b32_e32 v3, 2, v69
v_add_co_u32_e32 v63, vcc, v1, v3
v_addc_co_u32_e32 v64, vcc, 0, v2, vcc
global_load_dwordx4 v[5:8], v[61:62], off offset:16
global_load_dwordx4 v[1:4], v[61:62], off
global_load_dwordx4 v[9:12], v[63:64], off
v_mov_b32_e32 v14, s13
v_subrev_u32_e32 v49, 32, v0
v_cmp_gt_u32_e64 s[6:7], 32, v0
v_cmp_lt_u32_e64 s[0:1], 31, v0
s_mov_b64 s[20:21], -1
v_mov_b32_e32 v13, s12
v_mov_b32_e32 v16, s30
v_mov_b32_e32 v15, v68
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 14
v_cmp_gt_u32_e32 vcc, 16, v49
s_mov_b64 s[20:21], 0
s_and_saveexec_b64 s[8:9], vcc
s_mov_b64 s[20:21], exec
v_lshlrev_b32_e32 v15, 2, v49
s_or_b64 exec, exec, s[8:9]
s_mov_b32 s8, 0
v_mov_b32_e32 v13, s14
s_mov_b32 s9, s8
s_mov_b32 s10, s8
s_mov_b32 s11, s8
v_mov_b32_e32 v14, s15
v_mov_b32_e32 v16, s31
s_orn2_b64 s[20:21], s[20:21], exec
s_or_b64 exec, exec, s[2:3]
v_mov_b32_e32 v20, s11
v_mov_b32_e32 v19, s10
v_mov_b32_e32 v18, s9
v_mov_b32_e32 v17, s8
s_and_saveexec_b64 s[2:3], s[20:21]
s_cbranch_execz 9
v_ashrrev_i32_e32 v17, 31, v16
v_add_co_u32_e32 v15, vcc, v15, v16
v_addc_co_u32_e32 v16, vcc, 0, v17, vcc
v_lshlrev_b64 v[15:16], 2, v[15:16]
v_add_co_u32_e32 v13, vcc, v13, v15
v_addc_co_u32_e32 v14, vcc, v14, v16, vcc
global_load_dwordx4 v[17:20], v[13:14], off
s_or_b64 exec, exec, s[2:3]
s_mov_b64 s[2:3], 0
s_and_saveexec_b64 s[8:9], s[0:1]
s_xor_b64 s[8:9], exec, s[8:9]
s_cbranch_execnz 54
s_andn2_saveexec_b64 s[8:9], s[8:9]
s_cbranch_execnz 64
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execz 3
s_waitcnt vmcnt(0)
ds_write_b128 v13, v[17:20]
s_or_b64 exec, exec, s[8:9]
v_lshrrev_b32_e32 v50, 4, v0
v_and_b32_e32 v51, 15, v0
v_lshlrev_b32_e32 v0, 2, v65
s_movk_i32 s2, 0x210
v_mad_u32_u24 v0, v66, s2, v0
v_add_u32_e32 v13, 0x400, v0
s_waitcnt vmcnt(1)
ds_write2_b32 v0, v1, v2 offset1:132
ds_write2_b32 v13, v3, v4 offset0:8 offset1:140
v_add_u32_e32 v13, 0x800, v0
v_add_u32_e32 v0, 0xc00, v0
ds_write2_b32 v0, v7, v8 offset0:24 offset1:156
v_lshlrev_b32_e32 v0, 2, v67
s_movk_i32 s2, 0x110
v_mad_u32_u24 v0, v69, s2, v0
ds_write2_b32 v13, v5, v6 offset0:16 offset1:148
v_add_u32_e32 v13, 0x4000, v0
v_add_u32_e32 v0, 0x4400, v0
s_ashr_i32 s9, s17, 31
s_waitcnt vmcnt(0)
ds_write2_b32 v0, v11, v12 offset0:8 offset1:76
s_cmpk_gt_i32 s18, 0x7f
v_lshlrev_b32_e32 v0, 3, v50
v_lshlrev_b32_e32 v70, 2, v51
ds_write2_b32 v13, v9, v10 offset0:128 offset1:196
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 24
s_mov_b64 s[2:3], 0
s_mov_b32 s10, 0
s_branch 22
v_cmp_gt_u32_e32 vcc, 16, v49
s_and_saveexec_b64 s[10:11], vcc
s_xor_b64 s[10:11], exec, s[10:11]
v_mov_b32_e32 v13, 0x6800
s_mov_b64 s[2:3], exec
v_lshl_add_u32 v13, v49, 4, v13
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[2:3], s[2:3], exec
s_andn2_saveexec_b64 s[8:9], s[8:9]
s_cbranch_execz 65472
v_mov_b32_e32 v13, 0x6400
v_lshl_add_u32 v13, v68, 2, v13
s_or_b64 s[2:3], s[2:3], exec
s_or_b64 exec, exec, s[8:9]
s_and_saveexec_b64 s[8:9], s[2:3]
s_cbranch_execnz 65467
s_branch 65469
s_mov_b64 s[2:3], -1
s_load_dwordx2 s[4:5], s[4:5], 0x20
s_andn2_b64 vcc, exec, s[2:3]
v_mov_b32_e32 v45, s10
v_mov_b32_e32 v46, s10
v_mov_b32_e32 v47, s10
v_mov_b32_e32 v48, s10
v_mov_b32_e32 v41, s10
v_mov_b32_e32 v42, s10
v_mov_b32_e32 v43, s10
v_mov_b32_e32 v44, s10
v_mov_b32_e32 v37, s10
v_mov_b32_e32 v38, s10
v_mov_b32_e32 v39, s10
v_mov_b32_e32 v40, s10
v_mov_b32_e32 v33, s10
v_mov_b32_e32 v34, s10
v_mov_b32_e32 v35, s10
v_mov_b32_e32 v36, s10
v_mov_b32_e32 v29, s10
v_mov_b32_e32 v30, s10
v_mov_b32_e32 v31, s10
v_mov_b32_e32 v32, s10
v_mov_b32_e32 v25, s10
v_mov_b32_e32 v26, s10
v_mov_b32_e32 v27, s10
v_mov_b32_e32 v28, s10
v_mov_b32_e32 v21, s10
v_mov_b32_e32 v22, s10
v_mov_b32_e32 v23, s10
v_mov_b32_e32 v24, s10
v_mov_b32_e32 v13, s10
v_mov_b32_e32 v14, s10
v_mov_b32_e32 v15, s10
v_mov_b32_e32 v16, s10
s_cbranch_vccnz 1468
s_ashr_i32 s2, s18, 31
s_lshr_b32 s2, s2, 25
s_add_i32 s2, s18, s2
s_mov_b32 s8, s17
s_ashr_i32 s33, s2, 7
v_cmp_gt_u32_e64 s[2:3], 16, v49
s_ashr_i32 s11, s16, 31
s_mov_b32 s10, s16
v_lshlrev_b32_e32 v0, 3, v50
v_lshlrev_b32_e32 v70, 2, v51
v_lshlrev_b32_e32 v71, 2, v49
s_mov_b64 s[18:19], 0
v_mov_b32_e32 v16, 0
s_mov_b64 s[24:25], 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v13, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v28, 0
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v36, 0
v_mov_b32_e32 v35, 0
v_mov_b32_e32 v34, 0
v_mov_b32_e32 v33, 0
v_mov_b32_e32 v40, 0
v_mov_b32_e32 v39, 0
v_mov_b32_e32 v38, 0
v_mov_b32_e32 v37, 0
v_mov_b32_e32 v44, 0
v_mov_b32_e32 v43, 0
v_mov_b32_e32 v42, 0
v_mov_b32_e32 v41, 0
v_mov_b32_e32 v48, 0
v_mov_b32_e32 v47, 0
v_mov_b32_e32 v46, 0
v_mov_b32_e32 v45, 0
s_add_u32 s20, s24, 1
s_addc_u32 s21, s25, 0
s_cmp_lt_i32 s20, s33
s_cselect_b64 s[22:23], -1, 0
s_cmp_ge_i32 s20, s33
s_cbranch_scc1 50
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v9, vcc, s18, v61
v_addc_co_u32_e32 v10, vcc, v62, v11, vcc
global_load_dwordx4 v[1:4], v[9:10], off offset:64
global_load_dwordx4 v[5:8], v[9:10], off offset:80
v_add_co_u32_e32 v9, vcc, s18, v63
v_addc_co_u32_e32 v10, vcc, v64, v11, vcc
global_load_dwordx4 v[9:12], v[9:10], off offset:64
v_mov_b32_e32 v50, s13
v_mov_b32_e32 v52, s11
v_mov_b32_e32 v49, s12
v_mov_b32_e32 v51, s10
v_mov_b32_e32 v53, s30
s_mov_b64 s[26:27], s[6:7]
v_mov_b32_e32 v54, v68
s_and_saveexec_b64 s[28:29], s[0:1]
v_mov_b32_e32 v50, s15
v_mov_b32_e32 v52, s9
s_andn2_b64 s[26:27], s[6:7], exec
s_and_b64 s[34:35], s[2:3], exec
v_mov_b32_e32 v49, s14
v_mov_b32_e32 v51, s8
v_mov_b32_e32 v53, s31
s_or_b64 s[26:27], s[26:27], s[34:35]
v_mov_b32_e32 v54, v71
s_or_b64 exec, exec, s[28:29]
s_and_saveexec_b64 s[28:29], s[26:27]
s_cbranch_execz 18
v_ashrrev_i32_e32 v18, 31, v53
v_ashrrev_i32_e32 v19, 31, v54
v_add_co_u32_e32 v17, vcc, v53, v54
v_addc_co_u32_e32 v18, vcc, v18, v19, vcc
v_mad_u64_u32 v[17:18], s[26:27], v51, s20, v[17:18]
v_mul_lo_u32 v19, v51, s21
v_mul_lo_u32 v20, v52, s20
v_add3_u32 v18, v20, v18, v19
v_lshlrev_b64 v[17:18], 2, v[17:18]
v_add_co_u32_e32 v17, vcc, v49, v17
v_addc_co_u32_e32 v18, vcc, v50, v18, vcc
global_load_dwordx4 v[17:20], v[17:18], off
s_or_b64 exec, exec, s[28:29]
s_and_b32 s16, s24, 1
s_mul_i32 s24, s16, 0x2100
v_lshlrev_b32_e32 v49, 2, v0
v_add_u32_e32 v51, s24, v49
s_mul_i32 s24, s16, 0x1100
v_lshlrev_b32_e32 v53, 2, v70
v_or_b32_e32 v50, s24, v53
ds_read_b128 v[54:57], v51
ds_read_b128 v[104:107], v51 offset:16
ds_read_b128 v[108:111], v51 offset:528
ds_read_b128 v[112:115], v51 offset:544
ds_read_b128 v[116:119], v50 offset:16896
ds_read_b128 v[120:123], v50 offset:17168
v_mov_b32_e32 v103, 0
s_waitcnt lgkmcnt(0)
v_dot8_i32_i4 v103, v54, v116, v103
v_mov_b32_e32 v102, 0
v_dot8_i32_i4 v102, v54, v117, v102
v_mov_b32_e32 v101, 0
v_dot8_i32_i4 v101, v54, v118, v101
v_mov_b32_e32 v100, 0
v_dot8_i32_i4 v100, v54, v119, v100
v_mov_b32_e32 v99, 0
v_dot8_i32_i4 v99, v55, v116, v99
v_mov_b32_e32 v98, 0
v_dot8_i32_i4 v98, v55, v117, v98
v_mov_b32_e32 v97, 0
v_dot8_i32_i4 v97, v55, v118, v97
v_mov_b32_e32 v96, 0
v_dot8_i32_i4 v96, v55, v119, v96
v_mov_b32_e32 v95, 0
v_dot8_i32_i4 v95, v56, v116, v95
v_mov_b32_e32 v94, 0
v_dot8_i32_i4 v94, v56, v117, v94
v_mov_b32_e32 v93, 0
v_dot8_i32_i4 v93, v56, v118, v93
v_mov_b32_e32 v92, 0
v_dot8_i32_i4 v92, v56, v119, v92
v_mov_b32_e32 v91, 0
v_dot8_i32_i4 v91, v57, v116, v91
v_mov_b32_e32 v90, 0
v_dot8_i32_i4 v90, v57, v117, v90
v_mov_b32_e32 v89, 0
v_dot8_i32_i4 v89, v57, v118, v89
v_mov_b32_e32 v88, 0
v_dot8_i32_i4 v88, v57, v119, v88
v_mov_b32_e32 v87, 0
v_dot8_i32_i4 v87, v104, v116, v87
v_mov_b32_e32 v86, 0
v_dot8_i32_i4 v86, v104, v117, v86
v_mov_b32_e32 v85, 0
v_dot8_i32_i4 v85, v104, v118, v85
v_mov_b32_e32 v84, 0
v_dot8_i32_i4 v84, v104, v119, v84
v_mov_b32_e32 v83, 0
v_dot8_i32_i4 v83, v105, v116, v83
v_mov_b32_e32 v82, 0
v_dot8_i32_i4 v82, v105, v117, v82
v_mov_b32_e32 v81, 0
v_dot8_i32_i4 v81, v105, v118, v81
v_mov_b32_e32 v80, 0
v_dot8_i32_i4 v80, v105, v119, v80
v_mov_b32_e32 v79, 0
v_dot8_i32_i4 v79, v106, v116, v79
v_mov_b32_e32 v78, 0
v_dot8_i32_i4 v78, v106, v117, v78
v_mov_b32_e32 v77, 0
v_dot8_i32_i4 v77, v106, v118, v77
v_mov_b32_e32 v76, 0
v_dot8_i32_i4 v76, v106, v119, v76
v_mov_b32_e32 v75, 0
v_dot8_i32_i4 v75, v107, v116, v75
v_mov_b32_e32 v74, 0
v_dot8_i32_i4 v74, v107, v117, v74
v_mov_b32_e32 v73, 0
v_dot8_i32_i4 v73, v107, v118, v73
v_mov_b32_e32 v72, 0
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:1056
ds_read_b128 v[104:107], v51 offset:1072
ds_read_b128 v[116:119], v50 offset:17440
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:1584
ds_read_b128 v[112:115], v51 offset:1600
ds_read_b128 v[120:123], v50 offset:17712
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:2112
ds_read_b128 v[104:107], v51 offset:2128
ds_read_b128 v[116:119], v50 offset:17984
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:2640
ds_read_b128 v[112:115], v51 offset:2656
ds_read_b128 v[120:123], v50 offset:18256
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:3168
ds_read_b128 v[104:107], v51 offset:3184
ds_read_b128 v[116:119], v50 offset:18528
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:3696
ds_read_b128 v[112:115], v51 offset:3712
ds_read_b128 v[120:123], v50 offset:18800
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:4224
ds_read_b128 v[104:107], v51 offset:4240
ds_read_b128 v[116:119], v50 offset:19072
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:4752
ds_read_b128 v[112:115], v51 offset:4768
ds_read_b128 v[120:123], v50 offset:19344
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:5280
ds_read_b128 v[104:107], v51 offset:5296
ds_read_b128 v[116:119], v50 offset:19616
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:5808
ds_read_b128 v[112:115], v51 offset:5824
ds_read_b128 v[120:123], v50 offset:19888
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:6336
ds_read_b128 v[104:107], v51 offset:6352
ds_read_b128 v[116:119], v50 offset:20160
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:6864
ds_read_b128 v[112:115], v51 offset:6880
ds_read_b128 v[120:123], v50 offset:20432
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
ds_read_b128 v[54:57], v51 offset:7392
ds_read_b128 v[104:107], v51 offset:7408
ds_read_b128 v[116:119], v50 offset:20704
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
ds_read_b128 v[108:111], v51 offset:7920
ds_read_b128 v[112:115], v51 offset:7936
ds_read_b128 v[120:123], v50 offset:20976
s_waitcnt lgkmcnt(3)
v_dot8_i32_i4 v103, v54, v116, v103
v_dot8_i32_i4 v102, v54, v117, v102
v_dot8_i32_i4 v101, v54, v118, v101
v_dot8_i32_i4 v100, v54, v119, v100
v_dot8_i32_i4 v99, v55, v116, v99
v_dot8_i32_i4 v98, v55, v117, v98
v_dot8_i32_i4 v97, v55, v118, v97
v_dot8_i32_i4 v96, v55, v119, v96
v_dot8_i32_i4 v95, v56, v116, v95
v_dot8_i32_i4 v94, v56, v117, v94
v_dot8_i32_i4 v93, v56, v118, v93
v_dot8_i32_i4 v92, v56, v119, v92
v_dot8_i32_i4 v91, v57, v116, v91
v_dot8_i32_i4 v90, v57, v117, v90
v_dot8_i32_i4 v89, v57, v118, v89
v_dot8_i32_i4 v88, v57, v119, v88
v_dot8_i32_i4 v87, v104, v116, v87
v_dot8_i32_i4 v86, v104, v117, v86
v_dot8_i32_i4 v85, v104, v118, v85
v_dot8_i32_i4 v84, v104, v119, v84
v_dot8_i32_i4 v83, v105, v116, v83
v_dot8_i32_i4 v82, v105, v117, v82
v_dot8_i32_i4 v81, v105, v118, v81
v_dot8_i32_i4 v80, v105, v119, v80
v_dot8_i32_i4 v79, v106, v116, v79
v_dot8_i32_i4 v78, v106, v117, v78
v_dot8_i32_i4 v77, v106, v118, v77
v_dot8_i32_i4 v76, v106, v119, v76
v_dot8_i32_i4 v75, v107, v116, v75
v_dot8_i32_i4 v74, v107, v117, v74
v_dot8_i32_i4 v73, v107, v118, v73
v_dot8_i32_i4 v72, v107, v119, v72
s_waitcnt lgkmcnt(0)
v_dot8_i32_i4 v103, v108, v120, v103
v_dot8_i32_i4 v102, v108, v121, v102
v_dot8_i32_i4 v101, v108, v122, v101
v_dot8_i32_i4 v100, v108, v123, v100
v_dot8_i32_i4 v99, v109, v120, v99
v_dot8_i32_i4 v98, v109, v121, v98
v_dot8_i32_i4 v97, v109, v122, v97
v_dot8_i32_i4 v96, v109, v123, v96
v_dot8_i32_i4 v95, v110, v120, v95
v_dot8_i32_i4 v94, v110, v121, v94
v_dot8_i32_i4 v93, v110, v122, v93
v_dot8_i32_i4 v92, v110, v123, v92
v_dot8_i32_i4 v91, v111, v120, v91
v_dot8_i32_i4 v90, v111, v121, v90
v_dot8_i32_i4 v89, v111, v122, v89
v_dot8_i32_i4 v88, v111, v123, v88
v_dot8_i32_i4 v87, v112, v120, v87
v_dot8_i32_i4 v86, v112, v121, v86
v_dot8_i32_i4 v85, v112, v122, v85
v_dot8_i32_i4 v84, v112, v123, v84
v_dot8_i32_i4 v83, v113, v120, v83
v_dot8_i32_i4 v82, v113, v121, v82
v_dot8_i32_i4 v81, v113, v122, v81
v_dot8_i32_i4 v80, v113, v123, v80
v_dot8_i32_i4 v79, v114, v120, v79
v_dot8_i32_i4 v78, v114, v121, v78
v_dot8_i32_i4 v77, v114, v122, v77
v_dot8_i32_i4 v76, v114, v123, v76
v_dot8_i32_i4 v75, v115, v120, v75
v_dot8_i32_i4 v74, v115, v121, v74
v_dot8_i32_i4 v73, v115, v122, v73
v_dot8_i32_i4 v72, v115, v123, v72
v_lshl_or_b32 v49, s16, 9, v49
v_lshl_or_b32 v53, s16, 8, v53
ds_read_b128 v[57:60], v49 offset:25600
ds_read_b128 v[49:52], v49 offset:25616
ds_read_b128 v[53:56], v53 offset:26624
s_andn2_b64 vcc, exec, s[22:23]
s_cbranch_vccnz 50
s_and_b32 s28, s20, 1
s_mov_b64 s[22:23], 0
s_and_saveexec_b64 s[24:25], s[0:1]
s_xor_b64 s[24:25], exec, s[24:25]
s_cbranch_execnz 151
s_andn2_saveexec_b64 s[24:25], s[24:25]
s_cbranch_execnz 161
s_or_b64 exec, exec, s[24:25]
s_and_saveexec_b64 s[24:25], s[22:23]
s_cbranch_execz 3
s_waitcnt vmcnt(0)
ds_write_b128 v104, v[17:20]
s_or_b64 exec, exec, s[24:25]
s_xor_b32 s16, s16, 1
v_lshlrev_b32_e32 v104, 2, v65
v_mul_u32_u24_e32 v105, 0x210, v66
s_mul_i32 s22, s16, 0x2100
v_add3_u32 v104, s22, v105, v104
v_add_u32_e32 v105, 0x400, v104
s_waitcnt vmcnt(2)
ds_write2_b32 v104, v1, v2 offset1:132
ds_write2_b32 v105, v3, v4 offset0:8 offset1:140
v_add_u32_e32 v105, 0x800, v104
v_add_u32_e32 v104, 0xc00, v104
s_mulk_i32 s16, 0x1100
s_waitcnt vmcnt(1)
ds_write2_b32 v105, v5, v6 offset0:16 offset1:148
ds_write2_b32 v104, v7, v8 offset0:24 offset1:156
v_lshlrev_b32_e32 v104, 2, v67
v_mul_u32_u24_e32 v105, 0x110, v69
s_addk_i32 s16, 0x4200
v_add3_u32 v104, s16, v105, v104
s_waitcnt vmcnt(0)
ds_write2_b32 v104, v9, v10 offset1:68
ds_write2_b32 v104, v11, v12 offset0:136 offset1:204
v_cvt_f32_i32_e32 v102, v102
v_cvt_f32_i32_e32 v100, v100
v_cvt_f32_i32_e32 v99, v99
s_waitcnt lgkmcnt(0)
v_mul_f32_e32 v105, v57, v54
v_cvt_f32_i32_e32 v98, v98
v_mul_f32_e32 v104, v57, v53
v_fmac_f32_e32 v46, v102, v105
v_mul_f32_e32 v102, v57, v55
v_mul_f32_e32 v57, v57, v56
v_cvt_f32_i32_e32 v97, v97
v_fmac_f32_e32 v48, v100, v57
v_mul_f32_e32 v57, v53, v58
v_fmac_f32_e32 v41, v99, v57
v_mul_f32_e32 v57, v54, v58
v_fmac_f32_e32 v42, v98, v57
v_mul_f32_e32 v57, v55, v58
v_cvt_f32_i32_e32 v96, v96
v_fmac_f32_e32 v43, v97, v57
v_mul_f32_e32 v57, v56, v58
v_cvt_f32_i32_e32 v58, v95
v_fmac_f32_e32 v44, v96, v57
v_mul_f32_e32 v57, v53, v59
v_cvt_f32_i32_e32 v94, v94
v_fmac_f32_e32 v37, v58, v57
v_cvt_f32_i32_e32 v58, v93
v_mul_f32_e32 v57, v54, v59
v_fmac_f32_e32 v38, v94, v57
v_mul_f32_e32 v57, v55, v59
v_cvt_f32_i32_e32 v92, v92
v_fmac_f32_e32 v39, v58, v57
v_cvt_f32_i32_e32 v58, v91
v_mul_f32_e32 v57, v56, v59
v_fmac_f32_e32 v40, v92, v57
v_mul_f32_e32 v57, v53, v60
v_cvt_f32_i32_e32 v59, v90
v_fmac_f32_e32 v33, v58, v57
v_cvt_f32_i32_e32 v58, v89
v_mul_f32_e32 v57, v54, v60
v_fmac_f32_e32 v34, v59, v57
v_mul_f32_e32 v57, v55, v60
v_cvt_f32_i32_e32 v59, v88
v_fmac_f32_e32 v35, v58, v57
v_cvt_f32_i32_e32 v58, v87
v_mul_f32_e32 v57, v56, v60
v_fmac_f32_e32 v36, v59, v57
v_mul_f32_e32 v57, v53, v49
v_cvt_f32_i32_e32 v59, v86
v_fmac_f32_e32 v29, v58, v57
v_cvt_f32_i32_e32 v58, v85
v_mul_f32_e32 v57, v54, v49
v_fmac_f32_e32 v30, v59, v57
v_mul_f32_e32 v57, v55, v49
v_cvt_f32_i32_e32 v59, v84
v_fmac_f32_e32 v31, v58, v57
v_cvt_f32_i32_e32 v57, v83
v_mul_f32_e32 v49, v56, v49
v_fmac_f32_e32 v32, v59, v49
v_mul_f32_e32 v49, v53, v50
v_cvt_f32_i32_e32 v58, v82
v_fmac_f32_e32 v25, v57, v49
v_cvt_f32_i32_e32 v57, v81
v_mul_f32_e32 v49, v54, v50
v_fmac_f32_e32 v26, v58, v49
v_mul_f32_e32 v49, v55, v50
v_cvt_f32_i32_e32 v58, v80
v_fmac_f32_e32 v27, v57, v49
v_mul_f32_e32 v49, v56, v50
v_cvt_f32_i32_e32 v50, v79
v_fmac_f32_e32 v28, v58, v49
v_mul_f32_e32 v49, v53, v51
v_cvt_f32_i32_e32 v57, v78
v_fmac_f32_e32 v21, v50, v49
v_cvt_f32_i32_e32 v50, v77
v_mul_f32_e32 v49, v54, v51
v_fmac_f32_e32 v22, v57, v49
v_mul_f32_e32 v49, v55, v51
v_cvt_f32_i32_e32 v57, v76
v_fmac_f32_e32 v23, v50, v49
v_cvt_f32_i32_e32 v50, v75
v_mul_f32_e32 v49, v56, v51
v_cvt_f32_i32_e32 v51, v74
v_fmac_f32_e32 v24, v57, v49
v_mul_f32_e32 v49, v53, v52
v_fmac_f32_e32 v13, v50, v49
v_mul_f32_e32 v49, v54, v52
v_cvt_f32_i32_e32 v50, v73
v_cvt_f32_i32_e32 v103, v103
v_cvt_f32_i32_e32 v101, v101
v_fmac_f32_e32 v14, v51, v49
v_cvt_f32_i32_e32 v49, v72
v_mul_f32_e32 v51, v55, v52
s_add_u32 s18, s18, 64
v_fmac_f32_e32 v15, v50, v51
v_mul_f32_e32 v50, v56, v52
s_addc_u32 s19, s19, 0
v_fmac_f32_e32 v45, v103, v104
v_fmac_f32_e32 v47, v101, v102
v_fmac_f32_e32 v16, v49, v50
s_cmp_eq_u32 s33, s20
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 24
s_mov_b64 s[24:25], s[20:21]
s_branch 64136
s_and_saveexec_b64 s[26:27], s[2:3]
s_xor_b64 s[26:27], exec, s[26:27]
s_lshl_b32 s29, s28, 8
v_lshl_add_u32 v104, v71, 2, s29
s_mov_b64 s[22:23], exec
v_add_u32_e32 v104, 0x6800, v104
s_or_b64 exec, exec, s[26:27]
s_and_b64 s[22:23], s[22:23], exec
s_andn2_saveexec_b64 s[24:25], s[24:25]
s_cbranch_execz 65375
s_lshl_b32 s26, s28, 9
v_lshl_add_u32 v104, v68, 2, s26
v_add_u32_e32 v104, 0x6400, v104
s_or_b64 s[22:23], s[22:23], exec
s_or_b64 exec, exec, s[24:25]
s_and_saveexec_b64 s[24:25], s[22:23]
s_cbranch_execnz 65369
s_branch 65371
v_add_u32_e32 v6, s30, v0
v_or_b32_e32 v0, s31, v70
v_ashrrev_i32_e32 v1, 31, v0
v_mad_i64_i32 v[2:3], s[0:1], s17, v6, v[0:1]
v_or_b32_e32 v4, 1, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_lshlrev_b64 v[2:3], 2, v[2:3]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v7, s5
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[45:48], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 2, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[41:44], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 3, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[37:40], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 4, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[33:36], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 5, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[29:32], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 6, v6
v_mad_i64_i32 v[4:5], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
global_store_dwordx4 v[2:3], v[25:28], off
v_lshlrev_b64 v[2:3], 2, v[4:5]
v_or_b32_e32 v4, 7, v6
v_mad_i64_i32 v[0:1], s[0:1], s17, v4, v[0:1]
v_add_co_u32_e32 v2, vcc, s4, v2
v_lshlrev_b64 v[0:1], 2, v[0:1]
v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
v_add_co_u32_e32 v0, vcc, s4, v0
v_addc_co_u32_e32 v1, vcc, v7, v1, vcc
global_store_dwordx4 v[2:3], v[21:24], off
global_store_dwordx4 v[0:1], v[13:16], off
s_endpgm
