# 校准

## 初始化 Z 位置

校准前先设置 Z 轴初始位置：

1. 执行 `G28 X Y`（仅归零 XY，不要归零 Z）
2. 移动喷嘴到热床中央
3. 执行 `SET_KINEMATIC_POSITION z=80`
4. 手动降低喷嘴至贴床（垫 A4 纸），感到轻微阻力即可
5. 执行 `SET_KINEMATIC_POSITION z=0`

## 手动校准（Scan 模式）

```gcode
IDM_CALIBRATE
```

## Touch 模式

Touch 模式利用喷嘴接触热床来校准，适用于各种热床表面。

### 第 1 步：初次手动校准

```gcode
IDM_TOUCH METHOD=MANUAL
```

在弹出的偏移控制框中，将喷头降到喷嘴贴热床，然后点击 -0.1 偏移并确认。

### 第 2 步：归零

```gcode
G28
```

### 第 3 步：Touch 阈值校准

```gcode
IDM_THRESHOLD_SCAN MIN=500
```

### 第 4 步：保存固定 Z 偏移补偿

```gcode
SAVE_TOUCH_OFFSET
```

### 第 5 步：自动 Z 偏移测量

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

### 第 6 步：配置打印起始 G-code

打印起始 G-code 只需要：

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

完整流程参见[高级功能](USAGE_ADVANCED.html)。

## Second Probe 模式

Second Probe 模式使用 TAP 或机械限位开关触发 Z 归零和自动 Z 偏移校准，适用于使用外部接触触发器的设备。

### 配置

在 `[scanner]` 中添加：

```ini
calibration_method: second_probe
z_offset: 0
probe_speed: 10
probe_pin:
```

| 参数 | 说明 |
|------|------|
| `calibration_method` | 设置为 `second_probe`，启用第二探针触发方式 |
| `z_offset` | 第二探针触发高度相对于喷嘴的固定偏移；TAP 需测量实际值 |
| `probe_speed` | 校准时的 Z 轴移动速度，建议不超过 15 mm/s |
| `probe_pin` | TAP 或机械限位开关的实际触发引脚 |

保存配置并重启 Klipper，然后确认第二探针能够正常触发。

### 执行校准

```gcode
IDM_TOUCH CALIBRATE=1
```

### Z 偏移校准

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

### 固定 Z 偏移补偿

在网页界面中微调 Z 偏移，喷嘴高度合适后保存固定补偿：

```gcode
SAVE_TOUCH_OFFSET
```

TAP 等触发机构可能产生轻微压缩量。更换喷嘴、热端组件或第二探针后，应重新测定并保存固定补偿。

## 多模型管理

针对不同 PEI 板保存独立校准：

| 命令 | 说明 |
|------|------|
| `IDM_MODEL_SAVE NAME=<name>` | 保存当前校准 |
| `IDM_MODEL_SELECT NAME=<name>` | 载入已保存的校准 |
| `IDM_MODEL_LIST` | 列出所有校准 |
| `IDM_MODEL_REMOVE NAME=<name>` | 删除校准 |

---

[← 返回首页](INDEX.html)
