# Remove programas da inicialização – KelvenOptimizer
Get-CimInstance Win32_StartupCommand |
Where-Object { $_.Location -like "*Run*" } |
ForEach-Object {
    if ((Read-Host "Remover $($_.Name) ? (s/n)") -eq "s") {
        Remove-ItemProperty -Path "Registry::$($_.Location)" -Name $_.Name -Force
    }
}
Write-Host "✅ Inicialização limpa." -ForegroundColor Green