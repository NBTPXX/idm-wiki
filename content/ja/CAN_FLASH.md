# CAN モード書き込み

CAN モードは SocketCAN を使い、CAN バスに接続された IDM センサーと通信します。

## CAN 周波数の選択

ファームウェアのビルドに合わせて選択します。

| 選択値 | 周波数 | 説明 |
|--------|--------|------|
| 1000000 | 1M | 高速 |
| 500000 | 500k | 中速 |
| 250000 | 250k | 低速 |
| Other | - | 周波数タグがないファームウェア |

## ファームウェア種別

- **IDM Main Firmware (main)**: 標準のセンサー動作ファームウェア
- **Bootloader Override Firmware (deployer)**: 初回導入時に既存ブートローダーを置き換えるファームウェア

## ブートローダーの開始と終了

- **Enter BL**: CAN UUID を入力し、管理 ID `0x3f0` に `KLIPPER_REBOOT_CMD` を送信します
- **Exit BL**: clear node、node ID 設定、CONNECT、COMPLETE の順に実行します

![CAN モード書き込み画面](../images/can-workflow.svg)

## CAN UUID の照会

書き込みには 6 バイトの UUID が必要です。`Query` を押すと CAN バス上の Katapult ノードをスキャンします。

- デバイスが Katapult ブートローダーモードであること
- CAN インターフェース (例: `can0`) が設定され有効であること

## 書き込み手順

1. CAN モードを選択します
2. 周波数とファームウェア種別を選択します
3. バージョンとファイルを選択します
4. 稼働中デバイスでは UUID を入力して `Enter BL` を押します
5. `Query` で CAN UUID を取得します
6. `Start Flashing` を押します
7. コンソール出力で完了を確認します

---

[ホームに戻る](INDEX.html)
