#!/usr/bin/env bash
# ==============================================================================
# RobloxLinuxBlocker - Скрипт видалення (Uninstaller)
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

echo -e "${BOLD}${YELLOW}=== Видалення RobloxLinuxBlocker (RLB) ===${NC}\n"

# Перевірка прав root
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[!] Потрібні права суперкористувача (root). Перезапуск через sudo...${NC}"
    exec sudo bash "$0" "$@"
fi

# 1. Зняття всіх блокувань
echo -e "${CYAN}[1/4]${NC} Зняття діючих правил та зупинка служби..."
if [[ -x "/usr/local/bin/rlb" ]]; then
    /usr/local/bin/rlb off 2>/dev/null || true
fi

# 2. Вимкнення та видалення systemd служби
echo -e "${CYAN}[2/4]${NC} Видалення служби systemd..."
if command -v systemctl &>/dev/null; then
    systemctl disable --now rlb.service 2>/dev/null || true
fi
rm -f /etc/systemd/system/rlb.service
if command -v systemctl &>/dev/null; then
    systemctl daemon-reload 2>/dev/null || true
fi

# 3. Додаткова перевірка /etc/hosts
echo -e "${CYAN}[3/4]${NC} Перевірка та очищення /etc/hosts..."
if grep -q "# --- ROBLOX-LINUX-BLOCKER-START ---" /etc/hosts 2>/dev/null; then
    sed -i '/# --- ROBLOX-LINUX-BLOCKER-START ---/,/# --- ROBLOX-LINUX-BLOCKER-END ---/d' /etc/hosts
fi

# 4. Видалення файлів та каталогів
echo -e "${CYAN}[4/4]${NC} Видалення виконуваного файлу та конфігурацій..."
rm -f /usr/local/bin/rlb
rm -rf /etc/rlb

echo ""
echo -e "${GREEN}${BOLD}✔ RobloxLinuxBlocker успішно та повністю видалено з системи.${NC}"
echo -e "Всі мережеві маршрути, правила брандмауера та автостарт повернено до початкового стану.\n"
