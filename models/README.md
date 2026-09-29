# models/

权重不随源码包发布。这里只放**软链接**，指向本机已有的权重，
由 `bash scripts/setup_models.sh` 生成：

```
models/Qwen3.8-27B-NVFP4/
    config.json / tokenizer.json / vocab.json / chat_template.jinja      -> 原始 checkpoint
    model.safetensors / model_mtp.safetensors                            -> 原始 checkpoint（NVFP4 权重来源）
    rt4/                                                                 -> 转换后的 RT4 权重
        qwen38_27b.rt4(.json)        int4 主模型（注意力、线性注意力、embed、lm_head…）
        qwen38_27b_mtp.rt4(.json)    MTP 投机解码头
        qwen38_27b_vision.rt4(.json) 视觉塔
    model.rp4                                                             -> 可选：单文件（头+索引+载荷）
```

运行时实际需要什么：

* 有 `model.rp4` —— 只读这一个文件（主模型 + NVFP4 + MTP + 视觉塔都在里面）。
* 没有 `model.rp4` —— 退回「`rt4/qwen38_27b.rt4` + NVFP4 清单 + 原始 safetensors 直读」，
  清单由 `python3 tools/nvfp4_layout.py model.safetensors build/nvfp4_manifest.tsv` 生成。

把权重换成别的模型时，`RT_MODEL_DIR` / `RT_RT4` / `RT_RP4` 都能覆盖（见 `scripts/env.sh`）。
转换器 `tools/convert.c` 是自研的，用主机 `gcc` 编译，不需要 DTK。
