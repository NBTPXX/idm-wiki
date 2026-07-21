# IDM 使用教程

## 简介

IDM（Integrated Distance Monitor）是用于 3D 打印机的非接触式调平传感器，通过 CAN 或 USB 与 Klipper 上位机通信。

## 硬件连接

### CAN 模式（推荐）

将 IDM 传感器连接到打印机的 CAN 总线：

```
上位机 ─── CAN Bus ─── IDM 传感器
             │
             └── 工具板 / 其他 CAN 设备
```

### USB 模式

直接通过 USB 连接至上位机。

## Klipper 配置

在 `printer.cfg` 中添加以下配置：

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899     # 替换为你的设备 UUID

[temperature_sensor idm_temp]
sensor_type: temperature_mcu
sensor_mcu: idm
min_temp: 0
max_temp: 100

[idm]
sensor_type: IDM
```

### 获取 CAN UUID

```bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
```

## 校准

### Z 轴偏移校准

1. 执行 `PROBE_CALIBRATE` 命令
2. 使用纸片法手动调整喷嘴高度
3. 执行 `ACCEPT` 保存结果
4. 执行 `SAVE_CONFIG` 写入配置

### 温度补偿

IDM 传感器内置温度补偿：

```ini
[idm]
temperature_compensation: True
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `QUERY_PROBE` | 查询当前探测值 |
| `PROBE` | 执行单次探测 |
| `PROBE_ACCURACY` | 探测精度测试（重复 10 次） |
| `BED_MESH_CALIBRATE` | 热床网格校准 |
| `PROBE_CALIBRATE` | Z 偏移校准 |

## 热床网格

```ini
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 15, 15
mesh_max: 235, 235
probe_count: 5, 5
algorithm: bicubic
```

执行网格校准：

```
BED_MESH_CALIBRATE
BED_MESH_PROFILE SAVE=default
SAVE_CONFIG
```

## 自适应网格

在 `PRINT_START` 宏中添加：

```
BED_MESH_CALIBRATE ADAPTIVE=1
```

每次打印前自动探测当前打印区域，节省时间。

## 故障排查

| 问题 | 可能原因 | 解决方法 |
|------|---------|---------|
| 探测失败 | 传感器脏污 | 清洁传感器镜头 |
| 数值漂移 | 温度变化 | 等热床温度稳定后重新校准 |
| CAN 通信超时 | 接线松动 | 检查 CAN 接线和终端电阻 |
| 无法获取 UUID | 未进入 BL 模式 | 使用 IDM Flash Web 进入 bootloader |

---

[← 返回首页](INDEX.html)
