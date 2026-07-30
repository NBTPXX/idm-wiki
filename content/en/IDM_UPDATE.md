# IDM Klipper Module Auto-Update

Add the following configuration to `moonraker.conf` so Moonraker can automatically update the IDM Klipper module:

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

[← Back to Home](INDEX.html)
