# Advanced Features

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

Check `fit_result.png` — compensated data should be close to horizontal.

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

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Probe failed | Dirty sensor lens | Clean lens with alcohol wipe |
| Z offset drift | Temperature variation | Calibrate at print temp; configure temp compensation |
| "IDM model convergence" error | model_offset too large | `IDM_MODEL REMOVE=default` then re-calibrate |
| "no model" homing error | Config format error | Check indentation and section name syntax |
| Bed mesh anomalies | Bed heater EMI | Configure bed-off macro; check sensor mounting |
| CAN timeout | Frequency mismatch / loose wiring | Check frequency and termination; ensure no serial line |
| Cannot get UUID | Device not in BL mode | Send reboot via CAN or power cycle |

---

[← Back to Home](INDEX.html)
