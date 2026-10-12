.PHONY: all install uninstall test lint status help

all: help

help:
	@echo "RobloxLinuxBlocker (RLB) - Makefile targets:"
	@echo "  make install    - Install RLB system-wide (/usr/local/bin/rlb and /etc/rlb)"
	@echo "  make uninstall  - Completely remove RLB from the system"
	@echo "  make test       - Validate syntax of all bash scripts"
	@echo "  make lint       - Run ShellCheck (if installed)"
	@echo "  make status     - Check current blocking status"

install:
	@./install.sh

uninstall:
	@./uninstall.sh

test:
	@echo "==> Validating Bash syntax..."
	bash -n bin/rlb
	bash -n install.sh
	bash -n uninstall.sh
	@echo "✔ Syntax is valid!"

lint: test
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "==> Running ShellCheck..."; \
		shellcheck bin/rlb install.sh uninstall.sh; \
		echo "✔ ShellCheck passed!"; \
	else \
		echo "shellcheck not installed, skipping lint"; \
	fi

status:
	@./bin/rlb status
