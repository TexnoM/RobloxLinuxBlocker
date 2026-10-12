#!/usr/bin/env bash
# ==============================================================================
# RobloxLinuxBlocker - Скрипт встановлення (Installer)
# Ліцензія: GNU Affero General Public License v3.0 (AGPL-3.0)
# ==============================================================================

set -e

# Кольори
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}=== Встановлення RobloxLinuxBlocker (RLB) ===${NC}\n"

# Перевірка прав root
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[!] Потрібні права суперкористувача (root). Перезапуск через sudo...${NC}"
    exec sudo bash "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Створення системної директорії конфігурації
echo -e "${CYAN}[1/5]${NC} Створення директорії /etc/rlb..."
mkdir -p /etc/rlb

# 2. Копіювання файлів даних
echo -e "${CYAN}[2/5]${NC} Копіювання списків IP та доменів Roblox..."
cp -f "${SCRIPT_DIR}/data/roblox_ips.txt" /etc/rlb/roblox_ips.txt
cp -f "${SCRIPT_DIR}/data/roblox_domains.txt" /etc/rlb/roblox_domains.txt
chmod 644 /etc/rlb/roblox_ips.txt /etc/rlb/roblox_domains.txt

# 3. Встановлення CLI утиліти
echo -e "${CYAN}[3/5]${NC} Встановлення виконуваного файлу rlb в /usr/local/bin..."
cp -f "${SCRIPT_DIR}/bin/rlb" /usr/local/bin/rlb
chmod 755 /usr/local/bin/rlb

# 4. Встановлення systemd служби
echo -e "${CYAN}[4/5]${NC} Встановлення systemd сервісу rlb.service..."
mkdir -p /etc/systemd/system
cp -f "${SCRIPT_DIR}/systemd/rlb.service" /etc/systemd/system/rlb.service
chmod 644 /etc/systemd/system/rlb.service

if command -v systemctl &>/dev/null; then
    systemctl daemon-reload
fi

# 5. Перевірка
echo -e "${CYAN}[5/5]${NC} Перевірка залежностей..."
for cmd in ip iptables python3; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${YELLOW}[ПОПЕРЕДЖЕННЯ] Утиліта '$cmd' не знайдена в системі. Деякі функції можуть працювати обмежено.${NC}"
    fi
done

echo ""
echo -e "${GREEN}${BOLD}✔ RobloxLinuxBlocker успішно встановлено!${NC}"
echo -e "Команда ${BOLD}rlb${NC} тепер доступна глобально в системі."
echo ""
echo -e "${BOLD}Основні команди для використання:${NC}"
echo -e "  ${GREEN}sudo rlb auto${NC}    - Увімкнути блокування та додати в автостарт (РЕКОМЕНДОВАНО)"
echo -e "  ${YELLOW}sudo rlb status${NC}  - Перевірити поточний стан блокування"
echo -e "  ${RED}sudo rlb off${NC}     - Повністю вимкнути блокування"
echo -e "  ${CYAN}sudo rlb update${NC}  - Оновити IP-адреси Roblox з офіційних реєстрів"
echo -e "  ${BOLD}rlb help${NC}         - Довідка з усіх команд"
echo ""
