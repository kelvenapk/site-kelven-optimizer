@echo off & title 🎨 After Effects Mode – KelvenOptimizer
:: Cache e memória maximizados
reg add "HKCU\Software\Adobe\After Effects\24.0" /v MaxMemoryPercent /t REG_DWORD /d 85 /f
reg add "HKCU\Software\Adobe\After Effects\24.0" /v DiskCache /t REG_SZ /d "D:\Cache\AE" /f
echo ✅ After Effects cache otimizado!
pause