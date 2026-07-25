# Delta Nozzle Offset Compensation

## Problem

On Delta printers, Klipper homes to (0,0) at the effector center. If the nozzle is mounted off-center (e.g., y_offset=11mm), the physical nozzle sits at (0,-11), causing prints to be offset.

## Solution

The `nozzle_offset.py` module automatically compensates after homing:

1. Physically moves the nozzle to (0,0)
2. Re-solves the Delta coordinate system via trilateration
3. Tells Klipper the nozzle is at (0,0)

## Installation

1. Copy `nozzle_offset.py` to Klipper's `klippy/extras/`:

```bash
cp delta_nozzle_offset.py ~/klipper/klippy/extras/
```

2. Add to `printer.cfg`:

```ini
[delta_nozzle_offset]
x_offset: 0
y_offset: -11        # Nozzle offset from effector center
speed: 50
```

3. Auto-compensates after every `G28` homing. No extra command needed.

Manual trigger also available:

```gcode
DELTA_NOZZLE_OFFSET
```

## How It Works

1. `G1 X0 Y11` moves the effector to (0,11), placing the nozzle at (0,0)
2. Reads stepper positions, solves true cartesian coordinates
3. `SET_KINEMATIC_POSITION` sets the corrected origin without tilting the plane

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| x_offset | Nozzle X offset (mm) | 0 |
| y_offset | Nozzle Y offset (mm) | 0 |
| speed | Compensation move speed (mm/s) | 50 |
| enabled | Enable/disable | True |

---

[← Back to Home](INDEX.html)
