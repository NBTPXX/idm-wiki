# 校准

## 初始化 Z 位置

校准前先设置 Z 轴初始位置：

1. 执行 `G28 X Y`（仅归零 XY，不要归零 Z）
2. 移动喷嘴到热床中央
3. 执行 `SET_KINEMATIC_POSITION z=80`
4. 手动降低喷嘴至贴床（垫 A4 纸），感到轻微阻力即可
5. 执行 `SET_KINEMATIC_POSITION z=0`

## 手动校准（scan 模式）

```gcode
IDM_CALIBRATE
# 参照纸片法调整 Z 偏移
ACCEPT
SAVE_CONFIG
```

## Touch 模式

Touch 模式利用喷嘴接触热床来校准，适用于各种热床表面。

**完整工作流**：

**第 1 步：手动 Touch**
```gcode
IDM_TOUCH METHOD=MANUAL
# 调整喷嘴刚好贴床
ACCEPT
SAVE_CONFIG
```

**第 2 步：Touch 阈值校准**（归零后执行）
```gcode
IDM_THRESHOLD_SCAN MIN=500
SAVE_CONFIG
```

**第 3 步：自动 Z 偏移测量**
```gcode
PROBE_CALIBRATE METHOD=AUTO
SAVE_CONFIG
```

**第 4 步：保存固定偏移补偿**
```gcode
SAVE_TOUCH_OFFSET
```

> 打印起始 G-code 中需加入自动校准，见高级功能页。

## Second Probe 模式

使用 TAP 或机械限位开关作为第二探针：

```ini
[scanner]
calibration_method: second_probe
z_offset: 0.5                          # 第二探针触发高度与喷嘴的偏移
probe_speed: 1
probe_pin: ...
```

校准命令：
```gcode
IDM_TOUCH CALIBRATE=1
```

## 多模型管理

针对不同 PEI 板保存独立校准：

| 命令 | 说明 |
|------|------|
| `IDM_MODEL_SAVE NAME=<name>` | 保存当前校准 |
| `IDM_MODEL_SELECT NAME=<name>` | 载入已保存的校准 |
| `IDM_MODEL_LIST` | 列出所有校准 |
| `IDM_MODEL_REMOVE NAME=<name>` | 删除校准 |

## 常用命令

| 命令 | 说明 |
|------|------|
| `QUERY_PROBE` | 查询当前探测值 |
| `PROBE` | 执行单次探测 |
| `PROBE_ACCURACY` | 探测精度测试（重复 10 次） |
| `PROBE_CALIBRATE METHOD=AUTO` | 自动 Z 偏移测量 |
| `IDM_CALIBRATE` | 手动传感器校准 |

---

[← 返回首页](INDEX.html)
