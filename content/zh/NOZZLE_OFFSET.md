# 三角洲喷嘴偏移补偿

## 问题

Delta 机型归零时，Klipper 以效应器中心为 (0,0)，但喷嘴偏心安装（如 y_offset=11mm），导致喷嘴实际在 (0,-11)。打印时模型会偏移。

## 解决方案

使用 `nozzle_offset.py` 模块，归零后自动补偿：

1. 物理移动喷嘴到 (0,0)
2. 重新解算 Delta 坐标系
3. 让 Klipper 认为喷嘴就在 (0,0)

## 安装

1. 把 `nozzle_offset.py` 复制到 Klipper 的 `klippy/extras/` 目录：

```bash
cp nozzle_offset.py ~/klipper/klippy/extras/
```

2. 在 `printer.cfg` 中添加：

```ini
[nozzle_offset]
x_offset: 0
y_offset: -11        # 喷嘴相对效应器中心的偏移
speed: 50
```

3. 在 `G28` 宏或归零后调用：

```gcode
G28
NOZZLE_OFFSET_APPLY
```

或在 `[safe_z_home]` 后自动执行（推荐）：

```ini
[gcode_macro G28]
rename_existing: G28.1
gcode:
    G28.1 {rawparams}
    NOZZLE_OFFSET_APPLY
```

## 原理

1. `G1 X0 Y11` 把效应器移到 (0,11)，喷嘴物理到 (0,0)
2. 读取三塔步进位置，用 trilateration 解算真实坐标
3. `SET_KINEMATIC_POSITION` 设置新坐标，避免平面倾斜

## 参数

| 参数 | 说明 | 默认 |
|------|------|------|
| x_offset | 喷嘴 X 方向偏移（mm） | 0 |
| y_offset | 喷嘴 Y 方向偏移（mm） | 0 |
| speed | 补偿移动速度（mm/s） | 50 |
| enabled | 是否启用 | True |

---

[← 返回首页](INDEX.html)
