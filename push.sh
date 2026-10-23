#!/bin/bash
# 一键提交并推送 GitHub
# 用法：
#   ./push.sh              # 自动生成提交信息
#   ./push.sh "写点改动说明"  # 自定义提交信息
set -e
cd "$(dirname "$0")"

# 未配置身份则提示
if ! git config user.email >/dev/null 2>&1 || [ -z "$(git config user.email)" ]; then
  echo "✗ 还没配置 git 身份，先执行："
  echo '  git config --global user.name "你的名字"'
  echo '  git config --global user.email "你的邮箱"'
  exit 1
fi

# 没有远程仓库则提示
if ! git remote | grep -q .; then
  echo "✗ 还没关联 GitHub 仓库，先执行："
  echo '  git remote add origin https://github.com/你的用户名/仓库名.git'
  exit 1
fi

git add -A

if [ -z "$(git status --porcelain)" ]; then
  echo "✓ 没有改动，无需提交"
  exit 0
fi

MSG="${1:-update: $(date '+%Y-%m-%d %H:%M')}"
git commit -m "$MSG"

BRANCH=$(git branch --show-current)
git push -u origin "$BRANCH" && echo "✓ 已推送到 origin/$BRANCH"
