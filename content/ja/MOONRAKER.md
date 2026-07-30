# Moonraker 連携

IDM Flash Web は Klipper エコシステムの Moonraker API と連携します。

## 機能

- オンライン更新: Fluidd/Mainsail の Update Manager から更新
- サービス管理: Services パネルからサービス状態を表示、開始、停止
- 状態表示: Moonraker API でプリンターの接続状態を取得

![Fluidd Update Manager の IDM Flash Web](../images/system-architecture.svg)

## 自動設定

`install.sh` 実行後に以下が自動設定されます。

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

`~/printer_data/moonraker.asvc` に `idm_flash_web` を追加します。自動設定が完了しない場合は、上記設定を手動で追加します。

---

[ホームに戻る](INDEX.html)
