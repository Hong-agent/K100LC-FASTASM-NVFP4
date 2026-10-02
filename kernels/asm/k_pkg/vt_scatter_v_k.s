.text
k_vt_scatter_v_k:
v_mov_b32_e32 v1, 0
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_load_dword s28, s[4:5], 0x30
s_load_dword s29, s[4:5], 0x34
s_load_dword s30, s[4:5], 0x38
s_waitcnt lgkmcnt(0)
s_mov_b32 s31, s6
s_mov_b32 s32, s31
v_mov_b32_e32 v13, v0
v_and_b32_e32 v13, 63, v13
v_mov_b32_e32 v3, v13
s_mov_b32 s64, 1
s_lshl_b32 s65, s64, s30
s_mov_b32 s33, s65
s_lshr_b32 s66, s32, s30
s_mov_b32 s34, s66
s_mov_b32 s67, 1
s_sub_u32 s68, s33, s67
s_and_b32 s69, s32, s68
s_mov_b32 s35, s69
s_mov_b32 s70, 6
s_lshl_b32 s71, s34, s70
s_mov_b32 s36, s71
s_mov_b32 s72, 6
s_lshl_b32 s73, s35, s72
s_mov_b32 s37, s73
s_mov_b32 s74, 64
s_mov_b32 s38, 0
for_loop_1:
s_cmp_lt_u32 s38, s74
s_cbranch_scc0 for_end_3
s_add_u32 s75, s36, s38
s_mov_b32 s39, s75
s_cmp_lt_u32 s39, s24
s_cbranch_scc0 if_end_4
s_mul_i32 s76, s39, s26
s_add_u32 s77, s76, s37
v_mov_b32_e32 v64, s77
v_add_u32_e32 v65, v64, v3
v_lshlrev_b32_e32 v64, 2, v65
v_mov_b32_e32 v14, s20
v_mov_b32_e32 v15, s21
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_waitcnt vmcnt(0)
s_mov_b32 s78, 65
s_mul_i32 s79, s38, s78
v_mov_b32_e32 v66, s79
v_add_u32_e32 v67, v66, v3
v_lshlrev_b32_e32 v66, 2, v67
ds_write_b32 v66, v64 offset:0
s_mul_i32 s80, s39, s27
s_add_u32 s81, s80, s37
v_mov_b32_e32 v64, s81
v_add_u32_e32 v65, v64, v3
v_lshlrev_b32_e32 v64, 2, v65
v_mov_b32_e32 v14, s22
v_mov_b32_e32 v15, s23
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_add_u32 s82, s29, s39
s_mul_i32 s83, s82, s25
s_add_u32 s84, s83, s37
v_mov_b32_e32 v66, s84
v_add_u32_e32 v67, v66, v3
s_waitcnt vmcnt(0)
v_lshlrev_b32_e32 v66, 2, v67
v_mov_b32_e32 v14, s18
v_mov_b32_e32 v15, s19
v_add_co_u32_e32 v14, vcc, v14, v66
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_store_dword v[14:15], v64, off
if_end_4:
for_inc_2:
s_add_i32 s38, s38, 1
s_branch for_loop_1
for_end_3:
s_waitcnt lgkmcnt(0)
s_waitcnt vmcnt(0)
s_barrier
s_mov_b32 s85, 64
s_mov_b32 s40, 0
for_loop_6:
s_cmp_lt_u32 s40, s85
s_cbranch_scc0 for_end_8
s_add_u32 s86, s37, s40
s_mov_b32 s41, s86
v_mov_b32_e32 v64, s36
v_add_u32_e32 v65, v64, v3
v_mov_b32_e32 v64, s24
v_cmp_lt_u32_e64 vcc, v65, v64
s_and_saveexec_b64 s[48:49], vcc
s_cbranch_execz if_end_9
s_cmp_lt_u32 s41, s25
s_cbranch_scc0 if_end_10
v_mov_b32_e32 v64, 65
v_mul_lo_u32 v65, v3, v64
v_mov_b32_e32 v64, s40
v_add_u32_e32 v66, v65, v64
v_lshlrev_b32_e32 v64, 2, v66
ds_read_b32 v66, v64 offset:0
s_waitcnt lgkmcnt(0)
s_mul_i32 s87, s41, s28
s_add_u32 s88, s87, s29
s_add_u32 s89, s88, s36
v_mov_b32_e32 v65, s89
v_add_u32_e32 v67, v65, v3
v_lshlrev_b32_e32 v65, 2, v67
v_mov_b32_e32 v14, s16
v_mov_b32_e32 v15, s17
v_add_co_u32_e32 v14, vcc, v14, v65
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_store_dword v[14:15], v66, off
if_end_10:
s_or_b64 exec, exec, s[48:49]
if_end_9:
for_inc_7:
s_add_i32 s40, s40, 1
s_branch for_loop_6
for_end_8:
s_endpgm
