.text
k_q6k_dequant:
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
v_mov_b32_e32 v65, 210
v_mul_lo_u32 v66, v4, v65
v_mov_b32_e32 v5, v66
v_mov_b32_e32 v67, 256
v_mul_lo_u32 v68, v4, v67
v_mov_b32_e32 v6, v68
v_mov_b32_e32 v69, 208
v_add_u32_e32 v70, v5, v69
v_mov_b32_e32 v71, v70
v_mov_b32_e32 v200, s16
v_mov_b32_e32 v201, s17
v_add_co_u32_e32 v200, vcc, v200, v71
v_addc_co_u32_e32 v201, vcc, v201, v1, vcc
global_load_ushort v72, v[200:201], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v73, v72
v_mov_b32_e32 v7, v73
s_mov_b32 s65, 2
s_mov_b32 s21, 0
for_loop_2:
s_cmp_lt_u32 s21, s65
s_cbranch_scc0 for_end_4
v_mov_b32_e32 v74, 192
v_add_u32_e32 v75, v5, v74
s_mov_b32 s66, 8
s_mul_i32 s67, s21, s66
v_mov_b32_e32 v76, s67
v_add_u32_e32 v77, v75, v76
v_mov_b32_e32 v8, v77
s_mov_b32 s68, 32
s_mov_b32 s22, 0
for_loop_5:
s_cmp_lt_u32 s22, s68
s_cbranch_scc0 for_end_7
s_mov_b32 s69, 64
s_mul_i32 s70, s21, s69
v_mov_b32_e32 v78, s70
v_add_u32_e32 v79, v5, v78
v_mov_b32_e32 v80, s22
v_add_u32_e32 v81, v79, v80
v_mov_b32_e32 v82, v81
v_mov_b32_e32 v202, s16
v_mov_b32_e32 v203, s17
v_add_co_u32_e32 v202, vcc, v202, v82
v_addc_co_u32_e32 v203, vcc, v203, v1, vcc
global_load_ubyte v83, v[202:203], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v9, v83
s_mov_b32 s71, 64
s_mul_i32 s72, s21, s71
v_mov_b32_e32 v84, s72
v_add_u32_e32 v85, v5, v84
v_mov_b32_e32 v86, s22
v_add_u32_e32 v87, v85, v86
v_mov_b32_e32 v88, 32
v_add_u32_e32 v89, v87, v88
v_mov_b32_e32 v90, v89
v_mov_b32_e32 v204, s16
v_mov_b32_e32 v205, s17
v_add_co_u32_e32 v204, vcc, v204, v90
v_addc_co_u32_e32 v205, vcc, v205, v1, vcc
global_load_ubyte v91, v[204:205], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v10, v91
v_mov_b32_e32 v92, 128
v_add_u32_e32 v93, v5, v92
s_mov_b32 s73, 32
s_mul_i32 s74, s21, s73
v_mov_b32_e32 v94, s74
v_add_u32_e32 v95, v93, v94
v_mov_b32_e32 v96, s22
v_add_u32_e32 v97, v95, v96
v_mov_b32_e32 v98, v97
v_mov_b32_e32 v206, s16
v_mov_b32_e32 v207, s17
v_add_co_u32_e32 v206, vcc, v206, v98
v_addc_co_u32_e32 v207, vcc, v207, v1, vcc
global_load_ubyte v99, v[206:207], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v11, v99
v_mov_b32_e32 v100, 15
v_and_b32_e32 v101, v9, v100
v_mov_b32_e32 v102, 3
v_and_b32_e32 v103, v11, v102
v_mov_b32_e32 v104, 4
v_lshlrev_b32_e32 v105, v104, v103
v_or_b32_e32 v106, v101, v105
v_mov_b32_e32 v107, 32
v_sub_u32_e32 v108, v106, v107
v_mov_b32_e32 v12, v108
v_mov_b32_e32 v109, 15
v_and_b32_e32 v110, v10, v109
v_mov_b32_e32 v111, 2
v_lshrrev_b32_e32 v112, v111, v11
v_mov_b32_e32 v113, 3
v_and_b32_e32 v114, v112, v113
v_mov_b32_e32 v115, 4
v_lshlrev_b32_e32 v116, v115, v114
v_or_b32_e32 v117, v110, v116
v_mov_b32_e32 v118, 32
v_sub_u32_e32 v119, v117, v118
v_mov_b32_e32 v13, v119
v_mov_b32_e32 v120, 4
v_lshrrev_b32_e32 v121, v120, v9
v_mov_b32_e32 v122, 4
v_lshrrev_b32_e32 v123, v122, v11
v_mov_b32_e32 v124, 3
v_and_b32_e32 v125, v123, v124
v_mov_b32_e32 v126, 4
v_lshlrev_b32_e32 v127, v126, v125
v_or_b32_e32 v128, v121, v127
v_mov_b32_e32 v129, 32
v_sub_u32_e32 v130, v128, v129
v_mov_b32_e32 v14, v130
v_mov_b32_e32 v131, 4
v_lshrrev_b32_e32 v132, v131, v10
v_mov_b32_e32 v133, 6
v_lshrrev_b32_e32 v134, v133, v11
v_mov_b32_e32 v135, 3
v_and_b32_e32 v136, v134, v135
v_mov_b32_e32 v137, 4
v_lshlrev_b32_e32 v138, v137, v136
v_or_b32_e32 v139, v132, v138
v_mov_b32_e32 v140, 32
v_sub_u32_e32 v141, v139, v140
v_mov_b32_e32 v15, v141
s_mov_b32 s75, 4
s_lshr_b32 s76, s22, s75
s_mov_b32 s23, s76
v_mov_b32_e32 v142, s23
v_add_u32_e32 v143, v8, v142
v_mov_b32_e32 v144, 0
v_add_u32_e32 v145, v143, v144
v_mov_b32_e32 v146, v145
v_mov_b32_e32 v208, s16
v_mov_b32_e32 v209, s17
v_add_co_u32_e32 v208, vcc, v208, v146
v_addc_co_u32_e32 v209, vcc, v209, v1, vcc
global_load_ubyte v147, v[208:209], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v148, 24, v147
v_ashrrev_i32_e32 v148, 24, v148
v_mov_b32_e32 v16, v148
v_mov_b32_e32 v149, s23
v_add_u32_e32 v150, v8, v149
v_mov_b32_e32 v151, 2
v_add_u32_e32 v152, v150, v151
v_mov_b32_e32 v153, v152
v_mov_b32_e32 v210, s16
v_mov_b32_e32 v211, s17
v_add_co_u32_e32 v210, vcc, v210, v153
v_addc_co_u32_e32 v211, vcc, v211, v1, vcc
global_load_ubyte v154, v[210:211], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v155, 24, v154
v_ashrrev_i32_e32 v155, 24, v155
v_mov_b32_e32 v17, v155
v_mov_b32_e32 v156, s23
v_add_u32_e32 v157, v8, v156
v_mov_b32_e32 v158, 4
v_add_u32_e32 v159, v157, v158
v_mov_b32_e32 v160, v159
v_mov_b32_e32 v212, s16
v_mov_b32_e32 v213, s17
v_add_co_u32_e32 v212, vcc, v212, v160
v_addc_co_u32_e32 v213, vcc, v213, v1, vcc
global_load_ubyte v161, v[212:213], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v162, 24, v161
v_ashrrev_i32_e32 v162, 24, v162
v_mov_b32_e32 v18, v162
v_mov_b32_e32 v163, s23
v_add_u32_e32 v164, v8, v163
v_mov_b32_e32 v165, 6
v_add_u32_e32 v166, v164, v165
v_mov_b32_e32 v167, v166
v_mov_b32_e32 v214, s16
v_mov_b32_e32 v215, s17
v_add_co_u32_e32 v214, vcc, v214, v167
v_addc_co_u32_e32 v215, vcc, v215, v1, vcc
global_load_ubyte v168, v[214:215], off
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v169, 24, v168
v_ashrrev_i32_e32 v169, 24, v169
v_mov_b32_e32 v19, v169
s_mov_b32 s77, 128
s_mul_i32 s78, s21, s77
v_mov_b32_e32 v170, s78
v_add_u32_e32 v171, v6, v170
v_mov_b32_e32 v20, v171
v_cvt_f32_i32_e32 v172, v16
v_mul_f32_e32 v173, v7, v172
v_cvt_f32_i32_e32 v174, v12
v_mul_f32_e32 v175, v173, v174
v_mov_b32_e32 v176, s22
v_add_u32_e32 v177, v20, v176
v_lshlrev_b32_e32 v178, 2, v177
v_mov_b32_e32 v216, s18
v_mov_b32_e32 v217, s19
v_add_co_u32_e32 v216, vcc, v216, v178
v_addc_co_u32_e32 v217, vcc, v217, v1, vcc
global_store_dword v[216:217], v175, off
s_waitcnt vmcnt(0)
v_cvt_f32_i32_e32 v179, v17
v_mul_f32_e32 v180, v7, v179
v_cvt_f32_i32_e32 v181, v13
v_mul_f32_e32 v182, v180, v181
v_mov_b32_e32 v183, 32
v_add_u32_e32 v184, v20, v183
v_mov_b32_e32 v185, s22
v_add_u32_e32 v186, v184, v185
v_lshlrev_b32_e32 v187, 2, v186
v_mov_b32_e32 v218, s18
v_mov_b32_e32 v219, s19
v_add_co_u32_e32 v218, vcc, v218, v187
v_addc_co_u32_e32 v219, vcc, v219, v1, vcc
global_store_dword v[218:219], v182, off
s_waitcnt vmcnt(0)
v_cvt_f32_i32_e32 v188, v18
v_mul_f32_e32 v189, v7, v188
v_cvt_f32_i32_e32 v190, v14
v_mul_f32_e32 v191, v189, v190
v_mov_b32_e32 v192, 64
v_add_u32_e32 v193, v20, v192
v_mov_b32_e32 v194, s22
v_add_u32_e32 v195, v193, v194
v_lshlrev_b32_e32 v196, 2, v195
v_mov_b32_e32 v220, s18
v_mov_b32_e32 v221, s19
v_add_co_u32_e32 v220, vcc, v220, v196
v_addc_co_u32_e32 v221, vcc, v221, v1, vcc
global_store_dword v[220:221], v191, off
s_waitcnt vmcnt(0)
v_cvt_f32_i32_e32 v197, v19
v_mul_f32_e32 v198, v7, v197
v_cvt_f32_i32_e32 v199, v15
v_mul_f32_e32 v200, v198, v199
v_mov_b32_e32 v201, 96
v_add_u32_e32 v202, v20, v201
v_mov_b32_e32 v203, s22
v_add_u32_e32 v204, v202, v203
v_lshlrev_b32_e32 v205, 2, v204
v_mov_b32_e32 v222, s18
v_mov_b32_e32 v223, s19
v_add_co_u32_e32 v222, vcc, v222, v205
v_addc_co_u32_e32 v223, vcc, v223, v1, vcc
global_store_dword v[222:223], v200, off
s_waitcnt vmcnt(0)
for_inc_6:
s_add_i32 s22, s22, 1
s_branch for_loop_5
for_end_7:
for_inc_3:
s_add_i32 s21, s21, 1
s_branch for_loop_2
for_end_4:
s_or_b64 exec, exec, s[48:49]
if_end_1:
s_endpgm
