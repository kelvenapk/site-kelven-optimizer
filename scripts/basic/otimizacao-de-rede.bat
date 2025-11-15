@echo off & title 🌐 Otimizacao de Rede – KelvenOptimizer
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh int ip reset
netsh winsock reset
netsh advfirewall reset
netsh interface tcp set global autotuninglevel=disabled
netsh interface tcp set global chimney=enabled
netsh interface tcp set global rss=enabled
netsh interface tcp set global netdma=enabled
echo ✅ Rede otimizada – reinicie o PC.
pause