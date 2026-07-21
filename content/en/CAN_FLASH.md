# CAN Mode Flashing

CAN mode communicates with devices via SocketCAN, suitable for IDM sensors connected via CAN bus.

## CAN Frequency Selection

Select the CAN frequency from the dropdown based on the firmware build:

| Option | Frequency | Description |
|--------|-----------|-------------|
| 1000000 | 1M | High speed |
| 500000 | 500k | Medium speed |
| 250000 | 250k | Low speed |
| Other | - | Firmware without frequency tag |

## Firmware Types

- **IDM Main Firmware (main)**: Standard sensor operating firmware
- **Bootloader Override Firmware (deployer)**: Flashed during initial deployment to replace the existing bootloader

## CAN UUID

Flashing requires the device's 6-byte UUID. Click "Query" to automatically scan for Katapult nodes on the CAN bus.

Prerequisites:
- Device is in Katapult bootloader mode
- CAN interface is configured and enabled (e.g., `can0`)

## Enter/Exit Bootloader

- **Enter BL**: Sends KLIPPER_REBOOT_CMD via CAN to management ID 0x3f0
- **Exit BL**: Runs the clear node → set node ID → CONNECT → COMPLETE sequence

![CAN Mode Flash Interface](../images/can-flash.png)

## Flashing Procedure

1. Select CAN mode
2. Choose frequency and firmware type
3. Select firmware version and file
4. Click "Query" to get CAN UUID
5. Click "Enter BL" if needed
6. Click "Start Flashing"
7. Watch console output and wait for completion

---

[← Back to Home](INDEX.html)
