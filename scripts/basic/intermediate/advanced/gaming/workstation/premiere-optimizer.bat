@echo off & title 🎬 Premiere Pro Optimizer – KelvenOptimizer
reg add "HKCU\Software\Adobe\Premiere Pro\24.0" /v MaxMemoryPercent /t REG_DWORD /d 85 /f
reg add "HKCU\Software\Adobe\Premiere Pro\24.0" /v DiskCache /t REG_SZ /d "D:\Cache\Premiere" /f
echo ✅ Premiere Pro otimizado!
pause