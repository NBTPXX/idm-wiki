# Автообновление модуля IDM Klipper

Добавьте эту конфигурацию в `moonraker.conf`, чтобы Moonraker автоматически обновлял модуль IDM Klipper.

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

---

[Вернуться на главную](INDEX.html)
