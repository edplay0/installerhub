@echo off
chcp 65001 >nul
title Windows Activator
color 0a

:start
cls
echo ====================================================
echo                 WINDOWS ACTIVATOR
echo ====================================================
echo.
echo Select an option:
echo.
echo [1] Windows 10 Pro
echo [2] Windows 10 Home
echo [3] Windows 10 Enterprise
echo [4] Windows 11 Pro
echo [5] Windows 11 Home
echo [6] Windows 11 Enterprise
echo [7] Check activation status
echo [0] Exit
echo.
set /p choice="Enter the corresponding number: "

if "%choice%"=="1" goto win10pro
if "%choice%"=="2" goto win10home
if "%choice%"=="3" goto win10ent
if "%choice%"=="4" goto win11pro
if "%choice%"=="5" goto win11home
if "%choice%"=="6" goto win11ent
if "%choice%"=="7" goto checkstatus
if "%choice%"=="0" exit

goto start

:checkstatus
cls
echo ====================================================
echo              CHECK ACTIVATION STATUS
echo ====================================================
echo.
echo Current activation status:
echo.
slmgr /xpr
echo.
echo Detailed license information:
echo.
slmgr /dli
echo.
echo Press any key to return to main menu...
pause >nul
goto start

:win10pro
cls
echo Activating Windows 10 Pro...
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 10 Pro activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:win10home
cls
echo Activating Windows 10 Home...
slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 10 Home activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:win10ent
cls
echo Activating Windows 10 Enterprise...
slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 10 Enterprise activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:win11pro
cls
echo Activating Windows 11 Pro...
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 11 Pro activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:win11home
cls
echo Activating Windows 11 Home...
slmgr /ipk YTMG3-N6DKC-DKB77-7M9GH-8HVX7
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 11 Home activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:win11ent
cls
echo Activating Windows 11 Enterprise...
slmgr /ipk XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
slmgr /skms kms8.msguides.com
slmgr /ato
echo.
echo Windows 11 Enterprise activation completed.
echo Checking activation status...
echo.
slmgr /xpr
echo.
call :afterActivation
goto start

:afterActivation
echo.
echo What would you like to do?
echo [1] Return to main menu
echo [0] Exit
echo.
set /p afterchoice="Enter your choice (0 or 1): "
if "%afterchoice%"=="0" exit
goto :eof

:checkstatus
cls
echo ====================================================
echo              CHECK ACTIVATION STATUS
echo ====================================================
echo.
echo Current activation status:
echo.
slmgr /xpr
echo.
echo Detailed license information:
echo.
slmgr /dli
echo.
echo Press any key to return to main menu...
pause >nul
goto start
