# USB モード書き込み

USB モードはシリアルポートで通信し、USB シリアル接続の IDM センサーに使用します。

![USB モード書き込み画面](../images/usb-workflow.svg)

## シリアルポートの選択

- **Serial Port**: 通常のデバイスポートを選択します。例: `/dev/serial/by-id/usb-idm_idm_...`
- **Bootloader Serial**: ブートローダー移行後のシリアルポートです。すでに BL モードの場合は直接入力します

デバイス一覧には `IDM` を含むデバイスのみ表示されます。

## ファームウェアの選択

USB モードでは周波数によるフィルターを行わず、すべてのファームウェアを表示します。

## ブートローダーの開始と終了

- **Enter BL**: デバイスへブートローダー再起動を要求します
- **Exit BL**: DTR 切り替えを使わず、prime、CONNECT、COMPLETE の順に実行します

## ブートローダーの自動検出

`Detect BL` を押すと、現在のポートと `/dev/serial/by-id/*`、`/dev/ttyUSB*`、`/dev/ttyACM*` をスキャンします。名前に `katapult` または `canboot` を含むデバイスをブートローダーとして識別します。

## 書き込み手順

1. USB モードを選択します
2. シリアルポートを選択するか Bootloader Serial を入力します
3. ファームウェア種別、バージョン、ファイルを選択します
4. 必要に応じて `Enter BL` を押します
5. `Detect BL` でブートローダーポートを確認します
6. `Start Flashing` を押します
7. コンソール出力で完了を確認します

---

[ホームに戻る](INDEX.html)
