@echo off & title 🔧 Timer Resolution – KelvenOptimizer
:: Download e instalacao silenciosa do SetTimerResolutionService
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/kelvenapk/kelvenoptimizer-site/raw/main/assets/SetTimerResolutionService.exe' -OutFile '%TEMP%\str.exe'"
%TEMP%\str.exe /install /silent
sc start SetTimerResolutionService
echo ✅ Timer ajustado para 0.5 ms – servico instalado.
pause