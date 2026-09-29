# K100LC-FASTASM-NVFP4

海光 **K100_LC（gfx926）** 上的自研推理栈：**自研汇编器 + 无 DTK 运行时 +
NVFP4 权重直跑**，同一个项目里跑完整 27B 模型，并自带网页控制台。

本项目由两条独立路线合并而来：

* **k100lc-fast-nvfp4** —— 把 compressed-tensors 的 **NVFP4** checkpoint
  *不转换、不重量化、不重排*，按原生布局直接算（权重侧零误差）；
* **k100lc-asm** —— 自研表驱动**汇编器**与**无 DTK 运行路径**（不链接 hipcc /
  libgalaxyhip / libamd_comgr，只用 `/opt/hyhal` 的 HSA 运行时）。

合并后：模型、内核、运行时、网页在**一个自包含目录**里，**不需要 DTK 环境，
也不需要 Docker**，编译只要主机 `g++`，跑只要驱动自带的 HSA。

## 一句话

> 80 个模型内核由自研汇编器从 `.s` 汇编出来，逐字节等于原 DTK 编译产物；
> 打成一个 363,560 字节的 HSACO；运行时只链接 `libhsa-runtime64`（DTK 库引用
> **0**）；MLP 的 168 个张量用 checkpoint 原样的 NVFP4 直跑（权重零误差）。

## 快速开始

```bash
# 0) 接上本机已有的权重（软链接，不复制、不下载）
bash scripts/setup_models.sh

# 1) 一条命令构建：汇编内核 -> 单个 HSACO -> 生成 host 源码 -> g++ 编出 build/rt
bash build.sh

# 2) 命令行对话
bash run.sh --prompt "你好，用一句话介绍你自己" --n 64

# 3) 网页控制台（+ OpenAI 兼容接口）
bash serve.sh                     # http://<本机IP>:8080/
bash serve.sh --stop
```

> 源码包里带了 `prebuilt/rt` 与 `prebuilt/k100lc_all.hsaco`，**不编译也能直接跑**：
> `run.sh` / `serve.sh` 找不到 `build/rt` 时会自动用 `prebuilt/rt`。
> `build.sh` 只在你要重新生成内核机器码或改内核时才需要（那时才要主机 `g++`）。

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
bash scripts/make_offline_package.sh  # → dist/K100LC-FASTASM-NVFP4-离线部署-<日期>.zip（~16.3 GB）
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

`setup_models.sh` 默认从桌面找权重；也可以显式指定：

```bash
MODEL_SRC=/path/to/Qwen3.8-27B-NVFP4 \
RT4_DIR=/path/to/converted/rt4 \
RP4=/path/to/model.rp4 bash scripts/setup_models.sh
```

## 实测（本机 K100_LC，2026-09-29）

| 环节 | 结果 |
|---|---|
| 自研汇编器 | 80/80 个模型内核从 `.s` 汇编，**逐字节等于原 DTK 编译产物**（207,296 B） |
| 自研 HSACO | 单文件 **363,560 B**，含 80 个内核；HSA 解析全部符号并执行 |
| 运行时依赖 | `build/rt` 只链接 **libhsa-runtime64.so.1**；DTK 库引用 **0** |
| 模型加载 | `.rp4` 单文件 **15.765 GB**，1535 张量（main 851 / NVFP4 168 / MTP+视觉 348） |
| NVFP4 直跑 | **168 个 MLP 张量**改为原样 NVFP4 直跑（**8.423 GB，权重零误差**） |
| KV cache | 16 个注意力层跑 **int8**（每 dword 4 个元素，尺度 `amax/127`，与 Q/P 同走 `v_dot4_i32_i8`） |
| 端到端对话 | 64 层模型，预填充 58 token，生成 48 token（墙钟 1.49 s），输出连贯 |
| 网页 / 接口 | `GET /`（控制台）、`GET /style.css`、`GET /health`、`POST /v1/chat/completions` 全部正常 |

## 目录

| 路径 | 内容 |
|---|---|
| `asm.py`、`encodings.json` | **自研表驱动汇编器**与指令编码表（424+ 个编码形式） |
| `kernels/asm/` | 80 个内核的 `.s` 源码（自研汇编器语法） |
| `kernels/kernel_spec.json` | 每个内核的参数表、kernarg/段大小、SGPR/VGPR 计数 |
| `kernels/kv_pack.h` 等 | 内核共用常量与 RT4 内核头 |
| `kernels/nvfp4/`、`include/nvfp4/` | **NVFP4** 解码 GEMV / GEMM 内核与 FP4→int8 原语 |
| `runtime/hsa_rt.{h,cpp}` | **无 DTK 运行时**：HSA 队列、投递、内存、同步的 HIP 兼容垫片 |
| `src/model.cpp`、`src/k_*.hip` | 模型与内核启动代码（host 侧由 `tools/gen_nodtk.py` 自动改写） |
| `web/index.html`、`web/style.css` | 网页控制台（从 K100LC-RT4 搬入本项目） |
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
build/kernels/*.bin ──► tools/make_hsaco_multi.py ──► build/k100lc_all.hsaco（80 内核）
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
bash serve.sh                    # 默认 8080；网页 maxtoken 默认 40960、上下文 40960
PORT=80 CTX=16384 MTP_N=0 bash serve.sh
curl -s localhost:8080/v1/chat/completions -H 'Content-Type: application/json' \
  -d '{"messages":[{"role":"user","content":"1+1=?"}],"max_tokens":16}'
```

「最多 token」（`max_tokens`）与上下文（`--ctx`）是两回事：前者是单轮生成上限，
默认为 **40960**；客户端不传时用它，装不下会按剩余上下文自动收窄（只有 prompt
本身超长才报 413）。页面上的输入框、`serve.sh` 的 `RT_DEFAULT_MAX_TOKENS`、
`scripts/serve.py --default-max-tokens` 都可以改。

## 六个关键设计点

第一，**NVFP4 直跑、权重无损**。`I = 2 x E2M1` 落在 [-12,12] 且是整数，
所以 FP4 → int8 无损，可直接喂 `v_dot4_i32_i8`；误差只来自激活量化。

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
token、1.7~10 秒）降到 **24~35 token、0.62 秒**，回答逐字节不变。
再进一步：服务端记住「实际提交给引擎的 token 序列」，助手那一轮**完全不重新分词**
（BPE 解码→重编码不保证可逆，照搬文本回传会在思考段中间分叉），于是网页回传也能
**完全命中**——每轮只算「新用户那句话 + 生成提示」十几个 token。
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
