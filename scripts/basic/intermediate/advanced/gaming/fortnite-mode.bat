@echo off & title 🟪 Fortnite Mode – KelvenOptimizer
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
bcdedit /deletevalue useplatformclock >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
echo ✅ Fortnite Mode aplicado – reinicie.
pause