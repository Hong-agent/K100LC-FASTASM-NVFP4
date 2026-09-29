# NVFP4 格式：逐位说明与实测核对

对应 checkpoint：`unsloth/Qwen3.8-27B-NVFP4`（compressed-tensors，`nvfp4-pack-quantized`）。
本文的每一条都在本机用真实权重核对过，核对脚本是 [../tools/nvfp4_ref.py](../tools/nvfp4_ref.py)。

## 1. 张量清单

`config.json` 的 `quantization_config.config_groups` 里有两组：

| 组 | 格式 | 覆盖 |
|---|---|---|
| `group_0` | `float-quantized`（FP8 E4M3，权重逐通道、激活逐 token） | 注意力投影、线性注意力投影、`lm_head`、第 56~63 层 MLP |
| `group_1` | `nvfp4-pack-quantized` | **所有 MLP 的 `gate/up/down_proj`** |

扫一遍 safetensors 头部的统计（`tools/nvfp4_layout.py`）：

```
NVFP4 张量 168 个   =  56 层 x 3 个投影
  打包权重  7.487 GB     U8
  块尺度    0.936 GB     F8_E4M3
  MAC 总计  14.974 G/次
```

每个 NVFP4 线性层在文件里是三个张量：

```
<stem>.weight_packed        U8       [N, K/2]
<stem>.weight_scale         F8_E4M3  [N, K/16]
<stem>.weight_global_scale  F32      [1]
<stem>.input_global_scale   F32      [1]     -- 参考实现量化激活用的，本项目不用
```

实测形状：`gate/up_proj` = `[17408, 2560]`（即 N=17408, K=5120），
`down_proj` = `[5120, 8704]`（即 N=5120, K=17408）。`weight_scale` 的第二维
恰好是 `K/16`，说明**块沿 K（输入维）划分，每 16 个一组**。

## 2. 两个 LUT

### E2M1（1 符号 + 2 指数 + 1 尾数）

```
code c: s = bit3, e = (c>>1)&3, m = c&1
        e == 0 : v = 0.5 * m
        e >= 1 : v = (1 + 0.5*m) * 2^(e-1)
        value  = s ? -v : v

code 0..7  ->  0, 0.5, 1, 1.5, 2, 3, 4, 6
code 8..15 ->  -0, -0.5, -1, -1.5, -2, -3, -4, -6
```

### E4M3（1 符号 + 4 指数 + 3 尾数，bias 7）

```
code i: s = bit7, e = (i>>3)&0xF, m = i&7
        e == 0 : v = (m/8) * 2^-6            (次正规)
        e == 15 && m == 7 : NaN
        else   : v = (1 + m/8) * 2^(e-7)
```

**gfx926 上没有 `v_cvt_f32_fp8` / `v_cvt_f32_bf8`**（汇编器直接报
`instruction not supported on this GPU`），所以 E4M3 只能自己拼位或查表。
本项目用位运算拼（`include/nvfp4/nvfp4_decode.h` 的 `nvfp4_e4m3_to_f32`），
每 16 个权重才用一次，成本可忽略；GEMV 里进一步把它预计算成 256 项 shared 表。

## 3. 半个字节的顺序

`weight_packed[n, j]` 的第 j 个字节装第 `2j`（低半字节）和 `2j+1`（高半字节）个 k：

```c
code = (k & 1) ? (packed[n][k>>1] >> 4) : (packed[n][k>>1] & 0xF);
```

这一条与 `K100LC-RT4/tools/convert.c` 里已经用 BF16 原模型验证过的实现一致。

## 4. 反量化公式，以及它是怎么被独立核对过的

```
w[n,k] = e2m1(code) * e4m3(weight_scale[n, k/16]) / weight_global_scale
```

注意 `weight_global_scale` 在**分母**（compressed-tensors 的约定）。这一条不能靠
猜——用两条独立证据钉死：

**证据一：量级必须合理。** 反量化 `layers.0.mlp.gate_proj` 前 8 行：

```
gscale = 6400     mean = 0.00013   std = 0.01007   amax = 0.04875
```

5120 维的线性层权重 std ≈ 0.01 是合理的；若误用 `* gscale`，std 会变成 4.3e5，
显然荒谬。

**证据二：块内最大幅值必须落在 `6/gscale * scale` 上。** 因为 E2M1 的最大幅值是 6，
一个被正确缩放的块，其最大码应该顶到 6。实测（前 4 行 x 全部 320 个块）：

```
每个块的 max|code|  = 6.0   （最小值、均值、最大值全是 6）
块内 amax / (6*scale/gscale) = 1.0000
block_amax_w / (6 * scale / gscale) = 1.0
```

320 个块无一例外地顶满，说明公式里的方向（除还是乘）和常数（6）都对。

`tools/nvfp4_ref.py --inspect <safetensors> <张量名>` 可以随时复跑这两条。

## 5. 与内核的对应关系

| 格式里的东西 | 内核里怎么看 |
|---|---|
| `weight_packed` `[N, K/2]` | `const uint32_t*` 的 `[N][K/8]`，一个字 = 8 个码 |
| `weight_scale` `[N, K/16]` | 每行 `K/16` 个 E4M3 字节；GEMV 先过一张 256 项 shared 表变成 f32 |
| `weight_global_scale` | 主机的 `1.0f / gscale`，在表里就乘好 |
| 偶数 k 在低半字节 | `x & 0x0F0F0F0F` 得到偶数码，`(x>>4) & 0x0F0F0F0F` 得到奇数码 |

内核**没有任何重排**：清单给的文件偏移直接落到显存，`[N][K/8]` 的行主序与
`[N][K/16]` 的行主序就是内核的寻址方式。
