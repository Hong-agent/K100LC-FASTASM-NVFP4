# 联网从零部署（源码包）

从一台**裸机**（装了海光 K100_LC 的卡、能上网）到网页控制台，全部步骤。
不需要 DTK、不需要 Docker；只有装驱动那一步需要 `sudo` 与内核头文件。

## 0. 需要什么

| 项 | 要求 | 从哪来 |
|---|---|---|
| 机器 | 海光 K100_LC（gfx926）+ DCU 卡 | 硬件 |
| 系统 | Ubuntu 22.04（22.04.5 实测） | 自带 |
| 编译器/工具 | `g++ gcc make cmake autoconf m4 curl python3` | `apt install` |
| DCU 驱动 | 包内 `driver/installer/rock-*-不限内核.aio.run` | 本包 |
| 源模型 | `unsloth/Qwen3.8-27B-NVFP4`（22.57 GB + 0.85 GB） | `scripts/fetch_model.sh` 从魔搭拉 |
| 磁盘 | 源权重 23.4 GB + 转换产物 15.2 GB + 单文件 15.8 GB ≈ **55 GB** | 本地 |

## 1. 装系统依赖

```bash
sudo apt update
sudo apt install -y build-essential cmake autoconf m4 curl python3 python3-pip \
                    linux-headers-$(uname -r)
python3 -m pip install -r requirements.txt      # 只给网页/对话用；引擎不需要
```

## 2. 装 DCU 驱动

```bash
sudo bash driver/installer/rock-5.7.1-6.2.35-V1.6.7-不限内核.aio.run
sudo reboot
/opt/hyhal/bin/hy-smi        # 看得到 DCU 0
```

驱动包**不锁内核版本**：它用**当前正在运行的内核**现编模块，装完即可；
以后换内核重跑一次安装包就行。细节与实测坑见 `driver/INSTALL.md`。

## 3. 一条龙（或分步）

```bash
bash scripts/deploy_online.sh          # 环境检查 → 装依赖 → 下模型 → 转换 → 打包 → 编译
```

分步等价于：

```bash
bash scripts/fetch_model.sh            # 下源权重（16 连接断点续传，~22.6 GB）
bash scripts/setup_models.sh           # 把权重接进 models/Qwen3.8-27B-NVFP4/
bash scripts/convert_weights.sh        # 转成 RT4（主机 gcc，约 4.5 分钟）
bash scripts/pack_weights.sh           # 合成单文件 model.rp4（约 15.8 GB，几分钟）
bash build.sh                          # 自研汇编器汇编 80 内核 → HSACO → g++ 编出 build/rt
```

每一步都是幂等的，跑一半断了再跑一次即可（下载也会断点续传）。

## 4. 跑起来

```bash
bash serve.sh                    # 网页 http://<本机IP>:8080/ + OpenAI 兼容接口
bash serve.sh --stop
bash run.sh --prompt "你好" --n 64
```

* 网页里的「最多 token」默认 **40960**，上下文默认 **40960**；
  显存紧就 `CTX=16384 bash serve.sh`。
* 引擎启动日志会打 `KV cache：int8（KVEL=4，每 dword 4 个元素，尺度 amax/127）`。

验证接口：

```bash
curl -s localhost:8080/v1/chat/completions -H 'Content-Type: application/json' \
  -d '{"messages":[{"role":"user","content":"1+1=?"}],"max_tokens":16}'
```

## 5. 只想要「能跑」不想转权重？

源码包里带了预编译引擎（`prebuilt/rt` + `prebuilt/k100lc_all.hsaco`），
跑 `run.sh` / `serve.sh` 时会自动用它；**只有改内核/改运行时才需要 `build.sh`**。
权重仍然要按第 3 步准备（源模型 → RT4 → model.rp4）。

如果连转换也不想在目标机做，可以直接用离线整包
`K100LC-FASTASM-NVFP4-离线部署-<日期>.zip`（里面已经带了 `model.rp4`）。

## 6. 常见问题

| 现象 | 处理 |
|---|---|
| `build.sh` 报缺 `/opt/hyhal` | 驱动没装：回第 2 步 |
| `fetch_model.sh` 下载很慢 | 换源：`SOURCE=hf bash scripts/fetch_model.sh`（HF 直连可能被 302） |
| `convert_weights.sh` 报缺 `qwen38_27b_vision.rt4.json` | 视觉塔转换要走 `tools/convert_vision_rt4.py`，需要 `numpy`：`pip install numpy` |
| 网页起来但回答不出 | `tail -f build/serve.log`；第一次请求会与权重后台加载重叠，稍等即可 |
| 想确认内核机器码没变 | `bash build.sh --check`（与参考逐字节比对 + HSA 加载检查） |
