@echo off & title 💻 CPU Extrema – KelvenOptimizer
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Processor" /v Capabilities /t REG_DWORD /d 0 /f
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
echo ✅ CPU Extrema aplicada – reinicie.
pause