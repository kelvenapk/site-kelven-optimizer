@echo off & title 🧠 ISLC Auto-Run – KelvenOptimizer
set url=https://www.wagnardsoft.com/ISLC.exe
set dst=%PROGRAMFILES%\ISLC
powershell -Command "Invoke-WebRequest -Uri %url% -OutFile '%TEMP%\ISLC.exe'"
%TEMP%\ISLC.exe /S
copy "%dst%\ISLC.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"
echo ✅ ISLC instalado e autorun ativado!
pause