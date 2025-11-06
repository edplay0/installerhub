@echo off
setlocal enabledelayedexpansion

set "SUN_USER=user"
set "SUN_PASS=pass"
set "HOST=localhost"
set "PORT=47990"
set "FORCE_UPNP=Y"
set "WALLPAPER=C:\Windows\Web\Wallpaper\Windows\img19.jpg"

:: ----- Admin check -----
net session >nul 2>&1
if not %errorlevel%==0 (
  echo Please run this script as Administrator.
  echo Press any key to exit...
  pause >nul
  exit /b 1
)

:: ----- Paths / URLs -----
set "DL=%USERPROFILE%\Downloads"
set "URL=https://github.com/LizardByte/Sunshine/releases/latest/download/Sunshine-Windows-AMD64-installer.exe"
set "INSTALLER=%DL%\Sunshine-Windows-AMD64-installer.exe"
set "INSTALLDIR=%ProgramFiles%\Sunshine"
set "SUN_EXE=%INSTALLDIR%\sunshine.exe"

echo.
echo Credentials    : %SUN_USER% / %SUN_PASS%
echo Web UI (LAN)   : https://%HOST%:%PORT%
echo.

if not exist "%DL%" mkdir "%DL%" >nul 2>&1

:: ----- Download installer (curl first, PowerShell fallback) -----
curl -L --retry 3 --retry-delay 2 -o "%INSTALLER%" "%URL%"
if errorlevel 1 (
  echo curl failed, trying PowerShell fallback...
  powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%INSTALLER%' -UseBasicParsing } catch { exit 1 }"
  if errorlevel 1 (
    echo Download failed. Check your internet connection or the URL.
    echo Press any key to exit...
    pause >nul
    exit /b 1
  )
)

:: ----- Launch interactive installer and WAIT -----
echo.
echo Launching Sunshine installer wizard (this window waits until it closes)...
powershell -NoProfile -Command "Start-Process -FilePath '%INSTALLER%' -Verb RunAs -Wait"
set RET=%ERRORLEVEL%
echo Installer closed (exit code %RET%).

:: ----- Locate sunshine.exe (in case user changed path) -----
if not exist "%SUN_EXE%" (
  for /f "delims=" %%F in ('dir /b /s "%ProgramFiles%\Sunshine\sunshine.exe" 2^>nul') do set "SUN_EXE=%%F"
)
if not exist "%SUN_EXE%" (
  echo Could not find sunshine.exe. Is Sunshine installed?
  goto :cleanup
)

:: ----- Stop Sunshine service if present (best-effort) -----
for /f "usebackq delims=" %%S in (`powershell -NoProfile -Command "(Get-Service ^| ?{ $_.Name -match 'Sunshine' -or $_.DisplayName -match 'Sunshine' } ^| Select -First 1 -Expand Name) 2>$null"`) do set SVC=%%S
if defined SVC sc stop "%SVC%" >nul 2>&1

:: ----- Set Web UI credentials (no prompt) -----
echo Setting Sunshine Web UI credentials...
"%SUN_EXE%" --creds "%SUN_USER%" "%SUN_PASS%"

:: ----- Start service if present -----
if defined SVC sc start "%SVC%" >nul 2>&1

:: ----- Wait for Web UI (up to 120s) -----
call :wait_https https://%HOST%:%PORT%/api/configLocale 120
if errorlevel 1 (
  echo Warning: Sunshine Web UI did not respond yet. Continuing anyway...
)

:: ----- Enable UPnP automatically -----
if /I "%FORCE_UPNP%"=="Y" (
  echo Enabling UPnP...
  curl -s -k -u "%SUN_USER%:%SUN_PASS%" -H "Content-Type: application/json" ^
    -d "{\"upnp\":\"enabled\"}" https://%HOST%:%PORT%/api/config >nul 2>&1
  curl -s -k -u "%SUN_USER%:%SUN_PASS%" -X POST https://%HOST%:%PORT%/api/restart >nul 2>&1
  timeout /t 3 >nul
)

:: ----- Open firewall ports (idempotent) -----
echo Adding firewall rules...
netsh advfirewall firewall add rule name="Sunshine TCP 47984" dir=in action=allow protocol=TCP localport=47984 >nul
netsh advfirewall firewall add rule name="Sunshine TCP 47989" dir=in action=allow protocol=TCP localport=47989 >nul
netsh advfirewall firewall add rule name="Sunshine TCP 47990" dir=in action=allow protocol=TCP localport=47990 >nul
netsh advfirewall firewall add rule name="Sunshine UDP 47998-48000" dir=in action=allow protocol=UDP localport=47998-48000 >nul
netsh advfirewall firewall add rule name="Sunshine UDP 48010" dir=in action=allow protocol=UDP localport=48010 >nul

:: ----- Set fixed Windows wallpaper -----
if exist "%WALLPAPER%" (
  reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%WALLPAPER%" /f >nul
  reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 10 /f >nul
  reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d 0 /f >nul
  RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
) else (
)

:cleanup
:: ----- Delete installer and finish -----
if exist "%INSTALLER%" del /f /q "%INSTALLER%"
echo.
echo ========================================
echo Sunshine is ready.
echo Web UI: https://%HOST%:%PORT%
echo Username: %SUN_USER%
echo Password: %SUN_PASS%
echo ========================================
echo.
echo Press any key to close...
pause >nul
exit /b 0

:wait_https
:: %1 = URL, %2 = timeout seconds. Returns 0 if reachable, 1 on timeout.
set URL=%1
set T=%2
set /a i=0
:wait_loop
curl -s -k "%URL%" >nul 2>&1 && (exit /b 0)
set /a i+=1
if %i% GEQ %T% (exit /b 1)
timeout /t 1 >nul
goto :wait_loop

