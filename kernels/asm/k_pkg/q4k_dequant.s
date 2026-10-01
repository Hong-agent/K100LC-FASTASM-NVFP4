.text
k_q4k_dequant:
v_mov_b32_e32 v1, 0
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dword s20, s[4:5], 0x10
s_waitcnt lgkmcnt(0)
s_load_dword s64, s[4:5], 0x24
s_waitcnt lgkmcnt(0)
s_and_b32 s64, s64, 0xffff
v_mov_b32_e32 v3, s64
v_mov_b32_e32 v2, s6
v_mul_lo_u32 v2, v2, v3
v_add_u32_e32 v2, v2, v0
v_mov_b32_e32 v4, v2
v_mov_b32_e32 v64, s20
v_cmp_lt_u32_e32 vcc, v4, v64
s_and_saveexec_b64 s[48:49], vcc
s_cbranch_execz if_end_1
v_mov_b32_e32 v65, 144
v_mul_lo_u32 v66, v4, v65
v_mov_b32_e32 v5, v66
v_mov_b32_e32 v64, 256
v_mul_lo_u32 v65, v4, v64
v_mov_b32_e32 v6, v65
v_mov_b32_e32 v64, 0
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, v65
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v66
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ushort v67, v[254:255], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v68, v67
v_mov_b32_e32 v7, v68
v_mov_b32_e32 v64, 2
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, v65
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v66
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ushort v67, v[254:255], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v68, v67
v_mov_b32_e32 v8, v68
s_mov_b32 s65, 4
s_mov_b32 s21, 0
for_loop_2:
s_cmp_lt_u32 s21, s65
s_cbranch_scc0 for_end_4
s_mov_b32 s66, 2
s_mul_i32 s67, s21, s66
s_mov_b32 s22, s67
s_mov_b32 s68, 1
s_add_u32 s69, s22, s68
s_mov_b32 s23, s69
s_mov_b32 s70, 0
s_mov_b32 s24, s70
s_mov_b32 s71, 0
s_mov_b32 s25, s71
s_mov_b32 s72, 0
s_mov_b32 s26, s72
s_mov_b32 s73, 0
s_mov_b32 s27, s73
s_mov_b32 s74, 4
s_cmp_lt_u32 s22, s74
s_cbranch_scc0 if_else_6
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s22
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, v67
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v68
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v69, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v70, 63
v_and_b32_e32 v71, v69, v70
v_mov_b32_e32 v9, v71
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s22
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 63
v_and_b32_e32 v73, v71, v72
v_mov_b32_e32 v10, v73
s_branch if_end_5
if_else_6:
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s22
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 15
v_and_b32_e32 v73, v71, v72
v_mov_b32_e32 v74, 4
v_add_u32_e32 v75, v5, v74
v_mov_b32_e32 v76, s22
v_add_u32_e32 v77, v75, v76
v_mov_b32_e32 v78, 4
v_sub_u32_e32 v79, v77, v78
v_mov_b32_e32 v80, v79
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v80
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v81, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v82, 6
v_lshrrev_b32_e32 v83, v82, v81
v_mov_b32_e32 v84, 4
v_lshlrev_b32_e32 v85, v84, v83
v_or_b32_e32 v86, v73, v85
v_mov_b32_e32 v9, v86
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s22
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 4
v_lshrrev_b32_e32 v73, v72, v71
v_mov_b32_e32 v74, 4
v_add_u32_e32 v75, v5, v74
v_mov_b32_e32 v76, s22
v_add_u32_e32 v77, v75, v76
v_mov_b32_e32 v78, v77
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v78
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v79, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v80, 6
v_lshrrev_b32_e32 v81, v80, v79
v_mov_b32_e32 v82, 4
v_lshlrev_b32_e32 v83, v82, v81
v_or_b32_e32 v84, v73, v83
v_mov_b32_e32 v10, v84
if_end_5:
s_mov_b32 s75, 4
s_cmp_lt_u32 s23, s75
s_cbranch_scc0 if_else_8
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s23
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, v67
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v68
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v69, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v70, 63
v_and_b32_e32 v71, v69, v70
v_mov_b32_e32 v11, v71
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s23
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 63
v_and_b32_e32 v73, v71, v72
v_mov_b32_e32 v12, v73
s_branch if_end_7
if_else_8:
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s23
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 15
v_and_b32_e32 v73, v71, v72
v_mov_b32_e32 v74, 4
v_add_u32_e32 v75, v5, v74
v_mov_b32_e32 v76, s23
v_add_u32_e32 v77, v75, v76
v_mov_b32_e32 v78, 4
v_sub_u32_e32 v79, v77, v78
v_mov_b32_e32 v80, v79
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v80
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v81, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v82, 6
v_lshrrev_b32_e32 v83, v82, v81
v_mov_b32_e32 v84, 4
v_lshlrev_b32_e32 v85, v84, v83
v_or_b32_e32 v86, v73, v85
v_mov_b32_e32 v11, v86
v_mov_b32_e32 v64, 4
v_add_u32_e32 v65, v5, v64
v_mov_b32_e32 v66, s23
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, 4
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v72, 4
v_lshrrev_b32_e32 v73, v72, v71
v_mov_b32_e32 v74, 4
v_add_u32_e32 v75, v5, v74
v_mov_b32_e32 v76, s23
v_add_u32_e32 v77, v75, v76
v_mov_b32_e32 v78, v77
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v78
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v79, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v80, 6
v_lshrrev_b32_e32 v81, v80, v79
v_mov_b32_e32 v82, 4
v_lshlrev_b32_e32 v83, v82, v81
v_or_b32_e32 v84, v73, v83
v_mov_b32_e32 v12, v84
if_end_7:
s_mov_b32 s76, 32
s_mov_b32 s28, 0
for_loop_9:
s_cmp_lt_u32 s28, s76
s_cbranch_scc0 for_end_11
v_mov_b32_e32 v64, 16
v_add_u32_e32 v65, v5, v64
s_mov_b32 s77, 32
s_mul_i32 s78, s21, s77
v_mov_b32_e32 v66, s78
v_add_u32_e32 v67, v65, v66
v_mov_b32_e32 v68, s28
v_add_u32_e32 v69, v67, v68
v_mov_b32_e32 v70, v69
v_mov_b32_e32 v254, s16
v_mov_b32_e32 v255, s17
v_add_co_u32_e32 v254, vcc, v254, v70
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_load_ubyte v71, v[254:255], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v13, v71
v_cvt_f32_u32_e32 v64, v9
v_mul_f32_e32 v65, v7, v64
v_mov_b32_e32 v66, 15
v_and_b32_e32 v67, v13, v66
v_cvt_f32_u32_e32 v68, v67
v_mul_f32_e32 v69, v65, v68
v_cvt_f32_u32_e32 v70, v10
v_mul_f32_e32 v71, v8, v70
v_sub_f32_e32 v72, v69, v71
s_mov_b32 s79, 64
s_mul_i32 s80, s21, s79
v_mov_b32_e32 v73, s80
v_add_u32_e32 v74, v6, v73
v_mov_b32_e32 v75, s28
v_add_u32_e32 v76, v74, v75
v_lshlrev_b32_e32 v77, 2, v76
v_mov_b32_e32 v254, s18
v_mov_b32_e32 v255, s19
v_add_co_u32_e32 v254, vcc, v254, v77
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_store_dword v[254:255], v72, off
s_waitcnt vmcnt(0)
v_cvt_f32_u32_e32 v64, v11
v_mul_f32_e32 v65, v7, v64
v_mov_b32_e32 v66, 4
v_lshrrev_b32_e32 v67, v66, v13
v_cvt_f32_u32_e32 v68, v67
v_mul_f32_e32 v69, v65, v68
v_cvt_f32_u32_e32 v70, v12
v_mul_f32_e32 v71, v8, v70
v_sub_f32_e32 v72, v69, v71
s_mov_b32 s81, 64
s_mul_i32 s82, s21, s81
v_mov_b32_e32 v73, s82
v_add_u32_e32 v74, v6, v73
v_mov_b32_e32 v75, 32
v_add_u32_e32 v76, v74, v75
v_mov_b32_e32 v77, s28
v_add_u32_e32 v78, v76, v77
v_lshlrev_b32_e32 v79, 2, v78
v_mov_b32_e32 v254, s18
v_mov_b32_e32 v255, s19
v_add_co_u32_e32 v254, vcc, v254, v79
v_addc_co_u32_e32 v255, vcc, v255, v1, vcc
global_store_dword v[254:255], v72, off
s_waitcnt vmcnt(0)
for_inc_10:
s_add_i32 s28, s28, 1
s_branch for_loop_9
for_end_11:
for_inc_3:
s_add_i32 s21, s21, 1
s_branch for_loop_2
for_end_4:
s_or_b64 exec, exec, s[48:49]
if_end_1:
s_endpgm
