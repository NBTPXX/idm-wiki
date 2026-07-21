# IDM 使用教程

## 简介

IDM（Integrated Distance Monitor）是非接触式 3D 打印机调平传感器，内置加速度计和温度传感器，通过 CAN 或 USB 与 Klipper 通信。

## 安装

```bash
cd ~
git clone https://gitee.com/NBTP/IDM.git
cd IDM
~/klippy-env/bin/pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
./install.sh
```

## Klipper 配置

### 完整配置示例

```ini
[scanner]
mcu: idm                              # IDM 的 MCU 名称
sensor: idm                           # 传感器类型
calibration_method: touch             # 校准方法: touch / scan / second_probe
speed: 40                             # Z 探测下降速度 (mm/s)
lift_speed: 5                         # 抬升速度
backlash_comp: 0.5                    # 回差补偿距离 (mm)
x_offset: 0                           # X 偏移
y_offset: 21.1                        # Y 偏移
trigger_distance: 2                   # 归零触发距离 (mm)
trigger_dive_threshold: 1.5           # 量程/下潜探测阈值 (mm)
trigger_hysteresis: 0.006             # 触发解除回滞量 (mm)
cal_nozzle_z: 0.1                     # 手动校准后预期喷嘴偏移
cal_floor: 0.1                        # 测量响应曲线 Z 下限 (mm)
cal_ceil: 5                           # 测量响应曲线 Z 上限 (mm)
cal_speed: 1.0                        # 测量响应曲线速度
cal_move_speed: 10                    # 移动到测量位置速度
default_model_name: default           # 默认模型名
mesh_main_direction: x                # 网床扫描主方向
mesh_overscan: 3                      # 扫描线末端过冲距离
mesh_cluster_size: 1                  # 网格点聚类半径
mesh_runs: 1                          # 网床扫描遍历次数

# Touch 模式专用
scanner_touch_max_temp: 180           # Touch 时喷嘴温度
scanner_touch_speed: 5                # Touch 下降速度
scanner_touch_accel: 100              # Touch 加速度

# 温度补偿
temperature_compensation: True
```

### 必要配置项

**启用 force_move**（必须）：

```ini
[force_move]
enable_force_move: True
```

**修改 Z 限位**：

```ini
[stepper_z]
endstop_pin: probe:z_virtual_endstop   # 替换原有限位引脚
```

**安全归零**：

```ini
[safe_z_home]
home_xy_position: 150, 150
speed: 50
z_hop: 10
z_hop_speed: 5
```

**CAN 版去掉 serial 行**，USB 版则保留。

删除原有的 `[probe]` 模块。

### MCU 配置

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899              # 替换为你的设备 UUID

[temperature_sensor idm_temp]
sensor_type: temperature_mcu
sensor_mcu: idm
min_temp: 0
max_temp: 100
```

### 获取 CAN UUID

```bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

### 串口查询（USB 模式）

```bash
ls /dev/serial/by-id/*
```

---

## 校准

### 初始化 Z 位置

校准前先设置 Z 轴初始位置：

1. 执行 `G28 X Y`（仅归零 XY，不要归零 Z）
2. 移动喷嘴到热床中央
3. 执行 `SET_KINEMATIC_POSITION z=80`
4. 手动降低喷嘴至贴床（垫 A4 纸），感到轻微阻力即可
5. 执行 `SET_KINEMATIC_POSITION z=0`

### 手动校准（普通 / scan 模式）

```gcode
IDM_CALIBRATE
# 参照纸片法调整 Z 偏移后保存
ACCEPT
SAVE_CONFIG
```

### Touch 模式

Touch 模式利用喷嘴接触热床来校准，适用于各种热床表面。

**完整工作流**：

1. 手动 Touch：
```gcode
IDM_TOUCH METHOD=MANUAL
# 调整喷嘴刚好贴床，执行
ACCEPT
SAVE_CONFIG
```

2. Touch 阈值校准（归零后执行）：
```gcode
IDM_THRESHOLD_SCAN MIN=500
# 保存调整
SAVE_CONFIG
```

3. 自动 Z 偏移测量：
```gcode
PROBE_CALIBRATE METHOD=AUTO
SAVE_CONFIG
```

4. 保存固定偏移补偿：
```gcode
SAVE_TOUCH_OFFSET
```

5. 打印起始 G-code 中加入自动校准（见后文）。

### Second Probe 模式

使用 TAP 或机械限位开关作为第二探针：

```ini
[scanner]
calibration_method: second_probe
z_offset: 0.5                          # 第二探针触发高度与喷嘴的固定偏移
probe_speed: 1
probe_pin: ...                         # 第二探针限位引脚
```

校准命令：
```gcode
IDM_TOUCH CALIBRATE=1
```

---

## 多模型管理

针对不同 PEI 板保存独立校准：

| 命令 | 说明 |
|------|------|
| `IDM_MODEL_SAVE NAME=<名称>` | 保存当前校准 |
| `IDM_MODEL_SELECT NAME=<名称>` | 载入已保存的校准 |
| `IDM_MODEL_LIST` | 列出所有校准 |
| `IDM_MODEL_REMOVE NAME=<名称>` | 删除校准 |

---

## 温度补偿优化

IDM 内置温度补偿，可通过数据采集优化参数（耗时约 1 小时）。

### 数据采集

确保 `printer.cfg` 中有 `[temperature_sensor IDM_coil]`，执行数据采集宏：

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

数据文件生成于 `/tmp/data1`、`/tmp/data2`、`/tmp/data3`。

### 计算参数

```bash
~/klippy-env/bin/python ~/IDM/arg_fit.py
```

查看生成的 `fit_result.png` 拟合效果图，确认补偿后数据更接近水平线即为成功。

---

## 加速度计

IDM 内置加速度计，用于共振补偿。

**lis2dw 方形芯片配置**：

```ini
[lis2dw]
cs_pin: idm:PA15
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points: 150,150,20
```

**adxl345 长方形芯片配置**：

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

交流热床（500W+）需在探测前关闭热床以避免干扰：

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

在 `PRINT_START` 宏末尾添加自动校准：

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

## 常用命令

| 命令 | 说明 |
|------|------|
| `QUERY_PROBE` | 查询当前探测值 |
| `PROBE` | 执行单次探测 |
| `PROBE_ACCURACY` | 探测精度测试（重复 10 次） |
| `PROBE_CALIBRATE METHOD=AUTO` | 自动 Z 偏移测量 |
| `BED_MESH_CALIBRATE` | 热床网格校准 |
| `IDM_CALIBRATE` | 手动传感器校准 |

---

## 故障排查

| 问题 | 可能原因 | 解决方法 |
|------|---------|---------|
| 探测失败 | 传感器镜头脏污 | 用酒精棉清洁镜头 |
| Z 偏移漂移 | 温度变化 | 在打印温度下校准；配置温补参数 |
| "Internal error: IDM model convergence" | model_offset 过大 | `IDM_MODEL REMOVE=default` 后重新校准 |
| "no model" 归零报错 | 配置格式错误 | 检查缩进和段名语法 |
| 网床扫描异常 | 热床电磁干扰 | 配置热床关闭宏；检查传感器安装稳固 |
| CAN 通讯超时 | 频率不匹配 / 接线松动 | 检查频率设置和终端电阻；确认已删除 serial 行 |
| UUID 无法获取 | 设备未进入 BL 模式 | 通过 CAN 发送 reboot 命令或重新上电 |
| 固件版本过旧 | 功能不兼容 | 使用 IDM Flash Web 更新固件 |

---

[← 返回首页](INDEX.html)
