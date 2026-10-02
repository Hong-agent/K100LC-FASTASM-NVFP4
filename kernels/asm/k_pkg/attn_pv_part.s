.text
k_attn_pv_part:
v_mov_b32_e32 v1, 0
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_load_dwordx2 s[18:19], s[4:5], 0x8
s_load_dwordx2 s[20:21], s[4:5], 0x10
s_load_dword s22, s[4:5], 0x18
s_load_dword s23, s[4:5], 0x1c
s_load_dword s24, s[4:5], 0x20
s_load_dword s25, s[4:5], 0x24
s_waitcnt lgkmcnt(0)
s_load_dword s64, s[4:5], 0x34
s_waitcnt lgkmcnt(0)
s_and_b32 s64, s64, 0xffff
v_mov_b32_e32 v12, s64
v_mov_b32_e32 v11, s6
v_mul_lo_u32 v11, v11, v12
v_add_u32_e32 v11, v11, v0
v_mov_b32_e32 v2, v11
v_mov_b32_e32 v64, s24
v_lshrrev_b32_e32 v65, v64, v2
v_mov_b32_e32 v3, v65
s_mov_b32 s65, 1
s_lshl_b32 s66, s65, s24
s_mov_b32 s67, 1
s_sub_u32 s68, s66, s67
s_mov_b32 s26, s68
v_mov_b32_e32 v64, s26
v_and_b32_e32 v65, v2, v64
v_mov_b32_e32 v5, v65
v_mov_b32_e32 v64, s25
v_mul_lo_u32 v65, v5, v64
v_mov_b32_e32 v6, v65
v_mov_b32_e32 v64, s23
v_mul_lo_u32 v65, v3, v64
v_mov_b32_e32 v7, v65
v_mov_b32_e32 v64, 0x00000000
v_mov_b32_e32 v8, v64
s_mov_b32 s27, 0
for_loop_1:
s_cmp_lt_u32 s27, s25
s_cbranch_scc0 for_end_3
v_mov_b32_e32 v64, s27
v_add_u32_e32 v65, v6, v64
v_mov_b32_e32 v10, v65
v_lshlrev_b32_e32 v64, 2, v10
v_mov_b32_e32 v13, s18
v_mov_b32_e32 v14, s19
v_add_co_u32_e32 v13, vcc, v13, v64
v_addc_co_u32_e32 v14, vcc, v14, v1, vcc
global_load_dword v64, v[13:14], off
s_waitcnt vmcnt(0)
v_add_u32_e32 v65, v7, v10
v_lshlrev_b32_e32 v66, 2, v65
v_mov_b32_e32 v13, s20
v_mov_b32_e32 v14, s21
v_add_co_u32_e32 v13, vcc, v13, v66
v_addc_co_u32_e32 v14, vcc, v14, v1, vcc
global_load_dword v65, v[13:14], off
s_waitcnt vmcnt(0)
v_fma_f32 v66, v64, v65, v8
v_mov_b32_e32 v8, v66
for_inc_2:
s_add_i32 s27, s27, 1
s_branch for_loop_1
for_end_3:
v_lshlrev_b32_e32 v64, 2, v2
v_mov_b32_e32 v13, s16
v_mov_b32_e32 v14, s17
v_add_co_u32_e32 v13, vcc, v13, v64
v_addc_co_u32_e32 v14, vcc, v14, v1, vcc
global_store_dword v[13:14], v8, off
s_waitcnt vmcnt(0)
s_endpgm
