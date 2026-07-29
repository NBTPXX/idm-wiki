# Calibration

## Initialize Z Position

Before calibration, set the initial Z position:

1. Run `G28 X Y` (home XY only, do NOT home Z)
2. Move nozzle to bed center
3. Run `SET_KINEMATIC_POSITION z=80`
4. Manually lower nozzle until touching the bed (use a sheet of paper)
5. Run `SET_KINEMATIC_POSITION z=0`

## Manual Calibration (Scan Mode)

```gcode
IDM_CALIBRATE
```

## Touch Mode

Touch mode uses nozzle-bed contact for calibration, suitable for any bed surface.

### Step 1: Initial Manual Calibration

```gcode
IDM_TOUCH METHOD=MANUAL
```

In the offset control dialog, lower the printhead until the nozzle touches the bed, then click the -0.1 offset control and confirm.

### Step 2: Home the Printer

```gcode
G28
```

### Step 3: Calibrate the Touch Threshold

```gcode
IDM_THRESHOLD_SCAN MIN=500
```

### Step 4: Save the Fixed Z Offset

```gcode
SAVE_TOUCH_OFFSET
```

### Step 5: Measure the Z Offset Automatically

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

### Step 6: Configure the Print Start G-code

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
```

See [Advanced Features](USAGE_ADVANCED.html) for the complete workflow.

## Second Probe Mode

Second Probe mode uses a TAP or mechanical endstop for Z homing and automatic Z-offset calibration. It is intended for setups using an external contact trigger.

### Configuration

Add the following options to `[scanner]`:

```ini
calibration_method: second_probe
z_offset: 0
probe_speed: 10
probe_pin:
```

| Option | Description |
|--------|-------------|
| `calibration_method` | Set to `second_probe` to enable the second-probe trigger method |
| `z_offset` | Fixed trigger-height offset relative to the nozzle; measure the actual value when using TAP |
| `probe_speed` | Z-axis movement speed during calibration; 15 mm/s or less is recommended |
| `probe_pin` | Actual trigger pin for the TAP or mechanical endstop |

Save the configuration, restart Klipper, and verify that the second probe triggers correctly.

### Run Calibration

```gcode
IDM_TOUCH CALIBRATE=1
```

### Calibrate the Z Offset

```gcode
PROBE_CALIBRATE METHOD=AUTO
```

### Save the Fixed Z Offset

Fine-tune the Z offset in the web interface. Once the nozzle height is correct, save the fixed compensation:

```gcode
SAVE_TOUCH_OFFSET
```

TAP and similar trigger mechanisms may introduce a small amount of compression. Measure and save the fixed compensation again after replacing the nozzle, hotend components, or second probe.

## Multi-Model Management

Save and switch calibrations for different PEI sheets:

| Command | Description |
|---------|-------------|
| `IDM_MODEL_SAVE NAME=<name>` | Save current calibration |
| `IDM_MODEL_SELECT NAME=<name>` | Load a saved calibration |
| `IDM_MODEL_LIST` | List all calibrations |
| `IDM_MODEL_REMOVE NAME=<name>` | Delete a calibration |

---

[← Back to Home](INDEX.html)
