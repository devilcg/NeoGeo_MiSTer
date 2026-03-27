@echo off
setlocal

set "PROJECT_NAME=%~1"
if "%PROJECT_NAME%"=="" set "PROJECT_NAME=NeoGeo"

if /I not "%PROJECT_NAME%"=="NeoGeo" if /I not "%PROJECT_NAME%"=="NeoGeo_DualSDR" (
  echo Usage: %~nx0 [NeoGeo^|NeoGeo_DualSDR]
  exit /b 1
)

where quartus_sh >nul 2>nul
if errorlevel 1 (
  echo Error: quartus_sh not found in PATH.
  echo Run this from a Quartus shell, or add Quartus bin folder to PATH first.
  exit /b 1
)

echo == Clean build: %PROJECT_NAME% ==
echo Project root: %~dp0

cd /d "%~dp0"

if exist db rmdir /s /q db
if exist incremental_db rmdir /s /q incremental_db
if exist output_files rmdir /s /q output_files
if exist build_id.v del /f /q build_id.v

del /s /q *.ddb >nul 2>nul
del /s /q *.qws >nul 2>nul
del /s /q *.bak >nul 2>nul

echo == Running Quartus compile ==
quartus_sh --flow compile %PROJECT_NAME% -c %PROJECT_NAME%
if errorlevel 1 (
  echo Build failed.
  exit /b 1
)

if exist "output_files\%PROJECT_NAME%.rbf" (
  echo == Build finished ==
  dir "output_files\%PROJECT_NAME%.rbf"
) else (
  echo Warning: expected output not found: output_files\%PROJECT_NAME%.rbf
  exit /b 1
)

endlocal
