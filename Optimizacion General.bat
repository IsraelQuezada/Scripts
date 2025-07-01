@echo off
color a
title Optimización Gaming - Aplicar / Revertir

:menu
cls
echo =====================================================
echo            OPTIMIZACION GAMING - MENU
echo =====================================================
echo.
echo  1) Aplicar optimizaciones generales (ambos scripts)
echo  2) Revertir cambios del Ultra Low Latency
echo  3) Salir
echo -----------------------------------------------------
set /p choice=Selecciona una opcion (1-3):

if "%choice%"=="1" goto aplicar_todo
if "%choice%"=="2" goto revertir_ull
if "%choice%"=="3" exit
goto menu

:aplicar_todo
cls
echo Aplicando optimizaciones generales...

REM --- INICIA SCRIPT 1 (Ultra Low Latency Gaming) ---

REM 1. Deshabilitar MMCSS
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t REG_DWORD /d "4" /f

REM 2. SystemResponsiveness al minimo (10 decimal)
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f

REM 3. Activar NoLazyMode
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f

REM 4. Desactivar Nagle
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do (
    reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
    reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
    reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
)

REM 5. Desactivar IDLE en el plan de energia
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current

REM 6. Buffers de red al minimo
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver" ^| find "{"') do (
        for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /s /f "*ReceiveBuffers" ^| findstr "HKEY"') do (
            reg.exe add "%%b" /v "*ReceiveBuffers" /t REG_SZ /d "512" /f > NUL 2>&1
        )
        for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /s /f "*TransmitBuffers" ^| findstr "HKEY"') do (
            reg.exe add "%%b" /v "*TransmitBuffers" /t REG_SZ /d "512" /f > NUL 2>&1
        )
    )
)

REM 7. Desactivar MPO
Reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f

REM 8. Forzar uso de TSC
bcdedit /set useplatformtick No

REM --- INICIA SCRIPT 2 (Max Game Optimizer Extremo) ---

REM --- Servicios innecesarios ---
set SERVICES=BluetoothSupportService bthserv Fax Spooler WSearch wuauserv XblAuthManager XblGameSave XboxNetApiSvc diagnosticshub.standardcollector.service DiagTrack MapsBroker SharedAccess lfsvc PhoneSvc PrintNotify SEMgrSvc ShpAMSvc stisvc TabletInputService vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvss WbioSrvc wisvc WMPNetworkSvc

echo Deshabilitando servicios innecesarios...
for %%S in (%SERVICES%) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)

echo Desinstalando apps nativas innecesarias...
powershell -Command "Get-AppxPackage *3d* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *bing* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *zune* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *xbox* | Where-Object {$_.Name -notlike '*XboxGameCallableUI*'} | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *people* | Where-Object {$_.Name -notlike '*PeopleExperienceHost*'} | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *phone* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *feedback* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *onenote* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *cortana* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *alarms* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *soundrecorder* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *camera* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *communicationsapps* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *getstarted* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *skypeapp* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *mspaint* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *photos* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *messaging* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage *yourphone* | Remove-AppxPackage -ErrorAction SilentlyContinue"

echo Desinstalando Microsoft Store...
powershell -Command "Get-AppxPackage *WindowsStore* | Remove-AppxPackage -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq 'Microsoft.WindowsStore'} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"
sc stop InstallService >nul 2>&1
sc config InstallService start= disabled >nul 2>&1
sc stop wsappx >nul 2>&1
sc config wsappx start= disabled >nul 2>&1

echo Deshabilitando OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
IF EXIST %SystemRoot%\System32\OneDriveSetup.exe (
   %SystemRoot%\System32\OneDriveSetup.exe /uninstall
)

echo Deshabilitando Windows Update...
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1

echo Limpiando programas de inicio innecesarios...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f

echo Quitando icono de Defender de la barra...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d 1 /f

echo Quitando animaciones y efectos visuales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewWatermark /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SelectionFade /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v MenuShowDelay /t REG_SZ /d 0 /f

echo.
echo ---------------------------------------------------------
echo OPTIMIZACION GENERAL COMPLETADA.
echo REINICIA TU PC para aplicar todos los cambios.
echo ---------------------------------------------------------
pause
goto menu

:revertir_ull
cls
echo Revirtiendo cambios de Ultra Low Latency...

REM 1. Habilitar MMCSS
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t REG_DWORD /d "2" /f

REM 2. SystemResponsiveness default (20)
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f

REM 3. Desactivar NoLazyMode
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /f

REM 4. Restaurar Nagle (eliminar claves)
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do (
    reg delete "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /f
    reg delete "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /f
    reg delete "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /f
)

REM 5. Activar IDLE en plan de energia
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg -setactive scheme_current

REM 6. Buffers de red default (1024)
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver" ^| find "{"') do (
        for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /s /f "*ReceiveBuffers" ^| findstr "HKEY"') do (
            reg.exe add "%%b" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f > NUL 2>&1
        )
        for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /s /f "*TransmitBuffers" ^| findstr "HKEY"') do (
            reg.exe add "%%b" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f > NUL 2>&1
        )
    )
)

REM 7. Restaurar MPO
Reg.exe delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /f

REM 8. Restaurar useplatformtick
bcdedit /deletevalue useplatformtick

echo.
echo ---------------------------------------------------------
echo Cambios revertidos. Reinicia tu PC para aplicar efectos.
echo ---------------------------------------------------------
pause
goto menu
