.text
k__Z15vit_gelu_kernelPfPKfxi:
s_load_dword s2, s[4:5], 0x2c
s_load_dwordx2 s[0:1], s[4:5], 0x10
v_mov_b32_e32 v1, 0
v_mov_b32_e32 v2, s6
s_waitcnt lgkmcnt(0)
s_and_b32 s2, s2, 0xffff
v_mad_u64_u32 v[0:1], s[2:3], s2, v2, v[0:1]
v_cmp_gt_i64_e32 vcc, s[0:1], v[0:1]
s_and_saveexec_b64 s[0:1], vcc
s_cbranch_execz 199
s_load_dwordx2 s[0:1], s[4:5], 0x8
s_load_dword s2, s[4:5], 0x18
v_lshlrev_b64 v[2:3], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s1
v_add_co_u32_e32 v2, vcc, s0, v2
v_addc_co_u32_e32 v3, vcc, v4, v3, vcc
global_load_dword v2, v[2:3], off
s_cmp_eq_u32 s2, 0
s_cbranch_scc1 94
s_waitcnt vmcnt(0)
v_mul_f32_e32 v3, 0x3f3504f3, v2
v_and_b32_e32 v4, 0x7fffffff, v3
v_cmp_nlt_f32_e64 s[0:1], |v3|, 1.0
s_and_saveexec_b64 s[2:3], s[0:1]
s_xor_b64 s[0:1], exec, s[2:3]
s_cbranch_execz 57
v_mov_b32_e32 v5, 0xb9c68948
v_fmac_f32_e32 v5, 0x378e98ab, v4
v_mov_b32_e32 v6, 0x3b7cd369
v_fmac_f32_e32 v6, v4, v5
v_mov_b32_e32 v5, 0xbcc618b2
v_fmac_f32_e32 v5, v4, v6
v_mov_b32_e32 v6, 0x3dda74e4
v_fmac_f32_e32 v6, v4, v5
v_mov_b32_e32 v5, 0x3f228afd
v_fmac_f32_e32 v5, v4, v6
v_mov_b32_e32 v6, 0x3e03c728
v_fmac_f32_e32 v6, v4, v5
v_fmac_f32_e32 v4, v4, v6
s_mov_b32 s2, 0xbfb8aa3b
v_mul_f32_e32 v5, 0xbfb8aa3b, v4
v_rndne_f32_e32 v6, v5
v_fma_f32 v7, v4, s2, -v5
v_fmac_f32_e32 v7, 0xb2a5705f, v4
v_sub_f32_e32 v5, v5, v6
v_add_f32_e32 v5, v7, v5
s_mov_b32 s2, 0xc2fc0000
v_mov_b32_e32 v7, 0x42800000
v_cmp_gt_f32_e32 vcc, s2, v5
v_cndmask_b32_e32 v7, 0, v7, vcc
v_add_f32_e32 v5, v5, v7
v_cvt_i32_f32_e32 v6, v6
v_exp_f32_e32 v5, v5
v_mov_b32_e32 v7, 0x1f800000
v_cndmask_b32_e32 v7, 1.0, v7, vcc
s_mov_b32 s2, 0x42ce8ed0
v_mul_f32_e32 v5, v5, v7
v_ldexp_f32 v5, v5, v6
v_sub_f32_e32 v5, 1.0, v5
v_cmp_nlt_f32_e32 vcc, s2, v4
s_mov_b32 s2, 0xc2b17218
v_cndmask_b32_e32 v5, 1.0, v5, vcc
v_mov_b32_e32 v6, 0xff800000
v_cmp_ngt_f32_e32 vcc, s2, v4
v_cndmask_b32_e32 v4, v6, v5, vcc
s_andn2_saveexec_b64 s[0:1], s[0:1]
s_cbranch_execz 18
v_mul_f32_e32 v5, v3, v3
v_mov_b32_e32 v6, 0x3ba10414
v_fmac_f32_e32 v6, 0xba1345e1, v5
v_mov_b32_e32 v7, 0xbcdac9b8
v_fmac_f32_e32 v7, v5, v6
v_mov_b32_e32 v6, 0x3de703be
v_fmac_f32_e32 v6, v5, v7
v_mov_b32_e32 v7, 0xbec09330
v_fmac_f32_e32 v7, v5, v6
v_mov_b32_e32 v6, 0x3e0375d0
v_fmac_f32_e32 v6, v5, v7
v_fmac_f32_e32 v4, v4, v6
s_or_b64 exec, exec, s[0:1]
s_brev_b32 s0, -2
v_bfi_b32 v3, s0, v4, v3
s_load_dwordx2 s[0:1], s[4:5], 0x0
s_branch 79
s_load_dwordx2 s[0:1], s[4:5], 0x0
s_cbranch_execz 76
s_waitcnt vmcnt(0)
v_mul_f32_e32 v3, 0x3d372713, v2
v_mul_f32_e32 v3, v2, v3
v_fma_f32 v3, v2, v3, v2
v_mul_f32_e32 v3, 0x3f4c422a, v3
s_mov_b32 s2, 0x3f200000
v_and_b32_e32 v4, 0x7fffffff, v3
v_cmp_nlt_f32_e64 s[2:3], |v3|, s2
s_and_saveexec_b64 s[4:5], s[2:3]
s_xor_b64 s[2:3], exec, s[4:5]
s_cbranch_execz 38
v_add_f32_e32 v4, v4, v4
s_mov_b32 s4, 0x3fb8aa3b
v_mul_f32_e32 v5, 0x3fb8aa3b, v4
v_rndne_f32_e32 v6, v5
v_fma_f32 v7, v4, s4, -v5
v_fmac_f32_e32 v7, 0x32a5705f, v4
v_sub_f32_e32 v5, v5, v6
v_add_f32_e32 v5, v7, v5
s_mov_b32 s4, 0xc2fc0000
v_mov_b32_e32 v7, 0x42800000
v_cmp_gt_f32_e32 vcc, s4, v5
v_cndmask_b32_e32 v7, 0, v7, vcc
v_add_f32_e32 v5, v5, v7
v_cvt_i32_f32_e32 v6, v6
v_exp_f32_e32 v5, v5
v_mov_b32_e32 v7, 0x1f800000
v_cndmask_b32_e32 v7, 1.0, v7, vcc
s_mov_b32 s4, 0x42b17218
v_mul_f32_e32 v5, v5, v7
v_ldexp_f32 v5, v5, v6
v_add_f32_e32 v5, 1.0, v5
v_mov_b32_e32 v6, 0x7f800000
v_cmp_nlt_f32_e32 vcc, s4, v4
v_cndmask_b32_e32 v4, v6, v5, vcc
s_nop 0
v_rcp_f32_e32 v4, v4
v_fma_f32 v4, v4, -2.0, 1.0
s_andn2_saveexec_b64 s[2:3], s[2:3]
v_mul_f32_e32 v5, v3, v3
v_mov_b32_e32 v6, 0x3ca908c9
v_fmac_f32_e32 v6, 0xbbbac73d, v5
v_mov_b32_e32 v7, 0xbd5c1c4e
v_fmac_f32_e32 v7, v5, v6
v_mov_b32_e32 v6, 0x3e088382
v_fmac_f32_e32 v6, v5, v7
v_mov_b32_e32 v7, 0xbeaaaa99
v_fmac_f32_e32 v7, v5, v6
v_mul_f32_e32 v6, v4, v7
v_fmac_f32_e32 v4, v5, v6
s_or_b64 exec, exec, s[2:3]
s_brev_b32 s2, -2
v_bfi_b32 v3, s2, v4, v3
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt vmcnt(0)
v_mul_f32_e32 v2, 0.5, v2
v_add_f32_e32 v3, 1.0, v3
v_mul_f32_e32 v2, v2, v3
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v3, s1
v_add_co_u32_e32 v0, vcc, s0, v0
v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
global_store_dword v[0:1], v2, off
s_endpgm
