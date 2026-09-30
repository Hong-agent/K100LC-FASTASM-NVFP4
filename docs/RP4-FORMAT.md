# `.rp4`：一个自包含的模型文件

`tools/rp4_pack.py` 把**模型要用到的全部权重**合成一个文件，运行时只认这一个文件。

```bash
bash scripts/pack_weights.sh       # -> build/model-int4.rp4（默认 14.351 GB，约 30 秒）
```

## 文件布局

```
偏移 0        头（64 字节）
偏移 64       索引（TSV 文本，约 128 KB）
偏移 131072   载荷（按加载顺序排好的权重字节，4096 对齐）
```

头（小端）：

```
char magic[8]   "K100RP4\0"
u32  version    1
u32  flags      0
u64  index_off
u64  index_len
u64  data_off   （= 131072，4096 对齐，为了 O_DIRECT）
u64  data_len
u64  count      索引行数
u8   reserved[8]
```

索引（TSV，10 列）：

```
type  part  name  kind  N  K  group  off  nbytes  soff  gscale
```

| 字段 | 含义 |
|---|---|
| `type` | `t` 普通张量；`nvp` NVFP4 的 weight_packed；`nvs` NVFP4 的 weight_scale |
| `part` | `main` 主模型；`mtp` MTP 头；`visual` 视觉塔 |
| `off` / `soff` | 载荷内的字节偏移（**同时就是设备显存偏移**）；`soff` 是 i4 张量的尺度区 |

关键性质：**载荷顺序 == 文件偏移 == 设备偏移 == 加载顺序**。所以运行时
不需要重排、不需要 `d_delta`，读进来直接就能用。

## 里面装了什么

默认布局（`bash scripts/pack_weights.sh`，**主模型 W4A8 / MTP W8A8 / 不装视觉塔**）：

```
main    851 个  = 主模型全部张量，原样保留 RT4 的 int4 权重（W4A8：int4 权重 ×
                  int8 激活）。**不做任何 NVFP4 替换**，所以一个张量都不丢。
mtp      23 个  = MTP 头，int8/W8A8（每个矩阵拆成 <name>.hi / <name>.lo 两张 int4）
visual    0 个  = 不装：引擎单独读 rt4/qwen38_27b_vision.rt4，27 层在 DCU 上跑
```

合计 **874 条索引、14.351 GB 载荷**（`qwen38_27b.rt4` 13.91 + `mtp_w8.rt4` 0.44）。
引擎只读这一个文件；视觉塔是**独立的一份** `rt4/qwen38_27b_vision.rt4`（0.93 GB），
由引擎自己加载到显卡（`RT_VISION_DEVICE=gpu`，默认）或交给 CPU 编码器（`cpu`）。

**NVFP4 直跑是 opt-in**（`NVFP4_ALL=mlp` / `NVFP4_ALL=all`，旧的 `0`/`1` 等价）。
那时主模型里被取代的线性层张量在载荷里**整段丢掉**，换成一堆 NVFP4 张量：

| 布局 | 主模型 | mtp | visual | 索引 | 载荷 |
|---|---|---|---|---|---|
| 默认 | W4A8（int4） | w8（23） | 不装 | 874 | 14.351 GB |
| `NVFP4_ALL=mlp` | MLP 168 个走 NVFP4 | w8 | 不装 | ~1543 | 15.984 GB |
| `NVFP4_ALL=all` | 401 个线性层走 NVFP4 | w8 | 不装 | ~2009 | 16.482 GB |
| 加 `VISION_RP4=1` | 同上 | 同上 | 333 个装进来 | +333 | +0.93 GB |

`mlp` 档：168 个 MLP 是 checkpoint 原生 NVFP4（权重零误差），其余线性层留 RT4 int4；
`all` 档：另外 233 个（注意力/线性注意力投影、lm_head、第 56~63 层 MLP）由
`tools/nvfp4_quant.py` 从 FP8 按同一规格重量化。各档性能见 [BENCHLOG.md](BENCHLOG.md)。

**MTP 头默认是 int8（W8A8）**：checkpoint 里的 MTP 是 BF16，直接按 int4 量化误差
≈12.8%，会拖投机解码的接受率。`tools/mtp_w8_pack.py`（`scripts/convert_weights.sh`
默认会跑）把每个矩阵的 int8 量化码拆成 `w8 = 16*wh + wl`，输出
`rt4/qwen38_27b_mtp_w8.rt4`——两张 int4 张量共用同一个组尺度（hi 的预乘 16），
运行时「hi 跑一遍 int4 + lo 再跑一遍再相加」就等价于 int8 权重 × int8 激活，
不需要新内核。误差 12.8% → 0.9%。

运行时靠「索引里没有 `mtp.fc.weight`、只有 `mtp.fc.weight.hi`」自动识别这个格式
（`src/model.cpp` 的 `mtp.w8`），所以打进 `.rp4` 之后不用开任何开关。代价是
MTP 张量从 15 个变成 23 个、载荷 +219 MB。想回到 int4 版：
`MTP_W8=0 bash scripts/pack_weights.sh`（打包时）或 `MTP_W8=0 bash scripts/convert_weights.sh`（转换时）。

## 运行时怎么用

```
读 64 字节头 -> 读索引 -> 从 data_off 起把整段载荷顺序读进显存（O_DIRECT）
```

载荷按前向顺序分组（embedding / 第 0~63 层 / 其余全局 / MTP），
加载线程跨过某一组的结束偏移时就记该组的事件；`forward()` 用到第 il 层之前
`hipStreamWaitEvent` 等它，加载与计算重叠。

引擎**只打开这一个文件**（可以用 `ls -l /proc/<引擎PID>/fd` 核对）——默认布局里
MTP 也在里面；视觉塔**不在里面**，引擎另外读 `rt4/qwen38_27b_vision.rt4`（27 层在
DCU 上跑，`RT_VISION_DEVICE=gpu` 默认；设 `cpu` 则改由 `scripts/vision_cpu.py`
用 NumPy 算，引擎不加载那 0.93 GB）。只有 `VISION_RP4=1` 打包时才连视觉塔一起装进来。

## 开关与回退

| 变量 | 作用 |
|---|---|
| `RT_RP4=<path>` | 指定 `.rp4`；本项目里默认由 `scripts/env.sh` 指到 `models/Qwen3.8-27B-INT4/model.rp4`（int4，全项目默认），找不到再退 `build/model-int4.rp4` |
| `RT_RP4=0` | 关掉单文件模式 |
| `RT_PACKED=<packed.bin>` | 退一级：用 `tools/nvfp4_pack.py` 产出的连续权重文件 + TSV |
| `RT_PACKED=0` | 再退一级：从两个源文件按张量散读 |
| `RT_VISION_DEVICE=gpu\|cpu` | 视觉塔在哪跑：`gpu`（**默认**，引擎的 IMG_EMB，权重读 `RT_VISION_RT4` 或 `.rp4` 的 visual 部分）/ `cpu`（纯 NumPy，引擎不加载视觉权重） |
| `RT_VISION_RT4=<path>` | CPU 编码器 / GPU 回退读的视觉 RT4 文件 |

回退链是自动的：`.rp4` 打不开就用 `packed.bin`，再打不开就散读。
`RT_NVFP4=0`（跑纯 int4 路线）时会自动跳过 `.rp4`，因为里面没有 MLP 的 int4 权重。
