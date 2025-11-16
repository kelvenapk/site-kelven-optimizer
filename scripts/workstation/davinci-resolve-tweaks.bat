@echo off & title 🎞️ DaVinci Resolve Tweaks – KelvenOptimizer
:: Prioriza GPU e desativa limitações
reg add "HKCU\Software\Blackmagic Design\DaVinci Resolve\Preferences" /v GpuMemorySizeMB /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Blackmagic Design\DaVinci Resolve\Preferences" /v UseGPUProcessing /t REG_DWORD /d 1 /f
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo ✅ DaVinci Resolve otimizado!
pause