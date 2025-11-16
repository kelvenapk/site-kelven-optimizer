@echo off & title 💎 HPET Disable – KelvenOptimizer
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformtick no >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
echo ✅ HPET desativado – reinicie para aplicar.
pause