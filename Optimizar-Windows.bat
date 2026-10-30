@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title Optimizador Windows 10/11
color 0B

REM ============================================================================
REM  OPTIMIZADOR WINDOWS 10/11 — SCRIPT UNIFICADO (CMD)
REM  Click derecho > Ejecutar como Administrador
REM ============================================================================

cls
echo.
echo     ================================================================
echo     =                                                              =
echo     =        OPTIMIZADOR WINDOWS 10/11  v2.0  [CMD]               =
echo     =        PC de Escritorio  ^&  Notebook                        =
echo     =                                                              =
echo     ================================================================
echo.

REM --- Verificar admin ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo     ╔════════════════════════════════════════════════╗
    echo     ║  ERROR: Se requieren permisos de ADMINISTRADOR ║
    echo     ║  Click derecho ^> Ejecutar como Administrador   ║
    echo     ╚════════════════════════════════════════════════╝
    echo.
    pause
    exit /b
)

echo     [OK] Ejecutando como Administrador
echo.

REM ============================================================================
REM MENU PRINCIPAL
REM ============================================================================

echo     ┌──────────────────────────────────────────────────────
echo     │
echo     │   Que tipo de equipo queres optimizar?
echo     │
echo     │   [1]  PC DE ESCRITORIO / DESKTOP
echo     │        Plan Ultimate Performance, sin restricciones
echo     │        Desactiva Search Indexer y Geolocalizacion
echo     │
echo     │   [2]  NOTEBOOK / LAPTOP
echo     │        High Performance enchufado, Balanced bateria
echo     │        Conserva Search, GPS y Power Throttling
echo     │
echo     │   [0]  SALIR
echo     │
echo     └──────────────────────────────────────────────────────
echo.
set /p "pctype=    Elegir opcion [1/2/0]: "

if "%pctype%"=="0" (
    echo     Saliendo... No se realizaron cambios.
    timeout /t 2 >nul
    exit /b
)
if "%pctype%"=="1" (
    set "typename=PC DE ESCRITORIO"
    set "isdesktop=1"
) else if "%pctype%"=="2" (
    set "typename=NOTEBOOK / LAPTOP"
    set "isdesktop=0"
) else (
    echo     Opcion invalida.
    timeout /t 2 >nul
    exit /b
)

REM ============================================================================
REM MODO DE EJECUCION
REM ============================================================================

cls
echo.
echo     ================================================================
echo     =   OPTIMIZADOR WINDOWS 10/11  -  !typename!
echo     ================================================================
echo.
echo     ┌──────────────────────────────────────────────────────
echo     │  Como queres ejecutar la optimizacion?
echo     │
echo     │  [1] INTERACTIVO — Pregunta antes de cada paso
echo     │  [2] AUTOMATICO  — Aplica todo sin preguntar
echo     └──────────────────────────────────────────────────────
echo.
set /p "mode=    Elegir modo [1/2]: "

if "%mode%"=="2" (
    set "automode=1"
) else (
    set "automode=0"
)

set "applied=0"
set "skipped=0"

if "%isdesktop%"=="1" (set "totalsteps=10") else (set "totalsteps=10")

REM ============================================================================
REM VISTA PREVIA
REM ============================================================================

cls
echo.
echo     ================================================================
echo     =   !typename!  -  PLAN DE OPTIMIZACION
echo     ================================================================
echo.
echo     Esto es lo que se va a hacer:
echo.
echo      1. Desactivar animaciones y transparencias
echo      2. Desactivar notificaciones y sugerencias
if "%isdesktop%"=="1" (
echo      3. Plan de energia: Ultimate Performance
) else (
echo      3. Plan de energia: High Performance / Balanced bateria
)
if "%isdesktop%"=="1" (
echo      4. Desactivar 14 servicios innecesarios
) else (
echo      4. Desactivar 13 servicios innecesarios
)
echo      5. Desactivar apps en segundo plano
echo      6. Desactivar Cortana y busqueda web
echo      7. Desactivar Xbox Game Bar / DVR
echo      8. Limpiar archivos temporales y cache
if "%isdesktop%"=="1" (
echo      9. Optimizar red para baja latencia
) else (
echo      9. Optimizaciones especificas de notebook
)
echo     10. Reducir telemetria y privacidad
echo.
echo     Total: !totalsteps! pasos
echo.

if "%automode%"=="0" (
    echo     Presiona ENTER para comenzar o escribe "salir" para cancelar.
    set /p "startconfirm=    > "
    if /i "!startconfirm!"=="salir" (
        echo     Cancelado. No se realizaron cambios.
        exit /b
    )
)

cls
echo.
echo     ================================================================
echo     =   OPTIMIZANDO: !typename!
echo     ================================================================
echo.

REM ============================================================================
REM PASO 1: ANIMACIONES
REM ============================================================================

set "step=1"
echo     ┌─ PASO !step!/!totalsteps! ── ANIMACIONES Y EFECTOS VISUALES ──────
echo     │  Desactiva fade, transparencia, animacion de ventanas.
echo     │  Mantiene fuentes suavizadas para no pixelar texto.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N/T(odo)]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso2
    )
    if /i "!resp!"=="T" set "automode=1"
)

echo     [....] Desactivando animaciones...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [████████████████████████████████████████] 100%%
echo     [OK] Animaciones y transparencias desactivadas.
set /a applied+=1
echo.

:paso2
REM ============================================================================
REM PASO 2: NOTIFICACIONES
REM ============================================================================

set "step=2"
echo     ┌─ PASO !step!/!totalsteps! ── NOTIFICACIONES Y SUGERENCIAS ────────
echo     │  Desactiva toast, centro de accion, tips y publicidad.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso3
    )
)

echo     [....] Desactivando notificaciones...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [████████████████████████████████████████] 100%%
echo     [OK] Notificaciones y sugerencias desactivadas.
set /a applied+=1
echo.

:paso3
REM ============================================================================
REM PASO 3: PLAN DE ENERGIA
REM ============================================================================

set "step=3"
if "%isdesktop%"=="1" (
    echo     ┌─ PASO !step!/!totalsteps! ── PLAN DE ENERGIA: ULTIMATE PERFORMANCE ─
    echo     │  Desbloquea plan oculto. Disco nunca apaga, sin suspension.
    echo     └────────────────────────────────────────────────────────
) else (
    echo     ┌─ PASO !step!/!totalsteps! ── PLAN DE ENERGIA INTELIGENTE ──────────
    echo     │  High Performance enchufado / Balanced bateria.
    echo     │  Desactiva hibernacion ^(libera GB de disco^).
    echo     └────────────────────────────────────────────────────────
)

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso4
    )
)

if "%isdesktop%"=="1" (
    echo     [....] Desbloqueando Ultimate Performance...
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg -change -disk-timeout-ac 0
    powercfg -change -standby-timeout-ac 0
    powercfg -change -monitor-timeout-ac 15
    echo     [████████████████████████████████████████] 100%%
    echo     [OK] Ultimate/High Performance activado. Disco: nunca apaga.
) else (
    echo     [....] Configurando plan inteligente para notebook...
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg -change -disk-timeout-ac 0
    powercfg -change -standby-timeout-ac 0
    powercfg -change -monitor-timeout-ac 15
    powercfg -change -disk-timeout-dc 10
    powercfg -change -standby-timeout-dc 20
    powercfg -change -monitor-timeout-dc 5
    powercfg -h off >nul 2>&1
    echo     [████████████████████████████████████████] 100%%
    echo     [OK] Enchufado: High Perf / Bateria: conservador / Hibernacion: OFF
)
set /a applied+=1
echo.

:paso4
REM ============================================================================
REM PASO 4: SERVICIOS
REM ============================================================================

set "step=4"
if "%isdesktop%"=="1" (
    echo     ┌─ PASO !step!/!totalsteps! ── SERVICIOS INNECESARIOS ^(14^) ──────────
    echo     │  Incluye Search Indexer y Geolocalizacion.
) else (
    echo     ┌─ PASO !step!/!totalsteps! ── SERVICIOS INNECESARIOS ^(13^) ──────────
    echo     │  Conserva Search y GPS ^(utiles en portatil^).
)
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso5
    )
)

echo     [....] Desactivando servicios...

for %%s in (DiagTrack dmwappushservice SysMain MapsBroker RetailDemo wisvc WerSvc Fax XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)

if "%isdesktop%"=="1" (
    sc stop WSearch >nul 2>&1 & sc config WSearch start= disabled >nul 2>&1
    sc stop lfsvc >nul 2>&1 & sc config lfsvc start= disabled >nul 2>&1
) else (
    sc stop RemoteRegistry >nul 2>&1 & sc config RemoteRegistry start= disabled >nul 2>&1
)

echo     [████████████████████████████████████████] 100%%
echo     [OK] Servicios innecesarios desactivados.
set /a applied+=1
echo.

:paso5
REM ============================================================================
REM PASO 5: APPS EN SEGUNDO PLANO
REM ============================================================================

set "step=5"
echo     ┌─ PASO !step!/!totalsteps! ── APPS EN SEGUNDO PLANO ───────────────
echo     │  Desactiva todas las apps UWP/Store de correr en background.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso6
    )
)

echo     [....] Desactivando apps en segundo plano...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo     [████████████████████████████████████████] 100%%
echo     [OK] Apps en segundo plano desactivadas.
set /a applied+=1
echo.

:paso6
REM ============================================================================
REM PASO 6: CORTANA
REM ============================================================================

set "step=6"
echo     ┌─ PASO !step!/!totalsteps! ── CORTANA Y BUSQUEDA WEB ──────────────
echo     │  Desactiva Cortana y busqueda web. Busqueda local sigue OK.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso7
    )
)

echo     [....] Desactivando Cortana y busqueda web...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [████████████████████████████████████████] 100%%
echo     [OK] Cortana y busqueda web desactivadas.
set /a applied+=1
echo.

:paso7
REM ============================================================================
REM PASO 7: XBOX GAME BAR
REM ============================================================================

set "step=7"
echo     ┌─ PASO !step!/!totalsteps! ── XBOX GAME BAR / DVR ─────────────────
echo     │  Desactiva Game Bar y grabacion en segundo plano.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso8
    )
)

echo     [....] Desactivando Xbox Game Bar/DVR...
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
if "%isdesktop%"=="1" (
    reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo     [████████████████████████████████████████] 100%%
echo     [OK] Xbox Game Bar/DVR desactivados.
set /a applied+=1
echo.

:paso8
REM ============================================================================
REM PASO 8: TEMPORALES
REM ============================================================================

set "step=8"
echo     ┌─ PASO !step!/!totalsteps! ── LIMPIEZA DE TEMPORALES ──────────────
echo     │  Elimina archivos temporales, prefetch y limpia cache DNS.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :paso9
    )
)

echo     [....] Limpiando Temp del usuario...
del /q /s "%TEMP%\*" >nul 2>&1
echo     [██████████                              ] 25%%
echo     [....] Limpiando Windows Temp...
del /q /s "C:\Windows\Temp\*" >nul 2>&1
echo     [████████████████████                    ] 50%%
echo     [....] Limpiando Prefetch...
del /q /s "C:\Windows\Prefetch\*" >nul 2>&1
echo     [██████████████████████████████          ] 75%%
echo     [....] Limpiando cache DNS...
ipconfig /flushdns >nul 2>&1
echo     [████████████████████████████████████████] 100%%
echo     [OK] Temporales y cache DNS limpiados.
set /a applied+=1
echo.

:paso9
REM ============================================================================
REM PASO 9: RED (desktop) o EXTRAS (notebook)
REM ============================================================================

set "step=9"
if "%isdesktop%"=="1" (
    echo     ┌─ PASO !step!/!totalsteps! ── OPTIMIZACION DE RED ──────────────────
    echo     │  Reduce latencia desactivando Nagle's Algorithm. Ideal gaming.
    echo     └────────────────────────────────────────────────────────

    if "%automode%"=="0" (
        set /p "resp=    Aplicar? [S/N]: "
        if /i "!resp!"=="N" (
            echo     [SKIP] Paso saltado.
            set /a skipped+=1
            goto :paso10
        )
    )

    echo     [....] Optimizando red...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    netsh int tcp set global autotuninglevel=normal >nul 2>&1
    echo     [████████████████████████████████████████] 100%%
    echo     [OK] Red optimizada para baja latencia.
) else (
    echo     ┌─ PASO !step!/!totalsteps! ── EXTRAS DE NOTEBOOK ───────────────────
    echo     │  Brillo adaptativo OFF, delay arranque eliminado, Store OFF.
    echo     └────────────────────────────────────────────────────────

    if "%automode%"=="0" (
        set /p "resp=    Aplicar? [S/N]: "
        if /i "!resp!"=="N" (
            echo     [SKIP] Paso saltado.
            set /a skipped+=1
            goto :paso10
        )
    )

    echo     [....] Desactivando brillo adaptativo...
    powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 >nul 2>&1
    powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0 >nul 2>&1
    powercfg -setactive SCHEME_CURRENT >nul 2>&1
    echo     [██████████████                        ] 33%%
    echo     [....] Eliminando delay de arranque...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul 2>&1
    echo     [████████████████████████████           ] 66%%
    echo     [....] Desactivando auto-update Store...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1
    echo     [████████████████████████████████████████] 100%%
    echo     [....] Generando reporte de bateria...
    powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html" >nul 2>&1
    echo     [OK] Extras de notebook aplicados. Reporte de bateria en Escritorio.
)
set /a applied+=1
echo.

:paso10
REM ============================================================================
REM PASO 10: TELEMETRIA
REM ============================================================================

set "step=10"
echo     ┌─ PASO !step!/!totalsteps! ── TELEMETRIA Y PRIVACIDAD ─────────────
echo     │  Reduce envio de datos a Microsoft, publicidad y feedback.
echo     └────────────────────────────────────────────────────────

if "%automode%"=="0" (
    set /p "resp=    Aplicar? [S/N]: "
    if /i "!resp!"=="N" (
        echo     [SKIP] Paso saltado.
        set /a skipped+=1
        goto :final
    )
)

echo     [....] Reduciendo telemetria...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
if "%isdesktop%"=="0" (
    reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f >nul 2>&1
)
echo     [████████████████████████████████████████] 100%%
echo     [OK] Telemetria y privacidad reducidas.
set /a applied+=1
echo.

:final
REM ============================================================================
REM RESUMEN FINAL
REM ============================================================================

echo.
echo     ================================================================
echo     =                                                              =
echo     =       OPTIMIZACION COMPLETADA                                =
echo     =       Modo: !typename!
echo     =                                                              =
echo     =       Pasos aplicados:  !applied!                               =
echo     =       Pasos saltados:   !skipped!                               =
echo     =                                                              =
if "%isdesktop%"=="0" (
echo     =   Conservados para notebook:                                 =
echo     =   [+] Windows Search ^(busqueda rapida^)                       =
echo     =   [+] Geolocalizacion ^(Encontrar mi dispositivo^)             =
echo     =   [+] Power Throttling en bateria                           =
echo     =                                                              =
)
echo     ================================================================
echo.
color 0E
echo     *** REINICIA EL EQUIPO para aplicar todos los cambios ***
echo     Para revertir: Win+R ^> rstrui ^> Elegir punto de restauracion
echo.
color 0B
set /p "restart=    Reiniciar ahora? [S/N]: "
if /i "%restart%"=="S" (
    echo.
    echo     Reiniciando en 5 segundos...
    shutdown /r /t 5 /c "Reiniciando para aplicar optimizaciones..."
)

echo.
pause
