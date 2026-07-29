# IDM Flash Web User Manual

IDM Flash Web is a browser-based firmware flashing tool for IDM 3D printer sensors. It supports CAN, USB serial, and DFU connection modes.

![Main Interface](../images/main-ui.svg)

## Contents

- [Installation Guide](INSTALL.html)
- [Moonraker Integration](MOONRAKER.html)
- [CAN Mode Flashing](CAN_FLASH.html)
- [USB Mode Flashing](USB_FLASH.html)
- [DFU Mode Flashing](DFU_FLASH.html)

## Supported Modes

| Mode | Use Case | Communication |
|------|----------|---------------|
| CAN | CAN bus connected devices | CAN socket |
| USB | USB serial connected devices | Serial (Katapult) |
| DFU | USB DFU mode devices | dfu-util |

## Quick Start

1. Follow the [Installation Guide](INSTALL.html) to start IDM Flash Web
2. Connect the printer to the host
3. Open the web interface: `http://<printer-ip>:8888`
4. Select CAN, USB, or DFU based on the device connection
5. Select the firmware file and click "Start Flashing"

---

[IDM Flash Web Flashing Tool](http://localhost:8888)
