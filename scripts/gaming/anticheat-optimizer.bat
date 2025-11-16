@echo off & title 🛡️ Anti-Cheat Optimizer – KelvenOptimizer
sc config BFE start= auto
sc config mpssvc start= auto
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f >nul 2>&1
echo ✅ Anti-Cheat Optimizer aplicado!
pause