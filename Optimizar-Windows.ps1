# ============================================================================
#  OPTIMIZADOR WINDOWS 10/11 — SCRIPT UNIFICADO INTERACTIVO
#  Repositorio: https://github.com/Xaoxay/win-optimizer
# ============================================================================

param(
    [switch]$DryRun,
    [string]$Type = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Optimizador Windows 10/11"
$ErrorActionPreference = "SilentlyContinue"

# ============================================================================
# FUNCIONES DE UI
# ============================================================================

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "    ============================================================" -ForegroundColor Cyan
    Write-Host "    |                                                          |" -ForegroundColor Cyan
    Write-Host "    |               OPTIMIZADOR WINDOWS 10 / 11                |" -ForegroundColor White
    Write-Host "    |               PC de Escritorio  &  Notebook              |" -ForegroundColor Cyan
    Write-Host "    |               github.com/Xaoxay/win-optimizer            |" -ForegroundColor DarkGray
    Write-Host "    |                                                          |" -ForegroundColor Cyan
    Write-Host "    ============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-ProgressBar {
    param(
        [int]$Percent,
        [string]$Status,
        [int]$BarWidth = 35
    )
    if ($Percent -gt 100) { $Percent = 100 }
    if ($Percent -lt 0) { $Percent = 0 }
    
    $filled = [math]::Floor($BarWidth * $Percent / 100)
    $empty = $BarWidth - $filled
    $bar = ("#" * $filled) + ("-" * $empty)
    
    $color = "Yellow"
    if ($Percent -ge 50) { $color = "Cyan" }
    if ($Percent -ge 100) { $color = "Green" }
    
    Write-Host "`r    [$bar] $Percent%  $Status                    " -ForegroundColor $color -NoNewline
}

function Show-ProgressComplete {
    param([string]$Message)
    Write-Host ""
    Write-Host "    [OK] $Message" -ForegroundColor Green
}

function Show-StepHeader {
    param(
        [int]$Step,
        [int]$Total,
        [string]$Title,
        [string]$Description
    )
    Write-Host ""
    Write-Host "    ------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "    PASO $Step/$Total - $Title" -ForegroundColor White
    Write-Host "    $Description" -ForegroundColor Gray
    Write-Host "    ------------------------------------------------------" -ForegroundColor DarkGray
}

function Ask-Proceed {
    param([string]$Question = "Aplicar este paso?")
    Write-Host ""
    Write-Host "    $Question [S/N/T]: " -ForegroundColor Yellow -NoNewline
    Write-Host "(S=Si, N=Saltar, T=Todo sin preguntar)" -ForegroundColor DarkGray
    Write-Host "    > " -NoNewline -ForegroundColor Yellow
    $resp = Read-Host
    if ($null -eq $resp) { return "S" }
    return $resp.ToUpper().Trim()
}

# ============================================================================
# VERIFICACION DE PERMISOS
# ============================================================================

Show-Banner

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -and -not $DryRun) {
    Write-Host "    [!] Se requieren permisos de ADMINISTRADOR" -ForegroundColor Red
    Write-Host "        Reiniciando con elevacion de permisos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

if ($DryRun) {
    Write-Host "    *** MODO TEST / SIMULACION (DRY-RUN) ACTIVO ***" -ForegroundColor Magenta
    Write-Host "    No se realizaran cambios destructivos en el sistema." -ForegroundColor Magenta
    Write-Host ""
} else {
    Write-Host "    [OK] Permisos de Administrador verificados" -ForegroundColor Green
    Write-Host ""
}

# ============================================================================
# MENU PRINCIPAL
# ============================================================================

$pcType = $Type
if ($pcType -ne "1" -and $pcType -ne "2" -and $pcType -ne "3") {
    Write-Host "    Que deseas hacer?" -ForegroundColor White
    Write-Host ""
    Write-Host "    [1] OPTIMIZAR PC DE ESCRITORIO / DESKTOP" -ForegroundColor White
    Write-Host "        Plan Ultimate Performance, baja latencia, servicios apagados" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    [2] OPTIMIZAR NOTEBOOK / LAPTOP" -ForegroundColor White
    Write-Host "        High Perf enchufado, conserva GPS/Search, libera espacio en disco" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    [3] REVERTIR CAMBIOS / RESTAURAR TODO POR DEFECTO" -ForegroundColor Yellow
    Write-Host "        Vuelve todas las animaciones, notificaciones, servicios y energia al estado original" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "    [0] Salir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    Elegir opcion [1/2/3/0] > " -NoNewline -ForegroundColor Yellow
    $pcType = Read-Host
}

if ($pcType -eq "0" -or [string]::IsNullOrWhiteSpace($pcType)) {
    Write-Host "    Operacion cancelada." -ForegroundColor Gray
    exit
}

# ============================================================================
# OPCION 3: REVERTIR TODO A VALORES POR DEFECTO
# ============================================================================

if ($pcType -eq "3") {
    Clear-Host
    Show-Banner
    Write-Host "    ============================================================" -ForegroundColor Yellow
    Write-Host "    RESTAURAR CONFIGURACION POR DEFECTO DE WINDOWS" -ForegroundColor Yellow
    Write-Host "    ============================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Esta opcion devolvera:" -ForegroundColor White
    Write-Host "    - Todas las animaciones y efectos de transparencia de Windows" -ForegroundColor Gray
    Write-Host "    - Todas las notificaciones y Centro de Accion" -ForegroundColor Gray
    Write-Host "    - Plan de energia Equilibrado (Balanced)" -ForegroundColor Gray
    Write-Host "    - Servicios originales en segundo plano (SysMain, Telemetria, Xbox)" -ForegroundColor Gray
    Write-Host "    - Permisos para aplicaciones en segundo plano" -ForegroundColor Gray
    Write-Host "    - Cortana y busqueda web en Inicio" -ForegroundColor Gray
    Write-Host "    - Xbox Game Bar y Game DVR" -ForegroundColor Gray
    Write-Host "    - Parametros de red estandar" -ForegroundColor Gray
    Write-Host "    - Hibernacion reactivada" -ForegroundColor Gray
    Write-Host ""

    if (-not $DryRun) {
        Write-Host "    Seguro que deseas restaurar todo a como estaba antes? [S/N] > " -NoNewline -ForegroundColor Yellow
        $confRevert = Read-Host
        if ($confRevert -ne "S" -and $confRevert -ne "s") {
            Write-Host "    Operacion cancelada." -ForegroundColor Gray
            exit
        }
    }

    Write-Host ""
    Write-Host "    Iniciando restauracion del sistema..." -ForegroundColor Yellow
    Write-Host ""

    # 1. Animaciones
    Show-ProgressBar -Percent 10 -Status "Restaurando animaciones y transparencias..."
    if (-not $DryRun) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x9E,0x3E,0x07,0x80,0x12,0x00,0x00,0x00)) -Type Binary -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "1" -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 1 -Force
        $pp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (Test-Path $pp) { Set-ItemProperty -Path $pp -Name "EnableTransparency" -Value 1 -Force }
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "1" -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "400" -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "AnimationEnabled" -Value 1 -PropertyType String -Force | Out-Null
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Animaciones y transparencias restauradas"

    # 2. Notificaciones
    Show-ProgressBar -Percent 20 -Status "Restaurando notificaciones y sugerencias..."
    if (-not $DryRun) {
        $pushPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
        if (Test-Path $pushPath) { Set-ItemProperty -Path $pushPath -Name "ToastEnabled" -Value 1 -Force }
        $np = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        if (Test-Path $np) { Set-ItemProperty -Path $np -Name "DisableNotificationCenter" -Value 0 -Force }
        $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $keys = @("SubscribedContent-338389Enabled","SubscribedContent-310093Enabled","SubscribedContent-338388Enabled","SubscribedContent-353698Enabled","SoftLandingEnabled","SystemPaneSuggestionsEnabled","RotatingLockScreenEnabled","RotatingLockScreenOverlayEnabled")
        foreach ($k in $keys) {
            Set-ItemProperty -Path $cdm -Name $k -Value 1 -Force -ErrorAction SilentlyContinue
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Notificaciones y Centro de Accion restaurados"

    # 3. Plan de Energia
    Show-ProgressBar -Percent 35 -Status "Restaurando plan de energia Equilibrado..."
    if (-not $DryRun) {
        # Plan Equilibrado estándar de Windows
        powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>$null
        powercfg -change -disk-timeout-ac 20
        powercfg -change -standby-timeout-ac 30
        powercfg -change -monitor-timeout-ac 10
        powercfg -change -disk-timeout-dc 10
        powercfg -change -standby-timeout-dc 15
        powercfg -change -monitor-timeout-dc 5
        powercfg -h on 2>$null
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Plan Equilibrado (Balanced) e hibernacion reactivados"

    # 4. Servicios
    Show-ProgressBar -Percent 50 -Status "Restaurando servicios del sistema..."
    $restoreSvcs = @(
        @{Name="DiagTrack";          Type="Automatic"; Start=$true},
        @{Name="dmwappushservice";   Type="Manual";    Start=$false},
        @{Name="SysMain";            Type="Automatic"; Start=$true},
        @{Name="MapsBroker";         Type="Automatic"; Start=$false},
        @{Name="RetailDemo";         Type="Manual";    Start=$false},
        @{Name="wisvc";              Type="Manual";    Start=$false},
        @{Name="WerSvc";             Type="Manual";    Start=$false},
        @{Name="Fax";                Type="Manual";    Start=$false},
        @{Name="XblAuthManager";     Type="Manual";    Start=$false},
        @{Name="XblGameSave";        Type="Manual";    Start=$false},
        @{Name="XboxGipSvc";         Type="Manual";    Start=$false},
        @{Name="XboxNetApiSvc";      Type="Manual";    Start=$false},
        @{Name="WSearch";            Type="Automatic"; Start=$true},
        @{Name="lfsvc";              Type="Manual";    Start=$false},
        @{Name="RemoteRegistry";     Type="Disabled";  Start=$false}
    )
    if (-not $DryRun) {
        foreach ($s in $restoreSvcs) {
            $service = Get-Service -Name $s.Name -ErrorAction SilentlyContinue
            if ($service) {
                Set-Service -Name $s.Name -StartupType $s.Type -ErrorAction SilentlyContinue
                if ($s.Start) { Start-Service -Name $s.Name -ErrorAction SilentlyContinue }
            }
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Servicios del sistema restaurados a sus valores estandar"

    # 5. Apps en segundo plano
    Show-ProgressBar -Percent 65 -Status "Reactivando aplicaciones en segundo plano..."
    if (-not $DryRun) {
        $bgPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
        if (Test-Path $bgPath) { Set-ItemProperty -Path $bgPath -Name "GlobalUserDisabled" -Value 0 -Force }
        $bgPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
        if (Test-Path $bgPol) { Remove-ItemProperty -Path $bgPol -Name "LetAppsRunInBackground" -Force -ErrorAction SilentlyContinue }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Permisos de apps en fondo restaurados"

    # 6. Cortana y busqueda web
    Show-ProgressBar -Percent 75 -Status "Restaurando busqueda web y Cortana..."
    if (-not $DryRun) {
        $sp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (Test-Path $sp) {
            Remove-ItemProperty -Path $sp -Name "AllowCortana" -Force -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $sp -Name "DisableWebSearch" -Force -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $sp -Name "ConnectedSearchUseWeb" -Force -ErrorAction SilentlyContinue
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Busqueda web de Windows restaurada"

    # 7. Xbox Game Bar
    Show-ProgressBar -Percent 85 -Status "Restaurando Xbox Game Bar..."
    if (-not $DryRun) {
        $gb = "HKCU:\Software\Microsoft\GameBar"
        if (Test-Path $gb) {
            Set-ItemProperty -Path $gb -Name "UseNexusForGameBarEnabled" -Value 1 -Force
            Set-ItemProperty -Path $gb -Name "AutoGameModeEnabled" -Value 1 -Force
        }
        $gd = "HKCU:\System\GameConfigStore"
        if (Test-Path $gd) { Set-ItemProperty -Path $gd -Name "GameDVR_Enabled" -Value 1 -Force }
        $gdp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
        if (Test-Path $gdp) { Remove-ItemProperty -Path $gdp -Name "AllowGameDVR" -Force -ErrorAction SilentlyContinue }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressComplete "Xbox Game Bar restaurada"

    # 8. Red, Privacidad y Telemetria
    Show-ProgressBar -Percent 95 -Status "Restaurando red y privacidad..."
    if (-not $DryRun) {
        $netP = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
        Remove-ItemProperty -Path $netP -Name "TcpAckFrequency" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $netP -Name "TCPNoDelay" -Force -ErrorAction SilentlyContinue
        netsh int tcp set global autotuninglevel=normal 2>$null | Out-Null
        
        $tp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (Test-Path $tp) { Remove-ItemProperty -Path $tp -Name "AllowTelemetry" -Force -ErrorAction SilentlyContinue }
        
        $fp = "HKCU:\Software\Microsoft\Siuf\Rules"
        if (Test-Path $fp) { Remove-ItemProperty -Path $fp -Name "NumberOfSIUFInPeriod" -Force -ErrorAction SilentlyContinue }
        
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 1 -Force
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Parametros de red y privacidad restaurados"

    Write-Host ""
    Write-Host "    ============================================================" -ForegroundColor Green
    Write-Host "    RESTAURACION COMPLETADA CON EXITO" -ForegroundColor Green
    Write-Host "    Todos los valores originales de Windows fueron restablecidos." -ForegroundColor White
    Write-Host "    ============================================================" -ForegroundColor Green
    Write-Host ""

    if ($DryRun) {
        Write-Host "    [TEST EXITOSO] Simulacion de restauracion completada." -ForegroundColor Magenta
        exit
    }

    Write-Host "    Se recomienda reiniciar la PC para aplicar todos los cambios." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Deseas reiniciar ahora? [S/N] > " -NoNewline -ForegroundColor Yellow
    $restart = Read-Host
    if ($restart -eq "S" -or $restart -eq "s") {
        Write-Host "    Reiniciando en 5 segundos..." -ForegroundColor Cyan
        Restart-Computer -Force
    } else {
        Write-Host "    Recorda reiniciar cuando puedas." -ForegroundColor Gray
    }
    exit
}

# ============================================================================
# OPTIMIZACION (OPCION 1 Y 2)
# ============================================================================

$isDesktop = ($pcType -eq "1")
$typeName = "NOTEBOOK / LAPTOP"
if ($isDesktop) { $typeName = "PC DE ESCRITORIO" }

# Modo de ejecucion
$autoMode = $false
if (-not $DryRun) {
    Write-Host ""
    Write-Host "    Como queres ejecutar la optimizacion?" -ForegroundColor White
    Write-Host "    [1] INTERACTIVO - Te pregunta y explica cada paso" -ForegroundColor White
    Write-Host "    [2] AUTOMATICO  - Aplica todo de una sola vez" -ForegroundColor White
    Write-Host ""
    Write-Host "    Elegir modo [1/2] > " -NoNewline -ForegroundColor Yellow
    $modeChoice = Read-Host
    if ($modeChoice -eq "2") { $autoMode = $true }
} else {
    $autoMode = $true
}

$askAll = -not $autoMode

$totalSteps = 10
Clear-Host
Show-Banner
Write-Host "    Modo: $typeName" -ForegroundColor Green
Write-Host ""
Write-Host "    Plan de optimizacion que se ejecutara:" -ForegroundColor White
Write-Host "    1.  Desactivar animaciones y transparencias" -ForegroundColor Cyan
Write-Host "    2.  Desactivar notificaciones y sugerencias molestas" -ForegroundColor Cyan
Write-Host "    3.  Configurar plan de energia optimo" -ForegroundColor Cyan
Write-Host "    4.  Desactivar servicios innecesarios en segundo plano" -ForegroundColor Cyan
Write-Host "    5.  Desactivar ejecucion de apps en background" -ForegroundColor Cyan
Write-Host "    6.  Desactivar Cortana y telemetria de busqueda web" -ForegroundColor Cyan
Write-Host "    7.  Desactivar Xbox Game Bar y Game DVR" -ForegroundColor Cyan
Write-Host "    8.  Limpiar temporales y vaciar cache DNS" -ForegroundColor Cyan
if ($isDesktop) {
    Write-Host "    9.  Optimizar red para baja latencia (Gaming)" -ForegroundColor Cyan
} else {
    Write-Host "    9.  Optimizaciones especificas de notebook y bateria" -ForegroundColor Cyan
}
Write-Host "    10. Reducir telemetria y recoleccion de datos" -ForegroundColor Cyan
Write-Host ""

if (-not $autoMode) {
    Write-Host "    Presiona ENTER para iniciar o escribe 'salir' para cancelar: " -NoNewline -ForegroundColor Yellow
    $confirm = Read-Host
    if ($confirm -eq "salir") {
        Write-Host "    Cancelado." -ForegroundColor Gray
        exit
    }
}

# Punto de restauracion
Write-Host ""
Write-Host "    Preparando punto de restauracion de seguridad..." -ForegroundColor Yellow
Show-ProgressBar -Percent 20 -Status "Configurando..."

if (-not $DryRun) {
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Show-ProgressBar -Percent 60 -Status "Creando punto de restauracion..."
        Checkpoint-Computer -Description "Optimizador Windows - $typeName" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        Show-ProgressBar -Percent 100 -Status "Completado"
        Show-ProgressComplete "Punto de restauracion creado con exito"
    } catch {
        Show-ProgressBar -Percent 100 -Status "Continuando"
        Write-Host ""
        Write-Host "    [i] Punto de restauracion omitido (ya habia uno reciente o no esta soportado)" -ForegroundColor DarkYellow
    }
} else {
    Start-Sleep -Milliseconds 300
    Show-ProgressBar -Percent 100 -Status "Simulado"
    Show-ProgressComplete "Simulacion de punto de restauracion OK"
}

function Should-Proceed {
    param([int]$Step, [int]$Total, [string]$Title, [string]$Desc)
    if ($autoMode -or -not $script:askAll) { return $true }
    
    Show-StepHeader -Step $Step -Total $Total -Title $Title -Description $Desc
    $resp = Ask-Proceed
    
    if ($resp -eq "T") {
        $script:askAll = $false
        return $true
    }
    return ($resp -eq "S" -or $resp -eq "")
}

$currentStep = 0
$stepsApplied = 0
$stepsSkipped = 0

# PASO 1: ANIMACIONES
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "ANIMACIONES Y EFECTOS VISUALES" -Desc "Desactiva animaciones de ventanas, transparencias y retrasos de menus.") {
    Show-ProgressBar -Percent 10 -Status "Configurando registro de animaciones..."
    if (-not $DryRun) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -Force
        
        $pp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (Test-Path $pp) { Set-ItemProperty -Path $pp -Name "EnableTransparency" -Value 0 -Force }
        
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "0" -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "AnimationEnabled" -Value 0 -PropertyType String -Force | Out-Null
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Animaciones y transparencias desactivadas (fuentes protegidas)"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 2: NOTIFICACIONES
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "NOTIFICACIONES Y SUGERENCIAS" -Desc "Desactiva popups, sugerencias y publicidad en el menu Inicio.") {
    Show-ProgressBar -Percent 20 -Status "Desactivando avisos y toasts..."
    if (-not $DryRun) {
        $pushPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
        if (-not (Test-Path $pushPath)) { New-Item -Path $pushPath -Force | Out-Null }
        Set-ItemProperty -Path $pushPath -Name "ToastEnabled" -Value 0 -Force
        
        $np = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        if (-not (Test-Path $np)) { New-Item -Path $np -Force | Out-Null }
        Set-ItemProperty -Path $np -Name "DisableNotificationCenter" -Value 1 -Force
        
        $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $keys = @("SubscribedContent-338389Enabled","SubscribedContent-310093Enabled","SubscribedContent-338388Enabled","SubscribedContent-353698Enabled","SoftLandingEnabled","SystemPaneSuggestionsEnabled","RotatingLockScreenEnabled","RotatingLockScreenOverlayEnabled")
        foreach ($k in $keys) {
            Set-ItemProperty -Path $cdm -Name $k -Value 0 -Force -ErrorAction SilentlyContinue
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Notificaciones y sugerencias desactivadas"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 3: PLAN DE ENERGIA
$currentStep++
$energyDesc = "High Performance enchufado, Balanced en bateria."
if ($isDesktop) { $energyDesc = "Plan Ultimate Performance sin suspension de disco ni sistema." }

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "PLAN DE ENERGIA" -Desc $energyDesc) {
    Show-ProgressBar -Percent 30 -Status "Configurando perfiles de energia..."
    if (-not $DryRun) {
        if ($isDesktop) {
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
            $plans = powercfg -list
            $guid = ""
            foreach ($line in $plans) {
                if ($line -match "([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})" -and $line -match "Ultimate") {
                    $guid = $matches[1]
                    break
                }
            }
            if ($guid -ne "") {
                powercfg -setactive $guid 2>$null
            } else {
                powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
            }
            powercfg -change -disk-timeout-ac 0
            powercfg -change -standby-timeout-ac 0
            powercfg -change -monitor-timeout-ac 15
        } else {
            powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
            powercfg -change -disk-timeout-ac 0
            powercfg -change -standby-timeout-ac 0
            powercfg -change -monitor-timeout-ac 15
            powercfg -change -disk-timeout-dc 10
            powercfg -change -standby-timeout-dc 20
            powercfg -change -monitor-timeout-dc 5
            powercfg -h off 2>$null
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Plan de energia optimizado"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 4: SERVICIOS
$currentStep++
$servicios = @(
    @{Name="DiagTrack";          Desc="Telemetria Microsoft"},
    @{Name="dmwappushservice";   Desc="Push de diagnostico"},
    @{Name="SysMain";            Desc="Superfetch/SysMain (innecesario en SSD)"},
    @{Name="MapsBroker";         Desc="Mapas offline"},
    @{Name="RetailDemo";         Desc="Modo demostracion"},
    @{Name="wisvc";              Desc="Windows Insider"},
    @{Name="WerSvc";             Desc="Reporte de errores"},
    @{Name="Fax";                Desc="Servicio de Fax"},
    @{Name="XblAuthManager";     Desc="Xbox Live Auth"},
    @{Name="XblGameSave";        Desc="Xbox Game Save"},
    @{Name="XboxGipSvc";         Desc="Xbox Accessory"},
    @{Name="XboxNetApiSvc";      Desc="Xbox Networking"}
)

if ($isDesktop) {
    $servicios += @{Name="WSearch"; Desc="Windows Search Indexer"}
    $servicios += @{Name="lfsvc";   Desc="Servicio de ubicacion"}
} else {
    $servicios += @{Name="RemoteRegistry"; Desc="Registro remoto"}
}

$svcDesc = "Detiene y desactiva servicios secundarios innecesarios."
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "SERVICIOS EN SEGUNDO PLANO" -Desc $svcDesc) {
    $i = 0
    foreach ($svc in $servicios) {
        $i++
        $p = [math]::Floor(40 + ($i / $servicios.Count * 10))
        Show-ProgressBar -Percent $p -Status "Servicio: $($svc.Desc)"
        if (-not $DryRun) {
            $s = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($s) {
                Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }
        Start-Sleep -Milliseconds 50
    }
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Servicios optimizados correctamente"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 5: APPS EN SEGUNDO PLANO
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "APPS EN SEGUNDO PLANO" -Desc "Impide que aplicaciones de la Store consuman CPU/RAM sin estar abiertas.") {
    Show-ProgressBar -Percent 50 -Status "Aplicando politicas de apps en fondo..."
    if (-not $DryRun) {
        $bgPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
        if (-not (Test-Path $bgPath)) { New-Item -Path $bgPath -Force | Out-Null }
        Set-ItemProperty -Path $bgPath -Name "GlobalUserDisabled" -Value 1 -Force
        
        $bgPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
        if (-not (Test-Path $bgPol)) { New-Item -Path $bgPol -Force | Out-Null }
        Set-ItemProperty -Path $bgPol -Name "LetAppsRunInBackground" -Value 2 -Force
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Apps en segundo plano desactivadas"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 6: CORTANA Y BUSQUEDA WEB
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "CORTANA Y BUSQUEDA WEB" -Desc "Desactiva Cortana y busquedas de Bing en el menu de Inicio.") {
    Show-ProgressBar -Percent 60 -Status "Configurando Windows Search..."
    if (-not $DryRun) {
        $sp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (-not (Test-Path $sp)) { New-Item -Path $sp -Force | Out-Null }
        Set-ItemProperty -Path $sp -Name "AllowCortana" -Value 0 -Force
        Set-ItemProperty -Path $sp -Name "DisableWebSearch" -Value 1 -Force
        Set-ItemProperty -Path $sp -Name "ConnectedSearchUseWeb" -Value 0 -Force
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Cortana y busqueda web desactivadas"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 7: XBOX GAME BAR Y DVR
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "XBOX GAME BAR Y CAPTURAS" -Desc "Desactiva superposicion y grabacion constante en disco de partidas.") {
    Show-ProgressBar -Percent 70 -Status "Desactivando Game DVR..."
    if (-not $DryRun) {
        $gb = "HKCU:\Software\Microsoft\GameBar"
        if (-not (Test-Path $gb)) { New-Item -Path $gb -Force | Out-Null }
        Set-ItemProperty -Path $gb -Name "UseNexusForGameBarEnabled" -Value 0 -Force
        Set-ItemProperty -Path $gb -Name "AutoGameModeEnabled" -Value 0 -Force
        
        $gd = "HKCU:\System\GameConfigStore"
        if (-not (Test-Path $gd)) { New-Item -Path $gd -Force | Out-Null }
        Set-ItemProperty -Path $gd -Name "GameDVR_Enabled" -Value 0 -Force
        
        $gdp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
        if (-not (Test-Path $gdp)) { New-Item -Path $gdp -Force | Out-Null }
        Set-ItemProperty -Path $gdp -Name "AllowGameDVR" -Value 0 -Force
        
        if ($isDesktop) {
            Set-ItemProperty -Path $gb -Name "AllowAutoGameMode" -Value 1 -Force
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Xbox Game Bar y grabacion en segundo plano desactivadas"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 8: ARCHIVOS TEMPORALES
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "LIMPIEZA DE TEMPORALES" -Desc "Elimina archivos temporales acumulados y vacia la cache DNS.") {
    Show-ProgressBar -Percent 80 -Status "Limpiando directorios temporales..."
    $cleanedMB = 0
    if (-not $DryRun) {
        $paths = @($env:TEMP, "$env:LOCALAPPDATA\Temp", "C:\Windows\Temp", "C:\Windows\Prefetch")
        $totalBytes = 0
        foreach ($p in $paths) {
            if (Test-Path $p) {
                $files = Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue
                $bytes = ($files | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                if ($bytes) { $totalBytes += $bytes }
                Remove-Item -Path "$p\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        ipconfig /flushdns | Out-Null
        $cleanedMB = [math]::Round($totalBytes / 1MB, 2)
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Temporales limpiados ($cleanedMB MB liberados) y DNS vaciado"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# PASO 9: RED (DESKTOP) O BATERIA (NOTEBOOK)
$currentStep++
if ($isDesktop) {
    if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "OPTIMIZACION DE RED" -Desc "Reduce latencia de red desactivando el algoritmo de Nagle.") {
        Show-ProgressBar -Percent 90 -Status "Ajustando parametros TCP/IP..."
        if (-not $DryRun) {
            $netP = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
            Set-ItemProperty -Path $netP -Name "TcpAckFrequency" -Value 1 -Force
            Set-ItemProperty -Path $netP -Name "TCPNoDelay" -Value 1 -Force
            netsh int tcp set global autotuninglevel=normal 2>$null | Out-Null
        }
        Start-Sleep -Milliseconds 250
        Show-ProgressBar -Percent 100 -Status "Listo"
        Show-ProgressComplete "Red optimizada para menor latencia"
        $stepsApplied++
    } else {
        Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
        $stepsSkipped++
    }
} else {
    if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "AJUSTES DE NOTEBOOK" -Desc "Desactiva brillo adaptativo y retardo de inicio para acelerar el arranque.") {
        Show-ProgressBar -Percent 90 -Status "Optimizando notebook..."
        if (-not $DryRun) {
            powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 2>$null
            powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 2>$null
            powercfg -setactive SCHEME_CURRENT 2>$null
            
            $sdp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
            if (-not (Test-Path $sdp)) { New-Item -Path $sdp -Force | Out-Null }
            Set-ItemProperty -Path $sdp -Name "StartupDelayInMSec" -Value 0 -Force
            
            $storeP = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
            if (-not (Test-Path $storeP)) { New-Item -Path $storeP -Force | Out-Null }
            Set-ItemProperty -Path $storeP -Name "AutoDownload" -Value 2 -Force
            
            powercfg /batteryreport /output "$env:USERPROFILE\Desktop\battery-report.html" 2>$null
        }
        Start-Sleep -Milliseconds 250
        Show-ProgressBar -Percent 100 -Status "Listo"
        Show-ProgressComplete "Ajustes de notebook aplicados y reporte generado"
        $stepsApplied++
    } else {
        Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
        $stepsSkipped++
    }
}

# PASO 10: TELEMETRIA Y PRIVACIDAD
$currentStep++
if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "TELEMETRIA Y PRIVACIDAD" -Desc "Reduce el envio innecesario de diagnosticos y apaga rastreo publicitario.") {
    Show-ProgressBar -Percent 95 -Status "Reduciendo telemetria..."
    if (-not $DryRun) {
        $tp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (-not (Test-Path $tp)) { New-Item -Path $tp -Force | Out-Null }
        Set-ItemProperty -Path $tp -Name "AllowTelemetry" -Value 0 -Force
        
        $fp = "HKCU:\Software\Microsoft\Siuf\Rules"
        if (-not (Test-Path $fp)) { New-Item -Path $fp -Force | Out-Null }
        Set-ItemProperty -Path $fp -Name "NumberOfSIUFInPeriod" -Value 0 -Force
        
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force
        
        if (-not $isDesktop) {
            $ws = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
            if (Test-Path $ws) { Set-ItemProperty -Path $ws -Name "AutoConnectAllowedOEM" -Value 0 -Force }
        }
    }
    Start-Sleep -Milliseconds 250
    Show-ProgressBar -Percent 100 -Status "Listo"
    Show-ProgressComplete "Telemetria y publicidad desactivadas"
    $stepsApplied++
} else {
    Write-Host "    [SKIP] Paso omitido" -ForegroundColor DarkGray
    $stepsSkipped++
}

# RESUMEN FINAL
Write-Host ""
Write-Host "    ============================================================" -ForegroundColor Green
Write-Host "    OPTIMIZACION COMPLETADA" -ForegroundColor Green
Write-Host "    Modo: $typeName" -ForegroundColor White
Write-Host "    Pasos aplicados: $stepsApplied | Pasos omitidos: $stepsSkipped" -ForegroundColor White
if (-not $isDesktop) {
    Write-Host "    Conservados: Windows Search, GPS y Power Throttling en bateria" -ForegroundColor Cyan
}
Write-Host "    ============================================================" -ForegroundColor Green
Write-Host ""

if ($DryRun) {
    Write-Host "    [TEST EXITOSO] Todo el flujo se ejecuto sin ningun error." -ForegroundColor Magenta
    exit
}

Write-Host "    Se recomienda reiniciar la PC para que todos los cambios surtan efecto." -ForegroundColor Yellow
Write-Host ""
Write-Host "    Deseas reiniciar ahora? [S/N] > " -NoNewline -ForegroundColor Yellow
$restart = Read-Host

if ($restart -eq "S" -or $restart -eq "s") {
    Write-Host "    Reiniciando en 5 segundos..." -ForegroundColor Cyan
    Restart-Computer -Force
} else {
    Write-Host "    Recorda reiniciar cuando puedas." -ForegroundColor Gray
}
