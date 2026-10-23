@echo off
rem 一键提交并推送 GitHub（Windows 双击版）
rem 用法：双击本文件，或 push.bat "自定义说明"
cd /d "%~dp0"

git config user.email >nul 2>&1
if errorlevel 1 (
  echo 还没配置 git 身份，先执行：
  echo   git config --global user.name "你的名字"
  echo   git config --global user.email "你的邮箱"
  pause
  exit /b 1
)

git remote | findstr . >nul
if errorlevel 1 (
  echo 还没关联 GitHub 仓库，先执行：
  echo   git remote add origin https://github.com/你的用户名/仓库名.git
  pause
  exit /b 1
)

git add -A

git diff --cached --quiet
if not errorlevel 1 (
  echo 没有改动，无需提交
  timeout /t 3 >nul
  exit /b 0
)

if "%~1"=="" (
  set MSG=update: %date% %time:~0,5%
) else (
  set MSG=%~1
)

git commit -m "%MSG%"
for /f %%b in ('git branch --show-current') do set BRANCH=%%b
git push -u origin %BRANCH%
if not errorlevel 1 echo 已推送到 origin/%BRANCH%
pause
