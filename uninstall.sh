#!/usr/bin/env bash
# ==============================================================================
# RobloxLinuxBlocker - Uninstaller Script
# License: GNU Affero General Public License v3.0 (AGPL-3.0)
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${YELLOW}=== Uninstalling RobloxLinuxBlocker (RLB) ===${NC}\n"

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[!] Root privileges required. Re-running with sudo...${NC}"
    exec sudo bash "$0" "$@"
fi

# 1. Unblock active rules
echo -e "${CYAN}[1/4]${NC} Disabling active blocking rules and stopping service..."
if [[ -x "/usr/local/bin/rlb" ]]; then
    /usr/local/bin/rlb off 2>/dev/null || true
fi

# 2. Disable and remove systemd service
echo -e "${CYAN}[2/4]${NC} Removing systemd service..."
if command -v systemctl &>/dev/null; then
    systemctl disable --now rlb.service 2>/dev/null || true
fi
rm -f /etc/systemd/system/rlb.service
if command -v systemctl &>/dev/null; then
    systemctl daemon-reload 2>/dev/null || true
fi

# 3. Clean up /etc/hosts
echo -e "${CYAN}[3/4]${NC} Cleaning up /etc/hosts entries..."
if grep -q "# --- ROBLOX-LINUX-BLOCKER-START ---" /etc/hosts 2>/dev/null; then
    sed -i '/# --- ROBLOX-LINUX-BLOCKER-START ---/,/# --- ROBLOX-LINUX-BLOCKER-END ---/d' /etc/hosts
fi

# 4. Remove files and directories
echo -e "${CYAN}[4/4]${NC} Removing executable and configuration files..."
rm -f /usr/local/bin/rlb
rm -rf /etc/rlb

echo ""
echo -e "${GREEN}${BOLD}✔ RobloxLinuxBlocker has been completely removed from your system.${NC}"
echo -e "All firewall rules, network routes, hosts entries, and autostart services have been restored.\n"
