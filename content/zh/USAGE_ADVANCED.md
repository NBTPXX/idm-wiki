# 高级功能

## 温度补偿优化

IDM 内置温度补偿，可通过数据采集优化参数（耗时约 1 小时）。

### 数据采集

确保 `printer.cfg` 中有 `[temperature_sensor IDM_coil]`，执行：

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

数据文件生成于 `/tmp/data1`、`/tmp/data2`、`/tmp/data3`。

### 计算参数

```bash
~/klippy-env/bin/python ~/IDM/arg_fit.py
```

查看 `fit_result.png`，补偿后数据接近水平线即为成功。

---

## 加速度计

IDM 内置加速度计，用于共振补偿。

**lis2dw 方形芯片**：

```ini
[lis2dw]
cs_pin: idm:PA15
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points: 150,150,20
```

**adxl345 长方形芯片**：

```ini
[adxl345]
cs_pin: idm:PA15
spi_bus: spi1
axes_map: x,y,z

[resonance_tester]
accel_chip: adxl345
probe_points: 150,150,20
```

执行共振测量：
```gcode
SHAPER_CALIBRATE AXIS=X
SHAPER_CALIBRATE AXIS=Y
SAVE_CONFIG
```

---

## 热床网格

```ini
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 15, 15
mesh_max: 235, 235
probe_count: 5, 5
algorithm: bicubic
zero_reference_position: 150, 150    # Touch 模式必须配置
```

执行：
```gcode
BED_MESH_CALIBRATE
BED_MESH_PROFILE SAVE=default
SAVE_CONFIG
```

### 自适应网格

```gcode
BED_MESH_CALIBRATE ADAPTIVE=1
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
BED_MESH_CALIBRATE ADAPTIVE=1
```

---

## Moonraker 自动更新

```ini
[update_manager idm]
type: git_repo
channel: dev
path: ~/IDM
origin: https://gitee.com/NBTP/IDM.git
env: ~/klippy-env/bin/python
requirements: requirements.txt
install_script: install.sh
is_system_service: False
managed_services: klipper
info_tags:
  desc=idm
```

---

## 故障排查

| 问题 | 可能原因 | 解决方法 |
|------|---------|---------|
| 探测失败 | 传感器镜头脏污 | 用酒精棉清洁镜头 |
| Z 偏移漂移 | 温度变化 | 在打印温度下校准；配置温补参数 |
| "IDM model convergence" 报错 | model_offset 过大 | `IDM_MODEL REMOVE=default` 后重新校准 |
| "no model" 归零报错 | 配置格式错误 | 检查缩进和段名语法 |
| 网床扫描异常 | 热床电磁干扰 | 配置热床关闭宏；检查传感器安装稳固 |
| CAN 通讯超时 | 频率不匹配 / 接线松动 | 检查频率和终端电阻；确认无 serial 行 |
| UUID 无法获取 | 设备未进入 BL 模式 | 通过 CAN 发送 reboot 或重新上电 |

---

[← 返回首页](INDEX.html)
