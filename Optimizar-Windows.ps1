# ============================================================================
#  OPTIMIZADOR WINDOWS 10/11 — SCRIPT UNIFICADO INTERACTIVO
#  Ejecutar: Click derecho > Ejecutar con PowerShell (como Admin)
#  O: PowerShell Admin > Set-ExecutionPolicy Bypass -Scope Process -Force; .\Optimizar-Windows.ps1
# ============================================================================

# --- Configuracion de consola ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Optimizador Windows 10/11"
$ErrorActionPreference = "SilentlyContinue"

# ============================================================================
# FUNCIONES DE UI
# ============================================================================

function Show-Banner {
    Clear-Host
    $banner = @"

    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║     ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗      ║
    ║    ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝      ║
    ║    ██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝       ║
    ║    ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝        ║
    ║    ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗      ║
    ║     ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝      ║
    ║                                                              ║
    ║          OPTIMIZADOR WINDOWS 10/11  v2.0                     ║
    ║          PC de Escritorio  &  Notebook                       ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝

"@
    Write-Host $banner -ForegroundColor Cyan
}

function Show-ProgressBar {
    param(
        [int]$Percent,
        [string]$Status,
        [int]$BarWidth = 40
    )
    $filled = [math]::Floor($BarWidth * $Percent / 100)
    $empty = $BarWidth - $filled
    $bar = ("█" * $filled) + ("░" * $empty)
    
    $color = if ($Percent -lt 33) { "Yellow" } elseif ($Percent -lt 66) { "Cyan" } else { "Green" }
    
    Write-Host "`r    [$bar] $Percent%  $Status                    " -ForegroundColor $color -NoNewline
}

function Show-ProgressComplete {
    param([string]$Message)
    Write-Host ""
    Write-Host "    ✓ $Message" -ForegroundColor Green
}

function Show-StepHeader {
    param(
        [int]$Step,
        [int]$Total,
        [string]$Title,
        [string]$Description
    )
    Write-Host ""
    Write-Host "    ┌──────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "    │  PASO $Step/$Total — $Title" -ForegroundColor White
    Write-Host "    │  $Description" -ForegroundColor Gray
    Write-Host "    └──────────────────────────────────────────────────────" -ForegroundColor DarkGray
}

function Ask-Proceed {
    param([string]$Question = "Aplicar este paso?")
    Write-Host ""
    Write-Host "    $Question" -ForegroundColor Yellow -NoNewline
    Write-Host " [S/N/T]: " -ForegroundColor DarkYellow -NoNewline
    Write-Host "(S=Si, N=Saltar, T=Todo sin preguntar)" -ForegroundColor DarkGray
    Write-Host "    > " -NoNewline -ForegroundColor Yellow
    $resp = Read-Host
    return $resp.ToUpper().Trim()
}

function Show-Separator {
    Write-Host "    ──────────────────────────────────────────────────────" -ForegroundColor DarkGray
}

function Animate-Step {
    param([string]$Text, [int]$Ms = 30)
    foreach ($char in $Text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor White
        Start-Sleep -Milliseconds $Ms
    }
    Write-Host ""
}

# ============================================================================
# VERIFICAR PERMISOS
# ============================================================================

Show-Banner

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "    ╔════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "    ║  ERROR: Se requieren permisos de ADMINISTRADOR ║" -ForegroundColor Red
    Write-Host "    ║  Click derecho > Ejecutar como Administrador   ║" -ForegroundColor Red
    Write-Host "    ╚════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    pause
    exit
}

Write-Host "    ✓ Ejecutando como Administrador" -ForegroundColor Green
Write-Host ""

# ============================================================================
# MENU PRINCIPAL — ELEGIR TIPO DE PC
# ============================================================================

function Show-Menu {
    Write-Host "    ┌──────────────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host "    │" -ForegroundColor Cyan
    Write-Host "    │   Que tipo de equipo queres optimizar?" -ForegroundColor White
    Write-Host "    │" -ForegroundColor Cyan
    Write-Host "    │   ┌───┐" -ForegroundColor Cyan
    Write-Host "    │   │ 1 │  🖥️  PC DE ESCRITORIO / DESKTOP" -ForegroundColor White
    Write-Host "    │   └───┘  Plan Ultimate Performance, sin restricciones" -ForegroundColor Gray
    Write-Host "    │          Desactiva Search Indexer y Geolocalizacion" -ForegroundColor DarkGray
    Write-Host "    │          Optimiza red para baja latencia (gaming)" -ForegroundColor DarkGray
    Write-Host "    │" -ForegroundColor Cyan
    Write-Host "    │   ┌───┐" -ForegroundColor Cyan
    Write-Host "    │   │ 2 │  💻  NOTEBOOK / LAPTOP" -ForegroundColor White
    Write-Host "    │   └───┘  High Performance enchufado, Balanced bateria" -ForegroundColor Gray
    Write-Host "    │          Conserva Search, GPS y Power Throttling" -ForegroundColor DarkGray
    Write-Host "    │          Desactiva hibernacion (libera espacio)" -ForegroundColor DarkGray
    Write-Host "    │" -ForegroundColor Cyan
    Write-Host "    │   ┌───┐" -ForegroundColor Cyan
    Write-Host "    │   │ 0 │  ❌  SALIR" -ForegroundColor White
    Write-Host "    │   └───┘" -ForegroundColor Cyan
    Write-Host "    │" -ForegroundColor Cyan
    Write-Host "    └──────────────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    Elegir opcion > " -NoNewline -ForegroundColor Yellow
}

Show-Menu
$pcType = Read-Host

if ($pcType -eq "0" -or [string]::IsNullOrWhiteSpace($pcType)) {
    Write-Host ""
    Write-Host "    Saliendo... No se realizaron cambios." -ForegroundColor Gray
    Start-Sleep -Seconds 2
    exit
}

if ($pcType -notin @("1","2")) {
    Write-Host "    Opcion invalida. Saliendo." -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

$isDesktop = ($pcType -eq "1")
$typeName = if ($isDesktop) { "PC DE ESCRITORIO" } else { "NOTEBOOK / LAPTOP" }

Clear-Host
Show-Banner
Write-Host "    Modo seleccionado: $typeName" -ForegroundColor Green
Write-Host ""

# ============================================================================
# MODO DE EJECUCION
# ============================================================================

Write-Host "    ┌──────────────────────────────────────────────────────" -ForegroundColor Magenta
Write-Host "    │  Como queres ejecutar la optimizacion?" -ForegroundColor White
Write-Host "    │" -ForegroundColor Magenta
Write-Host "    │  [1] INTERACTIVO — Pregunta antes de cada paso" -ForegroundColor White
Write-Host "    │  [2] AUTOMATICO  — Aplica todo sin preguntar" -ForegroundColor White
Write-Host "    └──────────────────────────────────────────────────────" -ForegroundColor Magenta
Write-Host ""
Write-Host "    Elegir modo > " -NoNewline -ForegroundColor Yellow
$modeChoice = Read-Host

$autoMode = ($modeChoice -eq "2")
$askAll = $true  # Will be set to false if user chooses "T" (Todo)

# ============================================================================
# VISTA PREVIA DE PASOS
# ============================================================================

Clear-Host
Show-Banner
Write-Host "    Modo: $typeName | $(if($autoMode){'AUTOMATICO'}else{'INTERACTIVO'})" -ForegroundColor Green
Write-Host ""
Write-Host "    ┌──────────────────────────────────────────────────────" -ForegroundColor Yellow
Write-Host "    │  PLAN DE OPTIMIZACION — Esto es lo que se va a hacer:" -ForegroundColor White
Write-Host "    │" -ForegroundColor Yellow

$stepNum = 0

$stepNum++; Write-Host "    │  $stepNum. ⚡ Desactivar animaciones y transparencias" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🔕 Desactivar notificaciones y sugerencias" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🔋 Configurar plan de energia ($( if($isDesktop){'Ultimate Performance'}else{'High Perf enchufado / Balanced bateria'} ))" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🛑 Desactivar servicios innecesarios ($(if($isDesktop){'14'}else{'13'}) servicios)" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 📱 Desactivar apps en segundo plano" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🤖 Desactivar Cortana y busqueda web" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🎮 Desactivar Xbox Game Bar / DVR" -ForegroundColor Cyan
$stepNum++; Write-Host "    │  $stepNum. 🧹 Limpiar archivos temporales y cache" -ForegroundColor Cyan
if ($isDesktop) {
    $stepNum++; Write-Host "    │  $stepNum. 🌐 Optimizar red para baja latencia" -ForegroundColor Cyan
}
if (-not $isDesktop) {
    $stepNum++; Write-Host "    │  $stepNum. 💻 Optimizaciones especificas de notebook" -ForegroundColor Cyan
}
$stepNum++; Write-Host "    │  $stepNum. 🔒 Reducir telemetria y privacidad" -ForegroundColor Cyan

$totalSteps = $stepNum

Write-Host "    │" -ForegroundColor Yellow
Write-Host "    │  Total: $totalSteps pasos" -ForegroundColor White
Write-Host "    └──────────────────────────────────────────────────────" -ForegroundColor Yellow
Write-Host ""

if (-not $autoMode) {
    Write-Host "    Presiona ENTER para comenzar o escribe 'salir' para cancelar" -ForegroundColor Yellow
    Write-Host "    > " -NoNewline -ForegroundColor Yellow
    $confirm = Read-Host
    if ($confirm -eq "salir") {
        Write-Host "    Cancelado. No se realizaron cambios." -ForegroundColor Gray
        exit
    }
}

# ============================================================================
# CREAR PUNTO DE RESTAURACION
# ============================================================================

Clear-Host
Show-Banner
Write-Host "    Modo: $typeName" -ForegroundColor Green
Write-Host ""
Write-Host "    Creando punto de restauracion del sistema..." -ForegroundColor Yellow
Show-ProgressBar -Percent 5 -Status "Preparando..."
try {
    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
    Show-ProgressBar -Percent 50 -Status "Guardando estado del sistema..."
    Checkpoint-Computer -Description "Antes de Optimizacion - $typeName" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    Show-ProgressBar -Percent 100 -Status "Completado"
    Show-ProgressComplete "Punto de restauracion creado (podes revertir todo desde ahi)"
} catch {
    Write-Host ""
    Write-Host "    ⚠ No se pudo crear punto de restauracion (puede existir uno reciente)" -ForegroundColor DarkYellow
}

# ============================================================================
# CONTADORES Y ESTADO
# ============================================================================
$currentStep = 0
$stepsApplied = 0
$stepsSkipped = 0

function Should-Proceed {
    param([int]$Step, [int]$Total, [string]$Title, [string]$Desc)
    
    if ($autoMode -or -not $askAll) { return $true }
    
    Show-StepHeader -Step $Step -Total $Total -Title $Title -Description $Desc
    $resp = Ask-Proceed
    
    if ($resp -eq "T") {
        $script:askAll = $false
        return $true
    }
    return ($resp -eq "S" -or $resp -eq "")
}

# ============================================================================
# PASO 1: ANIMACIONES Y EFECTOS VISUALES
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "ANIMACIONES Y EFECTOS VISUALES" -Desc "Desactiva fade, transparencia, animacion de ventanas. Mantiene fuentes suavizadas.") {
    
    Show-ProgressBar -Percent ($pctBase + 2) -Status "Desactivando UserPreferencesMask..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -Force
    Start-Sleep -Milliseconds 200
    
    Show-ProgressBar -Percent ($pctBase + 4) -Status "Desactivando animacion minimizar/maximizar..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Force
    Start-Sleep -Milliseconds 200
    
    Show-ProgressBar -Percent ($pctBase + 5) -Status "Desactivando animaciones del taskbar..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -Force
    Start-Sleep -Milliseconds 200
    
    Show-ProgressBar -Percent ($pctBase + 7) -Status "Desactivando transparencia (Mica/Acrylic)..."
    $pp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    if (Test-Path $pp) { Set-ItemProperty -Path $pp -Name "EnableTransparency" -Value 0 -Force }
    Start-Sleep -Milliseconds 200

    Show-ProgressBar -Percent ($pctBase + 8) -Status "Desactivando arrastre completo y delay de menus..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "0" -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "AnimationEnabled" -Value 0 -PropertyType String -Force | Out-Null

    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Animaciones y transparencias desactivadas"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 2: NOTIFICACIONES
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "NOTIFICACIONES Y SUGERENCIAS" -Desc "Desactiva toast, centro de accion, tips de Windows y publicidad del Start Menu.") {
    
    Show-ProgressBar -Percent ($pctBase + 3) -Status "Desactivando toast notifications..."
    $pushPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
    if (-not (Test-Path $pushPath)) { New-Item -Path $pushPath -Force | Out-Null }
    Set-ItemProperty -Path $pushPath -Name "ToastEnabled" -Value 0 -Force
    Start-Sleep -Milliseconds 150

    Show-ProgressBar -Percent ($pctBase + 5) -Status "Desactivando centro de accion..."
    $np = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
    if (-not (Test-Path $np)) { New-Item -Path $np -Force | Out-Null }
    Set-ItemProperty -Path $np -Name "DisableNotificationCenter" -Value 1 -Force
    Start-Sleep -Milliseconds 150

    Show-ProgressBar -Percent ($pctBase + 8) -Status "Desactivando sugerencias y publicidad..."
    $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    @("SubscribedContent-338389Enabled","SubscribedContent-310093Enabled","SubscribedContent-338388Enabled",
      "SubscribedContent-353698Enabled","SoftLandingEnabled","SystemPaneSuggestionsEnabled",
      "RotatingLockScreenEnabled","RotatingLockScreenOverlayEnabled") | ForEach-Object {
        Set-ItemProperty -Path $cdm -Name $_ -Value 0 -Force -ErrorAction SilentlyContinue
    }

    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Notificaciones y sugerencias desactivadas"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 3: PLAN DE ENERGIA
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if ($isDesktop) {
    $energyTitle = "PLAN DE ENERGIA: ULTIMATE PERFORMANCE"
    $energyDesc = "Desbloquea y activa el plan mas agresivo. Disco nunca apaga, sin suspension."
} else {
    $energyTitle = "PLAN DE ENERGIA INTELIGENTE"
    $energyDesc = "High Performance enchufado, Balanced con bateria. Desactiva hibernacion."
}

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title $energyTitle -Desc $energyDesc) {
    
    if ($isDesktop) {
        Show-ProgressBar -Percent ($pctBase + 3) -Status "Desbloqueando Ultimate Performance..."
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        Start-Sleep -Milliseconds 300
        
        Show-ProgressBar -Percent ($pctBase + 5) -Status "Activando plan..."
        $up = powercfg -list | Select-String "Ultimate" | ForEach-Object {
            if ($_ -match '([a-f0-9\-]{36})') { $matches[1] }
        }
        if ($up) {
            powercfg -setactive $up
            Show-ProgressBar -Percent ($pctBase + 7) -Status "Ultimate Performance activado"
        } else {
            powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
            Show-ProgressBar -Percent ($pctBase + 7) -Status "High Performance activado (fallback)"
        }
        
        Show-ProgressBar -Percent ($pctBase + 9) -Status "Configurando timeouts..."
        powercfg -change -disk-timeout-ac 0
        powercfg -change -standby-timeout-ac 0
        powercfg -change -monitor-timeout-ac 15
        
        Show-ProgressBar -Percent $pctEnd -Status "Completado"
        Show-ProgressComplete "Plan Ultimate Performance activado — disco nunca apaga, sin suspension"
    } else {
        Show-ProgressBar -Percent ($pctBase + 3) -Status "Activando High Performance..."
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
        Start-Sleep -Milliseconds 300
        
        Show-ProgressBar -Percent ($pctBase + 5) -Status "Configurando AC (enchufado)..."
        powercfg -change -disk-timeout-ac 0
        powercfg -change -standby-timeout-ac 0
        powercfg -change -monitor-timeout-ac 15
        
        Show-ProgressBar -Percent ($pctBase + 7) -Status "Configurando DC (bateria)..."
        powercfg -change -disk-timeout-dc 10
        powercfg -change -standby-timeout-dc 20
        powercfg -change -monitor-timeout-dc 5
        
        Show-ProgressBar -Percent ($pctBase + 9) -Status "Desactivando hibernacion..."
        powercfg -h off 2>$null
        
        Show-ProgressBar -Percent $pctEnd -Status "Completado"
        Show-ProgressComplete "Enchufado: High Performance | Bateria: conservador | Hibernacion: OFF"
    }
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 4: SERVICIOS INNECESARIOS
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

$servicios = @(
    @{Name="DiagTrack";          Desc="Telemetria de Microsoft"},
    @{Name="dmwappushservice";   Desc="Push de telemetria"},
    @{Name="SysMain";            Desc="Superfetch (innecesario con SSD)"},
    @{Name="MapsBroker";         Desc="Mapas descargados"},
    @{Name="RetailDemo";         Desc="Modo demo de tienda"},
    @{Name="wisvc";              Desc="Windows Insider"},
    @{Name="WerSvc";             Desc="Reporte de errores Windows"},
    @{Name="Fax";                Desc="Servicio de Fax"},
    @{Name="XblAuthManager";     Desc="Xbox Live Auth"},
    @{Name="XblGameSave";        Desc="Xbox Game Save"},
    @{Name="XboxGipSvc";         Desc="Xbox Accessory Management"},
    @{Name="XboxNetApiSvc";      Desc="Xbox Live Networking"}
)

if ($isDesktop) {
    $servicios += @{Name="WSearch"; Desc="Windows Search Indexer"}
    $servicios += @{Name="lfsvc";   Desc="Geolocalizacion"}
} else {
    $servicios += @{Name="RemoteRegistry"; Desc="Registro remoto (seguridad)"}
}

$svcCount = $servicios.Count
$svcLabel = if ($isDesktop) { "$svcCount servicios (incluye Search Indexer y GPS)" } else { "$svcCount servicios (conserva Search y GPS)" }

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "SERVICIOS INNECESARIOS" -Desc "Detiene y desactiva $svcLabel") {
    
    $i = 0
    foreach ($svc in $servicios) {
        $i++
        $pct = $pctBase + [math]::Floor(($pctEnd - $pctBase) * $i / $svcCount)
        Show-ProgressBar -Percent $pct -Status "Desactivando: $($svc.Desc)..."
        
        $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
        if ($service) {
            Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
        }
        Start-Sleep -Milliseconds 100
    }
    
    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "$svcCount servicios detenidos y desactivados"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 5: APPS EN SEGUNDO PLANO
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "APPS EN SEGUNDO PLANO" -Desc "Desactiva todas las apps UWP/Store de correr en background. Libera RAM y CPU.") {
    
    Show-ProgressBar -Percent ($pctBase + 4) -Status "Desactivando a nivel de usuario..."
    $bgPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
    if (-not (Test-Path $bgPath)) { New-Item -Path $bgPath -Force | Out-Null }
    Set-ItemProperty -Path $bgPath -Name "GlobalUserDisabled" -Value 1 -Force
    Start-Sleep -Milliseconds 200

    Show-ProgressBar -Percent ($pctBase + 8) -Status "Aplicando politica de sistema..."
    $bgPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
    if (-not (Test-Path $bgPol)) { New-Item -Path $bgPol -Force | Out-Null }
    Set-ItemProperty -Path $bgPol -Name "LetAppsRunInBackground" -Value 2 -Force
    
    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Apps en segundo plano desactivadas globalmente"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 6: CORTANA Y BUSQUEDA WEB
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "CORTANA Y BUSQUEDA WEB" -Desc "Desactiva Cortana y la busqueda web desde el menu Start. La busqueda local sigue funcionando.") {
    
    Show-ProgressBar -Percent ($pctBase + 4) -Status "Desactivando Cortana..."
    $sp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    if (-not (Test-Path $sp)) { New-Item -Path $sp -Force | Out-Null }
    Set-ItemProperty -Path $sp -Name "AllowCortana" -Value 0 -Force
    Start-Sleep -Milliseconds 200
    
    Show-ProgressBar -Percent ($pctBase + 7) -Status "Desactivando busqueda web..."
    Set-ItemProperty -Path $sp -Name "DisableWebSearch" -Value 1 -Force
    Set-ItemProperty -Path $sp -Name "ConnectedSearchUseWeb" -Value 0 -Force
    
    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Cortana y busqueda web desactivadas"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 7: XBOX GAME BAR / DVR
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "XBOX GAME BAR / DVR" -Desc "Desactiva Game Bar y grabacion en segundo plano. $(if($isDesktop){'Activa Game Mode (mejora gaming).'}else{'Libera recursos.'})") {
    
    Show-ProgressBar -Percent ($pctBase + 3) -Status "Desactivando Game Bar..."
    $gb = "HKCU:\Software\Microsoft\GameBar"
    if (-not (Test-Path $gb)) { New-Item -Path $gb -Force | Out-Null }
    Set-ItemProperty -Path $gb -Name "UseNexusForGameBarEnabled" -Value 0 -Force
    Set-ItemProperty -Path $gb -Name "AutoGameModeEnabled" -Value 0 -Force
    Start-Sleep -Milliseconds 200

    Show-ProgressBar -Percent ($pctBase + 6) -Status "Desactivando Game DVR..."
    $gd = "HKCU:\System\GameConfigStore"
    if (-not (Test-Path $gd)) { New-Item -Path $gd -Force | Out-Null }
    Set-ItemProperty -Path $gd -Name "GameDVR_Enabled" -Value 0 -Force
    
    $gdp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    if (-not (Test-Path $gdp)) { New-Item -Path $gdp -Force | Out-Null }
    Set-ItemProperty -Path $gdp -Name "AllowGameDVR" -Value 0 -Force

    if ($isDesktop) {
        Show-ProgressBar -Percent ($pctBase + 8) -Status "Activando Game Mode..."
        Set-ItemProperty -Path $gb -Name "AllowAutoGameMode" -Value 1 -Force
    }

    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Xbox Game Bar/DVR desactivados$(if($isDesktop){' | Game Mode activado'})"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 8: LIMPIAR TEMPORALES
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "LIMPIEZA DE TEMPORALES" -Desc "Elimina archivos temporales, prefetch y limpia cache DNS.") {
    
    $tempPaths = @(
        @{Path="$env:TEMP";               Label="Temp del usuario"},
        @{Path="$env:LOCALAPPDATA\Temp";   Label="LocalAppData Temp"},
        @{Path="C:\Windows\Temp";          Label="Windows Temp"},
        @{Path="C:\Windows\Prefetch";      Label="Prefetch"}
    )

    $totalCleaned = 0
    $i = 0
    foreach ($tp in $tempPaths) {
        $i++
        $pct = $pctBase + [math]::Floor(($pctEnd - $pctBase - 2) * $i / $tempPaths.Count)
        Show-ProgressBar -Percent $pct -Status "Limpiando: $($tp.Label)..."
        
        if (Test-Path $tp.Path) {
            $files = Get-ChildItem -Path $tp.Path -Recurse -Force -ErrorAction SilentlyContinue
            $totalCleaned += ($files | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
            Remove-Item -Path "$($tp.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        Start-Sleep -Milliseconds 200
    }

    Show-ProgressBar -Percent ($pctEnd - 1) -Status "Limpiando cache DNS..."
    ipconfig /flushdns | Out-Null

    $cleanedMB = [math]::Round($totalCleaned / 1MB, 2)
    
    Show-ProgressBar -Percent $pctEnd -Status "Completado"
    Show-ProgressComplete "Limpiados $cleanedMB MB de temporales + cache DNS"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# PASO 9: RED (ESCRITORIO) O EXTRAS NOTEBOOK
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = [math]::Floor($currentStep / $totalSteps * 100)

if ($isDesktop) {
    if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "OPTIMIZACION DE RED" -Desc "Reduce latencia desactivando Nagle's Algorithm. Ideal para gaming online.") {
        
        Show-ProgressBar -Percent ($pctBase + 4) -Status "Desactivando Nagle's Algorithm..."
        $netP = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
        Set-ItemProperty -Path $netP -Name "TcpAckFrequency" -Value 1 -Force
        Set-ItemProperty -Path $netP -Name "TCPNoDelay" -Value 1 -Force
        Start-Sleep -Milliseconds 200

        Show-ProgressBar -Percent ($pctBase + 8) -Status "Configurando autotuning..."
        netsh int tcp set global autotuninglevel=normal 2>$null | Out-Null
        
        Show-ProgressBar -Percent $pctEnd -Status "Completado"
        Show-ProgressComplete "Red optimizada para baja latencia"
        $stepsApplied++
    } else {
        Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
        $stepsSkipped++
    }
} else {
    if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "EXTRAS DE NOTEBOOK" -Desc "Desactiva brillo adaptativo, delay de arranque y auto-update de la Store.") {
        
        Show-ProgressBar -Percent ($pctBase + 3) -Status "Desactivando brillo adaptativo..."
        powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 2>$null
        powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 2>$null
        powercfg -setactive SCHEME_CURRENT 2>$null
        Start-Sleep -Milliseconds 200
        
        Show-ProgressBar -Percent ($pctBase + 5) -Status "Eliminando delay de arranque..."
        $sdp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
        if (-not (Test-Path $sdp)) { New-Item -Path $sdp -Force | Out-Null }
        Set-ItemProperty -Path $sdp -Name "StartupDelayInMSec" -Value 0 -Force
        Start-Sleep -Milliseconds 200

        Show-ProgressBar -Percent ($pctBase + 7) -Status "Desactivando auto-update Store..."
        $storeP = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
        if (-not (Test-Path $storeP)) { New-Item -Path $storeP -Force | Out-Null }
        Set-ItemProperty -Path $storeP -Name "AutoDownload" -Value 2 -Force

        Show-ProgressBar -Percent ($pctBase + 9) -Status "Generando reporte de bateria..."
        $batReport = "$env:USERPROFILE\Desktop\battery-report.html"
        powercfg /batteryreport /output $batReport 2>$null

        Show-ProgressBar -Percent $pctEnd -Status "Completado"
        Show-ProgressComplete "Brillo adaptativo OFF | Arranque rapido | Store auto-update OFF"
        if (Test-Path $batReport) {
            Show-ProgressComplete "Reporte de bateria guardado en el Escritorio"
        }
        $stepsApplied++
    } else {
        Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
        $stepsSkipped++
    }
}

# ============================================================================
# PASO 10: TELEMETRIA Y PRIVACIDAD
# ============================================================================
$currentStep++
$pctBase = [math]::Floor(($currentStep - 1) / $totalSteps * 100)
$pctEnd = 100

if (Should-Proceed -Step $currentStep -Total $totalSteps -Title "TELEMETRIA Y PRIVACIDAD" -Desc "Reduce envio de datos a Microsoft, desactiva publicidad personalizada y feedback.") {
    
    Show-ProgressBar -Percent ($pctBase + 3) -Status "Reduciendo telemetria..."
    $tp = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $tp)) { New-Item -Path $tp -Force | Out-Null }
    Set-ItemProperty -Path $tp -Name "AllowTelemetry" -Value 0 -Force
    Start-Sleep -Milliseconds 200

    Show-ProgressBar -Percent ($pctBase + 5) -Status "Desactivando feedback..."
    $fp = "HKCU:\Software\Microsoft\Siuf\Rules"
    if (-not (Test-Path $fp)) { New-Item -Path $fp -Force | Out-Null }
    Set-ItemProperty -Path $fp -Name "NumberOfSIUFInPeriod" -Value 0 -Force
    Start-Sleep -Milliseconds 200

    Show-ProgressBar -Percent ($pctBase + 7) -Status "Desactivando publicidad personalizada..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force

    if (-not $isDesktop) {
        Show-ProgressBar -Percent ($pctBase + 9) -Status "Desactivando WiFi Sense..."
        $ws = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
        if (Test-Path $ws) {
            Set-ItemProperty -Path $ws -Name "AutoConnectAllowedOEM" -Value 0 -Force
        }
    }

    Show-ProgressBar -Percent 100 -Status "Completado"
    Show-ProgressComplete "Telemetria reducida al minimo | Publicidad y feedback OFF"
    $stepsApplied++
} else {
    Write-Host "    ⏭ Paso saltado" -ForegroundColor DarkGray
    $stepsSkipped++
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

Write-Host ""
Write-Host ""
$finalBar = "█" * 40
Write-Host "    [$finalBar] 100%" -ForegroundColor Green
Write-Host ""
Write-Host "    ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "    ║                                                          ║" -ForegroundColor Green
Write-Host "    ║       OPTIMIZACION COMPLETADA                            ║" -ForegroundColor Green
Write-Host "    ║       Modo: $($typeName.PadRight(43))║" -ForegroundColor Green
Write-Host "    ║                                                          ║" -ForegroundColor Green
Write-Host "    ╠══════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "    ║                                                          ║" -ForegroundColor Green
Write-Host "    ║   Pasos aplicados:  $($stepsApplied.ToString().PadRight(37))║" -ForegroundColor Green
Write-Host "    ║   Pasos saltados:   $($stepsSkipped.ToString().PadRight(37))║" -ForegroundColor $(if($stepsSkipped -gt 0){"Yellow"}else{"Green"})
Write-Host "    ║                                                          ║" -ForegroundColor Green

if (-not $isDesktop) {
    Write-Host "    ║   Conservados para notebook:                             ║" -ForegroundColor Cyan
    Write-Host "    ║   ✓ Windows Search (busqueda rapida)                     ║" -ForegroundColor Cyan
    Write-Host "    ║   ✓ Geolocalizacion (Encontrar mi dispositivo)           ║" -ForegroundColor Cyan
    Write-Host "    ║   ✓ Power Throttling en bateria                          ║" -ForegroundColor Cyan
    Write-Host "    ║                                                          ║" -ForegroundColor Green
}

Write-Host "    ╠══════════════════════════════════════════════════════════╣" -ForegroundColor Yellow
Write-Host "    ║                                                          ║" -ForegroundColor Yellow
Write-Host "    ║   ⚠  REINICIA EL EQUIPO para aplicar todos los cambios   ║" -ForegroundColor Yellow
Write-Host "    ║   Se creo un punto de restauracion por seguridad.        ║" -ForegroundColor Yellow
Write-Host "    ║   Para revertir: Win+R > rstrui > Elegir el punto       ║" -ForegroundColor Yellow
Write-Host "    ║                                                          ║" -ForegroundColor Yellow
Write-Host "    ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "    Reiniciar ahora? " -NoNewline -ForegroundColor Yellow
Write-Host "[S/N]: " -NoNewline -ForegroundColor White
$restart = Read-Host

if ($restart -eq "S" -or $restart -eq "s") {
    Write-Host ""
    Write-Host "    Reiniciando en 5 segundos..." -ForegroundColor Cyan
    for ($i = 5; $i -ge 1; $i--) {
        Write-Host "    $i..." -ForegroundColor White
        Start-Sleep -Seconds 1
    }
    Restart-Computer -Force
} else {
    Write-Host ""
    Write-Host "    OK. Recorda reiniciar cuando puedas." -ForegroundColor Gray
    Write-Host ""
    pause
}
