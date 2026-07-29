# Advanced Features

## Temperature Compensation Optimization

IDM has built-in temperature compensation. Parameters can be optimized through data collection (~1 hour).

### Data Collection

Add this macro to `printer.cfg`:

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

Run:

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

Data files are generated at `/tmp/data1`, `/tmp/data2`, `/tmp/data3`.

### Calculate Parameters

Move the three data files to `~/IDM`, then run:

```bash
cd ~/IDM
~/klippy-env/bin/python arg_fit.py
```

Check `fit_result.png` and confirm that the compensated offsets stay within three digits.

---

## Accelerometer

IDM includes a built-in accelerometer for resonance compensation.

**lis2dw (square chip)**:

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points: 125,125,20
```

**adxl345 (rectangular chip)**:

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points: 125,125,20
```

Run resonance measurement:
```gcode
SHAPER_CALIBRATE
```

---

## Bed Mesh

```ini
[bed_mesh]
zero_reference_position: 125, 125      # Set this to the center of the bed
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
```

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Z offset drift | Temperature variation | Calibrate at print temp; configure temp compensation |
| "IDM model convergence" error | model_offset too large | Set `model_offset` to `0`, then adjust the Z offset again |
| "no model" homing error | Config format error | Check indentation and section name syntax |
| Bed mesh anomalies | Bed heater EMI | Configure bed-off macro; check sensor mounting |
| CAN communication failure | Incorrect frequency or UUID | Check firmware frequency, query the UUID again, and ensure `serial:` is absent |

---

[← Back to Home](INDEX.html)
