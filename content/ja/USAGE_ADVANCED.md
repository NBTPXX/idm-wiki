# 高度な機能

## 温度補償の最適化

IDM は温度補償を内蔵しています。データ収集によりパラメーターを最適化できます。処理時間は約 1 時間です。

### データ収集

`printer.cfg` に以下のマクロを追加します。

```ini
[gcode_macro DATA_SAMPLE]
gcode:
  {% set bed_temp = params.BED_TEMP|default(90)|int %}
  {% set nozzle_temp = params.NOZZLE_TEMP|default(250)|int %}
  {% set min_temp = params.MIN_TEMP|default(40)|int %}
  {% set max_temp = params.MAX_TEMP|default(70)|int %}
  M106 S255
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MAXIMUM={min_temp}
  M106 S0
  G28
  G0 Z1
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MINIMUM={min_temp}
  IDM_STREAM FILENAME=/tmp/data1
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MINIMUM={max_temp}
  IDM_STREAM FILENAME=/tmp/data1
  M104 S0
  M140 S0
```

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

生成されたデータファイルを `~/IDM` へ移動して実行します。

```bash
cd ~/IDM
~/klippy-env/bin/python arg_fit.py
```

`fit_result.png` を確認し、補償後のオフセットが 3 桁以内であることを確認します。

## ベッドメッシュ

```ini
[bed_mesh]
zero_reference_position: 125, 125
```

500W 以上の AC ヒーターベッドでは、プロービング中にヒーターを停止します。

```ini
[gcode_macro BED_MESH_CALIBRATE]
rename_existing: _BED_MESH_CALIBRATE
gcode:
    {% set TARGET_TEMP = printer.heater_bed.target %}
    M140 S0
    _BED_MESH_CALIBRATE {rawparams}
    M140 S{TARGET_TEMP}
```

## 印刷開始 G-code

`PRINT_START` マクロの末尾に追加します。

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
```

## トラブルシューティング

| 問題 | 原因 | 対処 |
|------|------|------|
| Z オフセットの変動 | 温度変化 | 印刷温度でキャリブレーションし、温度補償を設定 |
| `IDM model convergence` エラー | model_offset が大きすぎる | `model_offset` を `0` にして Z オフセットを再調整 |
| `no model` ホーミングエラー | 設定形式のエラー | インデントとセクション名を確認 |
| ベッドメッシュの異常 | ベッドヒーターの EMI | ヒーター停止マクロとセンサー取付を確認 |
| CAN 通信失敗 | 周波数または UUID の誤り | ファームウェア周波数、UUID、`serial:` 設定を確認 |

---

[ホームに戻る](INDEX.html)
