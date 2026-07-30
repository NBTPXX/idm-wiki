# キャリブレーション

## Z 位置の初期化

キャリブレーション前に、初期 Z 位置を設定します。

1. `G28 X Y` を実行します。Z はホームしません
2. ノズルをベッド中央へ移動します
3. `SET_KINEMATIC_POSITION z=80` を実行します
4. 紙を使い、ノズルがベッドに触れるまで手動で下げます
5. `SET_KINEMATIC_POSITION z=0` を実行します

## 手動キャリブレーション (Scan モード)

```gcode
IDM_CALIBRATE
```

## Touch モード

Touch モードはノズルとベッドの接触でキャリブレーションします。すべてのベッド表面に使用できます。

```gcode
IDM_TOUCH METHOD=MANUAL
G28
IDM_THRESHOLD_SCAN MIN=500
SAVE_TOUCH_OFFSET
PROBE_CALIBRATE METHOD=AUTO
```

印刷開始マクロには以下を追加します。

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
```

## Second Probe モード

TAP または機械式エンドストップを Z ホーミングと自動 Z オフセットキャリブレーションに使用します。

```ini
[scanner]
calibration_method: second_probe
z_offset: 0
probe_speed: 10
probe_pin:
```

| 設定 | 説明 |
|------|------|
| `calibration_method` | `second_probe` を指定して有効化 |
| `z_offset` | ノズル基準の固定トリガー高さオフセット |
| `probe_speed` | キャリブレーション時の Z 軸速度。15 mm/s 以下を推奨 |
| `probe_pin` | TAP または機械式エンドストップの実際のトリガーピン |

設定を保存して Klipper を再起動し、プローブが正しく動作することを確認します。

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
SAVE_TOUCH_OFFSET
```

## 複数モデルの管理

| コマンド | 説明 |
|---------|------|
| `IDM_MODEL_SAVE NAME=<name>` | 現在のキャリブレーションを保存 |
| `IDM_MODEL_SELECT NAME=<name>` | 保存済みキャリブレーションを読み込み |
| `IDM_MODEL_LIST` | キャリブレーション一覧を表示 |
| `IDM_MODEL_REMOVE NAME=<name>` | キャリブレーションを削除 |

---

[ホームに戻る](INDEX.html)
