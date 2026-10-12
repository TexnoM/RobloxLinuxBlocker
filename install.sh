#!/usr/bin/env bash
# ==============================================================================
# RobloxLinuxBlocker - Installer Script
# License: GNU Affero General Public License v3.0 (AGPL-3.0)
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}=== Installing RobloxLinuxBlocker (RLB) ===${NC}\n"

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[!] Root privileges required. Re-running with sudo...${NC}"
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Create system configuration directory
echo -e "${CYAN}[1/5]${NC} Creating /etc/rlb configuration directory..."
mkdir -p /etc/rlb

# 2. Copy data files
echo -e "${CYAN}[2/5]${NC} Copying Roblox IP, domain lists, and bot configuration template..."
cp -f "${SCRIPT_DIR}/data/roblox_ips.txt" /etc/rlb/roblox_ips.txt
cp -f "${SCRIPT_DIR}/data/roblox_domains.txt" /etc/rlb/roblox_domains.txt
chmod 644 /etc/rlb/roblox_ips.txt /etc/rlb/roblox_domains.txt

if [[ ! -f "/etc/rlb/bot_config.json" ]]; then
    cp -f "${SCRIPT_DIR}/data/bot_config.json" /etc/rlb/bot_config.json
    chmod 600 /etc/rlb/bot_config.json
fi

if [[ ! -f "/etc/rlb/stats.json" ]]; then
    cp -f "${SCRIPT_DIR}/data/stats.json" /etc/rlb/stats.json
    chmod 644 /etc/rlb/stats.json
fi

# 3. Install CLI and Telegram bot tools
echo -e "${CYAN}[3/5]${NC} Installing executables to /usr/local/bin..."
cp -f "${SCRIPT_DIR}/bin/rlb" /usr/local/bin/rlb
cp -f "${SCRIPT_DIR}/bin/rlb-telegram-bot" /usr/local/bin/rlb-telegram-bot
chmod 755 /usr/local/bin/rlb /usr/local/bin/rlb-telegram-bot

# 4. Install systemd services
echo -e "${CYAN}[4/5]${NC} Installing systemd services (rlb.service and rlb-bot.service)..."
mkdir -p /etc/systemd/system
cp -f "${SCRIPT_DIR}/systemd/rlb.service" /etc/systemd/system/rlb.service
cp -f "${SCRIPT_DIR}/systemd/rlb-bot.service" /etc/systemd/system/rlb-bot.service
chmod 644 /etc/systemd/system/rlb.service /etc/systemd/system/rlb-bot.service

if command -v systemctl &>/dev/null; then
    systemctl daemon-reload
fi

# 5. Dependency checks
echo -e "${CYAN}[5/5]${NC} Checking system dependencies..."
for cmd in ip iptables python3; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${YELLOW}[WARNING] Utility '$cmd' is not installed. Some features might be degraded.${NC}"
    fi
done

echo ""
echo -e "${GREEN}${BOLD}✔ RobloxLinuxBlocker successfully installed!${NC}"
echo -e "The ${BOLD}rlb${NC} command is now available system-wide."
echo ""
echo -e "${BOLD}Recommended next steps:${NC}"
echo -e "  ${GREEN}sudo rlb auto${NC}                    - Enable blocking and setup autostart on boot"
echo -e "  ${YELLOW}sudo rlb pin set <PIN>${NC}           - Configure Parent PIN to prevent unauthorized disabling"
echo -e "  ${CYAN}sudo rlb add token <TOKEN>${NC}       - Configure Telegram Bot token"
echo -e "  ${CYAN}sudo rlb add parent <TG_ID>${NC}      - Authorize parent Telegram user ID"
echo -e "  ${CYAN}sudo rlb bot start${NC}               - Start the Telegram Bot parental control daemon"
echo -e "  ${BLUE}sudo rlb stats${NC}                   - View blocked connection statistics"
echo -e "  ${BOLD}rlb help${NC}                         - Show all command options"
echo ""
