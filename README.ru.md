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
  🌐 <b>Language / Мова / Язык:</b>
  <a href="README.md"><b>English</b></a> •
  <a href="README.uk.md"><b>Українська</b></a> •
  <a href="README.ru.md"><b>Русский</b></a>
</p>

**RobloxLinuxBlocker (RLB)** — это бескомпромиссный инструмент родительского контроля на уровне ядра системы, который блокирует **АБСОЛЮТНО ВСЕ IP-адреса и домены Roblox на Linux**. Разработан с нуля для 100% блокировки клиента **Sober** (Android-раннер для Linux), **Vinegar**, браузеров и любых нативных фоновых процессов.

Включает **встроенного Telegram-бота**, позволяющего родителям удаленно блокировать, разблокировать Roblox или устанавливать таймер игры прямо со своего смартфона!

---

## ⚡ Особенности (Features)

- 🔒 **Трехуровневая защита ядра Linux:**
  1. **Ядерные маршруты `blackhole` (FIB routing):** Пакеты, идущие к подсетям CIDR Roblox, отбрасываются ядром еще до выхода в сеть с нулевой нагрузкой на процессор.
  2. **Сетевой фильтр `iptables` и `ip6tables`:** Специальная цепочка `RLB_BLOCK` в цепочках `OUTPUT` и `FORWARD` отбрасывает любой трафик с хоста и из изолированных контейнеров (Flatpak, Bubblewrap).
  3. **DNS-блокировка в `/etc/hosts`:** Перенаправляет все домены авторизации, API, ассетов и CDN Roblox на `0.0.0.0` и `::1`.
- 🤖 **Гарантированная совместимость с Sober / Flatpak:** Так как Flatpak и Sober используют сетевой стек хоста (`--share=network`) и системный `/etc/hosts`, игра через Sober полностью исключена (ошибки подключения, невозможность авторизации и мгновенное закрытие активных сессий).
- 📱 **Родительский контроль через Telegram:** Блокируйте или разблокируйте Roblox удаленно при помощи кнопок в боте или открывайте временный доступ (например, на 30 минут или 1 час) с автоматической блокировкой по таймеру!
- 🚀 **Простой интерфейс командной строки (CLI):** Удобные команды (`rlb auto`, `rlb off`, `rlb on`, `rlb status`, `rlb add parent` и др.).
- 🔄 **Автозапуск через systemd:** Блокировка автоматически активируется при каждой загрузке компьютера.
- 🌐 **Динамическое обновление (`rlb update`):** Запрос к официальным реестрам RIPEstat (AS22697) и ARIN (RC-376) для получения свежих подсетей.
- 📜 **Свободная лицензия:** GNU Affero General Public License v3.0 (AGPL-3.0).

---

## 📥 Установка (Installation)

### Способ 1: Через Git (Рекомендуется)

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/TexnoM/RobloxLinuxBlocker.git
   cd RobloxLinuxBlocker
   ```

2. Запустите скрипт установки:
   ```bash
   sudo ./install.sh
   ```

### Способ 2: С помощью Make

```bash
git clone https://github.com/TexnoM/RobloxLinuxBlocker.git
cd RobloxLinuxBlocker
sudo make install
```

Установщик выполняет следующие действия:
- Создает системную директорию конфигурации `/etc/rlb/`.
- Копирует списки IP-адресов (`roblox_ips.txt`), доменов (`roblox_domains.txt`) и шаблон конфигурации бота.
- Устанавливает утилиты (`rlb` и `rlb-telegram-bot`) в `/usr/local/bin/` (доступны глобально).
- Настраивает службы systemd для автозапуска блокировки и Telegram-бота.

---

## 📱 Настройка Telegram-бота (Удаленный родительский контроль)

Управляйте доступом к Roblox на компьютере прямо со своего смартфона через Telegram!

### Шаг 1: Создайте бота в Telegram
1. Откройте Telegram и найдите официального бота [@BotFather](https://t.me/BotFather).
2. Отправьте команду `/newbot`, укажите имя и юзернейм для бота (например, `MyHomeParentBot`).
3. Скопируйте полученный HTTP API токен (вида `123456789:ABCdefGHIjkLMNopQRstUVwxyz`).

### Шаг 2: Настройте бота на компьютере
Выполните следующие команды в терминале Linux:
```bash
# 1. Сохраните токен Telegram-бота
sudo rlb add token ВАШ_ТОКЕН_БОТА

# 2. Авторизуйте ваш Telegram User ID в качестве родителя
sudo rlb add parent ВАШ_ТЕЛЕГРАМ_ID

# 3. Запустите фоновую службу бота (будет работать всегда)
sudo rlb bot start
```

> 💡 **Не знаете свой Telegram ID?**  
> Просто откройте созданного бота в Telegram, нажмите `/start`, и бот сам пришлет вам ваш ID и готовую команду для авторизации!

### Шаг 3: Использование бота в Telegram
После авторизации откройте бота в Telegram и отправьте `/start` — появится интерактивное меню с кнопками:
- 🔴 **Block Roblox:** Мгновенно отключает интернет для Roblox и принудительно завершает активные сессии Sober.
- 🟢 **Unblock Roblox:** Полностью разрешает игру без ограничений.
- ⏱️ **Allow for 30m / 1h:** Временно разрешает доступ к Roblox и запускает обратный отсчет. Когда время выйдет, бот автоматически заблокирует Roblox и пришлет уведомление!
- 📊 **Status:** Возвращает актуальный статус сетевых правил, таймера и запущенных процессов.

---

## 🎮 Справочник команд (CLI)

### 🔹 Системное управление:
- **`sudo rlb auto`** — Включить блокировку и добавить в автозапуск через systemd (Рекомендуется).
- **`sudo rlb off`** — Полностью выключить блокировку Roblox и отключить автозапуск.
- **`sudo rlb on`** — Включить блокировку немедленно (только для текущей сессии).
- **`sudo rlb noauto`** — Отключить автозапуск systemd (оставив текущую блокировку активной).
- **`rlb status`** — Показать текущее состояние правил брандмауэра, маршрутов ядра, hosts и бота.
- **`rlb test`** — Проверить блокировку серверов Roblox на практике.
- **`sudo rlb update`** — Обновить подсети Roblox из официальных реестров RIPEstat и ARIN.

### 🔹 Управление ботом и родителями:
- **`sudo rlb add token <TOKEN>`** — Сохранить токен Telegram-бота.
- **`sudo rlb add parent <TG_ID>`** — Добавить Telegram ID в список родителей.
- **`sudo rlb remove parent <TG_ID>`** — Удалить Telegram ID из списка родителей.
- **`rlb list parents`** — Просмотреть список авторизованных родителей.
- **`sudo rlb bot start`** — Запустить и включить автозапуск службы Telegram-бота.
- **`sudo rlb bot stop`** — Остановить службу Telegram-бота.
- **`sudo rlb bot restart`** — Перезапустить службу Telegram-бота.
- **`rlb bot status`** — Проверить, запущен ли демон Telegram-бота.

---

## 🗑️ Удаление (Uninstallation)

Если вы решите полностью удалить RobloxLinuxBlocker из системы:

### Способ 1: Через скрипт деинсталляции
```bash
sudo ./uninstall.sh
```

### Способ 2: С помощью Make
```bash
sudo make uninstall
```

### Что делает удаление:
1. Автоматически выполняет `rlb off` для очистки правил брандмауэра и маршрутов blackhole.
2. Останавливает, отключает и удаляет службы `rlb.service` и `rlb-bot.service`.
3. Очищает системный файл `/etc/hosts`.
4. Удаляет исполняемые файлы `/usr/local/bin/rlb`, `/usr/local/bin/rlb-telegram-bot` и каталог `/etc/rlb/`.
5. Возвращает операционную систему в исходное чистое состояние.

---

## 🛡️ Почему это работает против Sober?

[Sober](https://sober.vinegarhq.org/) — это неофициальный клиент Roblox для Linux, запускающий мобильную версию внутри контейнера Flatpak. Обычные блокировщики сайтов или браузерный родительский контроль бессильны против Sober, так как он работает в обход браузеров.

**RobloxLinuxBlocker останавливает Sober на трех уровнях:**
1. **Общая сеть:** Flatpak делит сетевой интерфейс хоста. Правила `ip route blackhole` и `iptables` отбрасывают все исходящие UDP/TCP пакеты, направленные к игровым серверам Roblox AS22697 (порты UDP 1024–65535).
2. **Изоляция DNS и API:** Flatpak монтирует системный файл `/etc/hosts`. Sober не может связаться с `auth.roblox.com` или `apis.roblox.com` для входа или загрузки обновлений.
3. **Завершение процессов:** Команда `sudo rlb on` или кнопка "Block" в Telegram немедленно находит и завершает активные сессии Sober.

---

## 🗂️ Структура проекта

```text
RobloxLinuxBlocker/
├── .github/
│   └── workflows/
│       └── test.yml          # GitHub Actions CI для проверки синтаксиса
├── bin/
│   ├── rlb                   # Главная консольная утилита (Bash)
│   └── rlb-telegram-bot      # Демон родительского контроля (Python 3)
├── data/
│   ├── roblox_ips.txt        # Проверенный список подсетей IP (AS22697 & RC-376)
│   ├── roblox_domains.txt    # Официальный перечень доменов для блокировки
│   └── bot_config.json       # Шаблон конфигурации Telegram-бота
├── systemd/
│   ├── rlb.service           # Служба автозапуска сетевой блокировки
│   └── rlb-bot.service       # Служба фонового Telegram-бота
├── .gitignore                # Исключения Git
├── CONTRIBUTING.md           # Руководство для разработчиков
├── LICENSE                   # Текст лицензии GNU AGPL-3.0
├── Makefile                  # Команды сборки и тестов
├── README.md                 # Документация на английском
├── README.uk.md              # Документация на украинском
├── README.ru.md              # Документация на русском
├── SECURITY.md               # Политика безопасности
├── install.sh                # Автоматический установщик в систему
└── uninstall.sh              # Скрипт полного удаления
```

---

## 📄 Лицензия (License)

Эта программа является свободным программным обеспечением: вы можете распространять и/или модифицировать ее на условиях лицензии **GNU Affero General Public License (AGPL-3.0)**.

Полный текст смотрите в файле [LICENSE](LICENSE).
