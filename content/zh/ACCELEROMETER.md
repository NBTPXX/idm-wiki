# 加速度计

IDM 内置加速度计，可用于共振测量。加速度计配置必须放在 IDM 配置之后。

## lis2dw 版本（方形芯片）

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points:
    125, 125, 20  # 设置为进行共振测量时喷头所处坐标
```

## adxl345 版本（长方形芯片）

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points:
    125, 125, 20  # 设置为进行共振测量时喷头所处坐标
```

## 共振测量

配置完成后执行：

```gcode
SHAPER_CALIBRATE
```

---

[← 返回首页](INDEX.html)
