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
RED='\033[0;31m'
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
echo -e "${CYAN}[2/5]${NC} Copying Roblox IP and domain lists..."
cp -f "${SCRIPT_DIR}/data/roblox_ips.txt" /etc/rlb/roblox_ips.txt
cp -f "${SCRIPT_DIR}/data/roblox_domains.txt" /etc/rlb/roblox_domains.txt
chmod 644 /etc/rlb/roblox_ips.txt /etc/rlb/roblox_domains.txt

# 3. Install CLI tool
echo -e "${CYAN}[3/5]${NC} Installing rlb executable to /usr/local/bin..."
cp -f "${SCRIPT_DIR}/bin/rlb" /usr/local/bin/rlb
chmod 755 /usr/local/bin/rlb

# 4. Install systemd service
echo -e "${CYAN}[4/5]${NC} Installing systemd service rlb.service..."
mkdir -p /etc/systemd/system
cp -f "${SCRIPT_DIR}/systemd/rlb.service" /etc/systemd/system/rlb.service
chmod 644 /etc/systemd/system/rlb.service

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
echo -e "  ${GREEN}sudo rlb auto${NC}    - Enable blocking and setup autostart on boot (RECOMMENDED)"
echo -e "  ${YELLOW}sudo rlb status${NC}  - Inspect current blocking status"
echo -e "  ${RED}sudo rlb off${NC}     - Turn off blocking and disable autostart"
echo -e "  ${CYAN}sudo rlb update${NC}  - Pull latest Roblox IP subnets from official registries"
echo -e "  ${BOLD}rlb help${NC}         - Show command help"
echo ""
