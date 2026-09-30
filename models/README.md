# models/

权重不随源码包发布。这里只放**软链接**，指向本机已有的权重，
由 `bash scripts/setup_models.sh` 生成。

## 默认模型：`Qwen3.8-27B-INT4/`（全项目默认）

源 checkpoint 是 `RedHatAI/Qwen3.8-27B-INT4`（compressed-tensors
`pack-quantized` int4，group_size 128），由 `tools/convert.c` 的 int4 分支转成 RT4。
`scripts/env.sh` 把 `RT_MODEL_DIR` 默认指到这里，所以 `serve.sh` / `run.sh` /
`deploy-offline.sh` 开箱即用：

```
models/Qwen3.8-27B-INT4/
    config.json / generation_config.json / tokenizer.json / tokenizer_config.json
    processor_config.json / recipe.yaml / chat_template.jinja   -> 原始 checkpoint
    model.safetensors / model_mtp.safetensors                   -> 原始 checkpoint
    rt4/                                                        -> 转换后的 RT4 权重
        qwen38_27b.rt4(.json)        int4 主模型（注意力、线性注意力、embed、lm_head…）
        qwen38_27b_mtp_w8.rt4(.json) MTP 投机解码头（int8/W8A8，默认用这份）
        qwen38_27b_mtp.rt4(.json)    MTP 头（int4，MTP_W8=0 时用）
        qwen38_27b_vision.rt4(.json) 视觉塔
    model.rp4                    -> build/model-int4.rp4（单文件：头+索引+载荷）
```

## opt-in：`Qwen3.8-27B-NVFP4/`

上游 NVFP4 checkpoint（`unsloth/Qwen3.8-27B-NVFP4`）那一份，保留下来做对照与
NVFP4 直跑实验。要用它（而不是 int4）跑：

```bash
RT_MODEL_DIR=models/Qwen3.8-27B-NVFP4 RT_RP4=build/model.rp4 bash serve.sh
```

目录布局与上面一致，`model.rp4 -> build/model.rp4`。

## 运行时实际需要什么

* 有 `model.rp4` —— 只读这一个文件（主模型 + MTP 都在里面）。
* 没有 `model.rp4` —— 退回「`rt4/qwen38_27b.rt4` + NVFP4 清单 + 原始 safetensors 直读」，
  清单由 `python3 tools/nvfp4_layout.py model.safetensors build/nvfp4_manifest.tsv` 生成。

把权重换成别的模型时，`RT_MODEL_DIR` / `RT_RT4` / `RT_RP4` 都能覆盖（见 `scripts/env.sh`）。
转换器 `tools/convert.c` 是自研的，用主机 `gcc` 编译，不需要 DTK。
