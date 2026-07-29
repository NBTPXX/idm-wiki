# Moonraker Integration

IDM Flash Web can integrate with the Klipper ecosystem's Moonraker API.

## Features

- Online updates: One-click update in Fluidd/Mainsail Update Manager
- Service management: View and start/stop services in the Services panel
- Status viewing: Get printer connection status via Moonraker API

![IDM Flash Web in Fluidd Update Manager](../images/system-architecture.svg)

## Automatic Configuration

Automatically configured after running install.sh:

### IDM Flash Web Updates

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

### IDM Klipper Module Updates

```ini
[update_manager idm]
type: git_repo
channel: dev
path: ~/IDM
origin: https://gitee.com/NBTP/IDM.git
env: ~/klippy-env/bin/python
requirements: requirements.txt
install_script: install.sh
is_system_service: False
managed_services: klipper
info_tags:
  desc=idm
```

### moonraker.asvc

Adds idm_flash_web to ~/printer_data/moonraker.asvc.

## Manual Configuration

If automatic configuration fails, you can manually add the above configuration.

---

[← Back to Home](INDEX.html)
