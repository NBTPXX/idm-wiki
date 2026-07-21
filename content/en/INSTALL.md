# Installation Guide

## Requirements

- Host running Klipper (Raspberry Pi, Orange Pi, etc., Debian/Ubuntu)
- Python 3.7+
- pyserial (installed via pip or bundled with Klipper)

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
curl http://localhost:8888/api/env
```

## Access the Web Interface

Open in browser: `http://<printer-ip>:8888`

Fluidd/Mainsail iframe embedding:

```html
<iframe src="http://localhost:8888" style="width:100%;height:100vh"></iframe>
```

## Uninstall

```bash
cd ~/idm-documents/flash_web
./uninstall.sh
```

---

[← Back to Home](INDEX.html)
