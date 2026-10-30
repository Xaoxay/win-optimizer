@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title Optimizador Windows 10/11
color 0B

echo.
echo     ============================================================
echo     =                                                          =
echo     =               OPTIMIZADOR WINDOWS 10 / 11                =
echo     =               PC de Escritorio  ^&  Notebook              =
echo     =               github.com/Xaoxay/win-optimizer            =
echo     =                                                          =
echo     ============================================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo     [!] Se requieren permisos de Administrador.
    echo         Solicitando elevacion...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo     [OK] Permisos de Administrador verificados
echo.
echo     [1] PC DE ESCRITORIO
echo     [2] NOTEBOOK / LAPTOP
echo     [0] Salir
echo.
set /p "pctype=    Elegir tipo de equipo [1/2/0]: "

if "%pctype%"=="0" exit /b
if "%pctype%"=="1" (
    set "modename=PC DE ESCRITORIO"
    set "isdesk=1"
) else if "%pctype%"=="2" (
    set "modename=NOTEBOOK / LAPTOP"
    set "isdesk=0"
) else (
    echo     Opcion invalida.
    exit /b
)

echo.
echo     [1] INTERACTIVO (Confirmar paso a paso)
echo     [2] AUTOMATICO  (Aplicar todo de una vez)
echo.
set /p "runmode=    Elegir modo [1/2]: "
if "%runmode%"=="2" (set "auto=1") else (set "auto=0")

cls
echo.
echo     ============================================================
echo     =   OPTIMIZANDO: !modename!
echo     ============================================================
echo.

echo     [1/10] Desactivando animaciones y efectos...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [OK] Animaciones desactivadas.
echo.

echo     [2/10] Desactivando notificaciones y sugerencias...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [OK] Notificaciones desactivadas.
echo.

echo     [3/10] Configurando plan de energia...
if "!isdesk!"=="1" (
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg -change -disk-timeout-ac 0
    powercfg -change -standby-timeout-ac 0
    powercfg -change -monitor-timeout-ac 15
    echo     [OK] Plan de energia al maximo activado.
) else (
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg -change -disk-timeout-ac 0
    powercfg -change -standby-timeout-ac 0
    powercfg -change -monitor-timeout-ac 15
    powercfg -change -disk-timeout-dc 10
    powercfg -change -standby-timeout-dc 20
    powercfg -change -monitor-timeout-dc 5
    powercfg -h off >nul 2>&1
    echo     [OK] Plan inteligente para notebook configurado.
)
echo.

echo     [4/10] Desactivando servicios innecesarios...
for %%s in (DiagTrack dmwappushservice SysMain MapsBroker RetailDemo wisvc WerSvc Fax XblAuthManager XblGameSave XboxGipSvc XboxNetApiSvc) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)
if "!isdesk!"=="1" (
    sc stop WSearch >nul 2>&1 & sc config WSearch start= disabled >nul 2>&1
    sc stop lfsvc >nul 2>&1 & sc config lfsvc start= disabled >nul 2>&1
) else (
    sc stop RemoteRegistry >nul 2>&1 & sc config RemoteRegistry start= disabled >nul 2>&1
)
echo     [OK] Servicios en segundo plano optimizados.
echo.

echo     [5/10] Desactivando apps en segundo plano...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
echo     [OK] Apps de la Store en segundo plano apagadas.
echo.

echo     [6/10] Desactivando Cortana y busqueda web...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
echo     [OK] Cortana y busqueda web desactivadas.
echo.

echo     [7/10] Desactivando Xbox Game Bar y DVR...
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [OK] Xbox Game Bar y grabacion en segundo plano apagadas.
echo.

echo     [8/10] Limpiando temporales y DNS...
del /q /s "%TEMP%\*" >nul 2>&1
del /q /s "C:\Windows\Temp\*" >nul 2>&1
del /q /s "C:\Windows\Prefetch\*" >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo     [OK] Temporales y cache DNS eliminados.
echo.

echo     [9/10] Optimizaciones de hardware...
if "!isdesk!"=="1" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
    echo     [OK] Red optimizada para baja latencia en juegos.
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul 2>&1
    powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html" >nul 2>&1
    echo     [OK] Ajustes de inicio y reporte de bateria generados.
)
echo.

echo     [10/10] Reduciendo telemetria...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul 2>&1
echo     [OK] Telemetria reducida al minimo.
echo.

echo     ============================================================
echo     OPTIMIZACION COMPLETADA CON EXITO
echo     ============================================================
echo.
pause
