# 多 Z 轴调平

## VORON 2.4 等 4Z 机器（QGL）

```ini
[gcode_macro QUAD_GANTRY_LEVEL]
rename_existing: _QUAD_GANTRY_LEVEL
gcode:
    SAVE_GCODE_STATE NAME=STATE_QGL
    BED_MESH_CLEAR
    {% if not printer.quad_gantry_level.applied %}
      _QUAD_GANTRY_LEVEL horizontal_move_z=10 retry_tolerance=1
    {% endif %}
    _QUAD_GANTRY_LEVEL horizontal_move_z=2
    RESTORE_GCODE_STATE NAME=STATE_QGL
```

## VORON Trident 等 3Z 机器（Z_TILT）

```ini
[gcode_macro Z_TILT_ADJUST]
rename_existing: _Z_TILT_ADJUST
gcode:
    SAVE_GCODE_STATE NAME=STATE_Z_TILT
    BED_MESH_CLEAR
    {% if not printer.z_tilt.applied %}
      _Z_TILT_ADJUST horizontal_move_z=10 retry_tolerance=1
    {% endif %}
    _Z_TILT_ADJUST horizontal_move_z=2
    RESTORE_GCODE_STATE NAME=STATE_Z_TILT
```

---

[← 返回首页](INDEX.html)
