@echo off & title 📡 Disable Telemetry – KelvenOptimizer
sc stop DiagTrack & sc config DiagTrack start= disabled
sc stop dmwappushservice & sc config dmwappushservice start= disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
echo ✅ Telemetria desativada!
pause