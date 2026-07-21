# Moonraker Integration

IDM Flash Web can integrate with the Klipper ecosystem's Moonraker API.

## Automatic Configuration

Automatically configured after running install.sh:

### update_manager (moonraker.conf)

```ini
[update_manager idm_flash_web]
type: git_repo
channel: dev
path: ~/idm-documents
origin: https://gitee.com/NBTP/idm-documents.git
is_system_service: False
managed_services: idm_flash_web
info_tags:
    desc=IDM Flash Web Tool
```

### moonraker.asvc

Adds idm_flash_web to ~/printer_data/moonraker.asvc.

## Features

- Online updates: One-click update in Fluidd/Mainsail Update Manager
- Service management: View and start/stop services in the Services panel
- Status viewing: Get printer connection status via Moonraker API

## Manual Configuration

If automatic configuration fails, you can manually add the above configuration.

---

[← Back to Home](INDEX.html)
