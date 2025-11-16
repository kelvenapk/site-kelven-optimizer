@echo off & title 🔄 Blender Optimizer – KelvenOptimizer
:: Cycles e Eevee acelerados
reg add "HKCU\Software\Blender Foundation\Blender\4.0\config" /v compute_device_type /t REG_SZ /d CUDA /f
reg add "HKCU\Software\Blender Foundation\Blender\4.0\config" /v cycles_device /t REG_SZ /d CUDA /f
echo ✅ Blender otimizado para GPU!
pause