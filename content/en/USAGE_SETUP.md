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

## Get the Device Identifier

Get the MCU identifier for your connection mode.

### CAN Mode

```bash
~/klippy-env/bin/python ~/klipper/lib/katapult/flashtool.py -i can0 -q
```

### USB Mode

```bash
ls /dev/serial/by-id/*
```

## MCU Configuration

CAN mode:

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899              # Replace with your device UUID
```

USB mode:

```ini
[mcu idm]
serial: /dev/serial/by-id/usb-idm_idm_...  # Replace with your device path
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
home_xy_position: <your_x_center_coordinate>, <your_y_center_coordinate>
z_hop: 10
```

Remove the existing `[probe]` section. Omit `serial:` in CAN mode and use the device serial path in USB mode.

## Complete Scanner Configuration

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
# mesh_overscan: -1
mesh_cluster_size: 1
mesh_runs: 1

# Touch mode settings
scanner_touch_max_temp: 180
scanner_touch_speed: 5
scanner_touch_accel: 100
```

---

[← Back to Home](INDEX.html)
