@echo off & title 🎯 Valorant Mode – KelvenOptimizer
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
bcdedit /deletevalue useplatformclock >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
echo ✅ Valorant Mode aplicado – reinicie.
pause