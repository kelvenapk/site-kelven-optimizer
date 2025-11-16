@echo off & title 🎯 Latency Monitor Fix – KelvenOptimizer
:: Ajustes para DPC/ISR baixos
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo ✅ Latencia ajustada – execute LatencyMon para verificar.
pause