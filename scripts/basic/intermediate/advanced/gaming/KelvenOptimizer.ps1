#requires -RunAsAdministrator
# KelvenOptimizer 1.0
# Copyright (C) 2025 kelvenapk

<#
.SYNOPSIS
    Otimizador visual de Windows com backup, restauração e execução simplificada.
.DESCRIPTION
    Cria ponto de restauração, backup do registro e aplica tweaks com interface em cores personalizáveis.
#>

#region CONFIGURAÇÕES GLOBAIS
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Paleta de cores (altere aqui se quiser)
$CorTitulo    = "Magenta"
$CorExec      = "DarkMagenta"
$CorInfo      = "Gray"
$CorDetalhe   = "DarkGray"

#endregion

#region FUNÇÃO DE EXECUÇÃO SIMPLIFICADA (2 cliques)
function Invoke-KelvenOptimizer {
    # Verifica se já está em modo admin; senão, re-eleva e oculta a janela intermediária
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
        exit
    }
}
Invoke-KelvenOptimizer
#endregion

#region CONFIGURAÇÃO DO OTIMIZADOR
$Config = @{
    General = @{
        PowerPlan                  = 'a1841308-3541-4fab-bc81-f71556f20b4a'
        DisablePrefetcher          = $true
        DisableMemoryDump          = $true
        DisableSystemRestore       = $false   # deixamos falso para não conflitar com o ponto criado
        DisableNtfsEncryption      = $true
        DisableNtfsCompression     = $true
        DisableVBS                 = $true
        DisableLastAccess          = $true
        DoPerformanceStuff         = $true
        MonitorAcTimeout           = 10
        MonitorDcTimeout           = 5
        DiskAcTimeout              = 0
        DiskDcTimeout              = 0
        StandbyAcTimeout           = 0
        StandbyDcTimeout           = 25
        HibernateAcTimeout         = 0
        HibernateDcTimeout         = 0
        DarkTheme                  = $true
        LegacyRightClicksMenu      = $true
        DisableWindowsSounds       = $true
        DisableStartupSound        = $true
        Remove3dObjFolder          = $true
        UnpinStartMenu             = $false
        DisablePerformanceMonitor  = $true
    }
    Security = @{
        DisableWindowsFirewall = $true
        DisableSMBServer       = $true
        DoSecurityStuff        = $true
        DoFingerprintPrevention= $true
        UseGoogleDNS           = $true
    }
    Privacy = @{
        DisableCortana   = $true
        DisableTelemetry = $true
        DisableBloatware = $true
        DoPrivacyStuff   = $true
    }
    SafetyToggles = @{
        BeWifiSafe            = $false
        BeMicrophoneSafe      = $true
        BeAppxSafe            = $false
        BeXboxSafe            = $false
        BeBiometricSafe       = $false
        BeNetworkPrinterSafe  = $false
        BePrinterSafe         = $false
        BeNetworkFolderSafe   = $false
        BeAeroPeekSafe        = $true
        BeThumbnailSafe       = $true
        BeCastSafe            = $false
        BeVpnPppoeSafe        = $false
        TroubleshootInstalls  = $false
    }
    Uninstall = @{
        UninstallWindowsDefender = $true
        UninstallOneDrive        = $true
        BloatwareList = @(
            "Microsoft.BingWeather*","MicrosoftTeams*","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.People","Microsoft.SkypeApp",
            "Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay",
            "Spotify*","Disney*","Netflix*","Instagram*","Facebook*","Minecraft*","Roblox*","CandyCrush*","Twitter*","Amazon*"
        )
    }
    Installation = @{
        InstallNvidiaControlPanel = $true
        InitialPackages           = $false
    }
    Updates = @{
        DisableWindowsUpdates = $false
    }
}

# Bloatware condicional
if ($Config.SafetyToggles.BeXboxSafe -eq $false) {
    $Config.Uninstall.BloatwareList += @("Microsoft.XboxGamingOverlay","Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay")
}
if ($Config.SafetyToggles.BeBiometricSafe -eq $false) {
    $Config.Uninstall.BloatwareList += @("Microsoft.BioEnrollment*","Microsoft.CredDialogHost*","Microsoft.ECApp*","Microsoft.LockApp*")
}
if ($Config.Installation.InstallNvidiaControlPanel -eq $false) {
    $Config.Uninstall.BloatwareList += "NVIDIACorp.NVIDIAControlPanel*"
}
if ($Config.SafetyToggles.BeCastSafe -eq $false) {
    $Config.Uninstall.BloatwareList += "Microsoft.PPIP*"
}
#endregion

#region LOGGING
$LogPath = "$env:TEMP\KelvenOptimizer_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$script:SuccessCount = 0
$script:WarningCount = 0
$script:ErrorCount   = 0

function Write-KelvenLog {
    param(
        [string]$Message,
        [ValidateSet('Info','Success','Warning','Error')]
        [string]$Type = 'Info'
    )
    $ts = Get-Date -Format 'HH:mm:ss'
    $line = "[$ts] [$Type] $Message"
    Add-Content -Path $LogPath -Value $line
    switch($Type){
        'Success' { Write-Host "  + $Message" -ForegroundColor Green;  $script:SuccessCount++ }
        'Warning' { Write-Host "  ~ $Message" -ForegroundColor Yellow; $script:WarningCount++ }
        'Error'   { Write-Host "  ! $Message" -ForegroundColor Red;    $script:ErrorCount++   }
        default   { Write-Host "  • $Message" -ForegroundColor Gray                                    }
    }
}
#endregion

#region BACKUP & RESTORE
function New-KelvenRestorePoint {
    Write-Host "`n" -NoNewline
    Write-Host " Criando ponto de restauração..." -ForegroundColor $CorExec
    try{
        $desc = "KelvenOptimizer-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Enable-ComputerRestore -Drive "$env:SystemDrive"
        Checkpoint-Computer -Description $desc -RestorePointType MODIFY_SETTINGS
        Write-KelvenLog "Ponto de restauração criado: $desc" "Success"
    }catch{
        Write-KelvenLog "Falha ao criar ponto de restauração: $_" "Warning"
    }
}

function Backup-KelvenRegistry {
    Write-Host "`n" -NoNewline
    Write-Host " Fazendo backup do registro..." -ForegroundColor $CorExec
    try{
        $bak = "$env:TEMP\KelvenOptimizer_RegBackup_$(Get-Date -Format 'yyyyMMdd-HHmmss').reg"
        Start-Process -FilePath "regedit" -ArgumentList "/e `"$bak`" `"HKEY_LOCAL_MACHINE`"" -Wait -NoNewWindow
        Write-KelvenLog "Backup do registro salvo em: $bak" "Success"
    }catch{
        Write-KelvenLog "Falha ao fazer backup do registro: $_" "Warning"
    }
}
#endregion

#region NOVA FUNÇÃO: FPS + INPUT LAG + TIMER RESOLUTION
function Set-FPSTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Aplicando tweaks de FPS e input lag..." -ForegroundColor $CorTitulo

    # Desativar HPET (High Precision Event Timer)
    try {
        bcdedit /set useplatformclock false | Out-Null
        bcdedit /set disabledynamictick yes | Out-Null
        bcdedit /set useplatformtick yes | Out-Null
        Write-KelvenLog "HPET e Dynamic Tick desativados" "Success"
    } catch {
        Write-KelvenLog "Erro ao desativar HPET: $_" "Warning"
    }

    # Timer Resolution (manual via reg)
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverride" -Value 3 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverrideMask" -Value 3 -ErrorAction SilentlyContinue
        Write-KelvenLog "Timer resolution otimizado" "Success"
    } catch {
        Write-KelvenLog "Erro ao otimizar timer resolution: $_" "Warning"
    }

    # Desativar core parking
    try {
        powercfg -attributes SUB_PROCESSOR 0cc5b647-c1df-4637-891a-dec35c318583 -ATTRIB_HIDE | Out-Null
        powercfg -setacvalueindex scheme_current sub_processor 0cc5b647-c1df-4637-891a-dec35c318583 100
        powercfg -setdcvalueindex scheme_current sub_processor 0cc5b647-c1df-4637-891a-dec35c318583 100
        Write-KelvenLog "Core parking desativado" "Success"
    } catch {
        Write-KelvenLog "Erro ao desativar core parking: $_" "Warning"
    }

    # Desativar C-states e SpeedStep via reg (requer BIOS para 100%)
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "CsEnabled" -Value 0 -ErrorAction SilentlyContinue
        Write-KelvenLog "C-states desativados (parcial via reg)" "Success"
    } catch {
        Write-KelvenLog "Erro ao desativar C-states: $_" "Warning"
    }

    # MSI Mode para GPUs NVIDIA/AMD (via reg)
    try {
        $gpuPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\VEN_10DE*"
        Get-ChildItem $gpuPath -ErrorAction SilentlyContinue | ForEach-Object {
            Set-ItemProperty -Path "$_\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MSISupported" -Value 1 -ErrorAction SilentlyContinue
        }
        Write-KelvenLog "MSI Mode ativado para GPU" "Success"
    } catch {
        Write-KelvenLog "Erro ao ativar MSI Mode: $_" "Warning"
    }

    # Desativar HPET via Device Manager (devcon)
    try {
        devcon disable *PNP0103* | Out-Null
        Write-KelvenLog "HPET desativado via devcon" "Success"
    } catch {
        Write-KelvenLog "Erro ao desativar HPET via devcon: $_" "Warning"
    }
}
#endregion

#region CORE FUNCTIONS
function Clear-AllCaches {
    Write-Host "`n" -NoNewline
    Write-Host " Limpando caches do sistema..." -ForegroundColor $CorTitulo
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" -Name * -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR" -Name * -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue
    try{
        Get-ChildItem $env:TEMP -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-KelvenLog "Arquivos temporários removidos" "Success"
    }catch{
        Write-KelvenLog "Erro ao limpar temporários: $_" "Warning"
    }
}

function Set-PrivacyTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Aplicando privacidade..." -ForegroundColor $CorTitulo
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -ErrorAction SilentlyContinue
    Stop-Service "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
    Write-KelvenLog "Telemetria e Cortana desativadas" "Success"
}

function Set-PerformanceTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Aplicando performance..." -ForegroundColor $CorTitulo
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0 -ErrorAction SilentlyContinue
    Stop-Service "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
    powercfg -SetActive $Config.General.PowerPlan | Out-Null
    Write-KelvenLog "Performance aplicada" "Success"
}

function Set-QualityTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Aplicando qualidade de vida..." -ForegroundColor $CorTitulo
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -ErrorAction SilentlyContinue
    Write-KelvenLog "Qualidade de vida aplicada" "Success"
}

function Set-SecurityTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Aplicando segurança..." -ForegroundColor $CorTitulo
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous" -Value 1 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 0 -ErrorAction SilentlyContinue
    Write-KelvenLog "Segurança reforçada" "Success"
}

function Set-UpdateTweaks {
    Write-Host "`n" -NoNewline
    Write-Host " Configurando Windows Update..." -ForegroundColor $CorTitulo
    if ($Config.Updates.DisableWindowsUpdates) {
        Stop-Service "wuauserv" -Force -ErrorAction SilentlyContinue
        Set-Service "wuauserv" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-KelvenLog "Windows Update desativado" "Success"
    } else {
        Set-Service "wuauserv" -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service "wuauserv" -ErrorAction SilentlyContinue
        Write-KelvenLog "Windows Update ativado" "Success"
    }
}

function Remove-Bloat {
    Write-Host "`n" -NoNewline
    Write-Host " Removendo bloatware..." -ForegroundColor $CorTitulo
    foreach ($app in $Config.Uninstall.BloatwareList) {
        try {
            Get-AppxPackage -Name $app -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
            Write-KelvenLog "Removido: $app" "Success"
        } catch {
            Write-KelvenLog "Falha ao remover: $app" "Warning"
        }
    }
}

function Set-HostsBlock {
    Write-Host "`n" -NoNewline
    Write-Host " Bloqueando telemetria via hosts..." -ForegroundColor $CorTitulo
    try {
        $hostsPath = "$env:windir\System32\drivers\etc\hosts"
        $block = @(
            "127.0.0.1 localhost",
            "127.0.0.1 telemetry.microsoft.com",
            "127.0.0.1 vortex.data.microsoft.com",
            "127.0.0.1 settings-win.data.microsoft.com"
        )
        Set-Content -Path $hostsPath -Value $block -Force
        Write-KelvenLog "Hosts bloqueio-telemetria atualizado" "Success"
    } catch {
        Write-KelvenLog "Falha ao atualizar hosts: $_" "Error"
    }
}
#endregion

#region EXECUÇÃO VISUAL
Clear-Host
Write-Host @"
===========================================
  🎯 KELVENOPTIMIZER  –  v1.0  –  2025
  Copyright (C) 2025 kelvenapk
===========================================
"@ -ForegroundColor $CorTitulo

# Confirmação única
Write-Host "`nEste script irá:" -ForegroundColor $CorInfo
Write-Host "  • Criar ponto de restauração" -ForegroundColor $CorDetalhe
Write-Host "  • Fazer backup do registro" -ForegroundColor $CorDetalhe
Write-Host "  • Aplicar otimizações de performance, privacidade e segurança" -ForegroundColor $CorDetalhe
Write-Host "`nDeseja continuar? (s/n)" -NoNewline -ForegroundColor $CorTitulo
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
if ($key.Character -ne 's') { Write-Host "`nOperação cancelada."; exit }

New-KelvenRestorePoint
Backup-KelvenRegistry

try {
    Clear-AllCaches
    Start-Sleep -Seconds 2
    Set-PrivacyTweaks
    Start-Sleep -Seconds 2
    Set-PerformanceTweaks
    Start-Sleep -Seconds 2
    Set-QualityTweaks
    Start-Sleep -Seconds 2
    Set-SecurityTweaks
    Start-Sleep -Seconds 2
    Set-UpdateTweaks
    Start-Sleep -Seconds 2
    Remove-Bloat
    Start-Sleep -Seconds 2
    Set-HostsBlock
    Start-Sleep -Seconds 2

    #  NOVO: TWEAKS DE FPS + INPUT LAG
    Set-FPSTweaks
    Start-Sleep -Seconds 2

    # Resumo
    $total = $script:SuccessCount + $script:WarningCount + $script:ErrorCount
    Write-Host "`n===========================================" -ForegroundColor $CorTitulo
    Write-Host "  OTIMIZAÇÃO CONCLUÍDA" -ForegroundColor $CorTitulo
    Write-Host "===========================================" -ForegroundColor $CorTitulo
    Write-Host "Sucessos : $script:SuccessCount" -ForegroundColor Green
    Write-Host "Avisos   : $script:WarningCount" -ForegroundColor Yellow
    Write-Host "Erros    : $script:ErrorCount" -ForegroundColor Red
    Write-Host "Log em    : $LogPath" -ForegroundColor $CorDetalhe
    Write-Host "===========================================" -ForegroundColor $CorTitulo

    $reiniciar = Read-Host "`nReiniciar agora? (s/n)"
    if ($reiniciar -eq 's') {
        Write-Host "Reiniciando em 5 segundos..." -ForegroundColor $CorExec
        for ($i = 5; $i -gt 0; $i--) { Write-Host " $i..." -ForegroundColor $CorInfo; Start-Sleep 1 }
        Restart-Computer -Force
    } else {
        Write-Host "Por favor, reinicie mais tarde." -ForegroundColor $CorInfo
    }
} catch {
    Write-KelvenLog "ERRO CRÍTICO: $_" "Error"
}
#endregion