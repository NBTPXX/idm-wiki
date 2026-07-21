# IDM Usage Tutorial

## Overview

IDM (Integrated Distance Monitor) is a contactless bed leveling sensor for 3D printers, communicating with Klipper via CAN bus or USB.

## Hardware Connection

### CAN Mode (Recommended)

Connect the IDM sensor to the printer's CAN bus:

```
Host ─── CAN Bus ─── IDM Sensor
           │
           └── Tool Board / Other CAN Devices
```

### USB Mode

Connect directly to the host via USB.

## Klipper Configuration

Add the following to `printer.cfg`:

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899     # Replace with your device UUID

[temperature_sensor idm_temp]
sensor_type: temperature_mcu
sensor_mcu: idm
min_temp: 0
max_temp: 100

[idm]
sensor_type: IDM
```

### Get CAN UUID

```bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

## Calibration

### Z Offset Calibration

1. Run `PROBE_CALIBRATE` command
2. Use the paper method to manually adjust nozzle height
3. Run `ACCEPT` to save the result
4. Run `SAVE_CONFIG` to write to config

### Temperature Compensation

The IDM sensor includes built-in temperature compensation:

```ini
[idm]
temperature_compensation: True
```

## Common Commands

| Command | Description |
|---------|-------------|
| `QUERY_PROBE` | Query current probe value |
| `PROBE` | Perform single probe |
| `PROBE_ACCURACY` | Probe accuracy test (10 repetitions) |
| `BED_MESH_CALIBRATE` | Bed mesh calibration |
| `PROBE_CALIBRATE` | Z offset calibration |

## Bed Mesh

```ini
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 15, 15
mesh_max: 235, 235
probe_count: 5, 5
algorithm: bicubic
```

Run mesh calibration:

```
BED_MESH_CALIBRATE
BED_MESH_PROFILE SAVE=default
SAVE_CONFIG
```

## Adaptive Mesh

Add to `PRINT_START` macro:

```
BED_MESH_CALIBRATE ADAPTIVE=1
```

Automatically probes only the current print area before each print, saving time.

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Probe failed | Dirty sensor | Clean sensor lens |
| Value drift | Temperature change | Re-calibrate after bed temp stabilizes |
| CAN communication timeout | Loose wiring | Check CAN wiring and termination resistor |
| Cannot get UUID | Not in BL mode | Use IDM Flash Web to enter bootloader |

---

[← Back to Home](INDEX.html)
