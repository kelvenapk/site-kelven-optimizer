@echo off & title 🔴 AMD Ryzen Tweaks – KelvenOptimizer
powercfg -duplicatescheme 93a6d8e6-369c-4f55-a125-53b2d065f7c8 >nul
powercfg -setactive 93a6d8e6-369c-4f55-a125-53b2d065f7c8
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
echo ✅ Ryzen tweaks aplicados!
pause