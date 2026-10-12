# RobloxLinuxBlocker (RLB) 🚫🎮

<p align="center">
  <img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3">
  <img src="https://img.shields.io/badge/Platform-Linux-orange.svg" alt="Platform: Linux">
  <img src="https://img.shields.io/badge/Compatibility-Sober%20%7C%20Vinegar%20%7C%20Flatpak-success.svg" alt="Sober Compatible">
  <img src="https://img.shields.io/badge/Language-Bash-4EAA25.svg" alt="Language: Bash">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg" alt="Status">
</p>

**RobloxLinuxBlocker (RLB)** is an uncompromising, system-level tool that blocks **ABSOLUTELY ALL Roblox IP addresses and domains on Linux**. Designed from the ground up for 100% compatibility and airtight blocking against **Sober** (the Android runner for Linux), **Vinegar**, web browsers, and any background native game clients.

---

## ⚡ Features

- 🔒 **Triple-Layer Linux Kernel Protection:**
  1. **Kernel Blackhole Routes (FIB routing):** Packets destined for Roblox CIDR blocks are immediately dropped by the Linux kernel with zero CPU overhead.
  2. **Netfilter / iptables & ip6tables Rules:** A dedicated `RLB_BLOCK` chain attached to `OUTPUT` and `FORWARD` drops all traffic originating from host applications as well as containerized sandbox environments (such as Flatpak and Bubblewrap).
  3. **DNS Sinkholing via `/etc/hosts`:** Routes all Roblox login, API, asset delivery, and CDN domains to `0.0.0.0` and `::1`.
- 🤖 **Guaranteed Sober / Flatpak Compatibility:** Because Flatpak and Sober share the host's network namespace (`--share=network`) and inherit the host `/etc/hosts`, gameplay through Sober is completely disabled (connection timeouts, authentication failure, and instant termination of active sessions).
- 🚀 **Intuitive CLI Commands:** Single-word controls (`rlb auto`, `rlb off`, `rlb on`, `rlb status`, etc.).
- 🔄 **Persistent Autostart via systemd:** Starts automatically on system boot.
- 🌐 **Dynamic Prefix Updates (`rlb update`):** Queries official RIPEstat (AS22697) and ARIN (RC-376) RDAP APIs to sync the latest Roblox subnets.
- 📜 **Free & Open Source:** Licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

---

## 📥 Installation

### Method 1: Git Clone (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/rxuser/RobloxLinuxBlocker.git
   cd RobloxLinuxBlocker
   ```

2. Run the installer script:
   ```bash
   sudo ./install.sh
   ```

### Method 2: Using Make

```bash
git clone https://github.com/rxuser/RobloxLinuxBlocker.git
cd RobloxLinuxBlocker
sudo make install
```

The installer performs the following operations:
- Creates the system configuration folder at `/etc/rlb/`.
- Deploys the IP ranges (`roblox_ips.txt`) and domain lists (`roblox_domains.txt`).
- Installs the executable binary `rlb` into `/usr/local/bin/rlb` (available system-wide).
- Sets up the systemd service file at `/etc/systemd/system/rlb.service`.

---

## 🎮 How to Use (Commands)

### 🔹 1. Enable Blocking & Autostart on Boot (Recommended):
Blocks Roblox immediately and configures systemd so that blocking stays active even after computer reboots:
```bash
sudo rlb auto
```

### 🔹 2. Completely Disable Blocking:
Reverts all firewall rules, deletes blackhole routes, cleans up `/etc/hosts`, and stops the systemd service:
```bash
sudo rlb off
```

### 🔹 3. Enable Blocking for Current Session Only:
Blocks Roblox immediately without enabling persistent systemd autostart:
```bash
sudo rlb on
```

### 🔹 4. Disable Autostart Only:
Disables the systemd autostart service while keeping the current session's block active:
```bash
sudo rlb noauto
```

### 🔹 5. Inspect Live Status:
Shows the active state of firewall rules, blackhole routes, DNS sinkholes, systemd service status, and running Sober processes:
```bash
rlb status
```

### 🔹 6. Test Blocking:
Runs connectivity probes against Roblox domains, APIs, and game server IPs to confirm that traffic is blocked:
```bash
rlb test
```

### 🔹 7. Update Roblox IP Subnets:
Fetches announced BGP prefixes and ARIN allocations in real time and reapplies the rules:
```bash
sudo rlb update
```

### 🔹 8. View Help:
```bash
rlb help
```

---

## 🗑️ Uninstallation

If you wish to remove RobloxLinuxBlocker completely from your system:

### Method 1: Using the uninstaller script
```bash
sudo ./uninstall.sh
```

### Method 2: Using Make
```bash
sudo make uninstall
```

### What uninstallation does:
1. Automatically runs `rlb off` to remove all active firewall rules and kernel blackhole routes.
2. Stops and disables the `rlb.service` systemd service.
3. Removes `/etc/systemd/system/rlb.service` and reloads systemd daemon.
4. Removes all Roblox sinkhole entries from `/etc/hosts`.
5. Deletes `/usr/local/bin/rlb` and `/etc/rlb/`.
6. Leaves your operating system in its original, clean state.

---

## 🛡️ Why Does This Work Against Sober?

[Sober](https://sober.vinegarhq.org/) is an unofficial Roblox runtime for Linux that wraps the Android APK inside a Flatpak container. Traditional app blockers or parental controls fail against Sober because it bypasses desktop Wine/browser restrictions.

**RobloxLinuxBlocker stops Sober on three levels:**
1. **Network Namespace:** Flatpak shares the host network interface. The `ip route blackhole` and `iptables` rules drop all outgoing UDP/TCP packets going to Roblox AS22697 game servers (UDP ports 1024–65535).
2. **DNS & API Isolation:** Flatpak mounts the host `/etc/hosts` file. Sober cannot connect to `auth.roblox.com` or `apis.roblox.com` to log in, fetch updates, or download game assets.
3. **Session Killer:** Running `sudo rlb on` or `sudo rlb auto` detects and immediately terminates any active Sober sessions.

---

## 🗂️ Project Structure

```text
RobloxLinuxBlocker/
├── .github/
│   └── workflows/
│       └── test.yml          # GitHub Actions CI for syntax validation
├── bin/
│   └── rlb                   # Primary CLI management tool
├── data/
│   ├── roblox_ips.txt        # Verified CIDR IP prefix list (AS22697 & RC-376)
│   └── roblox_domains.txt    # Official domain and subdomain blocklist
├── systemd/
│   └── rlb.service           # systemd unit for persistent boot protection
├── .gitignore                # Git ignore rules
├── CONTRIBUTING.md           # Contribution guidelines
├── LICENSE                   # GNU Affero General Public License v3.0
├── Makefile                  # Helper targets (install, uninstall, test)
├── README.md                 # Project documentation
├── SECURITY.md               # Security vulnerability policy
├── install.sh                # Automated system installer
└── uninstall.sh              # Clean uninstaller
```

---

## 📄 License

This program is free software: you can redistribute it and/or modify it under the terms of the **GNU Affero General Public License (AGPL-3.0)** as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

See the [LICENSE](LICENSE) file for the full text.
