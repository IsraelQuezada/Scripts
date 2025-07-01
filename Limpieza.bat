@echo off
title Limpieza Total Avanzada de Windows y Navegadores
color 2

REM ====================
REM === LIMPIEZA BÁSICA
REM ====================

REM Limpiar caché de DNS
ipconfig /flushdns

REM Limpiar la papelera de reciclaje (oculta mensaje de error si está vacía)
PowerShell Clear-RecycleBin -Force -ErrorAction SilentlyContinue
PowerShell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

REM Limpiar temporales de Windows y usuario
del /s /f /q "%temp%\*.*" 2>nul
rd /s /q "%temp%" 2>nul
md "%temp%" 2>nul
del /s /f /q "C:\Windows\Temp\*.*" 2>nul
rd /s /q "C:\Windows\Temp" 2>nul
md "C:\Windows\Temp" 2>nul

REM Limpiar carpetas temporales heredadas y obsoletas
for %%D in (
    "C:\Windows\tempor~1"
    "C:\Windows\tmp"
    "C:\Windows\history"
    "C:\Windows\cookies"
    "C:\Windows\recent"
    "C:\Windows\spool\printers"
    "C:\Windows\ff*.tmp"
    "%LocalAppData%\Microsoft\Windows\INetCache"
    "%LocalAppData%\Microsoft\Windows\INetCookies"
    "%LocalAppData%\Microsoft\Windows\WebCache"
    "%AppData%\Discord\Cache"
    "%AppData%\Discord\Code Cache"
    "%SystemDrive%\$GetCurrent"
    "%SystemDrive%\$SysReset"
    "%SystemDrive%\$Windows.~BT"
    "%SystemDrive%\$Windows.~WS"
    "%SystemDrive%\$WinREAgent"
    "%SystemDrive%\OneDriveTemp"
    "%LocalAppData%\Temp\mozilla-temp-files"
    "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache"
    "%USERPROFILE%\AppData\Local\Microsoft\Windows\WebCache"
) do (
    rd /s /q "%%D" 2>nul
)

REM Eliminar archivos de caché y temporales específicos
del "%AppData%\Discord\Cache\*" /s /f /q 2>nul
del "%AppData%\Discord\Code Cache\*" /s /f /q 2>nul
del "%ProgramData%\USOPrivate\UpdateStore\*" /s /f /q 2>nul
del "%ProgramData%\USOShared\Logs\*" /s /f /q 2>nul
del "%WINDIR%\Logs\*" /s /f /q 2>nul
del "%WINDIR%\Installer\$PatchCache$\*" /s /f /q 2>nul
del "C:\WIN386.SWP" 2>nul
del "%USERPROFILE%\AppData\Local\Microsoft\Windows\WebCache\*.log" /s /q 2>nul
del "%USERPROFILE%\AppData\Local\Microsoft\Windows\SettingSync\*.log" /s /q 2>nul
del "%USERPROFILE%\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp" /s /q 2>nul
del "%USERPROFILE%\AppData\Local\Microsoft\Terminal Server Client\Cache\*.bin" /s /q 2>nul

REM Limpieza de logs y prefetch
del "C:\Windows\logs\cbs\*.log" 2>nul
del "C:\Windows\Logs\MoSetup\*.log" 2>nul
del "C:\Windows\Panther\*.log" /s /q 2>nul
del "C:\Windows\inf\*.log" /s /q 2>nul
del "C:\Windows\logs\*.log" /s /q 2>nul
del "C:\Windows\SoftwareDistribution\*.log" /s /q 2>nul
del "C:\Windows\Microsoft.NET\*.log" /s /q 2>nul
rd /s /q "C:\WINDOWS\Prefetch" 2>nul
md "C:\WINDOWS\Prefetch" 2>nul

REM Limpiar otras temporales heredadas
DEL /F /S /Q "%HOMEPATH%\Config~1\Temp\*.*" 2>nul
RD /S /Q "%HOMEPATH%\Config~1\Temp" 2>nul
MD "%HOMEPATH%\Config~1\Temp" 2>nul

REM ============================
REM === LIMPIEZA DE NAVEGADORES
REM ============================

REM EDGE
taskkill /F /IM "msedge.exe" 2>nul
for %%P in (Default "Profile 1" "Profile 2") do (
    del "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\Cache\*" /q 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\Service Worker\Database" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\Service Worker\CacheStorage" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\Service Worker\ScriptCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\GPUCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\%%P\Storage\ext" 2>nul
)
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\GrShaderCache\GPUCache" 2>nul
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\ShaderCache\GPUCache" 2>nul

REM FIREFOX
taskkill /F /IM "firefox.exe" 2>nul
set "parentfolder=C:\Users\%USERNAME%\AppData\Local\Mozilla\Firefox\Profiles"
for /d %%a in ("%parentfolder%\*.default-release") do (
    del "%%a\cache2\entries\*" /q 2>nul
    del "%%a\startupCache\*.bin" /q 2>nul
    del "%%a\startupCache\*.lz*" /q 2>nul
    del "%%a\cache2\index*.*" /q 2>nul
    del "%%a\startupCache\*.little" /q 2>nul
    del "%%a\cache2\*.log" /s /q 2>nul
)

REM VIVALDI
taskkill /F /IM "vivaldi.exe" 2>nul
for %%P in (Default "Profile 1" "Profile 2") do (
    del "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\Cache\*" /q 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\Service Worker\Database" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\Service Worker\CacheStorage" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\Service Worker\ScriptCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\GPUCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\%%P\Storage\ext" 2>nul
)
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\GrShaderCache\GPUCache" 2>nul
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Vivaldi\User Data\ShaderCache\GPUCache" 2>nul

REM BRAVE
taskkill /F /IM "brave.exe" 2>nul
for %%P in (Default "Profile 1" "Profile 2") do (
    del "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\Cache\*" /q 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\Service Worker\Database" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\Service Worker\CacheStorage" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\Service Worker\ScriptCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\GPUCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\%%P\Storage\ext" 2>nul
)
rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\GrShaderCache\GPUCache" 2>nul
rd /s /q "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\ShaderCache\GPUCache" 2>nul

REM CHROME
taskkill /F /IM "chrome.exe" 2>nul
for %%P in (Default "Profile 1" "Profile 2") do (
    del "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\Cache\*" /q 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\Service Worker\Database" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\Service Worker\CacheStorage" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\Service Worker\ScriptCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\GPUCache" 2>nul
    rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\%%P\Storage\ext" 2>nul
)
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\GrShaderCache\GPUCache" 2>nul
rd /s /q "C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\ShaderCache\GPUCache" 2>nul

REM =======================
REM === DESCARGAS DEFAULT (MODIFICADO)
REM =======================
echo Limpiando carpeta Descargas del usuario actual...
del /s /f /q "%USERPROFILE%\Downloads\*.*" 2>nul
rd /s /q "%USERPROFILE%\Downloads" 2>nul
md "%USERPROFILE%\Downloads" 2>nul
echo Carpeta Descargas limpia.

REM ============================
REM === BORRADO DE EVENT LOGS
REM ============================
for /F "tokens=*" %%G in ('wevtutil.exe el') do (
    call :do_clear "%%G"
)
echo.
echo Todos los registros de eventos han sido limpiados.
goto theEnd

:do_clear
echo Limpiando %1
wevtutil.exe cl %1 2>nul
goto :eof

:theEnd
exit
