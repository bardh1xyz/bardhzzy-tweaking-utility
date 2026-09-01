# bardhzzY Tweaking Utility

[![OS - Windows](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-0078D4?logo=windows&logoColor=white)](https://microsoft.com/windows)
[![Language - Batch](https://img.shields.io/badge/Language-Batch-4D5A60?logo=gnu-bash&logoColor=white)](#)
[![Discord Online](https://img.shields.io/discord/uqD3nbuuNV?color=7289da&label=Discord&logo=discord&logoColor=white)](https://discord.gg/uqD3nbuuNV)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#license)

A custom *batch script* designed to optimize system performance, minimize background latency, strip *Windows bloatware*, and unlock *maximum FPS* with minimal input delay.

---

## 🚀 Features

* **OS Debloating & Privacy**: Force-removes *telemetry*, background tracking, *Microsoft Edge*, *OneDrive*, and pre-installed *UWP apps*.
* **Gaming & Latency Optimization**: Tweaks GPU profiles (*NVIDIA*, *AMD*, *Intel*), CPU priorities, RAM behavior, *TCP/IP* stack, mouse/keyboard response times, and *system timer resolution*.
* **TrustedInstaller Integration**: Leverages an automated *AdvancedRun engine* to safely modify locked registry hives and system services.
* **System Safety & Recovery**: Includes built-in options for *registry backups*, *System Restore Points*, and full tweak reversions.
* **Automated Dependency Setup**: Silently installs *Winget*, *DirectX Web Setup*, and *Visual C++ Redistributables* (2015–2022).
* **UI Customization**: Deploys lightweight *Open-Shell* configurations and custom performance visuals.
* **These are just some there's way more!**

---

## 🛠️ Menu Options

| Option | Module | Description |
| :---: | :--- | :--- |
| `1` | **Windows Tweaks** | Removes Edge/OneDrive, disables telemetry, optimizes UI, and sets up *Open-Shell* & *Winget*. |
| `2` | **GPU Tweaks** | Applies tailored driver, registry, and power settings for *NVIDIA*, *AMD*, or *Intel* graphics cards. |
| `3` | **CPU Tweaks** | Adjusts process priority scheduling, worker threads, and *kernel responsiveness*. |
| `4` | **RAM Tweaks** | Optimizes memory management, *prefetch/superfetch* behavior, and pagefile interactions. |
| `5` | **Power Tweaks** | Disables *dynamic power throttling* and optimizes CPU power state transitions. |
| `6` | **Network Tweaks** | Disables *Nagle's Algorithm*, tunes TCP/IP parameters, and lowers network latency. |
| `7` | **Storage Tweaks** | Adjusts drive *I/O priority*, disables disk logging, and optimizes file system indexing. |
| `8` | **Input Lag Tweaks** | Tunes *DWM*, graphics queue delay, and system timer parameters for minimal latency. |
| `9` | **KBM Tweaks** | Adjusts mouse/keyboard repeat rates, polling stability, and removes *acceleration curves*. |
| `10` | **Timer Resolution** | Configures low-level *system timer resolution* for consistent frame delivery. |
| `11` | **Fortnite Optimizer** | Whitelists Fortnite paths in security settings and applies *custom process priorities*. |
| `12` | **Service Reduction** | Disables non-essential Windows services (*Printers*, *Fax*, *Hyper-V*, *Bluetooth*, etc.). |
| `13` | **Device Manager Tweak** | Disables unused virtual devices (*WAN Miniports*, *VMIC guest interfaces*). |
| `14` | **Disable Defender** | Disables Windows security/antivirus *Proceed with care if u run this option!* |
| `15` | **Re-enable Defender** | Re-enables *Windows security* if disabled previously. |
| `16` | **Fixes** | Contains fixes for different games and errors if the tweak broke them. |
| `17` | **Restore Point** | Creates a standard Windows *System Restore Point*. |
| `18` | **Registry Backup** | Generates a full backup of critical system *registry hives*. |
| `19` | **Revert Tweaks** | Reverts modified registry keys and service configurations back to *defaults*. |
| `20–24` | **Utilities & Logs** | Quick system restart, *live execution log viewer*, error diagnostics, and script exit. |

---

## 📖 How to Use

> ⚠️ **Warning**: Modifying system registry values and services carries inherent risk. Always create backups before applying changes.

1. Right-click the .bat file.
2. Select Run as Administrator.
3. Create a registry backup (option 15) and a restore point (option 14)
4. Run the Tweak Options as Preferred
5. Restart