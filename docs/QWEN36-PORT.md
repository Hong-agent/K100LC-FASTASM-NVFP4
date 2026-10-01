# 适配 Qwen3.6-35B-A3B（Q8_0 GGUF + MTP）

> 状态：**进行中**。权重在下载（`models/Qwen3.6-35B-A3B-q8/`），
> 结构盘点与权重清单已完成；运行时（MoE 层 + Q8_0 通路 + MTP）待实现。

## 1. 目标权重

| 文件 | 体积 | 说明 |
|---|---:|---|
| `unsloth/Qwen3.6-35B-A3B-MTP-GGUF` → `Qwen3.6-35B-A3B-Q8_0.gguf` | 37.80 GB | 主模型 + MTP（blk.40），753 张量 |
| 同仓库 `mmproj-F16.gguf` | 0.90 GB | 视觉塔（独立文件） |

GGUF v3 元数据（`tools/gguf_head.py` 读出）：

```
general.architecture = qwen35moe      block_count        = 41  (40 层 + 1 MTP)
embedding_length     = 2048           head_count         = 16
head_count_kv        = 2              key/value_length   = 256
expert_count         = 256            expert_used_count  = 8
expert_ffn_length    = 512            shared_ffn_length  = 512
ssm.conv_kernel = 4  ssm.state_size = 128  ssm.group_count = 16
ssm.time_step_rank = 32               ssm.inner_size     = 4096
full_attention_interval = 4           nextn_predict_layers = 1
rope dimension_count = 64  freq_base = 1e7  sections = [11,11,10,0]
context_length = 262144               vocab = 248320（与 27B 同一套分词）
```

张量类型分布：**Q8_0 ×443、F32 ×308、BF16 ×2**（Q8_0 = 32 权重/块 + f16 尺度，
8.5 bit/权重）。完整清单：`models/Qwen3.6-35B-A3B-q8/tensor_manifest.tsv`
（name / type / dims / offset / bytes，共 753 行）。

### 单层张量（blk.N）

| 类别 | 张量 | 形状 |
|---|---|---|
| 线性注意力层（N%4≠3，30 层） | `attn_gate` / `attn_qkv` / `ssm_alpha` / `ssm_beta` / `ssm_out` | [2048,4096] / [2048,8192] / [2048,32] / [2048,32] / [4096,2048] |
| | `ssm_conv1d` / `ssm_a` / `ssm_dt.bias` / `ssm_norm` | f32 小张量 |
| 全注意力层（N%4=3，10 层） | `attn_q` / `attn_k` / `attn_v` / `attn_output` | [2048,8192] / [2048,512] / [2048,512] / [4096,2048] |
| MoE（每层都有） | `ffn_gate_inp`（路由） | F32 [2048,256] |
| | `ffn_gate_exps` / `ffn_up_exps` | Q8_0 [2048,512,256] |
| | `ffn_down_exps` | Q8_0 [512,2048,256] |
| | `ffn_gate_inp_shexp` / `ffn_gate_shexp` / `ffn_up_shexp` / `ffn_down_shexp` | 共享专家（1 个） |
| norm | `attn_norm` / `post_attention_norm` | F32 [2048] |

MTP 层 `blk.40` = 一个完整全注意力层 + MoE，另加
`nextn.eh_proj`[4096,2048]、`nextn.enorm`、`nextn.hnorm`、`nextn.shared_head_norm`。

## 2. 与当前运行时的差距

现在 `src/model.cpp` 只支持**稠密** 27B（`Cfg` 全部硬编码、MLP 是 3 张 i4 矩阵）。
要跑这个模型，缺的是：

1. **配置参数化**：`Cfg` 里的 hidden/layers/heads/ssm/MoE 维度全部要从
   `config.json`（或 GGUF 元数据）读，不能再写死 5120/64 层。
2. **GGUF 权重通路**：现在只有 RT4（转换后）与 NVFP4/rp4。GGUF 要新增
   「按张量表 pread → 显存」的加载器（753 张量、37.8 GB，全驻留显存）。
3. **Q8_0 内核**：`K100LC-kernels` 里已有 `q8_0_dot_k`（融合解码+点积）与
   `q8_0_dequant_k`，已同步进本项目（119 内核 HSACO）。专家索引
   （`rows_per_exp` + `magic_rpe`）参数在 ABI 里，可直接用于 256 专家的批选。
4. **MoE 层**：路由 `ffn_gate_inp` → softmax → top-8 → 逐专家
   gate/up/down → 加权合并；再加共享专家（`ffn_gate_inp_shexp` 是 **sigmoid 门**）。
   内核包里现成的 `router_top10_k` 是 **top-10 固定**，top-8 需要改一个变体
   （或写一个 256→8 的小内核）。
5. **MTP**：`blk.40` 的结构与本项目 27B 的 MTP 头不同（这里是「一层完整
   注意力 + MoE + nextn.eh_proj」），要按它的张量名重写 MTP 前向与 KV。
6. **视觉**：改为读 `mmproj-F16.gguf`（不是现在的 RT4 视觉塔）；投影输出维度
   是 2048（27B 是 5120）。

## 3. 显存 / 磁盘预算

| 项 | 数值 |
|---|---|
| 权重（Q8_0 全驻留） | 37.79 GB |
| KV（10 个全注意力层，int8，40k ctx） | ≈0.42 GB |
| SSM 状态 + 工作区 | ≈2 GB |
| 合计 | ≈40 GB（卡 64 GB，余量充足） |
| 磁盘 | 下载 38.7 GB（Q8 + mmproj），当前可用 75 GB |

## 4. 实施里程碑

| 阶段 | 内容 | 验收 |
|---|---|---|
| M1 | `Cfg` 从 config.json/GGUF 元数据读取；新增 `models/Qwen3.6-35B-A3B/` 模型档案 | `rt --engine --model-profile qwen36` 能起、打印 40 层配置 |
| M2 | GGUF 加载器：张量表 → mmap/pread → 显存；Q8_0 视图 | 753 张量全部就位，体积对账 37.79 GB |
| M3 | 线性/全注意力 + SSM 用新维度跑通（先不做 MoE，路由换恒等） | 单层数值与参考实现对齐 |
| M4 | MoE：路由 top-8 + 专家批选 + 共享专家 | 整模型 logits 与 llama.cpp 对齐 |
| M5 | MTP（blk.40）+ 投机解码 | 接受率 > 40% |
| M6 | 视觉（mmproj-F16）+ serve/run 入口 + 离线包 | 网页/图片请求通 |

## 5. 工具

```bash
# 读 GGUF 头（元数据 + 张量清单），只需文件开头就能工作
python3 tools/gguf_head.py models/Qwen3.6-35B-A3B-q8/Qwen3.6-35B-A3B-Q8_0.gguf --tensors --grep blk.40
python3 tools/gguf_head.py <gguf> --tsv <out.tsv>       # 落成加载映射表
```

参考：`K100LC-kernels/docs/ABI.md`（Q8_0 点积/解码、router_top10_k、
专家索引参数），以及本项目 `docs/RT4-FORMAT.md`（现有权重通路）。
