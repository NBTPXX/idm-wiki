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

Second Probe mode uses a TAP or mechanical endstop for Z homing and automatic Z-offset calibration. It is intended for setups using an external contact trigger.

### Configuration

Add the following options to `[scanner]`:

```ini
[scanner]
calibration_method: second_probe
z_offset: 0
probe_speed: 10
probe_pin: ^PA1
```

| Option | Description |
|--------|-------------|
| `calibration_method` | Set to `second_probe` to enable the second-probe trigger method |
| `z_offset` | Fixed trigger-height offset relative to the nozzle; measure the actual value when using TAP |
| `probe_speed` | Z-axis movement speed during calibration; 15 mm/s or less is recommended |
| `probe_pin` | Actual trigger pin for the TAP or mechanical endstop; replace the example `^PA1` with the wired pin |

Save the configuration, restart Klipper, and verify that the second probe triggers correctly.

### Initial Calibration

1. Home the X and Y axes:

```gcode
G28 X Y
```

2. Use the second probe for Z homing and automatic IDM model calibration:

```gcode
IDM_TOUCH CALIBRATE=1
```

3. Measure the Z offset automatically:

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

4. Fine-tune the Z offset in the web interface. Once the nozzle height is correct, save the fixed compensation:

```gcode
SAVE_TOUCH_OFFSET
```

TAP and similar trigger mechanisms may introduce a small amount of compression. Measure and save the fixed compensation again after replacing the nozzle, hotend components, or second probe.

### Daily Use

After the initial calibration, add the following sequence to the print start G-code:

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
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
