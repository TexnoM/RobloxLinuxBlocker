# RobloxLinuxBlocker (RLB) 🚫🎮

<p align="center">
  <img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3">
  <img src="https://img.shields.io/badge/Platform-Linux-orange.svg" alt="Platform: Linux">
  <img src="https://img.shields.io/badge/Compatibility-Sober%20%7C%20Vinegar%20%7C%20Flatpak-success.svg" alt="Sober Compatible">
  <img src="https://img.shields.io/badge/Language-Bash-4EAA25.svg" alt="Language: Bash">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen.svg" alt="Status">
</p>

Повний, безкомпромісний інструмент для **блокування АБСОЛЮТНО ВСІХ IP-адрес та доменів Roblox на рівні ядра Linux**. Розроблений для 100% сумісності та блокування клієнта **Sober** (Android-раннер для Linux), **Vinegar**, браузерів та будь-яких нативних процесів.

---

## ⚡ Особливості (Features)

- 🔒 **Трирівневий захист ядра Linux:**
  1. **Ядерні маршрути `blackhole` (FIB routing):** Пакети до серверів Roblox відкидаються ядром ще до виходу в мережу.
  2. **Мережевий фільтр `iptables` / `ip6tables`:** Спеціальний ланцюжок `RLB_BLOCK` у ланцюжках `OUTPUT` та `FORWARD` відкидає запити з хоста та будь-яких контейнерів (включно з Flatpak/Bubblewrap).
  3. **DNS-блокування в `/etc/hosts`:** Повне блокування доменів авторизації, API та CDN Roblox (`0.0.0.0` та `::1`).
- 🤖 **Повна сумісність із Sober:** Оскільки Flatpak та Sober використовують мережевий стек хоста та системний `/etc/hosts`, гра через Sober повністю унеможливлюється (помилки підключення, неможливість авторизації, автоматичне закриття активних сесій).
- 🚀 **Простий інтерфейс CLI:** Команди `rlb auto`, `rlb off`, `rlb on`, `rlb status` тощо.
- 🔄 **Автостарт через systemd:** Блокування автоматично піднімається при кожному завантаженні системи.
- 🌐 **Динамічне оновлення (`rlb update`):** Автоматичний запит до офіційних баз RIPEstat (AS22697) та ARIN (RC-376) для отримання найновіших підмереж.
- 📜 **Вільна ліцензія:** GNU Affero General Public License v3.0 (AGPL-3.0).

---

## 📥 Встановлення (Installation)

### 1. Клонування репозиторію та запуск інсталятора:
```bash
git clone https://github.com/rxuser/RobloxLinuxBlocker.git
cd RobloxLinuxBlocker
sudo ./install.sh
```

Після цього утиліта `rlb` стане доступною в усій системі як глобальна команда.

---

## 🎮 Використання (Usage)

### 🔹 Увімкнути блокування та додати в автостарт (Рекомендовано):
Вмикає повне блокування та реєструє системну службу `systemd`, щоб Roblox залишався заблокованим навіть після перезавантаження комп'ютера:
```bash
sudo rlb auto
```

### 🔹 Вимкнути блокування:
Знімає всі правила брандмауера, ядерні маршрути, очищає `/etc/hosts` та вимикає автостарт:
```bash
sudo rlb off
```

### 🔹 Увімкнути блокування тільки для поточного сеансу (без автостарту):
```bash
sudo rlb on
```

### 🔹 Вимкнути тільки автостарт (залишивши блокування активним):
```bash
sudo rlb noauto
```

### 🔹 Перевірити поточний стан захисту:
Показує кількість активних правил, статус служби systemd та наявність процесів Sober:
```bash
rlb status
```

### 🔹 Протестувати блокування на практиці:
Відправляє тестові запити до сервісів Roblox та повідомляє, чи вони заблоковані:
```bash
rlb test
```

### 🔹 Оновити IP-пули Roblox з офіційних реєстрів:
```bash
sudo rlb update
```

### 🔹 Довідка:
```bash
rlb help
```

---

## 🛡️ Як це працює проти Sober?

[Sober](https://sober.vinegarhq.org/) — це популярний серед користувачів Linux клієнт, що запускає мобільну версію Roblox всередині середовища Flatpak. Більшість звичайних способів блокування (блокування в браузері чи закриття вікон) безсилі проти Sober.

**RobloxLinuxBlocker діє на системному та мережевому рівнях:**
1. Flatpak за замовчуванням ділить спільний простір мережі з ОС (`--share=network`). Ядерні правила `RLB_BLOCK` та `ip route blackhole` унеможливлюють відправку будь-яких пакетів на порти ігрових серверів Roblox (UDP 1024-65535, AS22697).
2. Flatpak монтує системний файл `/etc/hosts`, тому Sober не може виконати запити до `auth.roblox.com` чи `apis.roblox.com`.
3. При виконанні команди блокування активні процеси Sober негайно закриваються.

---

## 🗂️ Структура проєкту

```text
RobloxLinuxBlocker/
├── .github/
│   └── workflows/
│       └── test.yml          # Автоматичні тести синтаксису (CI)
├── bin/
│   └── rlb                   # Основна утиліта керування
├── data/
│   ├── roblox_ips.txt        # База підмереж IP Roblox (CIDR)
│   └── roblox_domains.txt    # База доменів Roblox для hosts
├── systemd/
│   └── rlb.service           # Unit-файл для автостарту systemd
├── .gitignore
├── CONTRIBUTING.md           # Інструкція для розробників
├── LICENSE                   # Ліцензія AGPL-3.0
├── Makefile                  # Зручне керування збіркою та тестами
├── README.md                 # Документація проєкту
├── SECURITY.md               # Політика безпеки
├── install.sh                # Скрипт встановлення в систему
└── uninstall.sh              # Скрипт повного видалення
```

---

## 🗑️ Видалення (Uninstallation)

Якщо ви вирішите повністю видалити RobloxLinuxBlocker із системи:
```bash
sudo ./uninstall.sh
```
Або через `make`:
```bash
sudo make uninstall
```

Це повністю поверне вашу систему, брандмауер, маршрути та `/etc/hosts` до початкового стану.

---

## 📄 Ліцензія (License)

Цей проєкт поширюється на умовах ліцензії **GNU Affero General Public License v3.0 (AGPL-3.0)**.
Повний текст ліцензії дивіться у файлі [LICENSE](LICENSE).
