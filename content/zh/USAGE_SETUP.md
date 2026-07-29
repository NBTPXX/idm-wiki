# 安装与配置

## 简介

IDM（Integrated Distance Monitor）是非接触式 3D 打印机调平传感器，内置加速度计和温度传感器，通过 CAN 或 USB 与 Klipper 通信。

## 软件安装

```bash
cd ~
git clone https://gitee.com/NBTP/IDM.git
cd IDM
~/klippy-env/bin/pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
./install.sh
```

## 获取设备标识

根据连接方式获取 MCU 标识。

### CAN 模式

```bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

### USB 模式

```bash
ls /dev/serial/by-id/*
```

## MCU 配置

CAN 模式：

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899              # 替换为你的设备 UUID
```

USB 模式：

```ini
[mcu idm]
serial: /dev/serial/by-id/<device-id>  # 替换为你的设备路径
```

添加 MCU 温度传感器：

```ini
[temperature_sensor idm_temp]
sensor_type: temperature_mcu
sensor_mcu: idm
min_temp: 0
max_temp: 100
```

## 必要配置项

**启用 force_move**（必须）：

```ini
[force_move]
enable_force_move: True
```

**修改 Z 限位**：

```ini
[stepper_z]
endstop_pin: probe:z_virtual_endstop
```

**安全归零**：

```ini
[safe_z_home]
home_xy_position: 150, 150
speed: 50
z_hop: 10
z_hop_speed: 5
```

删除原有的 `[probe]` 模块。CAN 版不配置 `serial:`，USB 版使用设备串口路径。

## Scanner 完整配置

```ini
[scanner]
mcu: idm
sensor: idm
calibration_method: touch             # touch / scan / second_probe
speed: 40
lift_speed: 5
backlash_comp: 0.5
x_offset: 0
y_offset: 21.1
trigger_distance: 2
trigger_dive_threshold: 1.5
trigger_hysteresis: 0.006
cal_nozzle_z: 0.1
cal_floor: 0.1
cal_ceil: 5
cal_speed: 1.0
cal_move_speed: 10
default_model_name: default
mesh_main_direction: x
mesh_overscan: 3
mesh_cluster_size: 1
mesh_runs: 1

# Touch 模式专用
scanner_touch_max_temp: 180
scanner_touch_speed: 5
scanner_touch_accel: 100
```

---

[← 返回首页](INDEX.html)
