# DCU 驱动安装（K100 标准版 / rock-5.7.1，**不限内核版本**）

本项目把「把这台机器跑起来」需要的东西放在本目录里：驱动安装包、用户态运行时快照、
系统配置，以及现场记录。装完驱动，回项目根目录跑 `bash build.sh` 即可，命令里不需要任何
DTK 或 Docker。

## 0. 本目录内容

| 路径 | 说明 |
|---|---|
| `installer/rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run` | **推荐**：驱动安装包（67 MB，编译修正 + 不锁内核）；第三方二进制，不入 Git 仓库 |
| `installer/rock-5.7.1-6.2.35-V1.6.7-内核68修正.aio.run` | 原修正版（仍会锁内核，保留做对照）；第三方二进制，不入 Git 仓库 |
| `installer/内核68修正-说明.md` | 原厂包在内核 6.8 上编译失败的根因、diff、验证结果 |
| `不限内核-说明.md` | 去掉「写死目标内核」检查的 diff 与理由 |
| `installer/MD5SUMS.txt` | 安装包与运行时快照的校验和 |
| `hyhal/hyhal-prebuilt-<内核>.tar.gz` | `/usr/local/hyhal` 用户态运行时快照（`/opt/hyhal` 指向它）；第三方二进制，不入 Git 仓库 |
| `system/` | udev 规则、modprobe 配置、`hymgr.service` |
| `manifest.txt` | 打包时的现场快照（内核、包版本、`lsmod`、`hy-smi`、GRUB 默认项） |

## 1. 装驱动（必做）

只有 GitHub 仓库、没有部署包时，先从 Releases 下这一份（与包内文件同源）：

```bash
curl -L -O https://github.com/Hong-agent/K100LC-FASTASM-NVFP4/releases/download/driver-rock-5.7.1-6.2.35-V1.6.7/rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run
md5sum rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run   # 应为 fe80b298a3d3358a869de14105ada134
```

```bash
md5sum installer/rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run   # 应为 fe80b298a3d3358a869de14105ada134
sudo bash installer/rock-5.7.1-6.2.35-V1.6.7-any-kernel.aio.run
sudo reboot
/opt/hyhal/bin/hy-smi          # 看得到 DCU 0 就说明驱动 OK
```

实测踩过的坑：

* **必须用包内的修正包**（`不限内核` 或 `内核68修正` 都含这处修正）。原厂包在
  Ubuntu 22.04 / 内核 6.8 上会因为
  `enum drm_debug_category` 探测误判（`-Werror=missing-prototypes`）而编译失败；
  修正内容与验证见 `installer/内核68修正-说明.md`。
* 驱动是在**安装时按当前正在运行的内核**现编的。`不限内核` 版**不再写死目标内核**，
  所以装在哪个内核上都行，也不需要锁 GRUB；**升级内核后重跑一次安装包**即可。
* 现编的前提是当前内核的 `linux-headers-$(uname -r)` 与 `gcc`/`make`/`cmake`/
  `autoconf`/`m4` 在位（Ubuntu 桌面版一般都有）。
* 本机现场记录里的 `6.8.0-40-generic` 只是**打包那台机器**的内核，不是要求；
  目标机是别的内核（`uname -r` 不同）也能装。

## 2. 用户态运行时

安装器会自己铺 `/usr/local/hyhal`（`/opt/hyhal` 是它的软链）。要还原本机这一份：

```bash
sudo tar -C /usr/local -xzf hyhal/hyhal-prebuilt-$(uname -r).tar.gz
ln -sfn /usr/local/hyhal /opt/hyhal
```

> 快照里的 `dkms/*.ko` 是**为快照名里那个内核**编的，只在 `uname -r` 一模一样时能直接
> 用（本机是 `6.8.0-40-generic`）。内核不同就不要用快照，直接跑上面第 1 步的
> `.aio.run`（它会为当前内核现编），或者用 `bash snapshot_hyhal.sh` 在目标机上重新生成一份。

里面有 `bin/hy-smi`、`bin/hymgr`、`lib/*.so`（HIP/HSA）、`hsa/`、`vbios/` 固件，
以及 `dkms/*.ko`。本项目的 `build/rt` 只链接这里的 `libhsa-runtime64.so.1`，
**不链接** DTK 的 `libgalaxyhip` / `libamd_comgr`。

重新生成这份快照（在已装好驱动的机器上）：

```bash
bash snapshot_hyhal.sh          # → hyhal/hyhal-prebuilt-$(uname -r).tar.gz
```

## 3. 系统侧配置

`system/` 里是这几份文件（装驱动时会自动写好，手工核对/恢复用）：

```bash
sudo cp system/16-dcu.rules /etc/udev/rules.d/
sudo cp system/hydcu.conf system/blacklist-hydcu.conf /etc/modprobe.d/
sudo cp system/hymgr.service /lib/systemd/system/
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo systemctl enable --now hymgr.service
```

## 4. 验证

```bash
ls -l /dev/kfd /dev/dri/renderD*         # 设备节点在
lsmod | grep -E "^(hydcu|hyttm|hykcl)"   # 模块已加载
/opt/hyhal/bin/hy-smi                    # 看得到卡

cd ..                                    # 回项目根目录
bash build.sh --check                    # 汇编 + 打 HSACO + 编译 + 自检
bash run.sh --prompt 你好 --n 16          # 跑起来
```

`manifest.txt` 是打包时的现场快照（内核、包版本、lsmod、hy-smi、GRUB 默认项），
目标机器对不上时先看它。
