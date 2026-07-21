# IDM Usage Tutorial

## Overview

IDM (Integrated Distance Monitor) is a contactless bed leveling sensor for 3D printers, featuring built-in accelerometer and temperature sensor. Communicates with Klipper via CAN bus or USB.

## Installation

```bash
cd ~
git clone https://gitee.com/NBTP/IDM.git
cd IDM
~/klippy-env/bin/pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
./install.sh
```

## Klipper Configuration

### Complete Configuration

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

### Required Settings

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

### MCU Configuration

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

## Calibration

### Initialize Z Position

Before calibration, set initial Z position:

1. Run `G28 X Y` (home XY only, do NOT home Z)
2. Move nozzle to bed center
3. Run `SET_KINEMATIC_POSITION z=80`
4. Manually lower nozzle until it touches the bed (use a sheet of paper)
5. Run `SET_KINEMATIC_POSITION z=0`

### Manual Calibration (scan mode)

```gcode
IDM_CALIBRATE
# Adjust Z offset using paper method
ACCEPT
SAVE_CONFIG
```

### Touch Mode

Touch mode uses nozzle-bed contact for calibration, suitable for any bed surface.

**Full workflow**:

1. Manual touch calibration:
```gcode
IDM_TOUCH METHOD=MANUAL
# Adjust nozzle until just touching the bed
ACCEPT
SAVE_CONFIG
```

2. Touch threshold calibration (after homing):
```gcode
IDM_THRESHOLD_SCAN MIN=500
SAVE_CONFIG
```

3. Auto Z offset measurement:
```gcode
PROBE_CALIBRATE METHOD=AUTO
SAVE_CONFIG
```

4. Save fixed offset compensation:
```gcode
SAVE_TOUCH_OFFSET
```

5. Add auto-calibration to print start G-code (see below).

### Second Probe Mode

For TAP or mechanical endstop as a second probe:

```ini
[scanner]
calibration_method: second_probe
z_offset: 0.5
probe_speed: 1
probe_pin: ...
```

Calibration command:
```gcode
IDM_TOUCH CALIBRATE=1
```

---

## Multi-Model Management

Save and switch between calibrations for different PEI sheets:

| Command | Description |
|---------|-------------|
| `IDM_MODEL_SAVE NAME=<name>` | Save current calibration |
| `IDM_MODEL_SELECT NAME=<name>` | Load a saved calibration |
| `IDM_MODEL_LIST` | List all calibrations |
| `IDM_MODEL_REMOVE NAME=<name>` | Delete a calibration |

---

## Temperature Compensation Optimization

IDM has built-in temperature compensation. Parameters can be optimized through data collection (~1 hour).

### Data Collection

Ensure `[temperature_sensor IDM_coil]` is in `printer.cfg`, then run:

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

Data files are generated at `/tmp/data1`, `/tmp/data2`, `/tmp/data3`.

### Calculate Parameters

```bash
~/klippy-env/bin/python ~/IDM/arg_fit.py
```

Check the generated `fit_result.png` — compensated data should be close to horizontal.

---

## Accelerometer

IDM includes a built-in accelerometer for resonance compensation.

**lis2dw (square chip)**:

```ini
[lis2dw]
cs_pin: idm:PA15
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points: 150,150,20
```

**adxl345 (rectangular chip)**:

```ini
[adxl345]
cs_pin: idm:PA15
spi_bus: spi1
axes_map: x,y,z

[resonance_tester]
accel_chip: adxl345
probe_points: 150,150,20
```

Run resonance measurement:
```gcode
SHAPER_CALIBRATE AXIS=X
SHAPER_CALIBRATE AXIS=Y
SAVE_CONFIG
```

---

## Bed Mesh

```ini
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 15, 15
mesh_max: 235, 235
probe_count: 5, 5
algorithm: bicubic
zero_reference_position: 150, 150      # Required for Touch mode
```

Run:
```gcode
BED_MESH_CALIBRATE
BED_MESH_PROFILE SAVE=default
SAVE_CONFIG
```

### Adaptive Mesh

```gcode
BED_MESH_CALIBRATE ADAPTIVE=1
```

### High-Power Bed Macro

For AC heated beds (500W+), disable heater during probing:

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

## Print Start G-code

Add to the end of `PRINT_START` macro:

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
BED_MESH_CALIBRATE ADAPTIVE=1
```

---

## Moonraker Auto Update

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

## Common Commands

| Command | Description |
|---------|-------------|
| `QUERY_PROBE` | Query current probe value |
| `PROBE` | Perform single probe |
| `PROBE_ACCURACY` | Probe accuracy test (10 reps) |
| `PROBE_CALIBRATE METHOD=AUTO` | Auto Z offset measurement |
| `BED_MESH_CALIBRATE` | Bed mesh calibration |
| `IDM_CALIBRATE` | Manual sensor calibration |

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Probe failed | Dirty sensor lens | Clean lens with alcohol wipe |
| Z offset drift | Temperature variation | Calibrate at print temp; configure temp compensation |
| "Internal error: IDM model convergence" | model_offset too large | `IDM_MODEL REMOVE=default` then re-calibrate |
| "no model" homing error | Config format error | Check indentation and section name syntax |
| Bed mesh anomalies | Bed heater EMI | Configure bed-off macro; check sensor mounting |
| CAN communication timeout | Frequency mismatch / loose wiring | Check frequency and termination resistor; ensure no serial line |
| Cannot get UUID | Device not in BL mode | Send reboot via CAN or power cycle |
| Firmware too old | Feature incompatibility | Update firmware via IDM Flash Web |

---

[← Back to Home](INDEX.html)
