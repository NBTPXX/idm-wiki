# 加速度計

IDM には共振測定用の加速度計が内蔵されています。IDM 設定の後に加速度計設定を配置します。

## lis2dw バージョン (正方形チップ)

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points:
    125, 125, 20
```

## adxl345 バージョン (長方形チップ)

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points:
    125, 125, 20
```

## 共振測定

```gcode
SHAPER_CALIBRATE
```

---

[ホームに戻る](INDEX.html)
