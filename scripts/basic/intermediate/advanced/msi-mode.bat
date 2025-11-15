@echo off & title ⚡ MSI Mode – KelvenOptimizer
:: Habilita MSI apenas para GPUs reais
set "reg=HKLM\SYSTEM\CurrentControlSet\Enum\PCI\VEN_10DE*"
for /f "tokens=9 delims=\" %%i in ('reg query "%reg%" /s /f "DeviceDesc" 2^>nul ^| findstr /i "VEN_"') do (
  reg add "HKLM\SYSTEM\CurrentControlSet\Enum\PCI\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v MSISupported /t REG_DWORD /d 1 /f >nul 2>&1
)
echo ✅ MSI Mode ativado para GPUs NVIDIA/AMD.
pause