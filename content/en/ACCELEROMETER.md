# Accelerometer

IDM includes a built-in accelerometer for resonance measurement. Place the accelerometer configuration after the IDM configuration.

## lis2dw Version (Square Chip)

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points:
    125, 125, 20  # Set this to the printhead coordinates used for resonance measurement
```

## adxl345 Version (Rectangular Chip)

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points:
    125, 125, 20  # Set this to the printhead coordinates used for resonance measurement
```

## Resonance Measurement

After configuration, run:

```gcode
SHAPER_CALIBRATE
```

---

[← Back to Home](INDEX.html)
