# Акселерометр

IDM имеет встроенный акселерометр для измерения резонансов. Разместите конфигурацию акселерометра после конфигурации IDM.

## Версия lis2dw (квадратный чип)

```ini
[lis2dw]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: lis2dw
probe_points:
    125, 125, 20
```

## Версия adxl345 (прямоугольный чип)

```ini
[adxl345]
cs_pin: idm:PA3
spi_bus: spi1

[resonance_tester]
accel_chip: adxl345
probe_points:
    125, 125, 20
```

## Измерение резонансов

```gcode
SHAPER_CALIBRATE
```

---

[Вернуться на главную](INDEX.html)
