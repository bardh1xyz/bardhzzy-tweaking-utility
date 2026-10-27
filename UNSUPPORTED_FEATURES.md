# Windows Features That May Stop Working After Running bardhzzY Tweaks

This document lists Windows features, apps, services, and recovery functions that **may become unavailable or unreliable** after applying options in `bardhzzY Tweak.bat`.

> **Important:** The script is menu-based. These changes are **not all applied automatically** when the file starts. The actual impact depends on which menu options you run, your Windows version, which components are installed, and whether each command succeeds. This is a static review of the script, not a claim that every listed change was successfully applied on every PC.
> **Note:** This list covers the main potential compatibility issues identified in the script. Other tweaks may also have hardware- or Windows-version-specific side effects.

## Quick summary

| Menu option | Main potential impact |
|---|---|
| **1 — Windows Tweaks** | Edge/WebView2, OneDrive, UAC, selected Windows optional features, Bluetooth and other services; optional Windows Search changes |
| **2 — GPU Tweaks** | Hardware/driver-specific registry changes; possible GPU, display, power-management, or stability side effects |
| **3 — CPU Tweaks** | Hyper-V, Virtual Machine Platform, Windows hypervisor, VBS and Memory Integrity; selected legacy drivers and VPN-related services |
| **12 — Service Reduction** | Microsoft Store and app packages, Bluetooth, printing, camera, backup/shadow-copy services, time sync, diagnostics, and other Windows services |
| **13 — Device Manager Tweak** | Attempts to disable selected devices, including Bluetooth, print, virtual-machine, audio, and network-related devices |
| **14 — Disable Defender** | Microsoft Defender protections, SmartScreen, Windows Security notifications and related services |

Only review the sections matching the options you actually selected.

---

## 1. Windows Tweaks — Option 1

### Browser and embedded web components

- **Microsoft Edge:** The script attempts to uninstall Edge, remove its files and shortcuts, and disable its update services and scheduled tasks.
- **Microsoft Edge WebView2 Runtime:** The script attempts to uninstall WebView2 and remove its files.
- **Potential impact:** Apps that embed web pages or use WebView2 for sign-in, account pages, help panels, or other interfaces may fail or display blank content. Edge-dependent workflows will also be unavailable unless Edge is restored.

### Security and application protections

- **User Account Control (UAC):** Sets `EnableLUA=0`; a restart is required. This reduces an important layer of Windows security and can affect apps that expect normal UAC behavior.
- **Smart App Control:** Attempts to disable this protection on supported Windows 11 versions.
- **User Choice Protection Driver (UCPD):** On qualifying Windows 11 builds, attempts to disable UCPD, which can affect Windows' protection of default-app/file-association choices.

### Optional Windows features disabled

The script attempts to disable the following optional components when present:

- **IIS / web hosting:** IIS web-server, management, legacy compatibility and FTP-server components.
- **Microsoft Message Queuing (MSMQ):** MSMQ server, triggers, HTTP, multicast, DCOM and related components.
- **Windows Communication Foundation (WCF):** HTTP, non-HTTP, pipe, TCP activation and TCP port-sharing components.
- **Legacy network protocols/tools:** SMB 1.0, Telnet Client, TFTP, Simple TCP Services and TIFF IFilter.
- **Legacy software/game components:** DirectPlay and Legacy Components.
- **Windows Sandbox:** The optional Windows Sandbox feature.
- **Printing/document viewing:** Microsoft Print to PDF and XPS Viewer features.
- **Work Folders:** Work Folders Client.
- **Legacy browser and scripting components:** Internet Explorer optional component and Windows PowerShell 2.0.

**Possible consequences:** IIS-hosted sites or FTP services, MSMQ/WCF-dependent apps, SMB1-only devices/shares, older games, Sandbox, Print to PDF, XPS viewing, Work Folders, and apps that require PowerShell 2.0 may stop working. Some features may not be installed on your PC in the first place.

### Services and applications targeted

- **OneDrive:** Attempts to uninstall OneDrive, remove its remaining folders, and remove its Explorer integration. OneDrive sync and integration may be unavailable.
- **Bluetooth services:** Disables selected Bluetooth services, including `bthserv`, `BthAvctpSvc`, `BluetoothUserService`, and related services. Bluetooth peripherals and audio may stop working.
- **Hyper-V integration services:** Disables several guest/integration services. This is separate from the later CPU option, which disables Hyper-V and Virtual Machine Platform features themselves.
- **Windows Update:** Stops `wuauserv` and BITS in this section, deletes update-download cache files, and sets update-related policy values. Updates and background downloads may be interrupted or delayed.
- **Telemetry and diagnostics:** Disables selected diagnostic/autologger sessions and changes diagnostic-related settings.
- **Teredo:** Disables Teredo tunneling. Games or applications relying on Teredo-based IPv6 connectivity may be affected.
- **Selected privacy/convenience settings:** Changes settings associated with Windows suggestions, lock-screen content, and selected app capabilities.

### Optional Windows Search change

Windows Tweaks asks whether to apply a search optimization. If you answer **Y**, it disables the Windows Search service and stops Search processes.

- Windows Search indexing may stop.
- Search results for files, apps, and other indexed content may be incomplete or slower.
- The script also changes taskbar-search and Bing/Cortana-related settings and installs Open-Shell if possible.

### Media apps

The script attempts to remove the modern **Media Player** and **Movies & TV** packages (`ZuneMusic` and `ZuneVideo`). The legacy Windows Media Player feature is enabled as an alternative, but it may not replace every function of the modern apps.

---

## 2. CPU Tweaks — Option 3

This option changes CPU, device-priority and power settings, and attempts to disable virtualization-related Windows features.

### Virtualization and security features

- **Hyper-V:** Attempts to disable the Hyper-V optional feature.
- **Virtual Machine Platform (VMP):** Attempts to disable this optional feature.
- **Windows hypervisor at boot:** Sets `hypervisorlaunchtype` to `off`.
- **Virtualization-Based Security (VBS):** Sets the VBS enable registry value to `0`.
- **Hypervisor-Enforced Code Integrity (HVCI / Memory Integrity):** Sets the HVCI `Enabled` value to `0`.

**Potentially affected:**

- WSL 2 and Linux distributions configured to use WSL 2.
- Docker Desktop installations using the WSL 2 or Hyper-V backend.
- Hyper-V virtual machines.
- Other virtual machines, emulators, or security features that require the Windows hypervisor or virtualization-based security.

### Other services/drivers

The script also disables or modifies selected legacy drivers and services, including the CD/DVD-ROM driver service (`cdrom`), selected FireWire/floppy/HID-related drivers, Network Data Usage Monitoring (`Ndu`), and several Remote Access/VPN-related services.

**Potentially affected:** optical drives, legacy devices, data-usage monitoring, or VPN/remote-access configurations that rely on the affected services.

---

## 3. Service Reduction — Option 12

This option makes broad service and app-package changes. These are some of the most significant potential compatibility impacts in the script.

### Microsoft Store and app installation/licensing

- Attempts to remove the **Microsoft Store** app package.
- Disables **Client License Service (`ClipSVC`)**.
- Removes or affects other app packages listed below.

**Potential impact:** Store access, installing or updating Store apps, and licensing/activation functions for some packaged apps or games may stop working normally.

### App packages the script attempts to remove

Removal can fail or have no effect if a package is absent, protected, or named differently on a particular Windows version.

- **Microsoft Store / app ecosystem:** Microsoft Store, Gaming Services, Microsoft Gaming App / Xbox app, Xbox Gaming Overlay, Xbox Game Overlay, Content Delivery Manager, Windows Web Experience Pack, and Snipping Tool / ScreenSketch.
- **Microsoft communication and productivity apps:** Outlook for Windows, Mail and Calendar (`windowscommunicationsapps`), OneNote, To Do (`Todos`), Whiteboard, Office Hub, Power Automate Desktop, Dev Home, Phone Link / Your Phone, Skype, People, Messaging, Get Started, and Sway.
- **Microsoft media and utilities:** OneDrive, Photos, Camera, Maps, Alarms, Sound Recorder, Feedback Hub, Get Started, Clipchamp, Cortana, 3D Builder, Mixed Reality Portal, Bing Search and other Bing-branded apps.
- **Third-party/promotional apps:** Facebook, Twitter, Drawboard PDF, Solitaire, Candy Crush, Disney Magic Kingdoms, and other targeted packages.

**Potential impact:** The listed apps may be removed for installed users. Some app dependencies may also be affected. The script's revert option explicitly warns that removed apps are not reinstalled automatically by the registry-revert process.

### Hardware and connectivity services

The script disables a large selection of services. Depending on your hardware and usage, the following may stop working or become unreliable:

- **Bluetooth:** Bluetooth service, audio, hands-free, PAN/RFCOMM and related connections.
- **Printing:** Print Spooler and print-workflow services; printer queues and printing may stop working.
- **Camera:** Windows Camera Frame Server (`FrameServer`); apps using the affected camera framework may fail to access the camera.
- **Remote access and VPN:** Selected services related to SSTP, IPsec/policy agent, Remote Access, connection management and other networking components.
- **File and device sharing/discovery:** Selected services for network discovery, device association, network browsing and related discovery functions.
- **Phone/device synchronization:** Selected Connected Devices Platform, OneSync, user-data and messaging services.
- **Time and location:** Windows Time (`W32Time`), automatic time-zone updates (`tzautoupdate`) and location-related services.
- **Biometrics, smart cards and credentials:** Selected services involved in smart-card/credential handling and Windows Hello-related functions may be affected.
- **Input and accessibility:** Selected keyboard-filter, handwriting/ink, HID and device-flow functions may be affected.
- **Diagnostics and troubleshooting:** Windows Error Reporting, diagnostic policy/support, troubleshooting, Program Compatibility Assistant and related diagnostics may be reduced or unavailable.
- **System maintenance and performance:** SysMain, font cache, defragmentation/optimization, storage-resource management and other maintenance services are changed or disabled.
- **OpenSSH agent:** The `ssh-agent` service is disabled; SSH key-agent workflows may stop working until re-enabled.

Not every feature in these categories will necessarily fail. The effect depends on the exact service, Windows build, hardware and application dependencies.

### Backup, recovery and logs

- **Volume Shadow Copy (`VSS`):** Stopped and disabled. Backup software and recovery features that rely on VSS may fail.
- **Windows Backup (`SDRSVC`):** Stopped and disabled. Windows Backup functionality may be unavailable.
- **Windows.old:** The script deletes `C:\Windows.old` if it exists. This may remove the normal rollback files used to return to a previous Windows installation.
- **Event and diagnostic logs:** The script clears Windows event logs and removes selected Windows, update, SleepStudy and diagnostic log/cache folders. Historical troubleshooting information may be lost.
- **Disconnected devices:** The cleanup section attempts to remove non-present/disconnected Plug and Play devices. Some devices may need to be rediscovered or reinstalled when reconnected.
- **Defender scan history:** The script deletes files from the Microsoft Defender scan-history store.

These actions can reduce recovery options and make later troubleshooting harder.

---

## 4. Device Manager Tweak — Option 13

This option attempts to disable selected devices that it finds active. The target list includes:

- **Bluetooth devices/enumerators:** Bluetooth PAN, RFCOMM, Microsoft Bluetooth Enumerator and Bluetooth LE Enumerator.
- **Printing devices:** Microsoft Print to PDF and Root Print Queue.
- **Virtualization/virtual networking:** Hyper-V virtualization infrastructure driver, Hypervisor Service, virtual-drive and NDIS virtual-network enumerators, and the Microsoft Kernel Debug Network Adapter.
- **Remote Desktop and VPN/network adapters:** Remote Desktop Device Redirector Bus, RRAS Root Enumerator, and WAN Miniports for IKEv2, IP, IPv6, L2TP, PPPoE, PPTP, SSTP and Network Monitor.
- **Audio and system devices:** NVIDIA High Definition Audio, Microsoft GS Wavetable Synth, System Timer, High Precision Event Timer, DMA controller, and several ACPI/platform devices.
- **Other hardware/platform devices:** selected Intel management, SMBus/SPI, AMD PSP/controller and other system devices.

**Potential impact:** Bluetooth audio and HID devices, printing, virtual machines, some VPN/remote-access connections, NVIDIA HDMI/DisplayPort audio, or device-specific platform functions may stop working. This option should be used with particular care because it targets hardware devices, not just background services.

---

## 5. GPU Tweaks — Option 2

The script has NVIDIA, AMD and Intel GPU-specific tweak paths. These primarily modify graphics-driver and power/interrupt-related registry settings rather than removing the GPU itself.

**Potential impact:** GPU power-state behavior, clock/power management, interrupt handling, driver stability, display behavior or protected-video/HDCP-related functionality could be affected depending on the GPU model and driver. The exact side effects cannot be guaranteed from the registry changes alone; test the relevant GPU option on the actual hardware before relying on it.
**Disables nvidia app functionality, clipping, overlays (use nvcp for settings and obs for clips)

---

## 6. Disable Defender — Option 14

This is a separate menu option and includes confirmation prompts. If you proceed, the script attempts to disable or weaken:

- Microsoft Defender real-time antivirus protection.
- Behavior monitoring, on-access and downloaded-file scanning, and script scanning.
- Selected Defender services and scheduled scans.
- Microsoft SmartScreen checks for Windows, Explorer/AppHost and Microsoft Edge.
- Windows Security Center services and antivirus/security notifications.

**Security impact:** Protection against malware, malicious downloads, potentially unwanted apps and suspicious scripts is reduced. The script states that Windows Firewall is not changed by this option, but that does not replace antivirus or SmartScreen protection.

---

## Recovery and rollback limitations

- **Revert Tweaks (Option 20)** imports registry backups. It does not automatically reinstall applications removed by Service Reduction.
- Deleted files, cleared event logs, removed `Windows.old` data, disabled devices, and every service or optional feature may not be restored by the registry rollback alone.
- A restore point or registry backup should not be assumed to exist unless it was successfully created before the tweaks.
- Some changes require a restart, and some commands can silently fail or behave differently between Windows versions.

## Before applying the script

1. Create a restore point and a separate backup of important files.
2. Create the script's registry backup before applying changes.
3. Record the menu options you select.
4. Avoid **Service Reduction**, **Device Manager Tweak**, or **Disable Defender** unless you understand the affected features and have a recovery plan.
5. If a feature is important to you—such as Bluetooth, printing, WSL 2, Docker, VPN, Microsoft Store, Xbox, camera access or Windows Backup—test it after each individual option rather than applying every tweak at once.

## Official documentation

- [Microsoft Edge WebView2 overview](https://learn.microsoft.com/en-us/microsoft-edge/webview2/)
- [User Account Control (UAC)](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/)
- [Windows Subsystem for Linux FAQ](https://learn.microsoft.com/en-us/windows/wsl/faq)
