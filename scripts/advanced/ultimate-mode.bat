@echo off & title ⚡ ULTIMATE MODE – KelvenOptimizer
echo Aplicando TODAS as otimizacoes...
call "%~dp0cpu-extrema.bat" >nul 2>&1
call "%~dp0ram-extrema.bat" >nul 2>&1
call "%~dp0timer-resolution.bat" >nul 2>&1
call "%~dp0msi-mode.bat" >nul 2>&1
call "%~dp0hpet-disable.bat" >nul 2>&1
call "%~dp0disable-telemetry-full.bat" >nul 2>&1
echo ✅ ULTIMATE MODE aplicado – REINICIE AGORA!
pause