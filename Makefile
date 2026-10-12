.PHONY: all install uninstall test lint status help

all: help

help:
	@echo "RobloxLinuxBlocker (RLB) - Команди Makefile:"
	@echo "  make install    - Встановити RLB в систему (/usr/local/bin/rlb та /etc/rlb)"
	@echo "  make uninstall  - Повністю видалити RLB з системи"
	@echo "  make test       - Перевірити синтаксис усіх bash-скриптів"
	@echo "  make lint       - Запустити shellcheck (якщо встановлено)"
	@echo "  make status     - Показати поточний стан блокування"

install:
	@./install.sh

uninstall:
	@./uninstall.sh

test:
	@echo "==> Перевірка синтаксису bash..."
	bash -n bin/rlb
	bash -n install.sh
	bash -n uninstall.sh
	@echo "✔ Синтаксис коректний!"

lint: test
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "==> Запуск ShellCheck..."; \
		shellcheck bin/rlb install.sh uninstall.sh; \
		echo "✔ ShellCheck пройдено!"; \
	else \
		echo "shellcheck не встановлено, пропускаємо lint"; \
	fi

status:
	@./bin/rlb status
