# version 0.0.2
# created by : Team ViewTech
# date       : 2025-06-05 | 08.47 WIB
# developer  : Xenzi & Polygon (pejuang kentang)
########################################

PACKAGEBASH_TERMUX := curl python bc ncurses-utils file ossp-uuid uuid-utils less zsh boxes figlet ruby clang tree jq ripgrep coreutils xz-utils just fzf gum silversearcher-ag grep brotli toilet binutils python-pip bzip2 neofetch
PACKAGEBASH_DEBIAN := curl python3.13 python3.13-venv python3-pip bc ncurses-bin file ossp-uuid uuid-runtime less zsh boxes figlet ruby clang tree jq ripgrep coreutils xz-utils fzf silversearcher-ag grep brotli toilet binutils bzip2 neofetch
PACKAGEBASH_UBUNTU := $(PACKAGEBASH_DEBIAN)
PACKAGEPY := dns-client requests bs4 rich pycryptodome rich-cli certifi npyscreen prompt_toolkit requests lzstring faker phonenumbers blessed geopy cloudscraper emoji fuzzywuzzy textual
TERMUX_PATH := /data/data/com.termux/files/usr/bin/bash

detectCLI:
	@echo "[?] Mengecek lingkungan..."
	@if [ -f "$(TERMUX_PATH)" ]; then \
		echo "[✓] Termux terdeteksi!"; \
		OS_TYPE="termux"; \
	elif [ -f "/etc/debian_version" ]; then \
		grep -qi ubuntu /etc/os-release && OS_TYPE="ubuntu" || OS_TYPE="debian"; \
		echo "[✓] $$OS_TYPE terdeteksi!"; \
	else \
		echo "[!] OS tidak didukung!"; \
		exit 1; \
	fi; \
	echo $$OS_TYPE > .os_type

install-system: detectCLI
	@pip install textual 
	@pip install --upgrade textual
	@OS_TYPE=$$(cat .os_type); \
	echo "[?] Menginstall package..."; \
	if [ "$$OS_TYPE" = "termux" ]; then \
		PACKAGES="$(PACKAGEBASH_TERMUX)"; \
		INSTALL_CMD="pkg install -y"; \
	else \
		PACKAGES="$(PACKAGEBASH_DEBIAN)"; \
		INSTALL_CMD="sudo apt-get install -y"; \
		sudo apt-get update; \
	fi; \
	for pkg in $$PACKAGES; do \
		echo "[>] $$pkg"; \
		yes | $$INSTALL_CMD $$pkg >/dev/null 2>&1; \
	done

prepare-venv: detectCLI
	@OS_TYPE=$$(cat .os_type); \
	if [ "$$OS_TYPE" = "termux" ]; then \
		exit 0; \
	fi; \
	echo "[>] Mengatur permission project..."; \
	sudo chown -R $$(whoami):$$(whoami) "$$(pwd)"; \
	if ! command -v python3.13 >/dev/null 2>&1; then \
		echo ""; \
		echo "[✗] Python 3.13 tidak ditemukan."; \
		exit 1; \
	fi; \
	PYVER=$$(python3.13 -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}")'); \
	if [ "$$PYVER" != "3.13" ]; then \
		echo "[✗] Python harus versi 3.13"; \
		exit 1; \
	fi; \
	if [ ! -d venv ]; then \
		echo "[>] Membuat Virtual Environment..."; \
		python3.13 -m venv venv; \
	fi; \
	. venv/bin/activate && \
	pip install --upgrade pip setuptools wheel

install-py: detectCLI prepare-venv
	@OS_TYPE=$$(cat .os_type); \
	if [ "$$OS_TYPE" = "termux" ]; then \
		echo "[>] Install Python Package (Termux)..."; \
		pip install $(PACKAGEPY); \
	else \
		echo "[>] Install Python Package (VENV)..."; \
		. venv/bin/activate && \
		pip install $(PACKAGEPY); \
	fi

update: detectCLI
	@echo "[>] Update repository..."
	@cd && rm -rf Checker-Scammer
	@git clone https://github.com/ViewTechOrg/Checker-Scammer
	@cd Checker-Scammer && make install && just run

fix: detectCLI
	@OS_TYPE=$$(cat .os_type); \
	if [ "$$OS_TYPE" = "termux" ]; then \
		pip uninstall requests -y; \
		pip uninstall psutil -y; \
		pip install requests; \
		pip install "urllib3<2"; \
	else \
		. venv/bin/activate && \
		pip uninstall requests -y && \
		pip uninstall psutil -y && \
		pip install requests && \
		pip install "urllib3<2"; \
	fi

install: install-system prepare-venv install-py

all: install

.PHONY: detectCLI install-system prepare-venv install-py update fix install all
