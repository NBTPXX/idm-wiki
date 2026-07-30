# セットアップと設定

## 概要

IDM (Integrated Distance Monitor) は、加速度計と温度センサーを内蔵した 3D プリンター用の非接触ベッドレベリングセンサーです。Klipper とは CAN または USB で通信します。

## ソフトウェアのインストール

```bash
cd ~
git clone https://gitee.com/NBTP/IDM.git
cd IDM
~/klippy-env/bin/pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
./install.sh
```

## デバイス ID の取得

CAN モード:

```bash
~/klippy-env/bin/python ~/klipper/lib/katapult/flashtool.py -i can0 -q
```

USB モード:

```bash
ls /dev/serial/by-id/*
```

## MCU 設定

CAN モード:

```ini
[mcu idm]
canbus_uuid: 2ca7ad8c2899
```

USB モード:

```ini
[mcu idm]
serial: /dev/serial/by-id/usb-idm_idm_...
```

## 必須設定

`force_move` を有効化します。

```ini
[force_move]
enable_force_move: True

[stepper_z]
endstop_pin: probe:z_virtual_endstop

[safe_z_home]
home_xy_position: <x-center-coordinate>, <y-center-coordinate>
z_hop: 10
```

既存の `[probe]` セクションを削除します。CAN モードでは `serial:` を設定せず、USB モードではデバイスのシリアルパスを設定します。

## スキャナー設定例

```ini
[scanner]
mcu: idm
sensor: idm
calibration_method: touch
speed: 40
lift_speed: 5
backlash_comp: 0.5
x_offset: 0
y_offset: 21.1
trigger_distance: 2
trigger_dive_threshold: 1.5
trigger_hysteresis: 0.006
cal_nozzle_z: 0.1
cal_floor: 0.1
cal_ceil: 5
cal_speed: 1.0
cal_move_speed: 10
default_model_name: default
mesh_main_direction: x
mesh_cluster_size: 1
mesh_runs: 1
scanner_touch_max_temp: 180
scanner_touch_speed: 5
scanner_touch_accel: 100
```

---

[ホームに戻る](INDEX.html)
