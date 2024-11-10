@echo off
title PC Optimization Tool
setlocal

:: Set the Command Prompt window size to 80 columns and 25 lines
mode con: cols=90 lines=25

:: Request administrative privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% NEQ 0 (
    call :SetTitle "Requesting administrative privileges"
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Menu Section
:menu
cls
call :SetTitle PC Optimization Tool

set "choice="  :: Clear the choice variable to prevent re-use of the previous choice

type menu.txt

set /p choice="-->"

if "%choice%"=="0" goto credits
if "%choice%"=="1" goto clear_optimization
if "%choice%"=="2" goto clear_store
if "%choice%"=="3" goto clear_update_cache
if "%choice%"=="4" goto clear_logfiles
if "%choice%"=="5" goto clear_memorydump
if "%choice%"=="6" goto clear_temp
if "%choice%"=="7" goto clear_prefetch
if "%choice%"=="8" goto free_ram
if "%choice%"=="9" goto clear_shader
if "%choice%"=="10" goto browser_cache_menu
if "%choice%"=="11" goto clear_dns
if "%choice%"=="12" goto disable_startup
if "%choice%"=="13" goto disable_services
if "%choice%"=="14" goto disable_visual_effects
if "%choice%"=="15" goto defrag
if "%choice%"=="16" goto run_all
if "%choice%"=="17" goto restart_explorer
if "%choice%"=="18" goto high_performance
if "%choice%"=="19" goto display_specs
if "%choice%"=="20" goto enable_ultimate
if "%choice%"=="21" goto clear_recycling_bin
if "%choice%"=="22" goto Game_mode
if "%choice%"=="23" exit

echo Invalid choice, please try again.
pause
goto menu

:: Function to display PC Specifications
:display_specs
cls
call :SetTitle "Scanning PC Specifications"
echo ================================
echo       PC Specifications
echo ================================
echo.

:: Operating System
echo [Operating System]   
systeminfo | findstr /C:"OS"

:: Processor
echo [Processor]   
wmic cpu get caption

:: Total RAM
echo [Total RAM]   
wmic memorychip get capacity

:: Total Physical Memory in GB
echo [Total Physical Memory]   
set /a totalram=0
for /f "tokens=*" %%a in ('wmic computersystem get TotalPhysicalMemory /value') do set %%a
set /a totalram=%TotalPhysicalMemory:~0,-3%
set /a totalramGB=%totalram% / 1024 / 1024 / 1024
echo %totalramGB% GB

:: Graphics Card (GPU)
echo [Graphics Card (GPU)]   
wmic path win32_videocontroller get caption

:: Manufacturer
echo [Manufacturer]   
wmic computersystem get manufacturer

:: Model
echo [Model]   
wmic computersystem get model

:: Disk Drives
echo [Disk Drives]   
wmic diskdrive get model, size

:: Network Adapter
echo [Network Adapter]   
wmic nic get name

echo ================================
pause
goto menu

:: Function to clear the recycling bin
:clear_recycling_bin
call :SetTitle "Clearing Recycling Bin"
echo Emptying the Recycling Bin...
rd /s /q C:\$Recycle.Bin
if %errorlevel% == 0 (
    call :SetSuccess "Recycling Bin emptied."
) else (
    call :SetError "Failed to empty the Recycling Bin."
)
pause
goto menu

:clear_temp
call :SetTitle "Clearing Temporary Files"
echo Deleting temporary files...

:: Ensure %temp% resolves and directory exists
if exist "%temp%\*" (
    del /q /f /s "%temp%\*"
    if %errorlevel% == 0 (
        call :SetSuccess "Temporary files cleared."
    ) else (
        call :SetError "Some temporary files could not be deleted. Try closing applications and run again."
    )
) else (
    call :SetSuccess "No temporary files to clear."
)
pause
goto menu


:browser_cache_menu
cls
call :SetTitle "Clearing Browser Cache"
echo Select the browser cache to clear:
echo 1. Google Chrome
echo 2. Mozilla Firefox
echo 3. Opera GX
echo 4. Brave
echo 5. Microsoft Edge
echo 6. Return to Main Menu
echo.
set /p browserchoice="Enter your choice (1-6): "
echo.

if "%browserchoice%"=="1" goto clear_chrome
if "%browserchoice%"=="2" goto clear_firefox
if "%browserchoice%"=="3" goto clear_opera
if "%browserchoice%"=="4" goto clear_brave
if "%browserchoice%"=="5" goto clear_edge
if "%browserchoice%"=="6" goto menu

echo Invalid choice
pause
goto browser_cache_menu

:clear_chrome
call :SetTitle "Clearing Google Chrome Cache"
del /q /f /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*"
if %errorlevel% == 0 (
    call :SetSuccess "Google Chrome cache cleared."
) else (
    call :SetError "Failed to clear Google Chrome cache."
)
pause
goto menu

:clear_firefox
call :SetTitle "Clearing Mozilla Firefox Cache"
del /q /f /s "%LocalAppData%\Mozilla\Firefox\Profiles\*\cache2\*"
if %errorlevel% == 0 (
    call :SetSuccess "Mozilla Firefox cache cleared."
) else (
    call :SetError "Failed to clear Mozilla Firefox cache."
)
pause
goto menu

:clear_opera
call :SetTitle "Clearing Opera GX Cache"
del /q /f /s "%AppData%\Opera Software\Opera GX Stable\Cache\*"
if %errorlevel% == 0 (
    call :SetSuccess "Opera GX cache cleared."
) else (
    call :SetError "Failed to clear Opera GX cache."
)
pause
goto menu

:clear_brave
call :SetTitle "Clearing Brave Cache"
del /q /f /s "%LocalAppData%\BraveSoftware\Brave-Browser\User Data\Default\Cache\*"
if %errorlevel% == 0 (
    call :SetSuccess "Brave cache cleared."
) else (
    call :SetError "Failed to clear Brave cache."
)
pause
goto menu

:clear_edge
call :SetTitle "Clearing Microsoft Edge Cache"
del /q /f /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*"
if %errorlevel% == 0 (
    call :SetSuccess "Microsoft Edge cache cleared."
) else (
    call :SetError "Failed to clear Microsoft Edge cache."
)
pause
goto menu

:clear_dns
call :SetTitle "Clearing DNS Cache"
echo Clearing DNS Cache...
ipconfig /flushdns
if %errorlevel% == 0 (
    call :SetSuccess "DNS Cache cleared."
) else (
    call :SetError "Failed to clear DNS Cache."
)
pause
goto menu

:disable_startup
call :SetTitle "Disabling Startup Programs"
echo Disabling Unnecessary Startup Programs...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "UnnecessaryProgram" /f 2>nul
if %errorlevel% == 0 (
    call :SetSuccess "Startup programs disabled."
) else (
    call :SetError "Failed to disable startup programs."
)
pause
goto menu

:disable_services
call :SetTitle "Disabling Unnecessary Services"
echo Disabling Unnecessary Services...
net stop "wuauserv" 2>nul
net stop "SysMain" 2>nul
net stop "DiagTrack" 2>nul
if %errorlevel% == 0 (
    call :SetSuccess "Unnecessary services stopped."
) else (
    call :SetError "Failed to stop unnecessary services."
)
pause
goto menu

:clear_update_cache
call :SetTitle "Clearing Windows Update Cache"
net stop wuauserv
del /q /f /s %windir%\SoftwareDistribution\Download\*
net start wuauserv
if %errorlevel% == 0 (
    call :SetSuccess "Windows Update cache cleared."
) else (
    call :SetError "Failed to clear Windows Update cache."
)
pause
goto menu

:clear_prefetch
call :SetTitle "Clearing Prefetch Files"
if exist %windir%\Prefetch\ (
    del /q /f /s %windir%\Prefetch\*
    call :SetSuccess "Prefetch files cleared."
) else (
    call :SetError "Prefetch directory not found or empty."
)
pause
goto menu

:high_performance
call :SetTitle "Setting High-Performance Power Plan"
powercfg -setactive SCHEME_MIN
if %errorlevel% == 0 (
    call :SetSuccess "High-Performance Power Plan set."
) else (
    call :SetError "Failed to set High-Performance Power Plan."
)
pause
goto menu

:free_ram
call :SetTitle "Freeing Up RAM"
PowerShell -Command "Clear-Content -Path $env:temp\* -ErrorAction SilentlyContinue"
if %errorlevel% == 0 (
    call :SetSuccess "RAM freed."
) else (
    call :SetError "Failed to free up RAM."
)
pause
goto menu

:disable_visual_effects
call :SetTitle "Disabling Visual Effects"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
if %errorlevel% == 0 (
    call :SetSuccess "Visual Effects Disabled."
) else (
    call :SetError "Failed to disable visual effects."
)
pause
goto menu

:defrag
call :SetTitle "Defragmenting Hard Drive"
defrag C: /O
if %errorlevel% == 0 (
    call :SetSuccess "Disk Defragmentation complete."
) else (
    call :SetError "Failed to defragment hard drive."
)
pause
goto menu

:restart_explorer
call :SetTitle "Restarting Windows Explorer"
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe
start explorer.exe
if %errorlevel% == 0 (
    call :SetSuccess "Windows Explorer restarted."
) else (
    call :SetError "Failed to restart Windows Explorer."
)
pause
goto menu

:clear_store
call :SetTitle "Clearing Windows Store Cache"
wsreset
if %errorlevel% == 0 (
    call :SetSuccess "Windows Store cache cleared."
) else (
    call :SetError "Failed to clear Windows Store cache."
)
pause
goto menu

:clear_logfiles
call :SetTitle "Clearing Windows Log Files"
del /q /f /s %windir%\Logs\*
if %errorlevel% == 0 (
    call :SetSuccess "Windows log files cleared."
) else (
    call :SetError "Failed to clear Windows log files."
)
pause
goto menu

:clear_memorydump
call :SetTitle "Clearing Memory Dump Files"
if exist %windir%\Minidump\ (
    del /q /f /s %windir%\Minidump\*
    call :SetSuccess "Memory dump files cleared."
) else (
    call :SetError "Memory dump files directory not found or empty."
)
pause
goto menu

:clear_optimization
call :SetTitle "Clearing Windows Delivery Optimization Files"
net stop dosvc
del /q /f /s %windir%\SoftwareDistribution\DeliveryOptimization\*
net start dosvc
if %errorlevel% == 0 (
    call :SetSuccess "Windows Delivery Optimization files cleared."
) else (
    call :SetError "Failed to clear Delivery Optimization files."
)
pause
goto menu

:clear_shader
call :SetTitle "Clearing DirectX Shader Cache"
del /q /f /s "%LocalAppData%\D3DSCache\*"
if %errorlevel% == 0 (
    call :SetSuccess "DirectX Shader Cache cleared."
) else (
    call :SetError "Failed to clear DirectX Shader Cache."
)
pause
goto menu

:enable_ultimate
call :SetTitle "Enabling Ultimate Performance Power Plan"
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
if %errorlevel% == 0 (
    call :SetSuccess "Ultimate Performance Power Plan enabled."
) else (
    call :SetError "Failed to enable Ultimate Performance Power Plan."
)
pause
goto menu

:Game_mode

echo Enabling Game Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f

echo Game Mode has been enabled. Please restart your computer for changes to take effect.
pause


:: Function to display Credits
:credits
cls
call :SetTitle "Credits"
echo =========================================================================================
echo                      Thank you for using the PC Optimization Tool!
echo.
echo                        GitHub: https://github.com/St1tchedd
echo                               Discord: St1tched.
echo                       YouTube: https://www.youtube.com/@SSt1tched
echo =========================================================================================
pause
goto menu

:run_all
call :SetTitle "Running All Optimizations"
echo Running all optimizations sequentially...

call :clear_temp
call :clear_dns
call :disable_startup
call :disable_services
call :clear_update_cache
call :clear_prefetch
call :high_performance
call :free_ram
call :disable_visual_effects
call :defrag
call :restart_explorer
call :clear_store
call :clear_logfiles
call :clear_memorydump
call :clear_optimization
call :clear_shader
call :enable_ultimate
call :clear_recycling_bin

call :SetSuccess "All optimizations completed!"
pause
goto menu

:: Functions for coloring and setting dynamic title
:SetError
color 0C
echo %1
pause
goto menu

:SetSuccess
color 0A
echo %1
pause
goto menu

:SetTitle
title %1
goto :eof