.text
k_embed_f16_k:
v_mov_b32_e32 v1, 0
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_waitcnt lgkmcnt(0)
s_mov_b32 s24, s6
s_mov_b32 s25, s24
v_mov_b32_e32 v9, v0
v_and_b32_e32 v9, 63, v9
v_mov_b32_e32 v3, v9
s_cmp_lt_u32 s25, s22
s_cbranch_scc0 if_end_1
v_mov_b32_e32 v64, s25
v_lshlrev_b32_e32 v65, 2, v64
v_mov_b32_e32 v10, s18
v_mov_b32_e32 v11, s19
v_add_co_u32_e32 v10, vcc, v10, v65
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_dword v65, v[10:11], off
s_waitcnt vmcnt(0)
v_mov_b32_e32 v4, v65
v_mov_b32_e32 v64, s23
v_mul_lo_u32 v65, v4, v64
v_mov_b32_e32 v5, v65
s_mov_b32 s64, 63
s_add_u32 s65, s23, s64
s_mov_b32 s66, 6
s_lshr_b32 s67, s65, s66
s_mov_b32 s26, s67
s_mov_b32 s27, 0
for_loop_3:
s_cmp_lt_u32 s27, s26
s_cbranch_scc0 for_end_5
s_mov_b32 s68, 6
s_lshl_b32 s69, s27, s68
v_mov_b32_e32 v64, s69
v_add_u32_e32 v65, v64, v3
v_mov_b32_e32 v8, v65
v_mov_b32_e32 v64, s23
v_cmp_lt_u32_e64 vcc, v8, v64
s_and_saveexec_b64 s[48:49], vcc
s_cbranch_execz if_end_6
v_add_u32_e32 v64, v5, v8
v_mov_b32_e32 v65, 1
v_lshlrev_b32_e32 v66, v65, v64
v_mov_b32_e32 v65, v66
v_mov_b32_e32 v10, s20
v_mov_b32_e32 v11, s21
v_add_co_u32_e32 v10, vcc, v10, v65
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_load_ushort v65, v[10:11], off
s_waitcnt vmcnt(0)
v_cvt_f32_f16_e32 v66, v65
s_mul_i32 s70, s25, s23
v_mov_b32_e32 v65, s70
v_add_u32_e32 v64, v65, v8
v_lshlrev_b32_e32 v65, 2, v64
v_mov_b32_e32 v10, s16
v_mov_b32_e32 v11, s17
v_add_co_u32_e32 v10, vcc, v10, v65
v_addc_co_u32_e32 v11, vcc, v11, v1, vcc
global_store_dword v[10:11], v66, off
s_or_b64 exec, exec, s[48:49]
if_end_6:
for_inc_4:
s_add_i32 s27, s27, 1
s_branch for_loop_3
for_end_5:
if_end_1:
s_endpgm
