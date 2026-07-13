@ECHO off
setlocal

:: ULTIMATE FAILSAFE: Fix broken PCs that are missing System32/PowerShell in their PATH variable
set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0;%PATH%"

:: Universal PowerShell-based Device Disabler
set "dmv=powershell -NoProfile -Command Disable-PnpDevice -InstanceId"

:: --- STEP 2: ASK FOR ADMIN RIGHTS ---
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    title BARDHZZY Tweaks - Requesting Admin
    MODE 75,7
    color 09
    echo.
    echo          BARDHZZY Tweaks - Requesting Admin
    echo.

    :: Safely pass the path and arguments via environment variables
    set "BARDHZZ_PATH=%~f0"
    set "BARDHZZ_ARGS=%*"

    :: Create the temporary PowerShell script
    set "psScript=%TEMP%\bardhzz_uac.ps1"
    
    > "%psScript%" (
        echo $host.UI.RawUI.WindowTitle='BARDHZZY Tweaks - UAC'
        echo Write-Host ' [!] Administrator privileges required. ' -ForegroundColor White -BackgroundColor DarkRed
        echo Write-Host ' [!] Please click YES on the upcoming UAC prompt... ' -ForegroundColor White -BackgroundColor DarkRed
        echo Start-Sleep -Seconds 2
        echo try {
        echo     if ^(-not [string]::IsNullOrWhiteSpace^(^$env:BARDHZZ_ARGS^)^) {
        echo         Start-Process -FilePath $env:BARDHZZ_PATH -ArgumentList $env:BARDHZZ_ARGS -Verb RunAs -ErrorAction Stop
        echo     } else {
        echo         Start-Process -FilePath $env:BARDHZZ_PATH -Verb RunAs -ErrorAction Stop
        echo     }
        echo } catch {
        echo     Write-Host ' [X] UAC Prompt Declined or failed. Exiting...' -ForegroundColor Red
        echo     Start-Sleep -Seconds 3
        echo }
    )

    :: Execute the temporary script
    powershell -NoProfile -ExecutionPolicy Bypass -File "%psScript%"
    
    :: Clean up
    del /q "%psScript%" >nul 2>&1
    
    exit /b
)

:: --- STEP 3: RUN YOUR TWEAKS AS ADMIN ---
pushd "%~dp0"
title BARDHZZY Tweaks (Admin)
chcp 65001 >nul
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

echo [OK] Running as Administrator! Starting Tweaks...

:: Bulletproof ANSI Escape Character Setup
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
:: =====================================================================
:: [!] NSUDO INTEGRATION - BULLETPROOF TRUSTED INSTALLER ENGINE
:: =====================================================================
set "NSUDO_DIR=%ProgramData%\NSudo"
set "NSUDO_EXE=%NSUDO_DIR%\NSudoLC.exe"

if not exist "%NSUDO_EXE%" (
    echo [+] Initializing NSudo Framework...
    mkdir "%NSUDO_DIR%" >nul 2>&1
    
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri 'https://github.com/M2Team/NSudo/releases/download/8.2/NSudo_8.2_All_Components.zip' -OutFile $env:TEMP\NSudo.zip -UseBasicParsing; Expand-Archive -Path $env:TEMP\NSudo.zip -DestinationPath $env:TEMP\NSudoExtract -Force; $arch='x64'; if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { $arch='ARM64' } elseif ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') { $arch='Win32' }; $exe = Get-ChildItem -Path $env:TEMP\NSudoExtract -Recurse -Filter 'NSudoLC.exe' | Where-Object { $_.FullName -like ('*\' + $arch + '\*') } | Select-Object -First 1; if ($exe) { Copy-Item $exe.FullName $env:ProgramData\NSudo\NSudoLC.exe -Force; 'NSUDO_OK' } else { 'NSUDO_FAIL' } } catch { 'NSUDO_FAIL' }" > "%TEMP%\nsudo_status.txt"

    
    findstr "NSUDO_OK" "%TEMP%\nsudo_status.txt" >nul 2>&1
    del /q "%TEMP%\nsudo_status.txt" >nul 2>&1
    rd /s /q "%TEMP%\NSudoExtract" >nul 2>&1
    del /q "%TEMP%\NSudo.zip" >nul 2>&1
)

if exist "%NSUDO_EXE%" (
    set "TI=%NSUDO_EXE% -U:T -P:E -ShowWindowMode:Hide -Wait"
    echo [OK] NSudo Engine initialized. Deep system tweaks will be bulletproof.
    timeout /t 1 /nobreak >nul
) else (
    set "TI="
    echo [!] NSudo setup failed.
    echo [!] REASON: Network block, missing Admin rights, or aggressive Antivirus.
    echo [!] FIX: Ensure you are connected to the internet and running as Administrator.
    timeout /t 4 /nobreak >nul
)
:: =====================================================================

title BARDHZZY Tweaks
MODE 150,40
color 09
cls

echo.
echo      Welcome %USERNAME%, To BARDHZZY Tweaks!
echo.

goto license

:license
cls
MODE 60,12
echo.
echo ======================================================
echo            BARDHZZY Tweaks - License Required
echo ======================================================
echo.
set "user_key="
set /p "user_key=Enter your License Key: "

:: =====================================================================
:: [!] THE TRAP FIXER (Strips accidental quotes and spaces)
:: =====================================================================
if defined user_key set "user_key=%user_key:"=%"
if defined user_key set "user_key=%user_key: =%"

:: Validation List (Sanitized of all hidden browser spaces)
for %%k in (
    "1B99-QBRX-5YP7-YB07" "WITN-7N8Z-R8Q1-FRXX" "U3IG-J0E7-LWRO-9X27" "B21U-EY2U-C3J6-9ZTO"
    "0DC0-JVR3-QNJV-XCLK" "4Z29-1O7A-Z4XA-45QG" "BIS7-L7C3-JJNR-2JWY" "PKVJ-503R-ELHE-42GE"
    "8PAJ-MDNL-K47J-RS1F" "VVEL-QC56-GQV4-YBG8" "6ZQ2-LEF7-GOGA-OAGG" "N63C-FTQG-ES2K-M2GA"
    "Y9UD-FYP8-P0EE-VYII" "0P27-25QX-PVAR-ULPH" "VEDT-4YW6-3AI5-BXDX" "3470-S4JZ-PGWI-4ZF6"
    "WXF4-M5C7-G6KK-QF7X" "ASMV-5LJC-KNH4-VL85" "2AVO-SF1Y-Y624-ZEQS" "PJXL-AWWQ-PUWQ-MBYO"
    "AXTP-LPIU-IG6S-DYO9" "AOAJ-S6CQ-TX55-71E3" "SQXO-F1R8-0IXO-BHLW" "S3YC-E3SP-CVZN-484P"
    "62D4-MK2A-XALA-GFN5" "H2D7-K5N1-Q8X0-V3J9" "P4M6-L9Z2-B0W7-G1Y3" "QZ91-K2M3-L4P5-J6N7"
    "W8H9-V0X1-C2B3-N4M5" "A6S7-D8F9-G0H1-J2K3" "L4K5-J6H7-G8F9-D0S1" "Z2X3-C4V5-B6N7-M8Q9"
    "R1T2-Y3U4-I5O6-P7A8" "S9D0-F1G2-H3J4-K5L6" "M7N8-B9V0-C1X2-Z3A4" "Q5W6-E7R8-T9Y0-U1I2"
    "O3P4-A5S6-D7F8-G9H0" "J1K2-L3M4-N5B6-V7C8" "X9Z0-Q1W2-E3R4-T5Y6" "U7I8-O9P0-A1S2-D3F4"
    "G5H6-J7K8-L9M0-N1B2" "V3C4-X5Z6-Q7W8-E9R0" "T1Y2-U3I4-O5P6-A7S8" "D9F0-G1H2-J3K4-L5M6"
    "N7B8-V9C0-X1Z2-Q3W4" "E5R6-T7Y8-U9I0-O1P2" "A3S4-D5F6-G7H8-J9K0" "L1M2-N3B4-V5C6-X7Z8"
    "Q9W0-E1R2-T3Y4-U5I6" "O7P8-A9S0-D1F2-G3H4" "bardhzzY7" "akuma123"
) do (
    if /I "%user_key%"=="%%~k" goto valid
)

:invalid
echo.
echo [ERROR] Invalid License Key! Access Denied.
pause
exit /b

:valid
echo.
echo [OK] License Verified! Welcome.
timeout 2 >nul
goto main

:main
title bardhzzY Tweaks

MODE 150,40

echo %ESC%[0m
cls
color 09
echo.
echo        ██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗
echo        ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝
echo        ██████╔╝███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ 
echo        ██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  
echo        ██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   
echo        ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
echo.

set "build=0"
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" 2^>nul ^| findstr "REG_SZ"') do set "build=%%A"

if %build% GEQ 22000 (
    set "os_ver=Win11"
) else (
    set "os_ver=Win10"
)

:: =====================================================================
:: [!] PROFESSIONAL LOGGING SYSTEM - INITIALIZE
:: =====================================================================
if not defined LOG_INITIALIZED call :LogInit
:: =====================================================================
echo.                                         
echo.
echo.                %ESC%[34m[%ESC%[37m 1 %ESC%[34m]%ESC%[37m Windows Tweaks       %ESC%[34m^|       [%ESC%[37m 2 %ESC%[34m] %ESC%[37m GPU Tweaks       %ESC%[34m^|       [%ESC%[37m 3 %ESC%[34m] %ESC%[37m CPU Tweaks%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                %ESC%[34m[%ESC%[37m 4 %ESC%[34m]%ESC%[37m RAM Tweaks           %ESC%[34m^|       [%ESC%[37m 5 %ESC%[34m] %ESC%[37m Clean Up         %ESC%[34m^|       [%ESC%[37m 6 %ESC%[34m] %ESC%[37m Network Tweaks%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                %ESC%[34m[%ESC%[37m 7 %ESC%[34m]%ESC%[37m Storage Tweaks       %ESC%[34m^|       [%ESC%[37m 8 %ESC%[34m] %ESC%[37m Input Lag Tweaks %ESC%[34m^|       [%ESC%[37m 9 %ESC%[34m] %ESC%[37m KBM Tweaks%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo. 			   [%ESC%[37m 10 %ESC%[34m] %ESC%[37m Power Tweaks%ESC%[0m        %ESC%[34m^|       [%ESC%[37m 11 %ESC%[34m] %ESC%[37m Restore Point%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                %ESC%[34m[%ESC%[37m 12 %ESC%[34m]%ESC%[37m Fortnite Optimizer  %ESC%[34m^|       [%ESC%[37m 13 %ESC%[34m] %ESC%[37m Timer Resolution%ESC%[0m       %ESC%[34m[%ESC%[37m 14 %ESC%[34m]%ESC%[37m Restart PC%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                                %ESC%[34m[%ESC%[37m 15 %ESC%[34m]%ESC%[37m Revert Tweaks (Undo)     %ESC%[34m[%ESC%[37m 16 %ESC%[34m]%ESC%[37m Create Registry Backup%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                                %ESC%[34m[%ESC%[37m 17 %ESC%[34m]%ESC%[37m View Log File             %ESC%[34m[%ESC%[37m 18 %ESC%[34m]%ESC%[37m View Error Log%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                                %ESC%[34m[%ESC%[37m 19 %ESC%[34m]%ESC%[37m Generate Summary          %ESC%[34m[%ESC%[37m 20 %ESC%[34m]%ESC%[37m Quit (with Summary)%ESC%[0m
echo.                %ESC%[34m^______________________________________________________________________________________
echo.
echo.                                    %ESC%[37mIf You Need %ESC%[34mSUPPORT%ESC%[37m Open A %ESC%[34mTICKET%ESC%[37m In Our %ESC%[34mDISCORD%ESC%[37m.%ESC%[0m
echo.                                    %ESC%[34m^_________________________________________________
echo.
echo.                                                    %ESC%[34m[%ESC%[37m D %ESC%[34m]%ESC%[37m Discord%ESC%[0m
echo.                                                    %ESC%[34m^______________
echo.
set "input="
set /p input=
if defined input set "input=%input:"=%"
if defined input set "input=%input:&=%"
if defined input set "input=%input:|=%"
if defined input set "input=%input:^=%"
if /i "%input%"=="1" goto win
if /i "%input%"=="2" goto gpu
if /i "%input%"=="3" goto cpu
if /i "%input%"=="4" goto ram
if /i "%input%"=="5" goto clean
if /i "%input%"=="6" goto netw
if /i "%input%"=="7" goto stor
if /i "%input%"=="8" goto input
if /i "%input%"=="9" goto kbm
if /i "%input%"=="10" goto pwr
if /i "%input%"=="11" goto srp
if /i "%input%"=="12" goto fortnite
if /i "%input%"=="13" goto timerres
if /i "%input%"=="14" goto restartpc
if /i "%input%"=="15" goto revert
if /i "%input%"=="16" goto backup
if /i "%input%"=="17" (
    call :LogView
    goto main
)
if /i "%input%"=="18" (
    call :LogViewErrors
    goto main
)
if /i "%input%"=="19" (
    call :LogSummary
    pause
    goto main
)
if /i "%input%"=="20" (
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
call :LogSection "Windows Tweaks"
call :LogInfo "Checking for Winget..."
echo You selected Windows Tweaks!
echo [+] Checking for Winget (App Installer)...

:: Check using the absolute path, as CMD doesn't refresh PATH mid-script
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe" goto WINGET_OK

echo [!] Winget not found. Downloading prerequisites...
:: We use a single PowerShell block so we can catch exact errors and report them back to the Batch console.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference='SilentlyContinue';" ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
    "try {" ^
    "  Invoke-WebRequest -Uri 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx' -OutFile \"$env:TEMP\vclibs.appx\" -UseBasicParsing;" ^
    "  Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.3/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile \"$env:TEMP\xaml.appx\" -UseBasicParsing;" ^
    "  Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile \"$env:TEMP\winget.msixbundle\" -UseBasicParsing;" ^
    "  Add-AppxPackage -Path \"$env:TEMP\vclibs.appx\" -ForceApplicationShutdown -ErrorAction Stop;" ^
    "  Add-AppxPackage -Path \"$env:TEMP\xaml.appx\" -ForceApplicationShutdown -ErrorAction Stop;" ^
    "  Add-AppxPackage -Path \"$env:TEMP\winget.msixbundle\" -ForceApplicationShutdown -ErrorAction Stop;" ^
    "  Remove-Item \"$env:TEMP\vclibs.appx\", \"$env:TEMP\xaml.appx\", \"$env:TEMP\winget.msixbundle\" -Force -ErrorAction SilentlyContinue;" ^
    "} catch {" ^
    "  Write-Host \"[ERROR] PowerShell failed: $_\" -ForegroundColor Red;" ^
    "  exit 1" ^
" >nul 2>&1

:: If PowerShell threw an error (exit 1), go to fail
if %errorlevel% neq 0 goto WINGET_FAIL

:: Wait a few seconds for Windows to register the AppX package
timeout /t 5 /nobreak >nul

:: Check the absolute path again
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe" goto WINGET_OK

:WINGET_FAIL
echo [X] Winget installation failed. 
echo     This usually happens if you are running as Administrator, or if the Microsoft Store is updating in the background.
echo     Please install it manually from the Microsoft Store (Search for "App Installer").
echo     Continuing with tweaks...
timeout /t 5 >nul
goto WINGET_DONE

:WINGET_OK
echo [OK] Winget is installed and ready.

:WINGET_DONE
call :LogInfo "Disabling unnecessary services..."
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
set /p "search_choice=Apply this optimization? (Y/N): "
if /i not "%search_choice%"=="Y" goto skip_search

call :LogInfo "Disabling Windows Search Service..."
%TI% sc config WSearch start= disabled >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "sc config WSearch") else (call :LogErr "sc config WSearch")
%TI% sc stop WSearch >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "sc stop WSearch") else (call :LogErr "sc stop WSearch")

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
if %errorlevel% equ 0 (call :LogOK "Install Open-Shell") else (call :LogErr "Install Open-Shell")

call :LogInfo "Applying core lightweight configuration..."
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "WinKey" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "LeftClick" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_DWORD /d 2 /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Metro" /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "Dark" /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowRecent" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowFrequent" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowUserPic" /t REG_DWORD /d 0 /f

call :LogInfo "Restarting desktop shell..."
powershell -NoProfile -Command "Stop-Process -Name explorer -Force" >nul 2>&1
timeout 2 >nul
start explorer.exe
:: Wait up to 10 seconds for explorer to come back, then launch Open-Shell
powershell -NoProfile -Command "for ($i=0; $i -lt 10; $i++) { if (Get-Process -Name explorer -ErrorAction SilentlyContinue) { break }; Start-Sleep -Seconds 1 }" >nul 2>&1
if exist "C:\Program Files\Open-Shell\StartMenu.exe" (
    start "" "C:\Program Files\Open-Shell\StartMenu.exe" >nul 2>&1
)

:skip_search
call :LogInfo "Removing New Media Player app..."
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove ZuneVideo") else (call :LogErr "Remove ZuneVideo")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove ZuneMusic") else (call :LogErr "Remove ZuneMusic")

call :LogInfo "Enabling Legacy Media Player feature..."
dism /online /enable-feature /featurename:WindowsMediaPlayer /norestart >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Enable WMP feature") else (call :LogErr "Enable WMP feature")

call :LogInfo "Optimizing WMP Network Service..."
%TI% sc config WMPNetworkSvc start= demand >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "sc config WMPNetworkSvc") else (call :LogErr "sc config WMPNetworkSvc")

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
    
    :: Cleanup
    del /q "%temp%\dxwebsetup.exe" >nul 2>&1
    
    :: Flawless exit code evaluation
    if "!DX_EXIT_CODE!"=="0" (
        call :LogOK "DirectX installed successfully."
    ) else (
        call :LogWarn "DirectX installer returned non-zero exit code (!DX_EXIT_CODE!). May already be up to date."
    )
) else (
    call :LogErr "Failed to download DirectX. Check internet connection."
    if exist "%temp%\dxwebsetup.exe" del /q "%temp%\dxwebsetup.exe" >nul 2>&1
)

echo.
echo ======================================================
echo      Removing Edge and OneDrive
echo ======================================================
echo.

call :LogInfo "Starting Microsoft bloatware removal process..."

:: --- 1. Remove Microsoft OneDrive ---
call :LogInfo "Forcefully removing Microsoft OneDrive..."
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    if %errorlevel% equ 0 (call :LogOK "OneDrive uninstalled via setup") else (call :LogErr "OneDrive uninstall failed")
)
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.OneDrive* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "OneDrive Appx removed") else (call :LogWarn "OneDrive Appx removal skipped")

:: Clean up leftover OneDrive folders
rd /s /q "%LOCALAPPDATA%\Microsoft\OneDrive" >nul 2>&1
rd /s /q "%PROGRAMDATA%\Microsoft OneDrive" >nul 2>&1
call :LogOK "OneDrive leftover directories cleaned"

:: Remove OneDrive from Windows Explorer side panel (Requires TrustedInstaller)
call :TIRegLog delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
call :TIRegLog delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f

call :LogSection "Microsoft Edge Removal"
call :LogInfo "Stopping Edge processes (preserving WebView2)..."
taskkill /F /IM msedge.exe /T >nul 2>&1
taskkill /F /IM EdgeUpdate.exe /T >nul 2>&1

call :LogInfo "Searching for Edge installation versions..."
set "edge_found=0"
setlocal EnableDelayedExpansion

:: Check standard Program Files directories for the setup.exe
for %%P in ("C:\Program Files (x86)\Microsoft\Edge\Application" "C:\Program Files\Microsoft\Edge\Application") do (
    if exist "%%~P" (
        for /f "delims=" %%V in ('dir /b /ad "%%~P" 2^>nul ^| findstr /r "^[0-9].*"') do (
            if exist "%%~P\%%V\Installer\setup.exe" (
                call :LogInfo "Found Edge version: %%V. Executing silent uninstall..."
                powershell -NoProfile -Command "Start-Process -FilePath '%%~P\%%V\Installer\setup.exe' -ArgumentList '--uninstall --system-level --verbose-logging --force-uninstall' -Wait -NoNewWindow" >nul 2>&1
                if !errorlevel! equ 0 (call :LogOK "Edge setup.exe uninstall complete") else (call :LogWarn "Edge setup.exe returned non-zero exit code")
                set "edge_found=1"
            )
        )
    )
)

if "!edge_found!"=="0" call :LogWarn "Standard Edge setup.exe not found. Proceeding with Appx cleanup..."

call :LogInfo "Removing Edge Appx Packages (Strictly preserving WebView2)..."
:: FIXED: Removed the wildcard. Now it strictly targets the browser package, leaving WebView2 alone.
powershell -NoProfile -Command "Get-AppxPackage Microsoft.MicrosoftEdge -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1

call :LogInfo "Removing Provisioned Packages (prevents auto-reinstall on update)..."
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq 'Microsoft.MicrosoftEdge' } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue }" >nul 2>&1

call :LogInfo "Cleaning up leftover Edge directories (Preserving EdgeWebView)..."
:: FIXED: Added safety checks to ONLY delete Edge, NOT EdgeWebView.
if exist "C:\Program Files (x86)\Microsoft\Edge\" %TI% cmd.exe /c "rd /s /q \"C:\Program Files (x86)\Microsoft\Edge\"" >nul 2>&1
if exist "C:\Program Files\Microsoft\Edge\" %TI% cmd.exe /c "rd /s /q \"C:\Program Files\Microsoft\Edge\"" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge" >nul 2>&1

:: ==============================================================================
:: WARNING: DO NOT disable edgeupdate services or delete EdgeUpdate registry keys.
:: WebView2 Runtime relies on them to function. Snipping Tool needs WebView2.
:: ==============================================================================

endlocal

call :LogOK "Microsoft Edge, OneDrive, News/Widgets successfully removed and disabled!"

call :LogInfo "Applying registry optimizations..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTips" /t REG_DWORD /d 0 /f
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f
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
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d 4 /f
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

call :LogInfo "Disabling Telemetry..."
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventoryCollection" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d 1 /f

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
call :RegLog add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Taskband" /v "TaskbandDa" /t REG_DWORD /d 0 /f
call :RegLog delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "com.squirrel.Teams.Teams" /f

call :LogInfo "Disabling Windows Defender..."
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
call :ScLog config WinDefend start= disabled
call :ScLog stop WinDefend
call :ScLog config WdNisSvc start= disabled
call :ScLog stop WdNisSvc
call :ScLog config wscsvc start= disabled
call :ScLog stop wscsvc
call :ScLog config SecurityHealthService start= disabled
call :ScLog stop SecurityHealthService
call :TIRegLog delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
call :LogInfo "Disabling SMBv1 (security)..."
powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Disable SMB1Protocol") else (call :LogWarn "Disable SMB1Protocol")
call :ScLog config lanmanworkstation depend= "Bowser/Srv2/SrvNet"
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
echo All tweaks applied successfully!
timeout /t 1 /nobreak > NUL
pause
goto main

:gpu
cls
echo.
echo        ██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗
echo        ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝
echo        ██████╔╝███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ 
echo        ██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  
echo        ██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   
echo        ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
echo.
echo.                                           %ESC%[34m[%ESC%[37m 1 %ESC%[34m]%ESC%[37m AMD       %ESC%[34m^|       [%ESC%[37m 2 %ESC%[34m] %ESC%[37m Nvidia
echo.                                           %ESC%[34m^_____________________________________
echo.
echo.                                                        %ESC%[34m[%ESC%[37m 3 %ESC%[34m]%ESC%[37m EXIT%ESC%[0m
echo.
echo.
set "input="
set /p input=
if /i "%input%"=="1" goto amd
if /i "%input%"=="2" goto nvid
if /i "%input%"=="3" goto main
echo "%input%" isn't a right choice, try again!
goto gpu

:nvid
call :LogSection "Nvidia GPU Tweaks"
cls
echo ╔════════════════════════════════════════════════════════════════╗
echo ║           NVIDIA GPU ULTIMATE OPTIMIZATION SUITE               ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
call :LogInfo "Applying Driver & Profile Optimizations..."
cd /d "%~dp0"

call :LogInfo "Applying Driver & Profile Optimizations..."

:: 3. Secure Downloader: Retrieve the Inspector API if missing
if not exist "%~dp0nvidiaProfileInspector.exe" (
    call :LogInfo "Establishing secure connection to retrieve optimization tools..."
    
    :: Bypass setup prompts and enforce TLS 1.2 for flawless downloads on stripped OS versions
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest/download/nvidiaProfileInspector.zip' -OutFile '%~dp0NVPI_temp.zip' -UseBasicParsing" >nul 2>&1
    
    if exist "%~dp0NVPI_temp.zip" (
        call :LogOK "Download nvidiaProfileInspector"
        call :LogInfo "Unpacking performance binaries..."
        powershell -NoProfile -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -Path '%~dp0NVPI_temp.zip' -DestinationPath '%~dp0' -Force" >nul 2>&1
        if %errorlevel% equ 0 (call :LogOK "Extract nvidiaProfileInspector") else (call :LogErr "Extract nvidiaProfileInspector")
        del "%~dp0NVPI_temp.zip" /f /q >nul 2>&1
    ) else (
        call :LogErr "Download nvidiaProfileInspector (Network blocked)"
    )
)

:: Halt if network blocked the download
if not exist "%~dp0nvidiaProfileInspector.exe" (
    call :LogErr "nvidiaProfileInspector.exe not found. Cannot apply profile."
    timeout /t 4 >nul
    goto :end_nvid
)

call :LogInfo "Generating Global Low-Latency Driver Profile..."
(
echo ^<?xml version="1.0" encoding="utf-16"?^>
echo ^<ArrayOfProfile^>
echo   ^<Profile^>
echo     ^<ProfileName^>Base Profile^</ProfileName^>
echo     ^<Executeables /^>
echo     ^<Settings^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Power management mode^</SettingNameInfo^>
echo         ^<SettingID^>274197396^</SettingID^>
echo         ^<SettingValue^>1^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Texture filtering - Quality^</SettingNameInfo^>
echo         ^<SettingID^>13510289^</SettingID^>
echo         ^<SettingValue^>3^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Low Latency Mode^</SettingNameInfo^>
echo         ^<SettingID^>1343640812^</SettingID^>
echo         ^<SettingValue^>2^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Shader Cache Size^</SettingNameInfo^>
echo         ^<SettingID^>547544337^</SettingID^>
echo         ^<SettingValue^>10^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Threaded optimization^</SettingNameInfo^>
echo         ^<SettingID^>549528094^</SettingID^>
echo         ^<SettingValue^>1^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Ansel flags for enabled applications^</SettingNameInfo^>
echo         ^<SettingID^>276062518^</SettingID^>
echo         ^<SettingValue^>0^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>CUDA - Force P2 State^</SettingNameInfo^>
echo         ^<SettingID^>50166120^</SettingID^>
echo         ^<SettingValue^>0^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Vertical Sync^</SettingNameInfo^>
echo         ^<SettingID^>8392392^</SettingID^>
echo         ^<SettingValue^>0^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Preferred Refresh Rate^</SettingNameInfo^>
echo         ^<SettingID^>12291721^</SettingID^>
echo         ^<SettingValue^>2^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Image Scaling^</SettingNameInfo^>
echo         ^<SettingID^>278206341^</SettingID^>
echo         ^<SettingValue^>0^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo       ^<ProfileSetting^>
echo         ^<SettingNameInfo^>Antialiasing - Gamma correction^</SettingNameInfo^>
echo         ^<SettingID^>17818516^</SettingID^>
echo         ^<SettingValue^>0^</SettingValue^>
echo         ^<ValueType^>Dword^</ValueType^>
echo       ^</ProfileSetting^>
echo     ^</Settings^>
echo   ^</Profile^>
echo ^</ArrayOfProfile^>
)>"%TEMP%\global_optimized.nip"

:: 5. Silent Kernel Injection
call :LogInfo "Injecting profile directly into NVIDIA Kernel..."
"%~dp0nvidiaProfileInspector.exe" -silentImport "%TEMP%\global_optimized.nip" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Driver Profile Applied!") else (call :LogErr "Driver Profile Injection Failed")

call :LogInfo "Executing clean-up protocol..."
if exist "%TEMP%\global_optimized.nip" del "%TEMP%\global_optimized.nip" /f /q >nul 2>&1
if exist "%~dp0nvidiaProfileInspector.exe" del "%~dp0nvidiaProfileInspector.exe" /f /q >nul 2>&1
if exist "%~dp0Reference.xml" del "%~dp0Reference.xml" /f /q >nul 2>&1
if exist "%~dp0CustomSettingNames_en-EN.xml" del "%~dp0CustomSettingNames_en-EN.xml" /f /q >nul 2>&1


:end_nvid

call :LogInfo "Disabling Nvidia Telemetry Tasks..."
call :SchLog /change /disable /tn "NvTmMon*" 
call :SchLog /change /disable /tn "NvTmRep*"
call :SchLog /change /disable /tn "NvDriverUpdateCheckDaily*"
call :SchLog /change /disable /tn "NVIDIA GeForce Experience SelfUpdate*"

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

call :LogInfo "Enabling MSI Mode for NVIDIA GPU..."
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_10DE" ^| findstr "HKEY"') do (
    reg query "%%a" /v "Service" 2>nul | findstr /i "nvlddmkm" >nul && (
        call :RegLog add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /t REG_DWORD /d 1 /f
        call :RegLog add "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d 3 /f
    )
)
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\PnP\Pci" /v "GetInterruptConnectionCount" /t REG_DWORD /d 0 /f
call :LogOK "NVIDIA GPU MSI Mode & High Priority Enabled!"

call :LogInfo "Applying DirectX Optimizations..."
setlocal EnableDelayedExpansion
set "F_PATH=HKCU\Software\Microsoft\DirectX\UserGpuPreferences"
set "F_NAME=DirectXUserGlobalSettings"
set "F_TWEAK=SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;"
for /f "tokens=2,*" %%A in ('reg query "%F_PATH%" /v "%F_NAME%" 2^>nul') do set "F_DATA=%%B"
if defined F_DATA (
    set "F_DATA=!F_DATA:VRROptimizeEnable=1;=!"
    set "F_DATA=!F_DATA:VRROptimizeEnable=0;=!"
    set "F_DATA=!F_DATA:SwapEffectUpgradeEnable=1;=!"
    set "F_DATA=!F_DATA:SwapEffectUpgradeEnable=0;=!"
    call :RegLog add "%F_PATH%" /v "%F_NAME%" /t REG_SZ /d "!F_DATA!%F_TWEAK%" /f
) else (
    call :RegLog add "%F_PATH%" /v "%F_NAME%" /t REG_SZ /d "%F_TWEAK%" /f
)
endlocal
call :RegLog add "HKCU\Software\Microsoft\DXGIExtensions" /v "ForceIndependentFlip" /t REG_DWORD /d 1 /f
call :LogInfo "Disabling Multiplane Overlay (MPO)..."
call :RegLog delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestType" /f >nul 2>&1
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableOverlays" /t REG_DWORD /d "1" /f

for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /f "00*" /k ^| findstr "000"') do (
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

call :ScLog config NvBackend start= disabled
call :ScLog stop NvBackend
call :ScLog config nvcontainer start= disabled
call :ScLog stop nvcontainer
call :ScLog config NVDisplay.ContainerLocalSystem start= demand

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
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /f "DriverDesc" ^| findstr "HKEY"') do (
    for /f "tokens=3" %%b in ('reg query "%%a" /v "DriverDesc" 2^>nul') do (
        echo %%b | findstr /i "AMD" >nul && (
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
            call :RegLog add "%%a" /v "KMD_DeLagEnabled" /t REG_DWORD /d 0 /f
            call :RegLog add "%%a" /v "DisablePreemption" /t REG_DWORD /d 1 /f
        )
    )
)

call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "LoadDebugRuntime" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Direct3D" /v "EnablePipelineCache" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestType" /t REG_DWORD /d 00000005 /f
call :ScLog config "AMD External Events Utility" start= disabled
call :ScLog stop "AMD External Events Utility"

call :LogInfo "Enabling Windowed Game Optimizations"
call :RegLog add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;" /f
call :LogOK "AMD Tweaks Applied Successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:cpu
call :LogSection "CPU Tweaks"
echo You selected CPU Tweaks!
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MSISupport" /t REG_DWORD /d 1 /f
call :RegLog add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_SZ /d "0" /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "LbrEnabled" /t REG_DWORD /d 0 /f
powercfg /setacvalueindex scheme_current sub_pciexpress aspm 0
if %errorlevel% equ 0 (call :LogOK "powercfg sub_pciexpress") else (call :LogErr "powercfg sub_pciexpress")

set "CPU_CORES=%NUMBER_OF_PROCESSORS%"
set /a "SYS_THREADS=CPU_CORES * 12"

call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "AdditionalCriticalWorkerThreads" /t REG_DWORD /d %SYS_THREADS% /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "AdditionalDelayedWorkerThreads" /t REG_DWORD /d %SYS_THREADS% /f

echo %PROCESSOR_IDENTIFIER% | findstr /i "AMD" >nul && (
    call :LogInfo "AMD CPU detected - Applying AMD-specific tweaks..."
    call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f
)
echo %PROCESSOR_IDENTIFIER% | findstr /i "Intel" >nul && (
    call :LogInfo "Intel CPU detected - Applying Intel-specific tweaks..."
)

call :LogInfo "Applying Device Priority tweaks..."
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_" ^| findstr "HKEY" ^| findstr /v "Parameters"') do (
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

call :LogInfo "Scanning for common games to apply High Priority..."
setlocal enabledelayedexpansion
set "games[0]=C:\Riot Games\VALORANT\live\VALORANT.exe"
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
echo Tweaks applied successfully!
timeout /t 1 /nobreak > NUL
pause
goto main
    
:ram
cls
echo.
echo.
echo        ██████╗  █████╗ ██████╗ ██████╗ ██╗  ██╗███████╗███████╗██╗   ██╗
echo        ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║  ██║╚══███╔╝╚══███╔╝╚██╗ ██╔╝
echo        ██████╔╝███████║██████╔╝██║  ██║███████║  ███╔╝   ███╔╝  ╚████╔╝ 
echo        ██╔══██╗██╔══██║██╔══██╗██║  ██║██╔══██║ ███╔╝   ███╔╝    ╚██╔╝  
echo        ██████╔╝██║  ██║██║  ██║██████╔╝██║  ██║███████╗███████╗   ██║   
echo        ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
echo.                                            
echo.
echo.                             %ESC%[34m[%ESC%[37m 1 %ESC%[34m]%ESC%[37m 2 GB       %ESC%[34m^|       [%ESC%[37m 2 %ESC%[34m] %ESC%[37m 3 GB       %ESC%[34m^|       [%ESC%[37m 3 %ESC%[34m] %ESC%[37m 4 GB%ESC%[0m
echo.                             %ESC%[34m^_______________________________________________________________
echo.
echo.                             %ESC%[34m[%ESC%[37m 4 %ESC%[34m]%ESC%[37m 6 GB       %ESC%[34m^|       [%ESC%[37m 5 %ESC%[34m] %ESC%[37m 8 GB       %ESC%[34m^|       [%ESC%[37m 6 %ESC%[34m] %ESC%[37m 16 GB%ESC%[0m
echo.                             %ESC%[34m^_______________________________________________________________
echo.
echo.                             %ESC%[34m[%ESC%[37m 7 %ESC%[34m]%ESC%[37m 24 GB      %ESC%[34m^|       [%ESC%[37m 8 %ESC%[34m] %ESC%[37m 32 GB      %ESC%[34m^|       [%ESC%[37m 9 %ESC%[34m] %ESC%[37m 64 GB%ESC%[0m
echo.                             %ESC%[34m^_______________________________________________________________
echo.
echo.                                                        %ESC%[34m[%ESC%[37m 10 %ESC%[34m]%ESC%[37m EXIT%ESC%[0m
echo.
echo.
echo.
echo.
echo.
set "input="
set /p input=
if defined input set "input=%input:"=%"
if defined input set "input=%input:&=%"
if defined input set "input=%input:|=%"
if defined input set "input=%input:^=%"
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
echo "%input%" isn't a right choice, try again!
goto main

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
powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>&1
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
powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>&1
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
powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>&1
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
powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>&1
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


:clean
call :LogSection "Clean Up"
echo You Selected Cleanup!
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
call :TIScLog config edgeupdate start= demand
call :TIScLog config edgeupdatem start= demand
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
call :TIScLog config CDPUserSvc start= disabled
call :TIScLog config DevQueryBroker start= disabled
call :TIScLog config DevicesFlowUserSvc start= disabled
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
call :TIScLog config OneSyncSvc start= disabled
call :TIScLog config lmhosts start= disabled
call :TIScLog config UserDataSvc start= disabled
call :TIScLog config Browser start= disabled
call :TIScLog config UnistoreSvc start= disabled
call :TIScLog config Wcmsvc start= disabled
call :TIScLog config FontCache start= disabled
call :TIScLog config W32Time start= disabled
call :TIScLog config tzautoupdate start= disabled
call :TIScLog config DsSvc start= disabled
call :TIScLog config DevicesFlowUserSvc_5f1ad start= disabled
call :TIScLog config diagsvc start= disabled
call :TIScLog config DialogBlockingService start= disabled
call :TIScLog config PimIndexMaintenanceSvc_5f1ad start= disabled
call :TIScLog config MessagingService_5f1ad start= disabled
call :TIScLog config AppVClient start= disabled
call :TIScLog config MsKeyboardFilter start= disabled
call :TIScLog config NetTcpPortSharing start= disabled
call :TIScLog config ClipSVC start= disabled
call :TIScLog config ssh-agent start= disabled
call :TIScLog config OneSyncSvc_5f1ad start= disabled
call :TIScLog config wercplsupport start= disabled
call :TIScLog config WpnUserService_5f1ad start= disabled
call :TIScLog config WinHttpAutoProxySvc start= disabled
call :TIScLog config DsmSvc start= disabled
call :TIScLog config AJRouter start= demand
call :TIScLog config ALG start= demand
call :TIScLog config AppIDSvc start= demand
call :TIScLog config BDESVC start= demand
call :TIScLog config CertPropSvc start= demand
call :TIScLog config EntAppSvc start= demand
call :TIScLog config LxpSvc start= demand
call :TIScLog config PimIndexMaintenanceSvc start= demand
call :TIScLog config RasAuto start= demand
call :TIScLog config RasMan start= demand
call :TIScLog config RemoteAccess start= demand
call :TIScLog config RmSvc start= demand
call :TIScLog config SNMPTRAP start= demand
call :TIScLog config UPnPHost start= demand
call :TIScLog config WebClient start= demand
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
call :TIScLog stop "BluetoothUserService"
call :TIRegLog add "HKLM\System\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d 4 /f
call :TIScLog stop "Spooler"
call :TIScLog config "Spooler" start= disabled
call :TIScLog stop "PrintWorkflowUserSvc"
call :TIRegLog add "HKLM\System\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIScLog stop "FrameServer"
call :TIScLog config "FrameServer" start= disabled
call :TIScLog stop "wisvc"
call :TIScLog config "wisvc" start= disabled
call :TIRegLog add "HKLM\System\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\System\CurrentControlSet\Services\MessagingService" /v "Start" /t REG_DWORD /d 4 /f
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
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "512000" /f
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
call :LogInfo "Safely removing Windows Widgets (Preserving Snipping Tool)..."
winget uninstall --silent --accept-source-agreements "Windows web experience Pack" >nul 2>&1
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
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d 4 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d 4 /f

call :LogInfo "Preparing Appx Removal (25H2 Safe)..."
:: 25H2 Fix: Ensure AppXSvc is running so PowerShell doesn't hang
sc config AppXSvc start= demand >nul 2>&1
sc start AppXSvc >nul 2>&1
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
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: Microsoft.WindowsStore") else (call :LogErr "Remove Appx: Microsoft.WindowsStore")
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
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *549981C3F5F10* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*549981C3F5F10*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: 549981C3F5F10") else (call :LogErr "Remove AppxProv: 549981C3F5F10")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *DevHome* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*DevHome*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: DevHome") else (call :LogErr "Remove AppxProv: DevHome")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *OutlookForWindows* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*OutlookForWindows*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: OutlookForWindows") else (call :LogErr "Remove AppxProv: OutlookForWindows")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *PowerAutomateDesktop* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*PowerAutomateDesktop*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: PowerAutomateDesktop") else (call :LogErr "Remove AppxProv: PowerAutomateDesktop")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Todos* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*Todos*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: Todos") else (call :LogErr "Remove AppxProv: Todos")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Whiteboard* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*Whiteboard*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: Whiteboard") else (call :LogErr "Remove AppxProv: Whiteboard")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *MixedReality.Portal* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*MixedReality.Portal*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: MixedReality.Portal") else (call :LogErr "Remove AppxProv: MixedReality.Portal")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *SpotifyMusic* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*SpotifyMusic*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: SpotifyMusic") else (call :LogErr "Remove AppxProv: SpotifyMusic")
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *DisneyMagicKingdoms* | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*DisneyMagicKingdoms*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove AppxProv: DisneyMagicKingdoms") else (call :LogErr "Remove AppxProv: DisneyMagicKingdoms")
winget uninstall --silent --accept-source-agreements "Windows web experience Pack" >nul 2>&1
call :RegLog add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f
if %errorlevel% equ 0 (call :LogOK "Winget uninstall: Web Exp Pack") else (call :LogErr "Winget uninstall: Web Exp Pack")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: GetHelp") else (call :LogErr "Remove Appx: GetHelp")
powershell -NoProfile -Command "Get-AppxPackage *Microsoft.WindowsTerminal* | Remove-AppxPackage" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Remove Appx: WindowsTerminal") else (call :LogErr "Remove Appx: WindowsTerminal")
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

call :LogInfo "Cleaning Temporary Files (25H2 Safe)..."
:: FIX: Safely delete temp contents WITHOUT deleting the temp folder itself or the log folder!
for /d %%D in ("%temp%\*") do if /i not "%%~nxD"=="BARDHZZY_Logs" rd /s /q "%%D" >nul 2>&1
del /q /f "%temp%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1

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

call :LogInfo "Running DISM Component Cleanup (25H2 Safe)..."
:: FIX: Removed /resetbase to prevent crashing, added /NoRestart
dism /online /cleanup-image /startcomponentcleanup /NoRestart >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "DISM Component Cleanup") else (call :LogWarn "DISM Component Cleanup (Skipped or failed)")

:: FIX: Removed cleanmgr /sagerun:1. It opens a GUI and hangs on stripped ISOs.

call :LogOK "Apps, Features and services removed successfully!"
timeout /t 1 /nobreak > NUL
pause
goto main

:netw
call :LogSection "Network Tweaks"
echo You choose Network Tweaks


:: =====================================================================
:: [!] ETHERNET ONLY MODE - HARDWARE WIFI DISABLE
:: =====================================================================
echo.
echo [+] Ethernet Only Optimization
set /p "wifi_kill=Disable Wi-Fi adapter at hardware level for less processes? (Y/N): "
if /i "%wifi_kill%"=="Y" (
    call :LogInfo "Disabling Wi-Fi Adapters at hardware level..."
    echo [+] Searching for Wi-Fi adapters and disabling them...
    
    :: This finds any active Network adapter with Wi-Fi/Wireless/WLAN in the name and disables it
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PnpDevice -Class Net | Where-Object { $_.FriendlyName -match 'Wi-Fi|Wireless|WLAN|802.11' -and $_.Status -eq 'OK' } | ForEach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false }"
    
    if %errorlevel% equ 0 (
        call :LogOK "Wi-Fi Hardware Disabled"
        echo [OK] Wi-Fi adapter disabled! You are now strictly on Ethernet.
        echo     (Note: To re-enable Wi-Fi later, go to Device Manager -> Network Adapters -> Right-Click your Wi-Fi adapter -> Enable)
    ) else (
        call :LogWarn "Wi-Fi disable failed or no adapter found"
        echo [!] Could not disable Wi-Fi. It might already be disabled or not detected.
    )
    timeout /t 2 /nobreak >nul
)

call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
%TI% sc stop WlanSvc >nul 2>&1

call :LogInfo "Enabling MSI/MSI-X for Ethernet adapters..."
setlocal enabledelayedexpansion
set "count=0"

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "IfType" 2^>nul ^| findstr /i "HKEY_LOCAL_MACHINE"') do (
    reg query "%%i" /v "IfType" 2>nul | findstr /i "0x6" >nul && (
        call :RegLog add "%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f
        set /a count+=1
    )
)
if %count%==0 (
    call :LogWarn "No physical Ethernet adapters found."
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
call :TIRegLog add "HKLM\SYSTEM\ControlSet001\Services\Ndu" /v "Start" /t REG_DWORD /d 4 /f

netsh advfirewall firewall set rule group="Network Discovery" new enable=no >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh advfirewall Network Discovery") else (call :LogErr "netsh advfirewall Network Discovery")
netsh int tcp set supplemental Template=Compat CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh bbr2 Compat") else (call :LogErr "netsh bbr2 Compat")
netsh int tcp set supplemental Template=Internet CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh bbr2 Internet") else (call :LogErr "netsh bbr2 Internet")
netsh int tcp set supplemental Template=Datacenter CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh bbr2 Datacenter") else (call :LogErr "netsh bbr2 Datacenter")
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh bbr2 InternetCustom") else (call :LogErr "netsh bbr2 InternetCustom")
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=cubic >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh bbr2 DatacenterCustom") else (call :LogErr "netsh bbr2 DatacenterCustom")
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

call :ScLog config SSDPSRV start= disabled
call :ScLog stop SSDPSRV
call :ScLog config VacSvc start= disabled
call :ScLog stop VacSvc
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
    powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty -DisplayName '*%%a*' | Set-NetAdapterAdvancedProperty -RegistryValue 0 -ErrorAction SilentlyContinue" >nul 2>&1
    if !errorlevel! equ 0 (call :LogOK "Disable NetAdapter %%~a") else (call :LogErr "Disable NetAdapter %%~a")
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
fsutil behavior set mftzone 4 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil mftzone 4") else (call :LogErr "fsutil mftzone 4")
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
fsutil behavior set mtfzone 1 > nul 2>&1
if %errorlevel% equ 0 (call :LogOK "fsutil mtfzone 1") else (call :LogErr "fsutil mtfzone 1")
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
powershell -NoProfile -Command "Get-PnpDevice -Class HIDClass | Where-Object {$_.Status -eq 'OK'} | ForEach-Object { $path = $_.GetDeviceProperties('DEVPKEY_DeviceClass').DeviceInstance; powercfg /devicedisablewake '$path' }"
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
call :RegLog add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "IOMMUFlags" /t REG_DWORD /d 0 /f
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
call :ScLog config TextInputManagementService start= disabled
call :ScLog stop TextInputManagementService
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
call :RegLog add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "Attributes" /t REG_DWORD /d 0 /f
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg CPMINCORES 100") else (call :LogErr "powercfg CPMINCORES 100")
powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg CPMAXCORES 100") else (call :LogErr "powercfg CPMAXCORES 100")
powercfg -setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg 48e6b7a6 0") else (call :LogErr "powercfg 48e6b7a6 0")
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

for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "AllowIdleIrpInD3" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    call :RegLog add "%%a" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f
)
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f
call :RegLog add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "Attributes" /t REG_DWORD /d 2 /f
powercfg -setacvalueindex scheme_current 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "powercfg ee12f906 0") else (call :LogErr "powercfg ee12f906 0")

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "Device Parameters" /k ^| findstr "Device Parameters"') do (
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
    choice /c YN /n /m "Do you want to overwrite the existing backup Y/N: "
    if errorlevel 2 goto main
)

:DO_BACKUP
echo.
echo [+] Creating Safety Backup of System Registry...
echo     This may take up to 30 seconds. Please do not close this window...
mkdir "%BACKUP_DIR%" >nul 2>&1

reg export "HKLM\SYSTEM" "%BACKUP_DIR%\HKLM_SYSTEM.reg" /y >nul
if %errorlevel% equ 0 (call :LogOK "Export HKLM_SYSTEM") else (call :LogErr "Export HKLM_SYSTEM")
reg export "HKLM\SOFTWARE" "%BACKUP_DIR%\HKLM_SOFTWARE.reg" /y >nul
if %errorlevel% equ 0 (call :LogOK "Export HKLM_SOFTWARE") else (call :LogErr "Export HKLM_SOFTWARE")
reg export "HKCU\Software" "%BACKUP_DIR%\HKCU_Software.reg" /y >nul
if %errorlevel% equ 0 (call :LogOK "Export HKCU_Software") else (call :LogErr "Export HKCU_Software")
reg export "HKCU\Control Panel" "%BACKUP_DIR%\HKCU_CPanel.reg" /y >nul
if %errorlevel% equ 0 (call :LogOK "Export HKCU_CPanel") else (call :LogErr "Export HKCU_CPanel")

echo.
call :LogOK "Backup successfully saved to %BACKUP_DIR%"
echo [OK] Backup successfully saved to %BACKUP_DIR%
echo     You can now use the Revert Undo feature safely.
echo.
echo Press any key to return to the main menu...
pause >nul
goto main

:timerres
call :LogSection "Timer Resolution"
cls
setlocal EnableExtensions EnableDelayedExpansion
title Latency & Timer Resolution Tools

echo ======================================================
echo          LATENCY ^& TIMER RESOLUTION TOOLS
echo ======================================================
echo.

set "LOGFILE=%temp%\timerres_setup.log"
echo ====================================================== > "%LOGFILE%"
echo TimerRes Setup Log >> "%LOGFILE%"
echo ====================================================== >> "%LOGFILE%"
echo. >> "%LOGFILE%"

call :LogInfo "Administrator privileges confirmed."
echo [✓] Administrator privileges confirmed.
echo.

call :LogInfo "Checking internet connectivity..."
echo [!] Checking internet connectivity...
ping -n 1 1.1.1.1 >nul 2>&1
if errorlevel 1 (
    call :LogErr "No internet connection detected. Cannot continue with downloads."
    echo [X] No internet connection detected.
    echo [X] Cannot continue with downloads.
    echo [X] No internet connection >> "%LOGFILE%"
    pause
    goto main
)

call :LogOK "Internet connection detected."
echo [✓] Internet connection detected.
echo.

call :LogInfo "Enabling support for global timer resolution requests..."
echo [!] Enabling support for global timer resolution requests...
%TI% reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul 2>&1
if errorlevel 1 (
    call :LogErr "Failed to enable GlobalTimerResolutionRequests."
    echo [X] Failed to enable GlobalTimerResolutionRequests.
    echo [X] Registry modification failed >> "%LOGFILE%"
) else (
    call :LogOK "GlobalTimerResolutionRequests enabled."
    echo [✓] GlobalTimerResolutionRequests enabled.
    echo [✓] Registry modification successful >> "%LOGFILE%"
)
echo.

set "ISLC_PATH=%temp%\ISLC.exe"
call :LogInfo "Downloading ISLC..."
echo [!] Downloading ISLC...
set "ISLC_URL=https://www.wagnardsoft.com/ISLC/ISLC v1.0.3.2.exe"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri '%ISLC_URL%' -OutFile '%ISLC_PATH%' } catch { exit 1 }" >nul 2>&1

if exist "%ISLC_PATH%" (
    call :LogOK "ISLC downloaded successfully."
    echo [✓] ISLC downloaded successfully.
    echo [✓] ISLC downloaded >> "%LOGFILE%"
    echo [!] Launching ISLC...
    start "" "%ISLC_PATH%"
) else (
    call :LogErr "Failed to download ISLC."
    echo [X] Failed to download ISLC.
    echo [X] ISLC download failed >> "%LOGFILE%"
)
echo.

call :LogInfo "Checking for Winget..."
echo [!] Checking for Winget...
winget --version >nul 2>&1
if errorlevel 1 (
    call :LogWarn "Winget is not available. Process Lasso installation skipped."
    echo [X] Winget is not available.
    echo [X] Process Lasso installation skipped.
    echo [X] Winget missing >> "%LOGFILE%"
) else (
    call :LogOK "Winget detected. Installing Process Lasso..."
    echo [✓] Winget detected.
    echo [!] Installing Process Lasso...
    winget install --id BitSum.ProcessLasso --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
    if errorlevel 1 (
        call :LogErr "Process Lasso installation failed."
        echo [X] Process Lasso installation failed.
        echo [X] Process Lasso install failed >> "%LOGFILE%"
    ) else (
        call :LogOK "Process Lasso installed successfully."
        echo [✓] Process Lasso installed successfully.
        echo [✓] Process Lasso installed >> "%LOGFILE%"
    )
)
echo.

call :LogInfo "Timer-resolution-related tools configured."
echo ======================================================
echo                      COMPLETE
echo ======================================================
echo.
echo [✓] Timer-resolution-related tools configured.
echo.
echo [!] Notes:
echo     - ISLC configuration is optional
echo     - 0.50ms timer resolution is not universally optimal
echo     - Results vary by hardware, drivers, and games
echo     - Process Lasso may require manual configuration
echo.
echo [!] Log file:
echo     %LOGFILE%
echo.
timeout /t 1 /nobreak > NUL
pause
goto main


:fortnite
call :LogSection "Fortnite Optimizer"
cls
echo ============================================================================
echo Native GPEdit Enabler ^& Fortnite QoS Optimizer
echo ============================================================================
echo.

call :LogInfo "Unlocking Native Group Policy Editor..."
echo [1/7] Unlocking Native Group Policy Editor...
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
    echo        - gpedit packages not found ^(You likely already have Windows Pro^).
)
echo.

call :LogInfo "Injecting Registry QoS Override..."
echo [2/7] Injecting Registry QoS Override...
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableUserTOSSetting" /t REG_DWORD /d 0 /f
call :TIRegLog add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS" /v "Application DSCP Marking Request" /t REG_SZ /d "Allowed" /f
echo        - Local networking forced to accept standalone packet rules.
echo.

call :LogInfo "Configuring Core Engine Services (Psched & QWAVE)..."
echo [3/7] Configuring Core Engine Services ^(Psched ^& QWAVE^)...
call :TIScLog config Psched start= system
call :TIScLog start Psched
call :TIScLog config qwave start= auto
call :TIScLog start qwave
echo        - Prioritization daemons successfully initialized.
echo.

call :LogInfo "Eradicating Windows default bandwidth reservation caps..."
echo [4/7] Eradicating Windows default bandwidth reservation caps...
call :TIRegLog add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f
echo        - Interface limit throughput restrictions unthrottled ^(0%%^).
echo.

call :LogInfo "Aligning TCP Auto-Tuning..."
echo [5/7] Aligning TCP Auto-Tuning...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "netsh autotuninglevel=normal") else (call :LogErr "netsh autotuninglevel=normal")
echo        - TCP window scaling optimized for stable packet delivery.
echo.

call :LogInfo "Activating adapter stream configuration..."
echo [6/7] Activating adapter stream configuration...
powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Enable-NetAdapterQos -Name $_.Name -ErrorAction SilentlyContinue }" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Enable-NetAdapterQos") else (call :LogErr "Enable-NetAdapterQos")
echo        - Hardware streams successfully aligned.
echo.

call :LogInfo "Injecting Fortnite Game Packet Matrix Rule..."
echo [7/7] Injecting Fortnite Game Packet Matrix Rule...
powershell -NoProfile -Command "Remove-NetQosPolicy -Name 'FortniteQoS' -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'FortniteQoS' -AppPathName 'FortniteClient-Win64-Shipping.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction Stop" >nul 2>&1
if %errorLevel% equ 0 (
    call :LogOK "Fortnite Client prioritized (DSCP 46 | Profile: ALL)."
    echo        - Success: Fortnite Client prioritized ^(DSCP 46 ^| Profile: ALL^).
) else (
    call :LogErr "Failed to hook packet stream to OS policies."
    echo        - Warning: Failed to hook packet stream to OS policies.
)
echo.
call :LogOK "GPedit is active and Fortnite network priority is locked in."
echo [+] Setup Complete! GPedit is active and Fortnite network priority is locked in.

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
   del /q "C:\Fortnite Optimizer Tools.zip" >nul 2>&1
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
color 9
chcp 65001 >nul 2>&1
echo.
echo.
echo.                             ███████╗ ██████╗ ██████╗ ████████╗███╗   ██╗██╗████████╗███████╗       
echo.                             ██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║╚══██╔══╝██╔════╝       
echo.                             █████╗  ██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║   ██║   █████╗         
echo.                             ██╔══╝  ██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║   ██║   ██╔══╝         
echo.                             ██║     ╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║   ██║   ███████╗       
echo.                             ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝   ╚═╝   ╚══════╝       
echo.                                                                       
echo.                             ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗███████╗██████╗     
echo.                            ██╔═══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔════╝██╔══██╗    
echo.                            ██║   ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ █████╗  ██████╔╝    
echo.                            ██║   ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══╝  ██╔══██╗    
echo.                            ╚██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗███████╗██║  ██║    
echo.                             ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝    
echo. 
echo.                                  ╔════════════════════════════════════════════════════╗
echo.                                  ║              Version 2.1 - By Quaked               ║
echo.                                  ╚════════════════════════════════════════════════════╝
echo.
echo. ╔═════════╗                                                                        
echo. ║ Loading ║                                              
echo. ╚═════════╝
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
    move /Y "C:\Fortnite Optimizer Tools\Legacy Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
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
    move /Y "C:\Fortnite Optimizer Tools\New Performance Mode\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
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
    move /Y "C:\Fortnite Optimizer Tools\DX 12\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
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
    move /Y "C:\Fortnite Optimizer Tools\DX 11\GameUserSettings.ini" "%USERPROFILE%\AppData\Local\FortniteGame\Saved\Config\WindowsClient" >nul 2>&1
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
start "" "C:\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"
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
popd
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
echo     registry with the backup made when you first opened this tool.
echo.
echo [!] NOTE: If you used the 'Clean Up' tool to remove Windows Apps,
echo     those specific apps will NOT be reinstalled by this process.
echo     Use Windows System Restore (Option 11) for a full app rollback.
echo.
choice /c YN /n /m "Do you want to revert all registry tweaks to default? (Y/N): "
if %errorlevel% equ 2 goto main

echo.
set "BACKUP_DIR=%ProgramData%\BARDHZZY\Backup"
if not exist "%BACKUP_DIR%\HKLM_SYSTEM.reg" (
    call :LogErr "No backup found in %BACKUP_DIR%"
    echo [X] ERROR: No backup found in %BACKUP_DIR%
    echo [X] You cannot revert if you never made a backup.
    echo [X] Please select Option 16 to create a backup first.
    timeout /t 3 >nul
    goto main
)

call :LogInfo "Forcibly Importing Original System Registry (Bypassing TrustedInstaller)..."
echo [+] Forcibly Importing Original System Registry (Bypassing TrustedInstaller)...
%TI% reg.exe import "%BACKUP_DIR%\HKLM_SYSTEM.reg" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Import HKLM_SYSTEM") else (call :LogErr "Import HKLM_SYSTEM")
%TI% reg.exe import "%BACKUP_DIR%\HKLM_SOFTWARE.reg" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Import HKLM_SOFTWARE") else (call :LogErr "Import HKLM_SOFTWARE")

call :LogInfo "Importing Original User Registry..."
echo [+] Importing Original User Registry...
reg import "%BACKUP_DIR%\HKCU_Software.reg" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Import HKCU_Software") else (call :LogErr "Import HKCU_Software")
reg import "%BACKUP_DIR%\HKCU_CPanel.reg" >nul 2>&1
if %errorlevel% equ 0 (call :LogOK "Import HKCU_CPanel") else (call :LogErr "Import HKCU_CPanel")

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
:: BARDHZZY PROFESSIONAL LOGGING SYSTEM v14.1 (Absolute Perfection)
:: Immune to: & < > | " ! ( ) % ^ in file paths and registry keys
:: =====================================================================

:LogInit
set "SCRIPT_VERSION=2.2.1"
set "SCRIPT_BUILD=2026-06-24"
set "LOG_ROOT=%ProgramData%\BARDHZZY\Logs"
set "LOG_ENABLED=0"
set "LOG_SECTION=SYSTEM"

:: Fetch OS Version smoothly without bloat
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
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%LOG_SECTION%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
if "%LOG_ENABLED%"=="1" >>"%LOG_FILE%" echo [%LOG_NOW%] [INFO ] [%SEC%] %MSG%
endlocal
goto :eof

:LogOK
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%LOG_SECTION%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
if "%LOG_ENABLED%"=="1" >>"%LOG_FILE%" echo [%LOG_NOW%] [  OK ] [%SEC%] %MSG%
endlocal
goto :eof

:LogErr
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%LOG_SECTION%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
if "%LOG_ENABLED%"=="1" >>"%LOG_FILE%" echo [%LOG_NOW%] [FAILED] [%SEC%] %MSG%
if "%LOG_ENABLED%"=="1" >>"%LOG_ERR%" echo [%LOG_NOW%] [%SEC%] %MSG%
endlocal
goto :eof

:LogWarn
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%LOG_SECTION%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
if "%LOG_ENABLED%"=="1" >>"%LOG_FILE%" echo [%LOG_NOW%] [ WARN] [%SEC%] %MSG%
endlocal
goto :eof

:LogSkip
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "MSG=%~1"
if not defined MSG set "MSG=%LOG_MSG%"
if not defined MSG set "MSG=(No message)"
set "MSG=%MSG:^=^^%"
set "MSG=%MSG:&=^&%"
set "MSG=%MSG:|=^|%"
set "MSG=%MSG:<=^<%"
set "MSG=%MSG:>=^>%"
set "SEC=%LOG_SECTION%"
set "SEC=%SEC:&=^&%"
set "SEC=%SEC:|=^|%"
set "SEC=%SEC:<=^<%"
set "SEC=%SEC:>=^>%"
if "%LOG_ENABLED%"=="1" >>"%LOG_FILE%" echo [%LOG_NOW%] [ SKIP] [%SEC%] %MSG%
endlocal
goto :eof

:LogSection
setlocal DISABLEDELAYEDEXPANSION
call :LogTS
set "SEC=%~1"
set "SEC_ESC=%SEC:^=^^%"
set "SEC_ESC=%SEC_ESC:&=^&%"
set "SEC_ESC=%SEC_ESC:|=^|%"
set "SEC_ESC=%SEC_ESC:<=^<%"
set "SEC_ESC=%SEC_ESC:>=^>%"
if "%LOG_ENABLED%"=="1" (
    >>"%LOG_FILE%" echo.
    >>"%LOG_FILE%" echo ============================================================
    >>"%LOG_FILE%" echo [%LOG_NOW%] ^>^>^> SECTION: %SEC_ESC%
    >>"%LOG_FILE%" echo ============================================================
)
endlocal & set "LOG_SECTION=%~1"
goto :eof

:: =====================================================================
:: WRAPPER FUNCTIONS (BULLETPROOF STATE PRESERVATION)
:: =====================================================================

:RegLog
setlocal DISABLEDELAYEDEXPANSION
reg %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set LOG_MSG=%*
set "LOG_MSG=%LOG_MSG:"=%"
if "%BARDHZZ_ERR%"=="0" call :LogOK
if not "%BARDHZZ_ERR%"=="0" set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
if not "%BARDHZZ_ERR%"=="0" call :LogErr
endlocal
goto :eof

:TIRegLog
setlocal DISABLEDELAYEDEXPANSION
set BARDHZZ_CMD=reg %*
if defined TI set BARDHZZ_CMD=%TI% reg %*
%BARDHZZ_CMD% >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set LOG_MSG=%*
set "LOG_MSG=%LOG_MSG:"=%"
if "%BARDHZZ_ERR%"=="0" call :LogOK
if not "%BARDHZZ_ERR%"=="0" set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
if not "%BARDHZZ_ERR%"=="0" call :LogErr
endlocal
goto :eof

:ScLog
setlocal DISABLEDELAYEDEXPANSION
sc %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set LOG_MSG=%*
set "LOG_MSG=%LOG_MSG:"=%"
if "%BARDHZZ_ERR%"=="0" call :LogOK
if not "%BARDHZZ_ERR%"=="0" set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
if not "%BARDHZZ_ERR%"=="0" call :LogErr
endlocal
goto :eof

:TIScLog
setlocal DISABLEDELAYEDEXPANSION
set BARDHZZ_CMD=sc %*
if defined TI set BARDHZZ_CMD=%TI% sc %*
%BARDHZZ_CMD% >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set LOG_MSG=%*
set "LOG_MSG=%LOG_MSG:"=%"
if "%BARDHZZ_ERR%"=="0" call :LogOK
if not "%BARDHZZ_ERR%"=="0" set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
if not "%BARDHZZ_ERR%"=="0" call :LogErr
endlocal
goto :eof

:SchLog
setlocal DISABLEDELAYEDEXPANSION
schtasks %* >nul 2>&1
set "BARDHZZ_ERR=%errorlevel%"
set LOG_MSG=%*
set "LOG_MSG=%LOG_MSG:"=%"
if "%BARDHZZ_ERR%"=="0" call :LogOK
if not "%BARDHZZ_ERR%"=="0" set "LOG_MSG=%LOG_MSG% (err=%BARDHZZ_ERR%)"
if not "%BARDHZZ_ERR%"=="0" call :LogErr
endlocal
goto :eof

:: =====================================================================
:: SUMMARY & VIEWERS
:: =====================================================================

:LogSummary
setlocal DISABLEDELAYEDEXPANSION
call :LogTS

if not exist "%LOG_FILE%" (
    echo [!] No log file found.
    endlocal
    exit /b
)

set "LOG_OK=0"
set "LOG_FAIL=0"
set "LOG_WARN=0"
set "LOG_SKIP=0"

for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[  OK ]"') do set "LOG_OK=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[FAILED]"') do set "LOG_FAIL=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[ WARN]"') do set "LOG_WARN=%%A"
for /f %%A in ('type "%LOG_FILE%" 2^>nul ^| find /c "[ SKIP]"') do set "LOG_SKIP=%%A"

set /a "LOG_TOTAL=LOG_OK+LOG_FAIL+LOG_WARN+LOG_SKIP" 2>nul

if "%LOG_ENABLED%"=="1" (
    >>"%LOG_FILE%" echo.
    >>"%LOG_FILE%" echo ============================================================
    >>"%LOG_FILE%" echo [%LOG_NOW%] ^>^>^> EXECUTION SUMMARY
    >>"%LOG_FILE%" echo ============================================================
    >>"%LOG_FILE%" echo  Total Operations : %LOG_TOTAL%
    >>"%LOG_FILE%" echo  Successful       : %LOG_OK%
    >>"%LOG_FILE%" echo  Failed           : %LOG_FAIL%
    >>"%LOG_FILE%" echo  Warnings         : %LOG_WARN%
    >>"%LOG_FILE%" echo  Skipped          : %LOG_SKIP%
    >>"%LOG_FILE%" echo ============================================================
    >>"%LOG_FILE%" echo  Full Log  : %LOG_FILE%
    >>"%LOG_FILE%" echo  Error Log : %LOG_ERR%
    >>"%LOG_FILE%" echo ============================================================
)

echo.
echo ============================================================
echo                EXECUTION SUMMARY
echo ============================================================
echo  Total Operations : %LOG_TOTAL%
echo  Successful       : %LOG_OK%
echo  Failed           : %LOG_FAIL%
echo  Warnings         : %LOG_WARN%
echo  Skipped          : %LOG_SKIP%
echo ============================================================
echo  Log File: %LOG_FILE%
echo ============================================================
echo.
endlocal
goto :eof

:LogView
if exist "%LOG_FILE%" (
    start notepad "%LOG_FILE%"
) else (
    echo [!] No log file found.
    timeout 2 >nul
)
goto :eof

:LogViewErrors
if exist "%LOG_ERR%" (
    start notepad "%LOG_ERR%"
) else (
    echo [!] No error log file found.
    timeout 2 >nul
)
goto :eof
:: =====================================================================
:: END OF LOGGING SYSTEM
:: =====================================================================