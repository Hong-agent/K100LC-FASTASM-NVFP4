.text
k_rope_apply_k:
v_mov_b32_e32 v1, 0
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dwordx2 s[22:23], s[4:5], 0x18
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_load_dword s26, s[4:5], 0x28
s_load_dword s27, s[4:5], 0x2c
s_waitcnt lgkmcnt(0)
s_mov_b32 s28, s6
s_mov_b32 s29, s28
v_mov_b32_e32 v13, v0
v_and_b32_e32 v13, 63, v13
v_mov_b32_e32 v3, v13
s_mov_b32 s64, 1
s_lshr_b32 s65, s25, s64
s_mov_b32 s30, s65
s_lshr_b32 s66, s29, s26
s_add_u32 s67, s66, s27
s_mov_b32 s31, s67
s_mov_b32 s68, 63
s_add_u32 s69, s30, s68
s_mov_b32 s70, 6
s_lshr_b32 s71, s69, s70
s_mov_b32 s32, s71
s_cmp_lt_u32 s29, s24
s_cbranch_scc0 if_end_1
s_mov_b32 s33, 0
for_loop_3:
s_cmp_lt_u32 s33, s32
s_cbranch_scc0 for_end_5
s_mov_b32 s72, 6
s_lshl_b32 s73, s33, s72
v_mov_b32_e32 v64, s73
v_add_u32_e32 v65, v64, v3
v_mov_b32_e32 v8, v65
v_mov_b32_e32 v64, s30
v_cmp_lt_u32_e64 vcc, v8, v64
s_and_saveexec_b64 s[48:49], vcc
s_cbranch_execz if_end_6
s_mul_i32 s74, s31, s30
v_mov_b32_e32 v64, s74
v_add_u32_e32 v65, v64, v8
v_lshlrev_b32_e32 v64, 2, v65
v_mov_b32_e32 v14, s20
v_mov_b32_e32 v15, s21
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v9, v64
s_mul_i32 s75, s31, s30
v_mov_b32_e32 v64, s75
v_add_u32_e32 v65, v64, v8
v_lshlrev_b32_e32 v64, 2, v65
v_mov_b32_e32 v14, s22
v_mov_b32_e32 v15, s23
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v10, v64
s_mul_i32 s76, s29, s25
v_mov_b32_e32 v64, s76
v_add_u32_e32 v65, v64, v8
v_lshlrev_b32_e32 v64, 2, v65
v_mov_b32_e32 v14, s18
v_mov_b32_e32 v15, s19
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v11, v64
s_mul_i32 s77, s29, s25
v_mov_b32_e32 v64, s77
v_add_u32_e32 v65, v64, v8
v_mov_b32_e32 v64, s30
v_add_u32_e32 v66, v65, v64
v_lshlrev_b32_e32 v64, 2, v66
v_mov_b32_e32 v14, s18
v_mov_b32_e32 v15, s19
v_add_co_u32_e32 v14, vcc, v14, v64
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_load_dword v64, v[14:15], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v12, v64
v_mul_f32_e32 v64, v11, v9
v_mul_f32_e32 v65, v12, v10
v_sub_f32_e32 v66, v64, v65
s_mul_i32 s78, s29, s25
v_mov_b32_e32 v65, s78
v_add_u32_e32 v64, v65, v8
v_lshlrev_b32_e32 v65, 2, v64
v_mov_b32_e32 v14, s16
v_mov_b32_e32 v15, s17
v_add_co_u32_e32 v14, vcc, v14, v65
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_store_dword v[14:15], v66, off
v_mul_f32_e32 v64, v11, v10
v_mul_f32_e32 v65, v12, v9
v_add_f32_e32 v66, v64, v65
s_mul_i32 s79, s29, s25
v_mov_b32_e32 v65, s79
v_add_u32_e32 v64, v65, v8
v_mov_b32_e32 v65, s30
v_add_u32_e32 v67, v64, v65
v_lshlrev_b32_e32 v65, 2, v67
v_mov_b32_e32 v14, s16
v_mov_b32_e32 v15, s17
v_add_co_u32_e32 v14, vcc, v14, v65
v_addc_co_u32_e32 v15, vcc, v15, v1, vcc
global_store_dword v[14:15], v66, off
s_or_b64 exec, exec, s[48:49]
if_end_6:
for_inc_4:
s_add_i32 s33, s33, 1
s_branch for_loop_3
for_end_5:
if_end_1:
s_endpgm
