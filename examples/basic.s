.text
start:
    s_mov_b32 s0, s1
    s_add_u32 s2, s3, s4
    v_mov_b32_e32 v1, s2
    v_add_u32_e32 v3, s4, v5
    v_add_co_u32_e32 v6, vcc, s1, v2
    s_load_dword s5, s[2:3], 0x10
    global_load_dword v7, v[8:9], off offset:16
    global_store_dword v[10:11], v12, off offset:32
    s_cbranch_execz start
    s_endpgm
