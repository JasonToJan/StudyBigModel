@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ==========================================
echo  git add .  to  commit  to  push origin main
echo ==========================================
echo.
echo [1/3] git add .
git add .
echo.
echo [2/3] git commit -m "更新"
git commit -m "更新"
if errorlevel 1 echo     skip: nothing to commit
echo.
echo [3/3] git push origin main
git push origin main
if errorlevel 1 echo     [FAIL] push failed, check messages above
echo.
echo ==========================================
echo  done
echo ==========================================
pause
