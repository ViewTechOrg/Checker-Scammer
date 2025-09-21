# version 0.0.1
# created by : Team ViewTech
# date       : 2025-06-05 | 08.47 WIB
# developer  : Xenzi & Polygon (pejuang kentang)
########################################
# Daftar package per OS
PACKAGEBASH_TERMUX := curl python bc ncurses-utils file ossp-uuid uuid-utils less zsh boxes figlet ruby clang tree jq ripgrep coreutils xz-utils just fzf gum silversearcher-ag grep brotli toilet binutils python-pip bzip2 neofetch
PACKAGEBASH_DEBIAN := curl python3 bc ncurses-bin file ossp-uuid uuid-runtime less zsh boxes figlet ruby clang tree jq ripgrep coreutils xz-utils fzf silversearcher-ag grep brotli toilet binutils python3-pip bzip2 neofetch
PACKAGEBASH_UBUNTU := $(PACKAGEBASH_DEBIAN)

PACKAGEPY := dns-client requests bs4 rich pycryptodome rich-cli certifi npyscreen prompt_toolkit requests faker phonenumbers blessed

TERMUX_PATH := /data/data/com.termux/files/usr/bin/bash
PYTHON_VERSION := $(shell python -V | sed 's/[[:space:]]//g' | cut -c 1-10 | tr '[:upper:]' '[:lower:]')

# cek os type
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

# install package for bash
install-system: detectCLI
	@echo "[?] Menginstall package dari bash..."
	@OS_TYPE=$$(cat .os_type); \
	if [ "$$OS_TYPE" = "termux" ]; then \
		PACKAGES="$(PACKAGEBASH_TERMUX)"; \
		INSTALL_CMD="pkg install -y"; \
	elif [ "$$OS_TYPE" = "debian" ] || [ "$$OS_TYPE" = "ubuntu" ]; then \
		PACKAGES="$(PACKAGEBASH_DEBIAN)"; \
		INSTALL_CMD="sudo apt-get install -y"; \
	fi; \
	for pkg in $$PACKAGES; do \
		echo "[>] Menginstall $$pkg..."; \
		$$INSTALL_CMD $$pkg >/dev/null 2>&1; \
		if command -v $$pkg >/dev/null 2>&1 || dpkg -l | grep -qw $$pkg; then \
			echo "[✓] Berhasil menginstall $$pkg"; \
		else \
			echo "[✗] Gagal menginstall $$pkg"; \
			echo "[!] Jalankan manual: $$INSTALL_CMD $$pkg"; \
		fi; \
	done

# install package for python
install-py: detectCLI
	@OS_TYPE=$$(cat .os_type); \
	if command -v python3 >/dev/null 2>&1; then \
		echo "[✓] Python3 ditemukan"; \
		echo "[>] Menginstall Python package: $(PACKAGEPY)..."; \
		pip install $(PACKAGEPY); \
		echo "[>] Python Berhasil DI setup"; \
	else \
		echo "[✗] Python3 tidak ditemukan! Silakan install terlebih dahulu."; \
	fi

	@if ! test -d "$$HOME/.local"; then \
		mkdir "$$HOME/.local"; \
	fi

# UPDATE REPO 
update: detectCLI
	@echo "[>] Melakukan update ..";sleep 1
	@git pull

install: install-system install-py

fix:
	rm -rf $$PREFIX/lib/$(PYTHON_VERSION)/site-packages/requests
	pip uninstall requests -y
	pip uninstall psutil -y
	pip install requests

all: install

.PHONY: detectCLI install-system install-py update fix install all
