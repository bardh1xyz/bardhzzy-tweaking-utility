@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

echo ==================================
echo Run as admin if u didnt!!
echo ==================================
timeout /t 5 /nobreak >nul

:: ==================
:: BARDHZZYOS TWEAKS 
:: ==================

set "dmv=powershell -NoProfile -Command Disable-PnpDevice -InstanceId"

:: 2. Internet Connection Check
ping -n 1 8.8.8.8 >nul 2>&1
if %errorLevel% neq 0 (
    echo ====================================================
    echo ERROR: No internet connection detected. 
    echo Please connect to the internet and try again.
    echo ====================================================
    pause
    exit
)


echo [*] Starting bardhzzYos Optimizations...

:: =====================================================================
:: 1. DOWNLOAD & INSTALL PREREQUISITES (VC++ & OPEN-SHELL)
:: =====================================================================
echo [*] Downloading and installing Visual C++ Redistributables...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile '%TEMP%\vc_redist.x64.exe'; Start-Process -FilePath '%TEMP%\vc_redist.x64.exe' -ArgumentList '/install /quiet /norestart' -Wait; Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -OutFile '%TEMP%\vc_redist.x86.exe'; Start-Process -FilePath '%TEMP%\vc_redist.x86.exe' -ArgumentList '/install /quiet /norestart' -Wait" >nul 2>&1
del /q "%TEMP%\vc_redist.x64.exe" >nul 2>&1
del /q "%TEMP%\vc_redist.x86.exe" >nul 2>&1

echo [*] Downloading and installing Open-Shell...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.190/OpenShellSetup_4_4_190.exe' -OutFile '%TEMP%\OpenShell.exe'; Start-Process -FilePath '%TEMP%\OpenShell.exe' -ArgumentList '/quiet /norestart' -Wait" >nul 2>&1
del /q "%TEMP%\OpenShell.exe" >nul 2>&1

:: ====================================================
:: WINGET + LTSC IoT DEPENDENCIES 
:: ====================================================
echo.
echo [+] Downloading Winget and LTSC UWP Dependencies...
set "WG_OK=1"
curl -L -f -o "%temp%\vclibs.appx" "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" || set "WG_OK=0"
curl -L -f -o "%temp%\uia.appx" "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx" || set "WG_OK=0"
curl -L -f -o "%temp%\winget.msixbundle" "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" || set "WG_OK=0"

if "%WG_OK%"=="1" (
    echo [+] Installing Dependencies and Winget via PowerShell...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-AppxPackage -Path '%temp%\vclibs.appx'; Add-AppxPackage -Path '%temp%\uia.appx'; Add-AppxPackage -Path '%temp%\winget.msixbundle'"
    
    :: Clean up installers
    del "%temp%\vclibs.appx"
    del "%temp%\uia.appx"
    del "%temp%\winget.msixbundle"
    echo [+] Winget installed successfully!
) else (
    echo [-] ERROR: Failed to download Winget or dependencies.
    if exist "%temp%\vclibs.appx" del "%temp%\vclibs.appx"
    if exist "%temp%\uia.appx" del "%temp%\uia.appx"
    if exist "%temp%\winget.msixbundle" del "%temp%\winget.msixbundle"
)

echo [+] Downloading DirectX Web Setup...
curl -L -f -s -o "%temp%\dxwebsetup.exe" "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe"

if %errorlevel% neq 0 (
    echo [X] ERROR: Failed to download DirectX. Check your internet connection.
    if exist "%temp%\dxwebsetup.exe" del /q "%temp%\dxwebsetup.exe" >nul 2>&1
    goto :End
)

echo [OK] Download complete.
echo [+] Installing DirectX silently (this may take a moment)...

:: --- 4. INSTALLATION ---
start /wait "" "%temp%\dxwebsetup.exe" /Q /R:N

:: Capture the absolute raw status code immediately
set "DX_EXIT_CODE=!errorlevel!"

:: Immediate internal house-cleaning
del /q "%temp%\dxwebsetup.exe" >nul 2>&1

:: --- 5. LIVE ERROR EVALUATION ---
if "!DX_EXIT_CODE!"=="0" (
    echo [OK] DirectX installed successfully.
) else (
    echo [X] ERROR: DirectX installer finished with unexpected exit code: !DX_EXIT_CODE!
    echo     It may already be up to date. Check %windir%\DXError.log for details.
)

echo.

:: =====================================================================
:: 2. WINDOWS USER TWEAKS (HKCU), OPEN-SHELL & EDGE KILL
:: =====================================================================
echo [*] Applying User (HKCU) Registry Tweaks...

:: Disable Universal Search & Bing
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Open-Shell Core Config
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "WinKey" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "LeftClick" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "MenuStyle" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Metro" /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "SkinVariationW7" /t REG_SZ /d "Dark" /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\OpenShell\StartMenu\Settings" /v "ShowUserPic" /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe" /v "Debugger" /t REG_SZ /d "systray.exe" /f >nul 2>&1
taskkill /f /im SearchHost.exe >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchHost.exe" /v "Debugger" /t REG_SZ /d "systray.exe" /f >nul 2>&1

:: Explorer & UI Tweaks
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable the "Let's finish setting up your device" screen (SCOOBE)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f

:: Disable the Windows Welcome Experience post-update screens
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f

:: Disable Microsoft consumer cloud content features system-wide
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\DXGIExtensions" /v "ForceIndependentFlip" /t REG_DWORD /d 1 /f >nul 2>&1

for %%v in (ActivelyUsed IdleLongTime IdleMonitorOff IdleShortTime IdleVeryLongTime IdleNoContext) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatency%%v" /t REG_DWORD /d 1 /f >nul 2>&1
)
for %%v in (Idle0 Idle0MonitorOff Idle1 Idle1MonitorOff Memory NoContext NoContextMonitorOff Other TimerPeriod) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyTolerance%%v" /t REG_DWORD /d 1 /f >nul 2>&1
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d 1 /f >nul 2>&1

:: Gaming & Game DVR
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Mouse & Keyboard Tweaks (No acceleration, fast repeat)
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "200" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "15" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f >nul 2>&1

:: Notifications
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Bulletproof Edge Block (IFEO Trick)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdge.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f >nul 2>&1

:: Disable PnP Devices (WAN Minports, Virtual Buses)
for %%d in (
  "SWD\MSRRAS\MS_IKEEV2_MINIPORT" "SWD\MSRRAS\MS_IP_MINIPORT" "SWD\MSRRAS\MS_IPV6_MINIPORT"
  "SWD\MSRRAS\MS_L2TP_MINIPORT" "SWD\MSRRAS\MS_PPPOE_MINIPORT" "SWD\MSRRAS\MS_PPTP_MINIPORT"
  "SWD\MSRRAS\MS_SSTP_MINIPORT" "SWD\MSRRAS\MS_NDISWANBH" "SWD\MSRRAS\MS_NDISWANIP" "ACPI\PNP0103"
) do (
  %dmv% "%%~d" >nul 2>&1
)

sc config lanmanworkstation depend= "Bowser/Srv2/SrvNet" >nul 2>&1
powershell -NoProfile -Command "$paths = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture'); foreach ($p in $paths) { if (Test-Path $p) { Get-ChildItem $p | ForEach-Object { $fx = Join-Path $_.PSPath 'FxProperties'; if (Test-Path $fx) { Set-ItemProperty -Path $fx -Name '{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5' -Value 1 -Type DWord -ErrorAction SilentlyContinue } } } }" >nul 2>&1

:: =====================================================================
:: 3. GPU TWEAKS (NVIDIA & AMD)
:: =====================================================================
echo [*] Applying GPU Tweaks...

:: NVIDIA Profile & Settings
for %%i in (0000 0001 0002 0003 0004 0005) do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerEnable" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PerfLevelSrc" /t REG_DWORD /d 8738 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "PowerMizerLevelAC" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableCoreSlowdown" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableMCLKSlowdown" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "EnableNVCLKSlowdown" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%%i" /v "RMHdcpKeyglobZero" /t REG_DWORD /d 1 /f >nul 2>&1
)

:: Enable MSI Mode for NVIDIA GPU
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "NVIDIA" ^| findstr "HKEY"') do (
    reg add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d 3 /f >nul 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/2.4.0.4/nvidiaProfileInspector.zip' -OutFile '%TEMP%\nvp.zip'; Expand-Archive -Path '%TEMP%\nvp.zip' -DestinationPath '%TEMP%\nvp' -Force; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/BiteTheDust-Tweaks/NVIDIA-Profiles/main/Competitive.nip' -OutFile '%TEMP%\pro.nip'; Start-Process -FilePath '%TEMP%\nvp\nvidiaProfileInspector.exe' -ArgumentList '%TEMP%\pro.nip -silent' -Wait" >nul 2>&1
del /q "%TEMP%\nvp.zip" "%TEMP%\pro.nip" >nul 2>&1
rd /s /q "%TEMP%\nvp" >nul 2>&1

for %%t in ("NvTmMon*" "NvTmRep*" "NvDriverUpdateCheckDaily*" "NVIDIA GeForce Experience SelfUpdate*") do (
    schtasks /Change /TN %%t /Disable >nul 2>&1
)
sc config NvBackend start= disabled >nul 2>&1
sc config nvcontainer start= disabled >nul 2>&1
sc config NVDisplay.ContainerLocalSystem start= demand >nul 2>&1

:: =====================================================================
:: NVIDIA DRIVER LATENCY TWEAK (Safe to add)
:: =====================================================================
echo [*] Applying NVIDIA Latency Tweaks...
:: Disable NVIDIA Dynamic P-State (Causes clock drops in Fortnite)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d 0 /f >nul 2>&1

:: AMD Tweaks
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /f "DriverDesc" ^| findstr "HKEY"') do (
for /f "tokens=2,*" %%b in ('reg query "%%a" /v "DriverDesc" 2^>nul') do (
    echo %%c | findstr /i "AMD" >nul && (
            reg add "%%a" /v "PP_RTPMComputeF1Latency" /t REG_DWORD /d 1 /f >nul 2>&1
            reg add "%%a" /v "PP_DGBMMMaxTransitionLatencyUvd" /t REG_DWORD /d 1 /f >nul 2>&1
            reg add "%%a" /v "PP_DGBPMMaxTransitionLatencyGfx" /t REG_DWORD /d 1 /f >nul 2>&1
            reg add "%%a" /v "DalNBLatencyForUnderFlow" /t REG_DWORD /d 1 /f >nul 2>&1
            reg add "%%a" /v "KMD_DeLagEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
        )
    )
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d 10 /f >nul 2>&1
sc config "AMD External Events Utility" start= disabled >nul 2>&1
sc stop "AMD External Events Utility" >nul 2>&1

:: =====================================================================
:: 4. CPU & RAM TWEAKS (DYNAMIC DETECTION)
:: =====================================================================
echo [*] Applying CPU and RAM Tweaks...

:: CPU Tweaks
bcdedit /set debug off >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set x2apicpolicy Enable >nul 2>&1
bcdedit /set numaoptimize 1 >nul 2>&1
bcdedit /set disabledynamictick Yes >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
bcdedit /set tscsyncpolicy Enhanced >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
bcdedit /set bootuxdisabled yes >nul 2>&1
bcdedit /set bootlog No >nul 2>&1
bcdedit /set configaccesspolicy Default >nul 2>&1
bcdedit /set bootstatuspolicy ignoreallfailures >nul 2>&1
bcdedit /set {current} bootmenupolicy Standard >nul 2>&1
bcdedit /timeout 3 >nul 2>&1

:: Dynamic CPU Worker Thread Scaling
set "CPU_CORES=%NUMBER_OF_PROCESSORS%"
set /a "SYS_THREADS=CPU_CORES * 4"
if !SYS_THREADS! GTR 64 set "SYS_THREADS=64"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "AdditionalDelayedWorkerThreads" /t REG_DWORD /d %SYS_THREADS% /f >nul 2>&1

for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "VEN_" ^| findstr "HKEY" ^| findstr /v "Parameters"') do (
    reg add "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d 3 /f >nul 2>&1
)

:: Detect RAM and apply IOPageLockLimit (Fallback to 8GB if WMI fails)
set "totalRAM=8"
for /f %%i in ('powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)"') do set "totalRAM=%%i"

if !totalRAM! LSS 3 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "2097152" /f >nul 2>&1
) else if !totalRAM! LSS 5 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "4194304" /f >nul 2>&1
) else if !totalRAM! LSS 9 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "8388608" /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
) else (
    :: 16GB+
    set /a iopll=!totalRAM! * 1048576
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d !iopll! /f >nul 2>&1
    powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
    powershell -NoProfile -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
    powershell -NoProfile -Command "Disable-MMAgent -PageCombining" >nul 2>&1
    wmic pagefilesetting where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul 2>&1
)

echo [*] Applying fsutil storage optimizations...
fsutil behavior set memoryusage 2 >nul 2>&1
fsutil behavior set mftzone 4 >nul 2>&1
fsutil behavior set Disabledeletenotify 0 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DeepIoCoalescingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul 2>&1

:: =====================================================================
:: 5. NETWORK & STORAGE TWEAKS
:: =====================================================================
echo [*] Applying Network and Storage Tweaks...

:: Enable MSI Mode for Ethernet adapters
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v "IfType" 2^>nul ^| findstr /i "HKEY_LOCAL_MACHINE"') do (
    reg query "%%i" /v "IfType" 2>nul | findstr /i "0x6" >nul && (
        reg add "%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
    )
)

:: TCP ACK Frequency & No Delay
for /f "skip=2 delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-PnpDevice -Class Net | Where-Object { $_.FriendlyName -match 'Wi-Fi|Wireless|WLAN|802.11' -and $_.Status -eq 'OK' } | ForEach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false }"

:: Disable LLMNR & NetBIOS (Security/Latency)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableLLMNR" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -NoProfile -Command "Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object { $_.SetTCPIPNetBIOS(2) }" >nul 2>&1
powershell -NoProfile -Command "Get-NetAdapter | Disable-NetAdapterPowerManagement -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-NetAdapter | Enable-NetAdapterRss -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -match 'Energy|Green|Power|Selective|Eee'} | Set-NetAdapterAdvancedProperty -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1

:: Set TCP Congestion Provider to cubic
netsh int tcp set supplemental Template=Compat CongestionProvider=cubic >nul 2>&1
netsh int tcp set supplemental Template=Internet CongestionProvider=cubic >nul 2>&1
netsh int tcp set supplemental Template=Datacenter CongestionProvider=cubic >nul 2>&1
netsh int tcp set supplemental Template=InternetCustom CongestionProvider=cubic >nul 2>&1
netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=cubic >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d 65534 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumTcbTablePartitions" /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d 4 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d 7 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Afd\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d 1500 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "EnableOplocks" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "OplocksDisabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: Enable MSI Mode for Storage Controllers (NVMe/AHCI)
for %%S in (stornvme storahci) do (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=1,2,*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\%%S\Enum" 2^>nul ^| find "REG_SZ"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%C\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d 1 /f >nul 2>&1
        )
    )
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1

for %%p in (ntoskrnl.exe dwm.exe audiodg.exe) do (
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 4 /f >nul 2>&1
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v "IoPriority" /t REG_DWORD /d 3 /f >nul 2>&1
)
for %%p in (SearchIndexer.exe svchost.exe TrustedInstaller.exe wuauclt.exe lsass.exe) do (
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 1 /f >nul 2>&1
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%p\PerfOptions" /v "IoPriority" /t REG_DWORD /d 0 /f >nul 2>&1
)

:: =====================================================================
:: 6. POWER & LATENCY TWEAKS
:: =====================================================================
echo [*] Applying Power and Latency Tweaks...

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
for /f "tokens=4" %%a in ('powercfg -list ^| findstr /i "Ultimate Performance"') do (
    powercfg -setactive %%a >nul 2>&1
)
powercfg /hibernate off >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1

reg add "HKLM\System\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "Attributes" /t REG_DWORD /d 0 /f >nul 2>&1
powercfg -setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP UnattendSleepTimeout 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1

:: Disable Spectre & Meltdown Mitigations for Maximum CPU Throughput
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f >nul 2>&1

:: Disable USB Selective Suspend dynamically
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "AllowIdleIrpInD3" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    reg add "%%a" /v "AllowIdleIrpInD3" /t REG_DWORD /d 0 /f >nul 2>&1
)
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "Device Parameters" /k ^| findstr "Device Parameters"') do (
    reg add "%%i" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "%%i" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
)

:: =====================================================================
:: 7. GAME PRIORITIZATION & FORTNITE QoS
:: =====================================================================
echo [*] Applying Game Priority and Fortnite QoS...

set "regKeyGP=HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"
set "regKeyPR=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

:: Force High CPU/IO Priority
for %%A in (
  "VALORANT.exe" "GTA5.exe" "r5apex.exe" "cs2.exe" "Overwatch.exe" "LeagueClient.exe" "FortniteClient-Win64-Shipping.exe"
) do (
  reg add "%regKeyPR%\%%~A\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f >nul 2>&1
  reg add "%regKeyPR%\%%~A\PerfOptions" /v "IoPriority" /t REG_DWORD /d 3 /f >nul 2>&1
)

:: Force GPU Preference
for %%P in (
  "C:\Riot Games\VALORANT\live\VALORANT.exe"
  "C:\Program Files (x86)\Steam\steamapps\common\Grand Theft Auto V\GTA5.exe"
  "C:\Program Files (x86)\Steam\steamapps\common\Apex Legends\r5apex.exe"
  "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
  "C:\Program Files (x86)\Battle.net\Overwatch\Overwatch.exe"
  "C:\Riot Games\League of Legends\LeagueClient.exe"
  "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe"
) do (
  reg add "%regKeyGP%" /v "%%~P" /t REG_SZ /d "GpuPreference=2" /f >nul 2>&1
)

:: Fortnite QoS
sc config Psched start= system >nul 2>&1
sc config qwave start= auto >nul 2>&1
powershell -NoProfile -Command "Remove-NetQosPolicy -Name 'FortniteQoS' -ErrorAction SilentlyContinue; New-NetQosPolicy -Name 'FortniteQoS' -AppPathName 'FortniteClient-Win64-Shipping.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction SilentlyContinue" >nul 2>&1

:: =====================================================================
:: 8. DISABLE SCHEDULED TASKS (TELEMETRY & BLOAT)
:: =====================================================================
echo [*] Disabling Scheduled Tasks...

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\PcaPatchDbTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Device Information\Device" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Device Information\Device User" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Diagnosis\Scheduled" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskCleanup\SilentCleanup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\StorageSense" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DUSM\dusmtask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\EnterpriseMgmt\MDMMaintenenceTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataFlushing" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Flighting\FeatureConfig\UsageDataReporting" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Flighting\OneSettings\RefreshCache" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Input\LocalUserSyncDataAvailable" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Input\MouseSyncDataAvailable" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Input\PenSyncDataAvailable" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Input\TouchpadSyncDataAvailable" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\International\Synchronize Language Settings" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Installation" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Management\Provisioning\Cellular" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Management\Provisioning\Logon" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsToastTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\MUI\LPRemove" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\PushToInstall\Registration" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Ras\MobilityManager" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\RecoveryEnvironment\VerifyWinRE" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\RetailDemo\CleanupOfflineContent" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Servicing\StartComponentCleanup" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\SettingSync\NetworkStateChangeTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Setup\SetupCleanupTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Setup\SnapshotCleanupTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\SpacePort\SpaceAgentTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\SpacePort\SpaceManagerTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Speech\SpeechModelDownloadTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Storage Tiers Management\Storage Tiers Management Initialization" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Sysmain\ResPriStaticDbSync" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Sysmain\WsSwapAssessmentTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Task Manager\Interactive" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Time Zone\SynchronizeTimeZone" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TPM\Tpm-HASCertRetr" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TPM\Tpm-Maintenance" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\User Profile Service\HiveUploadTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WDI\ResolutionHost" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Management" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WOF\WIM-Hash-Validation" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Work Folders\Work Folders Logon Synchronization" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Work Folders\Work Folders Maintenance Work" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Workplace Join\Automatic-Device-Join" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WwanSvc\NotificationTask" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WwanSvc\OobeDiscovery" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Wininet\CacheTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable >nul 2>&1
schtasks /change /disable /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>&1
schtasks /change /disable /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>&1
schtasks /change /disable /tn "\Microsoft\Windows\Windows Error Reporting\Generic" >nul 2>&1

for %%s in (
  AJRouter ALG AppVClient BcastDVRUserService BDESVC bthserv BthAvctpSvc
  BTAGService BthHFSrv Browser CDPSvc CDPUserSvc CertPropSvc ClipSVC CscService
  DevicePickerUserSvc DeviceAssociationBrokerSvc DevicesFlowUserSvc DiagHub
  diagnosticshub.standardcollector.service DiagTrack DPS DUSM dmwappushservice
  DoSvc dusmtask EntAppSvc Fax fdPHost FDResPub fhsvc GpuEnergyDrv HomeGroupListener
  HomeGroupProvider IKEEXT iphlpsvc lfsvc MapsBroker MixedRealityOpenXRSvc
  MsKeyboardControllerFilterService NetTcpPortSharing NcbService Netlogon
  OneSyncSvc PcaSvc PeerDistSvc PhoneSvc pla PolicyAgent PNRPsvc p2psvc PNRPAutoReg
  PrintNotify PrintWorkflowUserSvc RasAuto RasMan RemoteAccess RemoteRegistry
  RetailDemo RpcLocator ScDeviceEnum SCardSvr SCPolicySvc ScDeviceEnum SEMgrSvc
  SensorDataService SensorService SensrSvc SessionEnv shpamsvc SmartCard
  SmartCardDeviceEnum SMSRouter snmptrap SpectrumService SrmSvc SstpSvc
  SSDPSRV sysmain TabletInputService TapiSrv TelephonyClientApiSvc TermService
  TrustedInstaller tzautoupdate UevAgentService UmRdpService upnphost
  UsoSvc VSS WbioSrvc Wcmsvc WdiServiceHost WdiSystemHost Wecsvc WerSvc
  wisvc WlanSvc WpcMonSvc WpnService WpnUserService WSearch wercplsupport
  WalletService WManSvc WOF xbgm XboxGipSvc XblAuthManager XboxNetApiSvc XblGameSave
) do (
  sc config %%s start= disabled >nul 2>&1
  sc stop %%s >nul 2>&1
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventoryCollection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\systray.exe" /f >nul 2>&1

sc config W32Time start= disabled >nul 2>&1
sc stop W32Time >nul 2>&1
sc config tzautoupdate start= disabled >nul 2>&1

reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve /d "" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v "DisableAIDataAnalysis" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Widgets" /v "AllowWidgets" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_IrisRecommendations" /t REG_DWORD /d 0 /f >nul 2>&1

for %%c in (activity appDiagnostics appointments bluetoothSync broadFileSystemAccess cellularData chat contacts documentsLibrary email gazeInput location phoneCall phoneCallHistory picturesLibrary radios userAccountInformation userDataTasks userNotificationListener videosLibrary) do (
  reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\%%c" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f >nul 2>&1

reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_SZ /d "5000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "MouseHoverTime" /t REG_SZ /d "10" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontShowUI" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: =====================================================================
:: APPLY FORTNITE SPECIFIC CONFIGURATIONS
:: =====================================================================
echo [*] Applying Fortnite Specific Tweaks...

:: Disable FSO for Fortnite specifically via registry
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

:: Set Fortnite to High CPU/IO Priority
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" /f >nul 2>&1

:: =====================================================================
:: DISCORD OPTIMIZATIONS
:: =====================================================================
echo [*] Applying Discord Optimizations...

:: Prioritize Discord Audio
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Affinity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

:: Disable Discord Hardware Acceleration overlay bloat by adding QoS policies
powershell -NoProfile -Command "New-NetQosPolicy -Name 'DiscordVoice' -AppPathName 'Discord.exe' -DSCPAction 46 -NetworkProfile All -ErrorAction SilentlyContinue" >nul 2>&1

:: Kill Microsoft Edge background processes completely
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global Chimney=disabled >nul 2>&1
netsh int tcp set global fastopen=1 >nul 2>&1

:: Disable LSO and Interrupt Moderation (Crucial for Ping)
powershell -NoProfile -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Disable-NetAdapterLso -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -match 'Interrupt Moderation'} | Set-NetAdapterAdvancedProperty -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-NetAdapterAdvancedProperty | Where-Object {$_.DisplayName -match 'Flow Control'} | Set-NetAdapterAdvancedProperty -RegistryValue 0 -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1

powercfg /setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "PlatformTimer" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "TimerSetCoalesce" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d 100 /f >nul 2>&1

sc config Sense start= disabled >nul 2>&1
sc stop Sense >nul 2>&1
sc config WerFaultSvc start= disabled >nul 2>&1
sc stop WerFaultSvc >nul 2>&1
sc config WerKernelSvc start= disabled >nul 2>&1
sc stop WerKernelSvc >nul 2>&1

powershell -NoProfile -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue" >nul 2>&1
sc config lanmanworkstation depend= "Bowser/Srv2/SrvNet" >nul 2>&1


:: =====================================================================
:: 9. CLEANUP & FINISH
:: =====================================================================
echo [*] Cleaning up temporary files...
del /s /f /q "%temp%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G" >nul 2>&1)
for %%k in ("Active Setup Temp Folders" "Content Indexer Cleaner" "Delivery Optimization Files" "Downloaded Program Files" "Internet Cache Files" "Offline Pages Files" "Old ChkDsk Files" "Recycle Bin" "Setup Log Files" "System error memory dump files" "System error minidump files" "Temporary Files" "Temporary Setup Files" "Thumbnail Cache" "Update Cleanup" "Upgrade Discarded Files" "Windows Error Reporting Archive Files" "Windows Error Reporting Queue Files" "Windows Error Reporting System Archive Files" "Windows Error Reporting System Queue Files") do (
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\%%~k" /v "StateFlags0001" /t REG_DWORD /d 2 /f >nul 2>&1
)
echo [*] All tweaks applied successfully.
exit /b