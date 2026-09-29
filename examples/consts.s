.text
    s_mov_b32 s0, 0
    s_add_u32 s1, s2, 24
    s_and_b32 s3, s3, 0xffff
    v_mov_b32_e32 v1, 0
    v_add_u32_e32 v2, 1, v3
    v_lshlrev_b64 v[4:5], 2, v[6:7]
    s_endpgm
