@echo off & title 🧹 Limpeza de Sistema – KelvenOptimizer
echo Limpando temporarios...
del /f /s /q %temp%\* >nul 2>&1
rd /s /q %temp% >nul 2>&1
del /f /s /q C:\Windows\Temp\* >nul 2>&1
del /f /s /q C:\Windows\Prefetch\* >nul 2>&1
del /f /s /q C:\Windows\SoftwareDistribution\Download\* >nul 2>&1
del /f /s /q C:\Windows\WinSxS\Backup\* >nul 2>&1
cleanmgr /sagerun:1 >nul 2>&1
echo ✅ Concluido!
pause