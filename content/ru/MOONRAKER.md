# Интеграция с Moonraker

IDM Flash Web интегрируется с Moonraker API в экосистеме Klipper.

## Возможности

- Онлайн-обновления через Update Manager Fluidd/Mainsail
- Управление службами: просмотр, запуск и остановка в панели Services
- Просмотр статуса подключения принтера через Moonraker API

![IDM Flash Web в Fluidd Update Manager](../images/system-architecture.svg)

## Автоматическая конфигурация

После запуска `install.sh` добавляется следующая настройка:

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

В `~/printer_data/moonraker.asvc` добавляется `idm_flash_web`. При ошибке автоматической настройки добавьте конфигурацию вручную.

---

[Вернуться на главную](INDEX.html)
