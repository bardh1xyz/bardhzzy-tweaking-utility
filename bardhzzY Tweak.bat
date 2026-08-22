@ECHO off
setlocal
title bardhzzY Tweaks - admin check
set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0;%PATH%"

set "dmv=powershell -NoProfile -Command Disable-PnpDevice -InstanceId"

fltmc >nul 2>&1

if not "%errorlevel%"=="0" (
    mode con: cols=78 lines=15
    color 0B
    cls

    echo.
    echo  ============================================================
    echo.
    echo                     bardhzzY TWEAKS
    echo.
    echo       Administrator privileges are required to continue.
    echo.
    echo       A Windows security prompt will appear shortly.
    echo.
    echo       Please click YES when prompted.
    echo.
    echo  ============================================================
    echo.
    timeout /t 3 /nobreak >nul

    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

title bardhzzY Tweaks (Admin)
chcp 65001 >nul
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

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
color 09
echo %ESC%[0m

echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╗██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34m═══════════════════════════════════════════════════════════════════════%ESC%[0m
echo.
echo                       %ESC%[37mLICENSE VERIFICATION%ESC%[0m
echo.
echo               %ESC%[34mEnter your license key to continue.%ESC%[0m
echo.
set "user_key="
set /p "user_key=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Enter your License Key: %ESC%[0m"

if defined user_key set "user_key=%user_key:"=%"
if defined user_key set "user_key=%user_key: =%"

for %%k in (
    "1B99-QBRX-5YP7-YB07" "WITN-7N8Z-R8Q1-FRXX" "U3IG-J0E7-LWRO-9X27" "B21U-EY2U-C3J6-9ZTO"
    "0DC0-JVR3-QNJV-XCLK" "4Z29-1O7A-Z4XA-45QG" "BIS7-L7C3-JJNR-2JWY" "PKVJ-503R-ELHE-42GE"
    "8PAJ-MDNL-K47J-RS1F" "VVEL-QC56-GQV4-YBG8" "6ZQ2-LEF7-GOGA-OAGG" "N63C-FTQG-ES2K-M2GA"
    "O3P4-A5S6-D7F8-G9H0" "J1K2-L3M4-N5B6-V7C8" "X9Z0-Q1W2-E3R4-T5Y6" "U7I8-O9P0-A1S2-D3F4"
    "G5H6-J7K8-L9M0-N1B2" "V3C4-X5Z6-Q7W8-E9R0" "T1Y2-U3I4-O5P6-A7S8" "D9F0-G1H2-J3K4-L5M6"
    "N7B8-V9C0-X1Z2-Q3W4" "E5R6-T7Y8-U9I0-O1P2" "A3S4-D5F6-G7H8-J9K0" "L1M2-N3B4-V5C6-X7Z8"
    "Q9W0-E1R2-T5Y6-U7I8" "O7P8-A9S0-D1F2-G3H4" "bardhzzY7" "akuma123"
) do (
    if /I "%user_key%"=="%%~k" goto valid
)

:invalid
cls
MODE 100,40
color 09
echo %ESC%[0m

echo.
echo        %ESC%[34m══════════════════════════════════════════════════════════════════════%ESC%[0m
echo.
echo                       %ESC%[37mLICENSE VERIFICATION%ESC%[0m
echo.
echo        %ESC%[31m[ERROR]%ESC%[37m Invalid license key.
echo.
echo        %ESC%[37mThe key was not recognized. Please check your key
echo        and try again.%ESC%[0m
echo.
echo        %ESC%[90mReturning to license verification...%ESC%[0m
echo.
echo        %ESC%[34m══════════════════════════════════════════════════════════════════════%ESC%[0m
echo.
timeout /t 3 /nobreak >nul
goto license


:valid
cls
MODE 100,40
color 09
echo %ESC%[0m

echo.
echo        %ESC%[34m══════════════════════════════════════════════════════════════════════%ESC%[0m
echo.
echo                       %ESC%[37mLICENSE VERIFICATION%ESC%[0m
echo.
echo        %ESC%[32m[  OK ]%ESC%[37m License verified successfully.
echo.
echo        %ESC%[37mWelcome to bardhzzY Tweaks.%ESC%[0m
echo.
echo        %ESC%[90mStarting the utility...%ESC%[0m
echo.
echo        %ESC%[34m══════════════════════════════════════════════════════════════════════%ESC%[0m
echo.
timeout /t 2 /nobreak >nul
goto init

:init
echo.
echo Downloading Tweaking Tools
set "UTIL_DIR=C:\bardhzzY Utility Tools"
set "GITHUB_ZIP_URL=https://github.com/bardh1xyz/bardhzzY-Utility-Tools/archive/refs/heads/main.zip"

if exist "%UTIL_DIR%" goto tools_exist

call :LogInfo "Tools not found. Downloading repository from GitHub..."
mkdir "%UTIL_DIR%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $zip = \"$env:TEMP\bardhzz_tools.zip\"; $ext = \"$env:TEMP\bardhzz_extract\"; try { Invoke-WebRequest -Uri '%GITHUB_ZIP_URL%' -OutFile $zip -UseBasicParsing; Expand-Archive -Path $zip -DestinationPath $ext -Force; $gitRoot = Get-ChildItem -Path $ext -Directory | Select-Object -First 1; Copy-Item -Path \"$($gitRoot.FullName)\*\" -Destination '%UTIL_DIR%' -Recurse -Force; Remove-Item $zip -Force; Remove-Item $ext -Recurse -Force; exit 0 } catch { exit 1 }" >nul 2>&1

if %errorlevel% equ 0 (
    if exist "%UTIL_DIR%" (
        call :LogOK "Tools successfully downloaded and extracted."
        goto NSUDO_SETUP
    ) else (
        call :LogErr "Failed to verify directory creation."
    )
) else (
    call :LogErr "Download failed. Download directly from https://github.com/bardh1xyz/bardhzzY-Utility-Tools ^(save to c: drive^) or check network connection."
)
goto NSUDO_SETUP

:tools_exist
if exist "%UTIL_DIR%\nsudo\NSudoLC.exe" (
    call :LogOK "bardhzzY Utility Tools verified. Skipping download."
    goto NSUDO_SETUP
)

call :LogWarn "Utility Tools folder exists but required NSudo is missing."
call :LogInfo "Attempting to repair the tools directory from GitHub..."

if exist "%UTIL_DIR%" rd /s /q "%UTIL_DIR%" >nul 2>&1
mkdir "%UTIL_DIR%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $zip = \"$env:TEMP\bardhzz_tools.zip\"; $ext = \"$env:TEMP\bardhzz_extract\"; try { Invoke-WebRequest -Uri '%GITHUB_ZIP_URL%' -OutFile $zip -UseBasicParsing; Expand-Archive -Path $zip -DestinationPath $ext -Force; $gitRoot = Get-ChildItem -Path $ext -Directory | Select-Object -First 1; Copy-Item -Path \"$($gitRoot.FullName)\*\" -Destination '%UTIL_DIR%' -Recurse -Force; Remove-Item $zip -Force; Remove-Item $ext -Recurse -Force; exit 0 } catch { exit 1 }" >nul 2>&1

if %errorlevel% equ 0 if exist "%UTIL_DIR%\nsudo\NSudoLC.exe" (
    call :LogOK "Utility Tools repaired successfully."
) else (
    call :LogWarn "Utility Tools repair could not be verified. Continuing with Administrator fallback."
)

goto NSUDO_SETUP

:NSUDO_SETUP
set "NSUDO_EXE=C:\bardhzzY Utility Tools\nsudo\NSudoLC.exe"
set "TI="
set "TI_AVAILABLE=0"

if not exist "%NSUDO_EXE%" goto NSUDO_UNAVAILABLE

set "TI_TEST=%TEMP%\BARDHZZY_TI_TEST_%RANDOM%.txt"

sc.exe query TrustedInstaller >nul 2>&1
if errorlevel 1 goto NSUDO_TEST_FAILED

sc.exe query TrustedInstaller | findstr /I "RUNNING" >nul 2>&1
if errorlevel 1 (
    sc.exe start TrustedInstaller >nul 2>&1
    timeout /t 2 /nobreak >nul
)

"%NSUDO_EXE%" -U:T -P:E -ShowWindowMode:Hide -Wait ^
    powershell.exe -NoProfile -NonInteractive -Command ^
    "$id=[Security.Principal.WindowsIdentity]::GetCurrent(); $id.Groups | ForEach-Object { $_.Value } | Set-Content -LiteralPath '%TI_TEST%' -Encoding ascii" >nul 2>&1

set "TI_TEST_ERR=%errorlevel%"
if not "%TI_TEST_ERR%"=="0" goto NSUDO_TEST_FAILED

findstr /L /I /C:"S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464" "%TI_TEST%" >nul 2>&1
if errorlevel 1 goto NSUDO_TEST_FAILED

del /q "%TI_TEST%" >nul 2>&1

set "TI=""%NSUDO_EXE%"" -U:T -P:E -ShowWindowMode:Hide -Wait"
set "TI_AVAILABLE=1"

echo.
echo [OK] TrustedInstaller verified successfully.
echo.
timeout /t 1 /nobreak >nul
goto :main

:NSUDO_TEST_FAILED
set "TI="
set "TI_AVAILABLE=0"
if exist "%TI_TEST%" del /q "%TI_TEST%" >nul 2>&1
echo.
echo [!] NSudo TrustedInstaller token test failed.
echo [!] Falling back to standard Administrator privileges.
echo.
timeout /t 2 /nobreak >nul
goto :main

:NSUDO_UNAVAILABLE
set "TI="
set "TI_AVAILABLE=0"
echo.
echo [!] NSudo is unavailable (Not found in tools folder).
echo [!] Using standard Administrator privileges instead.
echo.
timeout /t 2 /nobreak >nul

:main
title bardhzzY Tweaks
MODE 100,40
echo %ESC%[0m
cls
color 09

echo.
echo.
echo        ██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗
echo        ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝
echo        ██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ 
echo        ██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  
echo        ██████╔╗██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   
echo        ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
echo.
echo  %ESC%[34mSYSTEM TWEAKS                 %ESC%[0m %ESC%[34mNETWORK ^& LATENCY%ESC%[0m
echo  %ESC%[37m [%ESC%[36m 1%ESC%[37m] Windows Tweaks            %ESC%[37m [%ESC%[36m 6%ESC%[37m] Network Tweaks
echo  %ESC%[37m [%ESC%[36m 2%ESC%[37m] GPU Tweaks                %ESC%[37m [%ESC%[36m 7%ESC%[37m] Storage Tweaks
echo  %ESC%[37m [%ESC%[36m 3%ESC%[37m] CPU Tweaks                %ESC%[37m [%ESC%[36m 8%ESC%[37m] Input Lag Tweaks
echo  %ESC%[37m [%ESC%[36m 4%ESC%[37m] RAM Tweaks                %ESC%[37m [%ESC%[36m 9%ESC%[37m] KBM Tweaks
echo  %ESC%[37m [%ESC%[36m 5%ESC%[37m] Power Tweaks              %ESC%[37m [%ESC%[36m10%ESC%[37m] Timer Resolution
echo.
echo  %ESC%[34mGAMING ^& CLEANUP             %ESC%[0m %ESC%[34mSAFETY ^& UTILITIES%ESC%[0m
echo  %ESC%[37m [%ESC%[36m11%ESC%[37m] Fortnite Optimizer       %ESC%[37m [%ESC%[36m14%ESC%[37m] Restore Point
echo  %ESC%[37m [%ESC%[36m12%ESC%[37m] Service Reduction        %ESC%[37m [%ESC%[36m15%ESC%[37m] Registry Backup
echo  %ESC%[37m [%ESC%[36m13%ESC%[37m] Device Manager Tweak     %ESC%[37m [%ESC%[36m16%ESC%[37m] Revert Tweaks
echo.
echo  %ESC%[34mSYSTEM ^& LOGS%ESC%[0m
echo  %ESC%[37m [%ESC%[36m17%ESC%[37m] Restart PC       %ESC%[37m [%ESC%[36m18%ESC%[37m] View Log         %ESC%[37m [%ESC%[36m19%ESC%[37m] View Errors
echo  %ESC%[37m [%ESC%[36m20%ESC%[37m] Summary          %ESC%[37m [%ESC%[36m21%ESC%[37m] Quit             %ESC%[37m [%ESC%[36m D%ESC%[37m] Discord
echo.
echo  %ESC%[90mCopyright © 2026 bardhzzY Tweaks. All rights reserved.%ESC%[0m
echo.
set "input="
set /p "input=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

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
if /i "%input%"=="14" goto srp
if /i "%input%"=="15" goto backup
if /i "%input%"=="16" goto revert
if /i "%input%"=="17" goto restartpc
if /i "%input%"=="18" (
    call :LogView
    goto main
)
if /i "%input%"=="19" (
    call :LogViewErrors
    goto main
)
if /i "%input%"=="20" (
    call :LogSummary
    pause
    goto main
)
if /i "%input%"=="21" (
    call :LogSummary
    echo.
    echo Thank you for using BARDHZZY Tweaks!
    echo Your log file: %LOG_FILE%
    timeout 3 >nul
    exit /b
)
if /i "%input%"=="d" (
    start https://discord.gg/uqD3nbuuNV
    goto main
)

echo.
echo "%input%" isn't a right choice, try again!
timeout 2 >nul
goto main

:win
call :LogSection "Package Manager (Winget) Setup"
call :LogInfo "Verifying Winget availability..."

where curl >nul 2>&1
if %errorlevel% neq 0 (
    call :LogErr "CURL.exe not found. Winget cannot be downloaded automatically."
    goto WINGET_DONE
)

winget --version >nul 2>&1
if %errorlevel% equ 0 (
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
if %errorlevel% neq 0 (
    call :LogErr "Network error: Failed to download Winget bundle."
    goto WINGET_FAIL
)

call :LogInfo "Installing App Installer bundle (this may take 30s)..."
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { Add-AppxPackage -Path '%W_TEMP%\winget.msixbundle' -ForceUpdateFromAnyVersion -ErrorAction Stop; exit 0 } catch { exit 1 }"

if %errorlevel% neq 0 (
    call :LogErr "Installation failed. Windows components may be too corrupted."
    goto WINGET_FAIL
)

set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps;C:\Program Files\WindowsApps"
timeout /t 2 /nobreak >nul

winget --version >nul 2>&1
if %errorlevel% equ 0 (
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

call :LogInfo "Installing latest Open-Shell..."
winget install --id Open-Shell.Open-Shell-Menu --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
if not exist "C:\Program Files\Open-Shell\StartMenu.exe" (
    call :LogWarn "Winget failed or timed out. Attempting direct download from GitHub..."
    
    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/Open-Shell/Open-Shell-Menu/releases/latest' -UseBasicParsing; $a = $r.assets | Where-Object { $_.name -like 'OpenShellSetup*.exe' } | Select-Object -First 1; Invoke-WebRequest -Uri $a.browser_download_url -OutFile $env:TEMP\OpenShellSetup.exe -UseBasicParsing } catch { exit 1 }" >nul 2>&1
    
    if exist "%TEMP%\OpenShellSetup.exe" (
        call :LogInfo "Running Open-Shell silent installer..."
        start /wait "" "%TEMP%\OpenShellSetup.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
        
        if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
            call :LogOK "Open-Shell installed via GitHub fallback."
        ) else (
            call :LogErr "Open-Shell silent installer failed."
        )
        del /q "%TEMP%\OpenShellSetup.exe" >nul 2>&1
    ) else (
        call :LogErr "Failed to download Open-Shell from GitHub. Check internet connection."
    )
) else (
    call :LogOK "Open-Shell installed via Winget."
)
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
if %errorlevel% neq 0 (
    if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
        start "" "C:\Program Files\Open-Shell\StartMenu.exe"
    )
)

call :LogOK "configured open-shell"
goto skip_search

:skip_search
call :LogInfo "Removing New Media Player app..."
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneVideo* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove ZuneVideo") else (call :LogErr "Remove ZuneVideo")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneMusic* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove ZuneMusic") else (call :LogErr "Remove ZuneMusic")

call :LogInfo "Enabling Legacy Media Player feature..."
dism /online /enable-feature /featurename:WindowsMediaPlayer /norestart >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Enable WMP feature") else (call :LogErr "Enable WMP feature")

call :LogInfo "Optimizing WMP Network Service..."
call :TIScLog config WMPNetworkSvc start= demand

call :LogInfo "Installing Visual C++ 2015-2022 Redistributables..."
winget install --id Microsoft.VCRedist.2015+.x64 --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Install VCRedist x64") else (call :LogErr "Install VCRedist x64")
winget install --id Microsoft.VCRedist.2015+.x86 --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Install VCRedist x86") else (call :LogErr "Install VCRedist x86")

call :LogInfo "Downloading DirectX Web Setup..."
setlocal EnableDelayedExpansion
set "DX_OK=1"
curl -L -f -s -o "%temp%\dxwebsetup.exe" "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" >nul 2>&1
if %errorlevel% neq 0 set "DX_OK=0"

if "%DX_OK%"=="1" (
    call :LogOK "DirectX Web Setup downloaded."
    call :LogInfo "Installing DirectX silently (this may take a moment)..."
    
    :: /Q = Quiet, /R:N = Suppress restart
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
if %errorlevel% equ 0 (call :LogOK "OneDrive Appx removed") else (call :LogWarn "OneDrive Appx removal skipped")

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

call :LogInfo "Nuking leftover directories..."
if exist "C:\Program Files (x86)\Microsoft\Edge\"         %TI% cmd.exe /c "rd /s /q \"C:\Program Files (x86)\Microsoft\Edge\"" >nul 2>&1
if exist "C:\Program Files\Microsoft\Edge\"               %TI% cmd.exe /c "rd /s /q \"C:\Program Files\Microsoft\Edge\"" >nul 2>&1
if exist "C:\Program Files (x86)\Microsoft\EdgeWebView\"  %TI% cmd.exe /c "rd /s /q \"C:\Program Files (x86)\Microsoft\EdgeWebView\"" >nul 2>&1
if exist "C:\Program Files\Microsoft\EdgeWebView\"        %TI% cmd.exe /c "rd /s /q \"C:\Program Files\Microsoft\EdgeWebView\"" >nul 2>&1
if exist "C:\Program Files (x86)\Microsoft\EdgeUpdate\"   %TI% cmd.exe /c "rd /s /q \"C:\Program Files (x86)\Microsoft\EdgeUpdate\"" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\EdgeWebView" >nul 2>&1

call :LogInfo "Hardening against Windows Update reinstalls..."
%TI% icacls "C:\Program Files (x86)\Microsoft\Edge" /deny SYSTEM:(OI)(CI)F >nul 2>&1
%TI% icacls "C:\Program Files\Microsoft\Edge" /deny SYSTEM:(OI)(CI)F >nul 2>&1
%TI% icacls "C:\Program Files (x86)\Microsoft\EdgeWebView" /deny SYSTEM:(OI)(CI)F >nul 2>&1
%TI% icacls "C:\Program Files\Microsoft\EdgeWebView" /deny SYSTEM:(OI)(CI)F >nul 2>&1

call :LogInfo "Disabling EdgeUpdate & Elevation services..."
call :TIScLog stop "edgeupdate"
call :TIScLog config "edgeupdate" start= disabled
call :TIScLog stop "edgeupdatem"
call :TIScLog config "edgeupdatem" start= disabled
call :TIScLog stop "MicrosoftEdgeElevationService"
call :TIScLog config "MicrosoftEdgeElevationService" start= disabled

call :SchLog /Change /TN "MicrosoftEdgeUpdateTaskMachineCore" /Disable
call :SchLog /Change /TN "MicrosoftEdgeUpdateTaskMachineUA" /Disable

del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /q /f "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1

call :LogOK "Microsoft Edge and WebView2 completely eradicated!"

call :LogInfo "Disabling User Account Control (UAC)..."
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
call :LogWarn "UAC Disabled. A system restart is required for this to take effect"

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
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\ConnectedDevicesPlatformUserSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\ContactDataSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\MessagingSyncSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\OneSyncSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\MessagingService" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CortanaCtiUserSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\SCNotification" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\InstalledAppsProviderService" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\TabletInputService" /v "Start" /t REG_DWORD /d 4 /f

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
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f
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
if %errorlevel% equ 0 (call :LogOK "System sound assignments cleared") else (call :LogWarn "System sound assignments already cleared")

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
:: Disable "Welcome Experience" page after updates and "Get even more out of Windows" prompt
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
call :LogInfo "Disabling Meet Now and Teams startup..."
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
call :RegLog delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "com.squirrel.Teams.Teams" /f

call :LogInfo "Disabling Windows Defender..."
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
call :TIScLog config WinDefend start= disabled
call :TIScLog stop WinDefend
call :TIScLog config WdNisSvc start= disabled
call :TIScLog stop WdNisSvc
call :TIScLog config wscsvc start= disabled
call :TIScLog stop wscsvc
call :TIScLog config SecurityHealthService start= disabled
call :TIScLog stop SecurityHealthService
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
call :LogInfo "Disabling SMBv1 (security)..."
powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable SMB1Protocol") else (call :LogWarn "Disable SMB1Protocol")
call :TIScLog config lanmanworkstation depend= "Bowser/Srv2/SrvNet"
call :LogInfo "Disabling LLMNR and NetBIOS (security)..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableLLMNR" /t REG_DWORD /d 0 /f
if "%os_ver%"=="Win11" (
    call :LogInfo "Applying Win11-specific tweaks..."
    call :RegLog add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve /d ""
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
    call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Sudo\Settings" /v "Enabled" /t REG_DWORD /d 0 /f
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
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
    call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f
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
%dmv% "SWD\MSRRAS\MS_IKEEV2_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_IKEEV2_MINIPORT") else (call :LogErr "Disable MS_IKEEV2_MINIPORT")
%dmv% "SWD\MSRRAS\MS_IP_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_IP_MINIPORT") else (call :LogErr "Disable MS_IP_MINIPORT")
%dmv% "SWD\MSRRAS\MS_IPV6_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_IPV6_MINIPORT") else (call :LogErr "Disable MS_IPV6_MINIPORT")
%dmv% "SWD\MSRRAS\MS_L2TP_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_L2TP_MINIPORT") else (call :LogErr "Disable MS_L2TP_MINIPORT")
%dmv% "SWD\MSRRAS\MS_PPPOE_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_PPPOE_MINIPORT") else (call :LogErr "Disable MS_PPPOE_MINIPORT")
%dmv% "SWD\MSRRAS\MS_PPTP_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_PPTP_MINIPORT") else (call :LogErr "Disable MS_PPTP_MINIPORT")
%dmv% "SWD\MSRRAS\MS_SSTP_MINIPORT" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_SSTP_MINIPORT") else (call :LogErr "Disable MS_SSTP_MINIPORT")
%dmv% "SWD\MSRRAS\MS_NDISWANBH" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_NDISWANBH") else (call :LogErr "Disable MS_NDISWANBH")
%dmv% "SWD\MSRRAS\MS_NDISWANIP" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_NDISWANIP") else (call :LogErr "Disable MS_NDISWANIP")
%dmv% "SWD\MSRRAS\MS_NDISWANIPV6" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MS_NDISWANIPV6") else (call :LogErr "Disable MS_NDISWANIPV6")
%dmv% "ROOT\vmic_guestinterface\0000" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable vmic_guestinterface") else (call :LogErr "Disable vmic_guestinterface")

call :LogInfo "Whitelisting core gaming paths..."
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Epic Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude Epic Games path") else (call :LogErr "Exclude Epic Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Steam'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude Steam path") else (call :LogErr "Exclude Steam path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Riot Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude Riot Games path") else (call :LogErr "Exclude Riot Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\EA Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude EA Games path") else (call :LogErr "Exclude EA Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'C:\Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude C:\Games path") else (call :LogErr "Exclude C:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'D:\Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude D:\Games path") else (call :LogErr "Exclude D:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionPath 'E:\Games'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude E:\Games path") else (call :LogErr "Exclude E:\Games path")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'FortniteClient-Win64-Shipping.exe'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude FortniteClient Process") else (call :LogErr "Exclude FortniteClient Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'FortniteLauncher.exe'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude FortniteLauncher Process") else (call :LogErr "Exclude FortniteLauncher Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'EpicGamesLauncher.exe'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude EpicGamesLauncher Process") else (call :LogErr "Exclude EpicGamesLauncher Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'steam.exe'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude steam Process") else (call :LogErr "Exclude steam Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionProcess 'RiotClientServices.exe'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude RiotClientServices Process") else (call :LogErr "Exclude RiotClientServices Process")
powershell -NoProfile -Command "Add-MpPreference -ExclusionExtension 'pak','upk','big','bsp','vtf','assets'" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Exclude Game Extensions") else (call :LogErr "Exclude Game Extensions")
powershell -NoProfile -Command "$paths = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture'); foreach ($p in $paths) { if (Test-Path $p) { Get-ChildItem $p | ForEach-Object { $fx = Join-Path $_.PSPath 'FxProperties'; if (Test-Path $fx) { Set-ItemProperty -Path $fx -Name '{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5' -Value 1 -Type DWord -ErrorAction SilentlyContinue } } } }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "disable Audio Enhancements") else (call :LogErr "disable Audio Enhancements")

call :LogInfo "Windows Tweaks section complete."
timeout /t 1 /nobreak > NUL
pause
goto main

:gpu
cls
echo %ESC%[0m
color 09

echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mSELECT GPU MANUFACTURER%ESC%[0m
echo  %ESC%[37m [%ESC%[36m1%ESC%[37m] Nvidia          %ESC%[37m [%ESC%[36m2%ESC%[37m] AMD             %ESC%[37m [%ESC%[36m3%ESC%[37m] Intel
echo.
echo  %ESC%[37m [%ESC%[36m4%ESC%[37m] Exit to Main Menu
echo.
set "input="
set /p "input=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

:: Sanitize input to prevent "is not recognized" errors
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
if %errorlevel% equ 0 (
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
for /f "tokens=2 delims=:" %%t in ('schtasks /query /fo list ^| findstr /i "TaskName:" ^| findstr /i "NvTmMon NvTmRep NvDriverUpdateCheckDaily GeForce Experience SelfUpdate"') do (
    set "task=%%t"
    for /f "tokens=* delims= " %%s in ("!task!") do set "task=%%s"
    if not "!task!"=="" call :SchLog /change /disable /tn "!task!"
)
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

call :LogInfo "Applying DisableDynamicPstate to active GPU (Universal Safe)..."
powershell -NoProfile -Command "$gpus = Get-CimInstance Win32_VideoController | Where-Object { $_.PNPDeviceID -like 'PCI\VEN_10DE*' }; foreach ($gpu in $gpus) { $pnp = $gpu.PNPDeviceID; $regBase = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $pnp; $driverVal = (Get-ItemProperty -Path $regBase -Name 'Driver' -ErrorAction SilentlyContinue).Driver; if ($driverVal) { $classPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\' + $driverVal; if (Test-Path $classPath) { Set-ItemProperty -Path $classPath -Name 'DisableDynamicPstate' -Value 1 -Type DWord -ErrorAction SilentlyContinue } } }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "DisableDynamicPstate applied") else (call :LogWarn "DisableDynamicPstate skipped (No matching GPU found)")

:: --- MSI Mode
call :LogInfo "Enabling MSI Mode for NVIDIA GPU..."
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_10DE" ^| findstr "HKEY"') do (
    reg query "%%a" /v "Service" 2>nul | findstr /i "nvlddmkm" >nul
    if !errorlevel! equ 0 (
        call :RegLog add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d 3 /f
    )
)
endlocal
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "GetInterruptConnectionCount" /t REG_DWORD /d 0 /f
call :LogOK "NVIDIA GPU MSI Mode & High Priority Enabled!"

call :LogInfo "Applying DirectX Optimizations..."
powershell -NoProfile -Command "$p='HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'; $n='DirectXUserGlobalSettings'; $tweak='SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;'; $val=(Get-ItemProperty -Path $p -Name $n -ErrorAction SilentlyContinue).$n; if($val){ $parts=$val -split ';' | Where-Object { $_ -notmatch 'SwapEffectUpgradeEnable' -and $_ -notmatch 'VRROptimizeEnable' }; $new=($parts -join ';').';'+$tweak } else { $new=$tweak }; Set-ItemProperty -Path $p -Name $n -Value $new -Type String -Force" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "DirectX Global Settings applied") else (call :LogErr "DirectX Global Settings failed")

call :RegLog add "HKCU\Software\Microsoft\DXGIExtensions" /v "ForceIndependentFlip" /t REG_DWORD /d 1 /f
call :LogInfo "Disabling Multiplane Overlay (MPO)..."
call :RegLog delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestType" /f >nul 2>&1
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableOverlays" /t REG_DWORD /d "1" /f

:: --- HDCP Tweaks (Bugfixed to use 'delims=') ---
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /f "00*" /k ^| findstr "000"') do (
    call :RegLog add "%%a" /v "RmHdcpKeybackDisable" /t REG_DWORD /d 1 /f
    call :RegLog add "%%a" /v "RMHdcpPowerSavingDisable" /t REG_DWORD /d 1 /f
)
call :LogOK "NVIDIA DirectX Optimizations perfectly applied!"

call :LogInfo "Applying nvlddmkm tweaks..."
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d 1 /f
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
call :TIScLog stop NvBackend
call :TIScLog config NVDisplay.ContainerLocalSystem start= demand

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
        call :RegLog add "%%a" /v "PP_RTPMComputeF1Latency" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "PP_DGBMMMaxTransitionLatencyUvd" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "PP_DGBPMMaxTransitionLatencyGfx" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "DalNBLatencyForUnderFlow" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRSnoopL1Latency" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRSnoopL0Latency" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRNoSnoopL1Latency" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRNoSnoopL0Latency" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRMaxSnoopLatencyValue" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "BGM_LTRMaxNoSnoopLatencyValue" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "KMD_EnableComputePreemption" /t REG_DWORD /d 0 /f
        call :RegLog add "%%a" /v "KMD_DeLagEnabled" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a" /v "DisablePreemption" /t REG_DWORD /d 1 /f
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
for /f "delims=" %%g in ('powershell -NoProfile -Command "Get-CimInstance Win32_VideoController | Where-Object { $_.PNPDeviceID -like '*VEN_8086*' } | Select-Object -ExpandProperty PNPDeviceID" 2^>nul') do (
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
)
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
if %errorlevel% equ 0 (call :LogOK "powercfg sub_pciexpress") else (call :LogErr "powercfg sub_pciexpress")

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
for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_" ^| findstr "HKEY" ^| findstr /v "Parameters"') do (
    call :RegLog add "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d 3 /f
)

bcdedit /set debug off >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit debug off") else (call :LogErr "bcdedit debug off")
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
if %errorlevel% equ 0 (call :LogOK "Disable VMP feature") else (call :LogErr "Disable VMP feature")
dism /online /Disable-Feature /FeatureName:Microsoft-Hyper-V-All /NoRestart >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable Hyper-V feature") else (call :LogErr "Disable Hyper-V feature")
bcdedit /set hypervisorlaunchtype off >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit hypervisor off") else (call :LogErr "bcdedit hypervisor off")

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
echo %ESC%[0m
color 09

echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╝███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mSELECT RAM AMOUNT%ESC%[0m
echo  %ESC%[37m [%ESC%[36m 1%ESC%[37m] 2 GB               %ESC%[37m [%ESC%[36m 4%ESC%[37m] 6 GB               %ESC%[37m [%ESC%[36m 7%ESC%[37m] 24 GB
echo  %ESC%[37m [%ESC%[36m 2%ESC%[37m] 3 GB               %ESC%[37m [%ESC%[36m 5%ESC%[37m] 8 GB               %ESC%[37m [%ESC%[36m 8%ESC%[37m] 32 GB
echo  %ESC%[37m [%ESC%[36m 3%ESC%[37m] 4 GB               %ESC%[37m [%ESC%[36m 6%ESC%[37m] 16 GB              %ESC%[37m [%ESC%[36m 9%ESC%[37m] 64 GB
echo.
echo  %ESC%[37m [%ESC%[36m10%ESC%[37m] Exit to Main Menu
echo.
set "input="
set /p "input=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

:: Sanitize input to prevent "is not recognized" errors
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
powershell -NoProfile -Command "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable-MMAgent -mc") else (call :LogErr "Disable-MMAgent -mc")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MemoryCompression") else (call :LogErr "Disable MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "Disable-MMAgent -PageCombining" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable PageCombining") else (call :LogErr "Disable PageCombining")
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
powershell -NoProfile -Command "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable-MMAgent -mc") else (call :LogErr "Disable-MMAgent -mc")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MemoryCompression") else (call :LogErr "Disable MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "Disable-MMAgent -PageCombining" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable PageCombining") else (call :LogErr "Disable PageCombining")
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
powershell -NoProfile -Command "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable-MMAgent -mc") else (call :LogErr "Disable-MMAgent -mc")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MemoryCompression") else (call :LogErr "Disable MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "Disable-MMAgent -PageCombining" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable PageCombining") else (call :LogErr "Disable PageCombining")
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
powershell -NoProfile -Command "Disable-MMAgent -ApplicationLaunchPrefetching -ApplicationPreLaunch" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable-MMAgent -mc") else (call :LogErr "Disable-MMAgent -mc")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d 0 /f
echo Disabling Memory Compression
powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable MemoryCompression") else (call :LogErr "Disable MemoryCompression")
echo Disabling Page Combining
powershell -NoProfile -Command "Disable-MMAgent -PageCombining" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable PageCombining") else (call :LogErr "Disable PageCombining")
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
call :TIRegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f
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
winget uninstall --silent --accept-source-agreements "Windows web experience Pack" >nul 2>&1
call :LogInfo "Removing Snipping Tool (using Lightshot instead)..."
taskkill /f /im SnippingTool.exe >nul 2>&1
taskkill /f /im ScreenSketch.exe >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ScreenSketch* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove ScreenSketch") else (call :LogErr "Remove ScreenSketch")
call :LogInfo "Deprovisioning ScreenSketch (blocks reinstall on updates/new users)..."
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Microsoft.ScreenSketch' }; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Deprovision ScreenSketch") else (call :LogErr "Deprovision ScreenSketch")
call :LogInfo "Releasing Print Screen key for Lightshot..."
call :RegLog add "HKCU\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d 0 /f
powershell -NoProfile -Command "Get-AppxPackage *MicrosoftWindows.Client.WebExperience* -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
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
call :SchLog /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Application Experience\StartupAppScan" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Scan Independent Update" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\Ras\MobilityManager" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable
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
call :SchLog /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable
call :SchLog /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
call :SchLog /change /disable /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 
call :SchLog /change /disable /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" 
call :SchLog /change /disable /tn "\Microsoft\Windows\Windows Error Reporting\Generic" 

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

call :LogInfo "Disabling Spaced Intel Services"
for %%S in (
    "Intel(R) TPM Provisioning Service"
    "Intel(R) Platform License Manager Service"
    "Intel(R) Capability Licensing Service TCP IP Interface"
    "Intel(R) SUR QC SAM"
) do (
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\%%~S" /v "Start" /t REG_DWORD /d "4" /f
)

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
if %errorlevel% equ 0 (call :LogOK "StorSvc set to demand") else (call :LogErr "StorSvc config failed")

call :TIScLog stop "AppReadiness"
call :TIScLog config "AppReadiness" start= disabled

call :TIScLog stop "LanmanServer"
call :TIScLog config "LanmanServer" start= disabled

call :LogInfo "Nuking GameBarPresenceWriter..."
set "fileToDelete=%SystemRoot%\System32\GameBarPresenceWriter.exe"
if exist "%fileToDelete%" (
    %TI% takeown /F "%fileToDelete%" >nul 2>&1
    %TI% icacls "%fileToDelete%" /grant administrators:F >nul 2>&1
    %TI% cmd.exe /c del "%fileToDelete%" /f /q >nul 2>&1
    if exist "%fileToDelete%" (call :LogWarn "Failed to delete GameBarPresenceWriter.exe") else (call :LogOK "GameBarPresenceWriter.exe deleted")
) else (
    call :LogSkip "GameBarPresenceWriter.exe not found"
)

call :LogInfo "Nuking UsoClient and MoUsoCoreWorker..."
set "usoClientFile=C:\Windows\System32\UsoClient.exe"
set "usoCoreWorkerFile=C:\Windows\UUS\amd64\MoUsoCoreWorker.exe"

if exist "%usoClientFile%" (
    %TI% takeown /F "%usoClientFile%" >nul 2>&1
    %TI% icacls "%usoClientFile%" /grant administrators:F >nul 2>&1
    %TI% cmd.exe /c del "%usoClientFile%" /f /q >nul 2>&1
    if exist "%usoClientFile%" (call :LogWarn "Failed to delete UsoClient.exe") else (call :LogOK "UsoClient.exe deleted")
) else (
    call :LogSkip "UsoClient.exe not found"
)

if exist "%usoCoreWorkerFile%" (
    %TI% takeown /F "%usoCoreWorkerFile%" >nul 2>&1
    %TI% icacls "%usoCoreWorkerFile%" /grant administrators:F >nul 2>&1
    %TI% cmd.exe /c del "%usoCoreWorkerFile%" /f /q >nul 2>&1
    if exist "%usoCoreWorkerFile%" (call :LogWarn "Failed to delete MoUsoCoreWorker.exe") else (call :LogOK "MoUsoCoreWorker.exe deleted")
) else (
    call :LogSkip "MoUsoCoreWorker.exe not found"
)

call :LogInfo "Nuking AutoLogger-Diagtrack..."
set "autoLoggerDir=%PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if exist "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" (
    %TI% cmd.exe /c del /q "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" >nul 2>&1
    call :LogOK "AutoLogger ETL deleted"
) else (
    call :LogSkip "AutoLogger ETL not found"
)
%TI% icacls "%autoLoggerDir%" /deny SYSTEM:(OI)(CI)F >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "AutoLogger SYSTEM permissions denied") else (call :LogErr "AutoLogger permission deny failed")

call :LogOK "Manufactor bloat and more services disabled!"

call :LogInfo "Preparing Appx Removal..."
call :TIScLog config AppXSvc start= demand
call :TIScLog start AppXSvc
timeout /t 2 /nobreak >nul

call :LogInfo "Removing Appx Packages..."
powershell -NoProfile -Command "Get-AppxPackage -allusers *3DBuilder* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: 3DBuilder") else (call :LogErr "Remove Appx: 3DBuilder")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bing* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: bing") else (call :LogErr "Remove Appx: bing")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bingfinance* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: bingfinance") else (call :LogErr "Remove Appx: bingfinance")
powershell -NoProfile -Command "Get-AppxPackage -allusers *bingsports* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: bingsports") else (call :LogErr "Remove Appx: bingsports")
powershell -NoProfile -Command "Get-AppxPackage -allusers *BingWeather* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: BingWeather") else (call :LogErr "Remove Appx: BingWeather")
powershell -NoProfile -Command "Get-AppxPackage -allusers *CommsPhone* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: CommsPhone") else (call :LogErr "Remove Appx: CommsPhone")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Drawboard PDF* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Drawboard PDF") else (call :LogErr "Remove Appx: Drawboard PDF")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Facebook* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Facebook") else (call :LogErr "Remove Appx: Facebook")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Getstarted* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Getstarted") else (call :LogErr "Remove Appx: Getstarted")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Microsoft.Messaging* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.Messaging") else (call :LogErr "Remove Appx: Microsoft.Messaging")
powershell -NoProfile -Command "Get-AppxPackage -allusers *MicrosoftOfficeHub* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: MicrosoftOfficeHub") else (call :LogErr "Remove Appx: MicrosoftOfficeHub")
powershell -NoProfile -Command "Get-AppxPackage -allusers *people* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: people") else (call :LogErr "Remove Appx: people")
powershell -NoProfile -Command "Get-AppxPackage -allusers *SkypeApp* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: SkypeApp") else (call :LogErr "Remove Appx: SkypeApp")
powershell -NoProfile -Command "Get-AppxPackage -allusers *solit* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: solit") else (call :LogErr "Remove Appx: solit")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Sway* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Sway") else (call :LogErr "Remove Appx: Sway")
powershell -NoProfile -Command "Get-AppxPackage -allusers *Twitter* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Twitter") else (call :LogErr "Remove Appx: Twitter")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsAlarms* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsAlarms") else (call :LogErr "Remove Appx: WindowsAlarms")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsPhone* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsPhone") else (call :LogErr "Remove Appx: WindowsPhone")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsMaps* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsMaps") else (call :LogErr "Remove Appx: WindowsMaps")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsFeedbackHub") else (call :LogErr "Remove Appx: WindowsFeedbackHub")
powershell -NoProfile -Command "Get-AppxPackage -allusers *WindowsSoundRecorder* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsSoundRecorder") else (call :LogErr "Remove Appx: WindowsSoundRecorder")
powershell -NoProfile -Command "Get-AppxPackage -allusers *windowscommunicationsapps* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: windowscommunicationsapps") else (call :LogErr "Remove Appx: windowscommunicationsapps")
powershell -NoProfile -Command "Get-AppxPackage -allusers *zune* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: zune") else (call :LogErr "Remove Appx: zune")
powershell -NoProfile -Command "Get-AppxPackage *skype* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: skype") else (call :LogErr "Remove Appx: skype")
powershell -NoProfile -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: solitaire") else (call :LogErr "Remove Appx: solitaire")
powershell -NoProfile -Command "Get-AppxPackage *officehub* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: officehub") else (call :LogErr "Remove Appx: officehub")
powershell -NoProfile -Command "Get-AppxPackage *candycrush* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: candycrush") else (call :LogErr "Remove Appx: candycrush")
powershell -NoProfile -Command "Get-AppxPackage *YourPhone* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: YourPhone") else (call :LogErr "Remove Appx: YourPhone")
powershell -NoProfile -Command "Get-AppxPackage *OneDrive* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: OneDrive") else (call :LogErr "Remove Appx: OneDrive")
powershell -NoProfile -Command "taskkill /f /im OneDrive.exe" >nul 2>&1
%SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Uninstall OneDriveSetup") else (call :LogErr "Uninstall OneDriveSetup")
powershell -NoProfile -Command "Get-AppxPackage *Cortana* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Cortana") else (call :LogErr "Remove Appx: Cortana")
powershell -NoProfile -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsCamera") else (call :LogErr "Remove Appx: WindowsCamera")
powershell -NoProfile -Command "Get-AppxPackage *photos* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: photos") else (call :LogErr "Remove Appx: photos")
powershell -NoProfile -Command "Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: ConnectivityStore") else (call :LogErr "Remove Appx: ConnectivityStore")
powershell -NoProfile -Command "Get-AppxPackage *ContentDeliveryManager* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: ContentDeliveryManager") else (call :LogErr "Remove Appx: ContentDeliveryManager")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsStore* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.WindowsStore") else (call :LogErr "Remove Appx: Microsoft.WindowsStore")
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match 'Microsoft.WindowsStore' }; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
call :LogOK "Microsoft Store completely eradicated (Provisioned Package removed)!"
powershell -NoProfile -Command "Get-AppxPackage Microsoft.OneDrive | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.OneDrive") else (call :LogErr "Remove Appx: Microsoft.OneDrive")
powershell -NoProfile -Command "Get-AppxPackage Clipchamp | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Clipchamp") else (call :LogErr "Remove Appx: Clipchamp")
powershell -NoProfile -Command "Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.YourPhone") else (call :LogErr "Remove Appx: Microsoft.YourPhone")
powershell -NoProfile -Command "Get-AppxPackage Microsoft.GamingApp | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.GamingApp") else (call :LogErr "Remove Appx: Microsoft.GamingApp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.BingSearch* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.BingSearch") else (call :LogErr "Remove Appx: Microsoft.BingSearch")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.Office.OneNote") else (call :LogErr "Remove Appx: Microsoft.Office.OneNote")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.SkypeApp") else (call :LogErr "Remove Appx: Microsoft.SkypeApp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.ZuneVideo") else (call :LogErr "Remove Appx: Microsoft.ZuneVideo")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.WindowsFeedbackHub") else (call :LogErr "Remove Appx: Microsoft.WindowsFeedbackHub")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.XboxGamingOverlay") else (call :LogErr "Remove Appx: Microsoft.XboxGamingOverlay")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.XboxGameOverlay* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.XboxGameOverlay") else (call :LogErr "Remove Appx: Microsoft.XboxGameOverlay")
powershell -NoProfile -Command "Get-AppxPackage *GamingServices* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: GamingServices") else (call :LogErr "Remove Appx: GamingServices")
powershell -NoProfile -Command "$p = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*549981C3F5F10*'; if ($p) { $p | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue } }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: 549981C3F5F10") else (call :LogErr "Remove AppxProv: 549981C3F5F10")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *DevHome* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*DevHome*' -or $_.PackageName -like '*DevHome*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: DevHome") else (call :LogErr "Remove AppxProv: DevHome")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *OutlookForWindows* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*OutlookForWindows*' -or $_.PackageName -like '*OutlookForWindows*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: OutlookForWindows") else (call :LogErr "Remove AppxProv: OutlookForWindows")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *PowerAutomateDesktop* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*PowerAutomateDesktop*' -or $_.PackageName -like '*PowerAutomateDesktop*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: PowerAutomateDesktop") else (call :LogErr "Remove AppxProv: PowerAutomateDesktop")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Todos* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Todos*' -or $_.PackageName -like '*Todos*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: Todos") else (call :LogErr "Remove AppxProv: Todos")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Whiteboard* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Whiteboard*' -or $_.PackageName -like '*Whiteboard*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: Whiteboard") else (call :LogErr "Remove AppxProv: Whiteboard")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *MixedReality.Portal* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*MixedReality.Portal*' -or $_.PackageName -like '*MixedReality.Portal*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: MixedReality.Portal") else (call :LogErr "Remove AppxProv: MixedReality.Portal")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *DisneyMagicKingdoms* | Remove-AppxPackage -ErrorAction SilentlyContinue; Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*DisneyMagicKingdoms*' -or $_.PackageName -like '*DisneyMagicKingdoms*' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: DisneyMagicKingdoms") else (call :LogErr "Remove AppxProv: DisneyMagicKingdoms")
winget uninstall --silent --accept-source-agreements "Windows web experience Pack" >nul 2>&1
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
if %errorlevel% equ 0 (call :LogOK "Winget uninstall: Web Exp Pack") else (call :LogErr "Winget uninstall: Web Exp Pack")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: GetHelp") else (call :LogErr "Remove Appx: GetHelp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Todos") else (call :LogErr "Remove Appx: Todos")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: BingNews") else (call :LogErr "Remove Appx: BingNews")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: 3DViewer") else (call :LogErr "Remove Appx: 3DViewer")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.Windows.Cortana* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Cortana") else (call :LogErr "Remove Appx: Cortana")

call :LogInfo "Disabling Windows AI & Copilot"
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowRecall" /t REG_DWORD /d 0 /f
call :LogOK "AI Features Disabled!"

call :LogInfo "Cleaning Temporary Files (Flawless Execution)..."

for /d %%D in ("%temp%\*") do (
    if /i not "%%~nxD"=="BARDHZZY_Logs" (
        rd /s /q "%%D" >nul 2>&1
    )
)

for %%F in ("%temp%\*.*") do (
    if /i not "%%~xF"==".bat" if /i not "%%~xF"==".cmd" if /i not "%%~xF"==".ps1" (
        del /q /f /a "%%F" >nul 2>&1
    )
)
del /q /f /a "%temp%\*.tmp" >nul 2>&1

%TI% cmd.exe /c "del /s /f /q /a C:\Windows\Temp\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do %TI% cmd.exe /c "rd /s /q \"%%D\"" >nul 2>&1

%TI% cmd.exe /c "del /s /f /q /a C:\Windows\Prefetch\*.*" >nul 2>&1
for /d %%D in ("C:\Windows\Prefetch\*") do %TI% cmd.exe /c "rd /s /q \"%%D\"" >nul 2>&1

call :TIScLog stop wuauserv
call :TIScLog stop BITS
timeout /t 1 /nobreak >nul
%TI% cmd.exe /c "del /s /f /q /a C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1

call :LogOK "Temporary files cleared."

call :LogInfo "Clearing Windows Event Logs..."
for /f "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G" >nul 2>&1)

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
:: FIX: Removed /resetbase to prevent crashing, added /NoRestart
dism /online /cleanup-image /startcomponentcleanup /NoRestart >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "DISM Component Cleanup") else (call :LogWarn "DISM Component Cleanup (Skipped or failed)")

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
        call :LogWarn "(Note: To re-enable Wi-Fi later, go to Device Manager -^> Network Adapters -^> Right-Click your Wi-Fi adapter -^> Enable)"
    )
    timeout /t 2 /nobreak >nul
)

if /i "%wifi_kill%"=="Y" (
    call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
    call :TIScLog stop WlanSvc
    call :LogWarn "WLAN AutoConfig was disabled because Ethernet-only mode was selected."
) else (
    call :LogSkip "WLAN AutoConfig left unchanged."
)

call :LogInfo "Enabling MSI/MSI-X for Ethernet adapters..."
setlocal enabledelayedexpansion
set "count=0"

for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "IfType" 2^>nul ^| findstr /i "HKEY_LOCAL_MACHINE"') do (
    reg query "%%i" /v "IfType" 2>nul | findstr /i /r "REG_DWORD *0x6[ ]*$" >nul && (
        for /f "tokens=2*" %%A in ('reg query "%%i" /v "PnPInstanceID" 2>nul ^| findstr /i "PnPInstanceID"') do (
            set "MSI_REG_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\%%B\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
            
            reg query "!MSI_REG_PATH!" >nul 2>&1
            if !errorlevel! equ 0 (
                call :RegLog add "!MSI_REG_PATH!" /v "MSISupported" /t REG_DWORD /d 1 /f
                set /a count+=1
            ) else (
                call :LogSkip "Adapter %%B lacks MSI structures. Unsafe to force."
            )
        )
    )
)
if %count%==0 (
    call :LogWarn "No physical Ethernet adapters found or applied."
) else (
    call :LogOK "Successfully applied MSI mode to %count% adapter(s)."
)

call :LogInfo "Applying Advanced Network Tweaks..."
for /f "skip=2 delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    call :RegLog add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
    call :RegLog add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
)

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f

call :LogInfo "Disabling Network Diagnostic Usage (NDU)..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d 4 /f

netsh advfirewall firewall set rule group="Network Discovery" new enable=no >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh advfirewall Network Discovery") else (call :LogErr "netsh advfirewall Network Discovery")
netsh int tcp set supplemental Template=Compat CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh cubic Compat") else (call :LogErr "netsh cubic Compat")
netsh int tcp set supplemental Template=Internet CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh cubic Internet") else (call :LogErr "netsh cubic Internet")
netsh int tcp set supplemental Template=Datacenter CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh cubic Datacenter") else (call :LogErr "netsh cubic Datacenter")
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh cubic InternetCustom") else (call :LogErr "netsh cubic InternetCustom")
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh cubic DatacenterCustom") else (call :LogErr "netsh cubic DatacenterCustom")
netsh int tcp set global ecncapability=disabled >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh ecncapability=disabled") else (call :LogErr "netsh ecncapability=disabled")
netsh int tcp set global autotuninglevel=normal >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh autotuninglevel=normal") else (call :LogErr "netsh autotuninglevel=normal")
netsh interface ip delete arpcache >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh delete arpcache") else (call :LogErr "netsh delete arpcache")
call :LogInfo "Enabling TCP Fast Open..."
netsh int tcp set global fastopen=1 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh fastopen=1") else (call :LogErr "netsh fastopen=1")

call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer" /v EnableOplocks /t REG_DWORD /d 0 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer" /v OplocksDisabled /t REG_DWORD /d 1 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mrxsmb" /v OplocksDisabled /t REG_DWORD /d 1 /f
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 2 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f
call :RegLog add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d 32 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f

call :TIScLog config SSDPSRV start= disabled
call :TIScLog stop SSDPSRV
call :TIScLog config VacSvc start= disabled
call :TIScLog stop VacSvc
netsh int tcp set global Chimney=disabled >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh Chimney=disabled") else (call :LogErr "netsh Chimney=disabled")
netsh int tcp set global rsc=disabled >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh rsc=disabled") else (call :LogErr "netsh rsc=disabled")
powershell -NoProfile -Command "Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object { $_.SetTCPIPNetBIOS(2) }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable NetBIOS over TCP/IP") else (call :LogErr "Disable NetBIOS over TCP/IP")
powershell -NoProfile -Command "Get-NetAdapter | Enable-NetAdapterRss -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Enable-NetAdapterRss") else (call :LogErr "Enable-NetAdapterRss")
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumTcbTablePartitions" /t REG_DWORD /d 16 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f
powershell -NoProfile -Command "Get-NetAdapter | Disable-NetAdapterPowerManagement -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable-NetAdapterPowerManagement") else (call :LogErr "Disable-NetAdapterPowerManagement")
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -like '*Energy*'} | Set-NetAdapterAdvancedProperty -RegistryValue '0' -NoRestart" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable NetAdapter Energy") else (call :LogErr "Disable NetAdapter Energy")
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -like '*Green*'} | Set-NetAdapterAdvancedProperty -RegistryValue '0' -NoRestart" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable NetAdapter Green") else (call :LogErr "Disable NetAdapter Green")
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -like '*Power*'} | Set-NetAdapterAdvancedProperty -RegistryValue '0' -NoRestart" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable NetAdapter Power") else (call :LogErr "Disable NetAdapter Power")

for %%a in (
    "EnergyEfficientEthernet"
    "SelectiveSuspend"
    "PowerSaving"
    "GreenEthernet"
) do (
    powershell -NoProfile -Command "$p = Get-NetAdapterAdvancedProperty -DisplayName '*%%~a*' -ErrorAction SilentlyContinue; if ($p) { $p | Set-NetAdapterAdvancedProperty -RegistryValue 0 -ErrorAction SilentlyContinue; exit 0 } else { exit 1 }" >nul 2>&1
    if !errorlevel! equ 0 (call :LogOK "Disable NetAdapter %%~a") else (call :LogWarn "Skip NetAdapter %%~a (Not supported by NIC)")
)

ipconfig /flushdns >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "ipconfig /flushdns") else (call :LogErr "ipconfig /flushdns")
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
if %errorlevel% equ 0 (call :LogOK "fsutil memoryusage 2") else (call :LogErr "fsutil memoryusage 2")
fsutil behavior set Disabledeletenotify 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil Disabledeletenotify 0") else (call :LogErr "fsutil Disabledeletenotify 0")
fsutil behavior set encryptpagingfile 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil encryptpagingfile 0") else (call :LogErr "fsutil encryptpagingfile 0")

call :LogInfo "Enabling MSI Mode for Active Storage Controllers..."
setlocal EnableDelayedExpansion
for %%S in (stornvme storahci) do (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=1,2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" 2^>nul ^| find "REG_SZ"') do (
            set "DEVICE_ID=%%C"
            set "REG_PATH=HKLM\SYSTEM\CurrentControlSet\Enum\!DEVICE_ID!\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
            call :LogInfo "Target Found: !DEVICE_ID!"
            reg query "!REG_PATH!" >nul 2>&1
            if !errorlevel! equ 0 (
                call :RegLog add "!REG_PATH!" /v "MSISupported" /t REG_DWORD /d 1 /f
            ) else (
                call :LogSkip "Hardware lacks MSI structures. Unsafe to force."
            )
        )
    )
)
call :LogInfo "Storage MSI configuration complete."

call :LogInfo "Disabling Sleep Study"
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f

fsutil behavior set disablelastaccess 1 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil disablelastaccess 1") else (call :LogErr "fsutil disablelastaccess 1")
fsutil behavior set mftzone 1 > nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil mftzone 1") else (call :LogErr "fsutil mftzone 1")
fsutil behavior set disable8dot3 1 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil disable8dot3 1") else (call :LogErr "fsutil disable8dot3 1")

call :SchLog /run /tn "Microsoft\Windows\DiskCleanup\SilentCleanup"

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d 0 /f
call :LogOK "All Storage Tweaks applied successfully!"
endlocal
timeout /t 1 /nobreak > NUL
pause
goto main

:input
call :LogSection "Input Lag Tweaks"
echo You selected Input lag tweaks!

call :LogInfo "Setting Latency Tolerance"
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f
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
if %errorlevel% equ 0 (call :LogOK "powercfg hid device power") else (call :LogErr "powercfg hid device power")

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
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "ConnectMultiplePorts" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "MaximumPortsServiced" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "SendOutputToAllPorts" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "ConnectMultiplePorts" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MaximumPortsServiced" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "SendOutputToAllPorts" /t REG_DWORD /d 0 /f
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
color 09
echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[91m[!] BARDHZZY Tweaks - Aggressive Warning%ESC%[0m
echo ======================================================
echo.
echo  %ESC%[91m[!]%ESC%[0m The following tweaks will disable hardware devices:
echo      - High Precision Event Timer (HPET)
echo      - System Timer
echo      - Direct Memory Access (DMA) Controller
echo      - Numeric Data Processor
echo      - Composite Bus Enumerator
echo      - Microsoft GS Wavetable Synth
echo.
echo  %ESC%[91m[!] RISKS:%ESC%[0m
echo      Disabling HPET and System Timers is highly debated.
echo      On modern Windows, the OS relies on these for scheduling.
echo      This can either fix micro-stutters completely OR cause
echo      system freezes, DPC watchdog violations, and audio issues.
echo.
echo  %ESC%[37m [%ESC%[36m1%ESC%[37m] Continue (I understand the risks)
echo  %ESC%[37m [%ESC%[36m2%ESC%[37m] Go Back to Main Menu
echo.
set "pnp_choice="
set /p "pnp_choice=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

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

:: Flawless PowerShell execution: No pipes to confuse CMD, handles multiple instances, forces UTF-8 output
powershell -NoProfile -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $devices = @('High Precision Event Timer', 'System Timer', 'Direct memory access controller', 'Numeric Data Processor', 'Composite Bus Enumerator', 'Microsoft GS Wavetable Synth'); $found=0; foreach ($d in $devices) { $devs = Get-PnpDevice -FriendlyName $d -ErrorAction SilentlyContinue; foreach ($dev in $devs) { if ($dev.Status -eq 'OK') { try { Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction Stop; Write-Output ('OK:' + $d); $found=1 } catch { Write-Output ('FAIL:' + $d); $found=1 } } } }; if ($found -eq 0) { Write-Output 'WARN:No active target devices were found.' }" > "%TEMP%\bardhzz_pnp_log.txt"

:: Parse the results flawlessly
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
call :LogSection "Power Tweaks"
echo [++] Activating Ultimate Performance Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg duplicatescheme") else (call :LogErr "powercfg duplicatescheme")
for /f "tokens=4" %%a in ('powercfg -list ^| findstr /i "Ultimate Performance"') do (
    powercfg -setactive %%a >nul 2>&1
    call :LogOK "powercfg setactive %%a"
)
powercfg /hibernate off >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg hibernate off") else (call :LogErr "powercfg hibernate off")

call :LogInfo "Configuring Core parking..."
call :LogInfo "Applying Core Unparking Registry Keys..."
call :RegLog add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "Attributes" /t REG_DWORD /d 0 /f
if %errorlevel% equ 0 (call :LogOK "reg CPMINCORES 0") else (call :LogErr "reg CPMINCORES 0")
call :RegLog add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d 100 /f
if %errorlevel% equ 0 (call :LogOK "reg CPMAXCORES 100") else (call :LogErr "reg CPMAXCORES 100")
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg CPMINCORES 100") else (call :LogErr "powercfg CPMINCORES 100")
powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg CPMAXCORES 100") else (call :LogErr "powercfg CPMAXCORES 100")
powercfg /setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg ASPM 0") else (call :LogErr "powercfg ASPM 0")
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg disablewaketimersac") else (call :LogErr "disablewaketimersac")
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg 48e6b7a6 0") else (call :LogErr "powercfg 48e6b7a6 0")
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg SYSCOOLPOL 1") else (call :LogErr "powercfg SYSCOOLPOL 1")
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg DISKIDLE 0") else (call :LogErr "powercfg DISKIDLE 0")
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP UnattendSleepTimeout 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg unattendsleeptimeout") else (call :LogErr "powercfg unattendsleeptimeout")
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg VIDEOIDLE 0") else (call :LogErr "powercfg VIDEOIDLE 0")
powercfg -setactive scheme_current >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg setactive scheme_current") else (call :LogErr "powercfg setactive scheme_current")

for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "AllowIdleIrpInD3" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    call :RegLog add "%%a" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f
)
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "Attributes" /t REG_DWORD /d 2 /f
powercfg -setacvalueindex scheme_current 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg ee12f906 0") else (call :LogErr "powercfg ee12f906 0")

for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "Device Parameters" /k ^| findstr "Device Parameters"') do (
    call :RegLog add "%%i" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f
    call :RegLog add "%%i" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f
)

call :LogInfo "Disabling Power Throttling"
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DeepIoCoalescingEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d 0 /f

call :LogInfo "Optimizing System Timers and Disabling Throttling..."
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 1 /f
call :LogInfo "Applying Aggressive System Timer Tweaks..."
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "PlatformTimer" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "TimerSetCoalesce" /t REG_DWORD /d 0 /f
:: Forces MMCSS to prioritize gaming threads unconditionally
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d 100 /f

call :LogInfo "Setting MMCSS"
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f

call :LogInfo "Setting Resource Policy Store Values"
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Frozen" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNCS" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenPPLE" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Paused" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PausedDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Pausing" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" /v "IsLowPriority" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "BasePriority" /t REG_DWORD /d "82" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "OverTargetPriority" /t REG_DWORD /d "50" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f
call :RegLog add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f

call :LogInfo "Applying bcdedit and powercfg settings..."
bcdedit /set disabledynamictick Yes >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit disabledynamictick Yes") else (call :LogErr "bcdedit disabledynamictick Yes")
bcdedit /deletevalue useplatformclock >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit deletevalue useplatformclock") else (call :LogWarn "bcdedit deletevalue useplatformclock")
bcdedit /deletevalue useplatformtick >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit deletevalue useplatformtick") else (call :LogWarn "bcdedit deletevalue useplatformtick")
bcdedit /set quietboot yes >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit quietboot yes") else (call :LogErr "bcdedit quietboot yes")
bcdedit /set bootuxdisabled yes >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit bootuxdisabled yes") else (call :LogErr "bcdedit bootuxdisabled yes")
bcdedit /timeout 3
if %errorlevel% equ 0 (call :LogOK "bcdedit timeout 3") else (call :LogErr "bcdedit timeout 3")
bcdedit /set bootstatuspolicy ignoreallfailures >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit bootstatuspolicy ignoreallfailures") else (call :LogErr "bcdedit bootstatuspolicy ignoreallfailures")
bcdedit /set {current} bootmenupolicy Standard >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit bootmenupolicy Standard") else (call :LogErr "bcdedit bootmenupolicy Standard")
bcdedit /set x2apicpolicy Enable >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit x2apicpolicy Enable") else (call :LogErr "bcdedit x2apicpolicy Enable")
bcdedit /set numaoptimize 1 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit numaoptimize 1") else (call :LogErr "bcdedit numaoptimize 1")
bcdedit /set bootlog No >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit bootlog No") else (call :LogErr "bcdedit bootlog No")
bcdedit /set configaccesspolicy Default >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "bcdedit configaccesspolicy Default") else (call :LogErr "bcdedit configaccesspolicy Default")
powercfg -h off >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg -h off") else (call :LogErr "powercfg -h off")
powercfg -change -disk-timeout-ac 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg -change -disk-timeout-ac 0") else (call :LogErr "powercfg -change -disk-timeout-ac 0")
powercfg /setacvalueindex scheme_current sub_processor CPMAXCORES 100 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg CPMAXCORES 100") else (call :LogErr "powercfg CPMAXCORES 100")
powercfg /setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg PERFBOOSTMODE 2") else (call :LogErr "powercfg PERFBOOSTMODE 2")
powercfg -setactive SCHEME_CURRENT >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg -setactive SCHEME_CURRENT") else (call :LogErr "powercfg -setactive SCHEME_CURRENT")
%dmv% "ACPI\PNP0103" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "High Precision Event Timer driver") else (call :LogErr "High Precision Event Timer driver")

call :LogOK "Power tweaks applied successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:srp
call :LogSection "System Restore Point"
cls
chcp 65001 >nul 2>&1
echo %ESC%[0m
color 09
title BARDHZZY Tweaks - Creating Restore Point

echo =============================================
echo     Creating System Restore Point
echo =============================================
echo.

call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f

echo [+] Enabling System Protection on C: drive...
set "PS_SCRIPT=%TEMP%\bardhzzy_srp.ps1"
echo Enable-ComputerRestore -Drive 'C:\' > "%PS_SCRIPT%"
echo Checkpoint-Computer -Description 'BardhzzyTweak_Restore' -RestorePointType 'MODIFY_SETTINGS' >> "%PS_SCRIPT%"

echo [+] Creating restore point (This may take a moment)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" >nul 2>&1
set "SRP_STATUS=%errorlevel%"
del /q "%PS_SCRIPT%" >nul 2>&1

cls
chcp 65001 >nul 2>&1
echo %ESC%[0m
color 09

if %SRP_STATUS% equ 0 (
    call :LogOK "Restore point created successfully! (BardhzzyTweak_Restore)"
    echo =============================================
    echo     Creating System Restore Point
    echo =============================================
    echo.
    echo [OK] Restore point created successfully!
    echo     Description: BardhzzyTweak_Restore
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
chcp 65001 >nul 2>&1
echo %ESC%[0m
color 0B
echo.
echo ======================================================
echo           BARDHZZY Tweaks - Registry Backup
echo ======================================================
echo.

set "BACKUP_DIR=%ProgramData%\BARDHZZY\Backup"

if exist "%BACKUP_DIR%\HKLM_SYSTEM.reg" (
    echo [!] WARNING: A registry backup already exists at:
    echo     %BACKUP_DIR%
    echo     Creating a new backup will overwrite the old one.
    echo.
    choice /c YN /n /m "Do you want to overwrite the existing backup? (Y/N): "
    if errorlevel 2 goto main
)

echo.
echo [+] Creating Safety Backup of System Registry...
echo     This may take up to 30 seconds. Please do not close this window...
echo.

if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%" >nul 2>&1
)

if not exist "%BACKUP_DIR%" (
    call :LogErr "Could not create backup directory."
    echo [X] ERROR: Could not create:
    echo     %BACKUP_DIR%
    echo.
    pause
    goto main
)

set "BACKUP_OK=1"

echo [1/4] Exporting HKLM\SYSTEM...
reg export "HKLM\SYSTEM" "%BACKUP_DIR%\HKLM_SYSTEM.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKLM_SYSTEM failed."
    echo [X] HKLM_SYSTEM backup FAILED
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKLM_SYSTEM"
    echo [OK] HKLM_SYSTEM backup created
)

echo [2/4] Exporting HKLM\SOFTWARE...
reg export "HKLM\SOFTWARE" "%BACKUP_DIR%\HKLM_SOFTWARE.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKLM_SOFTWARE failed."
    echo [X] HKLM_SOFTWARE backup FAILED
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKLM_SOFTWARE"
    echo [OK] HKLM_SOFTWARE backup created
)

echo [3/4] Exporting HKCU\Software...
reg export "HKCU\Software" "%BACKUP_DIR%\HKCU_Software.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKCU_Software failed."
    echo [X] HKCU_Software backup FAILED
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKCU_Software"
    echo [OK] HKCU_Software backup created
)

echo [4/4] Exporting HKCU\Control Panel...
reg export "HKCU\Control Panel" "%BACKUP_DIR%\HKCU_CPanel.reg" /y >nul 2>&1
if errorlevel 1 (
    call :LogErr "Export HKCU_CPanel failed."
    echo [X] HKCU_CPanel backup FAILED
    set "BACKUP_OK=0"
) else (
    call :LogOK "Export HKCU_CPanel"
    echo [OK] HKCU_CPanel backup created
)

echo.

if "%BACKUP_OK%"=="1" (
    call :LogOK "Complete registry backup verified."
    echo ======================================================
    echo [OK] COMPLETE REGISTRY BACKUP VERIFIED
    echo ======================================================
    echo.
    echo Backup location:
    echo %BACKUP_DIR%
    echo.
    echo You can now safely use the Revert Tweaks option.
) else (
    call :LogErr "Registry backup is incomplete."
    echo ======================================================
    echo [X] REGISTRY BACKUP FAILED / INCOMPLETE
    echo ======================================================
    echo.
    echo One or more registry exports failed.
    echo DO NOT use Revert Tweaks until a complete backup exists.
)

echo.
echo Press any key to return to the main menu...
pause >nul
goto main


:timerres
setlocal EnableDelayedExpansion
call :LogSection "Timer Resolution"
cls
echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mLATENCY ^& TIMER RESOLUTION TOOLS%ESC%[0m
echo.

call :LogInfo "Enabling support for global timer resolution requests..."
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f
if %errorlevel% equ 0 (
    call :LogOK "GlobalTimerResolutionRequests enabled."
) else (
    call :LogErr "Failed to enable GlobalTimerResolutionRequests."
)

set "TIMER_DIR=C:\bardhzzY Utility Tools\Timer Resolution"
set "TIMER_EXE=%TIMER_DIR%\SetTimerResolution.exe"
set "MEASURE_EXE=%TIMER_DIR%\MeasureSleep.exe"
set "REPO_ZIP=%TEMP%\elifian_timer.zip"
set "EXTRACT_DIR=%TEMP%\elifian_timer_extracted"

if exist "%TIMER_EXE%" (
    for %%I in ("%TIMER_EXE%") do if %%~zI LSS 10240 del /q "%TIMER_EXE%" >nul 2>&1
)

if not exist "%TIMER_EXE%" (
    call :LogInfo "Downloading SetTimerResolution.exe (amitxv)..."
    mkdir "%TIMER_DIR%" >nul 2>&1
    
    curl -L -f -s -o "%TIMER_EXE%" "https://github.com/amitxv/SetTimerResolution/raw/master/SetTimerResolution.exe" >nul 2>&1
    if exist "%TIMER_EXE%" for %%I in ("%TIMER_EXE%") do if %%~zI LSS 10240 del /q "%TIMER_EXE%" >nul 2>&1

    if not exist "%TIMER_EXE%" (
        curl -L -f -s -o "%TIMER_EXE%" "https://github.com/elifian/SetTimerResolution/raw/main/SetTimerResolution.exe" >nul 2>&1
        if exist "%TIMER_EXE%" for %%I in ("%TIMER_EXE%") do if %%~zI LSS 10240 del /q "%TIMER_EXE%" >nul 2>&1
    )

    if not exist "%TIMER_EXE%" (
        call :LogInfo "Direct link failed. Downloading repository archive..."
        if exist "%REPO_ZIP%" del /q "%REPO_ZIP%" >nul 2>&1
        if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%" >nul 2>&1
        
        curl -L -f -s -o "%REPO_ZIP%" "https://github.com/elifian/SetTimerResolution/archive/refs/heads/master.zip" >nul 2>&1
        if not exist "%REPO_ZIP%" curl -L -f -s -o "%REPO_ZIP%" "https://github.com/elifian/SetTimerResolution/archive/refs/heads/main.zip" >nul 2>&1
        
        if exist "%REPO_ZIP%" (
            mkdir "%EXTRACT_DIR%" >nul 2>&1
            tar -xf "%REPO_ZIP%" -C "%EXTRACT_DIR%" >nul 2>&1
            
            for /r "%EXTRACT_DIR%" %%F in (SetTimerResolution.exe) do (
                if not exist "%TIMER_EXE%" copy /Y "%%F" "%TIMER_EXE%" >nul 2>&1
            )
        )
        
        rd /s /q "%EXTRACT_DIR%" >nul 2>&1
        del /q "%REPO_ZIP%" >nul 2>&1
    )

    if exist "%TIMER_EXE%" (
        for %%I in ("%TIMER_EXE%") do if %%~zI GTR 10240 (
            call :LogOK "SetTimerResolution.exe downloaded successfully."
        ) else (
            call :LogErr "Downloaded file is corrupted or invalid."
            del /q "%TIMER_EXE%" >nul 2>&1
            goto :timerres_islc
        )
    ) else (
        call :LogErr "Failed to download SetTimerResolution.exe automatically."
        call :LogInfo "Please download it manually from amitxv's GitHub and place it in:"
        echo     "%TIMER_DIR%\"
        goto :timerres_islc
    )
) else (
    call :LogOK "SetTimerResolution.exe already exists."
)

:timerres_menu
cls
echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mSELECT TIMER RESOLUTION%ESC%[0m
echo  %ESC%[37m [%ESC%[36m1%ESC%[37m] 0.500ms %ESC%[90m(5000)%ESC%[0m
echo  %ESC%[37m [%ESC%[36m2%ESC%[37m] 0.504ms %ESC%[90m(5040)%ESC%[0m
echo  %ESC%[37m [%ESC%[36m3%ESC%[37m] 0.507ms %ESC%[90m(5070)%ESC%[0m
echo  %ESC%[37m [%ESC%[36m4%ESC%[37m] Custom Value %ESC%[90m(Enter microseconds)%ESC%[0m
echo  %ESC%[37m [%ESC%[36m5%ESC%[37m] Measure Sleep Timing
echo  %ESC%[37m [%ESC%[36m6%ESC%[37m] Skip Timer Resolution
echo.
set "timer_choice="
set /p "timer_choice=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

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
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mMEASURE TIMER RESOLUTION%ESC%[0m
echo.
echo  %ESC%[37mMeasureSleep checks the actual timing behavior of Windows Sleep(1).%ESC%[0m
echo.

if not exist "%MEASURE_EXE%" (
    call :LogErr "MeasureSleep.exe was not found."
    echo.
    echo  %ESC%[31m[ERROR]%ESC%[37m MeasureSleep.exe is missing.
    echo.
    echo  Place it here:
    echo  %ESC%[90m%MEASURE_EXE%%ESC%[0m
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
echo  %ESC%[90mMeasureSleep is running separately. Review its results, then return here.%ESC%[0m
echo.
pause
goto timerres_menu

:timer_custom
cls
echo.
echo.
echo        %ESC%[34m██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗%ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝%ESC%[0m
echo        %ESC%[34m██████╔╗███████║██████╔╗██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ %ESC%[0m
echo        %ESC%[34m██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  %ESC%[0m
echo        %ESC%[34m██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   %ESC%[0m
echo        %ESC%[34m╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   %ESC%[0m
echo.
echo  %ESC%[34mENTER CUSTOM TIMER RESOLUTION%ESC%[0m
echo  %ESC%[90mValue must be in microseconds (e.g., 5000 for 0.5ms). Max 50000.%ESC%[0m
echo.
set "custom_val="
set /p "custom_val=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Enter value: %ESC%[0m"
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
call :LogInfo "Setting %TIMER_VAL%us Timer Resolution on startup..."
call :TIRegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BardhzzyTimerResolution" /t REG_SZ /d ^""%TIMER_EXE%" --resolution %TIMER_VAL% --no-console^" /f
if %errorlevel% equ 0 (
    call :LogOK "Timer Resolution set to %TIMER_VAL%us permanently (Startup Registry)."
) else (
    call :LogErr "Failed to set startup registry key."
)

call :LogInfo "Starting SetTimerResolution for current session..."
start "" "%TIMER_EXE%" --resolution %TIMER_VAL% --no-console
call :LogOK "Timer Resolution applied for this session."

:timerres_islc
echo.
echo  %ESC%[37m [%ESC%[36m1%ESC%[37m] Download ISLC (Recommended for 16GB RAM or less)
echo  %ESC%[37m [%ESC%[36m2%ESC%[37m] Skip ISLC
echo.
set "islc_choice="
set /p "islc_choice=%ESC%[34m[%ESC%[37m ? %ESC%[34m]%ESC%[37m Select an option: %ESC%[0m"

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
    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://www.wagnardsoft.com/ISLC/ISLC%%20v1.0.3.2.exe' -OutFile '%ISLC_INSTALLER%' -UseBasicParsing } catch { exit 1 }" >nul 2>&1
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
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package*.mum >nul 2>&1
if %errorLevel% equ 0 (
    for /f "delims=" %%i in ('dir /b /s %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package*.mum') do dism /online /norestart /add-package:"%%i" >nul 2>&1
    call :LogOK "dism add gpedit ClientTools"
    for /f "delims=" %%i in ('dir /b /s %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum') do dism /online /norestart /add-package:"%%i" >nul 2>&1
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
if %errorlevel% equ 0 (call :LogOK "netsh autotuninglevel=normal") else (call :LogErr "netsh autotuninglevel=normal")
echo        - TCP window scaling optimized for stable packet delivery.
echo.

call :LogInfo "[6/7] Activating adapter stream configuration..."
powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Enable-NetAdapterQos -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Enable-NetAdapterQos") else (call :LogErr "Enable-NetAdapterQos")
echo        - Hardware streams successfully aligned.
echo.

call :LogInfo "[7/7] Injecting Fortnite Game Packet Matrix Rule..."
powershell -NoProfile -Command "Remove-NetQosPolicy -Name 'FortniteQoS' -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'FortniteQoS' -AppPathName 'FortniteClient-Win64-Shipping.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction Stop" >nul 2>&1
if %errorLevel% equ 0 (
    call :LogOK "Fortnite Client prioritized (DSCP 46 | Profile: ALL)."
    echo        - Success: Fortnite Client prioritized ^(DSCP 46 ^| Profile: ALL^).
) else (
    call :LogErr "Failed to hook packet stream to OS policies."
    echo        - Warning: Failed to hook packet stream to OS policies.
)
echo.
call :LogOK "[+] GPedit is active and Fortnite network priority is locked in."

cls
color 9
chcp 65001 >nul 2>&1

set "Reset=%ESC%[0m"
set "DarkYellow=%ESC%[33m"
set "Red=%ESC%[91m"
set "Green=%ESC%[92m"
set "Blue=%ESC%[94m"
set "Cyan=%ESC%[96m"
set "White=%ESC%[97m"

if not exist "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" (
   goto :FN_Default_Path_Not_Found
) else (
   set "FortnitePath=C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
   goto :FN_Download_Tools
)

:FN_Default_Path_Not_Found
cls
color C
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════════╗
echo ║ Fortnite is not installed in the default Path.    ║
echo ╚═══════════════════════════════════════════════════╝
echo • Fortnite is likely installed on another drive or location!
echo.
echo %White%[Choose an option]
echo %Green%1. Manually Input Path
echo %DarkYellow%2. Continue Anyway
echo %Cyan%3. Learn More
echo %Red%4. Back to Main Menu
set "fnoption="
set /p fnoption="%White%Enter option number: "
chcp 65001 >nul 2>&1
if "%fnoption%"=="1" goto :FN_Manual_Path
if "%fnoption%"=="2" (
    cls
    color C
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
color A
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════════════════════════════════════════════╗
echo ║ Adding Manual Fortnite Path. [Path must include FortniteClient-Win64-Shipping.exe]    ║
echo ╚═══════════════════════════════════════════════════════════════════════════════════════╝
echo • Example: "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
echo.
set /p FortnitePath="Enter Your Fortnite Path: "
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
curl -s -L "%FN_FileURL%" -o "%FN_DownloadsFolder%\%FN_FileName%"
if exist "%FN_DownloadsFolder%\%FN_FileName%" (
   call :LogOK "Fortnite Tools downloaded."
   mkdir "%FN_ExtractFolder%" >nul 2>&1
   pushd "%FN_ExtractFolder%" >nul 2>&1
   tar -xf "%FN_DownloadsFolder%\%FN_FileName%" --strip-components=1 >nul 2>&1
   popd >nul 2>&1
   del /q "%FN_DownloadsFolder%\%FN_FileName%" >nul 2>&1
   goto :FN_Start_Screen
) else (
   call :LogErr "Failed to download Fortnite Optimizer Tools."
   goto :FN_Download_Failed
)

:FN_Download_Failed
cls
color C
chcp 65001 >nul 2>&1
echo ╔════════════════════════════════════════════════════════╗
echo ║ Fortnite Optimizer Tools Folder failed to download.    ║
echo ╚════════════════════════════════════════════════════════╝
echo • Please ensure you're connected to the internet!
echo.
echo %White%[Choose an option]
echo %Green%1. Retry
echo %Red%2. Back to Main Menu
set /p fnoption="%White%Enter option number: "
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
color 09
chcp 65001 >nul 2>&1
echo.
echo.
echo.                             %ESC%[34m███████╗ ██████╗ ██████╗ ████████╗███╗   ██╗██╗████████╗███████╗       %ESC%[0m
echo.                             %ESC%[34m██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║╚══██╔══╝██╔════╝       %ESC%[0m
echo.                             %ESC%[34m██████╗ ██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║   ██║   █████╗         %ESC%[0m
echo.                             %ESC%[34m██╔══╝  ██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║   ██║   ██╔══╝         %ESC%[0m
echo.                             %ESC%[34m██║     ╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║   ██║   ███████╗       %ESC%[0m
echo.                             %ESC%[34m╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝   ╚═╝   ╚══════╝       %ESC%[0m
echo.                                                                       
echo.                             %ESC%[34m██████╗  ██████╗ ████████╗██╗███╗   ███╗██╗███████╗███████╗██████╗     %ESC%[0m
echo.                             %ESC%[34m██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔════╝██╔══██╗    %ESC%[0m
echo.                             %ESC%[34m██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ █████╗  ██████╔╝    %ESC%[0m
echo.                             %ESC%[34m██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══╝  ██╔══██╗    %ESC%[0m
echo.                             %ESC%[34m╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗███████╗██║  ██║    %ESC%[0m
echo.                             %ESC%[34m ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝    %ESC%[0m
echo. 
echo.                                  %ESC%[34m╔════════════════════════════════════════════════════╗%ESC%[0m
echo.                                  %ESC%[34m║%ESC%[0m              %ESC%[37mVersion 2.1 - By Quaked%ESC%[0m               %ESC%[34m║%ESC%[0m
echo.                                  %ESC%[34m╚════════════════════════════════════════════════════╝%ESC%[0m
echo.
echo. %ESC%[34m╔═════════╗%ESC%[0m                                                                        
echo. %ESC%[34m║%ESC%[0m %ESC%[37mLoading %ESC%[34m║%ESC%[0m                                              
echo. %ESC%[34m╚═════════╝%ESC%[0m
timeout 2 > nul

cls
color 9
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
color 9
chcp 65001 >nul 2>&1
echo ╔═══════════════════════════════════════════════╗
echo ║ Importing Optimized Fortnite Game Configs.    ║
echo ╚═══════════════════════════════════════════════╝
echo • Please choose a config depending on your use case.
echo.
if not exist "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" mkdir "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient"

echo %White%[Choose an option]
echo %Green%1. Legacy Performance Mode.
echo %Blue%2. New Performance Mode.
echo %Blue%3. DX 12.
echo %Blue%4. DX 11.
echo %Red%5. Skip.
set /p fnoption="%White%Enter option number: "
if "%fnoption%"=="1" (
    cls
    color A
    echo ╔═══════════════════════════════════════╗
    echo ║ Importing Legacy Performance Mode.    ║
    echo ╚═══════════════════════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\Legacy Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import Legacy Performance Mode!"
        echo %Red%Failed to import Legacy Performance Mode!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported Legacy Performance Mode!"
        echo %Green%Successfully imported Legacy Performance Mode!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="2" (
    cls
    color A
    echo ╔════════════════════════════════════╗
    echo ║ Importing New Performance Mode.    ║
    echo ╚════════════════════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\New Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import New Performance Mode!"
        echo %Red%Failed to import New Performance Mode!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported New Performance Mode!"
        echo %Green%Successfully imported New Performance Mode!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="3" (
    cls
    color A
    echo ╔═════════════════════╗
    echo ║ Importing DX 12.    ║
    echo ╚═════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\DX 12\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import DX 12!"
        echo %Red%Failed to import DX 12!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported DX 12!"
        echo %Green%Successfully imported DX 12!
        timeout 3 > nul
        goto :FN_Command_Line
    )
)
if "%fnoption%"=="4" (
    cls
    color A
    echo ╔═════════════════════╗
    echo ║ Importing DX 11.    ║
    echo ╚═════════════════════╝
    copy /Y "C:\Fortnite Optimizer Tools\DX 11\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Failed to import DX 11!"
        echo %Red%Failed to import DX 11!
        timeout 3 > nul
        goto :FN_Import_Failed
    ) else (
        call :LogOK "Successfully imported DX 11!"
        echo %Green%Successfully imported DX 11!
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
color C
chcp 65001 >nul 2>&1
echo ╔═════════════════════════════════════════════════════╗
echo ║ Optimized Fortnite Game Config Failed to Import.    ║
echo ╚═════════════════════════════════════════════════════╝
echo • Fortnite Optimizer Tools may be empty!
echo.
echo %White%[Choose an option]
echo %Green%1. Retry Import
echo %DarkYellow%2. Continue Anyway
echo %Red%3. Back to Main Menu
set /p fnoption="%White%Enter option number: "
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
color 9
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
color B
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
echo %ESC%[0m
color 0C
echo.
echo ======================================================
echo           BARDHZZY Tweaks - Revert / Undo Mode
echo ======================================================
echo.
echo [!] WARNING: This will forcefully overwrite your current
echo     registry with the backup created via Option 15.
echo.
echo [!] NOTE: If you used the 'Clean Up' tool to remove Windows Apps,
echo     those specific apps will NOT be reinstalled by this process.
echo     Use Windows System Restore (Option 11) for a full app rollback.
echo.
choice /c YN /n /m "Do you want to revert all registry tweaks to default? (Y/N): "
if %errorlevel% equ 2 goto main

echo.
set "BACKUP_DIR=%ProgramData%\BARDHZZY\Backup"
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

call :TIRegLog import "%BACKUP_DIR%\HKLM_SYSTEM.reg"
if errorlevel 1 (
    call :LogErr "Import HKLM_SYSTEM failed."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKLM_SYSTEM"
)

call :TIRegLog import "%BACKUP_DIR%\HKLM_SOFTWARE.reg"
if errorlevel 1 (
    call :LogErr "Import HKLM_SOFTWARE failed."
    set "REVERT_OK=0"
) else (
    call :LogOK "Import HKLM_SOFTWARE"
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

call :LogOK "Registry Successfully Reverted to Original State!"
echo.
echo ======================================================
echo [OK] Registry Successfully Reverted to Original State!
echo ======================================================
echo [!] A System Restart is HIGHLY recommended to flush all drivers.
echo.
pause
goto main

:restartpc
call :LogSection "Restart PC"
cls
echo.
echo ===========================================
echo   Restarting in 5 seconds...
echo   Press [N] to Cancel.
echo ===========================================
echo.

choice /c YN /t 5 /d Y /n /m "Restarting in 5 seconds... Press [N] to cancel: "

if %errorlevel% equ 1 (
    call :LogInfo "User confirmed. Restarting PC now..."
    echo.
    echo Restarting now...
    shutdown /r /t 0
) else (
    call :LogWarn "Restart cancelled by user. Returning to menu..."
    echo.
    echo Restart cancelled! Returning to menu...
    timeout 2 >nul
    goto main
)

:: =====================================================================
:: BARDHZZY PROFESSIONAL LOGGING SYSTEM v14.2
:: =====================================================================

:LogInit
set "SCRIPT_VERSION=v3.0.0"
set "SCRIPT_BUILD=08-08-2026"
set "LOG_ROOT=%ProgramData%\BARDHZZY\Logs"
set "LOG_ENABLED=0"
set "LOG_SECTION=SYSTEM"

for /f "tokens=4-5 delims=[]. " %%i in ('ver') do set "LOG_OS_VER=%%i.%%j"

for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'" 2^>nul') do set "LOG_STAMP=%%t"
if not defined LOG_STAMP set "LOG_STAMP=00000000_000000"

mkdir "%LOG_ROOT%" >nul 2>&1
if exist "%LOG_ROOT%" goto :LogInit_Success

set "LOG_ROOT=%TEMP%\BARDHZZY_Logs"
mkdir "%LOG_ROOT%" >nul 2>&1
if exist "%LOG_ROOT%" goto :LogInit_Success

set "LOG_ROOT=%CD%\BARDHZZY_Logs"
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
>>"%LOG_FILE%" echo   BARDHZZY TWEAKS - PROFESSIONAL EXECUTION LOG
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
echo %ESC%[37m[INFO]%ESC%[0m %MSG%
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
echo %ESC%[32m[  OK]%ESC%[0m %MSG%
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
echo %ESC%[31m[FAIL]%ESC%[0m %MSG%
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
echo %ESC%[33m[WARN]%ESC%[0m %MSG%
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
echo %ESC%[90m[SKIP]%ESC%[0m %MSG%
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
setlocal DisableDelayedExpansion
reg %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%*"
if not "%BARDHZZ_ERR%"=="0" goto RegLog_Fail
call :LogOK
endlocal
goto :eof
:RegLog_Fail
set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
call :LogErr
endlocal
goto :eof

:TIRegLog
setlocal DisableDelayedExpansion
set "BARDHZZ_CMD=reg %*"
if defined TI set "BARDHZZ_CMD=%TI% reg %*"
if defined TI goto TIRegLog_Execute
reg %* >nul 2>&1
goto TIRegLog_Result
:TIRegLog_Execute
%BARDHZZ_CMD% >nul 2>&1
:TIRegLog_Result
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%*"
if not "%BARDHZZ_ERR%"=="0" goto TIRegLog_Fail
call :LogOK
endlocal
goto :eof
:TIRegLog_Fail
set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
call :LogErr
endlocal
goto :eof

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

:TIDisableServiceInstances
setlocal DisableDelayedExpansion
set "TIS_PREFIX=%~1"
if not defined TIS_PREFIX goto TISInstances_Done
set "TIS_FOUND=0"
for /f "tokens=2" %%S in ('sc query type^= service state^= all ^| findstr /I /C:"SERVICE_NAME: %TIS_PREFIX%_"') do call :TIDisableServiceInstance "%%S"
if not "%TIS_FOUND%"=="0" goto TISInstances_Done
set "LOG_MSG=%TIS_PREFIX%_ service instance not present (skipped)"
call :LogSkip
:TISInstances_Done
endlocal
goto :eof

:TIDisableServiceInstance
set "TIS_FOUND=1"
call :TIScLog config "%~1" start= disabled
goto :eof

:TIScLog
setlocal DisableDelayedExpansion
set "TIS_ACTION=%~1"
set "TIS_SERVICE=%~2"
if not defined TIS_ACTION goto TIScLog_BadArgs
if not defined TIS_SERVICE goto TIScLog_BadArgs

sc query "%TIS_SERVICE%" >nul 2>&1
set "TIS_QUERY_ERR=%errorlevel%"
if "%TIS_QUERY_ERR%"=="1060" goto TIScLog_Skip
if not "%TIS_QUERY_ERR%"=="0" goto TIScLog_QueryFail

set "LOG_MSG=%*"
if not defined TI goto TIScLog_NoTI
set "BARDHZZ_CMD=%TI% sc %*"
%BARDHZZ_CMD% >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%*"
if not "%BARDHZZ_ERR%"=="0" goto TIScLog_Fail

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
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%* (Admin Fallback)"
if not "%BARDHZZ_ERR%"=="0" goto TIScLog_Fail

:: If it was a config command, verify it
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

set "LOG_MSG=%* (Admin Fallback verification failed: expected %TIS_EXPECT_CODE%, actual %TIS_ACTUAL_CODE%)"
call :LogErr
endlocal
goto :eof

:TIScLog_OK
call :LogOK
endlocal
goto :eof

:TIScLog_Fail
set "LOG_MSG=%* (err=%BARDHZZ_ERR%)"
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
setlocal DisableDelayedExpansion
schtasks %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set "LOG_MSG=%*"
if "%BARDHZZ_ERR%"=="0" goto SchLog_OK
set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
call :LogErr
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
echo ============================================================
echo                EXECUTION SUMMARY
echo ============================================================
echo( Total Operations : %LOG_TOTAL%
echo( Successful       : %LOG_OK%
echo( Failed           : %LOG_FAIL%
echo( Warnings         : %LOG_WARN%
echo( Skipped          : %LOG_SKIP%
echo ============================================================
echo( Log File: %LOG_FILE%
echo ============================================================
echo(
endlocal
goto :eof

:LogSummary_NoFile
echo [!] No log file found.
timeout /t 2 /nobreak >nul
endlocal
goto :eof

:LogView
if not exist "%LOG_FILE%" goto LogView_NoFile
start "" notepad "%LOG_FILE%"
goto :eof

:LogView_NoFile
echo [!] No log file found.
timeout /t 2 /nobreak >nul
goto :eof

:LogViewErrors
if not exist "%LOG_ERR%" goto LogViewErrors_NoFile
start "" notepad "%LOG_ERR%"
goto :eof

:LogViewErrors_NoFile
echo [!] No error log file found.
timeout /t 2 /nobreak >nul
goto :eof

:: =====================================================================
:: END OF LOGGING SYSTEM
:: =====================================================================