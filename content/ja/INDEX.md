# IDM Flash Web ユーザーマニュアル

IDM Flash Web は、IDM 3D プリンターセンサー用のブラウザベースのファームウェア書き込みツールです。CAN、USB シリアル、DFU 接続モードに対応します。

![メイン画面](../images/main-ui.svg)

## 目次

- [インストールガイド](INSTALL.html)
- [Moonraker 連携](MOONRAKER.html)
- [CAN モード書き込み](CAN_FLASH.html)
- [USB モード書き込み](USB_FLASH.html)
- [DFU モード書き込み](DFU_FLASH.html)

## 対応モード

| モード | 用途 | 通信方式 |
|------|------|----------|
| CAN | CAN バス接続のデバイス | CAN socket |
| USB | USB シリアル接続のデバイス | Serial (Katapult) |
| DFU | USB DFU モードのデバイス | dfu-util |

## クイックスタート

1. [インストールガイド](INSTALL.html)に従って IDM Flash Web を起動します
2. プリンターをホストに接続します
3. `http://<printer-ip>:8888` を開きます
4. 接続方法に合わせて CAN、USB、DFU を選択します
5. ファームウェアを選び、書き込みを開始します

---

[IDM Flash Web 書き込みツール](http://localhost:8888)
