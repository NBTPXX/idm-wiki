# Installation Guide

## Requirements

- Host running Klipper (Raspberry Pi, Orange Pi, etc., Debian/Ubuntu)
- Python 3.7+
- pyserial (installed via pip or bundled with Klipper)

## Get Source Code

```bash
# Gitee (primary)
git clone https://gitee.com/NBTP/idm-documents.git

# GitHub (mirror, auto-synced)
git clone https://github.com/NBTPXX/idm-documents.git
```

## One-Click Install

```bash
cd ~/idm-documents/flash_web
./install.sh
```

The install script automatically:

1. Sets executable permissions
2. Configures Moonraker update_manager (supports online updates)
3. Adds managed_services configuration
4. Installs systemd service with auto-start
5. Starts the web service (port 8888)

## Manual Start

```bash
cd ~/idm-documents/flash_web
python3 server.py
```

## Verify Installation

```bash
curl http://<printer-ip>:8888/api/env
```

## Access the Web Interface

Open in browser: `http://<printer-ip>:8888`

## Uninstall

```bash
cd ~/idm-documents/flash_web
./uninstall.sh
```

---

[← Back to Home](INDEX.html)
