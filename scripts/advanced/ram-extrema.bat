@echo off & title 🧠 RAM Extrema – KelvenOptimizer
sc stop SysMain & sc config SysMain start= disabled
sc stop Superfetch & sc config Superfetch start= disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
echo ✅ RAM Extrema aplicada!
pause