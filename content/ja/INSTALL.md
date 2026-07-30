# インストールガイド

## 必要条件

- Klipper を実行するホスト (Raspberry Pi、Orange Pi、Debian/Ubuntu など)
- Python 3.7 以降
- pyserial (pip または Klipper に同梱)

## ソースコードの取得

```bash
# Gitee
git clone https://gitee.com/NBTP/idm-documents.git

# GitHub ミラー
git clone https://github.com/NBTPXX/idm-documents.git
```

## インストール方法

### ワンクリックインストール

```bash
cd ~/idm-documents/flash_web
./install.sh
```

インストールスクリプトは、実行権限、Moonraker update_manager、管理対象サービス、systemd の自動起動、Web サービスの開始を設定します。Web サービスのポートは `8888` です。

### 一時的な手動起動

```bash
cd ~/idm-documents/flash_web
python3 server.py
```

## インストール確認

```bash
curl http://<printer-ip>:8888/api/env
```

ブラウザで `http://<printer-ip>:8888` を開きます。

## アンインストール

```bash
cd ~/idm-documents/flash_web
./uninstall.sh
```

---

[ホームに戻る](INDEX.html)
