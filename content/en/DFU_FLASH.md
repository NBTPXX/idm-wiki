# DFU Mode Flashing

DFU mode uses the dfu-util tool, applicable when the device is in USB DFU mode.

## Prerequisites

- Install dfu-util: `sudo apt install -y dfu-util`
- Attempts without sudo first; falls back to `sudo -n` if that fails

## Enter DFU Mode

Short BOOT0, then power on the device to enter DFU mode.

## Flash Address

| Address | Description |
|---------|-------------|
| 0x08002000 | Main Firmware |
| 0x08000000 | Bootloader |

## Detect DFU Device

Click "Detect DFU" to run `dfu-util -l` and scan for DFU devices.

![DFU Mode Flash Interface](../images/dfu-workflow.svg)

## Flashing Procedure

1. Select DFU mode
2. Select the correct Flash Address
3. Select the firmware file
4. Click "Detect DFU" to confirm the device
5. Click "Start Flashing"
6. Wait for the device to reset automatically and exit DFU mode

---

[← Back to Home](INDEX.html)
