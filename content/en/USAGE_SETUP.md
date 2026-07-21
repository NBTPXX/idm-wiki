# Setup & Configuration

## Overview

IDM (Integrated Distance Monitor) is a contactless bed leveling sensor for 3D printers, featuring built-in accelerometer and temperature sensor. Communicates with Klipper via CAN or USB.

## Software Installation

```bash
cd ~
git clone https://gitee.com/NBTP/IDM.git
cd IDM
~/klippy-env/bin/pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
./install.sh
```

## Complete Configuration

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

# Touch mode settings
scanner_touch_max_temp: 180
scanner_touch_speed: 5
scanner_touch_accel: 100

# Temperature compensation
temperature_compensation: True
```

## Required Settings

**Enable force_move (required)**:

```ini
[force_move]
enable_force_move: True
```

**Update Z endstop**:

```ini
[stepper_z]
endstop_pin: probe:z_virtual_endstop
```

**Safe Z homing**:

```ini
[safe_z_home]
home_xy_position: 150, 150
speed: 50
z_hop: 10
z_hop_speed: 5
```

Remove existing `[probe]` section. For CAN mode, remove any `serial:` line.

## MCU Configuration

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899

[temperature_sensor idm_temp]
sensor_type: temperature_mcu
sensor_mcu: idm
min_temp: 0
max_temp: 100
```

### Get CAN UUID

```bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

### List Serial Ports (USB mode)

```bash
ls /dev/serial/by-id/*
```

---

[← Back to Home](INDEX.html)
