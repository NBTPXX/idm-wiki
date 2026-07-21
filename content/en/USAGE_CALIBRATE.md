# Calibration

## Initialize Z Position

Before calibration, set the initial Z position:

1. Run `G28 X Y` (home XY only, do NOT home Z)
2. Move nozzle to bed center
3. Run `SET_KINEMATIC_POSITION z=80`
4. Manually lower nozzle until touching the bed (use a sheet of paper)
5. Run `SET_KINEMATIC_POSITION z=0`

## Manual Calibration (scan mode)

```gcode
IDM_CALIBRATE
# Adjust Z offset using paper method
ACCEPT
SAVE_CONFIG
```

## Touch Mode

Touch mode uses nozzle-bed contact for calibration, suitable for any bed surface.

**Full workflow**:

**Step 1: Manual Touch**
```gcode
IDM_TOUCH METHOD=MANUAL
# Adjust nozzle until just touching the bed
ACCEPT
SAVE_CONFIG
```

**Step 2: Touch Threshold Calibration** (after homing)
```gcode
IDM_THRESHOLD_SCAN MIN=500
SAVE_CONFIG
```

**Step 3: Auto Z Offset Measurement**
```gcode
PROBE_CALIBRATE METHOD=AUTO
SAVE_CONFIG
```

**Step 4: Save Fixed Offset**
```gcode
SAVE_TOUCH_OFFSET
```

> Add auto-calibration to print start G-code — see Advanced Features page.

## Second Probe Mode

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

## Multi-Model Management

Save and switch calibrations for different PEI sheets:

| Command | Description |
|---------|-------------|
| `IDM_MODEL_SAVE NAME=<name>` | Save current calibration |
| `IDM_MODEL_SELECT NAME=<name>` | Load a saved calibration |
| `IDM_MODEL_LIST` | List all calibrations |
| `IDM_MODEL_REMOVE NAME=<name>` | Delete a calibration |

## Common Commands

| Command | Description |
|---------|-------------|
| `QUERY_PROBE` | Query current probe value |
| `PROBE` | Perform single probe |
| `PROBE_ACCURACY` | Probe accuracy test (10 reps) |
| `PROBE_CALIBRATE METHOD=AUTO` | Auto Z offset measurement |
| `IDM_CALIBRATE` | Manual sensor calibration |

---

[← Back to Home](INDEX.html)
