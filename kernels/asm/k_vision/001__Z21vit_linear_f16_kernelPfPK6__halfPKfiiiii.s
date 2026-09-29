.text
k__Z21vit_linear_f16_kernelPfPK6__halfPKfiiiii:
s_load_dwordx4 s[12:15], s[4:5], 0x18
s_load_dword s18, s[4:5], 0x28
v_lshrrev_b32_e32 v2, 4, v0
v_and_b32_e32 v1, 15, v0
s_mov_b32 s2, 0
s_waitcnt lgkmcnt(0)
s_cmp_gt_i32 s14, 0
v_lshlrev_b32_e32 v3, 2, v2
v_lshlrev_b32_e32 v4, 2, v1
s_cbranch_scc1 2
s_mov_b64 s[0:1], 0
s_branch 1
s_mov_b64 s[0:1], -1
s_load_dwordx2 s[16:17], s[4:5], 0x0
s_lshl_b32 s7, s7, 6
s_lshl_b32 s6, s6, 6
s_andn2_b64 vcc, exec, s[0:1]
v_mov_b32_e32 v7, s2
v_mov_b32_e32 v8, s2
v_mov_b32_e32 v9, s2
v_mov_b32_e32 v10, s2
v_mov_b32_e32 v11, s2
v_mov_b32_e32 v12, s2
v_mov_b32_e32 v13, s2
v_mov_b32_e32 v14, s2
v_mov_b32_e32 v22, s2
v_mov_b32_e32 v21, s2
v_mov_b32_e32 v20, s2
v_mov_b32_e32 v19, s2
v_mov_b32_e32 v18, s2
v_mov_b32_e32 v17, s2
v_mov_b32_e32 v16, s2
v_mov_b32_e32 v15, s2
s_cbranch_vccnz 1236
s_load_dword s0, s[4:5], 0x3c
s_load_dwordx4 s[8:11], s[4:5], 0x8
v_lshlrev_b32_e32 v3, 2, v2
v_lshlrev_b32_e32 v5, 8, v2
v_mov_b32_e32 v2, 0x1000
s_mov_b32 s4, s15
s_mov_b32 s5, 0
s_waitcnt lgkmcnt(0)
s_and_b32 s15, s0, 0xffff
v_lshlrev_b32_e32 v4, 2, v1
v_lshl_or_b32 v6, v1, 8, v2
v_mov_b32_e32 v2, 0
s_movk_i32 s19, 0x7ff
v_mov_b32_e32 v15, 0
v_mov_b32_e32 v16, 0
v_mov_b32_e32 v17, 0
v_mov_b32_e32 v18, 0
v_mov_b32_e32 v19, 0
v_mov_b32_e32 v20, 0
v_mov_b32_e32 v21, 0
v_mov_b32_e32 v22, 0
v_mov_b32_e32 v14, 0
v_mov_b32_e32 v13, 0
v_mov_b32_e32 v12, 0
v_mov_b32_e32 v11, 0
v_mov_b32_e32 v10, 0
v_mov_b32_e32 v9, 0
v_mov_b32_e32 v8, 0
v_mov_b32_e32 v7, 0
s_branch 1122
s_or_b64 exec, exec, s[2:3]
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
ds_read_b128 v[23:26], v6
ds_read_b128 v[27:30], v5
ds_read_b128 v[31:34], v5 offset:16
ds_read_b128 v[35:38], v6 offset:64
ds_read_b128 v[39:42], v6 offset:128
ds_read_b128 v[43:46], v6 offset:192
ds_read_b128 v[47:50], v6 offset:16
s_waitcnt lgkmcnt(5)
v_fma_mix_f32 v1, v27, v23, v22 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(3)
v_fma_mix_f32 v21, v27, v35, v21 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(2)
v_fma_mix_f32 v20, v27, v39, v20 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v19, v27, v43, v19 op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v27, v35, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v27, v39, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v27, v43, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v23, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v28, v36, v21 op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v28, v40, v20 op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v28, v44, v19 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v24, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v28, v36, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v28, v40, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v28, v44, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v24, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v29, v37, v21 op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v29, v41, v20 op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v29, v45, v19 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v25, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v29, v37, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v29, v41, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v29, v45, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v25, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v30, v38, v21 op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v30, v42, v20 op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v30, v46, v19 op_sel_hi:[1,1,0]
ds_read_b128 v[19:22], v5 offset:64
v_fma_mix_f32 v51, v30, v38, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v26, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v26, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v52, v30, v42, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v18, v19, v23, v18 op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v19, v35, v17 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v19, v39, v16 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v19, v43, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v19, v23, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v19, v35, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v19, v39, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v19, v43, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v20, v24, v18 op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v20, v36, v17 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v20, v40, v16 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v20, v44, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v20, v24, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v20, v36, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v20, v40, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v20, v44, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v21, v25, v18 op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v21, v37, v17 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v21, v41, v16 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v21, v45, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v21, v25, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v21, v37, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v21, v41, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v21, v45, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v22, v26, v18 op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v22, v38, v17 op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v22, v42, v16 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v22, v46, v15 op_sel_hi:[1,1,0]
ds_read_b128 v[15:18], v5 offset:128
v_fma_mix_f32 v53, v30, v46, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v57, v22, v46, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[27:30], v5 offset:80
v_fma_mix_f32 v54, v22, v26, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v14, v15, v23, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v15, v35, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v15, v39, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v15, v43, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v15, v23, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v15, v35, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v15, v39, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v15, v43, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v16, v24, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v16, v36, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v16, v40, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v16, v44, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v16, v24, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v16, v36, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v16, v40, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v16, v44, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v17, v25, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v17, v37, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v17, v41, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v17, v45, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v17, v25, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v17, v37, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v17, v41, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v17, v45, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v18, v26, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v18, v38, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v18, v42, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v18, v46, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v58, v18, v26, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[11:14], v5 offset:192
v_fma_mix_f32 v59, v18, v38, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v60, v18, v42, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v61, v18, v46, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[15:18], v6 offset:80
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v10, v11, v23, v10 op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v11, v23, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v12, v24, v10 op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v12, v24, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v13, v25, v10 op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v13, v25, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v11, v35, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v14, v26, v10 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v11, v35, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v55, v22, v38, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v56, v22, v42, v21 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v62, v14, v26, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[19:22], v6 offset:144
ds_read_b128 v[23:26], v6 offset:208
v_fma_mix_f32 v9, v12, v36, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v12, v36, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v13, v37, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v11, v39, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v13, v37, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v11, v39, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v14, v38, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v12, v40, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v14, v38, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v12, v40, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v31, v47, v1 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(2)
v_fma_mix_f32 v38, v31, v15, v51 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v39, v31, v19, v52 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v40, v31, v23, v53 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v31, v47, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v31, v15, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v31, v19, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v31, v23, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v32, v48, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v32, v16, v38 op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v32, v20, v39 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v32, v24, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v43, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v32, v48, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v32, v16, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v32, v20, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v32, v24, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v43, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v33, v49, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v33, v17, v38 op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v33, v21, v39 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v33, v25, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v44, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v33, v49, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v33, v17, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v33, v21, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v33, v25, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v44, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v34, v50, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v34, v18, v32 op_sel_hi:[1,1,0]
v_fma_mix_f32 v33, v34, v22, v38 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v34, v26, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v13, v41, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v45, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v34, v50, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v34, v18, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v34, v22, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v40, v34, v26, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v27, v47, v54 op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v27, v15, v55 op_sel_hi:[1,1,0]
v_fma_mix_f32 v33, v27, v19, v56 op_sel_hi:[1,1,0]
v_fma_mix_f32 v34, v27, v23, v57 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v13, v41, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v45, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v27, v47, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v27, v15, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v33, v27, v19, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v27, v23, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v14, v42, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v14, v46, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v28, v48, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v28, v16, v32 op_sel_hi:[1,1,0]
v_fma_mix_f32 v33, v28, v20, v33 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v28, v24, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v14, v42, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v14, v46, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[7:10], v5 offset:144
ds_read_b128 v[11:14], v5 offset:208
v_fma_mix_f32 v31, v28, v48, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v28, v16, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v33, v28, v20, v33 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v28, v24, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v29, v49, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v29, v17, v32 op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v29, v21, v33 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v29, v25, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v29, v49, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v29, v17, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v32, v29, v21, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v29, v25, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v30, v50, v28 op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v30, v18, v31 op_sel_hi:[1,1,0]
v_fma_mix_f32 v31, v30, v22, v32 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v30, v26, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v41, v30, v50, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v42, v30, v18, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v43, v30, v22, v31 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v44, v30, v26, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v27, v7, v47, v58 op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v7, v15, v59 op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v7, v19, v60 op_sel_hi:[1,1,0]
v_fma_mix_f32 v30, v7, v23, v61 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v7, v47, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v7, v15, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v7, v19, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v7, v23, v30 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v8, v24, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v8, v24, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v9, v25, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v9, v25, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v10, v26, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v52, v10, v26, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v7, v11, v47, v62 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v47, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v48, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v48, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v49, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v49, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v14, v50, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v47, v14, v50, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v15, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v15, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v16, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v16, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v17, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v17, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v8, v48, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v14, v18, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v8, v48, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v48, v14, v18, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v19, v36 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v19, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v20, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v20, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v21, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v21, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v14, v22, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v53, v14, v22, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v23, v37 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v11, v23, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v8, v16, v28 op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v8, v20, v29 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v24, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v8, v16, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v29, v8, v20, v29 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v12, v24, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v9, v49, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v9, v17, v28 op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v9, v21, v29 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v25, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v9, v49, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v9, v17, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v28, v9, v21, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v13, v25, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v10, v50, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v10, v18, v27 op_sel_hi:[1,1,0]
v_fma_mix_f32 v27, v10, v22, v28 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v14, v26, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v45, v10, v50, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v46, v10, v18, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v51, v10, v22, v27 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v54, v14, v26, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[7:10], v6 offset:32
ds_read_b128 v[11:14], v5 offset:32
ds_read_b128 v[15:18], v5 offset:48
ds_read_b128 v[19:22], v6 offset:96
ds_read_b128 v[23:26], v6 offset:160
ds_read_b128 v[27:30], v6 offset:224
ds_read_b128 v[31:34], v6 offset:48
s_waitcnt lgkmcnt(5)
v_fma_mix_f32 v1, v11, v7, v1 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(3)
v_fma_mix_f32 v35, v11, v19, v38 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(2)
v_fma_mix_f32 v36, v11, v23, v39 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v37, v11, v27, v40 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v11, v19, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v11, v23, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v11, v7, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v11, v27, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v12, v20, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v12, v24, v36 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v12, v8, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v12, v28, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v12, v20, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v12, v24, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v12, v8, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v12, v28, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v13, v21, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v13, v25, v36 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v13, v9, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v13, v29, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v13, v25, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v13, v9, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v13, v21, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v13, v29, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v14, v26, v35 op_sel_hi:[1,1,0]
ds_read_b128 v[35:38], v5 offset:96
v_fma_mix_f32 v1, v14, v10, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v14, v22, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v14, v30, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v14, v10, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v55, v14, v22, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v56, v14, v26, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v57, v14, v30, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v11, v35, v7, v41 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v35, v19, v42 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v35, v23, v43 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v35, v27, v44 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v35, v7, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v35, v19, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v35, v23, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v35, v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v36, v8, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v36, v20, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v36, v24, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v36, v28, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v36, v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v36, v20, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v36, v24, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v36, v28, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v37, v9, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v37, v21, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v37, v25, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v37, v29, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v37, v9, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v37, v21, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v37, v25, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v37, v29, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v38, v10, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v38, v22, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v38, v26, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v38, v30, v14 op_sel_hi:[1,1,0]
ds_read_b128 v[11:14], v5 offset:160
v_fma_mix_f32 v58, v38, v10, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v59, v38, v22, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v60, v38, v26, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v61, v38, v30, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v35, v11, v7, v45 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v11, v19, v46 op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v11, v23, v51 op_sel_hi:[1,1,0]
v_fma_mix_f32 v38, v11, v27, v52 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v11, v7, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v11, v19, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v11, v23, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v11, v27, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v12, v8, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v12, v20, v36 op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v12, v24, v37 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v12, v28, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v12, v8, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v12, v20, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v37, v12, v24, v37 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v12, v28, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v13, v9, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v13, v21, v36 op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v13, v25, v37 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v13, v29, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v13, v21, v35 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v36, v13, v25, v36 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v13, v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v13, v29, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v14, v22, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v39, v14, v26, v36 op_sel_hi:[1,1,0]
ds_read_b128 v[35:38], v5 offset:224
ds_read_b128 v[43:46], v6 offset:176
v_fma_mix_f32 v12, v14, v10, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v14, v30, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v14, v10, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v13, v14, v22, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v51, v14, v26, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v14, v30, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v14, v35, v7, v47 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v35, v7, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v8, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v8, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v9, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v9, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v38, v10, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v52, v38, v10, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v35, v19, v48 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v35, v19, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v20, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v20, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v21, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v21, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v38, v22, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v62, v38, v22, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v35, v23, v53 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v35, v23, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v24, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v36, v24, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v25, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v37, v25, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v35, v27, v54 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v15, v31, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v38, v26, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v35, v27, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v15, v31, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[39:42], v6 offset:112
ds_read_b128 v[47:50], v6 offset:240
v_fma_mix_f32 v53, v38, v26, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
ds_read_b128 v[7:10], v5 offset:112
v_fma_mix_f32 v14, v36, v28, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v16, v32, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v36, v28, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v16, v32, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v37, v29, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v17, v33, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v37, v29, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v17, v33, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v38, v30, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v18, v34, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v35, v38, v30, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(2)
v_fma_mix_f32 v14, v15, v39, v55 op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v15, v43, v56 op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v20, v15, v47, v57 op_sel_hi:[1,1,0]
v_fma_mix_f32 v22, v18, v34, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v1, v7, v31, v58 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v15, v39, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v15, v43, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v15, v47, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v7, v31, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v16, v40, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v16, v44, v19 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v16, v48, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v8, v32, v1 op_sel_hi:[1,1,0]
ds_read_b128 v[23:26], v5 offset:176
ds_read_b128 v[27:30], v5 offset:240
v_fma_mix_f32 v14, v16, v40, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v16, v44, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v16, v48, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v8, v32, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v17, v41, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v17, v45, v19 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v17, v49, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v9, v33, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v17, v41, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v17, v45, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v17, v49, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v9, v33, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v18, v42, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v18, v46, v16 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v18, v50, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v10, v34, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v21, v18, v42, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v20, v18, v46, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v19, v18, v50, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v18, v10, v34, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(1)
v_fma_mix_f32 v1, v23, v31, v12 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v7, v39, v59 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v7, v43, v60 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v23, v31, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v7, v47, v61 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v7, v39, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v7, v43, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v24, v32, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v7, v47, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v8, v40, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v8, v44, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v24, v32, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v8, v48, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v8, v40, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v8, v44, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v25, v33, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v8, v48, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v9, v41, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v9, v45, v15 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v25, v33, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v9, v49, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v9, v45, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v26, v34, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v9, v41, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v9, v49, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v10, v46, v14 op_sel_hi:[1,1,0]
v_fma_mix_f32 v14, v26, v34, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_waitcnt lgkmcnt(0)
v_fma_mix_f32 v1, v27, v31, v52 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v31, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v32, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v32, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v33, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v33, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v10, v42, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v10, v50, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v34, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v17, v10, v42, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v16, v10, v46, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v15, v10, v50, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v23, v47, v11 op_sel_hi:[1,1,0]
v_fma_mix_f32 v10, v30, v34, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v39, v62 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v23, v47, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v39, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v24, v48, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v40, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v24, v48, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v40, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v25, v49, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v41, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v25, v49, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v41, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v26, v50, v9 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v42, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v23, v43, v51 op_sel_hi:[1,1,0]
v_fma_mix_f32 v11, v26, v50, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v9, v30, v42, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v43, v53 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v23, v43, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v43, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v24, v44, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v44, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v24, v44, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v44, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v25, v45, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v45, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v25, v45, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v45, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v26, v46, v8 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v46, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v23, v39, v13 op_sel_hi:[1,1,0]
v_fma_mix_f32 v12, v26, v46, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v8, v30, v46, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v47, v35 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v23, v39, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v27, v47, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v24, v40, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v48, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v24, v40, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v28, v48, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v25, v41, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v49, v1 op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v25, v41, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v29, v49, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v26, v42, v7 op_sel_hi:[1,1,0]
v_fma_mix_f32 v1, v30, v50, v1 op_sel_hi:[1,1,0]
s_add_i32 s5, s5, 32
v_fma_mix_f32 v13, v26, v42, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0]
v_fma_mix_f32 v7, v30, v50, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0]
s_cmp_ge_i32 s5, s14
s_waitcnt lgkmcnt(0)
s_barrier
s_waitcnt lgkmcnt(0)
s_cbranch_scc1 79
s_mov_b64 s[2:3], 0
v_mov_b32_e32 v23, v0
s_branch 11
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v23, s15, v23
v_lshlrev_b32_e32 v1, 1, v25
v_cmp_lt_u32_e32 vcc, s19, v23
v_lshl_or_b32 v1, v24, 6, v1
s_or_b64 s[2:3], vcc, s[2:3]
ds_write_b16 v1, v26
s_andn2_b64 exec, exec, s[2:3]
s_cbranch_execz 23
v_lshrrev_b32_e32 v24, 5, v23
v_and_b32_e32 v25, 31, v23
v_add_u32_e32 v27, s7, v24
v_or_b32_e32 v1, s5, v25
v_cmp_gt_i32_e32 vcc, s12, v27
v_cmp_gt_i32_e64 s[0:1], s14, v1
s_and_b64 s[20:21], vcc, s[0:1]
v_mov_b32_e32 v26, 0
s_and_saveexec_b64 s[0:1], s[20:21]
s_cbranch_execz 65514
v_mad_i64_i32 v[26:27], s[20:21], v27, s4, v[1:2]
v_mov_b32_e32 v1, s11
v_lshlrev_b64 v[26:27], 2, v[26:27]
v_add_co_u32_e32 v26, vcc, s10, v26
v_addc_co_u32_e32 v27, vcc, v1, v27, vcc
global_load_dword v1, v[26:27], off
s_waitcnt vmcnt(0)
v_cvt_f16_f32_e32 v26, v1
s_branch 65502
s_or_b64 exec, exec, s[2:3]
s_mov_b64 s[2:3], 0
v_mov_b32_e32 v23, v0
s_branch 12
s_or_b64 exec, exec, s[0:1]
v_add_u32_e32 v23, s15, v23
v_lshlrev_b32_e32 v1, 1, v25
v_cmp_lt_u32_e32 vcc, s19, v23
v_lshl_or_b32 v1, v24, 6, v1
s_or_b64 s[2:3], vcc, s[2:3]
s_waitcnt vmcnt(0)
ds_write_b16 v1, v26 offset:4096
s_andn2_b64 exec, exec, s[2:3]
s_cbranch_execz 64361
v_lshrrev_b32_e32 v24, 5, v23
v_and_b32_e32 v25, 31, v23
v_add_u32_e32 v27, s6, v24
v_or_b32_e32 v1, s5, v25
v_cmp_gt_i32_e32 vcc, s13, v27
v_cmp_gt_i32_e64 s[0:1], s14, v1
s_and_b64 s[20:21], vcc, s[0:1]
v_mov_b32_e32 v26, 0
s_and_saveexec_b64 s[0:1], s[20:21]
s_cbranch_execz 65513
v_mad_u64_u32 v[28:29], s[20:21], v27, s14, v[1:2]
v_ashrrev_i32_e32 v26, 31, v27
v_mov_b32_e32 v1, v29
v_mad_u64_u32 v[26:27], s[20:21], v26, s14, v[1:2]
v_mov_b32_e32 v1, s9
v_mov_b32_e32 v29, v26
v_lshlrev_b64 v[26:27], 1, v[28:29]
v_add_co_u32_e32 v26, vcc, s8, v26
v_addc_co_u32_e32 v27, vcc, v1, v27, vcc
global_load_ushort v26, v[26:27], off
s_branch 65498
v_add_u32_e32 v3, s7, v3
v_mad_i64_i32 v[0:1], s[0:1], v3, s18, 0
v_or_b32_e32 v2, s6, v4
v_cmp_gt_i32_e64 s[6:7], s12, v3
v_cmp_gt_i32_e32 vcc, s13, v2
s_and_b64 s[0:1], s[6:7], vcc
v_ashrrev_i32_e32 v4, 31, v2
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 14
v_add_co_u32_e64 v5, s[0:1], v0, v2
v_addc_co_u32_e64 v6, s[0:1], v1, v4, s[0:1]
v_lshlrev_b64 v[5:6], 2, v[5:6]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v23, s17
v_add_co_u32_e64 v5, s[0:1], s16, v5
v_addc_co_u32_e64 v6, s[0:1], v23, v6, s[0:1]
global_store_dword v[5:6], v22, off
s_or_b64 exec, exec, s[2:3]
v_or_b32_e32 v5, 1, v2
v_cmp_gt_i32_e64 s[0:1], s13, v5
s_and_b64 s[2:3], s[6:7], s[0:1]
s_and_saveexec_b64 s[4:5], s[2:3]
s_cbranch_execz 14
v_add_co_u32_e64 v5, s[2:3], v0, v2
v_addc_co_u32_e64 v6, s[2:3], v1, v4, s[2:3]
v_lshlrev_b64 v[4:5], 2, v[5:6]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[2:3], s16, v4
v_addc_co_u32_e64 v5, s[2:3], v6, v5, s[2:3]
global_store_dword v[4:5], v21, off offset:4
s_or_b64 exec, exec, s[4:5]
v_or_b32_e32 v4, 2, v2
v_cmp_gt_i32_e64 s[2:3], s13, v4
s_and_b64 s[4:5], s[6:7], s[2:3]
s_and_saveexec_b64 s[8:9], s[4:5]
s_cbranch_execz 15
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[4:5], v0, v2
v_addc_co_u32_e64 v5, s[4:5], v1, v5, s[4:5]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[4:5], s16, v4
v_addc_co_u32_e64 v5, s[4:5], v6, v5, s[4:5]
global_store_dword v[4:5], v20, off offset:8
s_or_b64 exec, exec, s[8:9]
v_or_b32_e32 v4, 3, v2
v_cmp_gt_i32_e64 s[4:5], s13, v4
s_and_b64 s[6:7], s[6:7], s[4:5]
s_and_saveexec_b64 s[8:9], s[6:7]
s_cbranch_execz 15
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e64 v0, s[6:7], v0, v2
v_addc_co_u32_e64 v1, s[6:7], v1, v4, s[6:7]
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s17
v_add_co_u32_e64 v0, s[6:7], s16, v0
v_addc_co_u32_e64 v1, s[6:7], v4, v1, s[6:7]
global_store_dword v[0:1], v19, off offset:12
s_or_b64 exec, exec, s[8:9]
v_or_b32_e32 v4, 1, v3
v_mad_i64_i32 v[0:1], s[6:7], v4, s18, 0
v_cmp_gt_i32_e64 s[6:7], s12, v4
s_and_b64 s[8:9], s[6:7], vcc
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 85
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 100
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[2:3]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 115
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[6:7], s[6:7], s[4:5]
s_and_saveexec_b64 s[8:9], s[6:7]
s_cbranch_execz 15
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e64 v0, s[6:7], v0, v2
v_addc_co_u32_e64 v1, s[6:7], v1, v4, s[6:7]
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s17
v_add_co_u32_e64 v0, s[6:7], s16, v0
v_addc_co_u32_e64 v1, s[6:7], v4, v1, s[6:7]
global_store_dword v[0:1], v15, off offset:12
s_or_b64 exec, exec, s[8:9]
v_or_b32_e32 v4, 2, v3
v_mad_i64_i32 v[0:1], s[6:7], v4, s18, 0
v_cmp_gt_i32_e64 s[6:7], s12, v4
s_and_b64 s[8:9], s[6:7], vcc
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 107
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 122
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[2:3]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execnz 137
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[6:7], s[6:7], s[4:5]
s_and_saveexec_b64 s[8:9], s[6:7]
s_cbranch_execz 15
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e64 v0, s[6:7], v0, v2
v_addc_co_u32_e64 v1, s[6:7], v1, v4, s[6:7]
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v4, s17
v_add_co_u32_e64 v0, s[6:7], s16, v0
v_addc_co_u32_e64 v1, s[6:7], v4, v1, s[6:7]
global_store_dword v[0:1], v11, off offset:12
s_or_b64 exec, exec, s[8:9]
v_or_b32_e32 v3, 3, v3
v_mad_i64_i32 v[0:1], s[6:7], v3, s18, 0
v_cmp_gt_i32_e64 s[6:7], s12, v3
s_and_b64 s[10:11], s[6:7], vcc
s_and_saveexec_b64 s[8:9], s[10:11]
s_cbranch_execnz 129
s_or_b64 exec, exec, s[8:9]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[0:1], s[8:9]
s_cbranch_execnz 140
s_or_b64 exec, exec, s[0:1]
s_and_b64 s[2:3], s[6:7], s[2:3]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execnz 151
s_or_b64 exec, exec, s[0:1]
s_and_b64 s[0:1], s[6:7], s[4:5]
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execnz 162
s_endpgm
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v18, off
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execz 65436
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v17, off offset:4
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[2:3]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execz 65421
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v16, off offset:8
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[6:7], s[6:7], s[4:5]
s_and_saveexec_b64 s[8:9], s[6:7]
s_cbranch_execnz 65406
s_branch 65420
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v14, off
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execz 65414
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v13, off offset:4
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[8:9], s[6:7], s[2:3]
s_and_saveexec_b64 s[10:11], s[8:9]
s_cbranch_execz 65399
v_ashrrev_i32_e32 v5, 31, v2
v_add_co_u32_e64 v4, s[8:9], v0, v2
v_addc_co_u32_e64 v5, s[8:9], v1, v5, s[8:9]
v_lshlrev_b64 v[4:5], 2, v[4:5]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v6, s17
v_add_co_u32_e64 v4, s[8:9], s16, v4
v_addc_co_u32_e64 v5, s[8:9], v6, v5, s[8:9]
global_store_dword v[4:5], v12, off offset:8
s_or_b64 exec, exec, s[10:11]
s_and_b64 s[6:7], s[6:7], s[4:5]
s_and_saveexec_b64 s[8:9], s[6:7]
s_cbranch_execnz 65384
s_branch 65398
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v3, vcc, v0, v2
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v3, vcc, s16, v3
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v10, off
s_or_b64 exec, exec, s[8:9]
s_and_b64 s[8:9], s[6:7], s[0:1]
s_and_saveexec_b64 s[0:1], s[8:9]
s_cbranch_execz 65396
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v3, vcc, v0, v2
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v3, vcc, s16, v3
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v9, off offset:4
s_or_b64 exec, exec, s[0:1]
s_and_b64 s[2:3], s[6:7], s[2:3]
s_and_saveexec_b64 s[0:1], s[2:3]
s_cbranch_execz 65385
v_ashrrev_i32_e32 v4, 31, v2
v_add_co_u32_e32 v3, vcc, v0, v2
v_addc_co_u32_e32 v4, vcc, v1, v4, vcc
v_lshlrev_b64 v[3:4], 2, v[3:4]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v5, s17
v_add_co_u32_e32 v3, vcc, s16, v3
v_addc_co_u32_e32 v4, vcc, v5, v4, vcc
global_store_dword v[3:4], v8, off offset:8
s_or_b64 exec, exec, s[0:1]
s_and_b64 s[0:1], s[6:7], s[4:5]
s_and_saveexec_b64 s[2:3], s[0:1]
s_cbranch_execz 65374
v_ashrrev_i32_e32 v3, 31, v2
v_add_co_u32_e32 v0, vcc, v0, v2
v_addc_co_u32_e32 v1, vcc, v1, v3, vcc
v_lshlrev_b64 v[0:1], 2, v[0:1]
s_waitcnt lgkmcnt(0)
v_mov_b32_e32 v2, s17
v_add_co_u32_e32 v0, vcc, s16, v0
v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
global_store_dword v[0:1], v7, off offset:12
s_endpgm
