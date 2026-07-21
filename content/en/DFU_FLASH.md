# DFU Mode Flashing

DFU mode uses the dfu-util tool, applicable when the device is in USB DFU mode.

## Prerequisites

- Install dfu-util: `sudo apt install -y dfu-util`
- Attempts without sudo first; falls back to `sudo -n` if that fails

## Flash Address

| Address | Description |
|---------|-------------|
| 0x08002000 | Main Firmware |
| 0x08000000 | Bootloader |

## Detect DFU Device

Click "Detect DFU" to run `dfu-util -l` and scan for DFU devices.

## Notes

- DFU mode usually requires holding a physical button (e.g., BOOT0) while powering on
- After flashing, power cycle the device to exit DFU mode

## Flashing Procedure

1. Put the device in DFU mode (hold BOOT0 button while powering on)
2. Select DFU mode
3. Select the correct Flash Address
4. Select the firmware file
5. Click "Detect DFU" to confirm the device
6. Click "Start Flashing"
7. Power cycle after flashing completes

---

[← Back to Home](INDEX.html)
