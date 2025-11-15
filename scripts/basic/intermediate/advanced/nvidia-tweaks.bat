@echo off & title 🟢 NVIDIA Tweaks – KelvenOptimizer
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v DisableWriteCombining /t REG_DWORD /d 1 /f
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v PowerMizerEnable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v PowerMizerLevel /t REG_DWORD /d 1 /f
echo ✅ NVIDIA tweaks aplicados!
pause