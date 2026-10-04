# K100LC-FASTASM-NVFP4

海光 **K100_LC（gfx926）** 上的自研推理栈：**自研汇编器 + 无 DTK 运行时 +
RT4 int4 权重直跑**，同一个项目里跑完整 27B 模型，并自带网页控制台。

**默认模型 = int4**：`RedHatAI/Qwen3.8-27B-INT4`（落在 `models/Qwen3.8-27B-INT4/`，
主模型 W4A8：int4 权重 × int8 激活，由 `tools/convert.c` 的 int4 分支转成 RT4）。
`serve.sh` / `run.sh` / `deploy-offline.sh` / `scripts/pack_weights.sh` 默认都走它。
上游 NVFP4 checkpoint 那条路线作为**显式 opt-in** 保留，靠 `RT_MODEL_DIR` / `RT_RP4`
切换（见「默认模型与切换」一节）。

**NVFP4 直跑为什么降级成备用选项**：本机 A/B 实测（[docs/BENCHLOG.md](docs/BENCHLOG.md)）
全部线性层走 NVFP4 时预填充 **251.3 tok/s**，而 RT4 int4（W4A8）是 **295.3 tok/s**
（**−15%**）；单矩阵 GEMV 慢 17%；`.rp4` 反而大 3.2%（16.263 vs 15.765 GB）。
`nvfp4_gemm_kernel` 在 **M ≥ 1024 时还有已知的非法地址访问**，预填充只能靠
`CHUNK=512` 绕着走。精度上 NVFP4 略好（权重相对 RMS ≈9.5%，对照 int4/128 的
≈12%），但抵消不了性能与稳定性上的代价 —— 所以**默认不启用**，只作备用/对照。

本项目由两条独立路线合并而来：

* **k100lc-fast-nvfp4** —— 把 compressed-tensors 的 **NVFP4** checkpoint
  *不转换、不重量化、不重排*，按原生布局直接算（权重侧零误差）；
* **k100lc-asm** —— 自研表驱动**汇编器**与**无 DTK 运行路径**（不链接 hipcc /
  libgalaxyhip / libamd_comgr，只用 `/opt/hyhal` 的 HSA 运行时）。

合并后：模型、内核、运行时、网页在**一个自包含目录**里，**不需要 DTK 环境，
也不需要 Docker**，编译只要主机 `g++`，跑只要驱动自带的 HSA。

## 一句话

> 143 个模型内核由自研汇编器从 `.s` 汇编出来，与 K100LC-kernels 包 v1.9.11 的
> 142 个内核逐字节对齐（外加本项目的 `gather_exp_k`）；
> 打成一个 679,984 字节的 HSACO；运行时只链接 `libhsa-runtime64`（DTK 库引用
> **0**）。默认的 int4 主模型走 RT4 W4A8（int4 权重 × int8 激活），不做 NVFP4
> 替换；打开 `NVFP4_ALL=mlp|all` 才有 NVFP4 直跑 —— MLP 的 168 个是 checkpoint
> 原样（权重零误差），其余 233 个（注意力/线性注意力投影、lm_head、56~63 层 MLP）
> 由 `tools/nvfp4_quant.py` 从 FP8 按同一规格重量化。

## 快速开始

```bash
# 0) 接上本机已有的权重（软链接，不复制、不下载）
bash scripts/setup_models.sh

# 1) 一条命令构建：汇编内核 -> 单个 HSACO -> 生成 host 源码 -> g++ 编出 build/rt
bash build.sh

# 2) 命令行对话
bash run.sh --prompt "你好，用一句话介绍你自己" --n 64

# 3) 网页控制台（+ OpenAI 兼容接口）
bash serve.sh                     # http://<本机IP>/（监听 80，局域网不用带端口号）
bash serve.sh --stop
```

> 源码包里带了 `prebuilt/rt` 与 `prebuilt/k100lc_all.hsaco`，**不编译也能直接跑**：
> `run.sh` / `serve.sh` 找不到 `build/rt` 时会自动用 `prebuilt/rt`。
> `build.sh` 只在你要重新生成内核机器码或改内核时才需要（那时才要主机 `g++`）。

> **默认精度 = 全 W4A8**（大模型 / MTP / 视觉塔都是 int4 权重 × int8 激活）。
> 默认不走 `.rp4`、不走 NVFP4、不走原生 W4A16、不走 W4A4：引擎直接读
> `models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4`（主模型）、`qwen38_27b_mtp.rt4`
> （MTP）、`qwen38_27b_vision.rt4`（视觉塔，27 层在 DCU 上跑）。这些开关都在
> `scripts/env.sh`：`RT_NVFP4=0 / RT_RP4=0 / RT_INT4_NATIVE=0 / RT_ACT4=0 /
> RT_MTP_W8=0 / RT_VISION_DEVICE=gpu`。
>
> `.rp4` 单文件与 NVFP4 直跑保留为 opt-in：`bash scripts/pack_weights.sh` 打
> `build/model-int4.rp4`（默认也是 W4A8 主模型 + int4 MTP），`NVFP4_ALL=mlp|all`
> 才开 NVFP4；要把视觉塔装进 `.rp4`：`VISION_RP4=1`；想回 int8 MTP：`MTP_W8=1`。
>
> **项目内没有软链接**：`models/` 下的权重都是项目内真实文件（大文件用硬链接落盘，
> 同盘不额外占空间，删掉项目外的源目录也不影响）。`scripts/setup_models.sh` /
> `scripts/pack_weights.sh` 也不会再生成软链接。

## 默认模型与切换

项目默认跑 **int4**（`models/Qwen3.8-27B-INT4`，源 checkpoint
`RedHatAI/Qwen3.8-27B-INT4`）。所有入口都默认指向它：

| 入口 | 默认行为 |
|---|---|
| `bash serve.sh` | 起网页 + `/v1`，模型名 `qwen38-fastasm-int4`，**默认全 W4A8**（直接读 `rt4/` 下的 .rt4，不走 `.rp4`） |
| `bash run.sh` | 命令行对话，RT4 取 `models/Qwen3.8-27B-INT4/rt4/qwen38_27b.rt4` |
| `bash scripts/fetch_model.sh` | 从魔搭拉 int4 checkpoint（`VARIANT=nvfp4` 换 NVFP4 那份） |
| `bash scripts/convert_weights.sh` | 转换 `RT_MODEL_DIR` 里那份（默认 int4） |
| `bash scripts/pack_weights.sh` | 打 `build/model-int4.rp4` |
| `bash deploy-offline.sh` | 起服务，权重取 `models/Qwen3.8-27B-INT4/model.rp4` |

切到上游 NVFP4 checkpoint（opt-in）只需要两个环境变量：

```bash
VARIANT=nvfp4 bash scripts/fetch_model.sh          # 下 NVFP4 checkpoint 那份（可选）
RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 RT_RP4=build/model.rp4 bash serve.sh
```

再打开 NVFP4 直跑：`NVFP4_ALL=mlp|all bash scripts/pack_weights.sh`（见下文的打包说明）。
`serve-int4.sh` 仍保留，但已经是 `PORT=8080 bash serve.sh` 的薄别名。

### 全 W4A8 启动（**项目默认**，大模型 / MTP / 视觉塔）

```bash
bash serve.sh                   # http://<本机IP>/（80）；PORT=8081 可换端口
bash serve.sh --stop
# serve-w4a8.sh 是同一入口的兼容别名
```

三个部分都走「**int4 权重 × int8 激活**」，不碰 NVFP4 / 原生 W4A16 / W4A4：

| 部分 | 权重 | 运行时 |
|---|---|---|
| 大模型 | `rt4/qwen38_27b.rt4`（i4/128） | `RT_INT4_NATIVE=0` 关掉 checkpoint 原生 W4A16，解码 GEMV + 预填充 GEMM 都走 W4A8 |
| MTP | `rt4/qwen38_27b_mtp.rt4`（i4/128，15 张量） | 和主模型同一套 W4A8 内核；`RT_MTP_W8=0` 明确不要 W8A8 的 `.hi/.lo` 版本 |
| 视觉塔 | `rt4/qwen38_27b_vision.rt4`（i4/128，333 张量） | `RT_VISION_DEVICE=gpu`，线性层复用 W4A8 GEMV/GEMM，norm/bias/pos 仍是 f32 |

视觉权重由 `tools/convert_vision_rt4.py` 生成，**默认 int4**（`--f16` 可退回旧
f16 版本）。同一张图 48 token：int4 77.5 ms vs f16 157.6 ms（约 2 倍），
embedding 与 f16 的余弦相似度均值 0.977（最低 0.918）。

### 原生 int4 直跑（K100LC-kernels 的 `int4_dot_k`，opt-in）

线性层的**解码路径**可以直接吃 checkpoint 的原始 int4 字节（`weight_packed`
I32 + `weight_scale` BF16），不经过 `tools/convert.c` 的重量化 —— 内核来自
`K100LC-kernels` 包（`int4_dot_k` + `reduce_blocks_k`，W4A16：激活保持 f32）。
**默认关闭**（`RT_INT4_NATIVE=0`，项目默认走 W4A8）；要用就显式打开：

```bash
python3 /home/t/桌面/K100LC-kernels/tools/int4_engine_manifest.py \
        -o build/int4_manifest.tsv      # 400 层权重清单（文件偏移 + 字节数自检）
python3 tools/sync_kernels.py           # 同步 K100LC-kernels 的全部内核（142 个）
bash build.sh                           # 重新汇编（143 个内核）并编出 build/rt
RT_INT4_NATIVE=1 PORT=8080 bash serve.sh  # 网页 + /v1，日志里会出现「INT4 原生：400 个线性层…」
```

| 开关 | 默认 | 作用 |
|---|---|---|
| `RT_INT4_NATIVE` | `0` | 1 = 打开原生 W4A16 解码（默认关，走 RT4 W4A8） |
| `RT_INT4_PREFILL` | `0` | 1 = 预填充也走原生（逐 token，慢）；默认预填充仍用 RT4 的 W4A8 GEMM |
| `MTP_N` | 原生路径下 `0` | 原生解码下 MTP 的验证批要按行重读权重，实测更慢（6.9 vs 10.1 tok/s） |

实测（本机，无 MTP）：原生解码 **10.1 tok/s**，RT4/W4A8 基线 22.3 tok/s —— 慢 2.2 倍，
换来的是权重零误差 + f32 激活（A16）。格式、ABI、逐层带宽与对账见
`K100LC-kernels/docs/INT4.md`。

### 内核支持：与 K100LC-kernels 包同步（143 个内核）

项目的内核构建与可复用内核包 **K100LC-kernels v1.9.11 对齐**：
`kernels/kernel_spec.json` + `kernels/asm/**` 共 **143 个内核** —— 142 个与包内
三份权威清单同名（`kernels/kernel_spec.json` 基线 85 个、`flashmoe.spec.json`
34 个、`native_kernels.spec.json` 52 个，去重后 142 个），多出来的 `gather_exp_k`
（专家权重 gather，见 `kernels/asm/k_moe/`）是本项目自己的。

同名内核**默认不覆盖**项目里的副本（避免把项目自己的改动盖掉）。包内 v1.9.x
把点积族（`q4k/q5k/q6k/iq*_dot_k`、`int4_dot_k`）和 `reduce_blocks_k` 改成了
「一拍发 8/16 条 load、只等一次」，那批要显式 `--refresh` 才会换进来（实测在
本项目的形状上只快 1~3%，而它们只走 `RT_INT4_NATIVE=1` / `RT_Q36_W8=0` 这两条
非默认路径，所以本轮没有刷）。

```bash
python3 tools/sync_kernels.py --check        # 只报告差多少
python3 tools/sync_kernels.py                # 把缺的内核同步进来（默认不覆盖同名）
python3 tools/sync_kernels.py --refresh      # 同名内核也用包里的版本覆盖
bash build.sh                                # 重新汇编 143 个内核
bash tests/test_all_kernels_hsaco.sh         # 逐个解析全部内核符号并跑通
python3 tests/test_rmsnorm_fast.py           # 新内核 rmsnorm_fast_k 的逐元素对账
```

同步进来的自研内核按用途：

| 类别 | 内核 |
|---|---|
| RT4 / INT4 主通路 | `int4_dot_k`、`reduce_blocks_k`、`int4_dequant_k`、`quant_rows_fast_k`、`gemm_w4a4_flat` |
| W4A4 / W4A8 GEMV | `gemv_w4a4_r2_k`、`gemv_w4a4_r2_m3_k`、`gemv_i8_k`、`gemv_f32_k`、`gemv_f32_warp_k` |
| GGUF 原生解码/点积 | `q2_0/q4_0/q8_0/iq4nl/iq4xs/iq2s/iq3s/iq3xxs/q4k/q5k/q6k` 的 `*_dequant_k` / `*_dot_k` |
| 通用算子 | `gelu_mul_k`、`softmax_k`、`layernorm_k`、`topk_k`、`router_top10_k`、`iq4nl_to_i8_k` |
| **v1.9.x 新增（本轮同步）** | `rmsnorm_fast_k` / `rmsnorm_deep_k`、`vt_scatter_k` / `vt_scatter_v_k` / `vt_scatter_v1_k`、`flash_dec_part_k` / `flash_dec_comb_k`、`gemv_f32_rows8_k` / `_acc_k` / `_split_k`、`gemv_f32_warp_acc_k`、`gemv_f32_gated_acc_k`、`moe_combine_k` / `moe_combine_gather_k`、`gather_rows_k`、`softmax_vec_k`、`block_max_k` / `block_exp_sum_k`、`reduce_max1_k` / `reduce_sum1_k`、`div_scalar_k`、`rope_apply_k`、`embed_f16_k`、`attn_pv_part` |

### 新内核在**本项目**里能接到哪一步（实测）

新内核是按内核包自己的模型层（f32 KV、cos/sin 表 RoPE、f32 GEMV、f16 词表）
调的，而本项目主通路用的是自己的一套**打包布局**（KV 走 int4/int8 打包、
W4A8 GEMV、融合多头解码注意力），所以能直接替换的点不多。逐条量过的结论：

| 新内核 | 本项目里对应的位置 | 结论 |
|---|---|---|
| `rmsnorm_fast_k` / `rmsnorm_deep_k` | `k_rmsnorm`（src/k_new.hip，两条模型路径都在用） | **deep 默认接在 `D>=2048`**（`RT_NODEEPNORM=1` 关）；fast 仍可选（`RT_FASTNORM`，默认 `0`）。见下面的实测 |
| `gemv_f32_rows8_k` / `_acc_k` / `_split_k` / `gemv_f32_warp_acc_k` / `gemv_f32_gated_acc_k` | 稠密 f32 GEMV；本项目线性层走 W4A8，只有 MoE 路由曾是 f32，且已改成 W8 | 暂时挂不上（形状/精度都不合适） |
| `flash_dec_part_k` / `flash_dec_comb_k` / `attn_pv_part` | `k_attention`（打包 KV + 融合多头解码） | 布局不同：包内是 f32 转置 K / 行主序 V，本项目 KV 是 int4/int8 打包 |
| `softmax_vec_k`、`block_max_k`、`block_exp_sum_k`、`reduce_max1_k`、`reduce_sum1_k`、`div_scalar_k` | 本项目 softmax 在注意力内核内部（online softmax），没有独立 softmax 调用 | 无调用点 |
| `moe_combine_k` / `moe_combine_gather_k`、`gather_rows_k` | Qwen3.6 MoE 的专家合并 / 分桶（见 src/moe35.cpp） | 可接但要重构；实测省的只是十几次投递（~0.1 ms/层），暂缓 |
| `vt_scatter_*` | `k_kv_append_k` / `k_kv_append_v`（打包 KV 写入） | 布局不同 |
| `rope_apply_k` | `k_rope` | 包内吃 cos/sin 表，本项目现算频率（不吃表） |
| `embed_f16_k` | `k_embed`（int4 词表） | 权重格式不同 |

#### `rmsnorm_fast_k` 实测（K100_LC，本机）

包里的对照是「HIP 版 `rmsnorm_k` 15.0 µs → `rmsnorm_fast_k` 7.5 µs」；
**在本项目的自研运行时里这个收益不成立**：

| 测法 | 现役 `rmsnorm_k` | `rmsnorm_fast_k` |
|---|---|---|
| 单核微基准，rows=1 / D=5120（缓存冷） | **22.2 µs** | 25.3 µs |
| 单核微基准，rows=1 / D=2048（缓存冷） | **12.6 µs** | 13.5 µs |
| 单核微基准，rows=1 / D=256（等于投递地板） | 7.28 µs | 7.26 µs |
| 27B 端到端（`--raw --n 32 --temp 0`，3 次均值） | 1181.9 ms | 1178.6 ms（−0.3%，在噪声内） |

原因是本项目里的 `rmsnorm_k` 也是自研汇编器从同一份 HIP 源码产出的汇编
（`kernels/asm/k_new/006__...s`），在这个运行时/这颗芯片上它已经贴着投递地板，
`rmsnorm_fast_k` 把 4 条 load 一批发并没有换来好处。因为收益为 0 而数值上
会有 1e-6 量级的重排差异（端到端 greedy 输出可能因此改道），**默认不开**，
要做对照或等后续版本再量时用 `RT_FASTNORM=1`。

#### `rmsnorm_deep_k`（K100LC-kernels v1.9.12）：**已接，默认开**

`rmsnorm_fast_k` 收益为 0 的根因不是「发 4 条一批」这个办法，而是**深度不够**：
它是单 workgroup 处理整行，每 lane 读 `D/64` 个元素，完整访存往返 = `D/256`
——D=5120 时是 20 次，4 条一批只把往返从 80 次降到 20 次，所以贴着 `rmsnorm_k`
不动。**加深流水版 `rmsnorm_deep_k`** 把一趟发到 16 条（往返再除 4，D=5120 只
剩 5 次），同一套算法、同一份 ABI、**输出与 fast 版逐位相同**（NB 不改 Σx² 的
加法顺序）：

| 测法 | 现役 `rmsnorm_k` | `rmsnorm_deep_k` |
|---|---|---|
| 单核微基准，rows=1 / D=5120 | 22.2 µs | **13.0 µs** |
| 27B 端到端（`RT_NO_MTP=1 --n 128`，各 2 次取均值） | 43.76 ms/token | **42.05 ms/token（−3.9%）** |

`k_rmsnorm` 在 `D >= 2048` 时走 deep；D 小（比如 q/k norm 的 `head_dim=128`）
时主循环进不去、反而更慢，仍走原路。`RT_NODEEPNORM=1` 可关掉回旧路做对照。
备注：端到端那组**必须先关掉 MTP**（`RT_NO_MTP=1`）——MTP 的接受率抖动
（75.8% vs 71.4%）会把 4% 的收益整个盖住，我第一次量就因此误判成「更慢」。

引擎实际启动的仍只是其中 63 个；其余内核在 HSACO 里可用，需要时按
`K100LC-kernels/docs/ABI.md` 的参数表启动即可。

**结论：NVFP4 直跑是备用选项，不是推荐配置。** 理由是实测不划算（同一台 K100_LC、
`scripts/bench.sh` 默认档 8192 token 预填充 / 500 token 生成）：

| 指标 | MLP 走 NVFP4（其余 RT4 int4） | 全部线性层 NVFP4 | 变化 |
|---|---|---|---|
| 预填充 tok/s | **295.3** | 251.3 | **−14.9%** |
| 贪心解码 tok/s（MTP3） | 27.2 | 29.0 | +6.6% |
| 贪心解码 tok/s（无 MTP） | 21.4 | 21.2 | −0.9% |
| lm_head GEMV | 0.904 ms / 703 GB/s | 1.094 ms / 581 GB/s | −17% |
| `.rp4` 体积 | 15.765 GB | 16.263 GB | +3.2% |
| NVFP4 GEMM（q_proj 形状） | — | 9.8 TMAC/s | int4 两遍是 17.4（0.56×） |

另外 `nvfp4_gemm_kernel` 在 M ≥ 1024 会触发非法地址访问（预填充 `CHUNK=512` 恰好避开）。
权重精度上 NVFP4 更好（相对 RMS ≈9.5% vs int4/128 的 ≈12%），但换不来性能，
于是把 NVFP4 从默认布局降为**备用/对照路径**：想要它的精度或做内核实验时再开。

## 两种部署方式

**联网从零部署**——只带源码，模型与依赖都从网上下：

```bash
bash scripts/make_src_package.sh      # → dist/K100LC-FASTASM-NVFP4-源码-<日期>.zip
# 目标机（联网）：
sudo bash driver/installer/rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run && sudo reboot
sudo apt install -y build-essential cmake autoconf m4 curl python3 python3-pip
python3 -m pip install -r requirements.txt
bash scripts/deploy_online.sh         # 下模型 → 转换 → 打包权重 → 编译 → 起服务
```

详细步骤见 [DEPLOY-ONLINE.md](DEPLOY-ONLINE.md)。

**离线整包**——源码 + 模型 + 驱动 + 自带运行时 + 预编译引擎，解压就能跑：

```bash
bash scripts/make_offline_package.sh  # → dist/K100LC-FASTASM-NVFP4-离线部署-<日期>.zip（~14.8 GB）
# 目标机（不联网）：
unzip K100LC-FASTASM-NVFP4-离线部署-<日期>.zip && cd K100LC-FASTASM-NVFP4
HY_INSTALL_DRIVER=1 bash deploy-offline.sh    # 装驱动（不限内核）→ 起服务
```

包内清单与排障见 [离线部署说明.md](离线部署说明.md)。

两个包都带 `driver/installer/rock-*-any-kernel.aio.run`：**驱动按安装时正在运行的内核
现编，不锁内核版本、也不改 GRUB**（见 `driver/不限内核-说明.md`）。只有重新编译 host
代码才需要 `g++`；纯部署/运行不需要编译器（装驱动内核模块时除外）。

> 驱动安装包与 `/usr/local/hyhal` 快照是**海光的第三方二进制，不随源码仓库发布**
> （`.gitignore` 里已排除；本仓库只保留 `driver/` 下的说明、diff 与系统配置）。
> 要落地部署，请用 `scripts/make_src_package.sh` / `scripts/make_offline_package.sh`
> 打出的源码包 / 离线整包，或从驱动来源自行取得同名安装包。
>
> **不限内核版已挂到 Releases**（70 MB，md5 `fe80b298a3d3358a869de14105ada134`）：
> <https://github.com/Hong-agent/K100LC-FASTASM-NVFP4/releases/tag/driver-rock-5.7.1-6.2.35-V1.6.7>

`setup_models.sh` 默认从桌面找 int4 权重（`../Qwen3.8-27B-INT4`）；也可以显式指定：

```bash
MODEL_SRC=/path/to/Qwen3.8-27B-INT4 \
RT4_DIR=/path/to/converted/rt4 \
RP4=/path/to/model-int4.rp4 bash scripts/setup_models.sh
```

## 实测（本机 K100_LC，2026-09-29）

| 环节 | 结果 |
|---|---|
| 自研汇编器 | 143 个内核全部从 `.s` 汇编；其中 142 个与 K100LC-kernels 包内预编译 `.bin` **逐字节一致** |
| 自研 HSACO | 单文件 **679,984 B**，含 143 个内核；HSA 解析全部符号并执行 |
| 运行时依赖 | `build/rt` 只链接 **libhsa-runtime64.so.1**；DTK 库引用 **0** |
| 默认模型 | `RedHatAI/Qwen3.8-27B-INT4` → RT4 int4（W4A8）；主模型 851 张量 = 402 int4 + 353 f32 + 96 f16 |
| 模型加载（默认） | int4 路线的 `.rp4` 单文件 **14.351 GB**，874 张量（main 851 / MTP 23），视觉塔不装进去 |
| MTP 精度 | 头权重 **int8/W8A8**：int4 相对误差 ≈12.8% → **0.9%**，投机接受率更好 |
| MTP 温度投机 | 温度 > 0 也走投机（草稿按 q 采样 + `min(1,p/q)` 接受 + 残差重采，分布严格等价）：**1.18~1.38×**。见 [docs/BENCHLOG.md](docs/BENCHLOG.md) |
| 视觉塔 | **不装进 `.rp4`**：引擎从 `rt4/qwen38_27b_vision.rt4` 单独加载、在 DCU 上跑 27 层；也可 `RT_VISION_DEVICE=cpu` 走纯 NumPy |
| NVFP4 直跑（opt-in） | `NVFP4_ALL=all` 时 **401 个线性层**走 NVFP4（168 个 MLP 原样零误差，233 个由 FP8 重量化，相对 RMS ≈ 9.5%），`.rp4` 16.263 GB / 2001 张量 |
| 性能权衡 | 全部线性层 NVFP4 时预填充 **251 tok/s**、解码 21 tok/s；只让 MLP 走 NVFP4 时预填充 **295 tok/s**（`NVFP4_ALL=0` 打包）。见 [docs/BENCHLOG.md](docs/BENCHLOG.md) |
| KV cache | 16 个注意力层跑 **int8**（每 dword 4 个元素，尺度 `amax/127`，与 Q/P 同走 `v_dot4_i32_i8`） |
| 端到端对话 | 64 层模型，预填充 58 token，生成 48 token（墙钟 1.49 s），输出连贯 |
| 网页 / 接口 | `GET /`（控制台）、`GET /style.css`、`GET /health`、`POST /v1/chat/completions` 全部正常 |

## 目录

| 路径 | 内容 |
|---|---|
| `asm.py`、`encodings.json` | **自研表驱动汇编器**与指令编码表（424+ 个编码形式） |
| `kernels/asm/` | 143 个内核的 `.s` 源码（基线 + 自研；`k_pkg/` 是从 K100LC-kernels 同步来的） |
| `kernels/kernel_spec.json` | 每个内核的参数表、kernarg/段大小、SGPR/VGPR 计数 |
| `kernels/kv_pack.h` 等 | 内核共用常量与 RT4 内核头 |
| `kernels/nvfp4/`、`include/nvfp4/` | **NVFP4** 解码 GEMV / GEMM 内核与 FP4→int8 原语 |
| `runtime/hsa_rt.{h,cpp}` | **无 DTK 运行时**：HSA 队列、投递、内存、同步的 HIP 兼容垫片 |
| `src/model.cpp`、`src/k_*.hip` | 模型与内核启动代码（host 侧由 `tools/gen_nodtk.py` 自动改写） |
| `web/index.html`、`web/style.css` | 网页控制台（从 K100LC-RT4 搬入本项目） |
| `models/Qwen3.8-27B-INT4/` | **默认权重目录**（项目内真实文件，无软链接）：RT4 int4 主模型 + int4 MTP + int4 视觉塔 + `model.rp4`；NVFP4 checkpoint 在 `models/Qwen3.8-27B-NVFP4/`（opt-in） |
| `scripts/serve.py` | OpenAI 兼容服务 + 静态网页 + 附件/视觉（后端 = 本项目 `build/rt`） |
| `scripts/chat.py` | 命令行对话 |
| `scripts/deploy_online.sh`、`scripts/fetch_model.sh` | 联网从零部署一条龙 / 拉源模型（断点续传） |
| `scripts/make_src_package.sh`、`scripts/make_offline_package.sh` | 打「联网源码包」/「离线整包」 |
| `tools/` | 汇编/HSACO 生成、无 DTK 改写、NVFP4 清单与打包、权重转换 |
| `driver/` | **DCU 驱动**安装说明、系统配置与安装包 |
| `deploy-offline.sh`、`离线部署说明.md` | 离线整包解压后的部署脚本与说明 |
| `DEPLOY-ONLINE.md` | 联网从零部署的完整步骤 |
| `docs/` | NVFP4 设计/格式、RP4 与 RT4 格式、性能与内存说明 |
| `build.sh` / `run.sh` / `serve.sh` | 构建 / 对话 / 网页三条入口 |

## 构建流程（无 DTK、无 Docker）

`bash build.sh` 做四步，全程只用到 `python3`、`g++`、`/opt/hyhal`：

```
kernels/asm/*.s + kernel_spec.json
        │  tools/build_kernels.py（自研汇编器 asm.py）
        ▼
build/kernels/*.bin ──► tools/make_hsaco_multi.py ──► build/k100lc_all.hsaco（119 内核）
        │
        │  tools/gen_nodtk.py：剥掉设备代码、kernel<<<>>> → hsart_launch(...)
        ▼
build/nodtk/*.cpp ──► g++ -lhsa-runtime64 ──► build/rt
```

关键点是**内核机器码的来源**：`kernels/asm/**/*.s` 是自研汇编器的源文件，
`tools/build_kernels.py` 把它们汇编成机器码并生成 HSACO 清单。整个过程不调用
`llvm-mc`、`hipcc`、`dccobjdump`，也不需要任何 DTK 库。

## 网页

`web/index.html` + `web/style.css` 是从 **K100LC-RT4** 搬过来的控制台页面，
`scripts/serve.py` 直接把它作为 `/` 返回（`/style.css` 单独路由），后端换成
本项目的 `build/rt`。`RT_ENGINE_BIN` 可以把它指向任意实现同一引擎协议的进程。

助手输出按 **Markdown** 渲染（`web/markdown.js`，零依赖、离线可用）：标题、粗体/斜体/
删除线、行内代码、带语言与复制按钮的代码块、有序/无序/任务列表、引用、链接与裸链接、
管道表格、图片。流式输出做 80ms 节流，思考段同样是 Markdown。
渲染前整段文本先做 HTML 转义，链接只放行 `http/https/mailto` 与相对地址，
模型输出里的 `<script>`、`javascript:` 链接不会被当成代码执行
（`node tests/test_markdown.js` 覆盖这些用例）。

技能写出的文件（会话工作区）显示在「文件」栏里，每张卡片有 **打开 / 下载 / ✕ 删除**，
文件多于一个时还有一个 **全部清除**（会二次确认）。删除走
`DELETE /v1/files/{name}?conversation_id=…`，删完自动刷新列表；文件栏的显隐尊重
用户按「文件」按钮做的选择，后台刷新不会把它又弹出来。每轮回答结束后自动刷新，
新生成的文件立刻带删除按钮。

```bash
bash serve.sh                    # 默认 80（http://<本机IP>/）；网页 maxtoken 默认 40960、上下文 40960
PORT=8080 CTX=16384 MTP_N=0 bash serve.sh
curl -s localhost/v1/chat/completions -H 'Content-Type: application/json' \
  -d '{"messages":[{"role":"user","content":"1+1=?"}],"max_tokens":16}'
```

「最多 token」（`max_tokens`）与上下文（`--ctx`）是两回事：前者是单轮生成上限，
默认为 **40960**；客户端不传时用它，装不下会按剩余上下文自动收窄（只有 prompt
本身超长才报 413）。页面上的输入框、`serve.sh` 的 `RT_DEFAULT_MAX_TOKENS`、
`scripts/serve.py --default-max-tokens` 都可以改。

采样默认值是 **温度 0.95 / top-p 0.95 / top-k 40**（网页输入框、`scripts/chat.py`
的 `--temp/--top-p/--top-k`、以及服务端 `RT_DEFAULT_TEMP/RT_DEFAULT_TOP_P/
RT_DEFAULT_TOP_K` 都能改）。要贪心解码显式传 `temperature: 0` 即可——温度 > 0 时
MTP 走的是严格等价的投机采样，见 [docs/BENCHLOG.md](docs/BENCHLOG.md)。

## 六个关键设计点

第一，**NVFP4 直跑覆盖全部线性层（opt-in）**。`I = 2 x E2M1` 落在 [-12,12] 且是整数，
所以 FP4 → int8 无损，可直接喂 `v_dot4_i32_i8`；MLP 那 168 个张量用的是
checkpoint 原样 NVFP4（权重零误差），其余 233 个线性层由 `tools/nvfp4_quant.py`
按**同一规格**（每 16 个 k 一个 E4M3 尺度 + 逐张量 F32 全局尺度）重量化，
权重相对 RMS ≈ 9.5%（对照 RT4 int4/128 的 ≈ 12%）。
代价是预填充慢 15%：RT4 的 W4A8 虽然跑两遍 int4 GEMM，每遍都比 NVFP4 GEMM 快得多。
默认**不开**这条路（默认就是 RT4 int4/W4A8）；要开就 `NVFP4_ALL=mlp|all bash scripts/pack_weights.sh`。

第二，**解码便宜**。`v_perm_b32` 当 8 字节 LUT，一个打包字解成两组 int8 约 19 条
指令（2.6 条/元素），在访存受限的解码里是白送的。

第三，**GEMV 走 128 位载入**，GEMM 的 shared 必须**转置**（否则 16 路 bank 冲突，
3.57 → 13.07 TMAC/s）。

第四，**无 DTK 投递层**。HSA 的 AQL `setup` 低 2 位是 grid 维度数（不是「已初始化」
标志）；写死 1D 会让 `grid_size_y/z` 被合法忽略，多维 grid 的内核只有第一个平面
被派发。这条在本项目里已经按实际维度写入。

第五，**对话 KV 复用**。网页每轮都把整段 `messages` 重新渲染送进来，token 序列天然是
上一轮的前缀；引擎记住「这条对话已经缓存到哪个 token」，下一轮只补差量
（`append` / `rewind`），不再整段重算。实测每轮预填充从「整段历史」（几百到几千
token、1.7~10 秒）降到 **18 token、0.32 秒**，回答逐字节不变。
再进一步：服务端记住「实际提交给引擎的 token 序列」，助手那一轮**完全不重新分词**
（BPE 解码→重编码不保证可逆，照搬文本回传会在思考段中间分叉），于是网页回传也能
**完全命中**——每轮只算「新用户那句话 + 生成提示」十几个 token。快照点还对到 V 量化
tile 的边界，且改了历史 / 换了会话时由服务端显式要求整段重算（`PREFILL_NR`），
保证「切走再回来」与整段重算逐字节一致。
细节见 [docs/KV-REUSE.md](docs/KV-REUSE.md)，可用 `RT_NO_KV_REUSE=1` 关掉做 A/B。

第六，**KV cache 跑在 int8**。16 个注意力层的 K/V 都按 int8 打包：每个 dword 装
`KVEL=4` 个元素、每组尺度 `amax/127`，Q 与 P 跟着同一宽度，于是 `QK^T` 与 `P·V`
都能直接用 `v_dot4_i32_i8`。位宽是**全局**的一个选择（`kernels/kv_pack.h` 的
`KV_BITS`，默认 8），`-DKV_BITS=4` 可以整条通路回退到 int4 做 A/B；启动日志会打
`KV cache：int8（KVEL=4，每 dword 4 个元素，尺度 amax/127）`。

## 依赖

**部署包内**自带（无需联网、无需 pip；GitHub 源码仓库里只放源码，权重、第三方驱动
二进制、自带 Python 运行库都不在仓库里 —— 见 `.gitignore` 与 `NOTICE`）：

| 依赖 | 用途 | 位置 |
|---|---|---|
| Python 3.10 解释器 | 汇编内核、起服务 | `runtime/python/` |
| fastapi / uvicorn / tokenizers / jinja2 / numpy / pillow / msgpack | 网页、对话、打包 | `runtime/py/` |
| 预编译引擎 `build/rt` + 单个 HSACO | 直接运行 | `prebuilt/` |
| DCU 驱动安装包 + `/usr/local/hyhal` 快照 | 跑内核（HSA） | `driver/` |

包外的只有两样：

| 依赖 | 用途 | 说明 |
|---|---|---|
| DCU 驱动（内核模块 + `/dev/kfd`） | 跑内核 | 必须装，见 `driver/INSTALL.md` |
| `g++` | 重新编译 host 代码 | 只有 `bash build.sh` 才需要；纯部署/运行不需要 |

另外 DTK 工具链与 Docker **完全不需要**。`runtime/` 下自带的 Python 依赖优先于
系统 Python；想换成自己的环境时，`RT_PYTHON` / `RT_PY_DEPS` 可以覆盖
（见 `scripts/env.sh`），也可以直接 `python3 -m pip install -r requirements.txt`。

## 许可与第三方内容

本项目代码以 **Apache-2.0** 发布（合并自 K100LC-RT4 的 Apache-2.0 与
k100lc-fast-nvfp4 的 MIT）；第三方内容与驱动二进制见 `NOTICE`。
