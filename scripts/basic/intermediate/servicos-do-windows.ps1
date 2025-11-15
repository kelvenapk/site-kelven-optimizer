# Serviços desnecessários – KelvenOptimizer
$lista = @(
    "Fax",
    "WerSvc",          # Windows Error Reporting
    "DiagTrack",       # Telemetria
    "dmwappushservice",
    "MapsBroker",      # Download de Mapas
    "lfsvc",           # Geolocalização
    "SharedAccess",    # Internet Connection Sharing
    "TabletInputService"
)
ForEach ($svc in $lista) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}
Write-Host "✅ Serviços desnecessários desativados." -ForegroundColor Green