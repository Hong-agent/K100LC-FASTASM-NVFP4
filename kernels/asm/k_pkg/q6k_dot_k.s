.text
k_q6k_dot_k:
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
v_mov_b32_e32 v48, 210
v_mul_lo_u32 v2, v124, v48
v_add_u32_e32 v2, v2, v120
v_mov_b32_e32 v4, s16
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v4, vcc, v4, v2
v_addc_co_u32_e32 v5, vcc, v5, v3, vcc
v_mov_b32_e32 v44, v4
v_mov_b32_e32 v45, v5
v_mov_b32_e32 v46, 208
v_add_co_u32_e32 v44, vcc, v44, v46
v_addc_co_u32_e32 v45, vcc, v45, v3, vcc
global_load_ushort v8, v[44:45], off
global_load_dwordx4 v[32:35], v[4:5], off offset:192
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v8, v8
v_mov_b32_e32 v47, 0xc2000000
v_lshrrev_b32_e32 v36, 0, v32
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v128, v8, v36
v_lshrrev_b32_e32 v36, 8, v32
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v129, v8, v36
v_lshrrev_b32_e32 v36, 16, v32
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v130, v8, v36
v_lshrrev_b32_e32 v36, 24, v32
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v131, v8, v36
v_lshrrev_b32_e32 v36, 0, v33
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v132, v8, v36
v_lshrrev_b32_e32 v36, 8, v33
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v133, v8, v36
v_lshrrev_b32_e32 v36, 16, v33
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v134, v8, v36
v_lshrrev_b32_e32 v36, 24, v33
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v135, v8, v36
v_lshrrev_b32_e32 v36, 0, v34
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v136, v8, v36
v_lshrrev_b32_e32 v36, 8, v34
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v137, v8, v36
v_lshrrev_b32_e32 v36, 16, v34
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v138, v8, v36
v_lshrrev_b32_e32 v36, 24, v34
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v139, v8, v36
v_lshrrev_b32_e32 v36, 0, v35
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v140, v8, v36
v_lshrrev_b32_e32 v36, 8, v35
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v141, v8, v36
v_lshrrev_b32_e32 v36, 16, v35
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v142, v8, v36
v_lshrrev_b32_e32 v36, 24, v35
v_lshlrev_b32_e32 v36, 24, v36
v_ashrrev_i32_e32 v36, 24, v36
v_cvt_f32_i32_e32 v36, v36
v_mul_f32_e32 v143, v8, v36
global_load_dword v20, v[4:5], off offset:0
global_load_dword v21, v[4:5], off offset:32
global_load_dword v22, v[4:5], off offset:128
global_load_dwordx4 v[96:99], v[6:7], off offset:0
global_load_dwordx4 v[100:103], v[6:7], off offset:128
global_load_dwordx4 v[104:107], v[6:7], off offset:256
global_load_dwordx4 v[108:111], v[6:7], off offset:384
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:4
global_load_dword v21, v[4:5], off offset:36
global_load_dword v22, v[4:5], off offset:132
global_load_dwordx4 v[96:99], v[6:7], off offset:16
global_load_dwordx4 v[100:103], v[6:7], off offset:144
global_load_dwordx4 v[104:107], v[6:7], off offset:272
global_load_dwordx4 v[108:111], v[6:7], off offset:400
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:8
global_load_dword v21, v[4:5], off offset:40
global_load_dword v22, v[4:5], off offset:136
global_load_dwordx4 v[96:99], v[6:7], off offset:32
global_load_dwordx4 v[100:103], v[6:7], off offset:160
global_load_dwordx4 v[104:107], v[6:7], off offset:288
global_load_dwordx4 v[108:111], v[6:7], off offset:416
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:12
global_load_dword v21, v[4:5], off offset:44
global_load_dword v22, v[4:5], off offset:140
global_load_dwordx4 v[96:99], v[6:7], off offset:48
global_load_dwordx4 v[100:103], v[6:7], off offset:176
global_load_dwordx4 v[104:107], v[6:7], off offset:304
global_load_dwordx4 v[108:111], v[6:7], off offset:432
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v128, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v130, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v132, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v134, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:16
global_load_dword v21, v[4:5], off offset:48
global_load_dword v22, v[4:5], off offset:144
global_load_dwordx4 v[96:99], v[6:7], off offset:64
global_load_dwordx4 v[100:103], v[6:7], off offset:192
global_load_dwordx4 v[104:107], v[6:7], off offset:320
global_load_dwordx4 v[108:111], v[6:7], off offset:448
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:20
global_load_dword v21, v[4:5], off offset:52
global_load_dword v22, v[4:5], off offset:148
global_load_dwordx4 v[96:99], v[6:7], off offset:80
global_load_dwordx4 v[100:103], v[6:7], off offset:208
global_load_dwordx4 v[104:107], v[6:7], off offset:336
global_load_dwordx4 v[108:111], v[6:7], off offset:464
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:24
global_load_dword v21, v[4:5], off offset:56
global_load_dword v22, v[4:5], off offset:152
global_load_dwordx4 v[96:99], v[6:7], off offset:96
global_load_dwordx4 v[100:103], v[6:7], off offset:224
global_load_dwordx4 v[104:107], v[6:7], off offset:352
global_load_dwordx4 v[108:111], v[6:7], off offset:480
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:28
global_load_dword v21, v[4:5], off offset:60
global_load_dword v22, v[4:5], off offset:156
global_load_dwordx4 v[96:99], v[6:7], off offset:112
global_load_dwordx4 v[100:103], v[6:7], off offset:240
global_load_dwordx4 v[104:107], v[6:7], off offset:368
global_load_dwordx4 v[108:111], v[6:7], off offset:496
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v129, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v131, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v133, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v135, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:64
global_load_dword v21, v[4:5], off offset:96
global_load_dword v22, v[4:5], off offset:160
global_load_dwordx4 v[96:99], v[6:7], off offset:512
global_load_dwordx4 v[100:103], v[6:7], off offset:640
global_load_dwordx4 v[104:107], v[6:7], off offset:768
global_load_dwordx4 v[108:111], v[6:7], off offset:896
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:68
global_load_dword v21, v[4:5], off offset:100
global_load_dword v22, v[4:5], off offset:164
global_load_dwordx4 v[96:99], v[6:7], off offset:528
global_load_dwordx4 v[100:103], v[6:7], off offset:656
global_load_dwordx4 v[104:107], v[6:7], off offset:784
global_load_dwordx4 v[108:111], v[6:7], off offset:912
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:72
global_load_dword v21, v[4:5], off offset:104
global_load_dword v22, v[4:5], off offset:168
global_load_dwordx4 v[96:99], v[6:7], off offset:544
global_load_dwordx4 v[100:103], v[6:7], off offset:672
global_load_dwordx4 v[104:107], v[6:7], off offset:800
global_load_dwordx4 v[108:111], v[6:7], off offset:928
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:76
global_load_dword v21, v[4:5], off offset:108
global_load_dword v22, v[4:5], off offset:172
global_load_dwordx4 v[96:99], v[6:7], off offset:560
global_load_dwordx4 v[100:103], v[6:7], off offset:688
global_load_dwordx4 v[104:107], v[6:7], off offset:816
global_load_dwordx4 v[108:111], v[6:7], off offset:944
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v136, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v138, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v140, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v142, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:80
global_load_dword v21, v[4:5], off offset:112
global_load_dword v22, v[4:5], off offset:176
global_load_dwordx4 v[96:99], v[6:7], off offset:576
global_load_dwordx4 v[100:103], v[6:7], off offset:704
global_load_dwordx4 v[104:107], v[6:7], off offset:832
global_load_dwordx4 v[108:111], v[6:7], off offset:960
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:84
global_load_dword v21, v[4:5], off offset:116
global_load_dword v22, v[4:5], off offset:180
global_load_dwordx4 v[96:99], v[6:7], off offset:592
global_load_dwordx4 v[100:103], v[6:7], off offset:720
global_load_dwordx4 v[104:107], v[6:7], off offset:848
global_load_dwordx4 v[108:111], v[6:7], off offset:976
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:88
global_load_dword v21, v[4:5], off offset:120
global_load_dword v22, v[4:5], off offset:184
global_load_dwordx4 v[96:99], v[6:7], off offset:608
global_load_dwordx4 v[100:103], v[6:7], off offset:736
global_load_dwordx4 v[104:107], v[6:7], off offset:864
global_load_dwordx4 v[108:111], v[6:7], off offset:992
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v73, v36, v111, v73
global_load_dword v20, v[4:5], off offset:92
global_load_dword v21, v[4:5], off offset:124
global_load_dword v22, v[4:5], off offset:188
global_load_dwordx4 v[96:99], v[6:7], off offset:624
global_load_dwordx4 v[100:103], v[6:7], off offset:752
global_load_dwordx4 v[104:107], v[6:7], off offset:880
global_load_dwordx4 v[108:111], v[6:7], off offset:1008
s_waitcnt vmcnt(0)
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v70, v36, v96, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v71, v36, v97, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v72, v36, v98, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v137, v36
v_fma_f32 v73, v36, v99, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v70, v36, v100, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v71, v36, v101, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v72, v36, v102, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_and_b32_e32 v36, 0xf, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 2, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v139, v36
v_fma_f32 v73, v36, v103, v73
v_lshrrev_b32_e32 v36, 0, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v70, v36, v104, v70
v_lshrrev_b32_e32 v36, 8, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v71, v36, v105, v71
v_lshrrev_b32_e32 v36, 16, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v72, v36, v106, v72
v_lshrrev_b32_e32 v36, 24, v20
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 4, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v141, v36
v_fma_f32 v73, v36, v107, v73
v_lshrrev_b32_e32 v36, 0, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 0, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v70, v36, v108, v70
v_lshrrev_b32_e32 v36, 8, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 8, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v71, v36, v109, v71
v_lshrrev_b32_e32 v36, 16, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 16, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v72, v36, v110, v72
v_lshrrev_b32_e32 v36, 24, v21
v_and_b32_e32 v36, 0xff, v36
v_lshrrev_b32_e32 v36, 4, v36
v_lshrrev_b32_e32 v37, 24, v22
v_and_b32_e32 v37, 0xff, v37
v_lshrrev_b32_e32 v37, 6, v37
v_and_b32_e32 v37, 3, v37
v_lshlrev_b32_e32 v37, 4, v37
v_or_b32_e32 v36, v36, v37
v_cvt_f32_u32_e32 v36, v36
v_add_f32_e32 v36, v47, v36
v_mul_f32_e32 v36, v143, v36
v_fma_f32 v73, v36, v111, v73
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
