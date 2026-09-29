#!/bin/bash
# 把本仓库发布到 GitHub：创建仓库（已存在则复用）+ 推送当前分支 + 写好简介与话题。
#
#   GH_TOKEN=ghp_xxx bash scripts/publish_github.sh [仓库名] [public|private]
#
# 令牌用 GitHub classic PAT，勾上 `repo` 权限即可。脚本**不把令牌写进 .git/config
# 或任何文件**：只通过环境变量交给 git 的一次性凭据。用完请到
# https://github.com/settings/tokens 撤销。
#
# 如果 `git push` 连不上 github.com:443（本机常见），改用 Git Data API 推：
#   GH_TOKEN=ghp_xxx python3 scripts/push_via_api.py --branch main
# （走 api.github.com，只传源码 blob；本仓库约 210 个小文件，一两分钟。）
#
# 注意：`.gitignore` 已经排除权重（22GB）、第三方驱动二进制、自带 Python 运行库、
# 编译产物、打包产物和会话工作区；本脚本只推源码（含 kernels/asm 的 .s、
# prebuilt/ 小引擎、skeletons/ 与 tests/expected 的测试样本）。
set -euo pipefail

REPO="${1:-K100LC-FASTASM-NVFP4}"
VIS="${2:-public}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESC="海光 K100 LC（gfx926）上的自研推理栈：自研表驱动汇编器 + 无 DTK 运行时 + NVFP4 权重直跑，跑完整 27B 模型，自带网页控制台与 OpenAI 兼容接口"

if [ -z "${GH_TOKEN:-}" ]; then
  echo "需要 GitHub 令牌：GH_TOKEN=ghp_xxx bash scripts/publish_github.sh" >&2
  echo "到 https://github.com/settings/tokens/new 建一个 classic token（勾 repo）。" >&2
  exit 1
fi

api() { curl -sS -H "Authorization: token $GH_TOKEN" -H 'Accept: application/vnd.github+json' "$@"; }

LOGIN="$(api https://api.github.com/user | python3 -c 'import json,sys; print(json.load(sys.stdin)["login"])')"
echo "账号：$LOGIN"

HTTP="$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: token $GH_TOKEN" \
        "https://api.github.com/repos/$LOGIN/$REPO")"
if [ "$HTTP" = "404" ]; then
  private=false; [ "$VIS" = "private" ] && private=true
  api -X POST https://api.github.com/user/repos \
    -d "{\"name\":\"$REPO\",\"description\":\"$DESC\",\"private\":$private,\"has_issues\":true,\"has_wiki\":false}" \
    >/dev/null
  echo "已创建仓库 $LOGIN/$REPO（$VIS）"
else
  echo "仓库已存在（HTTP $HTTP），直接推送"
fi

api -X PATCH "https://api.github.com/repos/$LOGIN/$REPO" \
  -d '{"topics":["hip","rocm","llm-inference","nvfp4","fp4","quantization","assembler","dcu","gfx926","qwen","openai-compatible"]}' \
  >/dev/null 2>&1 || true

cd "$ROOT"
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$LOGIN/$REPO.git"
# 令牌只在这个 git 进程的临时凭据助手里用一次，不落盘
GIT_TERMINAL_PROMPT=0 git -c credential.helper= \
  -c credential.helper='!f() { echo username=x-access-token; echo password="$GH_TOKEN"; }; f' \
  push -u origin HEAD:main

echo
echo "仓库地址：https://github.com/$LOGIN/$REPO"
