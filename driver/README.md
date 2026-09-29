# DCU 驱动（K100 标准版 / rock-5.7.1，**不限内核版本**）

这个目录放**驱动相关的全部东西**，目标机器可以只靠它 + 本项目源码把环境搭起来：
安装包（67 MB）、用户态运行时快照（89 MB）、系统配置，以及现场记录。

> GitHub 源码仓库里**没有**两个二进制（`.aio.run` 与 hyhal 快照）——它们是海光的
> 第三方内容，只在 `scripts/make_src_package.sh` / `make_offline_package.sh` 打出的
> 部署包里携带；仓库里保留的是说明、修正/不限内核的 diff 与系统配置。

本项目**不需要 DTK 工具链，也不需要 Docker**：装好驱动后，编译只要主机 `g++`，
运行只要 `/opt/hyhal` 的 HSA 运行时。

## 安装

完整步骤（含实测踩过的坑）见 [INSTALL.md](INSTALL.md)，不限内核版本的做法见
[不限内核-说明.md](不限内核-说明.md)。最短路径：

```bash
sudo bash installer/rock-5.7.1-6.2.35-V1.6.7-不限内核.aio.run
sudo reboot
/opt/hyhal/bin/hy-smi          # 看得到 DCU 0

cd ..                          # 回项目根目录
bash build.sh
bash serve.sh                  # http://<本机IP>:8080/
```

## 本目录内容

| 路径 | 说明 |
|---|---|
| `INSTALL.md` | 完整安装/验证步骤 + 实测踩过的坑 |
| `不限内核-说明.md` | 去掉「写死目标内核」那处检查的 diff 与理由 |
| `installer/rock-5.7.1-…-不限内核.aio.run` | **推荐**：驱动安装包（6.8 编译修正 + 不锁内核）；第三方二进制，不入 Git 仓库 |
| `installer/rock-5.7.1-…-内核68修正.aio.run` | 原修正版（仍会锁内核，保留做对照）；第三方二进制，不入 Git 仓库 |
| `installer/内核68修正-说明.md` | 原厂包在内核 6.8 上编译失败的根因、diff、验证结果 |
| `installer/MD5SUMS.txt` | 两个安装包与运行时快照的校验和 |
| `hyhal/hyhal-prebuilt-<内核>.tar.gz` | `/usr/local/hyhal` 用户态运行时快照（`/opt/hyhal` 指向它）；第三方二进制，不入 Git 仓库 |
| `snapshot_hyhal.sh` | 在已装好驱动的机器上重新生成上面那份快照 |
| `manifest.txt` | 打包时的现场快照：内核、包版本、`lsmod`、`hy-smi`、GRUB 默认项、已装内核 |
| `system/16-dcu.rules` | udev 规则：`/dev/kfd`、`/dev/dri/renderD*` 的权限与属组 |
| `system/hydcu.conf`、`system/blacklist-hydcu.conf` | modprobe 参数与黑名单 |
| `system/hymgr.service` | 监控守护进程（`/opt/hyhal/bin/hymgr`） |

## 内核版本：现在不限制了

驱动内核模块本来就是**在目标机上现编**的（`.aio.run` 解包 → cmake → 用
`/lib/modules/$(uname -r)/build` 编译 → 立刻装）。原包里多加了一条
「目标内核名必须等于打包时的内核名」的检查，才引出「要锁 GRUB、升级内核要重装」的麻烦。

`不限内核.aio.run` 去掉了这条检查：**装在任何内核上都行**，它按当前内核现编；
升级内核后重跑一次安装包即可，不用再动 GRUB。硬前提只有一条——
当前内核的 `linux-headers-$(uname -r)` 与 `gcc/make/cmake/autoconf/m4` 在位
（Ubuntu 桌面版一般都有，安装包缺什么会明确提示）。

本机现场记录（`manifest.txt`）里的 `6.8.0-40-generic` 只是**当时那台机器**的内核，
不是要求。

## 许可

驱动安装包与用户态运行时是海光/DCU 的第三方内容，遵循其原始许可；本目录只做搬运与
版本记录，请在你有权使用的范围内复制与分发（详见仓库 `NOTICE`）。
