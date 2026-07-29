# DFU 模式刷写

DFU 模式使用 dfu-util 工具，适用于设备处于 USB DFU 模式时。

## 前置条件

- 安装 dfu-util：`sudo apt install -y dfu-util`
- 先尝试无 sudo 模式，失败后自动回退到 `sudo -n`

## 进入 DFU 模式

按住设备上的物理按钮（如 BOOT0）再上电，使设备进入 DFU 模式。

## Flash Address

| 地址 | 说明 |
|------|------|
| 0x08002000 | 主固件 (Main Firmware) |
| 0x08000000 | Bootloader |

## 检测 DFU 设备

点击「检测 DFU」按钮执行 `dfu-util -l` 扫描 DFU 设备。

## 刷写流程

![DFU 模式刷写界面](../images/dfu-workflow.svg)

1. 选择 DFU 模式
2. 选择正确的 Flash Address
3. 选择固件文件
4. 点击「检测 DFU」确认设备
5. 点击「开始刷写」
6. 刷写完成后重新上电，退出 DFU 模式

---

[← 返回首页](INDEX.html)
