# 高级功能

## 温度补偿优化

IDM 内置温度补偿，可通过数据采集优化参数（耗时约 1 小时）。

### 数据采集

将以下宏添加到 `printer.cfg`：

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
  M106 S255
  G0 Z80
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MAXIMUM={min_temp}
  M106 S0
  G28 Z0
  G0 Z2
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  G4 P1000
  IDM_STREAM FILENAME=/tmp/data2
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MINIMUM={max_temp}
  IDM_STREAM FILENAME=/tmp/data2
  M104 S0
  M140 S0
  M106 S255
  G0 Z80
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MAXIMUM={min_temp}
  M106 S0
  G28 Z0
  G0 Z3
  M104 S{nozzle_temp}
  M140 S{bed_temp}
  G4 P1000
  IDM_STREAM FILENAME=/tmp/data3
  TEMPERATURE_WAIT SENSOR='temperature_sensor IDM_coil' MINIMUM={max_temp}
  IDM_STREAM FILENAME=/tmp/data3
  M104 S0
  M140 S0
```

执行：

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

数据文件生成于 `/tmp/data1`、`/tmp/data2`、`/tmp/data3`。

### 计算参数

将三个数据文件移动到 `~/IDM`，然后执行：

```bash
cd ~/IDM
~/klippy-env/bin/python arg_fit.py
```

查看 `fit_result.png`，确认补偿后的偏移量控制在三位数以内。

---

## 加速度计

IDM 内置加速度计，用于共振补偿。

**lis2dw 方形芯片**：

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points: 125,125,20
```

**adxl345 长方形芯片**：

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points: 125,125,20
```

执行共振测量：
```gcode
SHAPER_CALIBRATE
```

---

## 热床网格

```ini
[bed_mesh]
zero_reference_position: 125, 125    # 设置为热床正中心坐标
```

### 大功率热床宏

交流热床（500W+）需在探测前关闭热床：

```ini
[gcode_macro BED_MESH_CALIBRATE]
rename_existing: _BED_MESH_CALIBRATE
gcode:
    {% set TARGET_TEMP = printer.heater_bed.target %}
    M140 S0
    _BED_MESH_CALIBRATE {rawparams}
    M140 S{TARGET_TEMP}
```

---

## 打印起始 G-code

在 `PRINT_START` 宏末尾添加：

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
```

---

## 故障排查

| 问题 | 可能原因 | 解决方法 |
|------|---------|---------|
| Z 偏移漂移 | 温度变化 | 在打印温度下校准；配置温补参数 |
| "IDM model convergence" 报错 | model_offset 过大 | 将 `model_offset` 设为 `0` 后重新调整 Z 偏移 |
| "no model" 归零报错 | 配置格式错误 | 检查缩进和段名语法 |
| 网床扫描异常 | 热床电磁干扰 | 配置热床关闭宏；检查传感器安装稳固 |
| CAN 通讯失败 | 频率或 UUID 配置错误 | 检查固件频率，重新查询 UUID，并确认无 `serial:` 行 |

---

[← 返回首页](INDEX.html)
