.text
k__Z7fa_int4PKjPKfS0_S2_S0_S2_Pfiiiiii:
s_load_dwordx2 s[28:29], s[4:5], 0x48
s_load_dwordx4 s[16:19], s[4:5], 0x38
s_mov_b64 s[38:39], s[2:3]
s_mov_b64 s[36:37], s[0:1]
s_add_u32 s36, s36, s8
s_addc_u32 s37, s37, 0
s_waitcnt lgkmcnt(0)
s_ashr_i32 s31, s28, 31
s_add_i32 s0, s28, s31
s_xor_b32 s30, s0, s31
v_cvt_f32_u32_e32 v1, s30
s_lshl_b32 s28, s6, 6
s_cmp_ge_i32 s28, s16
v_rcp_iflag_f32_e32 v1, v1
v_mul_f32_e32 v1, 0x4f7ffffe, v1
v_cvt_u32_f32_e32 v1, v1
v_readfirstlane_b32 s0, v1
s_cbranch_scc1 7214
s_load_dwordx8 s[8:15], s[4:5], 0x0
s_load_dwordx4 s[20:23], s[4:5], 0x20
s_load_dwordx2 s[24:25], s[4:5], 0x30
s_ashr_i32 s4, s7, 31
s_add_i32 s1, s7, s4
s_xor_b32 s5, s1, s4
s_sub_i32 s1, 0, s30
s_mul_i32 s1, s1, s0
s_mul_hi_u32 s1, s0, s1
s_add_i32 s0, s0, s1
s_mul_hi_i32 s27, s16, s7
s_mul_i32 s26, s16, s7
v_and_b32_e32 v33, 63, v0
s_mul_hi_u32 s6, s5, s0
s_lshl_b64 s[0:1], s[26:27], 8
v_mul_u32_u24_e32 v1, 0x110, v33
v_lshrrev_b32_e32 v35, 6, v0
s_waitcnt lgkmcnt(0)
s_add_u32 s2, s8, s0
v_lshl_or_b32 v1, v35, 2, v1
s_addc_u32 s3, s9, s1
v_mov_b32_e32 v34, 0
v_or_b32_e32 v3, 0xffffff00, v0
v_add_u32_e32 v4, 0x4400, v1
v_add_u32_e32 v1, s28, v35
s_mov_b64 s[0:1], 0
s_movk_i32 s8, 0xeff
v_ashrrev_i32_e32 v2, 31, v1
v_lshlrev_b64 v[5:6], 8, v[1:2]
v_mov_b32_e32 v7, s3
v_lshl_or_b32 v2, v33, 2, v5
v_add_co_u32_e32 v5, vcc, s2, v2
v_addc_co_u32_e32 v6, vcc, v7, v6, vcc
global_load_dword v2, v[5:6], off
v_add_u32_e32 v3, 0x100, v3
v_cmp_lt_u32_e32 vcc, s8, v3
v_add_u32_e32 v1, 4, v1
s_or_b64 s[0:1], vcc, s[0:1]
s_waitcnt vmcnt(0)
ds_write_b32 v4, v2
v_add_u32_e32 v4, 16, v4
s_andn2_b64 exec, exec, s[0:1]
s_cbranch_execnz 65515
s_or_b64 exec, exec, s[0:1]
s_movk_i32 s0, 0x80
v_cmp_gt_u32_e64 s[0:1], s0, v0
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 26
s_mul_hi_i32 s9, s7, s16
s_mul_i32 s8, s7, s16
s_lshl_b64 s[8:9], s[8:9], 3
s_add_u32 s7, s10, s8
s_addc_u32 s10, s11, s9
s_ashr_i32 s8, s28, 31
v_lshrrev_b32_e32 v4, 1, v0
v_mov_b32_e32 v2, s8
v_add_co_u32_e32 v1, vcc, s28, v4
v_and_b32_e32 v3, 1, v0
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_mad_i64_i32 v[1:2], s[8:9], v3, s16, v[1:2]
v_mov_b32_e32 v5, s10
v_lshlrev_b64 v[1:2], 2, v[1:2]
v_add_co_u32_e32 v1, vcc, s7, v1
v_addc_co_u32_e32 v2, vcc, v5, v2, vcc
global_load_dword v1, v[1:2], off
v_lshlrev_b32_e32 v2, 2, v4
v_lshl_add_u32 v2, v3, 8, v2
s_waitcnt vmcnt(0)
ds_write_b32 v2, v1 offset:57344
s_or_b64 exec, exec, s[2:3]
v_cmp_gt_u32_e32 vcc, 64, v0
v_lshlrev_b32_e32 v38, 2, v0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 8
v_mov_b32_e32 v1, 0xf149f2ca
v_mov_b32_e32 v3, 1.0
v_mov_b32_e32 v2, 0
ds_write2st64_b32 v38, v1, v3 offset0:228 offset1:229
ds_write2st64_b32 v38, v2, v2 offset0:226 offset1:227
s_or_b64 exec, exec, s[2:3]
s_mul_i32 s3, s6, s30
s_sub_i32 s3, s5, s3
s_xor_b32 s2, s4, s31
s_add_i32 s4, s6, 1
s_sub_i32 s5, s3, s30
s_cmp_ge_u32 s3, s30
s_cselect_b32 s4, s4, s6
s_cselect_b32 s3, s5, s3
s_add_i32 s5, s4, 1
s_cmp_ge_u32 s3, s30
s_cselect_b32 s3, s5, s4
s_xor_b32 s3, s3, s2
s_sub_i32 s10, s3, s2
s_mul_hi_i32 s3, s29, s10
s_mul_i32 s2, s29, s10
s_lshl_b64 s[2:3], s[2:3], 8
s_add_u32 s6, s12, s2
v_lshrrev_b32_e32 v146, 4, v0
v_and_b32_e32 v36, 60, v38
s_addc_u32 s7, s13, s3
v_cmp_gt_i32_e32 vcc, s17, v146
v_mov_b32_e32 v4, 0
v_lshlrev_b32_e32 v9, 2, v36
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v5, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 8
v_lshlrev_b32_e32 v1, 8, v146
v_mov_b32_e32 v2, s7
v_add_co_u32_e32 v1, vcc, s6, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_add_co_u32_e32 v1, vcc, v1, v9
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dwordx4 v[5:8], v[1:2], off
s_or_b64 exec, exec, s[2:3]
v_or_b32_e32 v40, 16, v146
v_cmp_gt_i32_e32 vcc, s17, v40
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v1, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 8
v_lshlrev_b32_e32 v1, 8, v40
v_mov_b32_e32 v2, s7
v_add_co_u32_e32 v1, vcc, s6, v1
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
v_add_co_u32_e32 v1, vcc, v1, v9
v_addc_co_u32_e32 v2, vcc, 0, v2, vcc
global_load_dwordx4 v[1:4], v[1:2], off
s_or_b64 exec, exec, s[2:3]
v_or_b32_e32 v42, 32, v146
v_cmp_gt_i32_e32 vcc, s17, v42
v_mov_b32_e32 v12, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v13, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
v_lshlrev_b32_e32 v9, 8, v42
v_mov_b32_e32 v10, s7
v_add_co_u32_e32 v9, vcc, s6, v9
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_lshlrev_b32_e32 v11, 2, v36
v_add_co_u32_e32 v9, vcc, v9, v11
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
global_load_dwordx4 v[13:16], v[9:10], off
s_or_b64 exec, exec, s[2:3]
v_or_b32_e32 v43, 48, v146
v_cmp_gt_i32_e32 vcc, s17, v43
v_mov_b32_e32 v11, 0
v_mov_b32_e32 v10, 0
v_mov_b32_e32 v9, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 9
v_lshlrev_b32_e32 v9, 8, v43
v_mov_b32_e32 v10, s7
v_add_co_u32_e32 v9, vcc, s6, v9
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
v_lshlrev_b32_e32 v11, 2, v36
v_add_co_u32_e32 v9, vcc, v9, v11
v_addc_co_u32_e32 v10, vcc, 0, v10, vcc
global_load_dwordx4 v[9:12], v[9:10], off
s_or_b64 exec, exec, s[2:3]
s_ashr_i32 s11, s29, 31
s_lshr_b32 s2, s11, 30
s_add_i32 s2, s29, s2
s_ashr_i32 s2, s2, 2
v_lshrrev_b32_e32 v37, 5, v0
v_lshlrev_b32_e32 v17, 3, v0
s_mul_hi_i32 s3, s2, s10
s_mul_i32 s2, s2, s10
v_and_b32_e32 v39, 0xf8, v17
s_lshl_b64 s[2:3], s[2:3], 10
v_lshlrev_b32_e32 v17, 2, v37
s_add_u32 s12, s20, s2
v_add_co_u32_e32 v17, vcc, 4, v17
s_addc_u32 s13, s21, s3
v_addc_co_u32_e64 v18, s[2:3], 0, 0, vcc
s_ashr_i32 s9, s17, 31
s_mov_b32 s8, s17
v_cmp_ge_u64_e32 vcc, s[8:9], v[17:18]
v_mov_b32_e32 v19, 0
v_lshlrev_b32_e32 v41, 2, v39
v_mov_b32_e32 v28, 0
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v21, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 10
v_lshlrev_b32_e32 v17, 10, v37
v_mov_b32_e32 v18, s13
v_add_co_u32_e32 v17, vcc, s12, v17
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
v_add_co_u32_e32 v17, vcc, v17, v41
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
global_load_dwordx4 v[21:24], v[17:18], off
global_load_dwordx4 v[25:28], v[17:18], off offset:16
s_or_b64 exec, exec, s[2:3]
v_or_b32_e32 v44, 8, v37
v_lshlrev_b32_e32 v17, 2, v44
v_add_co_u32_e32 v17, vcc, 4, v17
v_addc_co_u32_e64 v18, s[2:3], 0, 0, vcc
v_cmp_ge_u64_e32 vcc, s[8:9], v[17:18]
s_mov_b32 s21, s29
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v30, 0
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v20, 0
s_and_saveexec_b64 s[2:3], vcc
s_cbranch_execz 10
v_lshlrev_b32_e32 v17, 10, v44
v_mov_b32_e32 v18, s13
v_add_co_u32_e32 v17, vcc, s12, v17
v_addc_co_u32_e32 v18, vcc, 0, v18, vcc
v_add_co_u32_e32 v44, vcc, v17, v41
v_addc_co_u32_e32 v45, vcc, 0, v18, vcc
global_load_dwordx4 v[29:32], v[44:45], off
global_load_dwordx4 v[17:20], v[44:45], off offset:16
s_or_b64 exec, exec, s[2:3]
v_bfe_u32 v41, v0, 4, 3
v_and_b32_e32 v44, 4, v37
v_add_u32_e32 v44, v44, v41
s_mul_hi_i32 s3, s21, s10
s_mul_i32 s2, s21, s10
v_add_u32_e32 v45, 28, v44
v_cmp_gt_u32_e32 vcc, 4, v41
s_lshl_b64 s[2:3], s[2:3], 3
v_cndmask_b32_e32 v44, v45, v44, vcc
s_add_u32 s14, s14, s2
v_lshlrev_b32_e32 v44, 2, v44
s_movk_i32 s2, 0x110
v_mad_u32_u24 v44, v36, s2, v44
v_lshrrev_b32_e32 v40, 1, v40
s_waitcnt vmcnt(0)
ds_write2_b32 v44, v5, v6 offset1:68
buffer_store_dword v44, off, s[36:39], 0 offset:36
ds_write2_b32 v44, v7, v8 offset0:136 offset1:204
v_and_b32_e32 v44, 12, v40
v_add_u32_e32 v44, v44, v41
v_add_u32_e32 v45, 28, v44
v_cndmask_b32_e32 v44, v45, v44, vcc
v_lshlrev_b32_e32 v44, 2, v44
v_mad_u32_u24 v44, v36, s2, v44
v_lshrrev_b32_e32 v42, 1, v42
ds_write2_b32 v44, v1, v2 offset1:68
ds_write2_b32 v44, v3, v4 offset0:136 offset1:204
v_and_b32_e32 v44, 28, v42
v_add_u32_e32 v44, v44, v41
v_add_u32_e32 v45, 28, v44
v_cndmask_b32_e32 v44, v45, v44, vcc
v_lshlrev_b32_e32 v44, 2, v44
v_mad_u32_u24 v44, v36, s2, v44
v_lshrrev_b32_e32 v43, 1, v43
ds_write2_b32 v44, v13, v14 offset1:68
ds_write2_b32 v44, v15, v16 offset0:136 offset1:204
v_and_b32_e32 v44, 28, v43
v_add_u32_e32 v44, v44, v41
v_add_u32_e32 v45, 28, v44
v_cndmask_b32_e32 v44, v45, v44, vcc
v_lshlrev_b32_e32 v44, 2, v44
v_and_b32_e32 v38, 0x7c, v38
v_mad_u32_u24 v44, v36, s2, v44
v_lshlrev_b32_e32 v38, 2, v38
s_movk_i32 s2, 0x410
s_addc_u32 s15, s15, s3
ds_write2_b32 v44, v9, v10 offset1:68
ds_write2_b32 v44, v11, v12 offset0:136 offset1:204
v_mad_u32_u24 v38, v37, s2, v38
v_lshlrev_b32_e32 v44, 2, v33
ds_write_b128 v38, v[21:24] offset:34816
ds_write_b128 v38, v[25:28] offset:35328
ds_write_b128 v38, v[29:32] offset:43136
ds_write_b128 v38, v[17:20] offset:43648
s_and_saveexec_b64 s[4:5], s[0:1]
s_cbranch_execz 16
v_mad_i64_i32 v[45:46], s[2:3], s21, v35, v[33:34]
v_mov_b32_e32 v47, s15
v_lshl_or_b32 v44, v35, 8, v44
v_lshlrev_b64 v[45:46], 2, v[45:46]
v_add_co_u32_e64 v45, s[2:3], s14, v45
v_addc_co_u32_e64 v46, s[2:3], v47, v46, s[2:3]
global_load_dword v45, v[45:46], off
s_waitcnt vmcnt(0)
ds_write_b32 v44, v45 offset:56832
s_or_b64 exec, exec, s[4:5]
s_lshr_b32 s2, s11, 26
s_add_i32 s2, s29, s2
s_ashr_i32 s4, s2, 6
s_movk_i32 s2, 0x100
v_cmp_gt_u32_e64 s[2:3], s2, v0
s_mul_hi_i32 s11, s4, s10
s_mul_i32 s10, s4, s10
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 9
s_lshl_b64 s[30:31], s[10:11], 10
s_add_u32 s30, s22, s30
s_addc_u32 s31, s23, s31
v_lshlrev_b32_e32 v44, 2, v0
global_load_dword v45, v44, s[30:31]
s_waitcnt vmcnt(0)
ds_write_b32 v44, v45 offset:55808
s_or_b64 exec, exec, s[4:5]
v_lshrrev_b32_e32 v48, 2, v0
v_and_b32_e32 v45, 31, v0
v_and_b32_e32 v46, 56, v48
v_lshlrev_b32_e32 v47, 3, v45
s_mov_b32 s20, 0
s_cmp_lt_i32 s19, 1
v_mov_b32_e32 v130, 0
v_lshlrev_b32_e32 v44, 2, v46
v_mov_b32_e32 v131, 0
v_mov_b32_e32 v129, 0
v_mov_b32_e32 v128, 0
v_mov_b32_e32 v127, 0
v_mov_b32_e32 v126, 0
v_mov_b32_e32 v125, 0
v_mov_b32_e32 v124, 0
v_mov_b32_e32 v123, 0
v_mov_b32_e32 v122, 0
v_mov_b32_e32 v121, 0
v_mov_b32_e32 v120, 0
v_mov_b32_e32 v119, 0
v_mov_b32_e32 v118, 0
v_mov_b32_e32 v117, 0
v_mov_b32_e32 v116, 0
v_mov_b32_e32 v114, 0
v_mov_b32_e32 v113, 0
v_mov_b32_e32 v112, 0
v_mov_b32_e32 v111, 0
v_mov_b32_e32 v110, 0
v_mov_b32_e32 v109, 0
v_mov_b32_e32 v108, 0
v_mov_b32_e32 v107, 0
v_mov_b32_e32 v106, 0
v_mov_b32_e32 v105, 0
v_mov_b32_e32 v104, 0
v_mov_b32_e32 v103, 0
v_mov_b32_e32 v102, 0
v_mov_b32_e32 v101, 0
v_mov_b32_e32 v100, 0
v_mov_b32_e32 v99, 0
v_mov_b32_e32 v98, 0
v_mov_b32_e32 v97, 0
v_mov_b32_e32 v96, 0
v_mov_b32_e32 v95, 0
v_mov_b32_e32 v94, 0
v_mov_b32_e32 v93, 0
v_mov_b32_e32 v92, 0
v_mov_b32_e32 v91, 0
v_mov_b32_e32 v90, 0
v_mov_b32_e32 v89, 0
v_mov_b32_e32 v88, 0
v_mov_b32_e32 v87, 0
v_mov_b32_e32 v86, 0
v_mov_b32_e32 v85, 0
v_mov_b32_e32 v84, 0
v_mov_b32_e32 v83, 0
v_mov_b32_e32 v82, 0
v_mov_b32_e32 v81, 0
v_mov_b32_e32 v80, 0
v_mov_b32_e32 v79, 0
v_mov_b32_e32 v78, 0
v_mov_b32_e32 v77, 0
v_mov_b32_e32 v76, 0
v_mov_b32_e32 v75, 0
v_mov_b32_e32 v74, 0
v_mov_b32_e32 v73, 0
v_mov_b32_e32 v71, 0
v_mov_b32_e32 v70, 0
v_mov_b32_e32 v69, 0
v_mov_b32_e32 v68, 0
v_mov_b32_e32 v67, 0
v_mov_b32_e32 v66, 0
s_waitcnt vmcnt(0) lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 6363
v_mad_i64_i32 v[49:50], s[30:31], s21, v35, v[33:34]
v_lshlrev_b32_e32 v33, 2, v33
v_lshl_or_b32 v33, v35, 8, v33
v_add_u32_e32 v38, 0x8800, v38
v_add_u32_e32 v33, 0xde00, v33
buffer_store_dword v46, off, s[36:39], 0 offset:112
buffer_store_dword v38, off, s[36:39], 0 offset:40
v_and_b32_e32 v46, 7, v0
buffer_store_dword v49, off, s[36:39], 0 offset:88
buffer_store_dword v50, off, s[36:39], 0 offset:92
buffer_store_dword v33, off, s[36:39], 0 offset:96
v_mov_b32_e32 v33, 0x8800
v_lshlrev_b32_e32 v0, 2, v0
v_lshl_or_b32 v136, v45, 4, v33
v_add_u32_e32 v33, 0xda00, v0
buffer_store_dword v33, off, s[36:39], 0 offset:100
v_lshlrev_b32_e32 v33, 2, v36
v_mov_b32_e32 v34, s7
v_add_co_u32_e64 v138, s[6:7], s6, v33
v_addc_co_u32_e64 v139, s[6:7], 0, v34, s[6:7]
v_lshlrev_b32_e32 v33, 2, v39
v_mov_b32_e32 v34, s13
v_add_co_u32_e64 v33, s[6:7], s12, v33
v_and_b32_e32 v38, 62, v48
buffer_store_dword v33, off, s[36:39], 0 offset:80
v_addc_co_u32_e64 v33, s[6:7], 0, v34, s[6:7]
s_add_i32 s4, s18, s28
buffer_store_dword v33, off, s[36:39], 0 offset:84
v_lshlrev_b32_e32 v33, 2, v38
v_add_u32_e32 v134, s4, v38
v_or_b32_e32 v34, 0xe000, v33
v_mov_b32_e32 v38, 0xde00
buffer_store_dword v34, off, s[36:39], 0 offset:4
buffer_store_dword v48, off, s[36:39], 0 offset:108
v_lshlrev_b32_e32 v34, 2, v48
v_lshl_or_b32 v144, v46, 5, v38
v_or_b32_e32 v38, 0xe400, v33
buffer_store_dword v38, off, s[36:39], 0 offset:28
v_or_b32_e32 v38, 0xe404, v34
v_or_b32_e32 v35, 0xe004, v34
buffer_store_dword v38, off, s[36:39], 0 offset:32
s_movk_i32 s6, 0x220
v_mov_b32_e32 v38, 0xc900
buffer_store_dword v35, off, s[36:39], 0 offset:8
v_or_b32_e32 v35, 4, v34
v_mad_u32_u24 v38, v46, s6, v38
v_add_u32_e32 v35, v38, v35
buffer_store_dword v35, off, s[36:39], 0 offset:16
v_or_b32_e32 v35, 0xe500, v33
v_or_b32_e32 v151, 0x4400, v33
v_add_u32_e32 v39, v38, v33
buffer_store_dword v35, off, s[36:39], 0 offset:44
v_or_b32_e32 v35, 0xe300, v33
v_or_b32_e32 v33, 0xe200, v33
buffer_store_dword v33, off, s[36:39], 0 offset:52
v_or_b32_e32 v33, 0xe504, v34
buffer_store_dword v33, off, s[36:39], 0 offset:56
v_or_b32_e32 v33, 0xe304, v34
buffer_store_dword v33, off, s[36:39], 0 offset:60
v_or_b32_e32 v33, 0xe204, v34
buffer_store_dword v33, off, s[36:39], 0 offset:64
v_and_b32_e32 v33, 12, v40
v_add_u32_e32 v33, v33, v41
buffer_store_dword v35, off, s[36:39], 0 offset:48
v_add_u32_e32 v35, 28, v33
v_cndmask_b32_e32 v33, v35, v33, vcc
v_lshlrev_b32_e32 v33, 2, v33
s_movk_i32 s6, 0x110
v_mad_u32_u24 v33, v36, s6, v33
buffer_store_dword v33, off, s[36:39], 0 offset:68
v_and_b32_e32 v33, 28, v42
v_add_u32_e32 v33, v33, v41
v_add_u32_e32 v35, 28, v33
v_cndmask_b32_e32 v33, v35, v33, vcc
v_lshlrev_b32_e32 v33, 2, v33
v_mad_u32_u24 v33, v36, s6, v33
buffer_store_dword v33, off, s[36:39], 0 offset:72
v_and_b32_e32 v33, 28, v43
v_add_u32_e32 v33, v33, v41
v_add_u32_e32 v35, 28, v33
v_cndmask_b32_e32 v33, v35, v33, vcc
v_lshlrev_b32_e32 v33, 2, v33
v_mad_u32_u24 v33, v36, s6, v33
s_lshl_b64 s[6:7], s[10:11], 10
buffer_store_dword v33, off, s[36:39], 0 offset:76
v_or_b32_e32 v33, 0xe51c, v34
s_add_u32 s6, s22, s6
buffer_store_dword v33, off, s[36:39], 0 offset:20
v_or_b32_e32 v33, 0xe31c, v34
s_addc_u32 s7, s23, s7
buffer_store_dword v33, off, s[36:39], 0 offset:24
v_mov_b32_e32 v33, s7
v_add_co_u32_e32 v0, vcc, s6, v0
v_addc_co_u32_e32 v33, vcc, 0, v33, vcc
s_movk_i32 s6, 0x400
v_lshlrev_b32_e32 v133, 3, v46
s_mov_b32 s18, 0xda00
v_add_co_u32_e32 v59, vcc, s6, v0
v_mbcnt_lo_u32_b32 v0, -1, 0
v_cmp_eq_u32_e64 s[4:5], 0, v46
v_or_b32_e32 v147, 4, v133
v_or_b32_e32 v148, 5, v133
v_or_b32_e32 v149, 6, v133
v_or_b32_e32 v150, 7, v133
v_lshlrev_b32_e32 v152, 4, v46
v_or_b32_e32 v166, 0xe500, v44
v_or_b32_e32 v168, 0xe300, v44
v_or_b32_e32 v170, 0xc900, v44
v_lshl_add_u32 v171, v47, 2, s18
v_or_b32_e32 v57, 24, v37
v_addc_co_u32_e32 v60, vcc, 0, v33, vcc
v_mov_b32_e32 v172, 0
v_mov_b32_e32 v62, 0
s_mov_b32 s18, 0xefa18f08
s_mov_b32 s21, 0xc2fc0000
s_mov_b32 s22, 0x42fe0000
s_movk_i32 s23, 0x7f
v_mov_b32_e32 v173, 0xf149f2ca
v_mbcnt_hi_u32_b32 v174, -1, v0
v_mov_b32_e32 v175, 0x1f800000
v_mov_b32_e32 v176, 0x42800000
v_mov_b32_e32 v177, 0x7f
v_mov_b32_e32 v66, 0
v_mov_b32_e32 v67, 0
v_mov_b32_e32 v68, 0
v_mov_b32_e32 v69, 0
v_mov_b32_e32 v70, 0
v_mov_b32_e32 v71, 0
v_mov_b32_e32 v73, 0
v_mov_b32_e32 v74, 0
v_mov_b32_e32 v75, 0
v_mov_b32_e32 v76, 0
v_mov_b32_e32 v77, 0
v_mov_b32_e32 v78, 0
v_mov_b32_e32 v79, 0
v_mov_b32_e32 v80, 0
v_mov_b32_e32 v81, 0
v_mov_b32_e32 v82, 0
v_mov_b32_e32 v83, 0
v_mov_b32_e32 v84, 0
v_mov_b32_e32 v85, 0
v_mov_b32_e32 v86, 0
v_mov_b32_e32 v87, 0
v_mov_b32_e32 v88, 0
v_mov_b32_e32 v89, 0
v_mov_b32_e32 v90, 0
v_mov_b32_e32 v91, 0
v_mov_b32_e32 v92, 0
v_mov_b32_e32 v93, 0
v_mov_b32_e32 v94, 0
v_mov_b32_e32 v95, 0
v_mov_b32_e32 v96, 0
v_mov_b32_e32 v97, 0
v_mov_b32_e32 v98, 0
v_mov_b32_e32 v99, 0
v_mov_b32_e32 v100, 0
v_mov_b32_e32 v101, 0
v_mov_b32_e32 v102, 0
v_mov_b32_e32 v103, 0
v_mov_b32_e32 v104, 0
v_mov_b32_e32 v105, 0
v_mov_b32_e32 v106, 0
v_mov_b32_e32 v107, 0
v_mov_b32_e32 v108, 0
v_mov_b32_e32 v109, 0
v_mov_b32_e32 v110, 0
v_mov_b32_e32 v111, 0
v_mov_b32_e32 v112, 0
v_mov_b32_e32 v113, 0
v_mov_b32_e32 v114, 0
v_mov_b32_e32 v116, 0
v_mov_b32_e32 v117, 0
v_mov_b32_e32 v118, 0
v_mov_b32_e32 v119, 0
v_mov_b32_e32 v120, 0
v_mov_b32_e32 v121, 0
v_mov_b32_e32 v122, 0
v_mov_b32_e32 v123, 0
v_mov_b32_e32 v124, 0
v_mov_b32_e32 v125, 0
v_mov_b32_e32 v126, 0
v_mov_b32_e32 v127, 0
v_mov_b32_e32 v128, 0
v_mov_b32_e32 v129, 0
v_mov_b32_e32 v131, 0
v_mov_b32_e32 v130, 0
s_mov_b32 s29, 0
buffer_store_dword v39, off, s[36:39], 0 offset:12
buffer_store_dword v47, off, s[36:39], 0 offset:104
s_branch 265
s_or_b64 exec, exec, s[6:7]
v_mul_f32_e32 v130, v130, v37
v_mul_f32_e32 v131, v131, v37
v_mul_f32_e32 v129, v129, v37
v_mul_f32_e32 v128, v128, v37
v_mul_f32_e32 v127, v127, v37
v_mul_f32_e32 v126, v126, v37
v_mul_f32_e32 v125, v125, v37
v_mul_f32_e32 v124, v124, v37
v_cvt_f32_i32_e32 v37, v240
v_mul_f32_e32 v123, v123, v38
v_mul_f32_e32 v122, v122, v38
v_mul_f32_e32 v121, v121, v38
v_mul_f32_e32 v120, v120, v38
v_mul_f32_e32 v119, v119, v38
v_mul_f32_e32 v118, v118, v38
v_mul_f32_e32 v117, v117, v38
v_mul_f32_e32 v116, v116, v38
v_mul_f32_e32 v114, v114, v39
v_mul_f32_e32 v113, v113, v39
v_mul_f32_e32 v112, v112, v39
v_mul_f32_e32 v111, v111, v39
v_mul_f32_e32 v110, v110, v39
v_mul_f32_e32 v109, v109, v39
v_mul_f32_e32 v108, v108, v39
v_mul_f32_e32 v107, v107, v39
v_mul_f32_e32 v38, v33, v45
v_cvt_f32_i32_e32 v39, v239
v_fmac_f32_e32 v130, v37, v38
v_cvt_f32_i32_e32 v38, v238
v_mul_f32_e32 v37, v33, v46
v_fmac_f32_e32 v131, v39, v37
v_mul_f32_e32 v37, v33, v47
v_cvt_f32_i32_e32 v39, v237
v_fmac_f32_e32 v129, v38, v37
v_cvt_f32_i32_e32 v38, v236
v_mul_f32_e32 v37, v33, v48
v_fmac_f32_e32 v128, v39, v37
v_mul_f32_e32 v37, v33, v41
v_cvt_f32_i32_e32 v39, v235
v_fmac_f32_e32 v127, v38, v37
v_cvt_f32_i32_e32 v38, v234
v_mul_f32_e32 v37, v33, v42
v_fmac_f32_e32 v126, v39, v37
v_mul_f32_e32 v37, v33, v43
v_cvt_f32_i32_e32 v39, v233
v_fmac_f32_e32 v125, v38, v37
v_cvt_f32_i32_e32 v37, v232
v_mul_f32_e32 v33, v33, v44
v_fmac_f32_e32 v124, v39, v33
v_mul_f32_e32 v33, v34, v45
v_cvt_f32_i32_e32 v38, v231
v_fmac_f32_e32 v123, v37, v33
v_cvt_f32_i32_e32 v37, v230
v_mul_f32_e32 v33, v34, v46
v_fmac_f32_e32 v122, v38, v33
v_mul_f32_e32 v33, v34, v47
v_cvt_f32_i32_e32 v38, v229
v_fmac_f32_e32 v121, v37, v33
v_cvt_f32_i32_e32 v37, v228
v_mul_f32_e32 v33, v34, v48
v_fmac_f32_e32 v120, v38, v33
v_mul_f32_e32 v33, v34, v41
v_cvt_f32_i32_e32 v38, v227
v_fmac_f32_e32 v119, v37, v33
v_cvt_f32_i32_e32 v37, v226
v_mul_f32_e32 v33, v34, v42
v_fmac_f32_e32 v118, v38, v33
v_mul_f32_e32 v33, v34, v43
v_cvt_f32_i32_e32 v38, v225
v_fmac_f32_e32 v117, v37, v33
v_mul_f32_e32 v33, v34, v44
v_cvt_f32_i32_e32 v34, v224
v_fmac_f32_e32 v116, v38, v33
v_mul_f32_e32 v33, v35, v45
v_cvt_f32_i32_e32 v37, v223
v_fmac_f32_e32 v114, v34, v33
v_cvt_f32_i32_e32 v34, v222
v_mul_f32_e32 v33, v35, v46
v_fmac_f32_e32 v113, v37, v33
v_mul_f32_e32 v33, v35, v47
v_cvt_f32_i32_e32 v37, v221
v_fmac_f32_e32 v112, v34, v33
v_cvt_f32_i32_e32 v34, v220
v_mul_f32_e32 v33, v35, v48
v_fmac_f32_e32 v111, v37, v33
v_mul_f32_e32 v33, v35, v41
v_cvt_f32_i32_e32 v37, v219
v_fmac_f32_e32 v110, v34, v33
v_cvt_f32_i32_e32 v34, v218
v_mul_f32_e32 v33, v35, v42
v_fmac_f32_e32 v109, v37, v33
v_mul_f32_e32 v33, v35, v43
v_cvt_f32_i32_e32 v37, v217
v_fmac_f32_e32 v108, v34, v33
v_cvt_f32_i32_e32 v34, v216
v_mul_f32_e32 v33, v35, v44
v_cvt_f32_i32_e32 v35, v215
v_mul_f32_e32 v106, v106, v40
v_fmac_f32_e32 v107, v37, v33
v_mul_f32_e32 v33, v36, v45
v_mul_f32_e32 v105, v105, v40
v_fmac_f32_e32 v106, v34, v33
v_mul_f32_e32 v33, v36, v46
v_cvt_f32_i32_e32 v34, v214
v_fmac_f32_e32 v105, v35, v33
v_cvt_f32_i32_e32 v35, v213
v_mul_f32_e32 v104, v104, v40
v_mul_f32_e32 v33, v36, v47
v_mul_f32_e32 v103, v103, v40
v_fmac_f32_e32 v104, v34, v33
v_mul_f32_e32 v33, v36, v48
v_cvt_f32_i32_e32 v34, v212
v_fmac_f32_e32 v103, v35, v33
v_cvt_f32_i32_e32 v35, v211
v_mul_f32_e32 v102, v102, v40
v_mul_f32_e32 v33, v36, v41
v_mul_f32_e32 v101, v101, v40
v_fmac_f32_e32 v102, v34, v33
v_mul_f32_e32 v33, v36, v42
v_cvt_f32_i32_e32 v34, v210
v_fmac_f32_e32 v101, v35, v33
v_cvt_f32_i32_e32 v35, v209
v_mul_f32_e32 v100, v100, v40
v_mul_f32_e32 v33, v36, v43
v_mul_f32_e32 v99, v99, v40
v_fmac_f32_e32 v100, v34, v33
v_mul_f32_e32 v33, v36, v44
v_cvt_f32_i32_e32 v34, v208
v_fmac_f32_e32 v99, v35, v33
v_cvt_f32_i32_e32 v35, v207
v_mul_f32_e32 v98, v98, v52
v_mul_f32_e32 v33, v49, v45
v_mul_f32_e32 v97, v97, v52
v_fmac_f32_e32 v98, v34, v33
v_mul_f32_e32 v33, v49, v46
v_cvt_f32_i32_e32 v34, v206
v_fmac_f32_e32 v97, v35, v33
v_cvt_f32_i32_e32 v35, v205
v_mul_f32_e32 v96, v96, v52
v_mul_f32_e32 v33, v49, v47
v_mul_f32_e32 v95, v95, v52
v_fmac_f32_e32 v96, v34, v33
v_mul_f32_e32 v33, v49, v48
v_cvt_f32_i32_e32 v34, v204
v_fmac_f32_e32 v95, v35, v33
v_cvt_f32_i32_e32 v35, v203
v_mul_f32_e32 v94, v94, v52
v_mul_f32_e32 v33, v49, v41
v_mul_f32_e32 v93, v93, v52
v_fmac_f32_e32 v94, v34, v33
v_mul_f32_e32 v33, v49, v42
v_cvt_f32_i32_e32 v34, v202
v_fmac_f32_e32 v93, v35, v33
v_cvt_f32_i32_e32 v35, v201
v_mul_f32_e32 v92, v92, v52
v_mul_f32_e32 v33, v49, v43
v_mul_f32_e32 v91, v91, v52
v_fmac_f32_e32 v92, v34, v33
v_mul_f32_e32 v33, v49, v44
v_cvt_f32_i32_e32 v34, v200
v_fmac_f32_e32 v91, v35, v33
v_cvt_f32_i32_e32 v35, v199
v_mul_f32_e32 v90, v90, v53
v_mul_f32_e32 v33, v50, v45
v_mul_f32_e32 v89, v89, v53
v_fmac_f32_e32 v90, v34, v33
v_mul_f32_e32 v33, v50, v46
v_cvt_f32_i32_e32 v34, v198
v_fmac_f32_e32 v89, v35, v33
v_cvt_f32_i32_e32 v35, v197
v_mul_f32_e32 v88, v88, v53
v_mul_f32_e32 v33, v50, v47
v_mul_f32_e32 v87, v87, v53
v_fmac_f32_e32 v88, v34, v33
v_mul_f32_e32 v33, v50, v48
v_cvt_f32_i32_e32 v34, v196
v_fmac_f32_e32 v87, v35, v33
v_cvt_f32_i32_e32 v35, v195
v_mul_f32_e32 v86, v86, v53
v_mul_f32_e32 v33, v50, v41
v_mul_f32_e32 v85, v85, v53
v_fmac_f32_e32 v86, v34, v33
v_mul_f32_e32 v33, v50, v42
v_cvt_f32_i32_e32 v34, v194
v_fmac_f32_e32 v85, v35, v33
v_cvt_f32_i32_e32 v35, v193
v_mul_f32_e32 v84, v84, v53
v_mul_f32_e32 v33, v50, v43
v_mul_f32_e32 v83, v83, v53
v_fmac_f32_e32 v84, v34, v33
v_mul_f32_e32 v33, v50, v44
v_cvt_f32_i32_e32 v34, v192
v_fmac_f32_e32 v83, v35, v33
v_cvt_f32_i32_e32 v35, v191
v_mul_f32_e32 v82, v82, v54
v_mul_f32_e32 v33, v51, v45
v_mul_f32_e32 v81, v81, v54
v_fmac_f32_e32 v82, v34, v33
v_mul_f32_e32 v33, v51, v46
v_cvt_f32_i32_e32 v34, v190
v_fmac_f32_e32 v81, v35, v33
v_cvt_f32_i32_e32 v35, v189
v_mul_f32_e32 v80, v80, v54
v_mul_f32_e32 v33, v51, v47
v_mul_f32_e32 v79, v79, v54
v_fmac_f32_e32 v80, v34, v33
v_mul_f32_e32 v33, v51, v48
v_cvt_f32_i32_e32 v34, v188
v_fmac_f32_e32 v79, v35, v33
v_cvt_f32_i32_e32 v35, v187
v_mul_f32_e32 v78, v78, v54
v_mul_f32_e32 v33, v51, v41
v_mul_f32_e32 v77, v77, v54
v_fmac_f32_e32 v78, v34, v33
v_mul_f32_e32 v33, v51, v42
v_cvt_f32_i32_e32 v34, v186
v_fmac_f32_e32 v77, v35, v33
v_cvt_f32_i32_e32 v35, v185
v_mul_f32_e32 v76, v76, v54
v_mul_f32_e32 v33, v51, v43
v_mul_f32_e32 v75, v75, v54
v_fmac_f32_e32 v76, v34, v33
v_mul_f32_e32 v33, v51, v44
v_cvt_f32_i32_e32 v34, v184
v_fmac_f32_e32 v75, v35, v33
v_cvt_f32_i32_e32 v35, v183
v_mul_f32_e32 v74, v74, v58
v_mul_f32_e32 v33, v0, v45
v_mul_f32_e32 v73, v73, v58
v_fmac_f32_e32 v74, v34, v33
v_mul_f32_e32 v33, v0, v46
v_cvt_f32_i32_e32 v34, v182
v_fmac_f32_e32 v73, v35, v33
v_cvt_f32_i32_e32 v35, v181
v_mul_f32_e32 v71, v71, v58
v_mul_f32_e32 v33, v0, v47
v_mul_f32_e32 v70, v70, v58
v_fmac_f32_e32 v71, v34, v33
v_mul_f32_e32 v33, v0, v48
v_cvt_f32_i32_e32 v34, v180
v_fmac_f32_e32 v70, v35, v33
v_cvt_f32_i32_e32 v35, v179
v_mul_f32_e32 v69, v69, v58
v_mul_f32_e32 v33, v0, v41
v_mul_f32_e32 v68, v68, v58
v_fmac_f32_e32 v69, v34, v33
v_mul_f32_e32 v33, v0, v42
v_cvt_f32_i32_e32 v34, v178
v_fmac_f32_e32 v68, v35, v33
v_cvt_f32_i32_e32 v33, v61
v_mul_f32_e32 v67, v67, v58
v_mul_f32_e32 v66, v66, v58
v_mul_f32_e32 v35, v0, v43
v_mul_f32_e32 v0, v0, v44
s_add_i32 s20, s20, 64
v_add_co_u32_e32 v59, vcc, 0x400, v59
v_fmac_f32_e32 v67, v34, v35
v_fmac_f32_e32 v66, v33, v0
v_subrev_u32_e32 v134, 64, v134
v_add_u32_e32 v57, 16, v57
s_cmp_eq_u32 s19, s29
v_addc_co_u32_e32 v60, vcc, 0, v60, vcc
s_cbranch_scc1 5829
s_add_i32 s29, s29, 1
s_cmp_lt_i32 s29, s19
s_cselect_b64 s[10:11], -1, 0
s_cmp_ge_i32 s29, s19
s_cbranch_scc1 126
v_add_u32_e32 v11, s20, v146
v_add_u32_e32 v61, 64, v11
v_cmp_gt_i32_e32 vcc, s17, v61
v_mov_b32_e32 v4, 0
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v7, 0
v_mov_b32_e32 v6, 0
v_mov_b32_e32 v5, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 6
v_lshlrev_b64 v[0:1], 8, v[61:62]
v_add_co_u32_e32 v0, vcc, v138, v0
v_addc_co_u32_e32 v1, vcc, v139, v1, vcc
global_load_dwordx4 v[5:8], v[0:1], off
s_or_b64 exec, exec, s[6:7]
v_add_u32_e32 v0, 0x50, v11
v_cmp_gt_i32_e32 vcc, s17, v0
v_mov_b32_e32 v3, 0
v_mov_b32_e32 v2, 0
v_mov_b32_e32 v1, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 8, v[0:1]
v_add_co_u32_e32 v0, vcc, v138, v0
v_addc_co_u32_e32 v1, vcc, v139, v1, vcc
global_load_dwordx4 v[1:4], v[0:1], off
s_or_b64 exec, exec, s[6:7]
v_add_u32_e32 v9, 0x60, v11
v_cmp_gt_i32_e32 vcc, s17, v9
v_mov_b32_e32 v12, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v13, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_ashrrev_i32_e32 v10, 31, v9
v_lshlrev_b64 v[9:10], 8, v[9:10]
v_add_co_u32_e32 v9, vcc, v138, v9
v_addc_co_u32_e32 v10, vcc, v139, v10, vcc
global_load_dwordx4 v[13:16], v[9:10], off
s_or_b64 exec, exec, s[6:7]
v_add_u32_e32 v17, 0x70, v11
v_cmp_gt_i32_e32 vcc, s17, v17
v_mov_b32_e32 v11, 0
v_mov_b32_e32 v10, 0
v_mov_b32_e32 v9, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 7
v_ashrrev_i32_e32 v18, 31, v17
v_lshlrev_b64 v[9:10], 8, v[17:18]
v_add_co_u32_e32 v9, vcc, v138, v9
v_addc_co_u32_e32 v10, vcc, v139, v10, vcc
global_load_dwordx4 v[9:12], v[9:10], off
s_or_b64 exec, exec, s[6:7]
v_add_u32_e32 v61, -8, v57
v_mad_u64_u32 v[17:18], s[6:7], v61, 4, 4
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v28, 0
v_cmp_ge_u64_e32 vcc, s[8:9], v[17:18]
v_mov_b32_e32 v27, 0
v_mov_b32_e32 v26, 0
v_mov_b32_e32 v25, 0
v_mov_b32_e32 v24, 0
v_mov_b32_e32 v23, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v21, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 14
buffer_load_dword v0, off, s[36:39], 0 offset:80
v_lshlrev_b64 v[17:18], 10, v[61:62]
s_waitcnt vmcnt(0)
v_add_co_u32_e32 v17, vcc, v0, v17
buffer_load_dword v0, off, s[36:39], 0 offset:84
s_waitcnt vmcnt(0)
v_addc_co_u32_e32 v18, vcc, v0, v18, vcc
global_load_dwordx4 v[21:24], v[17:18], off
global_load_dwordx4 v[25:28], v[17:18], off offset:16
s_or_b64 exec, exec, s[6:7]
v_mad_u64_u32 v[17:18], s[6:7], v57, 4, 4
v_mov_b32_e32 v29, 0
v_mov_b32_e32 v30, 0
v_cmp_ge_u64_e32 vcc, s[8:9], v[17:18]
v_mov_b32_e32 v31, 0
v_mov_b32_e32 v32, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v19, 0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 16
buffer_load_dword v0, off, s[36:39], 0 offset:80
v_mov_b32_e32 v58, v62
v_lshlrev_b64 v[17:18], 10, v[57:58]
s_waitcnt vmcnt(0)
v_add_co_u32_e32 v17, vcc, v0, v17
buffer_load_dword v0, off, s[36:39], 0 offset:84
s_waitcnt vmcnt(0)
v_addc_co_u32_e32 v18, vcc, v0, v18, vcc
global_load_dwordx4 v[29:32], v[17:18], off
s_nop 0
global_load_dwordx4 v[17:20], v[17:18], off offset:16
s_or_b64 exec, exec, s[6:7]
buffer_load_dword v55, off, s[36:39], 0 offset:4
buffer_load_dword v56, off, s[36:39], 0 offset:8
s_waitcnt vmcnt(1)
ds_read_b32 v41, v55
s_waitcnt vmcnt(0)
ds_read_b32 v178, v56
ds_read_b128 v[37:40], v144
ds_read2_b64 v[42:45], v151 offset1:34
ds_read_b128 v[33:36], v144 offset:16
ds_read_b128 v[46:49], v152
ds_read_b128 v[50:53], v152 offset:128
ds_read_b128 v[179:182], v152 offset:272
ds_read_b128 v[183:186], v152 offset:400
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v0, v42, v46, v172
v_dot4_i32_i8 v54, v42, v47, v172
v_dot4_i32_i8 v58, v42, v48, v172
v_dot4_i32_i8 v61, v42, v49, v172
s_waitcnt lgkmcnt(2)
v_dot4_i32_i8 v189, v42, v50, v172
v_dot4_i32_i8 v190, v42, v51, v172
v_dot4_i32_i8 v191, v42, v52, v172
v_dot4_i32_i8 v42, v42, v53, v172
v_dot4_i32_i8 v192, v43, v46, v172
v_dot4_i32_i8 v193, v43, v47, v172
v_dot4_i32_i8 v194, v43, v48, v172
v_dot4_i32_i8 v195, v43, v49, v172
v_dot4_i32_i8 v196, v43, v50, v172
v_dot4_i32_i8 v197, v43, v51, v172
v_dot4_i32_i8 v198, v43, v52, v172
v_dot4_i32_i8 v43, v43, v53, v172
ds_read_b64 v[187:188], v151 offset:544
ds_read_b128 v[46:49], v152 offset:544
ds_read_b128 v[50:53], v152 offset:672
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v44, v179, v0
v_dot4_i32_i8 v54, v44, v180, v54
v_dot4_i32_i8 v58, v44, v181, v58
v_dot4_i32_i8 v61, v44, v182, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v44, v183, v189
v_dot4_i32_i8 v190, v44, v184, v190
v_dot4_i32_i8 v191, v44, v185, v191
v_dot4_i32_i8 v199, v44, v186, v42
v_dot4_i32_i8 v192, v45, v179, v192
v_dot4_i32_i8 v193, v45, v180, v193
v_dot4_i32_i8 v194, v45, v181, v194
v_dot4_i32_i8 v195, v45, v182, v195
v_dot4_i32_i8 v196, v45, v183, v196
v_dot4_i32_i8 v197, v45, v184, v197
v_dot4_i32_i8 v185, v45, v185, v198
v_dot4_i32_i8 v186, v45, v186, v43
ds_read_b64 v[183:184], v151 offset:816
ds_read_b128 v[42:45], v152 offset:816
ds_read_b128 v[179:182], v152 offset:944
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v187, v46, v0
v_dot4_i32_i8 v54, v187, v47, v54
v_dot4_i32_i8 v58, v187, v48, v58
v_dot4_i32_i8 v61, v187, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v187, v50, v189
v_dot4_i32_i8 v190, v187, v51, v190
v_dot4_i32_i8 v191, v187, v52, v191
v_dot4_i32_i8 v187, v187, v53, v199
v_dot4_i32_i8 v192, v188, v46, v192
v_dot4_i32_i8 v193, v188, v47, v193
v_dot4_i32_i8 v194, v188, v48, v194
v_dot4_i32_i8 v195, v188, v49, v195
v_dot4_i32_i8 v196, v188, v50, v196
v_dot4_i32_i8 v197, v188, v51, v197
v_dot4_i32_i8 v198, v188, v52, v185
v_dot4_i32_i8 v188, v188, v53, v186
ds_read_b64 v[185:186], v151 offset:1088
ds_read_b128 v[46:49], v152 offset:1088
ds_read_b128 v[50:53], v152 offset:1216
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:1360
ds_read_b128 v[42:45], v152 offset:1360
ds_read_b128 v[179:182], v152 offset:1488
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:1632
ds_read_b128 v[46:49], v152 offset:1632
ds_read_b128 v[50:53], v152 offset:1760
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:1904
ds_read_b128 v[42:45], v152 offset:1904
ds_read_b128 v[179:182], v152 offset:2032
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:2176
ds_read_b128 v[46:49], v152 offset:2176
ds_read_b128 v[50:53], v152 offset:2304
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:2448
ds_read_b128 v[42:45], v152 offset:2448
ds_read_b128 v[179:182], v152 offset:2576
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:2720
ds_read_b128 v[46:49], v152 offset:2720
ds_read_b128 v[50:53], v152 offset:2848
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:2992
ds_read_b128 v[42:45], v152 offset:2992
ds_read_b128 v[179:182], v152 offset:3120
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:3264
ds_read_b128 v[46:49], v152 offset:3264
ds_read_b128 v[50:53], v152 offset:3392
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:3536
ds_read_b128 v[42:45], v152 offset:3536
ds_read_b128 v[179:182], v152 offset:3664
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:3808
ds_read_b128 v[46:49], v152 offset:3808
ds_read_b128 v[50:53], v152 offset:3936
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:4080
ds_read_b128 v[42:45], v152 offset:4080
ds_read_b128 v[179:182], v152 offset:4208
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:4352
ds_read_b128 v[46:49], v152 offset:4352
ds_read_b128 v[50:53], v152 offset:4480
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:4624
ds_read_b128 v[42:45], v152 offset:4624
ds_read_b128 v[179:182], v152 offset:4752
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v185, v50, v189
v_dot4_i32_i8 v190, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v187, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v196, v186, v50, v196
v_dot4_i32_i8 v197, v186, v51, v197
v_dot4_i32_i8 v198, v186, v52, v198
v_dot4_i32_i8 v188, v186, v53, v188
ds_read_b64 v[185:186], v151 offset:4896
ds_read_b128 v[46:49], v152 offset:4896
ds_read_b128 v[50:53], v152 offset:5024
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v189, v183, v179, v189
v_dot4_i32_i8 v190, v183, v180, v190
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v187, v183, v182, v187
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v196, v184, v179, v196
v_dot4_i32_i8 v197, v184, v180, v197
v_dot4_i32_i8 v198, v184, v181, v198
v_dot4_i32_i8 v188, v184, v182, v188
ds_read_b64 v[183:184], v151 offset:5168
ds_read_b128 v[42:45], v152 offset:5168
ds_read_b128 v[179:182], v152 offset:5296
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v199, v185, v50, v189
v_dot4_i32_i8 v200, v185, v51, v190
v_dot4_i32_i8 v191, v185, v52, v191
v_dot4_i32_i8 v201, v185, v53, v187
v_dot4_i32_i8 v192, v186, v46, v192
v_dot4_i32_i8 v193, v186, v47, v193
v_dot4_i32_i8 v194, v186, v48, v194
v_dot4_i32_i8 v195, v186, v49, v195
v_dot4_i32_i8 v50, v186, v50, v196
v_dot4_i32_i8 v51, v186, v51, v197
v_dot4_i32_i8 v52, v186, v52, v198
v_dot4_i32_i8 v53, v186, v53, v188
v_add_u32_e32 v46, 0x1544, v152
ds_read2_b32 v[185:186], v46 offset1:1
v_add_u32_e32 v46, 0x1400, v152
ds_read2_b32 v[187:188], v46 offset0:80 offset1:83
ds_read_b64 v[189:190], v151 offset:5440
ds_read_b128 v[46:49], v152 offset:5568
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v196, v183, v179, v199
v_dot4_i32_i8 v197, v183, v180, v200
v_dot4_i32_i8 v191, v183, v181, v191
v_dot4_i32_i8 v198, v183, v182, v201
v_dot4_i32_i8 v192, v184, v42, v192
v_dot4_i32_i8 v193, v184, v43, v193
v_dot4_i32_i8 v194, v184, v44, v194
v_dot4_i32_i8 v195, v184, v45, v195
v_dot4_i32_i8 v179, v184, v179, v50
v_dot4_i32_i8 v180, v184, v180, v51
v_dot4_i32_i8 v181, v184, v181, v52
v_dot4_i32_i8 v182, v184, v182, v53
ds_read_b64 v[183:184], v151 offset:5712
ds_read_b128 v[42:45], v152 offset:5712
ds_read_b128 v[50:53], v152 offset:5840
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v189, v187, v0
v_dot4_i32_i8 v54, v189, v185, v54
v_dot4_i32_i8 v58, v189, v186, v58
v_dot4_i32_i8 v61, v189, v188, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v189, v46, v196
v_dot4_i32_i8 v197, v189, v47, v197
v_dot4_i32_i8 v191, v189, v48, v191
v_dot4_i32_i8 v189, v189, v49, v198
v_dot4_i32_i8 v187, v190, v187, v192
v_dot4_i32_i8 v192, v190, v185, v193
v_dot4_i32_i8 v193, v190, v186, v194
v_dot4_i32_i8 v188, v190, v188, v195
v_dot4_i32_i8 v194, v190, v46, v179
v_dot4_i32_i8 v195, v190, v47, v180
v_dot4_i32_i8 v198, v190, v48, v181
v_dot4_i32_i8 v190, v190, v49, v182
ds_read_b64 v[185:186], v151 offset:5984
ds_read_b128 v[46:49], v152 offset:5984
ds_read_b128 v[179:182], v152 offset:6112
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v183, v50, v196
v_dot4_i32_i8 v197, v183, v51, v197
v_dot4_i32_i8 v191, v183, v52, v191
v_dot4_i32_i8 v189, v183, v53, v189
v_dot4_i32_i8 v187, v184, v42, v187
v_dot4_i32_i8 v192, v184, v43, v192
v_dot4_i32_i8 v193, v184, v44, v193
v_dot4_i32_i8 v188, v184, v45, v188
v_dot4_i32_i8 v194, v184, v50, v194
v_dot4_i32_i8 v195, v184, v51, v195
v_dot4_i32_i8 v198, v184, v52, v198
v_dot4_i32_i8 v190, v184, v53, v190
ds_read_b64 v[183:184], v151 offset:6256
ds_read_b128 v[42:45], v152 offset:6256
ds_read_b128 v[50:53], v152 offset:6384
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v185, v179, v196
v_dot4_i32_i8 v197, v185, v180, v197
v_dot4_i32_i8 v191, v185, v181, v191
v_dot4_i32_i8 v189, v185, v182, v189
v_dot4_i32_i8 v187, v186, v46, v187
v_dot4_i32_i8 v192, v186, v47, v192
v_dot4_i32_i8 v193, v186, v48, v193
v_dot4_i32_i8 v188, v186, v49, v188
v_dot4_i32_i8 v194, v186, v179, v194
v_dot4_i32_i8 v195, v186, v180, v195
v_dot4_i32_i8 v198, v186, v181, v198
v_dot4_i32_i8 v190, v186, v182, v190
ds_read_b64 v[185:186], v151 offset:6528
ds_read_b128 v[46:49], v152 offset:6528
ds_read_b128 v[179:182], v152 offset:6656
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v183, v50, v196
v_dot4_i32_i8 v197, v183, v51, v197
v_dot4_i32_i8 v191, v183, v52, v191
v_dot4_i32_i8 v189, v183, v53, v189
v_dot4_i32_i8 v187, v184, v42, v187
v_dot4_i32_i8 v192, v184, v43, v192
v_dot4_i32_i8 v193, v184, v44, v193
v_dot4_i32_i8 v188, v184, v45, v188
v_dot4_i32_i8 v194, v184, v50, v194
v_dot4_i32_i8 v195, v184, v51, v195
v_dot4_i32_i8 v198, v184, v52, v198
v_dot4_i32_i8 v190, v184, v53, v190
ds_read_b64 v[183:184], v151 offset:6800
ds_read_b128 v[42:45], v152 offset:6800
ds_read_b128 v[50:53], v152 offset:6928
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v185, v179, v196
v_dot4_i32_i8 v197, v185, v180, v197
v_dot4_i32_i8 v191, v185, v181, v191
v_dot4_i32_i8 v189, v185, v182, v189
v_dot4_i32_i8 v187, v186, v46, v187
v_dot4_i32_i8 v192, v186, v47, v192
v_dot4_i32_i8 v193, v186, v48, v193
v_dot4_i32_i8 v188, v186, v49, v188
v_dot4_i32_i8 v194, v186, v179, v194
v_dot4_i32_i8 v195, v186, v180, v195
v_dot4_i32_i8 v198, v186, v181, v198
v_dot4_i32_i8 v190, v186, v182, v190
ds_read_b64 v[185:186], v151 offset:7072
ds_read_b128 v[46:49], v152 offset:7072
ds_read_b128 v[179:182], v152 offset:7200
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v183, v50, v196
v_dot4_i32_i8 v197, v183, v51, v197
v_dot4_i32_i8 v191, v183, v52, v191
v_dot4_i32_i8 v189, v183, v53, v189
v_dot4_i32_i8 v187, v184, v42, v187
v_dot4_i32_i8 v192, v184, v43, v192
v_dot4_i32_i8 v193, v184, v44, v193
v_dot4_i32_i8 v188, v184, v45, v188
v_dot4_i32_i8 v194, v184, v50, v194
v_dot4_i32_i8 v195, v184, v51, v195
v_dot4_i32_i8 v198, v184, v52, v198
v_dot4_i32_i8 v190, v184, v53, v190
v_add_u32_e32 v42, 0x1800, v152
ds_read2_b64 v[42:45], v42 offset0:150 offset1:151
ds_read_b64 v[183:184], v151 offset:7344
ds_read_b128 v[50:53], v152 offset:7472
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v185, v179, v196
v_dot4_i32_i8 v197, v185, v180, v197
v_dot4_i32_i8 v191, v185, v181, v191
v_dot4_i32_i8 v189, v185, v182, v189
v_dot4_i32_i8 v187, v186, v46, v187
v_dot4_i32_i8 v192, v186, v47, v192
v_dot4_i32_i8 v193, v186, v48, v193
v_dot4_i32_i8 v188, v186, v49, v188
v_dot4_i32_i8 v194, v186, v179, v194
v_dot4_i32_i8 v195, v186, v180, v195
v_dot4_i32_i8 v198, v186, v181, v198
v_dot4_i32_i8 v190, v186, v182, v190
ds_read_b64 v[185:186], v151 offset:7616
ds_read_b128 v[46:49], v152 offset:7616
ds_read_b128 v[179:182], v152 offset:7744
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v183, v50, v196
v_dot4_i32_i8 v197, v183, v51, v197
v_dot4_i32_i8 v191, v183, v52, v191
v_dot4_i32_i8 v189, v183, v53, v189
v_dot4_i32_i8 v187, v184, v42, v187
v_dot4_i32_i8 v192, v184, v43, v192
v_dot4_i32_i8 v193, v184, v44, v193
v_dot4_i32_i8 v188, v184, v45, v188
v_dot4_i32_i8 v194, v184, v50, v194
v_dot4_i32_i8 v195, v184, v51, v195
v_dot4_i32_i8 v198, v184, v52, v198
v_dot4_i32_i8 v190, v184, v53, v190
ds_read_b64 v[183:184], v151 offset:7888
ds_read_b128 v[42:45], v152 offset:7888
ds_read_b128 v[50:53], v152 offset:8016
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v185, v179, v196
v_dot4_i32_i8 v197, v185, v180, v197
v_dot4_i32_i8 v191, v185, v181, v191
v_dot4_i32_i8 v189, v185, v182, v189
v_dot4_i32_i8 v187, v186, v46, v187
v_dot4_i32_i8 v192, v186, v47, v192
v_dot4_i32_i8 v193, v186, v48, v193
v_dot4_i32_i8 v188, v186, v49, v188
v_dot4_i32_i8 v194, v186, v179, v194
v_dot4_i32_i8 v195, v186, v180, v195
v_dot4_i32_i8 v198, v186, v181, v198
v_dot4_i32_i8 v190, v186, v182, v190
ds_read_b64 v[185:186], v151 offset:8160
ds_read_b128 v[46:49], v152 offset:8160
ds_read_b128 v[179:182], v152 offset:8288
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v183, v50, v196
v_dot4_i32_i8 v197, v183, v51, v197
v_dot4_i32_i8 v191, v183, v52, v191
v_dot4_i32_i8 v189, v183, v53, v189
v_dot4_i32_i8 v187, v184, v42, v187
v_dot4_i32_i8 v192, v184, v43, v192
v_dot4_i32_i8 v193, v184, v44, v193
v_dot4_i32_i8 v188, v184, v45, v188
v_dot4_i32_i8 v194, v184, v50, v194
v_dot4_i32_i8 v195, v184, v51, v195
v_dot4_i32_i8 v198, v184, v52, v198
v_dot4_i32_i8 v190, v184, v53, v190
ds_read_b64 v[183:184], v151 offset:8432
ds_read_b128 v[42:45], v152 offset:8432
ds_read_b128 v[50:53], v152 offset:8560
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v0, v185, v46, v0
v_dot4_i32_i8 v54, v185, v47, v54
v_dot4_i32_i8 v58, v185, v48, v58
v_dot4_i32_i8 v61, v185, v49, v61
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v196, v185, v179, v196
v_dot4_i32_i8 v197, v185, v180, v197
v_dot4_i32_i8 v191, v185, v181, v191
v_dot4_i32_i8 v185, v185, v182, v189
v_dot4_i32_i8 v46, v186, v46, v187
v_dot4_i32_i8 v47, v186, v47, v192
v_dot4_i32_i8 v48, v186, v48, v193
v_dot4_i32_i8 v49, v186, v49, v188
v_dot4_i32_i8 v179, v186, v179, v194
v_dot4_i32_i8 v180, v186, v180, v195
v_dot4_i32_i8 v181, v186, v181, v198
v_dot4_i32_i8 v182, v186, v182, v190
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v0, v183, v42, v0
v_dot4_i32_i8 v54, v183, v43, v54
v_dot4_i32_i8 v58, v183, v44, v58
v_dot4_i32_i8 v61, v183, v45, v61
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v186, v183, v50, v196
v_dot4_i32_i8 v187, v183, v51, v197
v_dot4_i32_i8 v188, v183, v52, v191
v_dot4_i32_i8 v183, v183, v53, v185
v_dot4_i32_i8 v42, v184, v42, v46
v_dot4_i32_i8 v43, v184, v43, v47
v_dot4_i32_i8 v44, v184, v44, v48
v_dot4_i32_i8 v185, v184, v45, v49
v_dot4_i32_i8 v179, v184, v50, v179
v_dot4_i32_i8 v180, v184, v51, v180
v_dot4_i32_i8 v181, v184, v52, v181
v_dot4_i32_i8 v182, v184, v53, v182
v_cvt_f32_i32_e32 v0, v0
v_cvt_f32_i32_e32 v46, v54
v_mul_f32_e32 v45, v41, v37
v_mul_f32_e32 v47, v41, v38
v_cvt_f32_i32_e32 v48, v58
v_fma_f32 v0, v45, v0, 0
v_fma_f32 v45, v47, v46, 0
v_cvt_f32_i32_e32 v47, v61
v_cvt_f32_i32_e32 v49, v186
v_mul_f32_e32 v46, v41, v39
v_cvt_f32_i32_e32 v50, v187
v_fma_f32 v46, v46, v48, 0
v_mul_f32_e32 v48, v41, v40
v_cvt_f32_i32_e32 v51, v188
v_cvt_f32_i32_e32 v52, v183
v_fma_f32 v47, v48, v47, 0
v_mul_f32_e32 v48, v41, v33
v_fma_f32 v48, v48, v49, 0
v_mul_f32_e32 v49, v41, v34
v_fma_f32 v49, v49, v50, 0
v_mul_f32_e32 v50, v41, v35
v_mul_f32_e32 v41, v41, v36
v_cvt_f32_i32_e32 v42, v42
v_fma_f32 v50, v50, v51, 0
v_fma_f32 v51, v41, v52, 0
v_cvt_f32_i32_e32 v41, v43
v_mul_f32_e32 v37, v178, v37
v_fma_f32 v52, v37, v42, 0
v_mul_f32_e32 v37, v178, v38
v_cvt_f32_i32_e32 v38, v44
v_fma_f32 v53, v37, v41, 0
v_mul_f32_e32 v37, v178, v39
v_cvt_f32_i32_e32 v39, v185
v_fma_f32 v54, v37, v38, 0
v_mul_f32_e32 v37, v178, v40
v_cvt_f32_i32_e32 v38, v179
v_fma_f32 v58, v37, v39, 0
v_cvt_f32_i32_e32 v37, v180
v_mul_f32_e32 v33, v178, v33
v_fma_f32 v61, v33, v38, 0
v_mul_f32_e32 v33, v178, v34
v_fma_f32 v33, v33, v37, 0
v_add_u32_e32 v37, 0x2000, v151
v_add_u32_e32 v189, 0x2000, v152
v_cvt_f32_i32_e32 v34, v181
v_cvt_f32_i32_e32 v201, v182
ds_read_b32 v180, v55 offset:256
ds_read_b32 v179, v56 offset:256
ds_read_b128 v[41:44], v144 offset:256
ds_read2_b64 v[181:184], v37 offset0:64 offset1:98
ds_read_b128 v[37:40], v144 offset:272
ds_read_b128 v[185:188], v152 offset:8704
ds_read2_b64 v[189:192], v189 offset0:98 offset1:99
ds_read_b128 v[193:196], v152 offset:8832
ds_read_b128 v[197:200], v152 offset:9104
v_mul_f32_e32 v35, v178, v35
v_fma_f32 v34, v35, v34, 0
v_mul_f32_e32 v35, v178, v36
v_fma_f32 v35, v35, v201, 0
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v36, v181, v185, v172
v_dot4_i32_i8 v178, v181, v186, v172
v_dot4_i32_i8 v203, v181, v187, v172
v_dot4_i32_i8 v204, v181, v188, v172
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v205, v181, v193, v172
v_dot4_i32_i8 v206, v181, v194, v172
v_dot4_i32_i8 v207, v181, v195, v172
v_dot4_i32_i8 v181, v181, v196, v172
v_dot4_i32_i8 v208, v182, v185, v172
v_dot4_i32_i8 v209, v182, v186, v172
v_dot4_i32_i8 v210, v182, v187, v172
v_dot4_i32_i8 v211, v182, v188, v172
v_dot4_i32_i8 v212, v182, v193, v172
v_dot4_i32_i8 v213, v182, v194, v172
v_dot4_i32_i8 v214, v182, v195, v172
v_dot4_i32_i8 v182, v182, v196, v62
ds_read_b64 v[201:202], v151 offset:9248
ds_read_b128 v[185:188], v152 offset:9248
ds_read_b128 v[193:196], v152 offset:9376
v_dot4_i32_i8 v36, v183, v189, v36
v_dot4_i32_i8 v178, v183, v190, v178
v_dot4_i32_i8 v203, v183, v191, v203
v_dot4_i32_i8 v204, v183, v192, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v183, v197, v205
v_dot4_i32_i8 v206, v183, v198, v206
v_dot4_i32_i8 v207, v183, v199, v207
v_dot4_i32_i8 v215, v183, v200, v181
v_dot4_i32_i8 v208, v184, v189, v208
v_dot4_i32_i8 v209, v184, v190, v209
v_dot4_i32_i8 v210, v184, v191, v210
v_dot4_i32_i8 v211, v184, v192, v211
v_dot4_i32_i8 v212, v184, v197, v212
v_dot4_i32_i8 v213, v184, v198, v213
v_dot4_i32_i8 v199, v184, v199, v214
v_dot4_i32_i8 v200, v184, v200, v182
ds_read_b64 v[197:198], v151 offset:9520
ds_read_b128 v[181:184], v152 offset:9520
ds_read_b128 v[189:192], v152 offset:9648
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v201, v185, v36
v_dot4_i32_i8 v178, v201, v186, v178
v_dot4_i32_i8 v203, v201, v187, v203
v_dot4_i32_i8 v204, v201, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v201, v193, v205
v_dot4_i32_i8 v206, v201, v194, v206
v_dot4_i32_i8 v207, v201, v195, v207
v_dot4_i32_i8 v201, v201, v196, v215
v_dot4_i32_i8 v208, v202, v185, v208
v_dot4_i32_i8 v209, v202, v186, v209
v_dot4_i32_i8 v210, v202, v187, v210
v_dot4_i32_i8 v211, v202, v188, v211
v_dot4_i32_i8 v212, v202, v193, v212
v_dot4_i32_i8 v213, v202, v194, v213
v_dot4_i32_i8 v214, v202, v195, v199
v_dot4_i32_i8 v202, v202, v196, v200
ds_read_b64 v[199:200], v151 offset:9792
ds_read_b128 v[185:188], v152 offset:9792
ds_read_b128 v[193:196], v152 offset:9920
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v211, v198, v184, v211
v_dot4_i32_i8 v212, v198, v189, v212
v_dot4_i32_i8 v213, v198, v190, v213
v_dot4_i32_i8 v214, v198, v191, v214
v_dot4_i32_i8 v202, v198, v192, v202
ds_read_b64 v[197:198], v151 offset:10064
ds_read_b128 v[181:184], v152 offset:10064
ds_read_b128 v[189:192], v152 offset:10192
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v211, v200, v188, v211
v_dot4_i32_i8 v212, v200, v193, v212
v_dot4_i32_i8 v213, v200, v194, v213
v_dot4_i32_i8 v214, v200, v195, v214
v_dot4_i32_i8 v202, v200, v196, v202
ds_read_b64 v[199:200], v151 offset:10336
ds_read_b128 v[185:188], v152 offset:10336
ds_read_b128 v[193:196], v152 offset:10464
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v211, v198, v184, v211
v_dot4_i32_i8 v212, v198, v189, v212
v_dot4_i32_i8 v213, v198, v190, v213
v_dot4_i32_i8 v214, v198, v191, v214
v_dot4_i32_i8 v202, v198, v192, v202
ds_read_b64 v[197:198], v151 offset:10608
ds_read_b128 v[181:184], v152 offset:10608
ds_read_b128 v[189:192], v152 offset:10736
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v211, v200, v188, v211
v_dot4_i32_i8 v212, v200, v193, v212
v_dot4_i32_i8 v213, v200, v194, v213
v_dot4_i32_i8 v214, v200, v195, v214
v_dot4_i32_i8 v196, v200, v196, v202
ds_read_b64 v[199:200], v151 offset:10880
ds_read_b96 v[193:195], v152 offset:10880
ds_read_b32 v202, v152 offset:10892
ds_read_b128 v[185:188], v152 offset:11008
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v211, v198, v184, v211
v_dot4_i32_i8 v212, v198, v189, v212
v_dot4_i32_i8 v213, v198, v190, v213
v_dot4_i32_i8 v214, v198, v191, v214
v_dot4_i32_i8 v196, v198, v192, v196
ds_read_b64 v[197:198], v151 offset:11152
ds_read_b128 v[181:184], v152 offset:11152
ds_read_b128 v[189:192], v152 offset:11280
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v36, v199, v193, v36
v_dot4_i32_i8 v178, v199, v194, v178
v_dot4_i32_i8 v203, v199, v195, v203
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v204, v199, v202, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v185, v205
v_dot4_i32_i8 v206, v199, v186, v206
v_dot4_i32_i8 v207, v199, v187, v207
v_dot4_i32_i8 v201, v199, v188, v201
v_dot4_i32_i8 v208, v200, v193, v208
v_dot4_i32_i8 v209, v200, v194, v209
v_dot4_i32_i8 v210, v200, v195, v210
v_dot4_i32_i8 v202, v200, v202, v211
v_dot4_i32_i8 v211, v200, v185, v212
v_dot4_i32_i8 v212, v200, v186, v213
v_dot4_i32_i8 v213, v200, v187, v214
v_dot4_i32_i8 v214, v200, v188, v196
ds_read_b64 v[199:200], v151 offset:11424
ds_read_b128 v[185:188], v152 offset:11424
ds_read_b128 v[193:196], v152 offset:11552
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:11696
ds_read_b128 v[181:184], v152 offset:11696
ds_read_b128 v[189:192], v152 offset:11824
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:11968
ds_read_b128 v[185:188], v152 offset:11968
ds_read_b128 v[193:196], v152 offset:12096
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:12240
ds_read_b128 v[181:184], v152 offset:12240
ds_read_b128 v[189:192], v152 offset:12368
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:12512
ds_read_b128 v[185:188], v152 offset:12512
ds_read_b128 v[193:196], v152 offset:12640
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:12784
ds_read_b128 v[181:184], v152 offset:12784
ds_read_b128 v[189:192], v152 offset:12912
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:13056
ds_read_b128 v[185:188], v152 offset:13056
ds_read_b128 v[193:196], v152 offset:13184
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:13328
ds_read_b128 v[181:184], v152 offset:13328
ds_read_b128 v[189:192], v152 offset:13456
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:13600
ds_read_b128 v[185:188], v152 offset:13600
ds_read_b128 v[193:196], v152 offset:13728
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:13872
ds_read_b128 v[181:184], v152 offset:13872
ds_read_b128 v[189:192], v152 offset:14000
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:14144
ds_read_b128 v[185:188], v152 offset:14144
ds_read_b128 v[193:196], v152 offset:14272
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:14416
ds_read_b128 v[181:184], v152 offset:14416
ds_read_b128 v[189:192], v152 offset:14544
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[193:194], v151 offset:14688
ds_read_b128 v[185:188], v152 offset:14688
v_add_u32_e32 v195, 0x3800, v152
v_add_u32_e32 v199, 0x39e4, v152
ds_read2_b32 v[195:196], v195 offset0:120 offset1:123
ds_read2_b32 v[199:200], v199 offset1:1
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:14960
ds_read_b128 v[181:184], v152 offset:14960
ds_read_b128 v[189:192], v152 offset:15088
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v36, v193, v185, v36
v_dot4_i32_i8 v178, v193, v186, v178
v_dot4_i32_i8 v203, v193, v187, v203
v_dot4_i32_i8 v204, v193, v188, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v193, v195, v205
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v206, v193, v199, v206
v_dot4_i32_i8 v207, v193, v200, v207
v_dot4_i32_i8 v201, v193, v196, v201
v_dot4_i32_i8 v208, v194, v185, v208
v_dot4_i32_i8 v209, v194, v186, v209
v_dot4_i32_i8 v210, v194, v187, v210
v_dot4_i32_i8 v202, v194, v188, v202
v_dot4_i32_i8 v211, v194, v195, v211
v_dot4_i32_i8 v212, v194, v199, v212
v_dot4_i32_i8 v213, v194, v200, v213
v_dot4_i32_i8 v214, v194, v196, v214
ds_read_b64 v[199:200], v151 offset:15232
ds_read_b128 v[185:188], v152 offset:15232
ds_read_b128 v[193:196], v152 offset:15360
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:15504
ds_read_b128 v[181:184], v152 offset:15504
ds_read_b128 v[189:192], v152 offset:15632
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:15776
ds_read_b128 v[185:188], v152 offset:15776
ds_read_b128 v[193:196], v152 offset:15904
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:16048
ds_read_b128 v[181:184], v152 offset:16048
ds_read_b128 v[189:192], v152 offset:16176
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:16320
ds_read_b128 v[185:188], v152 offset:16320
ds_read_b128 v[193:196], v152 offset:16448
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:16592
ds_read_b128 v[181:184], v152 offset:16592
v_add_u32_e32 v189, 0x4000, v152
ds_read2_b64 v[189:192], v189 offset0:42 offset1:43
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v201, v199, v196, v201
v_dot4_i32_i8 v208, v200, v185, v208
v_dot4_i32_i8 v209, v200, v186, v209
v_dot4_i32_i8 v210, v200, v187, v210
v_dot4_i32_i8 v202, v200, v188, v202
v_dot4_i32_i8 v211, v200, v193, v211
v_dot4_i32_i8 v212, v200, v194, v212
v_dot4_i32_i8 v213, v200, v195, v213
v_dot4_i32_i8 v214, v200, v196, v214
ds_read_b64 v[199:200], v151 offset:16864
ds_read_b128 v[185:188], v152 offset:16864
ds_read_b128 v[193:196], v152 offset:16992
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v203, v197, v183, v203
v_dot4_i32_i8 v204, v197, v184, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v197, v189, v205
v_dot4_i32_i8 v206, v197, v190, v206
v_dot4_i32_i8 v207, v197, v191, v207
v_dot4_i32_i8 v201, v197, v192, v201
v_dot4_i32_i8 v208, v198, v181, v208
v_dot4_i32_i8 v209, v198, v182, v209
v_dot4_i32_i8 v210, v198, v183, v210
v_dot4_i32_i8 v202, v198, v184, v202
v_dot4_i32_i8 v211, v198, v189, v211
v_dot4_i32_i8 v212, v198, v190, v212
v_dot4_i32_i8 v213, v198, v191, v213
v_dot4_i32_i8 v214, v198, v192, v214
ds_read_b64 v[197:198], v151 offset:17136
ds_read_b128 v[181:184], v152 offset:17136
ds_read_b128 v[189:192], v152 offset:17264
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v36, v199, v185, v36
v_dot4_i32_i8 v178, v199, v186, v178
v_dot4_i32_i8 v203, v199, v187, v203
v_dot4_i32_i8 v204, v199, v188, v204
s_waitcnt lgkmcnt(3)
v_dot4_i32_i8 v205, v199, v193, v205
v_dot4_i32_i8 v206, v199, v194, v206
v_dot4_i32_i8 v207, v199, v195, v207
v_dot4_i32_i8 v199, v199, v196, v201
v_dot4_i32_i8 v185, v200, v185, v208
v_dot4_i32_i8 v186, v200, v186, v209
v_dot4_i32_i8 v187, v200, v187, v210
v_dot4_i32_i8 v188, v200, v188, v202
v_dot4_i32_i8 v193, v200, v193, v211
v_dot4_i32_i8 v194, v200, v194, v212
v_dot4_i32_i8 v195, v200, v195, v213
v_dot4_i32_i8 v196, v200, v196, v214
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v36, v197, v181, v36
v_dot4_i32_i8 v178, v197, v182, v178
v_dot4_i32_i8 v200, v197, v183, v203
v_dot4_i32_i8 v201, v197, v184, v204
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v202, v197, v189, v205
v_dot4_i32_i8 v203, v197, v190, v206
v_dot4_i32_i8 v204, v197, v191, v207
v_dot4_i32_i8 v197, v197, v192, v199
v_dot4_i32_i8 v181, v198, v181, v185
v_dot4_i32_i8 v182, v198, v182, v186
v_dot4_i32_i8 v183, v198, v183, v187
v_dot4_i32_i8 v184, v198, v184, v188
v_dot4_i32_i8 v185, v198, v189, v193
v_dot4_i32_i8 v186, v198, v190, v194
v_dot4_i32_i8 v187, v198, v191, v195
v_dot4_i32_i8 v188, v198, v192, v196
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v189, v180, v41
v_cvt_f32_i32_e32 v178, v178
v_mul_f32_e32 v190, v180, v42
v_fmac_f32_e32 v0, v189, v36
v_cvt_f32_i32_e32 v36, v200
v_cvt_f32_i32_e32 v189, v201
v_fmac_f32_e32 v45, v190, v178
v_mul_f32_e32 v178, v180, v43
v_fmac_f32_e32 v46, v178, v36
v_mul_f32_e32 v36, v180, v44
v_cvt_f32_i32_e32 v178, v202
v_fmac_f32_e32 v47, v36, v189
v_cvt_f32_i32_e32 v189, v203
v_mul_f32_e32 v36, v180, v37
v_fmac_f32_e32 v48, v36, v178
v_mul_f32_e32 v36, v180, v38
v_cvt_f32_i32_e32 v178, v204
v_fmac_f32_e32 v49, v36, v189
v_cvt_f32_i32_e32 v189, v197
v_mul_f32_e32 v36, v180, v39
v_fmac_f32_e32 v50, v36, v178
v_mul_f32_e32 v36, v180, v40
v_cvt_f32_i32_e32 v178, v181
v_fmac_f32_e32 v51, v36, v189
v_mul_f32_e32 v36, v179, v41
v_cvt_f32_i32_e32 v41, v182
v_fmac_f32_e32 v52, v36, v178
v_mul_f32_e32 v36, v179, v42
v_cvt_f32_i32_e32 v42, v183
v_fmac_f32_e32 v53, v36, v41
v_cvt_f32_i32_e32 v41, v184
v_mul_f32_e32 v36, v179, v43
v_fmac_f32_e32 v54, v36, v42
v_mul_f32_e32 v36, v179, v44
v_cvt_f32_i32_e32 v42, v185
v_fmac_f32_e32 v58, v36, v41
v_mul_f32_e32 v36, v179, v37
v_cvt_f32_i32_e32 v37, v186
v_fmac_f32_e32 v61, v36, v42
v_mul_f32_e32 v36, v179, v38
v_cvt_f32_i32_e32 v38, v187
v_fmac_f32_e32 v33, v36, v37
v_cvt_f32_i32_e32 v36, v188
v_mul_f32_e32 v37, v179, v39
v_cmp_le_i32_e32 vcc, v133, v134
v_fmac_f32_e32 v34, v37, v38
v_mul_f32_e32 v37, v179, v40
v_cndmask_b32_e32 v181, v173, v0, vcc
v_or_b32_e32 v0, 2, v133
v_fmac_f32_e32 v35, v37, v36
v_cmp_lt_i32_e32 vcc, v133, v134
v_mov_b32_e32 v36, v0
v_or_b32_e32 v0, 3, v133
v_cndmask_b32_e32 v180, v173, v45, vcc
v_cmp_le_i32_e32 vcc, v36, v134
v_mov_b32_e32 v37, v0
v_cndmask_b32_e32 v179, v173, v46, vcc
v_cmp_le_i32_e32 vcc, v37, v134
v_cndmask_b32_e32 v178, v173, v47, vcc
v_cmp_le_i32_e32 vcc, v147, v134
v_cndmask_b32_e32 v48, v173, v48, vcc
v_cmp_le_i32_e32 vcc, v148, v134
v_cndmask_b32_e32 v47, v173, v49, vcc
v_cmp_le_i32_e32 vcc, v149, v134
v_cndmask_b32_e32 v46, v173, v50, vcc
v_cmp_le_i32_e32 vcc, v150, v134
v_add_u32_e32 v0, 1, v134
v_cndmask_b32_e32 v45, v173, v51, vcc
v_cmp_le_i32_e32 vcc, v133, v0
v_cndmask_b32_e32 v44, v173, v52, vcc
v_cmp_lt_i32_e32 vcc, v133, v0
v_cndmask_b32_e32 v43, v173, v53, vcc
v_cmp_le_i32_e32 vcc, v36, v0
v_cndmask_b32_e32 v42, v173, v54, vcc
v_cmp_le_i32_e32 vcc, v37, v0
v_cndmask_b32_e32 v41, v173, v58, vcc
v_cmp_le_i32_e32 vcc, v147, v0
v_max_f32_e32 v36, v181, v180
v_cndmask_b32_e32 v40, v173, v61, vcc
v_cmp_le_i32_e32 vcc, v148, v0
v_max3_f32 v36, v36, v179, v178
v_cndmask_b32_e32 v39, v173, v33, vcc
v_and_b32_e32 v33, 64, v174
v_max3_f32 v36, v36, v48, v47
v_and_b32_e32 v49, 63, v174
v_add_u32_e32 v33, 64, v33
v_max3_f32 v37, v36, v46, v45
v_xor_b32_e32 v36, 1, v49
v_cmp_lt_i32_e32 vcc, v36, v33
v_cndmask_b32_e32 v36, v174, v36, vcc
v_lshlrev_b32_e32 v36, 2, v36
ds_bpermute_b32 v50, v36, v37
v_cmp_le_i32_e32 vcc, v149, v0
v_cndmask_b32_e32 v38, v173, v34, vcc
v_cmp_le_i32_e32 vcc, v150, v0
v_xor_b32_e32 v34, 2, v49
v_cndmask_b32_e32 v35, v173, v35, vcc
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v0, v50, v50
v_cmp_lt_i32_e32 vcc, v34, v33
v_max_f32_e32 v50, v44, v43
v_cndmask_b32_e32 v34, v174, v34, vcc
v_max3_f32 v50, v50, v42, v41
v_max_f32_e32 v0, v37, v0
v_lshlrev_b32_e32 v34, 2, v34
v_max3_f32 v50, v50, v40, v39
ds_bpermute_b32 v37, v34, v0
v_max3_f32 v50, v50, v38, v35
ds_bpermute_b32 v51, v36, v50
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v37, v37, v37
v_max_f32_e32 v0, v0, v37
v_xor_b32_e32 v37, 4, v49
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v49, v51, v51
v_max_f32_e32 v49, v50, v49
ds_bpermute_b32 v50, v34, v49
v_cmp_lt_i32_e32 vcc, v37, v33
v_cndmask_b32_e32 v33, v174, v37, vcc
v_lshlrev_b32_e32 v37, 2, v33
ds_bpermute_b32 v33, v37, v0
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v50, v50, v50
v_max_f32_e32 v49, v49, v50
ds_bpermute_b32 v50, v37, v49
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v33, v33, v33
v_max_f32_e32 v33, v0, v33
v_cmp_gt_f32_e32 vcc, s18, v33
s_waitcnt lgkmcnt(0)
v_max_f32_e32 v0, v50, v50
v_max_f32_e32 v0, v49, v0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 5
buffer_load_dword v33, off, s[36:39], 0 offset:28
s_waitcnt vmcnt(0)
ds_read_b32 v33, v33
s_or_b64 exec, exec, s[6:7]
v_cmp_gt_f32_e32 vcc, s18, v0
s_and_saveexec_b64 s[6:7], vcc
s_cbranch_execz 5
buffer_load_dword v0, off, s[36:39], 0 offset:32
s_waitcnt vmcnt(0)
ds_read_b32 v0, v0
s_or_b64 exec, exec, s[6:7]
s_waitcnt lgkmcnt(0)
v_sub_f32_e32 v49, v181, v33
v_mul_f32_e32 v49, 0x3fb8aa3b, v49
v_cmp_gt_f32_e32 vcc, s21, v49
v_cndmask_b32_e32 v50, 0, v176, vcc
v_add_f32_e32 v49, v49, v50
v_cmp_gt_f32_e64 s[6:7], s21, v49
v_cndmask_b32_e64 v50, 0, v176, s[6:7]
v_add_f32_e32 v49, v49, v50
v_sub_f32_e32 v50, v180, v33
v_exp_f32_e32 v49, v49
v_cndmask_b32_e64 v52, 1.0, v175, s[6:7]
v_mul_f32_e32 v50, 0x3fb8aa3b, v50
v_cndmask_b32_e32 v51, 1.0, v175, vcc
v_mul_f32_e32 v49, v49, v52
v_cmp_gt_f32_e32 vcc, s21, v50
v_mul_f32_e32 v49, v51, v49
v_cndmask_b32_e32 v51, 0, v176, vcc
v_add_f32_e32 v50, v50, v51
v_cmp_gt_f32_e64 s[6:7], s21, v50
v_cndmask_b32_e64 v51, 0, v176, s[6:7]
v_add_f32_e32 v50, v50, v51
v_cndmask_b32_e64 v52, 1.0, v175, s[6:7]
v_exp_f32_e32 v50, v50
v_cndmask_b32_e32 v51, 1.0, v175, vcc
v_sub_f32_e32 v48, v48, v33
v_mul_f32_e32 v48, 0x3fb8aa3b, v48
v_mul_f32_e32 v50, v50, v52
v_mul_f32_e32 v50, v51, v50
v_sub_f32_e32 v51, v179, v33
v_mul_f32_e32 v51, 0x3fb8aa3b, v51
v_cmp_gt_f32_e32 vcc, s21, v51
v_cndmask_b32_e32 v53, 0, v176, vcc
v_add_f32_e32 v51, v51, v53
v_cndmask_b32_e32 v52, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v51
v_cndmask_b32_e32 v53, 0, v176, vcc
v_add_f32_e32 v51, v51, v53
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_exp_f32_e32 v51, v51
v_sub_f32_e32 v47, v47, v33
v_mul_f32_e32 v47, 0x3fb8aa3b, v47
v_sub_f32_e32 v46, v46, v33
v_mul_f32_e32 v51, v51, v54
v_mul_f32_e32 v51, v52, v51
v_sub_f32_e32 v52, v178, v33
v_mul_f32_e32 v52, 0x3fb8aa3b, v52
v_cmp_gt_f32_e32 vcc, s21, v52
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v52, v52, v58
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v52
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v52, v52, v58
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_exp_f32_e32 v52, v52
v_cmp_gt_f32_e32 vcc, s21, v48
v_mul_f32_e32 v46, 0x3fb8aa3b, v46
v_sub_f32_e32 v45, v45, v33
v_mul_f32_e32 v52, v52, v58
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v48, v48, v58
v_mul_f32_e32 v52, v54, v52
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v48
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v48, v48, v58
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_exp_f32_e32 v48, v48
v_cmp_gt_f32_e32 vcc, s21, v47
v_mul_f32_e32 v45, 0x3fb8aa3b, v45
v_fma_f32 v49, v49, s22, 0.5
v_mul_f32_e32 v48, v48, v58
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v47, v47, v58
v_mul_f32_e32 v48, v54, v48
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v47
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v47, v47, v58
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_exp_f32_e32 v47, v47
v_cmp_gt_f32_e32 vcc, s21, v46
v_fma_f32 v50, v50, s22, 0.5
v_cvt_i32_f32_e32 v49, v49
v_mul_f32_e32 v47, v47, v58
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v46, v46, v58
v_mul_f32_e32 v47, v54, v47
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v46
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v46, v46, v58
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_exp_f32_e32 v46, v46
v_cmp_gt_f32_e32 vcc, s21, v45
v_cvt_i32_f32_e32 v50, v50
v_fma_f32 v51, v51, s22, 0.5
v_mul_f32_e32 v46, v46, v58
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v45, v45, v58
v_mul_f32_e32 v46, v54, v46
v_cndmask_b32_e32 v54, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v45
v_cndmask_b32_e32 v58, 0, v176, vcc
v_add_f32_e32 v45, v45, v58
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_exp_f32_e32 v45, v45
v_fma_f32 v52, v52, s22, 0.5
v_cvt_i32_f32_e32 v51, v51
v_cvt_i32_f32_e32 v52, v52
v_mul_f32_e32 v45, v45, v58
v_fma_f32 v48, v48, s22, 0.5
v_fma_f32 v47, v47, s22, 0.5
v_mul_f32_e32 v45, v54, v45
v_cvt_i32_f32_e32 v48, v48
v_cvt_i32_f32_e32 v47, v47
v_fma_f32 v46, v46, s22, 0.5
v_fma_f32 v45, v45, s22, 0.5
v_cvt_i32_f32_e32 v46, v46
v_cvt_i32_f32_e32 v45, v45
v_med3_i32 v49, v49, 0, s23
v_med3_i32 v50, v50, 0, s23
v_add_u32_e32 v53, v50, v49
v_med3_i32 v51, v51, 0, v177
v_med3_i32 v52, v52, 0, v177
v_add3_u32 v53, v53, v51, v52
v_med3_i32 v48, v48, 0, v177
v_med3_i32 v47, v47, 0, v177
v_add3_u32 v53, v53, v48, v47
v_med3_i32 v46, v46, 0, v177
v_med3_i32 v54, v45, 0, v177
v_add3_u32 v45, v53, v46, v54
ds_bpermute_b32 v53, v36, v45
v_sub_f32_e32 v44, v44, v0
v_mul_f32_e32 v44, 0x3fb8aa3b, v44
v_cmp_gt_f32_e32 vcc, s21, v44
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v44, v44, v61
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v45, v45, v53
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v44
ds_bpermute_b32 v53, v34, v45
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v44, v44, v61
v_sub_f32_e32 v43, v43, v0
v_exp_f32_e32 v61, v44
v_mul_f32_e32 v43, 0x3fb8aa3b, v43
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v44, v45, v53
v_cndmask_b32_e32 v53, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v43
v_mul_f32_e32 v53, v61, v53
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v43, v43, v61
v_mul_f32_e32 v53, v58, v53
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v43
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v43, v43, v61
v_sub_f32_e32 v42, v42, v0
v_exp_f32_e32 v43, v43
v_mul_f32_e32 v42, 0x3fb8aa3b, v42
v_cndmask_b32_e32 v61, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v42
v_mul_f32_e32 v43, v43, v61
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v42, v42, v61
v_mul_f32_e32 v43, v58, v43
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v42
v_cndmask_b32_e32 v61, 0, v176, vcc
v_add_f32_e32 v42, v42, v61
v_sub_f32_e32 v41, v41, v0
v_exp_f32_e32 v42, v42
v_mul_f32_e32 v41, 0x3fb8aa3b, v41
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v41
v_mul_f32_e32 v42, v42, v178
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v41, v41, v178
v_mul_f32_e32 v42, v58, v42
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v41
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v41, v41, v178
v_sub_f32_e32 v40, v40, v0
v_exp_f32_e32 v41, v41
v_mul_f32_e32 v40, 0x3fb8aa3b, v40
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v40
v_mul_f32_e32 v41, v41, v178
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v40, v40, v178
v_mul_f32_e32 v41, v58, v41
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v40
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v40, v40, v178
v_sub_f32_e32 v39, v39, v0
v_exp_f32_e32 v40, v40
v_mul_f32_e32 v39, 0x3fb8aa3b, v39
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v39
v_mul_f32_e32 v40, v40, v178
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v39, v39, v178
v_mul_f32_e32 v40, v58, v40
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v39
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v39, v39, v178
v_sub_f32_e32 v38, v38, v0
v_exp_f32_e32 v39, v39
v_mul_f32_e32 v38, 0x3fb8aa3b, v38
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v38
v_mul_f32_e32 v39, v39, v178
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v38, v38, v178
v_mul_f32_e32 v39, v58, v39
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v38
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v38, v38, v178
v_sub_f32_e32 v35, v35, v0
v_exp_f32_e32 v38, v38
v_mul_f32_e32 v35, 0x3fb8aa3b, v35
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v35
v_mul_f32_e32 v38, v38, v178
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v35, v35, v178
v_mul_f32_e32 v38, v58, v38
v_cndmask_b32_e32 v58, 1.0, v175, vcc
v_cmp_gt_f32_e32 vcc, s21, v35
v_cndmask_b32_e32 v178, 0, v176, vcc
v_add_f32_e32 v35, v35, v178
v_fma_f32 v53, v53, s22, 0.5
v_exp_f32_e32 v35, v35
v_fma_f32 v43, v43, s22, 0.5
v_cndmask_b32_e32 v178, 1.0, v175, vcc
v_cvt_i32_f32_e32 v53, v53
v_cvt_i32_f32_e32 v43, v43
v_fma_f32 v42, v42, s22, 0.5
v_fma_f32 v41, v41, s22, 0.5
v_mul_f32_e32 v35, v35, v178
v_cvt_i32_f32_e32 v42, v42
v_cvt_i32_f32_e32 v41, v41
v_fma_f32 v40, v40, s22, 0.5
v_fma_f32 v39, v39, s22, 0.5
v_mul_f32_e32 v35, v58, v35
v_cvt_i32_f32_e32 v40, v40
v_cvt_i32_f32_e32 v39, v39
v_fma_f32 v38, v38, s22, 0.5
v_fma_f32 v35, v35, s22, 0.5
v_cvt_i32_f32_e32 v38, v38
v_cvt_i32_f32_e32 v35, v35
v_med3_i32 v53, v53, 0, v177
v_med3_i32 v43, v43, 0, v177
v_add_u32_e32 v61, v43, v53
v_med3_i32 v42, v42, 0, v177
v_med3_i32 v41, v41, 0, v177
v_add3_u32 v61, v61, v42, v41
v_med3_i32 v40, v40, 0, v177
v_med3_i32 v39, v39, 0, v177
v_add3_u32 v58, v61, v40, v39
v_med3_i32 v38, v38, 0, v177
v_med3_i32 v61, v35, 0, v177
v_add3_u32 v35, v58, v38, v61
ds_bpermute_b32 v36, v36, v35
v_lshlrev_b32_e32 v46, 16, v46
v_lshlrev_b32_e32 v51, 16, v51
v_lshl_or_b32 v50, v50, 8, v51
v_lshlrev_b32_e32 v51, 24, v52
s_waitcnt lgkmcnt(0)
v_add_u32_e32 v35, v35, v36
v_lshl_or_b32 v36, v47, 8, v46
v_lshlrev_b32_e32 v46, 24, v54
v_or3_b32 v36, v36, v46, v48
buffer_load_dword v46, off, s[36:39], 0 offset:12
ds_bpermute_b32 v34, v34, v35
v_or3_b32 v49, v50, v51, v49
ds_bpermute_b32 v45, v37, v44
s_waitcnt lgkmcnt(1)
v_add_u32_e32 v34, v35, v34
ds_bpermute_b32 v35, v37, v34
v_lshlrev_b32_e32 v37, 24, v41
s_waitcnt vmcnt(0)
ds_write2_b32 v46, v49, v36 offset1:68
v_lshlrev_b32_e32 v36, 16, v42
v_lshl_or_b32 v36, v43, 8, v36
v_or3_b32 v36, v36, v37, v53
v_lshlrev_b32_e32 v37, 16, v38
v_lshl_or_b32 v37, v39, 8, v37
v_lshlrev_b32_e32 v38, 24, v61
v_or3_b32 v37, v37, v38, v40
buffer_load_dword v38, off, s[36:39], 0 offset:16
s_waitcnt vmcnt(0)
ds_write2_b32 v38, v36, v37 offset1:68
s_and_saveexec_b64 s[12:13], s[4:5]
s_cbranch_execz 174
buffer_load_dword v46, off, s[36:39], 0 offset:28
buffer_load_dword v47, off, s[36:39], 0 offset:52
v_max_f32_e32 v37, v33, v33
s_waitcnt lgkmcnt(3)
v_add_u32_e32 v42, v44, v45
s_waitcnt lgkmcnt(2)
v_add_u32_e32 v34, v34, v35
v_cvt_f32_i32_e32 v34, v34
buffer_load_dword v45, off, s[36:39], 0 offset:64
s_waitcnt vmcnt(2)
ds_read_b32 v36, v46
s_waitcnt vmcnt(1)
ds_read_b32 v40, v47
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v38, v36, v36
v_max_f32_e32 v37, v38, v37
v_sub_f32_e32 v33, v33, v37
v_mul_f32_e32 v33, 0x3fb8aa3b, v33
v_cmp_gt_f32_e32 vcc, s21, v33
v_cndmask_b32_e32 v38, 0, v176, vcc
v_add_f32_e32 v33, v33, v38
v_cmp_gt_f32_e64 s[6:7], s21, v33
v_cndmask_b32_e64 v38, 0, v176, s[6:7]
v_add_f32_e32 v33, v33, v38
v_cndmask_b32_e64 v39, 1.0, v175, s[6:7]
v_exp_f32_e32 v33, v33
v_cndmask_b32_e32 v38, 1.0, v175, vcc
v_sub_f32_e32 v36, v36, v37
v_mul_f32_e32 v36, 0x3fb8aa3b, v36
v_mul_f32_e32 v33, v33, v39
v_mul_f32_e32 v33, v38, v33
v_div_scale_f32 v38, s[6:7], s22, s22, v33
v_div_scale_f32 v39, vcc, v33, s22, v33
ds_write_b32 v46, v37
v_rcp_f32_e32 v41, v38
v_fma_f32 v43, -v38, v41, 1.0
v_fmac_f32_e32 v41, v43, v41
v_mul_f32_e32 v43, v39, v41
v_fma_f32 v44, -v38, v43, v39
v_fmac_f32_e32 v43, v44, v41
v_fma_f32 v38, -v38, v43, v39
v_div_fmas_f32 v38, v38, v41, v43
v_cmp_gt_f32_e32 vcc, s21, v36
v_cndmask_b32_e32 v39, 0, v176, vcc
v_add_f32_e32 v36, v36, v39
v_cmp_gt_f32_e64 s[6:7], s21, v36
v_cndmask_b32_e64 v39, 0, v176, s[6:7]
v_add_f32_e32 v36, v36, v39
v_cvt_f32_i32_e32 v39, v42
v_exp_f32_e32 v36, v36
v_cndmask_b32_e64 v42, 1.0, v175, s[6:7]
v_cndmask_b32_e32 v41, 1.0, v175, vcc
v_mul_f32_e32 v36, v36, v42
v_mul_f32_e32 v36, v41, v36
buffer_load_dword v41, off, s[36:39], 0 offset:44
buffer_load_dword v42, off, s[36:39], 0 offset:48
buffer_load_dword v44, off, s[36:39], 0 offset:32
s_waitcnt vmcnt(2)
ds_write_b32 v41, v36
v_mul_f32_e32 v41, 0x3c010204, v33
v_div_fixup_f32 v33, v38, s22, v33
v_mul_f32_e32 v33, v39, v33
s_waitcnt lgkmcnt(2)
v_fmac_f32_e32 v33, v40, v36
s_waitcnt vmcnt(1)
ds_write_b32 v42, v41
ds_write_b32 v47, v33
s_waitcnt vmcnt(0)
ds_read_b32 v33, v44
ds_read_b32 v37, v45
v_max_f32_e32 v36, v0, v0
s_waitcnt lgkmcnt(1)
v_max_f32_e32 v38, v33, v33
v_max_f32_e32 v36, v38, v36
v_sub_f32_e32 v0, v0, v36
v_mul_f32_e32 v0, 0x3fb8aa3b, v0
v_cmp_gt_f32_e32 vcc, s21, v0
v_cndmask_b32_e32 v38, 0, v176, vcc
v_add_f32_e32 v0, v0, v38
v_cmp_gt_f32_e64 s[6:7], s21, v0
v_cndmask_b32_e64 v38, 0, v176, s[6:7]
v_add_f32_e32 v0, v0, v38
v_cndmask_b32_e64 v39, 1.0, v175, s[6:7]
v_exp_f32_e32 v0, v0
v_cndmask_b32_e32 v38, 1.0, v175, vcc
v_sub_f32_e32 v33, v33, v36
v_mul_f32_e32 v33, 0x3fb8aa3b, v33
v_mul_f32_e32 v0, v0, v39
v_mul_f32_e32 v0, v38, v0
v_div_scale_f32 v38, s[6:7], s22, s22, v0
v_div_scale_f32 v39, vcc, v0, s22, v0
v_cmp_gt_f32_e64 s[6:7], s21, v33
v_cndmask_b32_e64 v41, 0, v176, s[6:7]
v_add_f32_e32 v33, v33, v41
ds_write_b32 v44, v36
buffer_load_dword v36, off, s[36:39], 0 offset:60
v_rcp_f32_e32 v40, v38
v_fma_f32 v42, -v38, v40, 1.0
v_fmac_f32_e32 v40, v42, v40
v_mul_f32_e32 v42, v39, v40
v_fma_f32 v43, -v38, v42, v39
v_fmac_f32_e32 v42, v43, v40
v_fma_f32 v38, -v38, v42, v39
v_div_fmas_f32 v38, v38, v40, v42
v_cmp_gt_f32_e32 vcc, s21, v33
v_cndmask_b32_e32 v39, 0, v176, vcc
v_add_f32_e32 v33, v33, v39
v_cndmask_b32_e32 v35, 1.0, v175, vcc
v_exp_f32_e32 v33, v33
v_cndmask_b32_e64 v39, 1.0, v175, s[6:7]
v_mul_f32_e32 v33, v33, v35
buffer_load_dword v35, off, s[36:39], 0 offset:56
v_mul_f32_e32 v33, v39, v33
s_waitcnt vmcnt(0)
ds_write_b32 v35, v33
v_mul_f32_e32 v35, 0x3c010204, v0
v_div_fixup_f32 v0, v38, s22, v0
v_mul_f32_e32 v0, v34, v0
s_waitcnt lgkmcnt(2)
v_fmac_f32_e32 v0, v37, v33
ds_write_b32 v36, v35
ds_write_b32 v45, v0
s_or_b64 exec, exec, s[12:13]
s_andn2_b64 vcc, exec, s[10:11]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccnz 54
buffer_load_dword v0, off, s[36:39], 0 offset:36
s_waitcnt vmcnt(0)
ds_write2_b32 v0, v5, v6 offset1:68
ds_write2_b32 v0, v7, v8 offset0:136 offset1:204
buffer_load_dword v0, off, s[36:39], 0 offset:68
s_waitcnt vmcnt(0)
ds_write2_b32 v0, v1, v2 offset1:68
ds_write2_b32 v0, v3, v4 offset0:136 offset1:204
buffer_load_dword v0, off, s[36:39], 0 offset:72
s_waitcnt vmcnt(0)
ds_write2_b32 v0, v13, v14 offset1:68
ds_write2_b32 v0, v15, v16 offset0:136 offset1:204
buffer_load_dword v0, off, s[36:39], 0 offset:76
s_waitcnt vmcnt(0)
ds_write2_b32 v0, v9, v10 offset1:68
ds_write2_b32 v0, v11, v12 offset0:136 offset1:204
s_and_saveexec_b64 s[6:7], s[0:1]
s_cbranch_execz 23
buffer_load_dword v33, off, s[36:39], 0 offset:88
s_nop 0
buffer_load_dword v34, off, s[36:39], 0 offset:92
s_add_i32 s12, s20, 64
v_mov_b32_e32 v0, s15
s_waitcnt vmcnt(1)
v_add_co_u32_e32 v33, vcc, s12, v33
s_waitcnt vmcnt(0)
v_addc_co_u32_e32 v34, vcc, 0, v34, vcc
v_lshlrev_b64 v[33:34], 2, v[33:34]
v_add_co_u32_e32 v33, vcc, s14, v33
v_addc_co_u32_e32 v34, vcc, v0, v34, vcc
global_load_dword v0, v[33:34], off
s_nop 0
buffer_load_dword v33, off, s[36:39], 0 offset:96
s_waitcnt vmcnt(0)
ds_write_b32 v33, v0
s_or_b64 exec, exec, s[6:7]
ds_read_b128 v[37:40], v166
ds_read_b96 v[52:54], v166 offset:16
buffer_load_dword v0, off, s[36:39], 0 offset:20
s_waitcnt vmcnt(0)
ds_read_b32 v58, v0
ds_read_b128 v[33:36], v168
ds_read_b96 v[49:51], v168 offset:16
buffer_load_dword v0, off, s[36:39], 0 offset:24
s_waitcnt vmcnt(0)
ds_read_b32 v0, v0
ds_read_b128 v[41:44], v170
ds_read_b128 v[45:48], v170 offset:16
ds_read_b128 v[178:181], v136
ds_read_b128 v[182:185], v136 offset:512
ds_read_b128 v[186:189], v170 offset:272
ds_read_b128 v[190:193], v170 offset:288
ds_read_b128 v[194:197], v136 offset:1040
ds_read_b128 v[198:201], v136 offset:1552
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v172
v_dot4_i32_i8 v202, v41, v179, v172
v_dot4_i32_i8 v203, v41, v180, v172
v_dot4_i32_i8 v204, v41, v181, v172
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v172
v_dot4_i32_i8 v206, v41, v183, v172
v_dot4_i32_i8 v207, v41, v184, v172
v_dot4_i32_i8 v208, v41, v185, v172
v_dot4_i32_i8 v209, v42, v178, v172
v_dot4_i32_i8 v210, v42, v179, v172
v_dot4_i32_i8 v211, v42, v180, v172
v_dot4_i32_i8 v212, v42, v181, v172
v_dot4_i32_i8 v213, v42, v182, v172
v_dot4_i32_i8 v214, v42, v183, v172
v_dot4_i32_i8 v215, v42, v184, v172
v_dot4_i32_i8 v216, v42, v185, v172
v_dot4_i32_i8 v217, v43, v178, v172
v_dot4_i32_i8 v218, v43, v179, v172
v_dot4_i32_i8 v219, v43, v180, v172
v_dot4_i32_i8 v220, v43, v181, v172
v_dot4_i32_i8 v221, v43, v182, v172
v_dot4_i32_i8 v222, v43, v183, v172
v_dot4_i32_i8 v223, v43, v184, v172
v_dot4_i32_i8 v224, v43, v185, v172
v_dot4_i32_i8 v225, v44, v178, v172
v_dot4_i32_i8 v226, v44, v179, v172
v_dot4_i32_i8 v227, v44, v180, v172
v_dot4_i32_i8 v228, v44, v181, v172
v_dot4_i32_i8 v229, v44, v182, v172
v_dot4_i32_i8 v230, v44, v183, v172
v_dot4_i32_i8 v231, v44, v184, v172
v_dot4_i32_i8 v232, v44, v185, v172
v_dot4_i32_i8 v233, v45, v178, v172
v_dot4_i32_i8 v234, v45, v179, v172
v_dot4_i32_i8 v235, v45, v180, v172
v_dot4_i32_i8 v236, v45, v181, v172
v_dot4_i32_i8 v237, v45, v182, v172
v_dot4_i32_i8 v238, v45, v183, v172
v_dot4_i32_i8 v239, v45, v184, v172
v_dot4_i32_i8 v240, v45, v185, v172
v_dot4_i32_i8 v241, v46, v178, v172
v_dot4_i32_i8 v242, v46, v179, v172
v_dot4_i32_i8 v243, v46, v180, v172
v_dot4_i32_i8 v244, v46, v181, v172
v_dot4_i32_i8 v245, v46, v182, v172
v_dot4_i32_i8 v246, v46, v183, v172
v_dot4_i32_i8 v247, v46, v184, v172
v_dot4_i32_i8 v248, v46, v185, v172
v_dot4_i32_i8 v249, v47, v178, v172
v_dot4_i32_i8 v250, v47, v179, v172
v_dot4_i32_i8 v251, v47, v180, v172
v_dot4_i32_i8 v252, v47, v181, v172
v_dot4_i32_i8 v253, v47, v182, v172
v_dot4_i32_i8 v254, v47, v183, v172
v_dot4_i32_i8 v255, v47, v184, v172
v_dot4_i32_i8 v64, v47, v185, v172
v_dot4_i32_i8 v63, v48, v178, v172
v_dot4_i32_i8 v135, v48, v179, v172
v_dot4_i32_i8 v137, v48, v180, v172
v_dot4_i32_i8 v157, v48, v181, v172
v_dot4_i32_i8 v158, v48, v182, v172
v_dot4_i32_i8 v160, v48, v183, v172
v_dot4_i32_i8 v161, v48, v184, v172
v_dot4_i32_i8 v65, v48, v185, v62
ds_read_b128 v[41:44], v170 offset:544
ds_read_b128 v[45:48], v170 offset:560
ds_read_b128 v[178:181], v136 offset:2080
ds_read_b128 v[182:185], v136 offset:2592
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:816
ds_read_b128 v[190:193], v170 offset:832
ds_read_b128 v[194:197], v136 offset:3120
ds_read_b128 v[198:201], v136 offset:3632
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:1088
ds_read_b128 v[45:48], v170 offset:1104
ds_read_b128 v[178:181], v136 offset:4160
ds_read_b128 v[182:185], v136 offset:4672
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:1360
ds_read_b128 v[190:193], v170 offset:1376
ds_read_b128 v[194:197], v136 offset:5200
ds_read_b128 v[198:201], v136 offset:5712
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:1632
ds_read_b128 v[45:48], v170 offset:1648
ds_read_b128 v[178:181], v136 offset:6240
ds_read_b128 v[182:185], v136 offset:6752
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:1904
ds_read_b128 v[190:193], v170 offset:1920
ds_read_b128 v[194:197], v136 offset:7280
ds_read_b128 v[198:201], v136 offset:7792
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:2176
ds_read_b128 v[45:48], v170 offset:2192
ds_read_b128 v[178:181], v136 offset:8320
ds_read_b128 v[182:185], v136 offset:8832
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:2448
ds_read_b128 v[190:193], v170 offset:2464
ds_read_b128 v[194:197], v136 offset:9360
ds_read_b128 v[198:201], v136 offset:9872
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:2720
ds_read_b128 v[45:48], v170 offset:2736
ds_read_b128 v[178:181], v136 offset:10400
ds_read_b128 v[182:185], v136 offset:10912
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:2992
ds_read_b128 v[190:193], v170 offset:3008
ds_read_b128 v[194:197], v136 offset:11440
ds_read_b128 v[198:201], v136 offset:11952
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:3264
ds_read_b128 v[45:48], v170 offset:3280
ds_read_b128 v[178:181], v136 offset:12480
ds_read_b128 v[182:185], v136 offset:12992
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v240, v190, v201, v240
v_dot4_i32_i8 v241, v191, v194, v241
v_dot4_i32_i8 v242, v191, v195, v242
v_dot4_i32_i8 v243, v191, v196, v243
v_dot4_i32_i8 v244, v191, v197, v244
v_dot4_i32_i8 v245, v191, v198, v245
v_dot4_i32_i8 v246, v191, v199, v246
v_dot4_i32_i8 v247, v191, v200, v247
v_dot4_i32_i8 v248, v191, v201, v248
v_dot4_i32_i8 v249, v192, v194, v249
v_dot4_i32_i8 v250, v192, v195, v250
v_dot4_i32_i8 v251, v192, v196, v251
v_dot4_i32_i8 v252, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:3536
ds_read_b128 v[190:193], v170 offset:3552
ds_read_b128 v[194:197], v136 offset:13520
ds_read_b128 v[198:201], v136 offset:14032
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v202, v41, v179, v202
v_dot4_i32_i8 v203, v41, v180, v203
v_dot4_i32_i8 v204, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v41, v182, v205
v_dot4_i32_i8 v206, v41, v183, v206
v_dot4_i32_i8 v207, v41, v184, v207
v_dot4_i32_i8 v208, v41, v185, v208
v_dot4_i32_i8 v209, v42, v178, v209
v_dot4_i32_i8 v210, v42, v179, v210
v_dot4_i32_i8 v211, v42, v180, v211
v_dot4_i32_i8 v212, v42, v181, v212
v_dot4_i32_i8 v213, v42, v182, v213
v_dot4_i32_i8 v214, v42, v183, v214
v_dot4_i32_i8 v215, v42, v184, v215
v_dot4_i32_i8 v216, v42, v185, v216
v_dot4_i32_i8 v217, v43, v178, v217
v_dot4_i32_i8 v218, v43, v179, v218
v_dot4_i32_i8 v219, v43, v180, v219
v_dot4_i32_i8 v220, v43, v181, v220
v_dot4_i32_i8 v221, v43, v182, v221
v_dot4_i32_i8 v222, v43, v183, v222
v_dot4_i32_i8 v223, v43, v184, v223
v_dot4_i32_i8 v224, v43, v185, v224
v_dot4_i32_i8 v225, v44, v178, v225
v_dot4_i32_i8 v226, v44, v179, v226
v_dot4_i32_i8 v227, v44, v180, v227
v_dot4_i32_i8 v228, v44, v181, v228
v_dot4_i32_i8 v229, v44, v182, v229
v_dot4_i32_i8 v230, v44, v183, v230
v_dot4_i32_i8 v231, v44, v184, v231
v_dot4_i32_i8 v232, v44, v185, v232
v_dot4_i32_i8 v233, v45, v178, v233
v_dot4_i32_i8 v234, v45, v179, v234
v_dot4_i32_i8 v235, v45, v180, v235
v_dot4_i32_i8 v236, v45, v181, v236
v_dot4_i32_i8 v237, v45, v182, v237
v_dot4_i32_i8 v238, v45, v183, v238
v_dot4_i32_i8 v239, v45, v184, v239
v_dot4_i32_i8 v240, v45, v185, v240
v_dot4_i32_i8 v241, v46, v178, v241
v_dot4_i32_i8 v242, v46, v179, v242
v_dot4_i32_i8 v243, v46, v180, v243
v_dot4_i32_i8 v244, v46, v181, v244
v_dot4_i32_i8 v245, v46, v182, v245
v_dot4_i32_i8 v246, v46, v183, v246
v_dot4_i32_i8 v247, v46, v184, v247
v_dot4_i32_i8 v248, v46, v185, v248
v_dot4_i32_i8 v249, v47, v178, v249
v_dot4_i32_i8 v250, v47, v179, v250
v_dot4_i32_i8 v251, v47, v180, v251
v_dot4_i32_i8 v252, v47, v181, v252
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v64, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v135, v48, v179, v135
v_dot4_i32_i8 v137, v48, v180, v137
v_dot4_i32_i8 v157, v48, v181, v157
v_dot4_i32_i8 v158, v48, v182, v158
v_dot4_i32_i8 v160, v48, v183, v160
v_dot4_i32_i8 v161, v48, v184, v161
v_dot4_i32_i8 v65, v48, v185, v65
ds_read_b128 v[41:44], v170 offset:3808
ds_read_b128 v[45:48], v170 offset:3824
ds_read_b128 v[178:181], v136 offset:14560
ds_read_b128 v[182:185], v136 offset:15072
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v186, v194, v61
v_dot4_i32_i8 v202, v186, v195, v202
v_dot4_i32_i8 v203, v186, v196, v203
v_dot4_i32_i8 v204, v186, v197, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v205, v186, v198, v205
v_dot4_i32_i8 v206, v186, v199, v206
v_dot4_i32_i8 v207, v186, v200, v207
v_dot4_i32_i8 v208, v186, v201, v208
v_dot4_i32_i8 v209, v187, v194, v209
v_dot4_i32_i8 v210, v187, v195, v210
v_dot4_i32_i8 v211, v187, v196, v211
v_dot4_i32_i8 v212, v187, v197, v212
v_dot4_i32_i8 v213, v187, v198, v213
v_dot4_i32_i8 v214, v187, v199, v214
v_dot4_i32_i8 v215, v187, v200, v215
v_dot4_i32_i8 v216, v187, v201, v216
v_dot4_i32_i8 v217, v188, v194, v217
v_dot4_i32_i8 v218, v188, v195, v218
v_dot4_i32_i8 v219, v188, v196, v219
v_dot4_i32_i8 v220, v188, v197, v220
v_dot4_i32_i8 v221, v188, v198, v221
v_dot4_i32_i8 v222, v188, v199, v222
v_dot4_i32_i8 v223, v188, v200, v223
v_dot4_i32_i8 v224, v188, v201, v224
v_dot4_i32_i8 v225, v189, v194, v225
v_dot4_i32_i8 v226, v189, v195, v226
v_dot4_i32_i8 v227, v189, v196, v227
v_dot4_i32_i8 v228, v189, v197, v228
v_dot4_i32_i8 v229, v189, v198, v229
v_dot4_i32_i8 v230, v189, v199, v230
v_dot4_i32_i8 v231, v189, v200, v231
v_dot4_i32_i8 v232, v189, v201, v232
v_dot4_i32_i8 v233, v190, v194, v233
v_dot4_i32_i8 v234, v190, v195, v234
v_dot4_i32_i8 v235, v190, v196, v235
v_dot4_i32_i8 v236, v190, v197, v236
v_dot4_i32_i8 v237, v190, v198, v237
v_dot4_i32_i8 v238, v190, v199, v238
v_dot4_i32_i8 v239, v190, v200, v239
v_dot4_i32_i8 v190, v190, v201, v240
v_dot4_i32_i8 v240, v191, v194, v241
v_dot4_i32_i8 v72, v191, v195, v242
v_dot4_i32_i8 v159, v191, v196, v243
v_dot4_i32_i8 v162, v191, v197, v244
v_dot4_i32_i8 v163, v191, v198, v245
v_dot4_i32_i8 v155, v191, v199, v246
v_dot4_i32_i8 v156, v191, v200, v247
v_dot4_i32_i8 v191, v191, v201, v248
v_dot4_i32_i8 v164, v192, v194, v249
v_dot4_i32_i8 v165, v192, v195, v250
v_dot4_i32_i8 v167, v192, v196, v251
v_dot4_i32_i8 v169, v192, v197, v252
v_dot4_i32_i8 v253, v192, v198, v253
v_dot4_i32_i8 v254, v192, v199, v254
v_dot4_i32_i8 v255, v192, v200, v255
v_dot4_i32_i8 v64, v192, v201, v64
v_dot4_i32_i8 v63, v193, v194, v63
v_dot4_i32_i8 v135, v193, v195, v135
v_dot4_i32_i8 v137, v193, v196, v137
v_dot4_i32_i8 v157, v193, v197, v157
v_dot4_i32_i8 v158, v193, v198, v158
v_dot4_i32_i8 v160, v193, v199, v160
v_dot4_i32_i8 v161, v193, v200, v161
v_dot4_i32_i8 v65, v193, v201, v65
ds_read_b128 v[186:189], v170 offset:4080
ds_read_b128 v[241:244], v170 offset:4096
ds_read_b128 v[245:248], v136 offset:15600
ds_read_b128 v[249:252], v136 offset:16112
s_waitcnt lgkmcnt(5)
v_dot4_i32_i8 v61, v41, v178, v61
v_dot4_i32_i8 v192, v41, v179, v202
v_dot4_i32_i8 v193, v41, v180, v203
v_dot4_i32_i8 v194, v41, v181, v204
s_waitcnt lgkmcnt(4)
v_dot4_i32_i8 v195, v41, v182, v205
v_dot4_i32_i8 v196, v41, v183, v206
v_dot4_i32_i8 v197, v41, v184, v207
v_dot4_i32_i8 v41, v41, v185, v208
v_dot4_i32_i8 v198, v42, v178, v209
v_dot4_i32_i8 v199, v42, v179, v210
v_dot4_i32_i8 v200, v42, v180, v211
v_dot4_i32_i8 v201, v42, v181, v212
v_dot4_i32_i8 v202, v42, v182, v213
v_dot4_i32_i8 v203, v42, v183, v214
v_dot4_i32_i8 v204, v42, v184, v215
v_dot4_i32_i8 v42, v42, v185, v216
v_dot4_i32_i8 v205, v43, v178, v217
v_dot4_i32_i8 v206, v43, v179, v218
v_dot4_i32_i8 v207, v43, v180, v219
v_dot4_i32_i8 v208, v43, v181, v220
v_dot4_i32_i8 v209, v43, v182, v221
v_dot4_i32_i8 v210, v43, v183, v222
v_dot4_i32_i8 v211, v43, v184, v223
v_dot4_i32_i8 v43, v43, v185, v224
v_dot4_i32_i8 v212, v44, v178, v225
v_dot4_i32_i8 v213, v44, v179, v226
v_dot4_i32_i8 v214, v44, v180, v227
v_dot4_i32_i8 v55, v44, v181, v228
v_dot4_i32_i8 v56, v44, v182, v229
v_dot4_i32_i8 v140, v44, v183, v230
v_dot4_i32_i8 v141, v44, v184, v231
v_dot4_i32_i8 v44, v44, v185, v232
v_dot4_i32_i8 v115, v45, v178, v233
v_dot4_i32_i8 v153, v45, v179, v234
v_dot4_i32_i8 v154, v45, v180, v235
v_dot4_i32_i8 v132, v45, v181, v236
v_dot4_i32_i8 v142, v45, v182, v237
v_dot4_i32_i8 v143, v45, v183, v238
v_dot4_i32_i8 v145, v45, v184, v239
v_dot4_i32_i8 v45, v45, v185, v190
v_dot4_i32_i8 v190, v46, v178, v240
v_dot4_i32_i8 v72, v46, v179, v72
v_dot4_i32_i8 v159, v46, v180, v159
v_dot4_i32_i8 v162, v46, v181, v162
v_dot4_i32_i8 v163, v46, v182, v163
v_dot4_i32_i8 v155, v46, v183, v155
v_dot4_i32_i8 v156, v46, v184, v156
v_dot4_i32_i8 v46, v46, v185, v191
v_dot4_i32_i8 v164, v47, v178, v164
v_dot4_i32_i8 v165, v47, v179, v165
v_dot4_i32_i8 v167, v47, v180, v167
v_dot4_i32_i8 v169, v47, v181, v169
v_dot4_i32_i8 v253, v47, v182, v253
v_dot4_i32_i8 v254, v47, v183, v254
v_dot4_i32_i8 v255, v47, v184, v255
v_dot4_i32_i8 v47, v47, v185, v64
v_dot4_i32_i8 v63, v48, v178, v63
v_dot4_i32_i8 v64, v48, v179, v135
v_dot4_i32_i8 v135, v48, v180, v137
v_dot4_i32_i8 v137, v48, v181, v157
v_dot4_i32_i8 v157, v48, v182, v158
v_dot4_i32_i8 v158, v48, v183, v160
v_dot4_i32_i8 v160, v48, v184, v161
v_dot4_i32_i8 v48, v48, v185, v65
s_waitcnt lgkmcnt(1)
v_dot4_i32_i8 v240, v186, v245, v61
v_dot4_i32_i8 v239, v186, v246, v192
v_dot4_i32_i8 v238, v186, v247, v193
v_dot4_i32_i8 v237, v186, v248, v194
s_waitcnt lgkmcnt(0)
v_dot4_i32_i8 v236, v186, v249, v195
v_dot4_i32_i8 v235, v186, v250, v196
v_dot4_i32_i8 v234, v186, v251, v197
v_dot4_i32_i8 v233, v186, v252, v41
v_dot4_i32_i8 v232, v187, v245, v198
v_dot4_i32_i8 v231, v187, v246, v199
v_dot4_i32_i8 v230, v187, v247, v200
v_dot4_i32_i8 v229, v187, v248, v201
v_dot4_i32_i8 v228, v187, v249, v202
v_dot4_i32_i8 v227, v187, v250, v203
v_dot4_i32_i8 v226, v187, v251, v204
v_dot4_i32_i8 v225, v187, v252, v42
v_dot4_i32_i8 v224, v188, v245, v205
v_dot4_i32_i8 v223, v188, v246, v206
v_dot4_i32_i8 v222, v188, v247, v207
v_dot4_i32_i8 v221, v188, v248, v208
v_dot4_i32_i8 v220, v188, v249, v209
v_dot4_i32_i8 v219, v188, v250, v210
v_dot4_i32_i8 v218, v188, v251, v211
v_dot4_i32_i8 v217, v188, v252, v43
v_dot4_i32_i8 v216, v189, v245, v212
v_dot4_i32_i8 v215, v189, v246, v213
v_dot4_i32_i8 v214, v189, v247, v214
v_dot4_i32_i8 v213, v189, v248, v55
v_dot4_i32_i8 v212, v189, v249, v56
v_dot4_i32_i8 v211, v189, v250, v140
v_dot4_i32_i8 v210, v189, v251, v141
v_dot4_i32_i8 v209, v189, v252, v44
v_dot4_i32_i8 v208, v241, v245, v115
v_dot4_i32_i8 v207, v241, v246, v153
v_dot4_i32_i8 v206, v241, v247, v154
v_dot4_i32_i8 v205, v241, v248, v132
v_dot4_i32_i8 v204, v241, v249, v142
v_dot4_i32_i8 v203, v241, v250, v143
v_dot4_i32_i8 v202, v241, v251, v145
v_dot4_i32_i8 v201, v241, v252, v45
v_dot4_i32_i8 v200, v242, v245, v190
v_dot4_i32_i8 v199, v242, v246, v72
v_dot4_i32_i8 v198, v242, v247, v159
v_dot4_i32_i8 v197, v242, v248, v162
v_dot4_i32_i8 v196, v242, v249, v163
v_dot4_i32_i8 v195, v242, v250, v155
v_dot4_i32_i8 v194, v242, v251, v156
v_dot4_i32_i8 v193, v242, v252, v46
v_dot4_i32_i8 v192, v243, v245, v164
v_dot4_i32_i8 v191, v243, v246, v165
v_dot4_i32_i8 v190, v243, v247, v167
v_dot4_i32_i8 v189, v243, v248, v169
v_dot4_i32_i8 v188, v243, v249, v253
v_dot4_i32_i8 v187, v243, v250, v254
v_dot4_i32_i8 v186, v243, v251, v255
v_dot4_i32_i8 v185, v243, v252, v47
v_dot4_i32_i8 v184, v244, v245, v63
v_dot4_i32_i8 v183, v244, v246, v64
v_dot4_i32_i8 v182, v244, v247, v135
v_dot4_i32_i8 v181, v244, v248, v137
v_dot4_i32_i8 v180, v244, v249, v157
v_dot4_i32_i8 v179, v244, v250, v158
v_dot4_i32_i8 v178, v244, v251, v160
v_dot4_i32_i8 v61, v244, v252, v48
ds_read_b128 v[45:48], v171
ds_read_b128 v[41:44], v171 offset:16
s_andn2_b64 vcc, exec, s[10:11]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_vccnz 59464
buffer_load_dword v55, off, s[36:39], 0 offset:40
s_waitcnt vmcnt(0)
ds_write_b128 v55, v[21:24]
ds_write_b128 v55, v[25:28] offset:512
ds_write_b128 v55, v[29:32] offset:8320
ds_write_b128 v55, v[17:20] offset:8832
s_and_saveexec_b64 s[6:7], s[2:3]
s_cbranch_execz 59450
global_load_dword v55, v[59:60], off
buffer_load_dword v56, off, s[36:39], 0 offset:100
s_waitcnt vmcnt(0)
ds_write_b32 v56, v55
s_branch 59442
buffer_load_dword v47, off, s[36:39], 0 offset:104
buffer_load_dword v48, off, s[36:39], 0 offset:108
buffer_load_dword v46, off, s[36:39], 0 offset:112
s_lshl_b64 s[0:1], s[26:27], 10
s_add_u32 s2, s24, s0
s_waitcnt vmcnt(0)
v_add_u32_e32 v0, s28, v46
s_addc_u32 s3, s25, s1
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57856
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v130
v_mul_f32_e32 v1, v7, v131
v_mul_f32_e32 v2, v7, v129
v_mul_f32_e32 v3, v7, v128
v_mul_f32_e32 v4, v7, v127
v_mul_f32_e32 v5, v7, v126
v_mul_f32_e32 v6, v7, v125
v_mul_f32_e32 v7, v7, v124
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 1
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57860
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v123
v_mul_f32_e32 v1, v7, v122
v_mul_f32_e32 v2, v7, v121
v_mul_f32_e32 v3, v7, v120
v_mul_f32_e32 v4, v7, v119
v_mul_f32_e32 v5, v7, v118
v_mul_f32_e32 v6, v7, v117
v_mul_f32_e32 v7, v7, v116
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 2
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57864
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v114
v_mul_f32_e32 v1, v7, v113
v_mul_f32_e32 v2, v7, v112
v_mul_f32_e32 v3, v7, v111
v_mul_f32_e32 v4, v7, v110
v_mul_f32_e32 v5, v7, v109
v_mul_f32_e32 v6, v7, v108
v_mul_f32_e32 v7, v7, v107
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 3
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57868
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v106
v_mul_f32_e32 v1, v7, v105
v_mul_f32_e32 v2, v7, v104
v_mul_f32_e32 v3, v7, v103
v_mul_f32_e32 v4, v7, v102
v_mul_f32_e32 v5, v7, v101
v_mul_f32_e32 v6, v7, v100
v_mul_f32_e32 v7, v7, v99
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 4
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57872
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v98
v_mul_f32_e32 v1, v7, v97
v_mul_f32_e32 v2, v7, v96
v_mul_f32_e32 v3, v7, v95
v_mul_f32_e32 v4, v7, v94
v_mul_f32_e32 v5, v7, v93
v_mul_f32_e32 v6, v7, v92
v_mul_f32_e32 v7, v7, v91
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 5
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57876
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v90
v_mul_f32_e32 v1, v7, v89
v_mul_f32_e32 v2, v7, v88
v_mul_f32_e32 v3, v7, v87
v_mul_f32_e32 v4, v7, v86
v_mul_f32_e32 v5, v7, v85
v_mul_f32_e32 v6, v7, v84
v_mul_f32_e32 v7, v7, v83
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_add3_u32 v0, s28, v46, 6
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v46
ds_read_b32 v2, v1 offset:57880
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[4:5], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v82
v_mul_f32_e32 v1, v7, v81
v_mul_f32_e32 v2, v7, v80
v_mul_f32_e32 v3, v7, v79
v_mul_f32_e32 v4, v7, v78
v_mul_f32_e32 v5, v7, v77
v_mul_f32_e32 v6, v7, v76
v_mul_f32_e32 v7, v7, v75
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_or_b64 exec, exec, s[0:1]
v_or_b32_e32 v1, 7, v48
v_add_u32_e32 v0, s28, v1
v_cmp_gt_i32_e32 vcc, s16, v0
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 44
v_lshlrev_b32_e32 v1, 2, v1
ds_read_b32 v2, v1 offset:57856
s_waitcnt lgkmcnt(0)
v_div_scale_f32 v1, s[0:1], v2, v2, 1.0
v_div_scale_f32 v3, vcc, 1.0, v2, 1.0
v_rcp_f32_e32 v4, v1
v_fma_f32 v5, -v1, v4, 1.0
v_fmac_f32_e32 v4, v5, v4
v_mul_f32_e32 v5, v3, v4
v_fma_f32 v6, -v1, v5, v3
v_fmac_f32_e32 v5, v6, v4
v_fma_f32 v1, -v1, v5, v3
v_div_fmas_f32 v3, v1, v4, v5
v_ashrrev_i32_e32 v1, 31, v0
v_lshlrev_b64 v[0:1], 10, v[0:1]
v_mov_b32_e32 v4, s3
v_lshl_or_b32 v0, v47, 2, v0
v_add_co_u32_e32 v8, vcc, s2, v0
v_addc_co_u32_e32 v9, vcc, v4, v1, vcc
v_cmp_lt_f32_e32 vcc, 0, v2
v_div_fixup_f32 v0, v3, v2, 1.0
v_cndmask_b32_e32 v7, 0, v0, vcc
v_mul_f32_e32 v0, v7, v74
v_mul_f32_e32 v1, v7, v73
v_mul_f32_e32 v2, v7, v71
v_mul_f32_e32 v3, v7, v70
v_mul_f32_e32 v4, v7, v69
v_mul_f32_e32 v5, v7, v68
v_mul_f32_e32 v6, v7, v67
v_mul_f32_e32 v7, v7, v66
global_store_dwordx4 v[8:9], v[0:3], off
global_store_dwordx4 v[8:9], v[4:7], off offset:16
s_endpgm
