# DFU Mode Flashing

DFU mode uses the dfu-util tool, applicable when the device is in USB DFU mode.

## Prerequisites

- Install dfu-util: `sudo apt install -y dfu-util`
- Attempts without sudo first; falls back to `sudo -n` if that fails

## Enter DFU Mode

Hold the device's physical button, such as BOOT0, while powering on to enter DFU mode.

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
6. Power cycle after flashing completes to exit DFU mode

---

[← Back to Home](INDEX.html)
