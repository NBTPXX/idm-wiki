# IDM Flash Web User Manual

IDM Flash Web is a browser-based firmware flashing tool for IDM 3D printer sensors. It supports CAN, USB serial, and DFU connection modes.

![Main Interface](../images/main-ui.svg)

## Contents

- [Installation Guide](INSTALL.html)
- [CAN Mode Flashing](CAN_FLASH.html)
- [USB Mode Flashing](USB_FLASH.html)
- [DFU Mode Flashing](DFU_FLASH.html)
- [Bootloader Management](BOOTLOADER.html)
- [Moonraker Integration](MOONRAKER.html)

## Quick Start

1. Connect the printer to the host (CAN or USB)
2. Open the web interface: `http://<printer-ip>:8888`
3. Select connection mode (CAN / USB / DFU)
4. Select the firmware file to flash
5. Click "Start Flashing"

## Supported Modes

| Mode | Use Case | Communication |
|------|----------|---------------|
| CAN | CAN bus connected devices | CAN socket |
| USB | USB serial connected devices | Serial (Katapult) |
| DFU | USB DFU mode devices | dfu-util |

---

[IDM Flash Web Flashing Tool](http://localhost:8888)
