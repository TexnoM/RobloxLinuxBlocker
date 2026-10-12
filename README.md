# RobloxLinuxBlocker (RLB) 🚫🎮

<p align="center">
  <img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3">
  <img src="https://img.shields.io/badge/Platform-Linux-orange.svg" alt="Platform: Linux">
  <img src="https://img.shields.io/badge/Compatibility-Sober%20%7C%20Vinegar%20%7C%20Flatpak-success.svg" alt="Sober Compatible">
  <img src="https://img.shields.io/badge/Telegram%20Bot-Parental%20Control-2CA5E0.svg" alt="Telegram Bot">
  <img src="https://img.shields.io/badge/Language-Bash%20%26%20Python-4EAA25.svg" alt="Language: Bash & Python">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg" alt="Status">
</p>

<p align="center">
  🌐 <b>Language / Мова:</b>
  <a href="README.md"><b>English</b></a> •
  <a href="README.uk.md"><b>Українська</b></a>
</p>

**RobloxLinuxBlocker (RLB)** is an uncompromising, system-level parental control tool that blocks **ABSOLUTELY ALL Roblox IP addresses and domains on Linux**. Designed from the ground up for 100% airtight blocking against **Sober** (the Android runner for Linux), **Vinegar**, web browsers, and background native game clients.

Includes an **integrated Telegram Bot** allowing parents to remotely block, unblock, or set gameplay timers directly from their smartphones!

---

## ⚡ Features

- 🔒 **Triple-Layer Linux Kernel Protection:**
  1. **Kernel Blackhole Routes (FIB routing):** Packets destined for Roblox CIDR blocks are immediately dropped by the Linux kernel with zero CPU overhead.
  2. **Netfilter / iptables & ip6tables Rules:** A dedicated `RLB_BLOCK` chain attached to `OUTPUT` and `FORWARD` drops all traffic originating from host applications as well as containerized sandbox environments (such as Flatpak and Bubblewrap).
  3. **DNS Sinkholing via `/etc/hosts`:** Routes all Roblox login, API, asset delivery, and CDN domains to `0.0.0.0` and `::1`.
- 🤖 **Guaranteed Sober / Flatpak Compatibility:** Because Flatpak and Sober share the host's network namespace (`--share=network`) and inherit the host `/etc/hosts`, gameplay through Sober is completely disabled (connection timeouts, authentication failure, and dropped game packets) purely at the network layer without killing browser or desktop processes.
- 📱 **Telegram Bot Parental Controls:** Remotely block or unblock Roblox from anywhere using interactive Telegram buttons, or grant temporary access (e.g. 30 minutes or 1 hour) with automatic re-blocking when the timer expires!
- 🌐 **Multilingual Telegram Bot:** Prompts for your preferred language on first start (🇺🇦 Ukrainian or 🇬🇧 English) with a dedicated Settings menu to change languages anytime.
- 🚨 **Real-Time Attempt Detection Alerts:** The Telegram bot automatically monitors dropped packets and notifies parents whenever Roblox connection attempts are made on the PC.
- 🛡️ **Parental PIN & Tamper-Proof Locking:** Protect console unblocking with a secret Parent PIN (`rlb pin set`), plus filesystem-level immutable locking (`chattr +i`) on `/etc/hosts`.
- 🌐 **Anti-Circumvention (DoH & DoT Mitigation):** Sinks canary domain `use-application-dns.net` and blocks port 853 to force browsers to respect system blocklists instead of Secure DNS.
- 📊 **Statistics & Connection Reports:** View real-time packet counters and access attempt history via `rlb stats` or directly within Telegram.
- 📦 **Arch Linux Native Package:** Includes ready-to-use `PKGBUILD` for Arch Linux and AUR integration.
- 🚀 **Intuitive CLI Commands:** Single-word controls (`rlb auto`, `rlb off`, `rlb on`, `rlb status`, `rlb pin`, `rlb stats`).
- 🔄 **Persistent Autostart via systemd:** Starts automatically on system boot.
- 🌐 **Dynamic Prefix Updates (`rlb update`):** Queries official RIPEstat (AS22697) and ARIN (RC-376) RDAP APIs to sync the latest Roblox subnets.
- 📜 **Free & Open Source:** Licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

---

## 📥 Installation

### Method 1: Git Clone & Installer (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/TexnoM/RobloxLinuxBlocker.git
   cd RobloxLinuxBlocker
   ```

2. Run the installer script:
   ```bash
   sudo ./install.sh
   ```

### Method 2: Arch Linux (makepkg)

```bash
git clone https://github.com/TexnoM/RobloxLinuxBlocker.git
cd RobloxLinuxBlocker
makepkg -si
```

### Method 3: Using Make

```bash
git clone https://github.com/TexnoM/RobloxLinuxBlocker.git
cd RobloxLinuxBlocker
sudo make install
```

The installer performs the following operations:
- Creates the system configuration folder at `/etc/rlb/`.
- Deploys the IP ranges (`roblox_ips.txt`), domain lists (`roblox_domains.txt`), and bot configuration.
- Installs the CLI tools (`rlb` and `rlb-telegram-bot`) into `/usr/local/bin/`.
- Configures systemd service units for both system autostart and the Telegram bot daemon.

---

## 📱 Telegram Bot Setup (Remote Parental Control)

Control Roblox blocking on the Linux machine directly from your phone via Telegram!

### Step 1: Create a Telegram Bot
1. Open Telegram and search for [@BotFather](https://t.me/BotFather).
2. Send `/newbot`, enter a display name and username (e.g., `MyHouseParentBot`).
3. Copy the HTTP API token provided by BotFather (e.g., `123456789:ABCdefGHIjkLMNopQRstUVwxyz`).

### Step 2: Configure the Bot on Linux
Run the following commands on the Linux PC:
```bash
# 1. Save the Telegram bot token
sudo rlb add token YOUR_BOT_TOKEN_HERE

# 2. Authorize your Telegram user ID as a parent
sudo rlb add parent YOUR_TELEGRAM_USER_ID

# 3. Start the bot background service (enabled on boot)
sudo rlb bot start
```

> 💡 **Don't know your Telegram User ID?**  
> Simply start the bot, message it `/start`, and the bot will reply with your Telegram ID and the exact command to authorize yourself!

### Step 3: Use the Bot in Telegram
Once authorized, open your bot in Telegram and use the interactive menu:
- 🌐 **Language Selection:** Upon sending `/start`, choose between 🇺🇦 Ukrainian and 🇬🇧 English.
- 🔴 **Block Roblox:** Immediately cuts off all Roblox network traffic at the kernel level.
- 🟢 **Unblock Roblox:** Allows unrestricted gameplay.
- ⏱️ **Allow for 30m / 1h:** Temporarily unblocks Roblox and begins a countdown. When time is up, the bot automatically re-blocks Roblox and sends you an alert!
- 📊 **Stats & Report:** Displays dropped packet statistics, detected attempts, and system diagnostics.
- ⚙️ **Settings:** Change bot interface language at any time.

---

## 🎮 Command Reference (CLI)

### 🔹 System Controls:
- **`sudo rlb auto`** — Enable blocking and configure persistent autostart via systemd (Recommended).
- **`sudo rlb off [PIN]`** — Completely disable Roblox blocking and autostart (requires PIN if configured).
- **`sudo rlb on`** — Enable blocking immediately (current session).
- **`sudo rlb noauto [PIN]`** — Disable systemd autostart (keeps current session blocked).
- **`rlb status`** — Inspect live status of firewall rules, blackhole routes, hosts, PIN, and bot service.
- **`rlb stats`** — Display connection attempts, dropped packet counters, and security summary.
- **`rlb test`** — Probe Roblox domains, APIs, game servers, and DoH canaries.
- **`sudo rlb update`** — Pull latest Roblox IP subnets from official RIPEstat & ARIN registries.

### 🔹 Parental PIN & Tamper Protection:
- **`sudo rlb pin set <PIN>`** — Set a 4-8 digit Parent PIN to prevent unauthorized terminal disabling.
- **`sudo rlb pin remove`** — Remove Parent PIN (prompts for current PIN).

### 🔹 Telegram Bot & Remote Control:
- **`sudo rlb add token <TOKEN>`** — Set Telegram bot token.
- **`sudo rlb add parent <TG_ID>`** — Authorize a parent Telegram ID.
- **`sudo rlb remove parent <TG_ID>`** — Revoke a parent Telegram ID.
- **`rlb list parents`** — List all authorized parent IDs.
- **`sudo rlb bot start`** — Start and enable the Telegram bot service.
- **`sudo rlb bot stop`** — Stop the Telegram bot service.
- **`sudo rlb bot restart`** — Restart the Telegram bot service.
- **`rlb bot status`** — Check if the Telegram bot daemon is active.

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
2. Stops and removes the `rlb.service` and `rlb-bot.service` systemd daemons.
3. Cleans up `/etc/hosts` and restores default networking.
4. Deletes `/usr/local/bin/rlb`, `/usr/local/bin/rlb-telegram-bot`, and `/etc/rlb/`.
5. Leaves your operating system in its original, clean state.

---

## 🛡️ Why Does This Work Against Sober?

[Sober](https://sober.vinegarhq.org/) is an unofficial Roblox runtime for Linux that wraps the Android APK inside a Flatpak container. Traditional app blockers or parental controls fail against Sober because it bypasses desktop Wine/browser restrictions.

**RobloxLinuxBlocker stops Sober on three levels:**
1. **Network Namespace:** Flatpak shares the host network interface. The `ip route blackhole` and `iptables` rules drop all outgoing UDP/TCP packets going to Roblox AS22697 game servers (UDP ports 1024–65535).
2. **DNS & API Isolation:** Flatpak mounts the host `/etc/hosts` file. Sober cannot connect to `auth.roblox.com` or `apis.roblox.com` to log in, fetch updates, or download game assets.
3. **No Process Termination Needed:** Blocking works entirely through kernel packet dropping and DNS routing, so user browser sessions, desktop windows, and unsaved work in other apps are never killed or interrupted.

---

## 🗂️ Project Structure

```text
RobloxLinuxBlocker/
├── .github/
│   └── workflows/
│       └── test.yml          # GitHub Actions CI for syntax validation
├── bin/
│   ├── rlb                   # Primary CLI management tool (Bash)
│   └── rlb-telegram-bot      # Parental control daemon (Python 3)
├── data/
│   ├── roblox_ips.txt        # Verified CIDR IP prefix list (AS22697 & RC-376)
│   ├── roblox_domains.txt    # Official domain and subdomain blocklist
│   └── bot_config.json       # Template configuration for Telegram bot
├── systemd/
│   ├── rlb.service           # systemd unit for persistent boot protection
│   └── rlb-bot.service       # systemd unit for Telegram bot daemon
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
