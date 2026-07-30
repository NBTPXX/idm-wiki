# IDM Klipper 模块自动更新

在 `moonraker.conf` 中添加以下配置，以便通过 Moonraker 自动更新 IDM Klipper 模块：

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

[← 返回首页](INDEX.html)
