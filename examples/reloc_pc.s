.data
one:
    .long 0x3f800000

.text
reloc_pc:
    s_getpc_b64 s[0:1]
    s_add_u32 s0, s0, rel32(one)
    s_addc_u32 s1, s1, 0
    s_load_dword s2, s[0:1], 0
    s_load_dwordx2 s[0:1], s[4:5], 0x0
    s_waitcnt lgkmcnt(0)
    v_mov_b32_e32 v0, s0
    v_mov_b32_e32 v1, s1
    v_mov_b32_e32 v2, s2
    global_store_dword v[0:1], v2, off
    s_endpgm
