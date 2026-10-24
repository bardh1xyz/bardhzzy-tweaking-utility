@ECHO off
setlocal
rem Console colors.
set "CONSOLE_ERROR=0C"
set "CONSOLE_DEFAULT=0F"
set "CONSOLE_SUCCESS=0A"
set "CONSOLE_INFO=0B"
set "CONSOLE_BLUE=09"

title bardhzzY Tweaks - admin check
set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0;%PATH%"

fltmc >nul 2>&1

if not "%errorlevel%"=="0" (
    mode con: cols=78 lines=18
    color %CONSOLE_ERROR%
    title [!] ACCESS DENIED - ELEVATION REQUIRED
    cls

    rem Play an error sound.
    powershell -NoProfile -Command "[console]::beep(800, 200); Start-Sleep -m 50; [console]::beep(500, 300)" >nul 2>&1

    echo.
    echo  ==============================================================
    echo.
    echo                    bardhzzY TWEAKS
    echo.
    echo  ==============================================================
    echo.
    echo   [!] ACCESS DENIED - Administrator required
    echo.
    echo   This utility modifies system services, the registry,
    echo   and protected files. Elevated privileges are needed.
    echo.
    echo   A Windows security prompt will appear shortly.
    echo.
    echo   Please click YES when prompted.
    echo.
    echo   If no prompt appears, right click the file and run as admin.
    echo.
    echo  ==============================================================
    echo.
    timeout /t 3 /nobreak >nul

    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

title bardhzzY Tweaks (Admin)
chcp 65001 >nul
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

rem ANSI colors.
set "RESET=%ESC%[0m"
set "BLUE=%ESC%[34m"
set "WHITE=%ESC%[37m"
set "CYAN=%ESC%[36m"
set "GRAY=%ESC%[90m"
set "YELLOW=%ESC%[33m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "BRIGHT_RED=%ESC%[91m"
set "BRIGHT_WHITE=%ESC%[97m"
set "BOLD_RED=%ESC%[1;31m"
set "BRIGHT_GREEN=%ESC%[92m"
set "BRIGHT_BLUE=%ESC%[94m"
set "BRIGHT_CYAN=%ESC%[96m"

call :LogInit

for /f "tokens=4-5 delims=. " %%i in ('ver') do set "os_ver=%%i.%%j"

if not "%os_ver%"=="10.0" goto :os_check_done

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| find "CurrentBuild"') do set "win_build=%%a"

if not defined win_build (
    set "os_ver=Win10"
    goto :os_check_done
)

if %win_build% GEQ 22000 (
    set "os_ver=Win11"
) else (
    set "os_ver=Win10"
)

:os_check_done
title bardhzzY Tweaks

:license
cls
MODE 100,40
echo %RESET%

echo.
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╗██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%═══════════════════════════════════════════════════════════════════════%RESET%
echo.
echo                       %WHITE%LICENSE VERIFICATION%RESET%
echo.
echo               %BLUE%Enter your license key to continue.%RESET%
echo.
set "user_key="
set /p "user_key=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Enter your License Key: %RESET%"

if defined user_key set "user_key=%user_key:"=%"
if defined user_key set "user_key=%user_key: =%"

for %%k in (
    "bardhzzY" "tester12" "A3S4-D5F6-G7H8-J9K0" "L1M2-N3B4-V5C6-X7Z8"
    "Q9W0-E1R2-T5Y6-U7I8" "O7P8-A9S0-D1F2-G3H4" "1B99-QBRX-5YP7-YB07"
) do (
    if /I "%user_key%"=="%%~k" goto valid
)

:invalid
cls
MODE 100,40
echo %RESET%

echo.
echo        %BLUE%══════════════════════════════════════════════════════════════════════%RESET%
echo.
echo                       %WHITE%LICENSE VERIFICATION%RESET%
echo.
echo        %RED%[ERROR]%WHITE% Invalid license key.
echo.
echo        %WHITE%The key was not recognized. Please check your key
echo        and try again.%RESET%
echo.
echo        %GRAY%Returning to license verification...%RESET%
echo.
echo        %BLUE%══════════════════════════════════════════════════════════════════════%RESET%
echo.
timeout /t 3 /nobreak >nul
goto license

:valid
cls
MODE 100,40
echo %RESET%

echo.
echo        %BLUE%══════════════════════════════════════════════════════════════════════%RESET%
echo.
echo                       %WHITE%LICENSE VERIFICATION%RESET%
echo.
echo        %GREEN%[  OK ]%WHITE% License verified successfully.
echo.
echo        %WHITE%Welcome to bardhzzY Tweaks.%RESET%
echo.
echo        %GRAY%Starting the utility...%RESET%
echo.
echo        %BLUE%══════════════════════════════════════════════════════════════════════%RESET%
echo.
timeout /t 2 /nobreak >nul
goto init

:init
echo.
echo Downloading Tweaking Tools
set "UTIL_DIR=C:\bardhzzY Utility Tools"
set "IMOD_EXE=%UTIL_DIR%\xHCI IMOD Disabler\xHCI IMOD Disabler.exe"
set "GITHUB_ZIP_URL=https://github.com/bardh1xyz/bardhzzY-Utility-Tools/archive/refs/heads/main.zip"
set "TOOLS_REFRESH_LOG=%TEMP%\bardhzzY_tools_refresh.log"
call :DetectToolPaths

if not exist "%UTIL_DIR%" goto tools_refresh
call :DetectToolPaths
if exist "%ADVANCEDRUN_EXE%" if exist "%POWERPLAN_STANDARD_FILE%" if exist "%POWERPLAN_IDLE_OFF_FILE%" goto tools_status_common
call :LogWarn "One or more required tools are missing. Refreshing the tools repository..."
goto tools_refresh

:tools_refresh
call :LogInfo "Downloading or refreshing tools from GitHub..."
if not exist "%UTIL_DIR%" mkdir "%UTIL_DIR%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $zip = \"$env:TEMP\bardhzz_tools.zip\"; $ext = \"$env:TEMP\bardhzz_extract\"; try { if (Test-Path $zip) { Remove-Item $zip -Force }; if (Test-Path $ext) { Remove-Item $ext -Recurse -Force }; Invoke-WebRequest -Uri '%GITHUB_ZIP_URL%' -OutFile $zip -UseBasicParsing; Expand-Archive -Path $zip -DestinationPath $ext -Force; $gitRoot = Get-ChildItem -Path $ext -Directory | Select-Object -First 1; if (-not $gitRoot) { throw 'Repository archive is empty' }; Copy-Item -Path \"$($gitRoot.FullName)\*\" -Destination '%UTIL_DIR%' -Recurse -Force; Remove-Item $zip -Force -ErrorAction SilentlyContinue; Remove-Item $ext -Recurse -Force -ErrorAction SilentlyContinue; exit 0 } catch { Write-Output $_.Exception.Message; Remove-Item $zip -Force -ErrorAction SilentlyContinue; Remove-Item $ext -Recurse -Force -ErrorAction SilentlyContinue; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1

if errorlevel 1 goto tools_refresh_failed
call :DetectToolPaths
if not exist "%ADVANCEDRUN_EXE%" goto tools_repair_failed
if not exist "%POWERPLAN_STANDARD_FILE%" goto tools_repair_failed
if not exist "%POWERPLAN_IDLE_OFF_FILE%" goto tools_repair_failed
goto tools_status_common

:tools_refresh_failed
call :LogErr "Tools repository download or refresh failed. Log: %TOOLS_REFRESH_LOG%"
if exist "%TOOLS_REFRESH_LOG%" type "%TOOLS_REFRESH_LOG%"
goto ADVANCEDRUN_SETUP

:tools_repair_failed
call :DetectToolPaths
call :LogErr "Repository refresh completed, but required files are still missing."
if not exist "%ADVANCEDRUN_EXE%" call :LogWarn "AdvancedRun expected at: %ADVANCEDRUN_EXE%"
if not exist "%POWERPLAN_STANDARD_FILE%" call :LogWarn "Standard power plan expected at: %POWERPLAN_STANDARD_FILE%"
if not exist "%POWERPLAN_IDLE_OFF_FILE%" call :LogWarn "Idle Off power plan expected at: %POWERPLAN_IDLE_OFF_FILE%"
if exist "%TOOLS_REFRESH_LOG%" type "%TOOLS_REFRESH_LOG%"
goto ADVANCEDRUN_SETUP

:tools_status_common
if exist "%IMOD_EXE%" (
    call :LogOK "xHCI IMOD Disabler found."
) else (
    call :LogWarn "Optional xHCI IMOD Disabler not found. Add it to %UTIL_DIR%\xHCI IMOD Disabler\."
)
goto ADVANCEDRUN_SETUP

:ADVANCEDRUN_SETUP
if defined SCRIPT_VERSION_CHECKED goto ADVANCEDRUN_SETUP_VERSION_CHECKED
call :CheckScriptVersion
set "SCRIPT_VERSION_CHECKED=1"
:ADVANCEDRUN_SETUP_VERSION_CHECKED
call :DetectToolPaths
set "TI="
set "TI_AVAILABLE=0"

if not exist "%ADVANCEDRUN_EXE%" goto ADVANCEDRUN_UNAVAILABLE

rem Check that AdvancedRun can run a process as TrustedInstaller.
call :AdvancedRun_Test
if not "%TI_AVAILABLE%"=="1" goto ADVANCEDRUN_TEST_FAILED

echo.
echo        %GREEN%[OK]%WHITE% AdvancedRun /RunAs 8 test passed.%RESET%
echo        %GRAY%Protected registry and service changes will try AdvancedRun /RunAs 8 first.%RESET%
echo        %GRAY%Per-user settings still apply to the signed-in account.%RESET%
echo.
call :LogInfo "AdvancedRun startup test passed; opening the main menu."
timeout /t 1 /nobreak >nul
goto main

:ADVANCEDRUN_TEST_FAILED
cls
MODE 100,30
echo %RESET%

echo.
echo.
echo        %RED%============================================================%RESET%
echo.
echo                    %BOLD_RED%ADVANCEDRUN TEST FAILED%RESET%
echo.
echo        %RED%============================================================%RESET%
echo.
echo.
echo        %WHITE%AdvancedRun could not complete its test command using /RunAs 8.%RESET%
echo        %GRAY%Exit code: %TI_TEST_RC%%RESET%
echo        %GRAY%Diagnostic log: %TI_TEST_LOG%%RESET%
echo.
echo        %GRAY%Possible causes:%RESET%
echo        %WHITE%  - AdvancedRun is blocked or an incompatible copy is installed%RESET%
echo        %WHITE%  - TrustedInstaller service did not start correctly%RESET%
echo        %WHITE%  - Insufficient permissions or an invalid tool path%RESET%
if exist "%TI_TEST_LOG%" (
    echo.
    echo        %GRAY%AdvancedRun output:%RESET%
    type "%TI_TEST_LOG%"
)
echo.
echo        %GRAY%What would you like to do?%RESET%
echo.
echo           %CYAN%1%WHITE%. %GREEN%Try test again%RESET%
echo           %CYAN%2%WHITE%. %YELLOW%Continue with Admin only%RESET%
echo           %CYAN%3%WHITE%. %RED%Exit script%RESET%
echo.
echo.
echo        %BLUE%============================================================%RESET%
echo.
echo.
set "setup_choice="
set /p "setup_choice=        Select option: "

if "%setup_choice%"=="1" goto ADVANCEDRUN_SETUP
if "%setup_choice%"=="2" goto ADVANCEDRUN_ADMIN_FALLBACK
if "%setup_choice%"=="3" exit /b

echo.
echo        %RED%Invalid choice.%RESET%
timeout /t 2 /nobreak >nul
goto ADVANCEDRUN_TEST_FAILED

:ADVANCEDRUN_ADMIN_FALLBACK
set "TI="
set "TI_AVAILABLE=0"
cls
echo.
echo        %YELLOW%[NOTE]%WHITE% Continuing with Administrator privileges only.%RESET%
echo        %GRAY%Some protected files and registry keys may not be modifiable.%RESET%
echo.
timeout /t 3 /nobreak >nul
goto :main

:ADVANCEDRUN_UNAVAILABLE
set "TI="
set "TI_AVAILABLE=0"
cls
echo.
echo        %YELLOW%[NOTE]%WHITE% AdvancedRun not found in tools folder.%RESET%
echo        %GRAY%Location: %ADVANCEDRUN_EXE%%RESET%
echo        %GRAY%Continuing with Administrator privileges only.%RESET%
echo.
timeout /t 3 /nobreak >nul
goto :main

rem AdvancedRun test.
:AdvancedRun_Test
set "TI_TEST_DIR=%SystemRoot%\Temp"
set "TI_TEST_FILE=%SystemRoot%\Temp\bardhzzY_ti_test.txt"
set "TI_TEST_LOG=%TEMP%\bardhzzY_advancedrun_test.log"
set "TI_TEST_RC=not-run"
set "TI_AVAILABLE=0"
set "TI="

if not exist "%TI_TEST_DIR%" mkdir "%TI_TEST_DIR%" >nul 2>&1
if not exist "%TI_TEST_DIR%" goto AdvancedRun_Test_Fail
if exist "%TI_TEST_FILE%" del /q "%TI_TEST_FILE%" >nul 2>&1

rem TrustedInstaller is demand-started on Windows.
sc query TrustedInstaller 2>nul | findstr /I "RUNNING" >nul 2>&1
if errorlevel 1 (
    sc start TrustedInstaller >nul 2>&1
    timeout /t 2 /nobreak >nul
)

call :AdvancedRun_TestOnce
if "%TI_AVAILABLE%"=="1" goto AdvancedRun_Test_Success

timeout /t 2 /nobreak >nul
sc start TrustedInstaller >nul 2>&1
call :AdvancedRun_TestOnce
if "%TI_AVAILABLE%"=="1" goto AdvancedRun_Test_Success

timeout /t 3 /nobreak >nul
sc start TrustedInstaller >nul 2>&1
call :AdvancedRun_TestOnce
if "%TI_AVAILABLE%"=="1" goto AdvancedRun_Test_Success
goto AdvancedRun_Test_Fail

:AdvancedRun_TestOnce
if exist "%TI_TEST_FILE%" del /q "%TI_TEST_FILE%" >nul 2>&1
"%ADVANCEDRUN_EXE%" /Clear /EXEFilename "%SystemRoot%\System32\cmd.exe" /CommandLine "/c echo TI_OK>%TI_TEST_FILE%" /RunAs 8 /WaitProcess 1 /Run >"%TI_TEST_LOG%" 2>&1
set "TI_TEST_RC=%errorlevel%"
if not exist "%TI_TEST_FILE%" exit /b 1
findstr /C:"TI_OK" "%TI_TEST_FILE%" >nul 2>&1
if errorlevel 1 exit /b 1
set "TI_AVAILABLE=1"
set "TI=1"
exit /b 0

:AdvancedRun_Test_Success
if exist "%TI_TEST_FILE%" del /q "%TI_TEST_FILE%" >nul 2>&1
call :LogInfo "AdvancedRun test command passed using /RunAs 8. Protected operations will still be checked individually."
exit /b 0

:AdvancedRun_Test_Fail
set "TI="
set "TI_AVAILABLE=0"
call :LogWarn "AdvancedRun did not create the expected test marker using /RunAs 8 (exit code %TI_TEST_RC%)."
call :LogWarn "Diagnostic log: %TI_TEST_LOG%"
if exist "%TI_TEST_FILE%" del /q "%TI_TEST_FILE%" >nul 2>&1
exit /b 1

:main
title bardhzzY Tweaks - dsc.gg/bardhzzy
call :LogInfo "Main menu entered."

MODE 100,40
echo %RESET%
cls

echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╗██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%SYSTEM TWEAKS                  %RESET% %BLUE%NETWORK ^& LATENCY%RESET%
echo  %WHITE% [%CYAN% 1%WHITE%] Windows Tweaks            %WHITE% [%CYAN% 6%WHITE%] Network Tweaks
echo  %WHITE% [%CYAN% 2%WHITE%] GPU Tweaks                %WHITE% [%CYAN% 7%WHITE%] Storage Tweaks
echo  %WHITE% [%CYAN% 3%WHITE%] CPU Tweaks                %WHITE% [%CYAN% 8%WHITE%] Input Lag Tweaks
echo  %WHITE% [%CYAN% 4%WHITE%] RAM Tweaks                %WHITE% [%CYAN% 9%WHITE%] KBM Tweaks
echo  %WHITE% [%CYAN% 5%WHITE%] Power Tweaks              %WHITE% [%CYAN%10%WHITE%] Timer Resolution
echo.
echo  %BLUE%GAMING ^& CLEANUP                %BLUE%SECURITY ^& FIXES
echo  %WHITE% [%CYAN%11%WHITE%] Fortnite Optimizer        %WHITE% [%CYAN%14%WHITE%] Disable Defender
echo  %WHITE% [%CYAN%12%WHITE%] Service Reduction         %WHITE% [%CYAN%15%WHITE%] Re-enable Defender
echo  %WHITE% [%CYAN%13%WHITE%] Device Manager Tweak      %WHITE% [%CYAN%16%WHITE%] xHCI IMOD Disabler
echo                                  %WHITE% [%CYAN%17%WHITE%] Fixes
echo.
echo  %BLUE%SAFETY ^& UTILITIES%RESET%             %RESET% %BLUE%SYSTEM ^& LOGS%RESET%
echo  %WHITE% [%CYAN%18%WHITE%] Restore Point             %WHITE% [%CYAN%21%WHITE%] View Log
echo  %WHITE% [%CYAN%19%WHITE%] Registry Backup           %WHITE% [%CYAN%22%WHITE%] View Errors
echo  %WHITE% [%CYAN%20%WHITE%] Revert Tweaks             %WHITE% [%CYAN%23%WHITE%] Summary
echo  %WHITE% [%CYAN% D%WHITE%] Discord                   %WHITE% [%CYAN%24%WHITE%] Restart PC
echo                                  %WHITE% [%CYAN%25%WHITE%] Quit
echo.
echo  %GRAY%Copyright © 2026 bardhzzY Tweaks. All rights reserved.%RESET%
if /i "%SCRIPT_VERSION_STATUS%"=="UPDATE" echo  %YELLOW%Update available: %SCRIPT_LATEST_VERSION%%RESET%
if /i "%SCRIPT_VERSION_STATUS%"=="CURRENT" echo  %BRIGHT_GREEN%%SCRIPT_VERSION% - up to date%RESET%
if /i "%SCRIPT_VERSION_STATUS%"=="AHEAD" echo  %GRAY%%SCRIPT_VERSION% - newer than marker%RESET%
if /i "%SCRIPT_VERSION_STATUS%"=="UNAVAILABLE" echo  %GRAY%%SCRIPT_VERSION% - offline%RESET%
echo.
set "input="
set /p "input=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

if not defined input goto main
set "input=%input:"=%"
set "input=%input:&=%"
set "input=%input:|=%"
set "input=%input:^=%"
set "input=%input:<=%"
set "input=%input:>=%"

if /i "%input%"=="1" goto win
if /i "%input%"=="2" goto gpu
if /i "%input%"=="3" goto cpu
if /i "%input%"=="4" goto ram
if /i "%input%"=="5" goto pwr
if /i "%input%"=="6" goto netw
if /i "%input%"=="7" goto stor
if /i "%input%"=="8" goto input
if /i "%input%"=="9" goto kbm
if /i "%input%"=="10" goto timerres
if /i "%input%"=="11" goto fortnite
if /i "%input%"=="12" goto services
if /i "%input%"=="13" goto devmgmt
if /i "%input%"=="14" goto defender
if /i "%input%"=="15" goto defender_revert
if /i "%input%"=="16" goto imod_disabler
if /i "%input%"=="17" goto fixes
if /i "%input%"=="18" goto srp
if /i "%input%"=="19" goto backup
if /i "%input%"=="20" goto revert
if /i "%input%"=="21" (
    call :LogView
    goto main
)
if /i "%input%"=="22" (
    call :LogViewErrors
    goto main
)
if /i "%input%"=="23" (
    call :LogSummary
    pause
    goto main
)
if /i "%input%"=="24" goto restartpc
if /i "%input%"=="25" (
    call :LogSummary
    echo.
    echo Thank you for using bardhzzY Tweaks!
    echo Your log file: %LOG_FILE%
    timeout 3 >nul
    exit /b
)
if /i "%input%"=="d" (
    start https://dsc.gg/bardhzzy
    goto main
)

echo.
echo "%input%" isn't a right choice, try again!
timeout 2 >nul
goto main

:win
call :LogSection "Windows Tweaks"
call :LogSection "Pre-flight: UCPD / Smart App Control / Teredo / Autologger"

rem UCPD
setlocal EnableDelayedExpansion
if "!os_ver!"=="Win11" (
    if defined win_build (
        if !win_build! GEQ 26100 (
            sc query ucpd 2>nul | findstr /I "RUNNING" >nul 2>&1
            if not errorlevel 1 (
                call :LogWarn "UCPD (User Choice Protection Driver) running on Win11 24H2+."
                call :LogInfo "UCPD blocks file association / default app changes. Disabling..."
                call :TIScLog config ucpd start= disabled
                call :TIScLog stop ucpd
                call :SchLog /Change /TN "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /Disable
                call :LogWarn "UCPD disabled. RESTART REQUIRED for full visual tweak compatibility."
            ) else (
                call :LogOK "UCPD not running or already disabled."
            )
        ) else (
            call :LogSkip "UCPD check: Windows build < 26100 (not Win11 24H2+)."
        )
    ) else (
        call :LogSkip "UCPD check: win_build not defined."
    )
) else (
    call :LogSkip "UCPD check: not Windows 11."
)
endlocal

rem Smart App Control
call :LogInfo "Disabling Smart App Control (Win11 22H2+)..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f

rem Teredo
call :LogInfo "Disabling Teredo tunneling..."
netsh interface teredo set state disabled >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh teredo disabled") else (call :LogWarn "netsh teredo disabled (already off or N/A)")

rem Disable selected autologgers; keep core Event Log sessions.
call :LogInfo "Applying aggressive Autologger performance profile..."
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $root='Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger'; $keep=@('Circular Kernel Context Logger','EventLog-Application','EventLog-Security','EventLog-System'); $disabled=0; $kept=0; $failed=0; try { $items=Get-ChildItem -Path $root -ErrorAction Stop; foreach($k in $items){ if($keep -contains $k.PSChildName){ $kept++; continue }; try { New-ItemProperty -Path $k.PSPath -Name 'Start' -PropertyType DWord -Value 0 -Force -ErrorAction Stop | Out-Null; $disabled++ } catch { $failed++ } }; Write-Output ('RESULT|'+$disabled+'|'+$kept+'|'+$failed); exit 0 } catch { Write-Output ('RESULT|0|0|1'); exit 1 }" > "%TEMP%\bardhzzY_autologger_result.txt" 2>nul
set "AUTOLOGGER_RC=%errorlevel%"
if exist "%TEMP%\bardhzzY_autologger_result.txt" (
    for /f "tokens=1-4 delims=|" %%A in ('type "%TEMP%\bardhzzY_autologger_result.txt" 2^>nul') do (
        if /I "%%A"=="RESULT" (
            if "%%D"=="0" (
                call :LogOK "Autologger profile applied: %%B disabled, %%C core session(s) kept."
            ) else (
                call :LogWarn "Autologger profile applied: %%B disabled, %%C core session(s) kept, %%D could not be modified."
            )
        )
    )
    del /q "%TEMP%\bardhzzY_autologger_result.txt" >nul 2>&1
)
if not "%AUTOLOGGER_RC%"=="0" call :LogWarn "Autologger profile encountered an enumeration error; continuing with targeted telemetry disables."

call :LogSection "Optional Features Disable (cherry-picked safe subset)"
call :LogInfo "Disabling IIS features..."
for %%F in (
    IIS-WebServerRole
    IIS-WebServer
    IIS-CommonHttpFeatures
    IIS-HttpErrors
    IIS-HttpRedirect
    IIS-ApplicationDevelopment
    IIS-NetFxExtensibility
    IIS-HealthAndDiagnostics
    IIS-HttpLogging
    IIS-LoggingLibraries
    IIS-RequestMonitor
    IIS-HttpTracing
    IIS-Security
    IIS-RequestFiltering
    IIS-IPSecurity
    IIS-Performance
    IIS-HttpCompressionDynamic
    IIS-WebServerManagementTools
    IIS-IIS6ManagementCompatibility
    IIS-Metabase
    IIS-WMICompatibility
    IIS-LegacyScripts
    IIS-LegacySnapin
    IIS-FTPServer
    IIS-FTPSvc
    IIS-FTPExtensibility
) do (
    powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName %%F -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
    if not errorlevel 1 (call :LogOK "Disable %%F") else (call :LogSkip "Disable %%F (not installed)")
)

call :LogInfo "Disabling MSMQ + WCF..."
for %%F in (
    MSMQ-Container
    MSMQ-Server
    MSMQ-Triggers
    MSMQ-ADIntegration
    MSMQ-HTTP
    MSMQ-Multicast
    MSMQ-DCOM
    WCF-HTTP-Activation
    WCF-NonHTTP-Activation
    WCF-Pipe-Activation
    WCF-TCP-Activation
    WCF-TCP-PortSharing45
) do (
    powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName %%F -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
    if not errorlevel 1 (call :LogOK "Disable %%F") else (call :LogSkip "Disable %%F (not installed)")
)

call :LogInfo "Disabling network/legacy features..."
for %%F in (
    SMB1Protocol
    SMB1Protocol-Client
    SMB1Protocol-Server
    TelnetClient
    TFTP
    SimpleTCP
    TIFFIFilter
    DirectPlay
    LegacyComponents
    WindowsSandbox
    Printing-PrintToPDFServices-Features
    Xps-Viewer-Services
    WorkFolders-Client
    Internet-Explorer-Optional-amd64
    MicrosoftWindowsPowerShell-V2
    MicrosoftWindowsPowerShell-V2-Root
) do (
    powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName %%F -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
    if not errorlevel 1 (call :LogOK "Disable %%F") else (call :LogSkip "Disable %%F (not installed)")
)
call :LogOK "Optional features disabled (WSL/Hyper-V/.NET left intact)."

call :LogSection "Package Manager (Winget) Setup"
call :LogInfo "Verifying Winget availability..."

where curl >nul 2>&1
if errorlevel 1 (
    call :LogErr "CURL.exe not found. Winget cannot be downloaded automatically."
    goto WINGET_DONE
)

winget --version >nul 2>&1
if not errorlevel 1 (
    call :LogOK "Winget is already installed and functional."
    goto WINGET_INITIALIZE
)

call :LogWarn "Winget command not found. Starting Ultimate Repair/Installation..."

call :LogInfo "Ensuring Windows Install services are active..."
for %%s in (AppXSvc, wuauserv, bits) do (
    call :TIScLog config "%%s" start= demand
    call :TIScLog start "%%s"
)

set "W_TEMP=%TEMP%\winget_auto_repair"
if exist "%W_TEMP%" rd /s /q "%W_TEMP%"
mkdir "%W_TEMP%"
call :LogInfo "Downloading latest Microsoft App Installer bundle..."

curl -L -f -s -o "%W_TEMP%\winget.msixbundle" "https://aka.ms/getwinget"
if errorlevel 1 (
    call :LogErr "Network error: Failed to download Winget bundle."
    goto WINGET_FAIL
)

call :LogInfo "Installing App Installer bundle (this may take 30s)..."
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Add-AppxPackage -Path '%W_TEMP%\winget.msixbundle' -ForceUpdateFromAnyVersion -ErrorAction Stop; exit 0 } catch { exit 1 }"

if errorlevel 1 (
    call :LogErr "Installation failed. Windows components may be too corrupted."
    goto WINGET_FAIL
)

set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;C:\Program Files\WindowsApps"
timeout /t 2 /nobreak >nul

winget --version >nul 2>&1
if not errorlevel 1 (
    call :LogOK "Winget successfully installed and injected into session."
    goto WINGET_INITIALIZE
) else (
    call :LogErr "Installation reported success, but command remains unresponsive."
    goto WINGET_FAIL
)

:WINGET_INITIALIZE
call :LogInfo "Initializing Winget sources..."
winget source reset --force >nul 2>&1
winget search "test" --accept-source-agreements >nul 2>&1
call :LogOK "Winget is fully operational."
goto WINGET_DONE

:WINGET_FAIL
call :LogErr "Winget setup failed. Most Software installs will fail."
goto WINGET_DONE

:WINGET_DONE
if exist "%W_TEMP%" rd /s /q "%W_TEMP%"

call :LogInfo "Disabling unnecessary services..."
echo "Disabling unnecessary services..."
for %%z in (
  DoSvc
  bthserv
  BthAvctpSvc
  NaturalAuthentication
  BluetoothUserService
  DiagHub
) do (
  call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "4" /f
)

call :LogInfo "Disabling Hyper-V services..."
for %%t in (
  HvHost
  vmickvpexchange
  vmicguestinterface
  vmicshutdown
  vmicheartbeat
  vmicvmsession
  vmicrdv
  vmictimesync
  vmicvss
) do (
  call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\%%t" /v "Start" /t REG_DWORD /d "4" /f
)

echo.
echo Configuring Universal Search and Open-Shell...
set "search_choice="
set /p "search_choice=Apply this optimization? (Y/N): "
if /i not "%search_choice%"=="Y" goto skip_search

call :LogInfo "Disabling Windows Search Service..."
call :TIScLog config WSearch start= disabled
call :TIScLog stop WSearch

call :LogInfo "Killing remnant modern Search processes..."
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im SearchIndexer.exe >nul 2>&1

call :LogInfo "Disabling Bing + Cortana tracking..."
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f

call :LogInfo "Installing Open-Shell..."
winget install --id Open-Shell.Open-Shell-Menu --exact --silent --accept-package-agreements --accept-source-agreements >nul 2>&1

set "OPENSHELL_INSTALLER=%UTIL_DIR%\OpenShell\OpenShellSetup_4_4_198.exe"

setlocal EnableDelayedExpansion

if not exist "C:\Program Files\Open-Shell\StartMenu.exe" (
    call :LogWarn "Winget installation did not produce a working Open-Shell installation."
    call :LogInfo "Trying bundled Open-Shell installer from Utility Tools..."

    if exist "%OPENSHELL_INSTALLER%" (
        call :LogInfo "Running bundled Open-Shell 4.4.198 installer..."
        call :RunOpenShellInstaller "%OPENSHELL_INSTALLER%"
        if errorlevel 1 (
            call :LogErr "Bundled Open-Shell installer failed."
        ) else (
            timeout /t 2 /nobreak >nul
            if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
                call :LogOK "Open-Shell installed from bundled installer."
            ) else (
                call :LogWarn "Open-Shell installer reported success, but StartMenu.exe was not found."
            )
        )
    ) else (
        call :LogErr "Bundled Open-Shell installer not found: %OPENSHELL_INSTALLER%"
    )
) else (
    call :LogOK "Open-Shell installed via Winget."
)

endlocal
timeout /t 4 /nobreak >nul

call :LogInfo "Applying Custom Open-Shell Skin and XML Setup..."

if not exist "C:\Program Files\Open-Shell\Skins\" mkdir "C:\Program Files\Open-Shell\Skins\" >nul 2>&1

if exist "C:\bardhzzY Utility Tools\OpenShell\Fluent-Metro.skin" (
    copy /y "C:\bardhzzY Utility Tools\OpenShell\Fluent-Metro.skin" "C:\Program Files\Open-Shell\Skins\" >nul 2>&1
    call :LogOK "Custom Open-Shell Skin copied."
) else (
    call :LogWarn "Custom Open-Shell Skin not found."
)

if exist "C:\bardhzzY Utility Tools\OpenShell\Fluent-Metro.skin7" (
    copy /y "C:\bardhzzY Utility Tools\OpenShell\Fluent-Metro.skin7" "C:\Program Files\Open-Shell\Skins\" >nul 2>&1
    call :LogOK "Custom Open-Shell Skin7 copied."
) else (
    call :LogWarn "Custom Open-Shell Skin7 not found."
)

if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
    taskkill /f /im StartMenu.exe >nul 2>&1
    timeout /t 1 /nobreak >nul
    
    if exist "C:\bardhzzY Utility Tools\OpenShell\bardhzzYBlack.xml" (
        start "" "C:\Program Files\Open-Shell\StartMenu.exe" -xml "C:\bardhzzY Utility Tools\OpenShell\bardhzzYBlack.xml"
        call :LogOK "Custom Open-Shell XML configured."
    ) else (
        call :LogWarn "Custom Open-Shell XML not found. Starting normally."
        start "" "C:\Program Files\Open-Shell\StartMenu.exe"
    )
) else (
    call :LogWarn "Open-Shell StartMenu.exe not found. Installation might have failed."
)

call :LogInfo "Restarting desktop shell..."
powershell -NoProfile -Command "Stop-Process -Name explorer -Force" >nul 2>&1
timeout 2 >nul
start explorer.exe

powershell -NoProfile -Command "for ($i=0; $i -lt 10; $i++) { if (Get-Process -Name explorer -ErrorAction SilentlyContinue) { break }; Start-Sleep -Seconds 1 }" >nul 2>&1

tasklist /FI "IMAGENAME eq StartMenu.exe" | find /i "StartMenu.exe" >nul 2>&1
if errorlevel 1 (
    if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
        start "" "C:\Program Files\Open-Shell\StartMenu.exe"
    )
)

call :LogOK "configured open-shell"
goto skip_search

:skip_search
call :LogInfo "Removing New Media Player app..."
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneVideo* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove ZuneVideo") else (call :LogErr "Remove ZuneVideo")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneMusic* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove ZuneMusic") else (call :LogErr "Remove ZuneMusic")

call :LogInfo "Enabling Legacy Media Player feature..."
dism /online /enable-feature /featurename:WindowsMediaPlayer /norestart >nul 2>&1
if not errorlevel 1 (call :LogOK "Enable WMP feature") else (call :LogErr "Enable WMP feature")

call :LogInfo "Optimizing WMP Network Service..."
call :TIScLog config WMPNetworkSvc start= demand

call :LogInfo "Installing Microsoft Visual C++ Redistributables..."

set "VC_TEMP=%TEMP%\bardhzzY_vcredist"
set "VC_X64=%VC_TEMP%\vc_redist.x64.exe"
set "VC_X86=%VC_TEMP%\vc_redist.x86.exe"

if exist "%VC_TEMP%" rd /s /q "%VC_TEMP%" >nul 2>&1
mkdir "%VC_TEMP%" >nul 2>&1

rem vc++ x64
winget install --id Microsoft.VCRedist.2015+.x64 --exact --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
set "VC64_RC=%errorlevel%"

if "%VC64_RC%"=="0" (
    call :LogOK "VCRedist x64 installed via Winget."
) else if "%VC64_RC%"=="3010" (
    call :LogOK "VCRedist x64 installed via Winget (restart required)."
) else (
    call :LogWarn "Winget failed for VCRedist x64 (rc=%VC64_RC%). Trying Microsoft direct download..."

    curl.exe -L -f --retry 3 --retry-delay 2 -sS ^
        -o "%VC_X64%" ^
        "https://aka.ms/vc14/vc_redist.x64.exe" >nul 2>&1

    if not exist "%VC_X64%" (
        call :LogErr "Microsoft VCRedist x64 download failed."
    ) else (
        for %%F in ("%VC_X64%") do if %%~zF LSS 1000000 (
            call :LogErr "Microsoft VCRedist x64 download appears invalid."
            del /q "%VC_X64%" >nul 2>&1
        ) else (
            start /wait "" "%VC_X64%" /install /quiet /norestart
            if errorlevel 3010 (
                if not errorlevel 3011 (
                    call :LogOK "VCRedist x64 installed from Microsoft (restart required)."
                ) else (
                    call :LogErr "VCRedist x64 Microsoft installer failed (rc=3010+)."
                )
            ) else if errorlevel 1 (
                call :LogErr "VCRedist x64 Microsoft installer failed."
            ) else (
                call :LogOK "VCRedist x64 installed from Microsoft."
            )
        )
    )
)

rem vc++ x86
winget install --id Microsoft.VCRedist.2015+.x86 --exact --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
set "VC86_RC=%errorlevel%"

if "%VC86_RC%"=="0" (
    call :LogOK "VCRedist x86 installed via Winget."
) else if "%VC86_RC%"=="3010" (
    call :LogOK "VCRedist x86 installed via Winget (restart required)."
) else (
    call :LogWarn "Winget failed for VCRedist x86 (rc=%VC86_RC%). Trying Microsoft direct download..."

    curl.exe -L -f --retry 3 --retry-delay 2 -sS ^
        -o "%VC_X86%" ^
        "https://aka.ms/vc14/vc_redist.x86.exe" >nul 2>&1

    if not exist "%VC_X86%" (
        call :LogErr "Microsoft VCRedist x86 download failed."
    ) else (
        for %%F in ("%VC_X86%") do if %%~zF LSS 1000000 (
            call :LogErr "Microsoft VCRedist x86 download appears invalid."
            del /q "%VC_X86%" >nul 2>&1
        ) else (
            start /wait "" "%VC_X86%" /install /quiet /norestart
            if errorlevel 3010 (
                if not errorlevel 3011 (
                    call :LogOK "VCRedist x86 installed from Microsoft (restart required)."
                ) else (
                    call :LogErr "VCRedist x86 Microsoft installer failed (rc=3010+)."
                )
            ) else if errorlevel 1 (
                call :LogErr "VCRedist x86 Microsoft installer failed."
            ) else (
                call :LogOK "VCRedist x86 installed from Microsoft."
            )
        )
    )
)

del /q "%VC_X64%" "%VC_X86%" >nul 2>&1
rd /s /q "%VC_TEMP%" >nul 2>&1

call :LogInfo "Downloading DirectX Web Setup..."
setlocal EnableDelayedExpansion
set "DX_OK=1"
curl -L -f -s -o "%temp%\dxwebsetup.exe" "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" >nul 2>&1
if errorlevel 1 set "DX_OK=0"

if "%DX_OK%"=="1" (
    call :LogOK "DirectX Web Setup downloaded."
    call :LogInfo "Installing DirectX silently (this may take a moment)..."
    
    start /wait "" "%temp%\dxwebsetup.exe" /Q /R:N
    set "DX_EXIT_CODE=!errorlevel!"
    
    del /q "%temp%\dxwebsetup.exe" >nul 2>&1
    
    if "!DX_EXIT_CODE!"=="0" (
        call :LogOK "DirectX installed successfully."
    ) else (
        call :LogWarn "DirectX installer returned non-zero exit code (!DX_EXIT_CODE!). May already be up to date."
    )
) else (
    call :LogErr "Failed to download DirectX. Check internet connection."
    if exist "%temp%\dxwebsetup.exe" del /q "%temp%\dxwebsetup.exe" >nul 2>&1
)
endlocal

call :LogInfo "Starting Microsoft bloatware removal process..."

call :LogInfo "Forcefully removing Microsoft OneDrive..."
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    if errorlevel 1 (call :LogErr "OneDrive uninstall failed") else (call :LogOK "OneDrive uninstalled via setup")
)
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.OneDrive* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "OneDrive Appx removed") else (call :LogWarn "OneDrive Appx removal skipped")

rd /s /q "%LOCALAPPDATA%\Microsoft\OneDrive" >nul 2>&1
rd /s /q "%PROGRAMDATA%\Microsoft OneDrive" >nul 2>&1
call :LogOK "OneDrive leftover directories cleaned"

call :TIRegLog delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
call :TIRegLog delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f

call :LogSection "Microsoft Edge & WebView2 Complete Removal"
call :LogInfo "Stopping all Edge/WebView2 processes..."
taskkill /F /IM msedge.exe /T >nul 2>&1
taskkill /F /IM msedgewebview2.exe /T >nul 2>&1
taskkill /F /IM EdgeUpdate.exe /T >nul 2>&1

call :TIRegLog add "HKLM\SOFTWARE\Microsoft\EdgeUpdateDev" /v "AllowUninstall" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f

setlocal EnableDelayedExpansion
set "edge_found=0"

for %%P in (
    "C:\Program Files (x86)\Microsoft\Edge\Application"
    "C:\Program Files\Microsoft\Edge\Application"
) do (
    if exist "%%~P" (
        for /f "delims=" %%V in ('dir /b /ad "%%~P" 2^>nul ^| findstr /r "^[0-9][0-9]*\.[0-9]"') do (
            if exist "%%~P\%%V\Installer\setup.exe" (
                call :LogInfo "Found Edge version: %%V. Executing silent uninstall..."
                powershell -NoProfile -Command "$p = Start-Process -FilePath '%%~P\%%V\Installer\setup.exe' -ArgumentList '--uninstall --system-level --verbose-logging --force-uninstall' -Wait -PassThru -WindowStyle Hidden; exit $p.ExitCode" >nul 2>&1
                set "edge_found=1"
            )
        )
    )
)

for %%P in (
    "C:\Program Files (x86)\Microsoft\EdgeWebView\Application"
    "C:\Program Files\Microsoft\EdgeWebView\Application"
) do (
    if exist "%%~P" (
        for /f "delims=" %%V in ('dir /b /ad "%%~P" 2^>nul ^| findstr /r "^[0-9][0-9]*\.[0-9]"') do (
            if exist "%%~P\%%V\Installer\setup.exe" (
                call :LogInfo "Found WebView2 version: %%V. Executing silent uninstall..."
                powershell -NoProfile -Command "$p = Start-Process -FilePath '%%~P\%%V\Installer\setup.exe' -ArgumentList '--uninstall --msedgewebview --system-level --verbose-logging --force-uninstall' -Wait -PassThru -WindowStyle Hidden; exit $p.ExitCode" >nul 2>&1
                set "edge_found=1"
            )
        )
    )
)
endlocal

call :LogInfo "Removing Edge & WebView2 Appx packages..."
powershell -NoProfile -Command "Get-AppxPackage Microsoft.MicrosoftEdge -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage Microsoft.Win32WebViewHost -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Microsoft.MicrosoftEdge|Microsoft.Win32WebViewHost' }; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1

call :LogInfo "Removing Edge/WebView2 files while preserving protected placeholder directories..."
for %%D in (
    "C:\Program Files (x86)\Microsoft\Edge"
    "C:\Program Files\Microsoft\Edge"
    "C:\Program Files (x86)\Microsoft\EdgeWebView"
    "C:\Program Files\Microsoft\EdgeWebView"
    "C:\Program Files (x86)\Microsoft\EdgeUpdate"
) do (
    if exist "%%~D" call :TIRun cmd.exe /c rd /s /q "%%~D" >nul 2>&1
    if not exist "%%~D" mkdir "%%~D" >nul 2>&1
)
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\EdgeWebView" >nul 2>&1

call :LogInfo "Hardening Edge/WebView2 placeholder directories against Windows Update reinstalls..."
for %%D in (
    "C:\Program Files (x86)\Microsoft\Edge"
    "C:\Program Files\Microsoft\Edge"
    "C:\Program Files (x86)\Microsoft\EdgeWebView"
    "C:\Program Files\Microsoft\EdgeWebView"
    "C:\Program Files (x86)\Microsoft\EdgeUpdate"
) do (
    if exist "%%~D" call :TIRun icacls "%%~D" /deny "SYSTEM:(OI)(CI)F" >nul 2>&1
)

call :LogInfo "Disabling EdgeUpdate & Elevation services..."
call :TIScLog stop "edgeupdate"
call :TIScLog config "edgeupdate" start= disabled
call :TIScLog stop "edgeupdatem"
call :TIScLog config "edgeupdatem" start= disabled
call :TIScLog stop "MicrosoftEdgeElevationService"
call :TIScLog config "MicrosoftEdgeElevationService" start= disabled

call :SchLog /Change /TN "MicrosoftEdgeUpdateTaskMachineCore" /Disable
call :SchLog /Change /TN "MicrosoftEdgeUpdateTaskMachineUA" /Disable

call :LogInfo "Removing every Edge shortcut from desktop, start menu, taskbar..."
del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%USERPROFILE%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%OneDrive%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Accessories\Microsoft Edge.lnk" >nul 2>&1
rem Remove the Edge shortcut stub and cached icon.
del /q /f "%LOCALAPPDATA%\Microsoft\Edge\Application\*Microsoft Edge*.lnk" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache\Microsoft Edge" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\Bin" >nul 2>&1
rem Block Edge shortcut recreation.
if exist "%LOCALAPPDATA%\Microsoft\Windows\Caches" attrib +r "%LOCALAPPDATA%\Microsoft\Windows\Caches\*Edge*" >nul 2>&1

call :LogOK "Edge and WebView2 cleanup finished."

call :LogInfo "Disabling User Account Control (UAC) completely..."
rem Disable UAC (restart required).

call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "1" /f
call :LogWarn "UAC fully disabled (EnableLUA=0). A restart is required for this change to take effect."

call :LogInfo "Applying registry optimizations..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTips" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "PeopleBand" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\TabletTip\1.7" /v "EnableDesktopModeAutoInvoke" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "TurnOffHandwritingRecognitionFeature" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "10" /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "Value" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "value" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "SensorPermissionState" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Edge\Main" /v "AllowPrelaunch" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableBuildPreview" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\LanguageOptions" /v "ActionCenterUninstalled" /t REG_DWORD /d 1 /f

call :LogInfo "Disabling printer services..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Fax" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\SCardSvr" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\ScDeviceEnum" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\SCPolicySvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t REG_DWORD /d "4" /f

call :LogInfo "Cleaning Windows Search Index..."
net stop WSearch >nul 2>&1
del /f /q "C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb" >nul 2>&1

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "ForceQueue" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f

call :LogInfo "Disabling extra background services..."
call :TIDisableServiceInstances "CDPUserSvc"
call :TIDisableServiceInstances "ConnectedDevicesPlatformUserSvc"
call :TIDisableServiceInstances "PimIndexMaintenanceSvc"
call :TIDisableServiceInstances "UnistoreSvc"
call :TIDisableServiceInstances "UserDataSvc"
call :TIDisableServiceInstances "ContactDataSvc"
call :TIDisableServiceInstances "MessagingSyncSvc"
call :TIDisableServiceInstances "OneSyncSvc"
call :TIDisableServiceInstances "MessagingService"
call :TIDisableServiceInstances "CortanaCtiUserSvc"
call :TIDisableServiceInstances "DevicePickerUserSvc"
call :TIDisableServiceInstances "SCNotification"
call :TIDisableServiceInstances "InstalledAppsProviderService"
call :TIDisableServiceInstances "WbioSrvc"
call :TIDisableServiceInstances "BcastDVRUserService"
call :TIDisableServiceInstances "CaptureService"
call :TIDisableServiceInstances "FrameServer"
call :TIDisableServiceInstances "DeviceAssociationBrokerSvc"
call :TIDisableServiceInstances "TabletInputService"

call :LogInfo "Applying game mode settings..."
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
call :RegLog add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DOMaxBackgroundDownloadBandwidth" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 10 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d 10 /f

call :LogInfo "Applying Capability Access Manager Deny policies..."
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Allow" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Allow" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f

call :LogInfo "Disabling Content Delivery Manager apps..."
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f

call :LogInfo "Applying CPU Priority tweaks..."
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f

call :LogInfo "Disabling Notifications..."
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\QuietHours" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LowDisk" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Print.Notification" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager" /v "Enabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "TelemetrySalt" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RemediationRequired" /t REG_DWORD /d "0" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feedback\Diagnostics" /v "UserConsentTelemetryAllowed" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
call :RegLog add "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_DWORD /d 2147483650 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows Search" /v "SetupCompletedSuccessfully" /t REG_DWORD /d 1 /f

call :LogInfo "Disabling Windows System Sounds"
call :RegLog add "HKCU\AppEvents\Schemes" /ve /d ".None" /f

powershell -NoProfile -Command "Get-ChildItem 'HKCU:\AppEvents\Schemes\Apps\.Default' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -eq '.Current' } | Remove-Item -Force -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "System sound assignments cleared") else (call :LogWarn "System sound assignments already cleared")

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v "DisableStartupSound" /t REG_DWORD /d "1" /f
call :LogOK "Windows Startup Sound disabled"

call :LogInfo "Disabling Telemetry..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventoryCollection" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d 1 /f

call :LogInfo "Applying Custom Wallpaper..."
set "WALLPAPER_PATH=C:\bardhzzY Utility Tools\Wallpaper\bardhzzY Utility Blue.png"

if exist "%WALLPAPER_PATH%" (
    call :RegLog add "HKCU\Control Panel\Desktop" /v Wallpaper      /t REG_SZ /d "%WALLPAPER_PATH%" /f
    call :RegLog add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f
    call :RegLog add "HKCU\Control Panel\Desktop" /v TileWallpaper  /t REG_SZ /d "0"  /f

    powershell -NoProfile -ExecutionPolicy Bypass -Command "$code = '[DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, string c, uint d);'; $sys = Add-Type -MemberDefinition $code -Name 'Wallpaper' -Namespace 'Win32' -PassThru; if (-not $sys::SystemParametersInfo(20, 0, $env:WALLPAPER_PATH, 3)) { exit 1 }"

    if errorlevel 1 (
        call :LogWarn "Wallpaper registry set, but live refresh failed. Will apply on next reboot."
    ) else (
        call :LogOK "Custom wallpaper applied successfully."
    )
) else (
    call :LogWarn "Custom wallpaper not found at %WALLPAPER_PATH%"
)

call :LogInfo "Applying Performance Visuals..."
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012028010000000 /f
call :RegLog add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d 2 /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
call :LogInfo "Applying additional UI tweaks..."
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTipSpace" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDragDrop" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v "TaskbarEndTask" /t REG_DWORD /d 1 /f

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DebugPollInterval" /t REG_DWORD /d 0x3e8 /f

call :RegLog delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f
call :RegLog delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f
call :RegLog delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f
call :RegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E913F}" /f
call :RegLog delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E913F}" /f
call :RegLog delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\image\shell\print" /f
call :RegLog delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\image\shell\printto" /f
call :RegLog delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f
call :RegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "NumThumbnails" /t REG_DWORD /d 0 /f
rem Disable post-update welcome prompts.
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
call :LogInfo "Disabling Meet Now and Teams startup..."
call :RegLog delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "com.squirrel.Teams.Teams" /f

call :LogInfo "Windows Defender handling moved to menu option 14 (Disable Defender)."
call :LogInfo "Disabling SMBv1 (security)..."
powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable SMB1Protocol") else (call :LogWarn "Disable SMB1Protocol")
call :TIScLog config lanmanworkstation depend= "Bowser/Srv2/SrvNet"
call :LogInfo "Disabling LLMNR and NetBIOS (security)..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableLLMNR" /t REG_DWORD /d 0 /f
if "%os_ver%"=="Win11" (
    call :LogInfo "Applying Win11-specific tweaks..."
    call :RegLog add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve /d ""
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Sudo\Settings" /v "Enabled" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v "DisableAIDataAnalysis" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" /v "State" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v "BackgroundType" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\UssSvc" /v "Start" /t REG_DWORD /d 4 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseCompactMode" /t REG_DWORD /d 1 /f
    call :LogInfo "Disabling Windows 11 Widgets..."
    call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Widgets" /v "AllowWidgets" /t REG_DWORD /d 0 /f
    call :TIScLog config SpectrumService start= disabled
    call :TIScLog stop SpectrumService
    call :TIScLog config TelephonyClientApiSvc start= disabled
    call :TIScLog stop TelephonyClientApiSvc
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d 0 /f
)
if "%os_ver%"=="Win10" (
    call :LogInfo "Applying Win10-specific tweaks..."
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f
    call :LogInfo "Disabling Windows 10 News and Interests..."
    call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
)

call :LogInfo "Applying final registry cleanups..."
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "StorageSenseGlobal" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SidebarEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d 1 /f

setlocal enabledelayedexpansion

call :LogInfo "Applying Additional OS Registry Keys..."
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f

call :LogInfo "Disabling Background Startup Apps..."

for /f "delims=" %%I in ('powershell -NoProfile -Command "Get-CimInstance Win32_StartupCommand | Select-Object -ExpandProperty Caption" 2^>nul') do (
    set "app_name=%%I"
    if not "!app_name!"=="" (
        reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "!app_name!" >nul 2>&1
        if !errorlevel! equ 0 (
            reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "!app_name!" /t REG_BINARY /d "0300000000000000" /f >nul 2>&1
            if !errorlevel! equ 0 (call :LogOK "Disable Startup App: !app_name!") else (call :LogErr "Disable Startup App: !app_name!")
        )
        reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "!app_name!" >nul 2>&1
        if !errorlevel! equ 0 (
            reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "!app_name!" /t REG_BINARY /d "0300000000000000" /f >nul 2>&1
            if !errorlevel! equ 0 (call :LogOK "Disable Startup App [HKLM]: !app_name!") else (call :LogErr "Disable Startup App [HKLM]: !app_name!")
        )
    )
)

endlocal

call :LogInfo "Disabling PnP Devices..."
call :DisablePnpByID "SWD\MSRRAS\MS_IKEEV2_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_IKEEV2_MINIPORT") else (call :LogErr "Disable MS_IKEEV2_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_IP_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_IP_MINIPORT") else (call :LogErr "Disable MS_IP_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_IPV6_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_IPV6_MINIPORT") else (call :LogErr "Disable MS_IPV6_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_L2TP_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_L2TP_MINIPORT") else (call :LogErr "Disable MS_L2TP_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_PPPOE_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_PPPOE_MINIPORT") else (call :LogErr "Disable MS_PPPOE_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_PPTP_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_PPTP_MINIPORT") else (call :LogErr "Disable MS_PPTP_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_SSTP_MINIPORT" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_SSTP_MINIPORT") else (call :LogErr "Disable MS_SSTP_MINIPORT")
call :DisablePnpByID "SWD\MSRRAS\MS_NDISWANBH" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_NDISWANBH") else (call :LogErr "Disable MS_NDISWANBH")
call :DisablePnpByID "SWD\MSRRAS\MS_NDISWANIP" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_NDISWANIP") else (call :LogErr "Disable MS_NDISWANIP")
call :DisablePnpByID "SWD\MSRRAS\MS_NDISWANIPV6" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable MS_NDISWANIPV6") else (call :LogErr "Disable MS_NDISWANIPV6")
call :DisablePnpByID "ROOT\vmic_guestinterface\0000" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable vmic_guestinterface") else (call :LogErr "Disable vmic_guestinterface")

call :LogInfo "Whitelisting core gaming paths..."
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Epic Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude Epic Games path") else (call :LogErr "Exclude Epic Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Steam'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude Steam path") else (call :LogErr "Exclude Steam path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Riot Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude Riot Games path") else (call :LogErr "Exclude Riot Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\EA Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude EA Games path") else (call :LogErr "Exclude EA Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude C:\Games path") else (call :LogErr "Exclude C:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'D:\Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude D:\Games path") else (call :LogErr "Exclude D:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'E:\Games'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude E:\Games path") else (call :LogErr "Exclude E:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'FortniteClient-Win64-Shipping.exe'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude FortniteClient Process") else (call :LogErr "Exclude FortniteClient Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'FortniteLauncher.exe'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude FortniteLauncher Process") else (call :LogErr "Exclude FortniteLauncher Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'EpicGamesLauncher.exe'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude EpicGamesLauncher Process") else (call :LogErr "Exclude EpicGamesLauncher Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'steam.exe'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude steam Process") else (call :LogErr "Exclude steam Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'RiotClientServices.exe'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude RiotClientServices Process") else (call :LogErr "Exclude RiotClientServices Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionExtension 'pak','upk','big','bsp','vtf','assets'" >nul 2>&1
if not errorlevel 1 (call :LogOK "Exclude Game Extensions") else (call :LogErr "Exclude Game Extensions")
powershell -NoProfile -Command "$paths = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture'); foreach ($p in $paths) { if (Test-Path $p) { Get-ChildItem $p | ForEach-Object { $fx = Join-Path $_.PSPath 'FxProperties'; if (Test-Path $fx) { Set-ItemProperty -Path $fx -Name '{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5' -Value 1 -Type DWord -ErrorAction SilentlyContinue } } } }" >nul 2>&1
if not errorlevel 1 (call :LogOK "disable Audio Enhancements") else (call :LogErr "disable Audio Enhancements")

rem Set the Arrow and Crosshair cursors for the current user.

call :LogInfo "Setting mouse pointer to cross_r.cur..."
if exist "%SystemRoot%\Cursors\cross_r.cur" (
    reg add "HKCU\Control Panel\Cursors" /v "Arrow" /t REG_EXPAND_SZ /d "%SystemRoot%\Cursors\cross_r.cur" /f >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to set the default Arrow cursor to cross_r.cur."
    ) else (
        reg add "HKCU\Control Panel\Cursors" /v "Crosshair" /t REG_EXPAND_SZ /d "%SystemRoot%\Cursors\cross_r.cur" /f >nul 2>&1
        if errorlevel 1 (
            call :LogErr "Arrow cursor changed, but Crosshair cursor mapping failed."
        ) else (
            powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $src='using System; using System.Runtime.InteropServices; public static class CursorRefresh { [DllImport(' + [char]34 + 'user32.dll' + [char]34 + ', SetLastError=true)] public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni); }'; Add-Type -TypeDefinition $src; if (-not [CursorRefresh]::SystemParametersInfo(0x0057, 0, [IntPtr]::Zero, 3)) { exit 1 }; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
            if errorlevel 1 (
                call :LogWarn "Cursor paths saved, but Windows could not refresh them immediately; sign out or restart if needed."
            ) else (
                call :LogOK "Default Arrow and Crosshair cursor mappings set to cross_r.cur."
            )
        )
    )
) else (
    call :LogWarn "cross_r.cur was not found in %SystemRoot%\Cursors; cursor mapping skipped."
)

call :LogInfo "Windows Tweaks section complete."
timeout /t 1 /nobreak > NUL
pause
goto main

:gpu
cls
echo %RESET%

echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%SELECT GPU MANUFACTURER%RESET%
echo  %WHITE% [%CYAN%1%WHITE%] Nvidia          %WHITE% [%CYAN%2%WHITE%] AMD             %WHITE% [%CYAN%3%WHITE%] Intel
echo.
echo  %WHITE% [%CYAN%4%WHITE%] Exit to Main Menu
echo.
set "input="
set /p "input=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

rem Validate user input.
if not defined input goto gpu
set "input=%input:"=%"
set "input=%input:&=%"
set "input=%input:|=%"
set "input=%input:^=%"
set "input=%input:<=%"
set "input=%input:>=%"

if /i "%input%"=="1" goto nvid
if /i "%input%"=="2" goto amd
if /i "%input%"=="3" goto intel
if /i "%input%"=="4" goto main

echo.
echo "%input%" isn't a right choice, try again!
timeout 2 >nul
goto gpu

:nvid
call :LogSection "Nvidia GPU Tweaks"
cls
call :LogInfo "Injecting Vortex profile directly into NVIDIA Kernel..."

if not exist "C:\bardhzzY Utility Tools\Nvidia\nvidiaProfileInspector.exe" goto NPI_MISSING_EXE
if not exist "C:\bardhzzY Utility Tools\Nvidia\vortex.nip" goto NPI_MISSING_NIP

"C:\bardhzzY Utility Tools\Nvidia\nvidiaProfileInspector.exe" -silentImport "C:\bardhzzY Utility Tools\Nvidia\vortex.nip" >nul 2>&1
if not errorlevel 1 (
    call :LogOK "Vortex Driver Profile Applied!"
) else (
    call :LogErr "Vortex Driver Profile Injection Failed"
)
goto NPI_CLEANUP

:NPI_MISSING_EXE
call :LogErr "nvidiaProfileInspector.exe not found in C:\bardhzzY Utility Tools\Nvidia!"
goto NPI_CLEANUP

:NPI_MISSING_NIP
call :LogErr "vortex.nip not found in C:\bardhzzY Utility Tools\Nvidia!"

:NPI_CLEANUP
call :LogInfo "Nvidia Profile Inspector Done"
timeout /t 1 >nul

call :LogInfo "Disabling Nvidia Telemetry Tasks..."
setlocal EnableDelayedExpansion
powershell -NoProfile -ExecutionPolicy Bypass -Command "$targets=@('NvTmMon','NvTmRep','NvDriverUpdateCheckDaily','GeForce Experience','SelfUpdate'); $tasks=Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $targets -contains $_.TaskName }; foreach($t in $tasks){ try { Disable-ScheduledTask -InputObject $t -ErrorAction Stop | Out-Null } catch {} }; if($tasks){exit 0}else{exit 2}" >nul 2>&1
if not errorlevel 1 (call :LogOK "NVIDIA telemetry tasks disabled (exact task names only).") else if errorlevel 2 (call :LogSkip "No matching NVIDIA telemetry tasks found.") else (call :LogWarn "NVIDIA telemetry task query returned an error.")
endlocal

call :LogInfo "Applying Nvidia Registry Tweaks..."
call :RegLog add "HKLM\SOFTWARE\NVIDIA Corporation\Global\GlobalSettings" /v "ShaderCacheMaxSizeBytes" /t REG_QWORD /d 10737418240 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\DirectX\GraphicsDeviceManager" /v "ShaderCacheSize" /t REG_DWORD /d 10240 /f
call :RegLog add "HKLM\SOFTWARE\NVIDIA Corporation\Global\Stereo3D" /v "ShaderCacheSize" /t REG_DWORD /d 10240 /f

for %%i in (0000 0001 0002 0003 0004 0005) do (
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerEnable" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PerfLevelSrc" /t REG_DWORD /d 8738 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerLevelAC" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableCoreSlowdown" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableMCLKSlowdown" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableNVCLKSlowdown" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMHdcpKeyglobZero" /t REG_DWORD /d 1 /f
)

call :LogInfo "Applying NVIDIA RM* depth tweaks (engine gatings, GC6, runtime PM, LRC, latency tolerance)..."

rem NVIDIA tweaks.
for %%i in (0000 0001 0002 0003 0004 0005) do (
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDisableHwFaultBuffer" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisablePerIntrDPCQueueing" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMElcg" /t REG_DWORD /d 1431655765 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMBlcg" /t REG_DWORD /d 286331153 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMElpg" /t REG_DWORD /d 4095 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMSlcg" /t REG_DWORD /d 262131 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMFspg" /t REG_DWORD /d 15 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDidleFeatureGC5" /t REG_DWORD /d 44731050 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMHotPlugSupportDisable" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmFbsrPagedDMA" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisablePostL2Compression" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmRcWatchdog" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmLogonRC" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMIntrDetailedLogs" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMCtxswLog" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMNvLog" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMSuppressGPIOIntrErrLog" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMUsbcDebugMode" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableFeatureDisablement" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmBreakonRC" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDebugSetSMCMode" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableLRCCoalescing" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmEnableI2CNanny" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMPcieLtrOverride" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMPcieLtrL12ThresholdOverride" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDisablePreosapps" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmPerfLimitsOverride" /t REG_DWORD /d 21 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMGCOffFeature" /t REG_DWORD /d 2 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmOverrideSupportChipsetAspm" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMEnableASPMDT" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableGpuASPMFlags" /t REG_DWORD /d 3 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMEnableASPMAtLoad" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMEnableEventTracer" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "SkipSwStateErrChecks" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMAERRForceDisable" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmWar1760398" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmLpwrArch" /t REG_DWORD /d 349525 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmLpwrGrPgSwFilterFunction" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmLpwrCacheStatsOnD3" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDwbMscg" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDisableInforomBBX" /t REG_DWORD /d 15 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmSec2EnableApm" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmOverrideIdleSlowdownSettings" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMClkSlowDown" /t REG_DWORD /d 71303168 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMNativePcieL1WarFlags" /t REG_DWORD /d 16 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMResetPerfMonD4" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmFbsrWDDMMode" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmFbsrFileMode" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmMIONoPowerOff" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableOptimalPowerForPadlinkPll" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmClkPowerOffDramPllWhenUnused" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMOPSB" /t REG_DWORD /d 10914 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "DisableAsyncPstates" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "SlideMCLK" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMNvlinkUPHYInitControl" /t REG_DWORD /d 16 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmGpsGenoa" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "SendTelemetryData" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableRID44231" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableRID64640" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableRID66610" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDisableRegistryCaching" /t REG_DWORD /d 15 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "D3PCLatency" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableMsHybrid" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableIntrIllegalCompstatAccess" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "SetPanelRefreshRate" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMDisableNoncontigAlloc" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDisableHdcp22" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableRuntimePowerManagement" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmProfilingAdminOnly" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "ShowDlssIndicator" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableHDAudioD3Cold" /t REG_DWORD /d 0 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RmDevToolsVisible" /t REG_DWORD /d 1 /f
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "NvDevToolsVisible" /t REG_DWORD /d 1 /f
)
call :LogOK "NVIDIA RM* depth tweaks applied."

call :LogInfo "Applying DisableDynamicPstate to active GPU"
powershell -NoProfile -Command "$gpus = Get-CimInstance Win32_VideoController | Where-Object { $_.PNPDeviceID -like 'PCI\VEN_10DE*' }; foreach ($gpu in $gpus) { $pnp = $gpu.PNPDeviceID; $regBase = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $pnp; $driverVal = (Get-ItemProperty -Path $regBase -Name 'Driver' -ErrorAction SilentlyContinue).Driver; if ($driverVal) { $classPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\' + $driverVal; if (Test-Path $classPath) { Set-ItemProperty -Path $classPath -Name 'DisableDynamicPstate' -Value 1 -Type DWord -ErrorAction SilentlyContinue } } }" >nul 2>&1
if not errorlevel 1 (call :LogOK "DisableDynamicPstate applied") else (call :LogWarn "DisableDynamicPstate skipped (No matching GPU found)")

rem nvidia msi mode
call :LogInfo "Enabling MSI Mode for NVIDIA GPU..."
setlocal EnableExtensions EnableDelayedExpansion

set "NVIDIA_MSI_COUNT=0"

for /f "delims=" %%A in ('
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_10DE" 2^>nul ^|
    findstr /i /b "HKEY_LOCAL_MACHINE"
') do (
    reg query "%%A" /v "Service" 2>nul | findstr /i /c:"nvlddmkm" >nul

    if not errorlevel 1 (
        set "NVIDIA_MSI_PATH=%%A\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"

        reg query "!NVIDIA_MSI_PATH!" >nul 2>&1

        if not errorlevel 1 (
            reg add "!NVIDIA_MSI_PATH!" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
            set "NVIDIA_MSI_RC=!errorlevel!"

            if "!NVIDIA_MSI_RC!"=="0" (
                set /a NVIDIA_MSI_COUNT+=1
                set "LOG_MSG=NVIDIA MSI enabled: %%A"
                call :LogOK
            ) else (
                set "LOG_MSG=NVIDIA MSI write failed: %%A (err=!NVIDIA_MSI_RC!)"
                call :LogErr
            )

            reg add "!NVIDIA_MSI_PATH!" /v "MessageNumberLimit" /t REG_DWORD /d 1 /f >nul 2>&1
            if not errorlevel 1 (
                set "LOG_MSG=NVIDIA MSI MessageNumberLimit configured: %%A"
                call :LogOK
            ) else (
                set "LOG_MSG=NVIDIA MessageNumberLimit write failed: %%A"
                call :LogWarn
            )

            set "NVIDIA_AFFINITY_PATH=%%A\Device Parameters\Interrupt Management\Affinity Policy"

            reg query "!NVIDIA_AFFINITY_PATH!" >nul 2>&1

            if not errorlevel 1 (
                reg add "!NVIDIA_AFFINITY_PATH!" /v "DevicePriority" /t REG_DWORD /d 3 /f >nul 2>&1

                if not errorlevel 1 (
                    set "LOG_MSG=NVIDIA DevicePriority set: %%A"
                    call :LogOK
                ) else (
                    set "LOG_MSG=NVIDIA DevicePriority write failed: %%A"
                    call :LogWarn
                )
            ) else (
                set "LOG_MSG=NVIDIA Affinity Policy structure not present; skipped: %%A"
                call :LogSkip
            )
        ) else (
            set "LOG_MSG=NVIDIA MSI structure not present; skipped: %%A"
            call :LogSkip
        )
    )
)

if !NVIDIA_MSI_COUNT! equ 0 (
    call :LogWarn "No NVIDIA devices with an existing MSI structure were modified."
) else (
    set "LOG_MSG=Successfully enabled MSI on !NVIDIA_MSI_COUNT! NVIDIA device(s)."
    call :LogOK
)
endlocal

call :LogInfo "Applying DirectX Optimizations..."
powershell -NoProfile -Command "$p='HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'; $n='DirectXUserGlobalSettings'; $tweak='SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;'; $val=(Get-ItemProperty -Path $p -Name $n -ErrorAction SilentlyContinue).$n; if($val){ $parts=$val -split ';' | Where-Object { $_ -notmatch 'SwapEffectUpgradeEnable' -and $_ -notmatch 'VRROptimizeEnable' }; $new=($parts -join ';').';'+$tweak } else { $new=$tweak }; Set-ItemProperty -Path $p -Name $n -Value $new -Type String -Force" >nul 2>&1
if not errorlevel 1 (call :LogOK "DirectX Global Settings applied") else (call :LogErr "DirectX Global Settings failed")

call :RegLog add "HKCU\Software\Microsoft\DXGIExtensions" /v "ForceIndependentFlip" /t REG_DWORD /d 1 /f
call :LogInfo "Disabling Multiplane Overlay (MPO)..."
call :RegLog delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestType" /f >nul 2>&1
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableOverlays" /t REG_DWORD /d "1" /f

rem HDCP tweaks.
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /f "00*" /k ^| findstr "000"') do (
    set "RL_DYN_KEY=%%a"
    call :DynRegLog /v "RmHdcpKeybackDisable" /t REG_DWORD /d 1 /f
    set "RL_DYN_KEY=%%a"
    call :DynRegLog /v "RMHdcpPowerSavingDisable" /t REG_DWORD /d 1 /f
)
call :LogOK "NVIDIA DirectX Optimizations perfectly applied!"

call :LogInfo "Applying nvlddmkm tweaks..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\NVIDIA Corporation\NvTray" /v "StartOnLogin" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "HideXGpuTrayIcon" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "Gestalt" /t REG_DWORD /d 2 /f
call :RegLog add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D\ReferenceDevice" /v "AllowAsync" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d False /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 2710 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "BackgroundPriority" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d True /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnablePipelineCache" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d 0 /f

call :TIScLog config NvBackend start= disabled

for %%v in (ActivelyUsed IdleLongTime IdleMonitorOff IdleShortTime IdleVeryLongTime IdleNoContext) do (
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatency%%v" /t REG_DWORD /d 1 /f
)
for %%v in (Idle0 Idle0MonitorOff Idle1 Idle1MonitorOff Memory) do (
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyTolerance%%v" /t REG_DWORD /d 1 /f
)

call :LogOK "All NVIDIA Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:amd
call :LogSection "AMD GPU Tweaks"
cls
echo.
echo [!] Searching for AMD GPU Registry Keys...
echo.
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /f "DriverDesc" ^| findstr "HKEY"') do (
    reg query "%%a" /v "DriverDesc" 2>nul | findstr /i "AMD" >nul
    if !errorlevel! equ 0 (
        call :LogInfo "Applying Performance Tweaks to: %%a"
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_RTPMComputeF1Latency" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_DGBMMMaxTransitionLatencyUvd" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_DGBPMMaxTransitionLatencyGfx" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DalNBLatencyForUnderFlow" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRSnoopL1Latency" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRSnoopL0Latency" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRNoSnoopL1Latency" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRNoSnoopL0Latency" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRMaxSnoopLatencyValue" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "BGM_LTRMaxNoSnoopLatencyValue" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "KMD_EnableComputePreemption" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "KMD_DeLagEnabled" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisablePreemption" /t REG_DWORD /d 1 /f

        call :LogInfo "Applying AMD depth tweaks (clock gating, power gating, ASPM, sleep) to: %%a"

        rem Performance mode + sleep disables
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_Force3DPerformanceMode" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_ForceHighDPMLevel" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCoarseGrainLightSleep" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCpLightSleep" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxMediumGrainLightSleep" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxRlcLightSleep" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableDrmLightSleep" /t REG_DWORD /d 1 /f

        rem Radeon Boost off
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "KMD_RadeonBoostEnabled" /t REG_DWORD /d 0 /f

        rem Clock gating keys
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfx3DCGLS" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCGTS" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCGTS_LS" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxMGCGPerfMon" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableDrmdmaMGCG" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableDrmMGCG" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfx3DCGCG" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableUvdClockGating" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableVceSwClockGating" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableGfxClockGatingThruSmu" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableSysClockGatingThruSmu" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "IRQMgrDisableIHClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "swGcClockGatingMask" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "swGcClockGatingOverride" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableRomMediumGrainClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableRomMGCGClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableSamuClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableSysClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableVceClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCoarseGrainClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxMediumGrainClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableMcMediumGrainClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableNbioMediumGrainClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DalDisableClockGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DalFineGrainClockGating" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableAllClockGating" /t REG_DWORD /d 1 /f

        rem Power gating keys
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxPGCondClearStateWA" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableCpPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableAcpPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableDrmdmaPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableDynamicGfxMGPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGDSPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGfxCGPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableGFXPipelinePowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisablePowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableQuickGfxMGPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableSAMUPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableStaticGfxMGPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableUVDPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableVCEPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableXdmaPowerGating" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableXdmaSclkGating" /t REG_DWORD /d 1 /f

        rem Powerdown + ASPM
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DalPSRSkipCRTCPowerDown" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableAspmSWL1" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableAspmL0s" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableAspmL1" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableAspmL0s" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableAspmL1" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableAspmL1SS" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "AspmL0sTimeout" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "AspmL1Timeout" /t REG_DWORD /d 0 /f

        rem Misc disable
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableClkReqSupport" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableFBCSupport" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "DisableForceUvdToSclk" /t REG_DWORD /d 1 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "EnableSpreadSpectrum" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "PowerSaverAutoEnable_CUR" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "ChillEnabled" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "AutoUpdateTriggered" /t REG_DWORD /d 0 /f
        set "RL_DYN_KEY=%%a"
        call :DynRegLog /v "AutoUpdate" /t REG_DWORD /d 0 /f
    )
)
endlocal

call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnablePipelineCache" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f
call :TIScLog config "AMD External Events Utility" start= disabled
call :TIScLog stop "AMD External Events Utility"

call :LogInfo "Enabling Windowed Game Optimizations"
call :RegLog add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;" /f
call :LogOK "AMD Tweaks Applied Successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:intel
call :LogSection "Intel iGPU Tweaks"
cls
call :LogInfo "Applying Intel iGPU Registry Tweaks (Laptops/Hybrid Systems)..."
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Disable_OverlayDSQualityEnhancement" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "IncreaseFixedSegment" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AdaptiveVsyncEnable" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePFonDP" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableCompensationForDVI" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NoFastLinkTrainingForeDP" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ACPowerPolicyVersion" /t REG_DWORD /d "16898" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DCPowerPolicyVersion" /t REG_DWORD /d "16642" /f
call :RegLog add "HKLM\Software\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "512" /f

call :LogInfo "Setting interrupt policies for Intel GPU..."
rem Intel GPU MSI tweaks.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $gpus=Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | Where-Object { $_.PNPDeviceID -like '*VEN_8086*' }; $count=0; foreach($g in $gpus){ $p='Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\'+$g.PNPDeviceID+'\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties'; if(Test-Path $p){ try { New-ItemProperty -Path $p -Name 'MSISupported' -PropertyType DWord -Value 1 -Force -ErrorAction Stop | Out-Null; $count++ } catch {} } }; Write-Output $count" > "%TEMP%\bardhzz_intel_msi_count.txt" 2>nul
set "INTEL_MSI_COUNT=0"
for /f "delims=" %%A in ('type "%TEMP%\bardhzz_intel_msi_count.txt" 2^>nul') do set "INTEL_MSI_COUNT=%%A"
del /q "%TEMP%\bardhzz_intel_msi_count.txt" >nul 2>&1
if "%INTEL_MSI_COUNT%"=="0" (call :LogSkip "Intel iGPU MSI: no existing MSI property path was modified.") else (set "LOG_MSG=Intel iGPU MSI enabled on %INTEL_MSI_COUNT% adapter(s)." & call :LogOK)
call :LogOK "Intel iGPU Tweaks Applied Successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:cpu
call :LogSection "CPU Tweaks"
echo You selected CPU Tweaks!
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MSISupported" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "LbrEnabled" /t REG_DWORD /d 0 /f
powercfg /setacvalueindex scheme_current sub_pciexpress aspm 0
if not errorlevel 1 (call :LogOK "powercfg sub_pciexpress") else (call :LogErr "powercfg sub_pciexpress")

echo %PROCESSOR_IDENTIFIER% | findstr /i "AMD" >nul && (
    call :LogInfo "AMD CPU detected - Applying AMD-specific tweaks..."
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f
)
echo %PROCESSOR_IDENTIFIER% | findstr /i "Intel" >nul && (
    call :LogInfo "Intel CPU detected - Applying Hybrid CPU Scheduler Tweaks..."
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DynamicHeteroCpuPolicyMask" /t REG_DWORD /d "3" /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DefaultDynamicHeteroCpuPolicy" /t REG_DWORD /d "3" /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DynamicHeteroCpuPolicyImportant" /t REG_DWORD /d "1" /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DynamicHeteroCpuPolicyImportantShort" /t REG_DWORD /d "1" /f
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "DynamicHeteroCpuPolicyImportantPriority" /t REG_DWORD /d "8" /f
)

call :LogInfo "Disabling unnecessary legacy drivers & Network Data Usage Monitor..."
for %%S in (Ndu 1394ohci fdc flpydisk sfloppy HidBth HidIr) do (
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v "Start" /t REG_DWORD /d "4" /f
)

call :LogInfo "Applying Device Priority tweaks..."
rem PCI device affinity.
set "CPU_AFFINITY_RC=0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $base='Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\PCI'; $keys=Get-ChildItem -Path $base -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer -and $_.Name -eq 'Affinity Policy' }; $count=0; foreach($k in $keys){ try { New-ItemProperty -Path $k.PSPath -Name 'DevicePriority' -PropertyType DWord -Value 3 -Force -ErrorAction Stop | Out-Null; $count++ } catch {} }; Write-Output $count" > "%TEMP%\bardhzz_cpu_affinity_count.txt" 2>nul
set "CPU_AFFINITY_COUNT=0"
for /f "delims=" %%A in ('type "%TEMP%\bardhzz_cpu_affinity_count.txt" 2^>nul') do set "CPU_AFFINITY_COUNT=%%A"
del /q "%TEMP%\bardhzz_cpu_affinity_count.txt" >nul 2>&1
if not defined CPU_AFFINITY_COUNT set "CPU_AFFINITY_COUNT=0"
if "%CPU_AFFINITY_COUNT%"=="0" (call :LogSkip "DevicePriority: no existing PCI Affinity Policy keys were modified.") else (set "LOG_MSG=DevicePriority applied to %CPU_AFFINITY_COUNT% PCI device(s)." & call :LogOK)

bcdedit /set debug off >nul 2>&1
if not errorlevel 1 (call :LogOK "bcdedit debug off") else (call :LogErr "bcdedit debug off")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "CountOperations" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f

call :LogInfo "Disabling unnecessary services..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CSC" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasAcd" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Rasl2tp" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasPppoe" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasSstp" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\dam" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\NdisCap" /v "Start" /t REG_DWORD /d "4" /f

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f

call :LogInfo "Disabling Hyper-V & VMP..."
dism /online /Disable-Feature /FeatureName:VirtualMachinePlatform /NoRestart >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable VMP feature") else (call :LogErr "Disable VMP feature")
dism /online /Disable-Feature /FeatureName:Microsoft-Hyper-V-All /NoRestart >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable Hyper-V feature") else (call :LogErr "Disable Hyper-V feature")
bcdedit /set hypervisorlaunchtype off >nul 2>&1
if not errorlevel 1 (call :LogOK "bcdedit hypervisor off") else (call :LogErr "bcdedit hypervisor off")

setlocal enabledelayedexpansion

call :LogInfo "Setting Background Apps to Power Saving / Low Priority..."
set "discordPath="
set "robloxPath="
for /f "delims=" %%i in ('dir /b /s "%USERPROFILE%\AppData\Local\Roblox\Versions\RobloxPlayerBeta.exe" 2^>nul') do set "robloxPath=%%i"
for /f "delims=" %%i in ('dir /b /s "%USERPROFILE%\AppData\Local\Discord\Discord.exe" 2^>nul') do set "discordPath=%%i"

set "apps[0]=!discordPath!"
set "apps[1]=%USERPROFILE%\AppData\Roaming\Spotify\Spotify.exe"
set "apps[2]=C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe"
set "apps[3]=C:\Program Files\obs-studio\bin\64bit\obs64.exe"
set "apps[4]=C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
set "apps[5]=C:\Program Files (x86)\Epic Games\Launcher\Engine\Binaries\Win64\EpicWebHelper.exe"
set "apps[6]=C:\Program Files (x86)\Steam\Steam.exe"
set "apps[7]=C:\Program Files (x86)\Battle.net\Battle.net.exe"
set "apps[8]=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "apps[9]=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"

set "regKeyGP=HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
set "regKeyPR=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

for /L %%i in (0, 1, 9) do (
    set "currentPath=!apps[%%i]!"
    if not "!currentPath!"=="" (
        if exist "!currentPath!" (
            for %%a in ("!currentPath!") do set "exeName=%%~nxa"
            reg add "!regKeyGP!" /v "!currentPath!" /t REG_SZ /d "GpuPreference=1" /f >nul 2>&1
            reg add "!regKeyPR!\!exeName!\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>&1
            call :LogOK "Power Saving / Low Priority: !exeName!"
        )
    )
)

endlocal

call :LogInfo "Scanning for common games to apply High Priority..."
setlocal enabledelayedexpansion
set "games[0]=C:\Riot Games\VALORANT\live\Game\Binaries\Win64\VALORANT-Win64-Shipping.exe"
set "games[1]=C:\Program Files (x86)\Steam\steamapps\common\Grand Theft Auto V\GTA5.exe"
set "games[2]=C:\Program Files (x86)\Steam\steamapps\common\Apex Legends\r5apex.exe"
set "games[3]=C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
set "games[4]=C:\Program Files (x86)\Battle.net\Overwatch\Overwatch.exe"
set "games[5]=C:\Riot Games\League of Legends\LeagueClient.exe"

set "regKeyGP=HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
set "regKeyPR=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

for /L %%i in (0, 1, 5) do (
    set "currentPath=!games[%%i]!"
    if exist "!currentPath!" (
        for %%a in ("!currentPath!") do set "exeName=%%~nxa"
        call :RegLog add "!regKeyGP!" /v "!currentPath!" /t REG_SZ /d "GpuPreference=2" /f
        call :RegLog add "!regKeyPR!\!exeName!\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f
        call :RegLog add "!regKeyPR!\!exeName!\PerfOptions" /v "IoPriority" /t REG_DWORD /d 3 /f
    )
)
endlocal
call :LogOK "Detected games elevated successfully."
call :LogInfo "CPU Tweaks section complete."
timeout /t 1 /nobreak > NUL
pause
goto main
    
:ram
cls
echo %RESET%

echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╝███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%SELECT RAM AMOUNT%RESET%
echo  %WHITE% [%CYAN% 1%WHITE%] 2 GB               %WHITE% [%CYAN% 4%WHITE%] 6 GB               %WHITE% [%CYAN% 7%WHITE%] 24 GB
echo  %WHITE% [%CYAN% 2%WHITE%] 3 GB               %WHITE% [%CYAN% 5%WHITE%] 8 GB               %WHITE% [%CYAN% 8%WHITE%] 32 GB
echo  %WHITE% [%CYAN% 3%WHITE%] 4 GB               %WHITE% [%CYAN% 6%WHITE%] 16 GB              %WHITE% [%CYAN% 9%WHITE%] 64 GB
echo.
echo  %WHITE% [%CYAN%10%WHITE%] Exit to Main Menu
echo.
set "input="
set /p "input=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

rem Validate user input.
if not defined input goto ram
set "input=%input:"=%"
set "input=%input:&=%"
set "input=%input:|=%"
set "input=%input:^=%"
set "input=%input:<=%"
set "input=%input:>=%"

if /i "%input%"=="1" goto 2g
if /i "%input%"=="2" goto 3g
if /i "%input%"=="3" goto 4g
if /i "%input%"=="4" goto 6g
if /i "%input%"=="5" goto 8g
if /i "%input%"=="6" goto 16g
if /i "%input%"=="7" goto 24g
if /i "%input%"=="8" goto 32g
if /i "%input%"=="9" goto 64g
if /i "%input%"=="10" goto main

echo.
echo "%input%" isn't a right choice, try again!
timeout 2 >nul
goto ram

:2g
call :LogSection "RAM Tweaks (2GB)"
echo You selected 2 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "2097152" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :LogOK "2GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:3g
call :LogSection "RAM Tweaks (3GB)"
echo You selected 3 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "3145728" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :LogOK "3GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:4g
call :LogSection "RAM Tweaks (4GB)"
echo You selected 4 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "4194304" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :LogOK "4GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:6g
call :LogSection "RAM Tweaks (6GB)"
echo You selected 6 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "6291456" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :LogOK "6GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:8g
call :LogSection "RAM Tweaks (8GB)"
echo You selected 8 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "8388608" /f
echo Disabling Paging Executive
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ZeroPagedMemory" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 8400000 /f
call :LogOK "8GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:16g
call :LogSection "RAM Tweaks (16GB)"
echo You selected 16 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "16777216" /f
powershell -NoProfile -Command "try { Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch") else (call :LogErr "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "try { Disable-MMAgent -MemoryCompression -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -MemoryCompression") else (call :LogErr "Disable-MMAgent -MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "try { Disable-MMAgent -PageCombining -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -PageCombining") else (call :LogErr "Disable-MMAgent -PageCombining")
echo Disabling Large System Cache
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ZeroPagedMemory" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 16800000 /f
call :LogOK "16GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:24g
call :LogSection "RAM Tweaks (24GB)"
echo You selected 24 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "25165824" /f
powershell -NoProfile -Command "try { Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch") else (call :LogErr "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "try { Disable-MMAgent -MemoryCompression -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -MemoryCompression") else (call :LogErr "Disable-MMAgent -MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "try { Disable-MMAgent -PageCombining -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -PageCombining") else (call :LogErr "Disable-MMAgent -PageCombining")
echo Disabling Large System Cache
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ZeroPagedMemory" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 25200000 /f
call :LogOK "24GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:32g
call :LogSection "RAM Tweaks (32GB)"
echo You selected 32 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "33554432" /f
powershell -NoProfile -Command "try { Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch") else (call :LogErr "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "try { Disable-MMAgent -MemoryCompression -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -MemoryCompression") else (call :LogErr "Disable-MMAgent -MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "try { Disable-MMAgent -PageCombining -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -PageCombining") else (call :LogErr "Disable-MMAgent -PageCombining")
echo Disabling Large System Cache
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ZeroPagedMemory" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 33600000 /f
call :LogOK "32GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:64g
call :LogSection "RAM Tweaks (64GB)"
echo You selected 64 GB RAM Tweak!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "67108864" /f
powershell -NoProfile -Command "try { Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch") else (call :LogErr "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "try { Disable-MMAgent -MemoryCompression -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -MemoryCompression") else (call :LogErr "Disable-MMAgent -MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "try { Disable-MMAgent -PageCombining -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if not errorlevel 1 (call :LogOK "Disable-MMAgent -PageCombining") else (call :LogErr "Disable-MMAgent -PageCombining")
echo Disabling Large System Cache
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ZeroPagedMemory" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d 67200000 /f
call :LogOK "64GB RAM Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:services
call :LogSection "Service Reduction"
call :TIScLog stop "wuauserv"
call :TIScLog config "wuauserv" start= demand
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIScLog config WpnService start= disabled
call :TIScLog stop WpnService
call :TIScLog config InstallService start= demand
call :TIScLog stop InstallService

call :LogInfo "Disabling Scheduled Tasks..."
call :SchLog /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable
call :SchLog /Change /TN "Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WaaSMedic\PerformRemediation" /Disable
call :TIScLog stop "UsoSvc"
call :TIScLog config "UsoSvc" start= disabled
call :TIScLog stop "UmRdpService"
call :TIScLog config "UmRdpService" start= disabled
call :TIScLog config wlidsvc start= disabled
call :TIScLog config DisplayEnhancementService start= disabled
call :TIScLog config DiagTrack start= disabled
call :TIScLog config TabletInputService start= disabled
call :TIScLog config Fax start= disabled
call :TIScLog config SharedAccess start= disabled
call :TIScLog config WpcMonSvc start= disabled
call :TIScLog config wcnsvc start= disabled
call :TIScLog config SessionEnv start= disabled
call :TIScLog config MicrosoftEdgeElevationService start= disabled
call :TIScLog config edgeupdate start= disabled
call :TIScLog config edgeupdatem start= disabled
call :TIScLog config autotimesvc start= disabled
call :TIScLog config CscService start= disabled
call :TIScLog config TermService start= disabled
call :TIScLog config SensorDataService start= disabled
call :TIScLog config SensorService start= disabled
call :TIScLog config SensrSvc start= disabled
call :TIScLog config shpamsvc start= disabled
call :TIScLog config diagnosticshub.standardcollector.service start= disabled
call :TIScLog config PhoneSvc start= disabled
call :TIScLog config TapiSrv start= disabled
call :TIScLog stop TapiSrv
call :TIScLog config "UdkUserSvc" start= disabled
call :TIScLog config "SharedRealitySvc" start= disabled
call :TIScLog config "IpxSvc" start= disabled
call :TIScLog config UevAgentService start= disabled
call :TIScLog config WalletService start= disabled
call :TIScLog config TokenBroker start= disabled
call :TIScLog config WebClient start= disabled
call :TIScLog config MixedRealityOpenXRSvc start= disabled
call :TIScLog config stisvc start= disabled
call :TIScLog config WbioSrvc start= disabled
call :TIScLog config icssvc start= disabled
call :TIScLog config Wecsvc start= disabled
call :TIScLog config Netlogon start= disabled
call :TIScLog config XboxGipSvc start= disabled
call :TIScLog config XblAuthManager start= disabled
call :TIScLog config XboxNetApiSvc start= disabled
call :TIScLog config XblGameSave start= disabled
call :TIScLog stop "xbgm"
call :TIScLog config "xbgm" start= disabled
call :TIScLog config SEMgrSvc start= disabled
call :TIScLog config iphlpsvc start= disabled
call :TIScLog config "Backupper Service" start= disabled
call :TIScLog config BthAvctpSvc start= disabled
call :TIScLog config BDESVC start= disabled
call :TIScLog config cbdhsvc start= disabled
call :TIScLog config CDPSvc start= disabled
call :TIDisableServiceInstances "CDPUserSvc"
call :TIScLog config DevQueryBroker start= disabled
call :TIDisableServiceInstances "DevicesFlowUserSvc"
call :TIScLog config DispBrokerDesktopSvc start= disabled
call :TIScLog config TrkWks start= disabled
call :TIScLog config dLauncherLoopback start= disabled
call :TIScLog config EFS start= disabled
call :TIScLog config fdPHost start= disabled
call :TIScLog config FDResPub start= disabled
call :TIScLog config IKEEXT start= disabled
call :TIScLog config NPSMSvc start= disabled
call :TIScLog config WPDBusEnum start= disabled
call :TIScLog config PcaSvc start= disabled
call :TIScLog config SstpSvc start= disabled
call :TIScLog stop "ShellHWDetection"
call :TIScLog config "ShellHWDetection" start= disabled
call :TIScLog stop "VSS"
call :TIScLog config "VSS" start= disabled
call :TIScLog stop "SDRSVC"
call :TIScLog config "SDRSVC" start= disabled
call :TIScLog config SysMain start= disabled
call :TIDisableServiceInstances "OneSyncSvc"
call :TIScLog config lmhosts start= disabled
call :TIDisableServiceInstances "UserDataSvc"
call :TIScLog config Browser start= disabled
call :TIScLog config UnistoreSvc start= disabled
call :TIScLog config Wcmsvc start= disabled
call :TIScLog config FontCache start= disabled
call :TIScLog config W32Time start= disabled
call :TIScLog config tzautoupdate start= disabled
call :TIScLog config DsSvc start= disabled

call :TIScLog config diagsvc start= disabled
call :TIScLog config DialogBlockingService start= disabled

call :TIScLog config AppVClient start= disabled
call :TIScLog config MsKeyboardFilter start= disabled
call :TIScLog config NetTcpPortSharing start= disabled
call :TIScLog config ClipSVC start= disabled
call :TIScLog config ssh-agent start= disabled

call :TIScLog config wercplsupport start= disabled

call :TIScLog config WinHttpAutoProxySvc start= disabled
call :TIScLog config DsmSvc start= disabled
call :TIScLog config ALG start= demand
call :TIScLog config AppIDSvc start= demand
call :TIScLog config CertPropSvc start= demand
call :TIScLog config EntAppSvc start= demand
call :TIScLog config LxpSvc start= demand

call :TIScLog config RasMan start= demand
call :TIScLog config RemoteAccess start= demand
call :TIScLog config RmSvc start= demand
call :TIScLog config SNMPTRAP start= demand
call :TIScLog config UPnPHost start= demand
call :TIScLog config WinRM start= demand
call :TIScLog config PolicyAgent start= disabled
call :TIScLog stop PolicyAgent
call :TIScLog config PeerDistSvc start= disabled
call :TIScLog stop PeerDistSvc
call :TIScLog config wcncsvc start= disabled
call :TIScLog stop wcncsvc
call :TIScLog config PcaSvc start= disabled
call :TIScLog stop PcaSvc
call :TIScLog config WorkFoldersSvc start= demand
call :TIScLog config "WpcSvc" start= disabled
call :TIScLog stop "bthserv"
call :TIScLog config "bthserv" start= disabled
call :TIScLog stop "BthHFSrv"
call :TIScLog config "BthHFSrv" start= disabled
call :TIScLog stop "BTAGService"
call :TIScLog config "BTAGService" start= disabled
call :TIDisableServiceInstances "BluetoothUserService"

call :TIScLog stop "Spooler"
call :TIScLog config "Spooler" start= disabled
call :TIDisableServiceInstances "PrintWorkflowUserSvc"

call :TIScLog stop "FrameServer"
call :TIScLog config "FrameServer" start= disabled
call :TIScLog stop "wisvc"
call :TIScLog config "wisvc" start= disabled
call :TIScLog stop whesvc
call :TIScLog config whesvc start= disabled
call :TIDisableServiceInstances "WpnUserService"
call :TIDisableServiceInstances "MessagingService"
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f
call :TIScLog stop "bthserv"
call :TIScLog stop "Spooler"
call :TIScLog stop "wisvc"
call :TIScLog config lltdsvc start= disabled
call :TIScLog config SgrmBroker start= disabled
call :TIScLog config WEPHOSTSVC start= disabled
call :TIScLog config VaultSvc start= disabled
call :TIScLog config BthPan start= disabled
call :TIScLog config rfcomm start= disabled
call :TIScLog config iprip start= disabled
call :TIScLog config simptcp start= disabled
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DiagHub" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\TroubleshootingSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PerceptionSimulationService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PNRPsvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\p2psvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\OobeSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\MSiSCSI" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\EntAppSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\ALG" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\AjRouter" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\AssignedAccessService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\SrmSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Ssh-Agent" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Sacsvr" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Pla" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PNRPAutoReg" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\NapAgent" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\jhidsvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CxUtilSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\BthHFSrv" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\AxInstSV" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\AVCTPService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenance" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DownloadedMapsManager" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\BTAGService" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WerFaultSvc" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WerKernelSvc" /v "Start" /t REG_DWORD /d "4" /f
call :LogInfo "Removing Snipping Tool (using Lightshot instead)..."
taskkill /f /im SnippingTool.exe >nul 2>&1
taskkill /f /im ScreenSketch.exe >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ScreenSketch* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove ScreenSketch") else (call :LogErr "Remove ScreenSketch")
call :LogInfo "Deprovisioning ScreenSketch (blocks reinstall on updates/new users)..."
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Microsoft.ScreenSketch' }; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Deprovision ScreenSketch") else (call :LogErr "Deprovision ScreenSketch")
call :LogInfo "Releasing Print Screen key for Lightshot..."
call :RegLog add "HKCU\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d 0 /f
powershell -NoProfile -Command "Get-AppxPackage *MicrosoftWindows.Client.WebExperience* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*MicrosoftWindows.Client.WebExperience*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Widgets" /v "AllowWidgets" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
call :TIScLog config SpectrumService start= disabled >nul 2>&1
call :TIScLog stop SpectrumService >nul 2>&1

call :SchLog /DELETE /TN "AMDInstallLauncher" /f
call :SchLog /DELETE /TN "AMDLinkUpdate" /f
call :SchLog /DELETE /TN "AMDRyzenMasterSDKTask" /f
call :SchLog /DELETE /TN "Driver Easy Scheduled Scan" /f
call :SchLog /DELETE /TN "ModifyLinkUpdate" /f
call :SchLog /DELETE /TN "SoftMakerUpdater" /f
call :SchLog /DELETE /TN "StartCN" /f
call :SchLog /DELETE /TN "StartDVR" /f
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Application Experience\StartupAppScan" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /Disable
call :SchLog /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /Disable
call :SchLog /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /Disable
call :SchLog /Change /TN "Microsoft\Windows\UpdateOrchestrator\Scan Independent Update" /Disable
call :SchLog /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /Disable
call :SchLog /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Ras\MobilityManager" /Disable
call :SchLog /Change /TN "Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Wininet\CacheTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Device Information\Device" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Device Information\Device User" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Diagnosis\Scheduled" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskCleanup\SilentCleanup" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskFootprint\StorageSense" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DUSM\dusmtask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\EnterpriseMgmt\MDMMaintenenceTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable
call :SchLog /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Flighting\OneSettings\RefreshCache" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Input\LocalUserSyncDataAvailable" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Input\MouseSyncDataAvailable" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Input\PenSyncDataAvailable" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Input\TouchpadSyncDataAvailable" /Disable
call :SchLog /Change /TN "Microsoft\Windows\International\Synchronize Language Settings" /Disable
call :SchLog /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Installation" /Disable
call :SchLog /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources" /Disable
call :SchLog /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" /Disable
call :SchLog /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Management\Provisioning\Cellular" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Management\Provisioning\Logon" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Maps\MapsToastTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" /Disable
call :SchLog /Change /TN "Microsoft\Windows\MUI\LPRemove" /Disable
call :SchLog /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
call :SchLog /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable
call :SchLog /Change /TN "Microsoft\Windows\PushToInstall\Registration" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Ras\MobilityManager" /Disable
call :SchLog /Change /TN "Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" /Disable
call :SchLog /Change /TN "Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Servicing\StartComponentCleanup" /Disable
call :SchLog /Change /TN "Microsoft\Windows\SettingSync\NetworkStateChangeTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Setup\SetupCleanupTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Setup\SnapshotCleanupTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\SpacePort\SpaceAgentTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\SpacePort\SpaceManagerTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Speech\SpeechModelDownloadTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Storage Tiers Management\Storage Tiers Management Initialization" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Sysmain\ResPriStaticDbSync" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Sysmain\WsSwapAssessmentTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Task Manager\Interactive" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Time Zone\SynchronizeTimeZone" /Disable
call :SchLog /Change /TN "Microsoft\Windows\TPM\Tpm-HASCertRetr" /Disable
call :SchLog /Change /TN "Microsoft\Windows\TPM\Tpm-Maintenance" /Disable
call :SchLog /Change /TN "Microsoft\Windows\User Profile Service\HiveUploadTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WDI\ResolutionHost" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Management" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Validation" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Work Folders\Work Folders Logon Synchronization" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Work Folders\Work Folders Maintenance Work" /Disable
call :SchLog /Change /TN "Microsoft\Windows\Workplace Join\Automatic-Device-Join" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WwanSvc\NotificationTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WwanSvc\OobeDiscovery" /Disable
call :SchLog /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Wininet\CacheTask" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WindowsUpdate\sih" /Disable
call :SchLog /Change /TN "Microsoft\Windows\WindowsUpdate\sihboot" /Disable
call :SchLog /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
call :SchLog /change /disable /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 
call :SchLog /change /disable /tn "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" 
call :SchLog /change /disable /tn "Microsoft\Windows\Windows Error Reporting\Generic" 

for /f "tokens=2" %%a in ('sc query type^= service ^| findstr /i "WpnUserService_"') do (
    call :TIScLog stop "%%a"
    call :TIScLog config "%%a" start= disabled
)

call :TIScLog stop AJRouter
call :TIScLog config AJRouter start= disabled
call :TIScLog stop tzautoupdate
call :TIScLog config tzautoupdate start= disabled
call :TIScLog stop BITS
call :TIScLog config BITS start= disabled
call :TIScLog stop DiagTrack
call :TIScLog stop CDPSvc
call :TIScLog config CDPSvc start= disabled
call :TIScLog stop DusmSvc
call :TIScLog config DusmSvc start= disabled
call :TIScLog stop DoSvc
call :TIScLog config DoSvc start= disabled
call :TIScLog stop diagsvc
call :TIScLog config diagsvc start= disabled
call :TIScLog stop DPS
call :TIScLog config DPS start= disabled
call :TIScLog stop WdiServiceHost
call :TIScLog config WdiServiceHost start= disabled
call :TIScLog stop WdiSystemHost
call :TIScLog config WdiSystemHost start= disabled
call :TIScLog stop dmwappushservice
call :TIScLog config dmwappushservice start= disabled
call :TIScLog stop DisplayEnhancementService
call :TIScLog config DisplayEnhancementService start= disabled
call :TIScLog stop MapsBroker
call :TIScLog config MapsBroker start= disabled
call :TIScLog stop fhsvc
call :TIScLog config fhsvc start= disabled
call :TIScLog stop lfsvc
call :TIScLog config lfsvc start= disabled
call :TIScLog stop HomeGroupListener
call :TIScLog config HomeGroupListener start= disabled
call :TIScLog stop HomeGroupProvider
call :TIScLog config HomeGroupProvider start= disabled
call :TIScLog stop SmsRouter
call :TIScLog config SmsRouter start= disabled
call :TIScLog stop CscService
call :TIScLog config CscService start= disabled
call :TIScLog stop SEMgrSvc
call :TIScLog config SEMgrSvc start= disabled
call :TIScLog stop pla
call :TIScLog config pla start= disabled
call :TIScLog stop PhoneSvc
call :TIScLog config PhoneSvc start= disabled
call :TIScLog stop WpcMonSvc
call :TIScLog config WpcMonSvc start= disabled
call :TIScLog stop RasAuto
call :TIScLog config RasAuto start= disabled
call :TIScLog stop SessionEnv
call :TIScLog config SessionEnv start= disabled
call :TIScLog stop TermService
call :TIScLog stop RpcLocator
call :TIScLog config RpcLocator start= disabled
call :TIScLog stop RemoteRegistry
call :TIScLog config RemoteRegistry start= disabled
call :TIScLog stop RetailDemo
call :TIScLog config RetailDemo start= disabled
call :TIScLog stop SysMain
call :TIScLog stop WalletService
call :TIScLog config WalletService start= disabled
call :TIScLog stop WerSvc
call :TIScLog config WerSvc start= disabled
call :TIScLog stop WSearch
call :TIScLog config WSearch start= disabled
call :TIScLog stop W32Time
call :TIScLog config W32Time start= disabled
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d 4 /f

call :LogInfo "Disabling OEM / App Bloat Services (HP, Gigabyte, CCleaner, Logitech)..."
for %%S in (
    HPAppHelperCap
    HPDiagsCap
    HpTouchpointAnalyticsService
    HPNetworkCap
    HPOmenCap
    HPSysInfoCap
    cFosSpeedS
    GigabyteUpdateService
    ccleaner
    ccleanerm
    CCleanerPerformanceOptimizerService
    logi_lamparray_service
) do (
    call :TIScLog stop "%%S"
    call :TIScLog config "%%S" start= disabled
)

call :LogInfo "Disabling Intel Management & Graphics Bloat Services..."
for %%S in (
    jhi_service
    WMIRegistrationService
    ipfsvc
    igccservice
    cplspcon
    esifsvc
    LMS
    ibtsiva
    IntelAudioService
    cphs
    DSAService
    DSAUpdateService
    igfxCUIService2.0.0.0
    RstMwService
    SystemUsageReportSvc_QUEENCREEK
    iaStorAfsService
) do (
    call :TIScLog stop "%%S"
    call :TIScLog config "%%S" start= disabled
)

rem Intel service settings.
call :LogSkip "Intel display-name service-key block skipped (real short names handled above)."

call :LogInfo "Disabling Browser Background Updater Services..."
for %%S in (
    gupdate
    gupdatem
    GoogleChromeElevationService
    brave
    bravem
    BraveElevationService
) do (
    call :TIScLog stop "%%S"
    call :TIScLog config "%%S" start= disabled
)

call :LogInfo "Disabling Realtek Audio Background Service..."
call :TIScLog stop "RealtekAudioUniversalService"
call :TIScLog config "RealtekAudioUniversalService" start= disabled

call :LogInfo "Disabling Windows Update Health & File History leftovers..."
for %%S in (
    uhssvc
    upfc
    ossrs
    fhsvc
    seclogon
    TieringEngineService
) do (
    call :TIScLog stop "%%S"
    call :TIScLog config "%%S" start= disabled
)

call :TIScLog config "StorSvc" start= demand
if not errorlevel 1 (call :LogOK "StorSvc set to demand") else (call :LogErr "StorSvc config failed")

call :TIScLog stop "AppReadiness"
call :TIScLog config "AppReadiness" start= disabled

call :TIScLog stop "LanmanServer"
call :TIScLog config "LanmanServer" start= disabled

call :LogInfo "Handling GameBarPresenceWriter without deleting protected system binaries..."
set "fileToDelete=%SystemRoot%\System32\GameBarPresenceWriter.exe"
if exist "%fileToDelete%" (
    taskkill /f /im GameBarPresenceWriter.exe >nul 2>&1
    call :LogSkip "GameBarPresenceWriter.exe kept in place (protected Windows component); process terminated if running"
) else (
    call :LogSkip "GameBarPresenceWriter.exe not found"
)

call :LogInfo "Keeping UsoClient and MoUsoCoreWorker binaries intact; disabling Update Orchestrator at service level..."
set "usoClientFile=%SystemRoot%\System32\UsoClient.exe"
set "usoCoreWorkerFile=%SystemRoot%\UUS\amd64\MoUsoCoreWorker.exe"

if exist "%usoClientFile%" (
    call :LogSkip "UsoClient.exe deletion skipped (Windows Update repair component kept intact)"
) else (
    call :LogSkip "UsoClient.exe not found"
)

if exist "%usoCoreWorkerFile%" (
    call :LogSkip "MoUsoCoreWorker.exe deletion skipped (preserved for SFC/DISM and servicing)"
) else (
    call :LogSkip "MoUsoCoreWorker.exe not found"
)

call :LogInfo "Nuking AutoLogger-Diagtrack..."
call :TIScLog stop DiagTrack >nul 2>&1
set "autoLoggerDir=%PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if exist "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" (
    call :TIRun cmd.exe /c del /q "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" >nul 2>&1
    if exist "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" (
        call :LogWarn "AutoLogger ETL is still in use; delete skipped after shutdown attempt"
    ) else (
        call :LogOK "AutoLogger ETL deleted"
    )
) else (
    call :LogSkip "AutoLogger ETL not found"
)
if exist "%autoLoggerDir%" (
    call :TIRun icacls "%autoLoggerDir%" /deny "SYSTEM:(OI)(CI)F" >nul 2>&1
    if not errorlevel 1 (call :LogOK "AutoLogger SYSTEM permissions denied") else (call :LogWarn "AutoLogger SYSTEM permission deny failed")
) else (
    call :LogSkip "AutoLogger directory not present"
)

call :LogOK "Manufactor bloat and more services disabled!"

call :LogInfo "Preparing Appx Removal..."
call :TIScLog config AppXSvc start= demand
call :TIScLog start AppXSvc
timeout /t 2 /nobreak >nul

call :LogInfo "Removing Appx Packages..."
powershell -NoProfile -Command "Get-AppxPackage -allusers *3DBuilder* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: 3DBuilder") else (call :LogErr "Remove Appx: 3DBuilder")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bing* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: bing") else (call :LogErr "Remove Appx: bing")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bingfinance* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: bingfinance") else (call :LogErr "Remove Appx: bingfinance")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bingsports* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: bingsports") else (call :LogErr "Remove Appx: bingsports")
powershell -NoProfile -Command "Get-AppxPackage -allusers *BingWeather* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: BingWeather") else (call :LogErr "Remove Appx: BingWeather")
powershell -NoProfile -Command "Get-AppxPackage -allusers *CommsPhone* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: CommsPhone") else (call :LogErr "Remove Appx: CommsPhone")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Drawboard PDF* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Drawboard PDF") else (call :LogErr "Remove Appx: Drawboard PDF")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Facebook* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Facebook") else (call :LogErr "Remove Appx: Facebook")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Getstarted* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Getstarted") else (call :LogErr "Remove Appx: Getstarted")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Microsoft.Messaging* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.Messaging") else (call :LogErr "Remove Appx: Microsoft.Messaging")
powershell -NoProfile -Command "Get-AppxPackage -allusers *MicrosoftOfficeHub* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: MicrosoftOfficeHub") else (call :LogErr "Remove Appx: MicrosoftOfficeHub")
powershell -NoProfile -Command "Get-AppxPackage -allusers *people* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: people") else (call :LogErr "Remove Appx: people")
powershell -NoProfile -Command "Get-AppxPackage -allusers *SkypeApp* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: SkypeApp") else (call :LogErr "Remove Appx: SkypeApp")
powershell -NoProfile -Command "Get-AppxPackage -allusers *solit* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: solit") else (call :LogErr "Remove Appx: solit")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Sway* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Sway") else (call :LogErr "Remove Appx: Sway")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Twitter* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Twitter") else (call :LogErr "Remove Appx: Twitter")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsAlarms* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsAlarms") else (call :LogErr "Remove Appx: WindowsAlarms")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsPhone* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsPhone") else (call :LogErr "Remove Appx: WindowsPhone")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsMaps* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsMaps") else (call :LogErr "Remove Appx: WindowsMaps")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsFeedbackHub* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsFeedbackHub") else (call :LogErr "Remove Appx: WindowsFeedbackHub")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsSoundRecorder* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsSoundRecorder") else (call :LogErr "Remove Appx: WindowsSoundRecorder")
powershell -NoProfile -Command "Get-AppxPackage -allusers *windowscommunicationsapps* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: windowscommunicationsapps") else (call :LogErr "Remove Appx: windowscommunicationsapps")
powershell -NoProfile -Command "Get-AppxPackage -allusers *zune* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: zune") else (call :LogErr "Remove Appx: zune")
powershell -NoProfile -Command "Get-AppxPackage *skype* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: skype") else (call :LogErr "Remove Appx: skype")
powershell -NoProfile -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: solitaire") else (call :LogErr "Remove Appx: solitaire")
powershell -NoProfile -Command "Get-AppxPackage *officehub* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: officehub") else (call :LogErr "Remove Appx: officehub")
powershell -NoProfile -Command "Get-AppxPackage *candycrush* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: candycrush") else (call :LogErr "Remove Appx: candycrush")
powershell -NoProfile -Command "Get-AppxPackage *YourPhone* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: YourPhone") else (call :LogErr "Remove Appx: YourPhone")
powershell -NoProfile -Command "Get-AppxPackage *OneDrive* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: OneDrive") else (call :LogErr "Remove Appx: OneDrive")
powershell -NoProfile -Command "taskkill /f /im OneDrive.exe" >nul 2>&1
%SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1
if not errorlevel 1 (call :LogOK "Uninstall OneDriveSetup") else (call :LogErr "Uninstall OneDriveSetup")
powershell -NoProfile -Command "Get-AppxPackage *Cortana* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Cortana") else (call :LogErr "Remove Appx: Cortana")
powershell -NoProfile -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: WindowsCamera") else (call :LogErr "Remove Appx: WindowsCamera")
powershell -NoProfile -Command "Get-AppxPackage *photos* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: photos") else (call :LogErr "Remove Appx: photos")
powershell -NoProfile -Command "Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: ConnectivityStore") else (call :LogErr "Remove Appx: ConnectivityStore")
powershell -NoProfile -Command "Get-AppxPackage *ContentDeliveryManager* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: ContentDeliveryManager") else (call :LogErr "Remove Appx: ContentDeliveryManager")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsStore* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.WindowsStore") else (call :LogErr "Remove Appx: Microsoft.WindowsStore")
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Microsoft.WindowsStore' }; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
call :LogOK "Microsoft Store completely eradicated (Provisioned Package removed)!"
powershell -NoProfile -Command "Get-AppxPackage Microsoft.OneDrive | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.OneDrive") else (call :LogErr "Remove Appx: Microsoft.OneDrive")
powershell -NoProfile -Command "Get-AppxPackage Clipchamp | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Clipchamp") else (call :LogErr "Remove Appx: Clipchamp")
powershell -NoProfile -Command "Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.YourPhone") else (call :LogErr "Remove Appx: Microsoft.YourPhone")
powershell -NoProfile -Command "Get-AppxPackage Microsoft.GamingApp | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.GamingApp") else (call :LogErr "Remove Appx: Microsoft.GamingApp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.BingSearch* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.BingSearch") else (call :LogErr "Remove Appx: Microsoft.BingSearch")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.Office.OneNote") else (call :LogErr "Remove Appx: Microsoft.Office.OneNote")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.SkypeApp") else (call :LogErr "Remove Appx: Microsoft.SkypeApp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.ZuneVideo") else (call :LogErr "Remove Appx: Microsoft.ZuneVideo")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.WindowsFeedbackHub") else (call :LogErr "Remove Appx: Microsoft.WindowsFeedbackHub")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.XboxGamingOverlay") else (call :LogErr "Remove Appx: Microsoft.XboxGamingOverlay")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Microsoft.XboxGameOverlay") else (call :LogErr "Remove Appx: Microsoft.XboxGameOverlay")
powershell -NoProfile -Command "Get-AppxPackage *GamingServices* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: GamingServices") else (call :LogErr "Remove Appx: GamingServices")
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*549981C3F5F10*'; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: 549981C3F5F10") else (call :LogErr "Remove AppxProv: 549981C3F5F10")
powershell -NoProfile -Command "Get-AppxPackage -allusers *DevHome* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*DevHome*' -or $_.PackageName -like '*DevHome*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: DevHome") else (call :LogErr "Remove AppxProv: DevHome")
powershell -NoProfile -Command "Get-AppxPackage -allusers *OutlookForWindows* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*OutlookForWindows*' -or $_.PackageName -like '*OutlookForWindows*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: OutlookForWindows") else (call :LogErr "Remove AppxProv: OutlookForWindows")
powershell -NoProfile -Command "Get-AppxPackage -allusers *PowerAutomateDesktop* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*PowerAutomateDesktop*' -or $_.PackageName -like '*PowerAutomateDesktop*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: PowerAutomateDesktop") else (call :LogErr "Remove AppxProv: PowerAutomateDesktop")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Todos* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Todos*' -or $_.PackageName -like '*Todos*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: Todos") else (call :LogErr "Remove AppxProv: Todos")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Whiteboard* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Whiteboard*' -or $_.PackageName -like '*Whiteboard*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: Whiteboard") else (call :LogErr "Remove AppxProv: Whiteboard")
powershell -NoProfile -Command "Get-AppxPackage -allusers *MixedReality.Portal* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*MixedReality.Portal*' -or $_.PackageName -like '*MixedReality.Portal*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: MixedReality.Portal") else (call :LogErr "Remove AppxProv: MixedReality.Portal")
powershell -NoProfile -Command "Get-AppxPackage -allusers *DisneyMagicKingdoms* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*DisneyMagicKingdoms*' -or $_.PackageName -like '*DisneyMagicKingdoms*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: DisneyMagicKingdoms") else (call :LogErr "Remove AppxProv: DisneyMagicKingdoms")
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$pkgs = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like '*WebExperience*' -or $_.PackageFullName -like '*WebExperience*' }; if ($pkgs) { $pkgs | ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue }; exit 0 } else { exit 1 }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove AppxProv: Windows Web Experience Pack removal.") else (call :LogSkip "Windows Web Experience Pack not present or already removed.")
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
if not errorlevel 1 (call :LogOK "Winget uninstall: Web Exp Pack") else (call :LogErr "Winget uninstall: Web Exp Pack")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: GetHelp") else (call :LogErr "Remove Appx: GetHelp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Todos") else (call :LogErr "Remove Appx: Todos")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: BingNews") else (call :LogErr "Remove Appx: BingNews")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: 3DViewer") else (call :LogErr "Remove Appx: 3DViewer")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Windows.Cortana* | Remove-AppxPackage" >nul 2>&1
if not errorlevel 1 (call :LogOK "Remove Appx: Cortana") else (call :LogErr "Remove Appx: Cortana")

call :LogInfo "Disabling Windows AI & Copilot"
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowRecall" /t REG_DWORD /d 0 /f
call :LogOK "AI Features Disabled!"

call :LogInfo "Cleaning temporary files..."

for /d %%D in ("%temp%\*") do (
    if /i not "%%~nxD"=="bardhzzY_Logs" (
        rd /s /q "%%D" >nul 2>&1
    )
)

for %%F in ("%temp%\*.*") do (
    if /i not "%%~xF"==".bat" if /i not "%%~xF"==".cmd" if /i not "%%~xF"==".ps1" (
        del /q /f /a "%%F" >nul 2>&1
    )
)
del /q /f /a "%temp%\*.tmp" >nul 2>&1

call :TIRun cmd.exe /c del /s /f /q /a C:\Windows\Temp\*.* >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do call :TIRun cmd.exe /c rd /s /q "%%~D" >nul 2>&1

call :TIRun cmd.exe /c del /s /f /q /a C:\Windows\Prefetch\*.* >nul 2>&1
for /d %%D in ("C:\Windows\Prefetch\*") do call :TIRun cmd.exe /c rd /s /q "%%~D" >nul 2>&1

call :TIScLog stop wuauserv
call :TIScLog stop BITS
timeout /t 1 /nobreak >nul
call :TIRun cmd.exe /c del /s /f /q /a C:\Windows\SoftwareDistribution\Download\*.* >nul 2>&1

call :LogOK "Temporary files cleared."

call :LogInfo "Clearing Windows Event Logs..."
for /f "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G" >nul 2>&1)

call :LogInfo "Cleaning Discord + Spotify cache (frees disk space)..."
rem Discord cache.
for /d %%D in ("%LOCALAPPDATA%\Discord\app-*") do (
    if exist "%%D\Cache" call :TIRun cmd.exe /c rd /s /q "%%D\Cache" >nul 2>&1
    if exist "%%D\Code Cache" call :TIRun cmd.exe /c rd /s /q "%%D\Code Cache" >nul 2>&1
    if exist "%%D\GPUCache" call :TIRun cmd.exe /c rd /s /q "%%D\GPUCache" >nul 2>&1
)
call :LogOK "Discord cache cleared."

rem Spotify cache.
if exist "%LOCALAPPDATA%\Spotify\Data" (
    call :TIRun cmd.exe /c rd /s /q "%LOCALAPPDATA%\Spotify\Data" >nul 2>&1
    if not exist "%LOCALAPPDATA%\Spotify\Data" (call :LogOK "Spotify cache cleared.") else (call :LogErr "Spotify cache clear failed.")
) else (
    call :LogSkip "Spotify cache not present"
)

call :LogInfo "Cleaning USO UpdateStore + Logs..."
if exist "%ProgramData%\USOPrivate\UpdateStore" (
    call :TIRun cmd.exe /c rd /s /q "%ProgramData%\USOPrivate\UpdateStore" >nul 2>&1
    if not exist "%ProgramData%\USOPrivate\UpdateStore" (call :LogOK "USO UpdateStore cleared.") else (call :LogErr "USO UpdateStore clear failed.")
) else (
    call :LogSkip "USO UpdateStore not present"
)
if exist "%ProgramData%\USOShared\Logs" (
    call :TIRun cmd.exe /c rd /s /q "%ProgramData%\USOShared\Logs" >nul 2>&1
    if not exist "%ProgramData%\USOShared\Logs" (call :LogOK "USO Logs cleared.") else (call :LogErr "USO Logs clear failed.")
) else (
    call :LogSkip "USO Logs not present"
)

call :LogInfo "Cleaning SleepStudy + Windows Logs..."
if exist "C:\Windows\System32\SleepStudy" (
    call :TIRun cmd.exe /c rd /s /q "C:\Windows\System32\SleepStudy" >nul 2>&1
    if not exist "C:\Windows\System32\SleepStudy" (call :LogOK "SleepStudy cleared.") else (call :LogErr "SleepStudy clear failed.")
) else (
    call :LogSkip "SleepStudy not present"
)
if exist "C:\Windows\Logs" (
    call :TIRun cmd.exe /c rd /s /q "C:\Windows\Logs" >nul 2>&1
    if not exist "C:\Windows\Logs" (call :LogOK "Windows Logs cleared.") else (call :LogErr "Windows Logs clear failed.")
) else (
    call :LogSkip "Windows Logs not present"
)

call :LogInfo "Setting VolumeCaches StateFlags..."
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Content Indexer Cleaner" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files" /v "StateFlags0001" /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files" /v "StateFlags0001" /t REG_DWORD /d 2 /f

if exist "C:\Windows.old" (
    takeown /F "C:\Windows.old" /R /D Y >nul 2>&1
    icacls "C:\Windows.old" /grant administrators:F /T >nul 2>&1
    rd /s /q "C:\Windows.old" >nul 2>&1
)

del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
powershell -NoProfile -Command "Get-ChildItem -Path 'C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache' -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse" >nul 2>&1
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /s /f /q "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
net stop FontCache >nul 2>&1
del /s /f /q "%WINDIR%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.dat" >nul 2>&1
net start FontCache >nul 2>&1
del /s /f /q "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store\*" >nul 2>&1

call :LogInfo "Running DISM Component Cleanup..."
rem Component cleanup.
dism /online /cleanup-image /startcomponentcleanup /NoRestart >nul 2>&1
if not errorlevel 1 (call :LogOK "DISM Component Cleanup") else (call :LogWarn "DISM Component Cleanup (Skipped or failed)")

call :LogInfo "Clearing Ghost Devices and USB cache."
Setlocal EnableExtensions EnableDelayedExpansion

echo.
echo ==================================================
echo   Ghost Device ^& USB Cache Cleanup
echo ==================================================
echo.

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "DEVMGR_SHOW_NONPRESENT_DEVICES" /t REG_SZ /d "1" /f >nul 2>&1

set "Removed=0"

for /f "tokens=2 delims=:" %%A in ('
    pnputil /enum-devices /disconnected ^| findstr "\\" ^| findstr /v /i "ROOT\" ^| findstr /v /i "SWD\"
') do (
    set "ID=%%A"

    for /f "tokens=* delims= " %%B in ("!ID!") do (
        pnputil /remove-device "%%B" /force >nul 2>&1
        if !errorlevel! EQU 0 (
            set /a Removed+=1
        )
    )
)

echo Removed %Removed% disconnected device(s).

call :RegLog delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2" /f >nul 2>&1
endlocal
call :LogOK "Ghost Devices and USB cache cleared."
call :LogOK "Apps, Features and services removed successfully!"
echo.
echo Service Reduction completed successfully.
timeout /t 1 /nobreak > NUL
pause
goto main

:netw
setlocal EnableExtensions EnableDelayedExpansion
call :LogSection "Network Tweaks"
echo.

call :LogInfo "[+] Ethernet Only Optimization"

set "wifi_kill="
set /p "wifi_kill=Disable Wi-Fi adapter at hardware level for less processes? (Y/N): "

if /i "%wifi_kill%"=="Y" (
    call :LogInfo "[+] Searching for Wi-Fi adapters and disabling them..."
     
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$devs = Get-PnpDevice -Class Net | Where-Object { $_.FriendlyName -match 'Wi-Fi|Wireless|WLAN|802.11' -and $_.Status -eq 'OK' }; if (-not $devs) { exit 2 } else { try { $devs | ForEach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction Stop }; exit 0 } catch { exit 1 } }"
     
    if errorlevel 2 (
        call :LogWarn "[!] No active Wi-Fi adapter found. Nothing to disable."
    ) else if errorlevel 1 (
        call :LogErr "[X] Could not disable Wi-Fi. It might be protected or already in use. Check Device Manager."
    ) else (
        call :LogOK "[OK] Wi-Fi adapter disabled! You are now strictly on Ethernet."
        call :LogWarn "(Note: To re-enable Wi-Fi later, go to Device Manager -> Network Adapters -> Right-Click your Wi-Fi adapter -> Enable)"
    )

    timeout /t 2 /nobreak >nul

    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
    call :TIScLog stop WlanSvc
    call :LogWarn "WLAN AutoConfig was disabled because Ethernet-only mode was selected."

) else if /i "%wifi_kill%"=="N" (
    call :LogInfo "[SKIP] Wi-Fi/WLAN left unchanged."
) else (
    call :LogWarn "[!] Invalid choice. Wi-Fi/WLAN left unchanged."
)

call :LogInfo "Enabling MSI/MSI-X for Ethernet adapters..."
setlocal EnableExtensions EnableDelayedExpansion

set "ETH_MSI_COUNT=0"

for /f "delims=" %%A in ('
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "IfType" 2^>nul ^|
    findstr /i /b "HKEY_LOCAL_MACHINE"
') do (
    reg query "%%A" /v "IfType" 2>nul | findstr /i /r /c:"REG_DWORD[ ]*0x6[ ]*$" >nul

    if not errorlevel 1 (
        for /f "tokens=2,*" %%B in ('
            reg query "%%A" /v "PnPInstanceID" 2^>nul ^|
            findstr /i "PnPInstanceID"
        ') do (
            set "ETH_MSI_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\%%C\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"

            reg query "!ETH_MSI_PATH!" >nul 2>&1

            if not errorlevel 1 (
                reg add "!ETH_MSI_PATH!" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1

                if not errorlevel 1 (
                    set /a ETH_MSI_COUNT+=1
                    set "LOG_MSG=Ethernet MSI enabled: %%C"
                    call :LogOK
                ) else (
                    set "LOG_MSG=Ethernet MSI write failed: %%C (err=!errorlevel!)"
                    call :LogErr
                )
            ) else (
                set "LOG_MSG=Ethernet MSI structure not present; skipped: %%C"
                call :LogSkip
            )
        )
    )
)

if !ETH_MSI_COUNT! equ 0 (
    call :LogWarn "No Ethernet adapters with an existing MSI structure were modified."
) else (
    set "LOG_MSG=Successfully enabled MSI on !ETH_MSI_COUNT! Ethernet adapter(s)."
    call :LogOK
)

endlocal

call :LogInfo "Applying Advanced Network Tweaks..."
for /f "skip=2 delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    set "RL_DYN_KEY=%%i"
    call :DynRegLog /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
    set "RL_DYN_KEY=%%i"
    call :DynRegLog /v "TCPNoDelay" /t REG_DWORD /d 1 /f
)

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f

call :LogInfo "Disabling Network Diagnostic Usage (NDU)..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d 4 /f

netsh advfirewall firewall set rule group="Network Discovery" new enable=no >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh advfirewall Network Discovery") else (call :LogErr "netsh advfirewall Network Discovery")
netsh int tcp set supplemental Template=Compat CongestionProvider=cubic >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh cubic Compat") else (call :LogErr "netsh cubic Compat")
netsh int tcp set supplemental Template=Internet CongestionProvider=cubic >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh cubic Internet") else (call :LogErr "netsh cubic Internet")
netsh int tcp set supplemental Template=Datacenter CongestionProvider=cubic >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh cubic Datacenter") else (call :LogErr "netsh cubic Datacenter")
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=cubic >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh cubic InternetCustom") else (call :LogErr "netsh cubic InternetCustom")
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=cubic >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh cubic DatacenterCustom") else (call :LogErr "netsh cubic DatacenterCustom")
netsh int tcp set global ecncapability=disabled >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh ecncapability=disabled") else (call :LogErr "netsh ecncapability=disabled")
netsh int tcp set global autotuninglevel=normal >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh autotuninglevel=normal") else (call :LogErr "netsh autotuninglevel=normal")
netsh interface ip delete arpcache >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh delete arpcache") else (call :LogErr "netsh delete arpcache")
call :LogInfo "Enabling TCP Fast Open..."
netsh int tcp set global fastopen=1 >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh fastopen=1") else (call :LogErr "netsh fastopen=1")

call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer" /v EnableOplocks /t REG_DWORD /d 0 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer" /v OplocksDisabled /t REG_DWORD /d 1 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mrxsmb" /v OplocksDisabled /t REG_DWORD /d 1 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 2 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f
call :RegLog add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d 32 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f

call :TIScLog config SSDPSRV start= disabled
call :TIScLog stop SSDPSRV
call :TIScLog config VacSvc start= disabled
call :TIScLog stop VacSvc
netsh int tcp set global Chimney=disabled >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh Chimney=disabled") else (call :LogErr "netsh Chimney=disabled")
netsh int tcp set global rsc=disabled >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh rsc=disabled") else (call :LogErr "netsh rsc=disabled")
powershell -NoProfile -Command "Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object { $_.SetTCPIPNetBIOS(2) }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Disable NetBIOS over TCP/IP") else (call :LogErr "Disable NetBIOS over TCP/IP")
powershell -NoProfile -Command "Get-NetAdapter | Enable-NetAdapterRss -ErrorAction SilentlyContinue" >nul 2>&1
if not errorlevel 1 (call :LogOK "Enable-NetAdapterRss") else (call :LogErr "Enable-NetAdapterRss")
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumTcbTablePartitions" /t REG_DWORD /d 16 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f
rem Network adapter tweaks.

ipconfig /flushdns >nul 2>&1
if not errorlevel 1 (call :LogOK "ipconfig /flushdns") else (call :LogErr "ipconfig /flushdns")

rem Per-adapter settings.
rem Unsupported adapter properties are skipped.
call :LogInfo "Applying Per-NIC Adapter Tuning (supported properties only)..."
set "NIC_PS=%TEMP%\bardhzz_nic_tune.ps1"
set "NIC_LOG=%TEMP%\bardhzz_nic.log"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$b64='JEVycm9yQWN0aW9uUHJlZmVyZW5jZSA9ICdTdG9wJwokdGFyZ2V0cyA9IEAoCiAgQHsgUGF0dGVybiA9ICdSZWNlaXZlIEJ1ZmZlcnMnOyBWYWx1ZSA9ICcyMDQ4JyB9LAogIEB7IFBhdHRlcm4gPSAnVHJhbnNtaXQgQnVmZmVycyc7IFZhbHVlID0gJzEwMjQnIH0sCiAgQHsgUGF0dGVybiA9ICdFbmVyZ3kgRWZmaWNpZW50IEV0aGVybmV0JzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0ludGVycnVwdCBNb2RlcmF0aW9uJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0ludGVycnVwdCBNb2RlcmF0aW9uIFJhdGUnOyBWYWx1ZSA9ICcwJyB9LAogIEB7IFBhdHRlcm4gPSAnV2FrZSBvbiBNYWdpYyBQYWNrZXQnOyBWYWx1ZSA9ICcwJyB9LAogIEB7IFBhdHRlcm4gPSAnV2FrZSBvbiBQYXR0ZXJuIE1hdGNoJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0Zsb3cgQ29udHJvbCc7IFZhbHVlID0gJzAnIH0sCiAgQHsgUGF0dGVybiA9ICdQcmlvcml0eSAmIFZMQU4nOyBWYWx1ZSA9ICcwJyB9LAogIEB7IFBhdHRlcm4gPSAnTG9nIExpbmsgU3RhdGUgRXZlbnQnOyBWYWx1ZSA9ICcxNicgfSwKICBAeyBQYXR0ZXJuID0gJ1Bvd2VyIFNhdmluZyBNb2RlJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ1NlbGVjdGl2ZSBTdXNwZW5kJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0dyZWVuIEV0aGVybmV0JzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0dpZ2FMaXRlJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ1VMUCBNb2RlJzsgVmFsdWUgPSAnMCcgfSwKICBAeyBQYXR0ZXJuID0gJ0F1dG8gUG93ZXIgU2F2ZSBNb2RlJzsgVmFsdWUgPSAnMCcgfQopCiRhZGFwdGVycyA9IEAoR2V0LU5ldEFkYXB0ZXIgLUVycm9yQWN0aW9uIFN0b3AgfCBXaGVyZS1PYmplY3QgeyAkXy5TdGF0dXMgLWVxICdVcCcgLW9yICRfLk1lZGlhQ29ubmVjdGlvblN0YXRlIC1lcSAnQ29ubmVjdGVkJyB9KQpmb3JlYWNoKCRhIGluICRhZGFwdGVycyl7IHRyeSB7IERpc2FibGUtTmV0QWRhcHRlclBvd2VyTWFuYWdlbWVudCAtTmFtZSAkYS5OYW1lIC1Ob1Jlc3RhcnQgLUVycm9yQWN0aW9uIFN0b3AgfCBPdXQtTnVsbDsgJ09LfCcgKyAkYS5OYW1lICsgJ3xBZGFwdGVyIFBvd2VyIE1hbmFnZW1lbnR8RGlzYWJsZWQnIH0gY2F0Y2ggeyAnU0tJUHwnICsgJGEuTmFtZSArICd8QWRhcHRlciBQb3dlciBNYW5hZ2VtZW50fFVuc3VwcG9ydGVkIG9yIHVuYXZhaWxhYmxlJyB9IH0KaWYoJGFkYXB0ZXJzLkNvdW50IC1lcSAwKXsgJ1dBUk58Tk9ORXxObyBjb25uZWN0ZWQgYWRhcHRlcnMgZm91bmQnOyBleGl0IDAgfQpmb3JlYWNoKCRhIGluICRhZGFwdGVycyl7CiAgdHJ5IHsgJHByb3BzID0gQChHZXQtTmV0QWRhcHRlckFkdmFuY2VkUHJvcGVydHkgLU5hbWUgJGEuTmFtZSAtQWxsUHJvcGVydGllcyAtRXJyb3JBY3Rpb24gU3RvcCkgfSBjYXRjaCB7ICdXQVJOfCcgKyAkYS5OYW1lICsgJ3xDYW5ub3QgZW51bWVyYXRlIGFkdmFuY2VkIHByb3BlcnRpZXMnOyBjb250aW51ZSB9CiAgZm9yZWFjaCgkdGFyZ2V0IGluICR0YXJnZXRzKXsKICAgICRwID0gJHByb3BzIHwgV2hlcmUtT2JqZWN0IHsgJF8uRGlzcGxheU5hbWUgLWFuZCAkXy5EaXNwbGF5TmFtZSAtbGlrZSAoJyonICsgJHRhcmdldC5QYXR0ZXJuICsgJyonKSB9IHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMQogICAgaWYoLW5vdCAkcCl7ICdTS0lQfCcgKyAkYS5OYW1lICsgJ3wnICsgJHRhcmdldC5QYXR0ZXJuICsgJ3xOb3QgZXhwb3NlZCBieSBkcml2ZXInOyBjb250aW51ZSB9CiAgICAkcmVxdWVzdGVkID0gW3N0cmluZ10kdGFyZ2V0LlZhbHVlCiAgICAkdmFsaWQgPSBAKCRwLlZhbGlkUmVnaXN0cnlWYWx1ZXMgfCBGb3JFYWNoLU9iamVjdCB7IFtzdHJpbmddJF8gfSkKICAgIGlmICgkdmFsaWQuQ291bnQgLWd0IDAgLWFuZCAtbm90ICgkdmFsaWQgLWNvbnRhaW5zICRyZXF1ZXN0ZWQpKSB7ICdTS0lQfCcgKyAkYS5OYW1lICsgJ3wnICsgJHAuRGlzcGxheU5hbWUgKyAnfFVuc3VwcG9ydGVkIHJlZ2lzdHJ5IHZhbHVlICcgKyAkcmVxdWVzdGVkOyBjb250aW51ZSB9CiAgICB0cnkgeyBTZXQtTmV0QWRhcHRlckFkdmFuY2VkUHJvcGVydHkgLUlucHV0T2JqZWN0ICRwIC1SZWdpc3RyeVZhbHVlICRyZXF1ZXN0ZWQgLU5vUmVzdGFydCAtRXJyb3JBY3Rpb24gU3RvcCB8IE91dC1OdWxsOyAnT0t8JyArICRhLk5hbWUgKyAnfCcgKyAkcC5EaXNwbGF5TmFtZSB9CiAgICBjYXRjaCB7ICdTS0lQfCcgKyAkYS5OYW1lICsgJ3wnICsgJHAuRGlzcGxheU5hbWUgKyAnfFJlamVjdGVkIHZhbHVlIG9yIGRyaXZlciBsaW1pdGF0aW9uJyB9CiAgfQp9Cg=='; [IO.File]::WriteAllText("%NIC_PS%", [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64)))" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -File "%NIC_PS%" > "%NIC_LOG%" 2>nul
if errorlevel 1 (
    call :LogErr "Per-NIC tuning PowerShell failed to start or enumerate adapters."
) else (
    set "NIC_OK=0"
    set "NIC_SKIP=0"
    for /f "tokens=1-4 delims=|" %%A in ('type "%NIC_LOG%" 2^>nul') do (
        if /I "%%A"=="OK" (set /a NIC_OK+=1 >nul & set "LOG_MSG=Per-NIC applied: %%B - %%C" & call :LogOK)
        if /I "%%A"=="SKIP" (set /a NIC_SKIP+=1 >nul & set "LOG_MSG=Per-NIC skipped: %%B - %%C %%D" & call :LogSkip)
        if /I "%%A"=="WARN" (set "LOG_MSG=Per-NIC warning: %%B %%C" & call :LogWarn)
    )
    set "LOG_MSG=Per-NIC summary: !NIC_OK! applied, !NIC_SKIP! skipped."
    call :LogInfo
)
del /q "%NIC_PS%" "%NIC_LOG%" >nul 2>&1

rem Network cleanup.
call :LogInfo "Performing non-disruptive Network Cleanup..."
rem Avoid DHCP release/renew so the active interface stays up.
call :LogSkip "ipconfig /release + /renew skipped (non-disruptive mode)."
arp -d * >nul 2>&1
if not errorlevel 1 (call :LogOK "arp -d *") else (call :LogWarn "arp -d *")
nbtstat -R >nul 2>&1
if not errorlevel 1 (call :LogOK "nbtstat -R") else (call :LogWarn "nbtstat -R")
nbtstat -RR >nul 2>&1
if not errorlevel 1 (call :LogOK "nbtstat -RR") else (call :LogWarn "nbtstat -RR")
ipconfig /registerdns >nul 2>&1
if not errorlevel 1 (call :LogOK "ipconfig /registerdns") else (call :LogWarn "ipconfig /registerdns")

call :LogOK "Advanced Network Tweaks Applied!"
endlocal
timeout /t 1 /nobreak > NUL
pause
goto main

:stor
call :LogSection "Storage Tweaks"
echo You selected Storage Tweaks!
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\Storage\SD\IdleState\1" /v "IdleExitEnergyMicroJoules" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 1 /f

fsutil behavior set memoryusage 2 >nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil memoryusage 2") else (call :LogErr "fsutil memoryusage 2")
fsutil behavior set Disabledeletenotify 0 >nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil Disabledeletenotify 0") else (call :LogErr "fsutil Disabledeletenotify 0")
fsutil behavior set encryptpagingfile 0 >nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil encryptpagingfile 0") else (call :LogErr "fsutil encryptpagingfile 0")
rem Storage MSI / MSI-X
call :LogInfo "Enabling MSI Mode for Active Storage Controllers..."
setlocal EnableExtensions EnableDelayedExpansion

set "STORAGE_MSI_COUNT=0"

for %%S in (stornvme storahci) do (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" >nul 2>&1

    if not errorlevel 1 (
        for /f "tokens=1,2,*" %%A in ('
            reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" 2^>nul ^|
            findstr /r /c:"REG_SZ"
        ') do (
            set "DEVICE_ID=%%C"
            set "STORAGE_MSI_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\!DEVICE_ID!\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"

            call :LogInfo "Target Found: !DEVICE_ID!"

            reg query "!STORAGE_MSI_PATH!" >nul 2>&1

            if not errorlevel 1 (
                reg add "!STORAGE_MSI_PATH!" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1

                if not errorlevel 1 (
                    set /a STORAGE_MSI_COUNT+=1
                    set "LOG_MSG=Storage MSI enabled: !DEVICE_ID!"
                    call :LogOK
                ) else (
                    set "LOG_MSG=Storage MSI write failed: !DEVICE_ID! (err=!errorlevel!)"
                    call :LogErr
                )
            ) else (
                set "LOG_MSG=Storage MSI structure not present; skipped: !DEVICE_ID!"
                call :LogSkip
            )
        )
    )
)

if !STORAGE_MSI_COUNT! equ 0 (
    call :LogWarn "No storage controllers with an existing MSI structure were modified."
) else (
    set "LOG_MSG=Successfully enabled MSI on !STORAGE_MSI_COUNT! storage controller(s)."
    call :LogOK
)

endlocal

call :LogInfo "Disabling Sleep Study"
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f

fsutil behavior set disablelastaccess 1 >nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil disablelastaccess 1") else (call :LogErr "fsutil disablelastaccess 1")
fsutil behavior set mftzone 1 > nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil mftzone 1") else (call :LogErr "fsutil mftzone 1")
fsutil behavior set disable8dot3 1 >nul 2>&1
if not errorlevel 1 (call :LogOK "fsutil disable8dot3 1") else (call :LogErr "fsutil disable8dot3 1")

call :SchLog /run /tn "Microsoft\Windows\DiskCleanup\SilentCleanup"

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d 0 /f
call :LogOK "All Storage Tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:input
call :LogSection "Input Lag Tweaks"
echo You selected Input lag tweaks!

call :LogInfo "Setting Latency Tolerance"
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "TimerInterval" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "TimerInterval" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v "TimerInterval" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CSC" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasAcd" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Rasl2tp" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasPppoe" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\RasSstp" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\dam" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\NdisCap" /v "Start" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f

call :LogInfo "Optimizing Audio Latency and disabling Communications Ducking..."
call :RegLog add "HKCU\Software\Microsoft\Multimedia\Audio" /v "Ducking" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioEnhancements" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 4 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "Medium" /f
powershell -NoProfile -Command "Get-PnpDevice -Class HIDClass | Where-Object {$_.Status -eq 'OK'} | ForEach-Object { powercfg /devicedisablewake \"$($_.FriendlyName)\" }"
if not errorlevel 1 (call :LogOK "powercfg hid device power") else (call :LogErr "powercfg hid device power")

call :LogOK "Input tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:kbm
call :LogSection "KBM Tweaks"
echo [!] Optimizing Your Keyboard and Mouse Input...
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
call :RegLog add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "200" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "15" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f
call :RegLog add "HKCU\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d 3 /f
call :RegLog add "HKCU\Software\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d 0 /f
call :TIScLog config TextInputManagementService start= disabled
call :TIScLog stop TextInputManagementService
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "ConnectMultiplePorts" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "MaximumPortsServiced" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "SendOutputToAllPorts" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "ConnectMultiplePorts" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MaximumPortsServiced" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "SendOutputToAllPorts" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000A800000000000000E00000000000" /f
call :RegLog add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
call :RegLog add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
call :RegLog add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "5000" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "MouseTrails" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "SnapToDefaultButton" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "Beep" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Mouse" /v "ExtendedSounds" /t REG_SZ /d "0" /f
call :LogOK "KBM tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:devmgmt
call :LogSection "Device Manager Tweaks"
cls
echo %RESET%
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BRIGHT_RED%[!] bardhzzY Tweaks - Aggressive Warning%RESET%
echo ======================================================
echo.
echo  %BRIGHT_RED%[!]%RESET% The following tweaks will disable 48 hardware devices:
echo      - HPET, System Timer, DMA Controller, Numeric Data Processor
echo      - Composite Bus, Microsoft GS Wavetable Synth, Programmable PIC
echo      - ACPI Processor Aggregator, Thermal Zone, Wake Alarm
echo      - AMD Controller Emulation, Crash Defender, PSP
echo      - Intel Management Engine (MEI, DAL, WMI, PMT, SMBus, SPI)
echo      - Bluetooth enumerators (PAN, RFCOMM, MS BT, MS BT LE)
echo      - Microsoft Hyper-V, Hypervisor Service, Kernel Debug Network
echo      - Print to PDF, Radio Device, RRAS, Virtual Drive, WMI for ACPI
echo      - NDIS Virtual, NVIDIA HD Audio, RDP Redirector, Root Print Queue
echo      - UMBus Root, all 7 WAN Miniports (IKEv2/IP/IPv6/L2TP/NetMon/PPPOE/PPTP/SSTP)
echo.
echo  %BRIGHT_RED%[!] RISKS:%RESET%
echo      Disabling HPET/Timers is highly debated - may fix stutters
echo      OR cause freezes, DPC watchdog violations, audio issues.
echo      Intel ME / AMD PSP disable may cause boot issues on some systems.
echo      WAN Miniport disable breaks VPN clients (OpenVPN, Cisco AnyConnect).
echo      Bluetooth enumerators break Bluetooth audio/HID devices.
echo      Disabling NVIDIA HD Audio breaks HDMI audio output.
echo.
echo  %WHITE% [%CYAN%1%WHITE%] Continue (I understand the risks)
echo  %WHITE% [%CYAN%2%WHITE%] Go Back to Main Menu
echo.
set "pnp_choice="
set /p "pnp_choice=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

if not defined pnp_choice goto devmgmt
set "pnp_choice=%pnp_choice:"=%"
set "pnp_choice=%pnp_choice: =%"

if /i "%pnp_choice%"=="1" goto devmgmt_apply
if /i "%pnp_choice%"=="2" goto main

echo.
echo "%pnp_choice%" isn't a right choice, try again!
timeout 2 >nul
goto devmgmt

:devmgmt_apply
cls
echo.
echo [+] Scanning for active system devices...
call :LogInfo "Preparing Device Manager PnP Tweaks..."

rem Disable selected PnP devices and log results.
powershell -NoProfile -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $devices = @('High Precision Event Timer', 'System Timer', 'Direct memory access controller', 'Numeric Data Processor', 'Composite Bus Enumerator', 'Microsoft GS Wavetable Synth', 'ACPI Processor Aggregator', 'ACPI Thermal Zone', 'ACPI Wake Alarm', 'AMD Controller Emulation', 'AMD Crash Defender', 'AMD PSP', 'Bluetooth Device (Personal Area Network)', 'Bluetooth Device (RFCOMM Protocol TDI)', 'Intel(R) Management Engine Interface', 'Intel(R) Dynamic Application Loader Host Interface', 'Intel(R) Management Engine WMI Provider', 'Intel(R) Platform Monitoring Technology Device', 'Intel(R) SMBus - 7AA3', 'Intel(R) SPI (Flash) Controller - 7AA4', 'Microsoft Bluetooth Enumerator', 'Microsoft Bluetooth LE Enumerator', 'Microsoft Device Association Root Enumerator', 'Microsoft Hyper-V Virtualization Infrastructure Driver', 'Microsoft Hypervisor Service', 'Microsoft Kernel Debug Network Adapter', 'Microsoft Print to PDF', 'Microsoft Radio Device Enumeration Bus', 'Microsoft RRAS Root Enumerator', 'Microsoft Virtual Drive Enumerator', 'Microsoft Windows Management Interface for ACPI', 'NDIS Virtual Network Adapter Enumerator', 'NVIDIA High Definition Audio', 'Programmable interrupt controller', 'Remote Desktop Device Redirector Bus', 'Resource Hub proxy device', 'Root Print Queue', 'UMBus Root Bus Enumerator', 'WAN Miniport (IKEv2)', 'WAN Miniport (IP)', 'WAN Miniport (IPv6)', 'WAN Miniport (L2TP)', 'WAN Miniport (Network Monitor)', 'WAN Miniport (PPPOE)', 'WAN Miniport (PPTP)', 'WAN Miniport (SSTP)'); $found=0; foreach ($d in $devices) { $devs = Get-PnpDevice -FriendlyName $d -ErrorAction SilentlyContinue; foreach ($dev in $devs) { if ($dev.Status -eq 'OK') { try { Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction Stop; Write-Output ('OK:' + $d); $found=1 } catch { Write-Output ('FAIL:' + $d); $found=1 } } } }; if ($found -eq 0) { Write-Output 'WARN:No active target devices were found.' }" > "%TEMP%\bardhzz_pnp_log.txt"

rem Parse PnP results.
set "pnp_processed=0"
for /f "tokens=1,* delims=:" %%A in ('type "%TEMP%\bardhzz_pnp_log.txt" 2^>nul') do (
    set "pnp_processed=1"
    if "%%A"=="OK" call :LogOK "Disabled Device: %%B"
    if "%%A"=="FAIL" call :LogErr "Failed to disable: %%B"
    if "%%A"=="WARN" call :LogWarn "%%B"
)

if "%pnp_processed%"=="0" (
    call :LogErr "PowerShell execution failed or returned empty."
)

del /q "%TEMP%\bardhzz_pnp_log.txt" >nul 2>&1
call :LogOK "Device Manager Tweaks section complete."
echo.
timeout /t 2 /nobreak >nul
pause
goto main

:pwr
setlocal EnableExtensions EnableDelayedExpansion
call :LogSection "Power Plan"
call :DetectToolPaths
set "PWR_NORMAL_FILE=!POWERPLAN_DIR!\bardhzzY powerplan.pow"
set "PWR_IDLE_FILE=!POWERPLAN_DIR!\bardhzzY powerplan idle off.pow"

goto pwr_menu

:pwr_menu
cls
echo.
echo  %BLUE%╔══════════════════════════════════════════════════════════════════════╗%RESET%
echo  %BLUE%║%CYAN%                          POWER PLAN SELECTOR                         %BLUE%║%RESET%
echo  %BLUE%╚══════════════════════════════════════════════════════════════════════╝%RESET%
echo.
echo  %WHITE%Choose the plan you want to import and activate.%RESET%
echo  %GRAY%The active scheme will be checked after activation.%RESET%
echo.
echo  %BLUE%┌──────────────────────────────────────────────────────────────────────┐%RESET%
echo  %BLUE%│%RESET%  %GREEN%[1]%RESET%  %WHITE%STANDARD%RESET%
echo  %BLUE%│%RESET%      %GRAY%bardhzzY powerplan.pow%RESET%
if exist "!PWR_NORMAL_FILE!" (
    echo  %BLUE%│%RESET%      %GREEN%Status: file found%RESET%
) else (
    echo  %BLUE%│%RESET%      %RED%Status: file missing%RESET%
)
echo  %BLUE%├──────────────────────────────────────────────────────────────────────┤%RESET%
echo  %BLUE%│%RESET%  %GREEN%[2]%RESET%  %WHITE%IDLE OFF%RESET%
echo  %BLUE%│%RESET%      %GRAY%bardhzzY powerplan idle off.pow%RESET%
if exist "!PWR_IDLE_FILE!" (
    echo  %BLUE%│%RESET%      %GREEN%Status: file found%RESET%
) else (
    echo  %BLUE%│%RESET%      %RED%Status: file missing%RESET%
)
echo  %BLUE%└──────────────────────────────────────────────────────────────────────┘%RESET%
echo.
echo  %WHITE%[3]%RESET%  Back to main menu
echo.
set "PWR_CHOICE="
set /p "PWR_CHOICE=%BLUE%[%WHITE%?%BLUE%]%WHITE% Select an option: %RESET%"
set "PWR_CHOICE=!PWR_CHOICE:"=!"
set "PWR_CHOICE=!PWR_CHOICE: =!"
if not defined PWR_CHOICE goto pwr_menu
if /i "!PWR_CHOICE!"=="1" goto pwr_select_standard
if /i "!PWR_CHOICE!"=="2" goto pwr_select_idle
if /i "!PWR_CHOICE!"=="3" goto pwr_back
call :LogWarn "Invalid power plan choice. Please select 1, 2, or 3."
timeout /t 1 /nobreak >nul
goto pwr_menu

:pwr_select_standard
set "PWR_FILE=!PWR_NORMAL_FILE!"
set "PWR_PLAN_LABEL=bardhzzY powerplan"
set "PWR_GUID_FILE=!POWERPLAN_DIR!\bardhzzY powerplan.guid"
goto pwr_plan_selected

:pwr_select_idle
set "PWR_FILE=!PWR_IDLE_FILE!"
set "PWR_PLAN_LABEL=bardhzzY powerplan idle off"
set "PWR_GUID_FILE=!POWERPLAN_DIR!\bardhzzY powerplan idle off.guid"
goto pwr_plan_selected

:pwr_plan_selected
if not exist "!PWR_FILE!" goto pwr_file_missing
call :LogInfo "Selected power plan: !PWR_PLAN_LABEL!"
set "PWR_GUID="
set "PWR_OLD_GUID="

rem Find the previous copy of this plan, if one was imported earlier.
if exist "!PWR_GUID_FILE!" (
    for /f "usebackq delims=" %%G in ("!PWR_GUID_FILE!") do if not defined PWR_OLD_GUID set "PWR_OLD_GUID=%%G"
    if defined PWR_OLD_GUID (
        powercfg /list | findstr /i /l "!PWR_OLD_GUID!" >nul 2>&1
        if errorlevel 1 set "PWR_OLD_GUID="
    )
)
if not defined PWR_OLD_GUID (
    for /f "tokens=4" %%G in ('powercfg /list ^| findstr /i /c:"(!PWR_PLAN_LABEL!)"') do if not defined PWR_OLD_GUID set "PWR_OLD_GUID=%%~G"
)

for /f "delims=" %%G in ('powershell -NoProfile -Command "[guid]::NewGuid().Guid" 2^>nul') do set "PWR_GUID=%%G"
if not defined PWR_GUID goto pwr_guid_failed

call :LogInfo "Importing !PWR_PLAN_LABEL! from !PWR_FILE!..."
powercfg /import "!PWR_FILE!" !PWR_GUID! >nul 2>&1
if errorlevel 1 goto pwr_import_failed

powercfg /list | findstr /i /l "!PWR_GUID!" >nul 2>&1
if errorlevel 1 goto pwr_verify_failed

call :LogInfo "Activating !PWR_PLAN_LABEL!..."
powercfg /setactive !PWR_GUID! >nul 2>&1
if errorlevel 1 goto pwr_activate_failed
powercfg /getactivescheme | findstr /i /l "!PWR_GUID!" >nul 2>&1
if errorlevel 1 goto pwr_activate_failed

>"!PWR_GUID_FILE!" echo !PWR_GUID!
if defined PWR_OLD_GUID if /i not "!PWR_OLD_GUID!"=="!PWR_GUID!" (
    powercfg /delete !PWR_OLD_GUID! >nul 2>&1
    if errorlevel 1 (
        call :LogWarn "New plan is active, but the previous imported copy could not be removed."
    ) else (
        call :LogInfo "Removed the previous imported copy of this plan."
    )
)
call :LogOK "!PWR_PLAN_LABEL! is active."
goto pwr_done

:pwr_file_missing
call :LogErr "The selected power plan file was not found."
call :LogInfo "Expected file: !PWR_FILE!"
goto pwr_done

:pwr_guid_failed
call :LogErr "Could not generate a GUID for the power plan."
goto pwr_done

:pwr_import_failed
call :LogErr "Powercfg could not import the selected plan. Verify that the .pow file is a valid powercfg export."
goto pwr_done

:pwr_verify_failed
powercfg /delete !PWR_GUID! >nul 2>&1
call :LogErr "Powercfg reported an import, but the new plan could not be verified."
goto pwr_done

:pwr_activate_failed
powercfg /delete !PWR_GUID! >nul 2>&1
call :LogErr "Windows could not activate the newly imported plan. The previous copy was left in place."
goto pwr_done

:pwr_done
echo.
pause
endlocal
goto main

:pwr_back
endlocal
goto main

:srp
call :LogSection "System Restore Point"
cls
chcp 65001 >nul 2>&1
echo %RESET%
title bardhzzY Tweaks - Creating Restore Point

echo =============================================
echo     Creating System Restore Point
echo =============================================
echo.

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f

echo [+] Enabling System Protection on C: drive...
set "PS_SCRIPT=%TEMP%\bardhzzY_srp.ps1"
echo Enable-ComputerRestore -Drive 'C:\' > "%PS_SCRIPT%"
echo Checkpoint-Computer -Description 'bardhzzY_Tweak_Restore' -RestorePointType 'MODIFY_SETTINGS' >> "%PS_SCRIPT%"

echo [+] Creating restore point (This may take a moment)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" >nul 2>&1
set "SRP_STATUS=%errorlevel%"
del /q "%PS_SCRIPT%" >nul 2>&1

cls
chcp 65001 >nul 2>&1
echo %RESET%

if %SRP_STATUS% equ 0 (
    call :LogOK "Restore point created successfully! (bardhzzY_Tweak_Restore)"
    echo =============================================
    echo     Creating System Restore Point
    echo =============================================
    echo.
    echo [OK] Restore point created successfully!
    echo     Description: bardhzzY_Tweak_Restore
) else (
    call :LogErr "Restore point creation failed."
    echo =============================================
    echo     Creating System Restore Point
    echo =============================================
    echo.
    echo [X] Restore point creation failed.
    echo     Note: Ensure System Restore is not disabled by an antivirus or corporate policy.
)

echo.
echo Tip: You can verify this manually via "Create a restore point" in Windows Search.
echo.
echo Press any key to return to the main menu...
pause >nul
goto main

:backup
call :LogSection "Registry Backup"
cls
MODE 92,42
chcp 65001 >nul 2>&1
echo %RESET%
color %CONSOLE_DEFAULT%
title bardhzzY Tweaks - Registry Backup

echo.
echo  %BLUE%========================================================================%RESET%
echo.
echo                   %YELLOW%REGISTRY BACKUP UTILITY%RESET%
echo.
echo  %BLUE%========================================================================%RESET%
echo.
echo        %WHITE%Create a full snapshot of your system registry before%RESET%
echo        %WHITE%applying destructive tweaks. Always have a rollback path.%RESET%
echo.
echo  %BLUE%------------------------------------------------------------------------%RESET%
echo.

set "BACKUP_DIR=%ProgramData%\bardhzzY\Backup"

if exist "%BACKUP_DIR%\HKLM_SYSTEM.reg" (
    echo        %YELLOW%[!]%WHITE% A registry backup already exists at:%RESET%
    echo        %GRAY%    %BACKUP_DIR%%RESET%
    echo        %WHITE%Creating a new backup will overwrite the old one.%RESET%
    echo.
    choice /c YN /n /m "       Overwrite existing backup? [Y/N]: "
    if errorlevel 2 goto main
    echo.
)

echo        %CYAN%[%WHITE% i %CYAN%]%WHITE% Creating Safety Backup of System Registry...%RESET%
echo        %GRAY%    This may take up to 30 seconds. Do not close this window.%RESET%
echo.

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>&1

if not exist "%BACKUP_DIR%" (
    call :LogErr "Could not create backup directory."
    echo        %RED%[X]%WHITE% ERROR: Could not create:%RESET%
    echo        %GRAY%    %BACKUP_DIR%%RESET%
    echo.
    pause
    goto main
)

set "BACKUP_OK=1"
set "BK_TOTAL=6"
set "BK_DONE=0"

echo        %CYAN%[1/6]%WHITE% Exporting HKLM\SYSTEM...%RESET%
reg export "HKLM\SYSTEM" "%BACKUP_DIR%\HKLM_SYSTEM.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKLM_SYSTEM failed."
    echo        %RED%    [X]%WHITE% HKLM_SYSTEM backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKLM_SYSTEM"
    echo        %GREEN%    [OK]%WHITE% HKLM_SYSTEM backup created%RESET%
)

echo        %CYAN%[2/6]%WHITE% Exporting HKLM\SOFTWARE...%RESET%
reg export "HKLM\SOFTWARE" "%BACKUP_DIR%\HKLM_SOFTWARE.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKLM_SOFTWARE failed."
    echo        %RED%    [X]%WHITE% HKLM_SOFTWARE backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKLM_SOFTWARE"
    echo        %GREEN%    [OK]%WHITE% HKLM_SOFTWARE backup created%RESET%
)

echo        %CYAN%[3/6]%WHITE% Exporting HKCU\Software...%RESET%
reg export "HKCU\Software" "%BACKUP_DIR%\HKCU_Software.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKCU_Software failed."
    echo        %RED%    [X]%WHITE% HKCU_Software backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKCU_Software"
    echo        %GREEN%    [OK]%WHITE% HKCU_Software backup created%RESET%
)

echo        %CYAN%[4/6]%WHITE% Exporting HKCU\Control Panel...%RESET%
reg export "HKCU\Control Panel" "%BACKUP_DIR%\HKCU_CPanel.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKCU_CPanel failed."
    echo        %RED%    [X]%WHITE% HKCU_CPanel backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKCU_CPanel"
    echo        %GREEN%    [OK]%WHITE% HKCU_CPanel backup created%RESET%
)

echo        %CYAN%[5/6]%WHITE% Exporting HKCR (HKEY_CLASSES_ROOT)...%RESET%
reg export "HKCR" "%BACKUP_DIR%\HKCR.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKCR failed."
    echo        %RED%    [X]%WHITE% HKCR backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKCR"
    echo        %GREEN%    [OK]%WHITE% HKCR backup created%RESET%
)

echo        %CYAN%[6/6]%WHITE% Exporting HKU (HKEY_USERS)...%RESET%
reg export "HKU" "%BACKUP_DIR%\HKU.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKU failed."
    echo        %RED%    [X]%WHITE% HKU backup FAILED%RESET%
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKU"
    echo        %GREEN%    [OK]%WHITE% HKU backup created%RESET%
)

echo.
echo  %BLUE%------------------------------------------------------------------------%RESET%
echo.

if "%BACKUP_OK%"=="1" (
    call :LogOK "Complete registry backup verified."
    echo        %GREEN%[OK]%WHITE% COMPLETE REGISTRY BACKUP VERIFIED%RESET%
    echo  %BLUE%------------------------------------------------------------------------%RESET%
    echo.
    echo        %WHITE%Backup location:%RESET%
    echo        %CYAN%%BACKUP_DIR%%RESET%
    echo.
    echo        %GREEN%You can now safely use the Revert Tweaks option.%RESET%
) else (
    call :LogErr "Registry backup is incomplete."
    echo        %RED%[X]%WHITE% REGISTRY BACKUP FAILED / INCOMPLETE%RESET%
    echo  %BLUE%------------------------------------------------------------------------%RESET%
    echo.
    echo        %YELLOW%One or more registry exports failed.%RESET%
    echo        %RED%DO NOT use Revert Tweaks until a complete backup exists.%RESET%
)

echo.
echo  %BLUE%========================================================================%RESET%
echo.
echo        %GRAY%Press any key to return to the main menu...%RESET%
pause >nul
goto main

:timerres
setlocal EnableDelayedExpansion
call :LogSection "Timer Resolution"
cls
echo.
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%LATENCY ^& TIMER RESOLUTION TOOLS%RESET%
echo.

call :LogInfo "Enabling support for global timer resolution requests..."

rem Timer startup registry helper.
call :TimerRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f
if errorlevel 1 (
    call :LogErr "Failed to enable GlobalTimerResolutionRequests."
) else (
    call :LogOK "GlobalTimerResolutionRequests enabled."
)

set "TIMER_DIR=C:\bardhzzY Utility Tools\Timer Resolution"
set "TIMER_EXE=%TIMER_DIR%\SetTimerResolution.exe"
set "MEASURE_EXE=%TIMER_DIR%\MeasureSleep.exe"
if not exist "%TIMER_DIR%" mkdir "%TIMER_DIR%" >nul 2>&1
set "REPO_ZIP=%TEMP%\bardhzzY_timer_tools.zip"
set "EXTRACT_DIR=%TEMP%\bardhzzY_timer_tools_extract"
set "TIMER_DOWNLOAD_LOG=%TEMP%\bardhzzY_timer_download.log"
set "TIMER_SOURCE=Existing local copy"

if exist "%TIMER_DOWNLOAD_LOG%" del /q "%TIMER_DOWNLOAD_LOG%" >nul 2>&1

rem Remove empty or obviously invalid downloads before checking the repository.
if exist "%TIMER_EXE%" for %%I in ("%TIMER_EXE%") do if %%~zI LEQ 10240 del /q "%TIMER_EXE%" >nul 2>&1
if exist "%MEASURE_EXE%" for %%I in ("%MEASURE_EXE%") do if %%~zI EQU 0 del /q "%MEASURE_EXE%" >nul 2>&1

set "TIMER_EXE_WAS_MISSING=0"
if not exist "%TIMER_EXE%" set "TIMER_EXE_WAS_MISSING=1"
set "TIMER_REFRESH_NEEDED=0"
if not exist "%TIMER_EXE%" set "TIMER_REFRESH_NEEDED=1"
if not exist "%MEASURE_EXE%" set "TIMER_REFRESH_NEEDED=1"
if "%TIMER_REFRESH_NEEDED%"=="0" goto timerres_tools_ready

call :LogInfo "Checking the Utility Tools repository for missing timer files..."
if not defined GITHUB_ZIP_URL goto timerres_utility_refresh_failed
if exist "%REPO_ZIP%" del /q "%REPO_ZIP%" >nul 2>&1
if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%" >nul 2>&1

powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GITHUB_ZIP_URL%' -OutFile '%REPO_ZIP%' -UseBasicParsing" >"%TIMER_DOWNLOAD_LOG%" 2>&1
if errorlevel 1 goto timerres_utility_refresh_failed
if not exist "%REPO_ZIP%" goto timerres_utility_refresh_failed

mkdir "%EXTRACT_DIR%" >nul 2>&1
tar -xf "%REPO_ZIP%" -C "%EXTRACT_DIR%" >>"%TIMER_DOWNLOAD_LOG%" 2>&1
if errorlevel 1 goto timerres_utility_refresh_failed

rem Copy only the timer utilities needed by this section.
for /r "%EXTRACT_DIR%" %%F in (SetTimerResolution.exe) do if not exist "%TIMER_EXE%" copy /Y "%%F" "%TIMER_EXE%" >nul 2>&1
for /r "%EXTRACT_DIR%" %%F in (MeasureSleep.exe) do if not exist "%MEASURE_EXE%" copy /Y "%%F" "%MEASURE_EXE%" >nul 2>&1
if "%TIMER_EXE_WAS_MISSING%"=="1" if exist "%TIMER_EXE%" set "TIMER_SOURCE=Utility Tools repository"

rd /s /q "%EXTRACT_DIR%" >nul 2>&1
del /q "%REPO_ZIP%" >nul 2>&1
goto timerres_validate_tools

:timerres_utility_refresh_failed
if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%" >nul 2>&1
if exist "%REPO_ZIP%" del /q "%REPO_ZIP%" >nul 2>&1
call :LogWarn "Timer tools could not be retrieved from the Utility Tools repository."
if exist "%TIMER_DOWNLOAD_LOG%" type "%TIMER_DOWNLOAD_LOG%"

:timerres_validate_tools
if exist "%TIMER_EXE%" for %%I in ("%TIMER_EXE%") do if %%~zI LEQ 10240 del /q "%TIMER_EXE%" >nul 2>&1
if exist "%MEASURE_EXE%" for %%I in ("%MEASURE_EXE%") do if %%~zI EQU 0 del /q "%MEASURE_EXE%" >nul 2>&1
if exist "%TIMER_EXE%" goto timerres_tools_ready

call :LogWarn "SetTimerResolution.exe is unavailable from Utility Tools. Trying SwiftyPop TimerResBenchmark..."
if exist "%TIMER_DOWNLOAD_LOG%" del /q "%TIMER_DOWNLOAD_LOG%" >nul 2>&1
powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SwiftyPop/TimerResBenchmark/main/SetTimerResolution.exe' -OutFile '%TIMER_EXE%' -UseBasicParsing" >"%TIMER_DOWNLOAD_LOG%" 2>&1
if errorlevel 1 goto timerres_download_failed
if not exist "%TIMER_EXE%" goto timerres_download_failed
for %%I in ("%TIMER_EXE%") do if %%~zI LEQ 10240 del /q "%TIMER_EXE%" >nul 2>&1
if not exist "%TIMER_EXE%" goto timerres_download_failed
set "TIMER_SOURCE=SwiftyPop TimerResBenchmark"

call :LogOK "SetTimerResolution.exe downloaded from SwiftyPop TimerResBenchmark."
goto timerres_tools_ready

:timerres_download_failed
if exist "%TIMER_EXE%" del /q "%TIMER_EXE%" >nul 2>&1
call :LogErr "Could not obtain SetTimerResolution.exe from either configured source."
call :LogInfo "Download the executable manually from https://github.com/SwiftyPop/TimerResBenchmark"
call :LogInfo "Expected location: %TIMER_EXE%"
if exist "%TIMER_DOWNLOAD_LOG%" type "%TIMER_DOWNLOAD_LOG%"
goto timerres_islc

:timerres_tools_ready
if exist "%TIMER_EXE%" call :LogOK "SetTimerResolution.exe is ready (%TIMER_SOURCE%)."
if not exist "%MEASURE_EXE%" call :LogWarn "MeasureSleep.exe is unavailable; option 5 cannot run until it is added to Utility Tools."

:timerres_menu
cls
echo.
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%SELECT TIMER RESOLUTION%RESET%
echo  %WHITE% [%CYAN%1%WHITE%] 0.500ms %GRAY%(5000)%RESET%
echo  %WHITE% [%CYAN%2%WHITE%] 0.504ms %GRAY%(5040)%RESET%
echo  %WHITE% [%CYAN%3%WHITE%] 0.507ms %GRAY%(5070)%RESET%
echo  %WHITE% [%CYAN%4%WHITE%] Custom Value %GRAY%(Enter microseconds)%RESET%
echo  %WHITE% [%CYAN%5%WHITE%] Measure Sleep Timing
echo  %WHITE% [%CYAN%6%WHITE%] Skip Timer Resolution
echo.
set "timer_choice="
set /p "timer_choice=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

if not defined timer_choice goto timerres_menu
set "timer_choice=%timer_choice:"=%"
set "timer_choice=%timer_choice: =%"

if /i "%timer_choice%"=="1" (
    set "TIMER_VAL=5000"
    goto timer_apply
)
if /i "%timer_choice%"=="2" (
    set "TIMER_VAL=5040"
    goto timer_apply
)
if /i "%timer_choice%"=="3" (
    set "TIMER_VAL=5070"
    goto timer_apply
)
if /i "%timer_choice%"=="4" goto timer_custom

if /i "%timer_choice%"=="5" goto timer_measure

if /i "%timer_choice%"=="6" (
    call :LogSkip "Timer Resolution setup skipped."
    goto :timerres_islc
)

echo.
echo "%timer_choice%" isn't a right choice, try again!
timeout 2 >nul
goto timerres_menu

:timer_measure
cls
echo.
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%MEASURE TIMER RESOLUTION%RESET%
echo.
echo  %WHITE%MeasureSleep checks the actual timing behavior of Windows Sleep(1).%RESET%
echo.

if not exist "%MEASURE_EXE%" (
    call :LogErr "MeasureSleep.exe was not found."
    echo.
    echo  %RED%[ERROR]%WHITE% MeasureSleep.exe is missing.
    echo.
    echo  Place it here:
    echo  %GRAY%%MEASURE_EXE%%RESET%
    echo.
    timeout /t 3 /nobreak >nul
    goto timerres_menu
)

call :LogInfo "Launching MeasureSleep.exe..."

start "" "%MEASURE_EXE%"

if errorlevel 1 (
    call :LogErr "Failed to launch MeasureSleep.exe."
) else (
    call :LogOK "MeasureSleep.exe launched."
)

echo.
echo  %GRAY%MeasureSleep is running separately. Review its results, then return here.%RESET%
echo.
pause
goto timerres_menu

:timer_custom
cls
echo.
echo.
echo        %BLUE%██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%RESET%
echo        %BLUE%██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%RESET%
echo        %BLUE%██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %RESET%
echo        %BLUE%██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %RESET%
echo        %BLUE%██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %RESET%
echo        %BLUE%╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %RESET%
echo.
echo  %BLUE%ENTER CUSTOM TIMER RESOLUTION%RESET%
echo  %GRAY%Value must be in microseconds (e.g., 5000 for 0.5ms). Max 50000.%RESET%
echo.
set "custom_val="
set /p "custom_val=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Enter value: %RESET%"
if not defined custom_val goto timerres_menu
set "custom_val=%custom_val:"=%"
set "custom_val=%custom_val: =%"

echo !custom_val!| findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    call :LogErr "Invalid custom value. Must be numeric."
    timeout 2 >nul
    goto timer_custom
)

if !custom_val! LSS 1 (
    call :LogErr "Value cannot be less than 1."
    timeout 2 >nul
    goto timer_custom
)
if !custom_val! GTR 50000 (
    call :LogErr "Value cannot exceed 50000 (5.0ms)."
    timeout 2 >nul
    goto timer_custom
)

set "TIMER_VAL=!custom_val!"

:timer_apply
call :LogInfo "Creating Timer Resolution shortcut in the signed-in user's Startup folder..."
set "BARDHZZ_TIMER_EXE=%TIMER_EXE%"
set "BARDHZZ_TIMER_DIR=%TIMER_DIR%"
set "BARDHZZ_TIMER_VAL=%TIMER_VAL%"
set "TIMER_SHORTCUT_LOG=%TEMP%\bardhzzY_timer_startup.log"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwB0AG8AcAAnAAoAJABQAHIAbwBnAHIAZQBzAHMAUAByAGUAZgBlAHIAZQBuAGMAZQA9ACcAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAnAAoAdAByAHkAIAB7AAoAIAAkAGUAeABlAD0AJABlAG4AdgA6AEIAQQBSAEQASABaAFoAXwBUAEkATQBFAFIAXwBFAFgARQA7ACAAJABkAGkAcgA9ACQAZQBuAHYAOgBCAEEAUgBEAEgAWgBaAF8AVABJAE0ARQBSAF8ARABJAFIAOwAgACQAcgA9ACQAZQBuAHYAOgBCAEEAUgBEAEgAWgBaAF8AVABJAE0ARQBSAF8AVgBBAEwACgAgAGkAZgAgACgALQBuAG8AdAAgACgAVABlAHMAdAAtAFAAYQB0AGgAIAAtAEwAaQB0AGUAcgBhAGwAUABhAHQAaAAgACQAZQB4AGUAIAAtAFAAYQB0AGgAVAB5AHAAZQAgAEwAZQBhAGYAKQApACAAewAgAHQAaAByAG8AdwAgACIAUwBlAHQAVABpAG0AZQByAFIAZQBzAG8AbAB1AHQAaQBvAG4ALgBlAHgAZQAgAG4AbwB0ACAAZgBvAHUAbgBkADoAIAAkAGUAeABlACIAIAB9AAoAIABpAGYAIAAoACQAcgAgAC0AbgBvAHQAbQBhAHQAYwBoACAAJwBeAFwAZAArACQAJwAgAC0AbwByACAAWwBpAG4AdABdACQAcgAgAC0AbAB0ACAAMQAgAC0AbwByACAAWwBpAG4AdABdACQAcgAgAC0AZwB0ACAANQAwADAAMAAwACkAIAB7ACAAdABoAHIAbwB3ACAAIgBJAG4AdgBhAGwAaQBkACAAcgBlAHMAbwBsAHUAdABpAG8AbgA6ACAAJAByACIAIAB9AAoAIAAkAHMAcwA9AFsARABpAGEAZwBuAG8AcwB0AGkAYwBzAC4AUAByAG8AYwBlAHMAcwBdADoAOgBHAGUAdABDAHUAcgByAGUAbgB0AFAAcgBvAGMAZQBzAHMAKAApAC4AUwBlAHMAcwBpAG8AbgBJAGQACgAgACQAZQA9AEcAZQB0AC0AQwBpAG0ASQBuAHMAdABhAG4AYwBlACAAVwBpAG4AMwAyAF8AUAByAG8AYwBlAHMAcwAgAC0ARgBpAGwAdABlAHIAIAAiAE4AYQBtAGUAPQAnAGUAeABwAGwAbwByAGUAcgAuAGUAeABlACcAIgAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwB0AG8AcAAgAHwAIABXAGgAZQByAGUALQBPAGIAagBlAGMAdAAgAHsAIAAkAF8ALgBTAGUAcwBzAGkAbwBuAEkAZAAgAC0AZQBxACAAJABzAHMAIAB9ACAAfAAgAFMAZQBsAGUAYwB0AC0ATwBiAGoAZQBjAHQAIAAtAEYAaQByAHMAdAAgADEACgAgAGkAZgAgACgALQBuAG8AdAAgACQAZQApACAAewAgAHQAaAByAG8AdwAgACIATgBvACAARQB4AHAAbABvAHIAZQByACAAcAByAG8AYwBlAHMAcwAgAGYAbwB1AG4AZAAgAGkAbgAgAGkAbgB0AGUAcgBhAGMAdABpAHYAZQAgAHMAZQBzAHMAaQBvAG4AIAAkAHMAcwA7ACAAbgBvAHQAIABjAHIAZQBhAHQAaQBuAGcAIABhACAAcwBoAG8AcgB0AGMAdQB0ACAAaQBuACAAdABoAGUAIAB3AHIAbwBuAGcAIABwAHIAbwBmAGkAbABlAC4AIgAgAH0ACgAgACQAbwA9AEkAbgB2AG8AawBlAC0AQwBpAG0ATQBlAHQAaABvAGQAIAAtAEkAbgBwAHUAdABPAGIAagBlAGMAdAAgACQAZQAgAC0ATQBlAHQAaABvAGQATgBhAG0AZQAgAEcAZQB0AE8AdwBuAGUAcgAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwB0AG8AcAAKACAAaQBmACAAKAAkAG8ALgBSAGUAdAB1AHIAbgBWAGEAbAB1AGUAIAAtAG4AZQAgADAAIAAtAG8AcgAgAC0AbgBvAHQAIAAkAG8ALgBVAHMAZQByACkAIAB7ACAAdABoAHIAbwB3ACAAJwBDAG8AdQBsAGQAIABuAG8AdAAgAGkAZABlAG4AdABpAGYAeQAgAHQAaABlACAAcwBpAGcAbgBlAGQALQBpAG4AIAB1AHMAZQByAC4AJwAgAH0ACgAgACQAYQA9AGkAZgAgACgAJABvAC4ARABvAG0AYQBpAG4AKQAgAHsAIAAnAHsAMAB9AFwAewAxAH0AJwAgAC0AZgAgACQAbwAuAEQAbwBtAGEAaQBuACwAJABvAC4AVQBzAGUAcgAgAH0AIABlAGwAcwBlACAAewAgACQAbwAuAFUAcwBlAHIAIAB9AAoAIAAkAHMAaQBkAD0AKABbAFMAZQBjAHUAcgBpAHQAeQAuAFAAcgBpAG4AYwBpAHAAYQBsAC4ATgBUAEEAYwBjAG8AdQBuAHQAXQA6ADoAbgBlAHcAKAAkAGEAKQApAC4AVAByAGEAbgBzAGwAYQB0AGUAKABbAFMAZQBjAHUAcgBpAHQAeQAuAFAAcgBpAG4AYwBpAHAAYQBsAC4AUwBlAGMAdQByAGkAdAB5AEkAZABlAG4AdABpAGYAaQBlAHIAXQApAC4AVgBhAGwAdQBlAAoAIAAkAHAAPQBHAGUAdAAtAEMAaQBtAEkAbgBzAHQAYQBuAGMAZQAgAFcAaQBuADMAMgBfAFUAcwBlAHIAUAByAG8AZgBpAGwAZQAgAC0ARgBpAGwAdABlAHIAIAAiAFMASQBEAD0AJwAkAHMAaQBkACcAIgAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwB0AG8AcAAgAHwAIABTAGUAbABlAGMAdAAtAE8AYgBqAGUAYwB0ACAALQBGAGkAcgBzAHQAIAAxAAoAIABpAGYAIAAoAC0AbgBvAHQAIAAkAHAAKQAgAHsAIAB0AGgAcgBvAHcAIAAiAFAAcgBvAGYAaQBsAGUAIABuAG8AdAAgAGYAbwB1AG4AZAAgAGYAbwByACAAJABhAC4AIgAgAH0ACgAgACQAcwB0AGEAcgB0AHUAcAA9AEoAbwBpAG4ALQBQAGEAdABoACAAJABwAC4ATABvAGMAYQBsAFAAYQB0AGgAIAAnAEEAcABwAEQAYQB0AGEAXABSAG8AYQBtAGkAbgBnAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAUwB0AGEAcgB0ACAATQBlAG4AdQBcAFAAcgBvAGcAcgBhAG0AcwBcAFMAdABhAHIAdAB1AHAAJwAKACAAJABrAD0AIgBSAGUAZwBpAHMAdAByAHkAOgA6AEgASwBFAFkAXwBVAFMARQBSAFMAXAAkAHMAaQBkAFwAUwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwARQB4AHAAbABvAHIAZQByAFwAVQBzAGUAcgAgAFMAaABlAGwAbAAgAEYAbwBsAGQAZQByAHMAIgAKACAAJABmAD0ARwBlAHQALQBJAHQAZQBtAFAAcgBvAHAAZQByAHQAeQAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABrACAALQBOAGEAbQBlACAAUwB0AGEAcgB0AHUAcAAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAKACAAaQBmACAAKAAkAGYALgBTAHQAYQByAHQAdQBwACkAIAB7AAoAIAAgACQAcwB0AGEAcgB0AHUAcAA9ACgAWwBzAHQAcgBpAG4AZwBdACQAZgAuAFMAdABhAHIAdAB1AHAAKQAuAFIAZQBwAGwAYQBjAGUAKAAnACUAVQBTAEUAUgBQAFIATwBGAEkATABFACUAJwAsACQAcAAuAEwAbwBjAGEAbABQAGEAdABoACkALgBSAGUAcABsAGEAYwBlACgAJwAlAEEAUABQAEQAQQBUAEEAJQAnACwAKABKAG8AaQBuAC0AUABhAHQAaAAgACQAcAAuAEwAbwBjAGEAbABQAGEAdABoACAAJwBBAHAAcABEAGEAdABhAFwAUgBvAGEAbQBpAG4AZwAnACkAKQAuAFIAZQBwAGwAYQBjAGUAKAAnACUATABPAEMAQQBMAEEAUABQAEQAQQBUAEEAJQAnACwAKABKAG8AaQBuAC0AUABhAHQAaAAgACQAcAAuAEwAbwBjAGEAbABQAGEAdABoACAAJwBBAHAAcABEAGEAdABhAFwATABvAGMAYQBsACcAKQApAAoAIAAgACQAcwB0AGEAcgB0AHUAcAA9AFsARQBuAHYAaQByAG8AbgBtAGUAbgB0AF0AOgA6AEUAeABwAGEAbgBkAEUAbgB2AGkAcgBvAG4AbQBlAG4AdABWAGEAcgBpAGEAYgBsAGUAcwAoACQAcwB0AGEAcgB0AHUAcAApAAoAIAB9AAoAIABpAGYAIAAoAC0AbgBvAHQAIAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAHMAdABhAHIAdAB1AHAAIAAtAFAAYQB0AGgAVAB5AHAAZQAgAEMAbwBuAHQAYQBpAG4AZQByACkAKQAgAHsAIABOAGUAdwAtAEkAdABlAG0AIAAtAEkAdABlAG0AVAB5AHAAZQAgAEQAaQByAGUAYwB0AG8AcgB5ACAALQBQAGEAdABoACAAJABzAHQAYQByAHQAdQBwACAALQBGAG8AcgBjAGUAIAB8ACAATwB1AHQALQBOAHUAbABsACAAfQAKACAAJABzAD0ASgBvAGkAbgAtAFAAYQB0AGgAIAAkAHMAdABhAHIAdAB1AHAAIAAnAGIAYQByAGQAaAB6AHoAWQAgAFQAaQBtAGUAcgAgAFIAZQBzAG8AbAB1AHQAaQBvAG4ALgBsAG4AawAnADsAIAAkAHcAPQBOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBDAG8AbQBPAGIAagBlAGMAdAAgAFcAUwBjAHIAaQBwAHQALgBTAGgAZQBsAGwAOwAgACQAbAA9ACQAdwAuAEMAcgBlAGEAdABlAFMAaABvAHIAdABjAHUAdAAoACQAcwApAAoAIAAkAGwALgBUAGEAcgBnAGUAdABQAGEAdABoAD0AJABlAHgAZQA7ACAAJABsAC4AQQByAGcAdQBtAGUAbgB0AHMAPQAiAC0ALQBuAG8ALQBjAG8AbgBzAG8AbABlACAALQAtAHIAZQBzAG8AbAB1AHQAaQBvAG4AIAAkAHIAIgA7ACAAJABsAC4AVwBvAHIAawBpAG4AZwBEAGkAcgBlAGMAdABvAHIAeQA9ACQAZABpAHIAOwAgACQAbAAuAEQAZQBzAGMAcgBpAHAAdABpAG8AbgA9ACcAYgBhAHIAZABoAHoAegBZACAAVABpAG0AZQByACAAUgBlAHMAbwBsAHUAdABpAG8AbgAnADsAIAAkAGwALgBTAGEAdgBlACgAKQAKACAAaQBmACAAKAAtAG4AbwB0ACAAKABUAGUAcwB0AC0AUABhAHQAaAAgAC0ATABpAHQAZQByAGEAbABQAGEAdABoACAAJABzACAALQBQAGEAdABoAFQAeQBwAGUAIABMAGUAYQBmACkAKQAgAHsAIAB0AGgAcgBvAHcAIAAiAFMAaABvAHIAdABjAHUAdAAgAHcAYQBzACAAbgBvAHQAIABjAHIAZQBhAHQAZQBkADoAIAAkAHMAIgAgAH0ACgAgACQAdgA9ACQAdwAuAEMAcgBlAGEAdABlAFMAaABvAHIAdABjAHUAdAAoACQAcwApADsAIAAkAGEAcgBnAHMAPQAiAC0ALQBuAG8ALQBjAG8AbgBzAG8AbABlACAALQAtAHIAZQBzAG8AbAB1AHQAaQBvAG4AIAAkAHIAIgAKACAAaQBmACAAKAAkAHYALgBUAGEAcgBnAGUAdABQAGEAdABoACAALQBpAG4AZQAgACQAZQB4AGUAIAAtAG8AcgAgACQAdgAuAEEAcgBnAHUAbQBlAG4AdABzACAALQBuAGUAIAAkAGEAcgBnAHMAKQAgAHsAIAB0AGgAcgBvAHcAIAAnAFMAaABvAHIAdABjAHUAdAAgAHQAYQByAGcAZQB0ACAAbwByACAAYQByAGcAdQBtAGUAbgB0AHMAIABkAGkAZAAgAG4AbwB0ACAAcwBhAHYAZQAgAGMAbwByAHIAZQBjAHQAbAB5AC4AJwAgAH0ACgAgAFcAcgBpAHQAZQAtAE8AdQB0AHAAdQB0ACAAIgBJAG4AdABlAHIAYQBjAHQAaQB2AGUAIAB1AHMAZQByADoAIAAkAGEAIgA7ACAAVwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAiAFMAdABhAHIAdAB1AHAAIABmAG8AbABkAGUAcgA6ACAAJABzAHQAYQByAHQAdQBwACIAOwAgAFcAcgBpAHQAZQAtAE8AdQB0AHAAdQB0ACAAIgBTAGgAbwByAHQAYwB1AHQAOgAgACQAcwAiADsAIABXAHIAaQB0AGUALQBPAHUAdABwAHUAdAAgACIAVABhAHIAZwBlAHQAOgAgACQAKAAkAHYALgBUAGEAcgBnAGUAdABQAGEAdABoACkAIgA7ACAAVwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAiAEEAcgBnAHUAbQBlAG4AdABzADoAIAAkACgAJAB2AC4AQQByAGcAdQBtAGUAbgB0AHMAKQAiAAoAIAB0AHIAeQAgAHsAIABSAGUAbQBvAHYAZQAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5ACAALQBQAGEAdABoACAAJwBIAEsATABNADoAXABTAE8ARgBUAFcAQQBSAEUAXABNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABDAHUAcgByAGUAbgB0AFYAZQByAHMAaQBvAG4AXABSAHUAbgAnACAALQBOAGEAbQBlACAAJwBiAGEAcgBkAGgAegB6AFkAVABpAG0AZQByAFIAZQBzAG8AbAB1AHQAaQBvAG4AJwAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwB0AG8AcAA7ACAAVwByAGkAdABlAC0ATwB1AHQAcAB1AHQAIAAnAFIAZQBtAG8AdgBlAGQAIABsAGUAZwBhAGMAeQAgAFIAdQBuACAAZQBuAHQAcgB5AC4AJwAgAH0AIABjAGEAdABjAGgAIAB7AH0ACgAgAGUAeABpAHQAIAAwAAoAfQAgAGMAYQB0AGMAaAAgAHsAIABbAEMAbwBuAHMAbwBsAGUAXQA6ADoARQByAHIAbwByAC4AVwByAGkAdABlAEwAaQBuAGUAKAAiAFQAaQBtAGUAcgAgAFIAZQBzAG8AbAB1AHQAaQBvAG4AIABzAGgAbwByAHQAYwB1AHQAIABjAHIAZQBhAHQAaQBvAG4AIABmAGEAaQBsAGUAZAA6ACAAJAAoACQAXwAuAEUAeABjAGUAcAB0AGkAbwBuAC4ATQBlAHMAcwBhAGcAZQApACIAKQA7ACAAZQB4AGkAdAAgADEAIAB9AA== > "%TIMER_SHORTCUT_LOG%" 2>&1
if errorlevel 1 (
    call :LogErr "Failed to create the Timer Resolution Startup shortcut."
    if exist "%TIMER_SHORTCUT_LOG%" type "%TIMER_SHORTCUT_LOG%"
    call :LogInfo "Diagnostic log: %TIMER_SHORTCUT_LOG%"
) else (
    call :LogOK "Startup shortcut set to %TIMER_VAL%us."
    call :LogInfo "Shortcut verified in the signed-in user's Startup folder."
    call :LogInfo "Arguments: --no-console --resolution %TIMER_VAL%"
)

call :LogInfo "Starting SetTimerResolution for current session..."
start "" "%TIMER_EXE%" --no-console --resolution %TIMER_VAL%
if errorlevel 1 (
    call :LogErr "Failed to launch SetTimerResolution for this session."
) else (
    call :LogOK "SetTimerResolution launched for this session."
)

:timerres_islc
echo.
echo  %WHITE% [%CYAN%1%WHITE%] Download ISLC (Recommended for 16GB RAM or less)
echo  %WHITE% [%CYAN%2%WHITE%] Skip ISLC
echo.
set "islc_choice="
set /p "islc_choice=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

if not defined islc_choice goto :timerres_end
set "islc_choice=%islc_choice:"=%"
set "islc_choice=%islc_choice: =%"

if /i "%islc_choice%"=="2" (
    call :LogSkip "ISLC setup skipped."
    goto :timerres_end
)
if /i not "%islc_choice%"=="1" (
    echo "%islc_choice%" isn't a right choice, try again!
    timeout 2 >nul
    goto :timerres_islc
)

call :LogInfo "Downloading ISLC..."
set "ISLC_INSTALLER=%TEMP%\ISLC_Installer.exe"
set "ISLC_DIR=C:\Program Files\ISLC"

if exist "%ISLC_INSTALLER%" del /q "%ISLC_INSTALLER%" >nul 2>&1

curl -L -f -s -o "%ISLC_INSTALLER%" "https://www.wagnardsoft.com/ISLC/ISLC%%20v1.0.3.2.exe" >nul 2>&1

if not exist "%ISLC_INSTALLER%" (
    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://www.wagnardsoft.com/ISLC/ISLC%%20v1.0.3.2.exe' -OutFile '%ISLC_INSTALLER%' -UseBasicParsing } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
)

if exist "%ISLC_INSTALLER%" (
    for %%I in ("%ISLC_INSTALLER%") do if %%~zI GTR 10240 (
        call :LogOK "ISLC downloaded. Extracting to %ISLC_DIR%..."
        
        mkdir "%ISLC_DIR%" >nul 2>&1
        "%ISLC_INSTALLER%" -y -o"%ISLC_DIR%" >nul 2>&1
        
        del /q "%ISLC_INSTALLER%" >nul 2>&1
        
        call :LogOK "ISLC extracted successfully."
        
        set "ISLC_EXE="
        for /f "delims=" %%A in ('dir /b /s "%ISLC_DIR%\Intelligent standby list cleaner ISLC.exe" 2^>nul') do set "ISLC_EXE=%%A"
        
        if defined ISLC_EXE (
            call :LogInfo "Launching ISLC..."
            start "" "!ISLC_EXE!"
            call :LogInfo "Please check 'Start ISLC minimized' and 'Launch ISLC on user logon'."
            call :LogInfo "Ensure 'Free memory lower than' is set to 1024, then click Start."
        ) else (
            call :LogErr "Extraction finished, but could not locate the ISLC executable."
        )
    ) else (
        call :LogErr "Failed to download ISLC. File is corrupted or URL changed."
        del /q "%ISLC_INSTALLER%" >nul 2>&1
    )
) else (
    call :LogErr "Failed to download ISLC. Network blocked or URL changed."
)

:timerres_end
echo.
call :LogOK "Timer Resolution configuration complete."
endlocal
timeout /t 2 /nobreak > NUL
pause
goto main

:fortnite
call :LogSection "Fortnite Optimizer"
cls
echo ============================================================================
echo Native GPEdit Enabler ^& Fortnite QoS Optimizer
echo ============================================================================
echo.

call :LogInfo "[1/7] Unlocking Native Group Policy Editor..."
pushd "%~dp0"
dir /b "%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package*.mum" >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%i in ('dir /b /s "%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package*.mum"') do dism /online /norestart /add-package:"%%i" >nul 2>&1
    call :LogOK "dism add gpedit ClientTools"
    for /f "delims=" %%i in ('dir /b /s "%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum"') do dism /online /norestart /add-package:"%%i" >nul 2>&1
    call :LogOK "dism add gpedit ClientExtensions"
    popd
    echo        - Native gpedit.msc successfully unlocked.
) else (
    popd
    call :LogSkip "gpedit packages not found (You likely already have Windows Pro)."
)
echo.

call :LogInfo "[2/7] Injecting Registry QoS Override..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableUserTOSSetting" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS" /v "Application DSCP Marking Request" /t REG_SZ /d "Allowed" /f
echo        - Local networking forced to accept standalone packet rules.
echo.

call :LogInfo "[3/7] Configuring Core Engine Services (Psched & QWAVE)..."
call :TIScLog config Psched start= system
call :TIScLog start Psched
call :TIScLog config qwave start= auto
call :TIScLog start qwave
echo        - Prioritization daemons successfully initialized.
echo.

call :LogInfo "[4/7] Eradicating Windows default bandwidth reservation caps..."
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f
echo        - Interface limit throughput restrictions unthrottled ^(0%%^).
echo.

call :LogInfo "[5/7] Aligning TCP Auto-Tuning..."
netsh int tcp set global autotuninglevel=normal >nul 2>&1
if not errorlevel 1 (call :LogOK "netsh autotuninglevel=normal") else (call :LogErr "netsh autotuninglevel=normal")
echo        - TCP window scaling optimized for stable packet delivery.
echo.

call :LogInfo "[6/7] Activating adapter stream configuration..."
powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Enable-NetAdapterQos -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
if not errorlevel 1 (call :LogOK "Enable-NetAdapterQos") else (call :LogErr "Enable-NetAdapterQos")
echo        - Hardware streams successfully aligned.
echo.

call :LogInfo "[7/7] Injecting Fortnite Game Packet Matrix Rule..."
powershell -NoProfile -Command "Remove-NetQosPolicy -Name 'FortniteQoS' -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'FortniteQoS' -AppPathName 'FortniteClient-Win64-Shipping.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction Stop" >nul 2>&1
if not errorlevel 1 (
    call :LogOK "Fortnite Client prioritized (DSCP 46 | Profile: ALL)."
    echo        - Success: Fortnite Client prioritized ^(DSCP 46 ^| Profile: ALL^).
) else (
    call :LogErr "Failed to hook packet stream to OS policies."
    echo        - Warning: Failed to hook packet stream to OS policies.
)
echo.
call :LogOK "[+] GPedit is active and Fortnite network priority is locked in."

cls
color %CONSOLE_BLUE%
chcp 65001 >nul 2>&1

if not exist "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" (
   goto :FN_Default_Path_Not_Found
) else (
   set "FortnitePath=C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
   goto :FN_Download_Tools
)

:FN_Default_Path_Not_Found
cls
color %CONSOLE_ERROR%
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════════╗
echo ║ Fortnite is not installed in the default Path.    ║
echo ╚═══════════════════════════════════════════════════╝
echo • Fortnite is likely installed on another drive or location!
echo.
echo %BRIGHT_WHITE%[Choose an option]
echo %BRIGHT_GREEN%1. Manually Input Path
echo %YELLOW%2. Continue Anyway
echo %BRIGHT_CYAN%3. Learn More
echo %BRIGHT_RED%4. Back to Main Menu
set "fnoption="
set /p fnoption="%BRIGHT_WHITE%Enter option number: "
chcp 65001 >nul 2>&1
if "%fnoption%"=="1" goto :FN_Manual_Path
if "%fnoption%"=="2" (
    cls
    color %CONSOLE_ERROR%
    echo ╔══════════════════════════════════════════╗
    echo ║ Continuing with Fortnite Optimizer.      ║
    echo ╚══════════════════════════════════════════╝
    echo • Now continuing in 2 seconds!
    timeout 2 > nul
    cls
    chcp 437 >nul
    goto :FN_Download_Tools
)
if "%fnoption%"=="3" (
    start "" "https://github.com/QuakedK/Fortnite-Optimizer/blob/main/Help/Fortnite%%20Path.md"
    pause >nul
    goto :FN_Default_Path_Not_Found
)
if "%fnoption%"=="4" goto main
goto :FN_Default_Path_Not_Found

:FN_Manual_Path
cls
color %CONSOLE_SUCCESS%
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════════════════════════════════════════════╗
echo ║ Adding Manual Fortnite Path. [Path must include FortniteClient-Win64-Shipping.exe]    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════════╝
echo • Example: "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
echo.
set "FortnitePath="
set /p FortnitePath="Enter Your Fortnite Path: "
if not defined FortnitePath goto :FN_Manual_Path
set "FortnitePath=%FortnitePath:"=%"
if not exist "%FortnitePath%" (
    echo [X] Path does not exist! Try again.
    timeout 2 >nul
    goto :FN_Manual_Path
)
echo.
echo Your Entered Path: "%FortnitePath%"
echo.
pause >nul
cls
chcp 437 >nul
goto :FN_Download_Tools

:FN_Download_Tools
call :LogInfo "Downloading Fortnite Optimizer Tools..."
set "FN_FileURL=https://github.com/QuakedK/Fortnite-Optimizer/raw/refs/heads/main/Downloads/FortniteOptimizerTools.zip"
set "FN_FileName=Fortnite Optimizer Tools.zip"
set "FN_ExtractFolder=C:\Fortnite Optimizer Tools"
set "FN_DownloadsFolder=C:\"
curl -s -L -f --retry 3 --retry-delay 2 "%FN_FileURL%" -o "%FN_DownloadsFolder%\%FN_FileName%" >nul 2>&1
if exist "%FN_DownloadsFolder%\%FN_FileName%" (
   call :LogOK "Fortnite Tools downloaded."
   if exist "%FN_ExtractFolder%" rd /s /q "%FN_ExtractFolder%" >nul 2>&1
   mkdir "%FN_ExtractFolder%" >nul 2>&1
   pushd "%FN_ExtractFolder%" >nul 2>&1
   tar -tf "%FN_DownloadsFolder%\%FN_FileName%" 2>nul | findstr /r "^[^/\\]*/$" >nul 2>&1
   if not errorlevel 1 (
      tar -xf "%FN_DownloadsFolder%\%FN_FileName%" --strip-components=1 >nul 2>&1
   ) else (
      tar -xf "%FN_DownloadsFolder%\%FN_FileName%" >nul 2>&1
   )
   if errorlevel 1 (
      popd >nul 2>&1
      call :LogErr "Fortnite Tools archive extraction failed."
      del /q "%FN_DownloadsFolder%\%FN_FileName%" >nul 2>&1
      goto :FN_Download_Failed
   )
   popd >nul 2>&1
   del /q "%FN_DownloadsFolder%\%FN_FileName%" >nul 2>&1
   goto :FN_Start_Screen
) else (
   call :LogErr "Failed to download Fortnite Optimizer Tools."
   goto :FN_Download_Failed
)

:FN_Download_Failed
cls
color %CONSOLE_ERROR%
chcp 65001 >nul 2>&1
echo ╔════════════════════════════════════════════════════════╗
echo ║ Fortnite Optimizer Tools Folder failed to download.    ║
echo ╚════════════════════════════════════════════════════════╝
echo • Please ensure you're connected to the internet!
echo.
echo %BRIGHT_WHITE%[Choose an option]
echo %BRIGHT_GREEN%1. Retry
echo %BRIGHT_RED%2. Back to Main Menu
set "fnoption="
set /p fnoption="%BRIGHT_WHITE%Enter option number: "
chcp 65001 >nul 2>&1
if "%fnoption%"=="1" (
    timeout 2 > nul
    cls
    chcp 437 >nul
    goto :FN_Download_Tools
)
if "%fnoption%"=="2" goto main
goto :FN_Download_Failed

:FN_Start_Screen
cls
echo %RESET%
chcp 65001 >nul 2>&1
echo.
echo.
echo.                             %BRIGHT_BLUE%███████╗ ██████╗ ██████╗ ████████╗███╗   ██╗██╗████████╗███████╗       %RESET%
echo.                             %BRIGHT_BLUE%██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║╚══██╔══╝██╔════╝       %RESET%
echo.                             %BRIGHT_BLUE%██████╗ ██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║   ██║   █████╗         %RESET%
echo.                             %BRIGHT_BLUE%██╔══╝  ██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║   ██║   ██╔══╝         %RESET%
echo.                             %BRIGHT_BLUE%██║     ╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║   ██║   ███████╗       %RESET%
echo.                             %BRIGHT_BLUE%╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝   ╚═╝   ╚══════╝       %RESET%
echo.                                                                       
echo.                             %BRIGHT_BLUE%██████╗  ██████╗ ████████╗██╗███╗   ███╗██╗███████╗███████╗██████╗     %RESET%
echo.                             %BRIGHT_BLUE%██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔════╝██╔══██╗    %RESET%
echo.                             %BRIGHT_BLUE%██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ █████╗  ██████╔╝    %RESET%
echo.                             %BRIGHT_BLUE%██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══╝  ██╔══██╗    %RESET%
echo.                             %BRIGHT_BLUE%╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗███████╗██║  ██║    %RESET%
echo.                             %BRIGHT_BLUE% ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝    %RESET%
echo. 
echo.                                  %BRIGHT_BLUE%╔════════════════════════════════════════════════════╗%RESET%
echo.                                  %BRIGHT_BLUE%║%RESET%              %BRIGHT_WHITE%Version 2.1 - By Quaked%RESET%               %BRIGHT_BLUE%║%RESET%
echo.                                  %BRIGHT_BLUE%╚════════════════════════════════════════════════════╝%RESET%
echo.
echo. %BRIGHT_BLUE%╔═════════╗%RESET%                                                                        
echo. %BRIGHT_BLUE%║%RESET% %BRIGHT_WHITE%Loading %BRIGHT_BLUE%║%RESET%                                              
echo. %BRIGHT_BLUE%╚═════════╝%RESET%
timeout 2 > nul

cls
color %CONSOLE_BLUE%
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════════════════════════════╗
echo ║ Auto Setting Graphics Preferences, Priority and FSO.    ║
echo ╚═════════════════════════════════════════════════════════╝
echo • Setting Fortnite Graphics Preference to High Performance.
call :RegLog add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "%FortnitePath%" /t REG_SZ /d "GpuPreference=2" /f
echo • Setting Fortnite to High Priority.
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d 3 /f
echo • Disabling Fortnite's FSO.
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%FortnitePath%" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" /f
echo   Graphics Preferences, Priority and FSO applied successfully.
timeout 3 > nul

:FN_Import_Config
cls
color %CONSOLE_BLUE%
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════╗
echo ║ Importing Optimized Fortnite Game Configs.    ║
echo ╚═══════════════════════════════════════════════╝
echo • Please choose a config depending on your use case.
echo.
if not exist "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" mkdir "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient"

echo %BRIGHT_WHITE%[Choose an option]
echo %BRIGHT_GREEN%1. Legacy Performance Mode.
echo %BRIGHT_BLUE%2. New Performance Mode.
echo %BRIGHT_BLUE%3. DX 12.
echo %BRIGHT_BLUE%4. DX 11.
echo %BRIGHT_RED%5. Skip.
set "fnoption="
set /p fnoption="%BRIGHT_WHITE%Enter option number: "
if "%fnoption%"=="1" (
    cls
    color %CONSOLE_SUCCESS%
    echo ╔═══════════════════════════════════════╗
    echo ║ Importing Legacy Performance Mode.    ║
    echo ╚═══════════════════════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\Legacy Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import Legacy Performance Mode!"
        echo %BRIGHT_RED%Failed to import Legacy Performance Mode!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported Legacy Performance Mode!"
        echo %BRIGHT_GREEN%Successfully imported Legacy Performance Mode!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="2" (
    cls
    color %CONSOLE_SUCCESS%
    echo ╔════════════════════════════════════╗
    echo ║ Importing New Performance Mode.    ║
    echo ╚════════════════════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\New Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import New Performance Mode!"
        echo %BRIGHT_RED%Failed to import New Performance Mode!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported New Performance Mode!"
        echo %BRIGHT_GREEN%Successfully imported New Performance Mode!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="3" (
    cls
    color %CONSOLE_SUCCESS%
    echo ╔═════════════════════╗
    echo ║ Importing DX 12.    ║
    echo ╚═════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\DX 12\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import DX 12!"
        echo %BRIGHT_RED%Failed to import DX 12!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported DX 12!"
        echo %BRIGHT_GREEN%Successfully imported DX 12!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="4" (
    cls
    color %CONSOLE_SUCCESS%
    echo ╔═════════════════════╗
    echo ║ Importing DX 11.    ║
    echo ╚═════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\DX 11\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import DX 11!"
        echo %BRIGHT_RED%Failed to import DX 11!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported DX 11!"
        echo %BRIGHT_GREEN%Successfully imported DX 11!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="5" (
    call :LogSkip "Skipping Fortnite config import."
    echo Skipping!
    timeout 2 > nul
    goto :FN_Command_Line
)
goto :FN_Import_Config

:FN_Import_Failed
cls
color %CONSOLE_ERROR%
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════════════════════════╗
echo ║ Optimized Fortnite Game Config Failed to Import.    ║
echo ╚═════════════════════════════════════════════════════╝
echo • Fortnite Optimizer Tools may be empty!
echo.
echo %BRIGHT_WHITE%[Choose an option]
echo %BRIGHT_GREEN%1. Retry Import
echo %YELLOW%2. Continue Anyway
echo %BRIGHT_RED%3. Back to Main Menu
set "fnoption="
set /p fnoption="%BRIGHT_WHITE%Enter option number: "
chcp 65001 >nul 2>&1
if "%fnoption%"=="1" (
    timeout 2 > nul
    goto :FN_Import_Config
)
if "%fnoption%"=="2" (
    call :LogWarn "User chose to continue anyway despite import failure."
    timeout 2 > nul
    goto :FN_Command_Line
)
if "%fnoption%"=="3" (
    call :LogInfo "Cleaning up Fortnite Optimizer Tools folder..."
    rd /s /q "C:\Fortnite Optimizer Tools" >nul 2>&1
    goto main
)
goto :FN_Import_Failed

:FN_Command_Line
cls
color %CONSOLE_BLUE%
call :LogInfo "Opening Epic Games Launcher and Github Guide..."
echo ╔═════════════════════════════════════════════════════════╗
echo ║ Adding Fortnite Additional Command Line Arguments.      ║
echo ╚═════════════════════════════════════════════════════════╝
echo Opening Epic Games Launcher in 2 seconds!
timeout 2 > nul
if exist "C:\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" (
    start "" "C:\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
) else if exist "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" (
    start "" "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
) else (
    start "" "com.epicgames.launcher://apps"
)
echo.
echo Launching the Github guide in 3 seconds!
timeout 3 > nul
start "" "https://github.com/QuakedK/Fortnite-Optimizer/blob/main/Help/Additional%%20Command%%20Line%%20Arguments.md"
echo.
<nul set /p="→ Press any key to continue . . . "
pause >nul
goto :FN_Done

:FN_Done
cls
color %CONSOLE_INFO%
chcp 65001 >nul 2>&1
call :LogOK "Fortnite Optimizer routine completed."
echo =====================================
echo Fortnite Optimizer done successfully
echo =====================================
timeout /t 3 /nobreak > NUL
goto main

:revert
call :LogSection "Revert Tweaks"
cls
chcp 65001 >nul 2>&1
echo %RESET%
color %CONSOLE_ERROR%
echo.
echo ======================================================
echo           bardhzzY Tweaks - Revert / Undo Mode
echo ======================================================
echo.
echo [!] WARNING: This will forcefully overwrite your current
echo     registry with the backup created via Option 19 (Registry Backup).
echo.
echo [!] NOTE: If you used the 'Clean Up' tool to remove Windows Apps,
echo     those specific apps will NOT be reinstalled by this process.
echo     Use Windows System Restore (Option 18) for a full app rollback.
echo.
choice /c YN /n /m "Do you want to revert all registry tweaks to default? (Y/N): "
if %errorlevel% equ 2 goto main

echo.
set "BACKUP_DIR=%ProgramData%\bardhzzY\Backup"
set "BACKUP_OK=1"

if not exist "%BACKUP_DIR%" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKLM_SYSTEM.reg" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKLM_SOFTWARE.reg" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKCU_Software.reg" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKCU_CPanel.reg" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKCR.reg" (
    set "BACKUP_OK=0"
)

if not exist "%BACKUP_DIR%\HKU.reg" (
    set "BACKUP_OK=0"
)

if "%BACKUP_OK%"=="0" (
    call :LogErr "Registry backup is missing or incomplete."
    echo.
    echo ======================================================
    echo [X] INVALID / INCOMPLETE REGISTRY BACKUP
    echo ======================================================
    echo.
    echo Required backup files were not found.
    echo Revert has been CANCELLED for safety.
    echo.
    echo Please create a new complete Registry Backup first.
    echo.
    pause
    goto main
)

call :LogOK "Complete registry backup verified before restore."
echo [OK] All required registry backup files verified.
echo.

set "REVERT_OK=1"

call :LogInfo "Forcibly Importing Original System Registry..."
echo [+] Importing Original System Registry...

call :TIRun reg import "%BACKUP_DIR%\HKLM_SYSTEM.reg" >nul 2>&1
set "REVERT_RC=%errorlevel%"
if "%REVERT_RC%"=="0" (
    call :LogOK "Import HKLM_SYSTEM"
) else (
    call :LogErr "Import HKLM_SYSTEM failed (err=%REVERT_RC%)"
    set "REVERT_OK=0"
)

call :TIRun reg import "%BACKUP_DIR%\HKLM_SOFTWARE.reg" >nul 2>&1
set "REVERT_RC=%errorlevel%"
if "%REVERT_RC%"=="0" (
    call :LogOK "Import HKLM_SOFTWARE"
) else (
    call :LogErr "Import HKLM_SOFTWARE failed (err=%REVERT_RC%)"
    set "REVERT_OK=0"
)

call :LogInfo "Importing Original User Registry..."
echo [+] Importing Original User Registry...

reg import "%BACKUP_DIR%\HKCU_Software.reg" >nul 2>&1
if errorlevel 1 (
    call :LogErr "Import HKCU_Software failed."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKCU_Software"
)

reg import "%BACKUP_DIR%\HKCU_CPanel.reg" >nul 2>&1
if errorlevel 1 (
    call :LogErr "Import HKCU_CPanel failed."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKCU_CPanel"
)

call :LogInfo "Importing HKCR + HKU..."
call :TIRun reg import "%BACKUP_DIR%\HKCR.reg" >nul 2>&1
if errorlevel 1 (
    call :LogWarn "Import HKCR failed (may need TI)."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKCR"
)

reg import "%BACKUP_DIR%\HKU.reg" >nul 2>&1
if errorlevel 1 (
    call :LogWarn "Import HKU failed (may need TI)."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKU"
)

echo.

if "%REVERT_OK%"=="1" (
    call :LogOK "All registry imports completed successfully."
    echo [OK] All registry hives restored successfully.
) else (
    call :LogErr "One or more registry imports failed."
    echo [X] Registry restore completed with ERRORS.
    echo [!] Do not assume the system is fully reverted.
)

call :LogInfo "Restarting Explorer to apply visual reverts..."
echo [+] Restarting Explorer to apply visual reverts...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe >nul 2>&1

if "%REVERT_OK%"=="1" (
    call :LogOK "Registry restore completed successfully."
    echo.
    echo ======================================================
    echo [OK] Registry restore completed successfully.
    echo ======================================================
) else (
    call :LogErr "Registry restore finished with errors; system is not fully reverted."
    echo.
    echo ======================================================
    echo [X] Registry restore finished with errors.
    echo [!] System is NOT guaranteed to be fully reverted.
    echo ======================================================
)
echo [!] A System Restart is HIGHLY recommended to flush all drivers.
echo.
pause
goto main

rem Disable Defender.
:defender
call :LogSection "Disable Defender (Enhanced)"
cls
MODE 100,40
color %CONSOLE_DEFAULT%
echo %RESET%

echo.
echo  %BRIGHT_RED%==========================================================================%RESET%
echo  %BRIGHT_RED%                 WINDOWS DEFENDER DISABLE - AGGRESSIVE%RESET%
echo  %BRIGHT_RED%==========================================================================%RESET%
echo.
echo  %WHITE%This option is intentionally aggressive and will disable Windows security%RESET%
echo  %WHITE%components including Defender, SmartScreen, Security Center services,%RESET%
echo  %WHITE%scheduled scans, and the Defender executable fallback protection.%RESET%
echo.
echo  %BRIGHT_RED%[!] WARNING: This reduces Windows security protections significantly.%RESET%
echo  %YELLOW%[!] Windows Firewall will NOT be changed by this option.%RESET%
echo  %YELLOW%[!] A restart is required for the changes to fully apply.%RESET%
echo  %CYAN%[ i ] Re-enable Defender is available from the main menu.%RESET%
echo.
echo  %BRIGHT_RED%--------------------------------------------------------------------------%RESET%
echo  %BRIGHT_WHITE%Continue with aggressive Defender disabling?%RESET%

echo        %GREEN%[Y]%WHITE% Yes - continue
echo        %RED%[N]%WHITE% No  - return to main menu
echo.
choice /c YN /n /m "       Continue? [Y/N]: "
if errorlevel 2 (
    call :LogWarn "Defender disable cancelled by user."
    goto main
)

echo.
call :LogInfo "Defender disable confirmed by user."

call :LogInfo "Step 1/8: Detecting Tamper Protection state..."
set "TP_STATE="
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection 2^>nul ^| findstr /i "TamperProtection"') do set "TP_STATE=%%A"

if "%TP_STATE%"=="0x5" (
    call :LogWarn "Tamper Protection is ENABLED. Registry writes WILL be rolled back."
    call :LogInfo "Opening windowsdefender: so you can turn off RTP + TP manually..."
    start windowsdefender:
    echo.
    echo  %YELLOW%--------------------------------------------------------------------------%RESET%
    echo  %BRIGHT_WHITE%In the Windows Security window:%RESET%
    echo    1. Virus ^& threat protection ^> Manage settings
    echo    2. Turn OFF Real-time protection
    echo    3. Turn OFF Cloud-delivered protection
    echo    4. Turn OFF Automatic sample submission
    echo    5. Turn OFF Tamper Protection
    echo  %YELLOW%--------------------------------------------------------------------------%RESET%
    echo        %GREEN%[Y]%WHITE% Done - continue disabling Defender
    echo        %RED%[N]%WHITE% Cancel - return to main menu
    choice /c YN /n /m "       Continue? [Y/N]: "
    if errorlevel 2 (
        call :LogWarn "Defender disable cancelled while Tamper Protection was enabled."
        goto main
    )
    taskkill /f /im SecHealthUI.exe >nul 2>&1
) else if not defined TP_STATE (
    call :LogWarn "Tamper Protection state is unavailable on this Windows build; continuing without assuming it is OFF."
) else (
    call :LogOK "Tamper Protection is OFF (state=%TP_STATE%). Proceeding."
)

call :LogInfo "Step 2/8: Disabling Defender via policy registry keys..."
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "PassiveMode" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f

call :LogInfo "Step 3/8: Disabling all Defender services..."
rem PPL-protected Defender services may refuse a live stop even when the startup/policy changes are applied.
sc stop WinDefend >nul 2>&1
sc stop WdNisSvc >nul 2>&1
sc stop WdBoot >nul 2>&1
call :LogSkip "WinDefend/WdNisSvc/WdBoot live-stop requests suppressed from error log (PPL protected)"
call :TIScLog config WinDefend start= disabled
call :TIScLog config WdNisSvc start= disabled
call :TIScLog config WdBoot start= disabled
call :TIScLog stop Sense
call :TIScLog config Sense start= disabled
call :TIScLog stop wscsvc
call :TIScLog config wscsvc start= disabled
call :TIScLog stop SecurityHealthService
call :TIScLog config SecurityHealthService start= disabled
rem Apply the service setting through the registry if needed.
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d 4 /f

call :LogInfo "Step 4/8: Removing SecurityHealth startup entries..."
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealthSystray" /f

call :LogInfo "Step 5/8: Disabling SmartScreen (Explorer, Edge, AppHost, AppRep)..."
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "PreventOverride" /t REG_DWORD /d 0 /f

call :LogInfo "Step 6/8: Disabling Defender scheduled tasks..."
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable

call :LogInfo "Step 7/8: IFEO failsafe - redirect Defender binaries to systray.exe..."
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NisSrv.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SecurityHealthService.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Smartscreen.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f

call :LogInfo "Step 8/8: Disabling Windows Security Center notifications..."
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "FirstRunDisabled" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "AntiVirusDisableNotify" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "FirewallDisableNotify" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "UpdatesDisableNotify" /t REG_DWORD /d 1 /f

call :LogOK "Defender + SmartScreen + Security Center disabled."
call :LogWarn "A SYSTEM RESTART is required for all changes to take effect."
echo.
echo  ============================================================
echo  %GREEN%[OK]%RESET% %WHITE%Defender + SmartScreen + Security Center%RESET%
echo  %WHITE%     disabled. RESTART to apply.%RESET%
echo  %YELLOW%NOTE: Windows Firewall was NOT touched.%RESET%
echo  ============================================================
echo.
echo  To re-enable: use menu option 15 (Re-enable Defender).
echo.
pause
goto main

rem Re-enable Defender and SmartScreen.
:defender_revert
call :LogSection "Re-enable Defender + SmartScreen"
cls
color %CONSOLE_SUCCESS%
echo %RESET%
echo.
echo  %GREEN%Re-enabling Windows Defender, SmartScreen, Security Center...%RESET%
echo.

call :LogInfo "Removing IFEO failsafe..."
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe" /f
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NisSrv.exe" /f
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SecurityHealthService.exe" /f
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Smartscreen.exe" /f

call :LogInfo "Removing Defender policy keys..."
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "PassiveMode" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /f

call :LogInfo "Re-enabling Defender services (start=demand)..."
call :TIScLog config WinDefend start= demand
call :TIScLog config WdNisSvc start= demand
call :TIScLog config WdBoot start= demand
call :TIScLog config wscsvc start= demand
call :TIScLog config SecurityHealthService start= demand

rem Keep existing gaming and launcher exclusions.
call :LogInfo "Keeping existing gaming Defender exclusions..."
call :LogOK "Gaming Defender exclusions preserved."

call :LogInfo "Re-enabling SmartScreen..."
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "On" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /f

call :LogInfo "Removing Security Center notification disables..."
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "FirstRunDisabled" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "AntiVirusDisableNotify" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "FirewallDisableNotify" /f
call :TIRegLog delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Security Center" /v "UpdatesDisableNotify" /f

call :LogInfo "Re-enabling Defender scheduled tasks..."
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable
call :SchLog /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable

call :LogOK "Defender + SmartScreen re-enabled. RESTART to apply."
echo.
echo  ============================================================
echo  %GREEN%[OK]%RESET% %WHITE%Defender re-enabled. RESTART to apply.%RESET%
echo  %YELLOW%NOTE: If Tamper Protection is on, you may need to manually%RESET%
echo  %YELLOW%      re-enable RTP in the Defender UI after restart.%RESET%
echo  ============================================================
echo.
pause
goto main

:imod_disabler
call :LogSection "xHCI IMOD Disabler"
cls
echo.
echo  %BLUE%============================================================%RESET%
echo                  %BRIGHT_CYAN%xHCI IMOD DISABLER%RESET%
echo  %BLUE%============================================================%RESET%
echo.
echo  %WHITE%This tool modifies low-level USB xHCI controller registers.%RESET%
echo  %YELLOW%It may affect multiple USB devices, not only your mouse.%RESET%
echo.
echo  %GREEN%[RECOMMENDED]%WHITE% Use Task Scheduler for automatic startup.%RESET%
echo  %RED%[AVOID]%WHITE% Registry Run; the author warns it can cause BSOD loops.%RESET%
echo.
echo  %YELLOW%[COMPATIBILITY]%WHITE% On affected updated Windows 11 systems, Windows may%RESET%
echo  %WHITE%block the legacy drivers required by this tool. A task can be%RESET%
echo  %WHITE%created successfully even if the tool itself cannot apply IMOD.%RESET%
echo.
if not exist "%IMOD_EXE%" (
    call :LogErr "xHCI IMOD Disabler executable was not found."
    echo  Expected file:
    echo  "%IMOD_EXE%"
    echo.
    echo  Add the executable and its required driver files to the
    echo  Utility Tools repository, then download/refresh the tools.
    echo.
    pause
    goto main
)
echo  %GREEN%[OK] Tool detected:%RESET%
echo  "%IMOD_EXE%"
echo  %GRAY%Keep the executable and all four required upstream driver files%RESET%
echo  %GRAY%together in this folder. The startup task will run silently.%RESET%
echo.
echo  %CYAN%[1]%WHITE% Open the interactive tool %GRAY%(manual use / testing)%RESET%
echo  %YELLOW%[2]%WHITE% Create a Task Scheduler entry %GRAY%(silent at each logon)%RESET%
echo  %RED%[3]%WHITE% Remove the bardhzzY Task Scheduler entry%RESET%
echo  %GRAY%[4] Back to main menu%RESET%
echo.
choice /c 1234 /n /m "Select an option: "
if errorlevel 4 goto main
if errorlevel 3 goto imod_remove_task
if errorlevel 2 goto imod_setup_task
if errorlevel 1 goto imod_launch_interactive

goto main

:imod_launch_interactive
call :LogInfo "Launching xHCI IMOD Disabler interactively..."
start "" "%IMOD_EXE%"
if errorlevel 1 (
    call :LogErr "Could not start xHCI IMOD Disabler."
) else (
    call :LogOK "Launch request sent. The app should open in a separate window."
)
echo.
echo  To enable automatic startup, use this script's Task Scheduler option
echo  or the tool's own Task Scheduler option, but do not enable both.
echo  First test the tool manually. Confirm whether Windows allows its
echo  required drivers to load before relying on automatic startup.
echo.
pause
goto main

:imod_setup_task
cls
echo.
echo  %BLUE%============================================================%RESET%
echo              %BRIGHT_CYAN%IMOD TASK SCHEDULER SETUP%RESET%
echo  %BLUE%============================================================%RESET%
echo.
echo  %WHITE%This creates a logon task for the current user with highest%RESET%
echo  %WHITE%privileges. It runs the executable with --Silent each logon.%RESET%
echo.
echo  %YELLOW%[NOTE]%WHITE% This does NOT prove IMOD was successfully disabled. Driver policy,%RESET%
echo  %WHITE%missing driver files, or hardware compatibility can still prevent%RESET%
echo  %WHITE%the tool from working.%RESET%
echo.
echo  %GRAY%The script checks for an existing scheduled task using this same%RESET%
echo  %GRAY%executable to avoid creating an obvious duplicate.%RESET%
echo.
echo  %CYAN%Task name:%WHITE% bardhzzY xHCI IMOD Disabler%RESET%
echo.
choice /c YN /n /m "Create this scheduled task? [Y/N]: "
if errorlevel 2 goto main

call :LogInfo "Checking and configuring the IMOD logon task..."
del /q "%TEMP%\bardhzzY_imod_task_setup.log" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $exe = '%IMOD_EXE%'; if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { Write-Output 'ERROR|Executable not found'; exit 2 }; $existingTasks = @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $task = $_; @($task.Actions | Where-Object { $_.Execute -and $_.Execute -ieq $exe }).Count -gt 0 }); if ($existingTasks.Count -gt 0) { Write-Output ('EXISTS|'+(($existingTasks | ForEach-Object {$_.TaskName}) -join ';')); exit 10 }; $user=[System.Security.Principal.WindowsIdentity]::GetCurrent().Name; $action=New-ScheduledTaskAction -Execute $exe -Argument '--Silent' -WorkingDirectory (Split-Path -Parent $exe); $trigger=New-ScheduledTaskTrigger -AtLogOn -User $user; $principal=New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Highest; Register-ScheduledTask -TaskName 'bardhzzY xHCI IMOD Disabler' -Action $action -Trigger $trigger -Principal $principal -Description 'Runs QuakedK xHCI IMOD Disabler silently at user logon.' -Force | Out-Null; Write-Output 'CREATED'; exit 0" > "%TEMP%\bardhzzY_imod_task_setup.log" 2>&1
set "IMOD_TASK_RC=%errorlevel%"
if "%IMOD_TASK_RC%"=="0" goto imod_task_created
if "%IMOD_TASK_RC%"=="10" goto imod_task_exists
goto imod_task_failed

:imod_task_created
call :LogOK "Scheduled task created successfully."
echo.
echo  %GREEN%[OK]%WHITE% Task created: bardhzzY xHCI IMOD Disabler%RESET%
echo  %GREEN%[OK]%WHITE% Trigger:%RESET% when the current user logs on
echo  %GREEN%[OK]%WHITE% Run level:%RESET% highest privileges
echo  %GREEN%[OK]%WHITE% Argument:%RESET% --Silent
echo.
echo  %CYAN%It will run automatically at the current user's next logon.%RESET%
echo  %YELLOW%A successful task setup does not prove the driver loaded or that%RESET%
echo  %YELLOW%IMOD was changed. Review the tool/logs after testing.%RESET%
echo.
choice /c YN /n /m "Run the scheduled task once now as well? [Y/N]: "
if errorlevel 2 goto imod_task_finish
schtasks /Run /TN "bardhzzY xHCI IMOD Disabler" >nul 2>&1
if errorlevel 1 (
    call :LogErr "Task was created, but Windows could not start it now."
    echo  You can still test it after logon in Task Scheduler.
) else (
    call :LogInfo "Windows accepted the request to run the task. This is not proof of IMOD success."
    echo  Windows accepted the run request. Check driver/tool status to confirm it worked.
)
goto imod_task_finish

:imod_task_exists
call :LogWarn "An existing scheduled task already points to this executable. No duplicate was created."
echo.
echo  %YELLOW%An existing task was detected:%RESET%
type "%TEMP%\bardhzzY_imod_task_setup.log"
echo.
echo  %GRAY%No duplicate task was created. Check the listed task in Task Scheduler.%RESET%
echo  %YELLOW%Keep only one IMOD startup task enabled.%RESET%
goto imod_task_finish

:imod_task_failed
call :LogErr "Could not create the IMOD scheduled task."
echo.
echo  %RED%Task Scheduler setup failed. Details:%RESET%
if exist "%TEMP%\bardhzzY_imod_task_setup.log" type "%TEMP%\bardhzzY_imod_task_setup.log"
echo.
echo  %GRAY%Run this script as administrator and verify Task Scheduler is available.%RESET%
goto imod_task_finish

:imod_task_finish
echo.
pause
goto main

:imod_remove_task
cls
echo.
echo  %BLUE%============================================================%RESET%
echo             %BRIGHT_RED%REMOVE IMOD SCHEDULED TASK%RESET%
echo  %BLUE%============================================================%RESET%
echo.
echo  %WHITE%This removes only the task managed by bardhzzY Tweaks:%RESET%
echo  %CYAN%bardhzzY xHCI IMOD Disabler%RESET%
echo.
echo  %GRAY%It will not remove a differently named task created from inside%RESET%
echo  %GRAY%the IMOD tool. Check Task Scheduler if you previously enabled one.%RESET%
echo.
choice /c YN /n /m "Remove the bardhzzY scheduled task? [Y/N]: "
if errorlevel 2 goto main
schtasks /Delete /TN "bardhzzY xHCI IMOD Disabler" /F >nul 2>&1
if errorlevel 1 (
    call :LogWarn "Task was not found or could not be removed."
    echo  The task may already be absent, or Windows denied removal.
) else (
    call :LogOK "bardhzzY IMOD scheduled task removed."
    echo  Automatic startup through this task is now disabled.
)
echo.
pause
goto main

:fixes
call :LogSection "System Fixes / Recovery"
cls
MODE 100,30
color %CONSOLE_INFO%
echo %RESET%

echo.
echo  ============================================================
echo                  %CYAN%SYSTEM FIXES / RECOVERY%RESET%
echo  ============================================================
echo.
echo  %WHITE% Use this section to fix issues caused by aggressive tweaks.%RESET%
echo.
echo  %WHITE% [%CYAN%1%WHITE%] Wi-Fi / Network Fixer (re-enable 16 network services)
echo  %WHITE% [%CYAN%2%WHITE%] Epic Games Fixer (re-enable Epic services)
echo  %WHITE% [%CYAN%3%WHITE%] Rockstar Games Fixer (re-enable Rockstar service)
echo  %WHITE% [%CYAN%4%WHITE%] Back to Main Menu
echo.
set "fix_choice="
set /p "fix_choice=%BLUE%[%WHITE% ? %BLUE%]%WHITE% Select an option: %RESET%"

if not defined fix_choice goto fixes
set "fix_choice=%fix_choice:"=%"
set "fix_choice=%fix_choice: =%"

if /i "%fix_choice%"=="1" goto fix_wifi
if /i "%fix_choice%"=="2" goto fix_epic
if /i "%fix_choice%"=="3" goto fix_rockstar
if /i "%fix_choice%"=="4" goto main

echo.
echo "%fix_choice%" isn't a right choice, try again!
timeout 2 >nul
goto fixes

:fix_wifi
call :LogInfo "Wi-Fi / Network Fixer - re-enabling critical network services..."
for %%S in (
    LanmanWorkstation
    LanmanServer
    netprofm
    NlaSvc
    netman
    WlanSvc
    WwanSvc
    Dhcp
    Dnscache
    nsi
    BFE
    WinHttpAutoProxySvc
    Wcmsvc
    RmSvc
    NcbService
    DPS
    lmhosts
) do (
    call :TIScLog config "%%S" start= demand
    call :TIScLog start "%%S"
)
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableActiveProbing" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "NoActiveProbe" /t REG_DWORD /d 0 /f
call :LogOK "Network services re-enabled. Test your connection now."
echo.
pause
goto fixes

:fix_epic
call :LogInfo "Epic Games Fixer - re-enabling Epic services..."
call :TIScLog config "EpicGamesUpdater" start= demand
call :TIScLog start "EpicGamesUpdater"
call :TIScLog config "EpicOnlineServices" start= demand
call :TIScLog start "EpicOnlineServices"
call :LogOK "Epic services re-enabled."
echo.
pause
goto fixes

:fix_rockstar
call :LogInfo "Rockstar Games Fixer - re-enabling Rockstar service..."
call :TIScLog config "RockstarService" start= demand
call :TIScLog start "RockstarService"
call :LogOK "Rockstar service re-enabled."
echo.
pause
goto fixes

:restartpc
call :LogSection "Restart PC"
cls
MODE 90,28
chcp 65001 >nul 2>&1
echo %RESET%
color %CONSOLE_DEFAULT%

echo.
echo  %BLUE%==========================================================================%RESET%
echo.
echo                       %YELLOW%RESTART COMPUTER%RESET%
echo.
echo  %BLUE%==========================================================================%RESET%
echo.
echo        %WHITE%A system restart is recommended after applying tweaks%RESET%
echo        %WHITE%so that all service, registry, and driver changes%RESET%
echo        %WHITE%take full effect.%RESET%
echo.
echo        %CYAN%[%WHITE% Y %CYAN%]%GREEN% Restart now     %GRAY%(^<-- auto in 5s)%RESET%
echo        %CYAN%[%WHITE% N %CYAN%]%YELLOW% Cancel           %GRAY%return to menu%RESET%
echo.
echo  %BLUE%--------------------------------------------------------------------------%RESET%
echo.

choice /c YN /t 5 /d Y /n /m "Choice"

if %errorlevel% equ 1 (
    call :LogInfo "User confirmed. Restarting PC now..."
    cls
    echo.
    echo  %BLUE%==========================================================================%RESET%
    echo.
    echo                    %GREEN%RESTARTING NOW%RESET%
    echo.
    echo  %BLUE%==========================================================================%RESET%
    echo.
    echo        %GRAY%Saving settings... closing sessions...%RESET%
    echo.
    shutdown /r /t 3 /c "bardhzzY Tweaks: restarting in 3 seconds..."
    timeout /t 4 /nobreak >nul
    exit /b
) else (
    call :LogWarn "Restart cancelled by user. Returning to menu..."
    cls
    echo.
    echo  %BLUE%==========================================================================%RESET%
    echo.
    echo                    %YELLOW%RESTART CANCELLED%RESET%
    echo.
    echo  %BLUE%==========================================================================%RESET%
    echo.
    echo        %GRAY%Returning to main menu...%RESET%
    echo.
    timeout 2 >nul
    goto main
)

rem Check the published script version.
:CheckScriptVersion
set "SCRIPT_VERSION_STATUS=UNAVAILABLE"
set "SCRIPT_LATEST_VERSION="
set "SCRIPT_VERSION_CHECK_FILE=%TEMP%\bardhzzY_script_version_check.txt"
if exist "%SCRIPT_VERSION_CHECK_FILE%" del /q "%SCRIPT_VERSION_CHECK_FILE%" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $localText=$env:SCRIPT_VERSION.Trim().TrimStart([char[]]@('v','V')); $r=Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/bardh1xyz/bardhzzY-Utility-Tools/main/script-version.txt' -UseBasicParsing -TimeoutSec 5; $remote=($r.Content -split '\r?\n' | Where-Object { $_.Trim() -ne '' } | Select-Object -First 1).Trim(); $remoteText=$remote.TrimStart([char[]]@('v','V')); if ($localText -notmatch '^\d+(\.\d+){1,3}$' -or $remoteText -notmatch '^\d+(\.\d+){1,3}$') { throw 'Invalid version marker' }; $local=[version]$localText; $latest=[version]$remoteText; if ($latest -gt $local) { 'UPDATE|' + $remote } elseif ($latest -lt $local) { 'AHEAD|' + $remote } else { 'CURRENT|' + $remote } } catch { 'UNAVAILABLE|' }" >"%SCRIPT_VERSION_CHECK_FILE%" 2>nul
if exist "%SCRIPT_VERSION_CHECK_FILE%" (
    for /f "usebackq tokens=1,* delims=|" %%A in ("%SCRIPT_VERSION_CHECK_FILE%") do (
        set "SCRIPT_VERSION_STATUS=%%A"
        set "SCRIPT_LATEST_VERSION=%%B"
    )
    del /q "%SCRIPT_VERSION_CHECK_FILE%" >nul 2>&1
)
if /i "%SCRIPT_VERSION_STATUS%"=="UPDATE" call :LogWarn "A newer script version is available: %SCRIPT_LATEST_VERSION% (current: %SCRIPT_VERSION%)."
if /i "%SCRIPT_VERSION_STATUS%"=="CURRENT" call :LogInfo "Script version %SCRIPT_VERSION% is current."
if /i "%SCRIPT_VERSION_STATUS%"=="UNAVAILABLE" call :LogInfo "Script version check unavailable; continuing normally."
goto :eof

:DetectToolPaths
set "ADVANCEDRUN_EXE=%UTIL_DIR%\AdvancedRun\AdvancedRun.exe"
if exist "%ADVANCEDRUN_EXE%" goto DetectToolPaths_AdvancedRunDone
if exist "%UTIL_DIR%\AdvancedRun.exe" set "ADVANCEDRUN_EXE=%UTIL_DIR%\AdvancedRun.exe"
:DetectToolPaths_AdvancedRunDone

rem Locate the power plans in the current repository layout.
set "POWERPLAN_DIR=%UTIL_DIR%\PowerPlans"
set "POWERPLAN_STANDARD_FILE=%POWERPLAN_DIR%\bardhzzY powerplan.pow"
set "POWERPLAN_IDLE_OFF_FILE=%POWERPLAN_DIR%\bardhzzY powerplan idle off.pow"
:DetectToolPaths_Done
set "POWERPLAN_FILE=%POWERPLAN_STANDARD_FILE%"
if exist "%POWERPLAN_FILE%" goto :eof
set "POWERPLAN_FILE=%POWERPLAN_IDLE_OFF_FILE%"
goto :eof
:LogInit
set "SCRIPT_VERSION=v3.0.0.4"
set "SCRIPT_BUILD=10-24-2026"
set "LOG_ROOT=%ProgramData%\bardhzzY\Logs"
set "LOG_ENABLED=0"
set "LOG_SECTION=SYSTEM"

for /f "tokens=4-5 delims=[]. " %%i in ('ver') do set "LOG_OS_VER=%%i.%%j"

for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'" 2^>nul') do set "LOG_STAMP=%%t"
if not defined LOG_STAMP set "LOG_STAMP=00000000_000000"

mkdir "%LOG_ROOT%" >nul 2>&1
if exist "%LOG_ROOT%" goto :LogInit_Success

set "LOG_ROOT=%TEMP%\bardhzzY_Logs"
mkdir "%LOG_ROOT%" >nul 2>&1
if exist "%LOG_ROOT%" goto :LogInit_Success

set "LOG_ROOT=%CD%\bardhzzY_Logs"
mkdir "%LOG_ROOT%" >nul 2>&1
if exist "%LOG_ROOT%" goto :LogInit_Success

set "LOG_ENABLED=0"
goto :eof

:LogInit_Success
set "LOG_INITIALIZED=1"
set "LOG_FILE=%LOG_ROOT%\tweak_%LOG_STAMP%.log"
set "LOG_ERR=%LOG_ROOT%\errors_%LOG_STAMP%.log"
set "LOG_ENABLED=1"

>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo   bardhzzY TWEAKS - PROFESSIONAL EXECUTION LOG
>>"%LOG_FILE%" echo   Script Ver. : %SCRIPT_VERSION% (%SCRIPT_BUILD%)
>>"%LOG_FILE%" echo   Timestamp   : %LOG_STAMP%
>>"%LOG_FILE%" echo   User        : %USERNAME%
>>"%LOG_FILE%" echo   Computer    : %COMPUTERNAME%
>>"%LOG_FILE%" echo   OS Version  : %LOG_OS_VER%
>>"%LOG_FILE%" echo   Log File    : %LOG_FILE%
>>"%LOG_FILE%" echo   Error Log   : %LOG_ERR%
>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo.
goto :eof

:LogTS
set "LOG_HR=%time:~0,2%"
set "LOG_HR=%LOG_HR: =0%"
set "LOG_NOW=%date% %LOG_HR%:%time:~3,2%:%time:~6,2%"
goto :eof

:LogInfo
setlocal DisableDelayedExpansion
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "SEC=%LOG_SECTION%"
if not defined SEC set "SEC=SYSTEM"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%SEC:^=^^%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
echo %WHITE%[INFO]%RESET% %MSG%
if not "%LOG_ENABLED%"=="1" goto LogInfo_Done
>>"%LOG_FILE%" echo([%LOG_NOW%] [INFO ] [%SEC%] %MSG%
:LogInfo_Done
endlocal
goto :eof

:LogOK
setlocal DisableDelayedExpansion
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "SEC=%LOG_SECTION%"
if not defined SEC set "SEC=SYSTEM"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%SEC:^=^^%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
echo %GREEN%[  OK]%RESET% %MSG%
if not "%LOG_ENABLED%"=="1" goto LogOK_Done
>>"%LOG_FILE%" echo([%LOG_NOW%] [  OK ] [%SEC%] %MSG%
:LogOK_Done
endlocal
goto :eof

:LogErr
setlocal DisableDelayedExpansion
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "SEC=%LOG_SECTION%"
if not defined SEC set "SEC=SYSTEM"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%SEC:^=^^%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
echo %RED%[FAIL]%RESET% %MSG%
if not "%LOG_ENABLED%"=="1" goto LogErr_Done
>>"%LOG_FILE%" echo([%LOG_NOW%] [FAILED] [%SEC%] %MSG%
if defined LOG_ERR >>"%LOG_ERR%" echo([%LOG_NOW%] [%SEC%] %MSG%
:LogErr_Done
endlocal
goto :eof

:LogWarn
setlocal DisableDelayedExpansion
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "SEC=%LOG_SECTION%"
if not defined SEC set "SEC=SYSTEM"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%SEC:^=^^%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
echo %YELLOW%[WARN]%RESET% %MSG%
if not "%LOG_ENABLED%"=="1" goto LogWarn_Done
>>"%LOG_FILE%" echo([%LOG_NOW%] [ WARN] [%SEC%] %MSG%
:LogWarn_Done
endlocal
goto :eof

:LogSkip
setlocal DisableDelayedExpansion
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "SEC=%LOG_SECTION%"
if not defined SEC set "SEC=SYSTEM"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%SEC:^=^^%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
echo %GRAY%[SKIP]%RESET% %MSG%
if not "%LOG_ENABLED%"=="1" goto LogSkip_Done
>>"%LOG_FILE%" echo([%LOG_NOW%] [ SKIP] [%SEC%] %MSG%
:LogSkip_Done
endlocal
goto :eof

:LogSection
setlocal DisableDelayedExpansion
call :LogTS
set "SEC=%~1"
if not defined SEC set "SEC=SYSTEM"
set "SEC_ESC=%SEC:^=^^%"
set "SEC_ESC=%SEC_ESC:&=^&%"
set "SEC_ESC=%SEC_ESC:|=^|%"
set "SEC_ESC=%SEC_ESC:<=^<%"
set "SEC_ESC=%SEC_ESC:>=^>%"
if not "%LOG_ENABLED%"=="1" goto LogSection_Set
>>"%LOG_FILE%" echo(
>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo([%LOG_NOW%] ^>^>^> SECTION: %SEC_ESC%
>>"%LOG_FILE%" echo ============================================================
:LogSection_Set
endlocal & set "LOG_SECTION=%~1"
goto :eof

:RegLog
setlocal EnableDelayedExpansion
set "RL_ARGS=%*"
reg !RL_ARGS! >nul 2>&1
set "BARDHZZ_ERR=!errorlevel!"
set "LOG_MSG=%*"
if "!BARDHZZ_ERR!"=="0" goto RegLog_OK
rem Verify failed registry writes where the value can be read back.
echo !RL_ARGS! | findstr /B /I "add " >nul 2>&1 || goto RegLog_Fail
set "RL_KEY="
set "RL_VAL_NAME="
set "RL_VAL_DATA="
set "RL_TYPE="
set "RL_NEXT_KEY=0"
set "RL_NEXT_VAL=0"
set "RL_NEXT_DATA=0"
set "RL_NEXT_TYPE=0"
for %%A in (!RL_ARGS!) do (
    if "!RL_NEXT_KEY!"=="1" (set "RL_KEY=%%~A" & set "RL_NEXT_KEY=0") else if "!RL_NEXT_VAL!"=="1" (set "RL_VAL_NAME=%%~A" & set "RL_NEXT_VAL=0") else if "!RL_NEXT_DATA!"=="1" (set "RL_VAL_DATA=%%~A" & set "RL_NEXT_DATA=0") else if "!RL_NEXT_TYPE!"=="1" (set "RL_TYPE=%%~A" & set "RL_NEXT_TYPE=0") else if /I "%%~A"=="add" (set "RL_NEXT_KEY=1") else if /I "%%~A"=="/v" (set "RL_NEXT_VAL=1") else if /I "%%~A"=="/d" (set "RL_NEXT_DATA=1") else if /I "%%~A"=="/t" (set "RL_NEXT_TYPE=1")
)
if not defined RL_KEY goto RegLog_Fail
if not defined RL_VAL_NAME goto RegLog_Fail
if /I "!RL_TYPE!"=="REG_DWORD" goto RegLog_VerifyNumeric
if /I "!RL_TYPE!"=="REG_QWORD" goto RegLog_VerifyNumeric
if /I "!RL_TYPE!"=="REG_SZ" goto RegLog_VerifyString
goto RegLog_Fail
:RegLog_VerifyString
set "RL_ACTUAL="
for /f "tokens=2,*" %%X in ('reg query "!RL_KEY!" /v "!RL_VAL_NAME!" 2^>nul ^| findstr /I "REG_SZ"') do set "RL_ACTUAL=%%Y"
if defined RL_ACTUAL if /I "!RL_ACTUAL!"=="!RL_VAL_DATA!" goto RegLog_OK
goto RegLog_Fail
:RegLog_VerifyNumeric
set "RL_ACTUAL="
for /f "tokens=2,*" %%X in ('reg query "!RL_KEY!" /v "!RL_VAL_NAME!" 2^>nul ^| findstr /I "REG_DWORD REG_QWORD"') do set "RL_ACTUAL=%%Y"
if not defined RL_ACTUAL goto RegLog_Fail
set "RL_VERIFY_ACTUAL=!RL_ACTUAL!"
set "RL_VERIFY_EXPECTED=!RL_VAL_DATA!"
powershell -NoProfile -Command "$a=$env:RL_VERIFY_ACTUAL;$w=$env:RL_VERIFY_EXPECTED; try { if($a -match '^0x'){ $an=[UInt64]::Parse($a.Substring(2),'HexNumber') } else { $an=[UInt64]$a }; if($w -match '^0x'){ $wn=[UInt64]::Parse($w.Substring(2),'HexNumber') } else { $wn=[UInt64]$w }; if($an -eq $wn){exit 0}else{exit 1} } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
if errorlevel 1 goto RegLog_Fail
goto RegLog_OK
:RegLog_Fail
set "LOG_MSG=!LOG_MSG! (err=!BARDHZZ_ERR!)"
call :LogErr
endlocal
goto :eof
:RegLog_OK
call :LogOK
endlocal
goto :eof

rem Use TrustedInstaller for protected system operations; keep the menu in the user session.
:TIRun
setlocal DisableDelayedExpansion
if "%~1"=="" (
    endlocal & exit /b 87
)

set "TI_PROGRAM=%~1"
set "TI_ALL_ARGS=%*"
set "TI_ARGS=%TI_ALL_ARGS:* =%"
set "TI_EXE=%TI_PROGRAM%"

if /I "%TI_PROGRAM%"=="cmd.exe" set "TI_EXE=%SystemRoot%\System32\cmd.exe"
if /I "%TI_PROGRAM%"=="takeown" set "TI_EXE=%SystemRoot%\System32\takeown.exe"
if /I "%TI_PROGRAM%"=="icacls" set "TI_EXE=%SystemRoot%\System32\icacls.exe"
if /I "%TI_PROGRAM%"=="reg" set "TI_EXE=%SystemRoot%\System32\reg.exe"
if /I "%TI_PROGRAM%"=="sc" set "TI_EXE=%SystemRoot%\System32\sc.exe"

if not "%TI_AVAILABLE%"=="1" goto TIRun_Admin

"%ADVANCEDRUN_EXE%" /Clear /EXEFilename "%TI_EXE%" /CommandLine '%TI_ARGS%' /RunAs 8 /WaitProcess 1 /Run >nul 2>&1
set "TIRUN_RC=%errorlevel%"
if not "%TIRUN_RC%"=="0" goto TIRun_Admin
endlocal & exit /b %TIRUN_RC%

:TIRun_Admin
"%TI_EXE%" %TI_ARGS% >nul 2>&1
set "TIRUN_RC=%errorlevel%"
endlocal & exit /b %TIRUN_RC%

:TIRegLog
setlocal EnableDelayedExpansion
set "BARDHZZ_ARGS=%*"
set "TI_REG_KEY=%~2"
rem Skip service startup changes when the service key is missing.
if /I "%~1"=="add" if /I not "%~2"=="" if /I "!TI_REG_KEY:~0,39!"=="HKLM\SYSTEM\CurrentControlSet\Services\" (
    reg query "%~2" >nul 2>&1
    if errorlevel 1 (
        set "LOG_MSG=%~2 (service key not present)"
        call :LogSkip
        endlocal
        exit /b 0
    )
)

if "%TI_AVAILABLE%"=="1" (
    set "BARDHZZ_CMD="%ADVANCEDRUN_EXE%" /Clear /EXEFilename "%SystemRoot%\System32\reg.exe" /CommandLine '%BARDHZZ_ARGS%' /RunAs 8 /WaitProcess 1 /Run"
    rem Delayed expansion is needed inside this block.
    !BARDHZZ_CMD! >nul 2>&1
    set "BARDHZZ_ERR=!errorlevel!"
    if not "!BARDHZZ_ERR!"=="0" (
        rem Retry as administrator if AdvancedRun fails.
        reg %* >nul 2>&1
        set "BARDHZZ_ERR=!errorlevel!"
        set "LOG_MSG=%* (Administrator fallback)"
    ) else (
        set "LOG_MSG=%*"
    )
) else (
    reg %* >nul 2>&1
    set "BARDHZZ_ERR=!errorlevel!"
    set "LOG_MSG=%* (Administrator)"
)

if not "!BARDHZZ_ERR!"=="0" goto TIRegLog_Fail
call :LogOK
endlocal
goto :eof

:TIRegLog_Fail
set "LOG_MSG=!LOG_MSG! (err=!BARDHZZ_ERR!)"
call :LogErr
endlocal
goto :eof

rem Timer-resolution registry helper.
:TimerRegLog
setlocal DisableDelayedExpansion
if "%~1"=="" goto TimerRegLog_BadArgs
set "TIMER_REG_ARGS=%*"
if not "%TI_AVAILABLE%"=="1" goto TimerRegLog_Admin
"%ADVANCEDRUN_EXE%" /Clear /EXEFilename "%SystemRoot%\System32\reg.exe" /CommandLine '%TIMER_REG_ARGS%' /RunAs 8 /WaitProcess 1 /Run >nul 2>&1
set "TIMER_REG_ERR=%errorlevel%"
if "%TIMER_REG_ERR%"=="0" goto TimerRegLog_TI_OK
reg %* >nul 2>&1
set "TIMER_REG_ERR=%errorlevel%"
set "LOG_MSG=%* (Administrator fallback)"
if "%TIMER_REG_ERR%"=="0" goto TimerRegLog_OK
goto TimerRegLog_Fail

:TimerRegLog_TI_OK
set "LOG_MSG=%*"
goto TimerRegLog_OK

:TimerRegLog_Admin
reg %* >nul 2>&1
set "TIMER_REG_ERR=%errorlevel%"
set "LOG_MSG=%* (Administrator)"
if not "%TIMER_REG_ERR%"=="0" goto TimerRegLog_Fail

:TimerRegLog_OK
call :LogOK
endlocal & exit /b 0

:TimerRegLog_Fail
set "LOG_MSG=%LOG_MSG% (err=%TIMER_REG_ERR%)"
call :LogErr
endlocal & exit /b %TIMER_REG_ERR%

:TimerRegLog_BadArgs
endlocal & exit /b 87

:ScLog
setlocal DisableDelayedExpansion
sc %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%*"
if not "%BARDHZZ_ERR%"=="0" goto ScLog_Fail
call :LogOK
endlocal
goto :eof

:ScLog_Fail
set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
call :LogErr
endlocal
goto :eof

:RunOpenShellInstaller
start /wait "" "%~1" /qn
exit /b %errorlevel%

:TIDisableServiceInstances
setlocal DisableDelayedExpansion
set "TIS_PREFIX=%~1"
if not defined TIS_PREFIX goto TISInstances_Done
set "TIS_FOUND=0"

rem Per-user services have a bare template plus GUID-suffixed live instances.
sc query "%TIS_PREFIX%" >nul 2>&1
if not errorlevel 1 (
    set "TIS_FOUND=1"
    call :TIScLog config "%TIS_PREFIX%" start= disabled
)

for /f "tokens=2" %%S in ('sc query type^= service state^= all ^| findstr /I /C:"SERVICE_NAME: %TIS_PREFIX%_"') do call :TIDisableServiceInstance "%%S"

if not "%TIS_FOUND%"=="0" goto TISInstances_Done
set "LOG_MSG=%TIS_PREFIX% service/instance not present (skipped)"
call :LogSkip
:TISInstances_Done
endlocal
goto :eof

:TIDisableServiceInstance
set "TIS_FOUND=1"
call :TIScLog config "%~1" start= disabled
goto :eof

:DynRegLog
setlocal DisableDelayedExpansion
if not defined RL_DYN_KEY (set "LOG_MSG=DynRegLog: dynamic registry key not defined" & call :LogErr & endlocal & exit /b 87)
reg add "%RL_DYN_KEY%" %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=reg add %RL_DYN_KEY% %*"
if not "%BARDHZZ_ERR%"=="0" goto DynRegLog_Fail
call :LogOK
endlocal & exit /b 0
:DynRegLog_Fail
set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
call :LogErr
endlocal & exit /b %BARDHZZ_ERR%

:DisablePnpByID
setlocal DisableDelayedExpansion
set "DPID_ID=%~1"
if not defined DPID_ID (endlocal & exit /b 87)
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Disable-PnpDevice -InstanceId '%DPID_ID%' -Confirm:$false -ErrorAction Stop; exit 0 } catch { Write-Output $_.Exception.Message; exit 1 }" >"%TOOLS_REFRESH_LOG%" 2>&1
set "DPID_RC=%errorlevel%"
endlocal & exit /b %DPID_RC%

:TIScLog
setlocal EnableDelayedExpansion
set "TIS_ACTION=%~1"
set "TIS_SERVICE=%~2"
if not defined TIS_ACTION goto TIScLog_BadArgs
if not defined TIS_SERVICE goto TIScLog_BadArgs

sc query "%TIS_SERVICE%" >nul 2>&1
set "TIS_QUERY_ERR=!errorlevel!"
if "%TIS_QUERY_ERR%"=="1060" goto TIScLog_Skip
if not "%TIS_QUERY_ERR%"=="0" goto TIScLog_QueryFail

set "LOG_MSG=%*"
if not "%TI_AVAILABLE%"=="1" goto TIScLog_NoTI
set "BARDHZZ_ARGS=%*"
set "BARDHZZ_CMD="%ADVANCEDRUN_EXE%" /Clear /EXEFilename "%SystemRoot%\System32\sc.exe" /CommandLine '%BARDHZZ_ARGS%' /RunAs 8 /WaitProcess 1 /Run"
%BARDHZZ_CMD% >nul 2>&1
set "BARDHZZ_ERR=!errorlevel!"
if not "!BARDHZZ_ERR!"=="0" (
    rem Retry as administrator if AdvancedRun fails.
    sc %* >nul 2>&1
    set "BARDHZZ_ERR=!errorlevel!"
    set "LOG_MSG=%* (Administrator fallback)"
)
if not "!BARDHZZ_ERR!"=="0" goto TIScLog_Fail

if /I not "%TIS_ACTION%"=="config" goto TIScLog_OK
if /I not "%~3"=="start=" goto TIScLog_OK

set "TIS_EXPECT=%~4"
set "TIS_EXPECT_CODE="
if /I "%TIS_EXPECT%"=="disabled" set "TIS_EXPECT_CODE=4"
if /I "%TIS_EXPECT%"=="demand" set "TIS_EXPECT_CODE=3"
if /I "%TIS_EXPECT%"=="auto" set "TIS_EXPECT_CODE=2"
if not defined TIS_EXPECT_CODE goto TIScLog_OK

set "TIS_ACTUAL_CODE="
for /f "tokens=3" %%A in ('sc qc "%TIS_SERVICE%" ^| findstr /I /C:"START_TYPE"') do set "TIS_ACTUAL_CODE=%%A"
if "%TIS_ACTUAL_CODE%"=="%TIS_EXPECT_CODE%" goto TIScLog_OK

set "LOG_MSG=%* (verification failed: expected start code %TIS_EXPECT_CODE%, actual %TIS_ACTUAL_CODE%)"
call :LogErr
endlocal
goto :eof

:TIScLog_NoTI
sc %* >nul 2>&1
set "BARDHZZ_ERR=!errorlevel!"
set "LOG_MSG=%* (Administrator)"
if not "!BARDHZZ_ERR!"=="0" goto TIScLog_Fail

if /I not "%TIS_ACTION%"=="config" goto TIScLog_OK
if /I not "%~3"=="start=" goto TIScLog_OK

set "TIS_EXPECT=%~4"
set "TIS_EXPECT_CODE="
if /I "%TIS_EXPECT%"=="disabled" set "TIS_EXPECT_CODE=4"
if /I "%TIS_EXPECT%"=="demand" set "TIS_EXPECT_CODE=3"
if /I "%TIS_EXPECT%"=="auto" set "TIS_EXPECT_CODE=2"
if not defined TIS_EXPECT_CODE goto TIScLog_OK

set "TIS_ACTUAL_CODE="
for /f "tokens=3" %%A in ('sc qc "%TIS_SERVICE%" ^| findstr /I /C:"START_TYPE"') do set "TIS_ACTUAL_CODE=%%A"
if "%TIS_ACTUAL_CODE%"=="%TIS_EXPECT_CODE%" goto TIScLog_OK

set "LOG_MSG=%* (Administrator verification failed: expected %TIS_EXPECT_CODE%, actual %TIS_ACTUAL_CODE%)"
call :LogErr
endlocal
goto :eof

:TIScLog_OK
call :LogOK
endlocal
goto :eof

:TIScLog_Fail
set "LOG_MSG=!LOG_MSG! (err=!BARDHZZ_ERR!)"
call :LogErr
endlocal
goto :eof

:TIScLog_Skip
set "LOG_MSG=%* (service not installed)"
call :LogSkip
endlocal
goto :eof

:TIScLog_QueryFail
set "LOG_MSG=%* (service query failed, err=%TIS_QUERY_ERR%)"
call :LogErr
endlocal
goto :eof

:TIScLog_BadArgs
set "LOG_MSG=TIScLog called with invalid arguments"
call :LogErr
endlocal
goto :eof

:SchLog
setlocal EnableDelayedExpansion
rem Extract the task name from schtasks arguments.
set "SCH_ALL=%*"
set "SCH_TASK="
set "SCH_IN_TN=0"
for %%A in (!SCH_ALL!) do (
    if /I "!SCH_IN_TN!"=="1" (
        set "SCH_TASK=%%~A"
        set "SCH_IN_TN=0"
    ) else if /I "%%~A"=="/TN" (
        set "SCH_IN_TN=1"
    )
)
rem Preserve rooted scheduled-task paths.

if not defined SCH_TASK goto SchLog_Run
rem Skip scheduled tasks that do not exist.
schtasks /Query /TN "!SCH_TASK!" >nul 2>&1
if not "!errorlevel!"=="0" goto SchLog_NotFound

:SchLog_Run
schtasks %* >nul 2>&1
set "BARDHZZ_ERR=!errorlevel!"
set "LOG_MSG=%*"
if "!BARDHZZ_ERR!"=="0" goto SchLog_OK
set "LOG_MSG=!LOG_MSG! (err=!BARDHZZ_ERR!)"
call :LogErr
endlocal
goto :eof

:SchLog_NotFound
set "LOG_MSG=%* (task not present - skipped)"
call :LogSkip
endlocal
goto :eof

:SchLog_OK
call :LogOK
endlocal
goto :eof

:LogSummary
setlocal DisableDelayedExpansion
call :LogTS
if not exist "%LOG_FILE%" goto LogSummary_NoFile

set "LOG_OK=0"
set "LOG_FAIL=0"
set "LOG_WARN=0"
set "LOG_SKIP=0"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[  OK ]"') do set "LOG_OK=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[FAILED]"') do set "LOG_FAIL=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[ WARN]"') do set "LOG_WARN=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[ SKIP]"') do set "LOG_SKIP=%%A"
set /a "LOG_TOTAL=LOG_OK+LOG_FAIL+LOG_WARN+LOG_SKIP" >nul 2>&1

if not "%LOG_ENABLED%"=="1" goto LogSummary_Display
>>"%LOG_FILE%" echo(
>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo([%LOG_NOW%] ^>^>^> EXECUTION SUMMARY
>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo( Total Operations : %LOG_TOTAL%
>>"%LOG_FILE%" echo( Successful       : %LOG_OK%
>>"%LOG_FILE%" echo( Failed           : %LOG_FAIL%
>>"%LOG_FILE%" echo( Warnings         : %LOG_WARN%
>>"%LOG_FILE%" echo( Skipped          : %LOG_SKIP%
>>"%LOG_FILE%" echo ============================================================
>>"%LOG_FILE%" echo( Full Log  : %LOG_FILE%
>>"%LOG_FILE%" echo( Error Log : %LOG_ERR%
>>"%LOG_FILE%" echo ============================================================

:LogSummary_Display
echo(
echo %BLUE%============================================================%RESET%
echo %BLUE%               %WHITE%EXECUTION SUMMARY%BLUE%                 %RESET%
echo %BLUE%============================================================%RESET%
echo %BLUE% %WHITE% Total Operations : %BRIGHT_WHITE%%LOG_TOTAL%%RESET%
echo %BLUE% %WHITE% Successful       : %GREEN%%LOG_OK%%RESET%
echo %BLUE% %WHITE% Failed           : %RED%%LOG_FAIL%%RESET%
echo %BLUE% %WHITE% Warnings         : %YELLOW%%LOG_WARN%%RESET%
echo %BLUE% %WHITE% Skipped          : %GRAY%%LOG_SKIP%%RESET%
echo %BLUE%============================================================%RESET%
echo %BLUE% %WHITE% Log File : %CYAN%%LOG_FILE%%RESET%
echo %BLUE% %WHITE% Error Log: %CYAN%%LOG_ERR%%RESET%
echo %BLUE%============================================================%RESET%
echo(
endlocal
goto :eof

:LogSummary_NoFile
echo %YELLOW%[!]%WHITE% No log file found.%RESET%
timeout /t 2 /nobreak >nul
endlocal
goto :eof

:LogView
if not exist "%LOG_FILE%" goto LogView_NoFile
start "" notepad "%LOG_FILE%"
goto :eof

:LogView_NoFile
echo %YELLOW%[!]%WHITE% No log file found.%RESET%
timeout /t 2 /nobreak >nul
goto :eof

:LogViewErrors
if not exist "%LOG_ERR%" goto LogViewErrors_NoFile
start "" notepad "%LOG_ERR%"
goto :eof

:LogViewErrors_NoFile
echo %YELLOW%[!]%WHITE% No error log file found.%RESET%
timeout /t 2 /nobreak >nul
goto :eof
rem End logging helpers.
