@echo off
setlocal

:: ============================================================================
:: PairCodeMoonlight.cmd
:: - No questions for host/port or credentials.
:: - Only asks for the Moonlight PIN code.
:: - Uses the same credentials as AutoSetup.cmd.
:: ============================================================================

:: ----- Fixed settings (must match AutoSetup.cmd) -----
set "HOST=localhost"
set "PORT=47990"
set "SUN_USER=user"
set "SUN_PASS=pass"

echo === Pair Moonlight with Sunshine ===
echo Host : https://%HOST%:%PORT%
echo User : %SUN_USER%
echo.

set /p PIN=Enter Moonlight PIN (4-8 digits): 
set /p DEVNAME=Device name: 

if "%PIN%"=="" (
  echo PIN cannot be empty.
  echo Press any key to exit...
  pause >nul
  exit /b 1
)

echo Sending PIN ...
curl -s -k -u "%SUN_USER%:%SUN_PASS%" -H "Content-Type: application/json" ^
  -d "{\"pin\":\"%PIN%\",\"name\":\"%DEVNAME%\"}" https://%HOST%:%PORT%/api/pin >nul

if errorlevel 1 (
  echo Pairing failed. Make sure Sunshine is running and the PIN is still visible in Moonlight.
) else (
  echo PIN sent. Pairing should complete on your Moonlight device.
)

echo.
echo Press any key to close...
pause >nul
exit /b 0

