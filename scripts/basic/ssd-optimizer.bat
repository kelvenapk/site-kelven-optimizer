@echo off & title 💾 SSD Optimizer – KelvenOptimizer
sc stop SysMain >nul 2>&1 & sc config SysMain start= disabled
sc stop WSearch >nul 2>&1 & sc config WSearch start= disabled
sc stop Defragsvc >nul 2>&1 & sc config Defragsvc start= disabled
fsutil behavior set DisableLastAccess 1
fsutil behavior set DisableDeleteNotify 0
echo ✅ SSD otimizado!
pause