## 2026-09-29 22:43:46 · git 15b4975

| 指标 | 值 |
|---|---|
| P_prefill（tok/s） | **251.3**（中位；最优 251.3；8192tok@32603ms=251.3 / 8192tok@32599ms=251.3 / 8192tok@32642ms=251.0） |
| D_mtp3（贪心 tok/s） | **29.0**（500 tok / 17254 ms） |
| A_mtp（接受 token/轮） | **1.058**（257/474，54.2%，243 轮） |
| MTP 自适应 ema | 0.59 |
| D_nomtp（参照 tok/s） | 21.2（500 tok / 23545 ms）（MTP 加速 1.36×） |
| 加载（s） | 0.4 |
| 引擎 | /home/t/桌面/K100LC-FASTASM-NVFP4/build/rt |
| prompt 来源 | prefill:tokenizer/8192tok gen:tokenizer/84tok |
| 参数 | tokens=8192 gen=500 runs=3 prof=0 |

MTPBENCH（GEMV=2 单矩阵带宽）：

| 矩阵 | ms | GB/s |
|---|---|---|
| mtp.fc   [5120x10240] | 0.0785 | 334 |
| q_proj   [12288x5120] | 0.1003 | 314 |
| k_proj   [1024x5120] | 0.0214 | 122 |
| v_proj   [1024x5120] | 0.0205 | 128 |
| o_proj   [5120x6144] | 0.0429 | 366 |
| mlp.gate [17408x5120] | 0.0831 | 536 |
| mlp.up   [17408x5120] | 0.0793 | 562 |
| mlp.down [5120x17408] | 0.0940 | 474 |
| lm_head  [248320x5120] | 1.0968 | 580 |
| **合计（steps=30 head=1）** | 1.649 ms/步 | 514 |
| 启动探针（960 kernel） | — | 7.07 µs/kernel |
| 依赖链探针（240 kernel） | — | 7.01 µs/kernel |

## 2026-09-29 22:46:54 · git 15b4975

| 指标 | 值 |
|---|---|
| P_prefill（tok/s） | **295.3**（中位；最优 295.4；8192tok@27745ms=295.3 / 8192tok@27737ms=295.4 / 8192tok@27768ms=295.0） |
| D_mtp3（贪心 tok/s） | **27.2**（500 tok / 18351 ms） |
| A_mtp（接受 token/轮） | **0.808**（223/469，47.5%，276 轮） |
| MTP 自适应 ema | 0.46 |
| D_nomtp（参照 tok/s） | 21.4（500 tok / 23391 ms）（MTP 加速 1.27×） |
| 加载（s） | 1.1 |
| 引擎 | /home/t/桌面/K100LC-FASTASM-NVFP4/build/rt |
| prompt 来源 | prefill:tokenizer/8192tok gen:tokenizer/84tok |
| 参数 | tokens=8192 gen=500 runs=3 prof=0 |

MTPBENCH（GEMV=2 单矩阵带宽）：

| 矩阵 | ms | GB/s |
|---|---|---|
| mtp.fc   [5120x10240] | 0.0776 | 338 |
| q_proj   [12288x5120] | 0.1002 | 314 |
| k_proj   [1024x5120] | 0.0212 | 124 |
| v_proj   [1024x5120] | 0.0208 | 126 |
| o_proj   [5120x6144] | 0.0434 | 362 |
| mlp.gate [17408x5120] | 0.0874 | 510 |
| mlp.up   [17408x5120] | 0.0793 | 562 |
| mlp.down [5120x17408] | 0.0946 | 471 |
| lm_head  [248320x5120] | 0.9061 | 702 |
| **合计（steps=30 head=1）** | 1.413 ms/步 | 600 |
| 启动探针（960 kernel） | — | 7.02 µs/kernel |
| 依赖链探针（240 kernel） | — | 7.02 µs/kernel |

## 2026-09-29 · NVFP4 扩面到全部线性层：A/B 结论

`tools/nvfp4_quant.py` 把 checkpoint 里那批 **FP8（逐通道）** 的线性层
（自注意力 q/k/v/o、线性注意力 in_proj_qkv/in_proj_z/out_proj、lm_head、
第 56~63 层 MLP，共 233 个张量）按 **与 MLP 完全相同的 NVFP4 规格**重量化，
运行时走同一批 `k_nvfp4_*` 内核。两套权重都打出来对拍（都是本机 K100_LC，
`bash scripts/bench.sh` 的默认档：8192 token 预填充 / 500 token 生成）：

| 指标 | 只有 MLP 是 NVFP4（RT4 int4 跑其余层） | 全部线性层 NVFP4 | 变化 |
|---|---|---|---|
| P_prefill（tok/s） | **295.3** | **251.3** | **−14.9%** |
| D_mtp3（贪心 tok/s） | 27.2 | 29.0 | +6.6% |
| A_mtp（接受 token/轮） | 0.808（47.5%） | 1.058（54.2%） | + |
| D_nomtp（tok/s） | 21.4 | 21.2 | −0.9% |
| 单矩阵 GEMV（lm_head 248320x5120） | 0.904 ms / 703 GB/s | 1.094 ms / 581 GB/s | −17% |
| model.rp4 体积 | 15.765 GB | 16.263 GB | +3.2% |

结论：**权重精度更好**（每 16 个 k 一个 E4M3 尺度，实测相对 RMS ≈ 9.5%，
对照 RT4 int4/128 的 ≈ 12%；贪心输出与 int4 版语义一致 —— 前 64 个 token
相同 57.8%，随后只是措辞不同），**解码基本不变，但预填充慢 15%**。

原因：预填充是算力受限，RT4 的 W4A8 路径虽然要跑两遍 int4 GEMM，但每一遍
都比 `nvfp4_gemm_kernel`（BM=64/BN=64，每 16 个 k 折一次浮点尺度）快一倍以上，
两遍加起来仍然赢；解码侧（GEMV，单遍）NVFP4 也只是略慢，因为多出来的是
FP4→int8 解码 + 每 16 一个尺度那一层的开销。

要把它变成净收益，得先优化 `nvfp4_gemm_kernel`（更大 BM 复用权重、把每 16
一个尺度那层折叠掉）—— 那属于内核侧改动，而内核机器码来自 `kernels/asm/**/*.s`。

想回到「预填充优先」的打包方式：`NVFP4_ALL=0 bash scripts/pack_weights.sh`。
