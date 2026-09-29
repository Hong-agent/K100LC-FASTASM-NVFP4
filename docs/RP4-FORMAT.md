# `.rp4`：一个自包含的模型文件

`tools/rp4_pack.py` 把**模型要用到的全部权重**合成一个文件，运行时只认这一个文件。

```bash
bash scripts/hybrid.sh pack        # -> build/model.rp4（约 15.8 GB，30 秒）
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

```
main    851 个  = 主模型全部张量，但**减掉**被 NVFP4 取代的 168 个 MLP 张量
                  （这 168 个仍留一条 0 字节的元数据行，因为运行时还要查它们的 N/K）
nvfp4   336 个  = 168 个 weight_packed + 168 个 weight_scale
mtp      15 个
visual  333 个
```

合计 1535 条索引、15.765 GB 载荷。原来分散在 4 个文件里
（`qwen38_27b.rt4` 13.91 + `_mtp.rt4` 0.22 + `_vision.rt4` 0.93 + `model.safetensors` 22.57 GB），
打包时把被取代的 7.72 GB MLP 整段丢掉。

## 运行时怎么用

```
读 64 字节头 -> 读索引 -> 从 data_off 起把整段载荷顺序读进显存（O_DIRECT）
```

载荷按前向顺序分了 69 组（embedding / 第 0~63 层 / 其余全局 / MTP+视觉），
加载线程跨过某一组的结束偏移时就记该组的事件；`forward()` 用到第 il 层之前
`hipStreamWaitEvent` 等它，加载与计算重叠。

运行时**只打开这一个文件**（可以用 `ls -l /proc/<引擎PID>/fd` 核对），
原来那三个 `.rt4` 和 safetensors 一个都不需要。

## 开关与回退

| 变量 | 作用 |
|---|---|
| `RT_RP4=<path>` | 指定 `.rp4`；本项目里默认由 `scripts/env.sh` 指到 `models/Qwen3.8-27B-NVFP4/model.rp4` |
| `RT_RP4=0` | 关掉单文件模式 |
| `RT_PACKED=<packed.bin>` | 退一级：用 `tools/nvfp4_pack.py` 产出的连续权重文件 + TSV |
| `RT_PACKED=0` | 再退一级：从两个源文件按张量散读 |

回退链是自动的：`.rp4` 打不开就用 `packed.bin`，再打不开就散读。
`RT_NVFP4=0`（跑纯 int4 路线）时会自动跳过 `.rp4`，因为里面没有 MLP 的 int4 权重。
