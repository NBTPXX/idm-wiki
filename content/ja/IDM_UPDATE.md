# IDM Klipper モジュールの自動更新

Moonraker が IDM Klipper モジュールを自動更新できるように、`moonraker.conf` に次の設定を追加します。

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

[ホームに戻る](INDEX.html)
