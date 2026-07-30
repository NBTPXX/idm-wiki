# Расширенные функции

## Оптимизация температурной компенсации

IDM имеет встроенную температурную компенсацию. Параметры можно оптимизировать сбором данных; процесс занимает около часа.

### Сбор данных

Добавьте этот макрос в `printer.cfg`.

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
```

```gcode
DATA_SAMPLE BED_TEMP=90 NOZZLE_TEMP=250 MIN_TEMP=40 MAX_TEMP=70
```

Переместите файлы данных в `~/IDM` и выполните:

```bash
cd ~/IDM
~/klippy-env/bin/python arg_fit.py
```

Проверьте `fit_result.png`: компенсированные смещения должны укладываться в три знака.

## Карта стола

```ini
[bed_mesh]
zero_reference_position: 125, 125
```

Для столов с AC-нагревателем мощностью от 500 Вт отключайте нагреватель при измерении.

```ini
[gcode_macro BED_MESH_CALIBRATE]
rename_existing: _BED_MESH_CALIBRATE
gcode:
    {% set TARGET_TEMP = printer.heater_bed.target %}
    M140 S0
    _BED_MESH_CALIBRATE {rawparams}
    M140 S{TARGET_TEMP}
```

## G-code запуска печати

Добавьте в конец макроса `PRINT_START`:

```gcode
IDM_TOUCH CALIBRATE=1
PROBE_CALIBRATE METHOD=AUTO
```

## Устранение неполадок

| Проблема | Причина | Решение |
|----------|---------|---------|
| Меняется смещение Z | Изменение температуры | Калибруйте при температуре печати и настройте компенсацию |
| Ошибка `IDM model convergence` | Слишком большой model_offset | Установите `model_offset` в `0`, затем настройте Z offset |
| Ошибка хоуминга `no model` | Ошибка формата конфигурации | Проверьте отступы и имя секции |
| Аномалии карты стола | EMI нагревателя | Настройте макрос отключения нагревателя и проверьте монтаж |
| Ошибка связи CAN | Неверная частота или UUID | Проверьте частоту, UUID и отсутствие `serial:` |

---

[Вернуться на главную](INDEX.html)
