# Limpa entradas órfãs do registro – KelvenOptimizer
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$lista = Get-ChildItem $regPaths -ErrorAction SilentlyContinue | Where-Object {
    $_.Property -contains "DisplayName" -and
    -not (Test-Path ($_.GetValue("InstallLocation")))
}
$lista | ForEach-Object {
    Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "✅ Entradas órfãs removidas." -ForegroundColor Green