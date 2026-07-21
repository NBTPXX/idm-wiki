# Bootloader Management

IDM sensors use Katapult (formerly CanBoot) as the bootloader.

## Bootloader Protocol

Katapult uses a custom binary protocol:

| Parameter | Value |
|-----------|-------|
| Header | \x01\x88 |
| Trailer | \x99\x03 |
| CRC | CRC16-CCITT |
| Baud Rate | 250000 |

### Protocol Commands

| Command | Code | Description |
|---------|------|-------------|
| CONNECT | 0x11 | Connect to bootloader |
| COMPLETE | 0x15 | Finish and exit bootloader |
| GET_CANBUS_ID | 0x16 | Get CAN ID |
| SEND_BLOCK | 0x12 | Send data block |
| REQUEST_BLOCK | 0x14 | Request data block |
| SEND_EOF | 0x13 | End of transfer |

### CAN Management Commands

| Command | Code | Description |
|---------|------|-------------|
| QUERY_UNASSIGNED | 0x00 | Query unassigned nodes |
| SET_NODEID | 0x11 | Set node ID |
| CLEAR_NODE_ID | 0x12 | Clear node ID |
| KLIPPER_REBOOT | 0x02 | Reboot into BL |

## Entering Bootloader

### USB Mode
Calls flash_usb.enter_bootloader() to send a command that reboots the device into bootloader.

### CAN Mode
Uses socket.PF_CAN native CAN transport:
1. Create a CAN socket and bind to an interface (e.g., can0)
2. Send KLIPPER_REBOOT_CMD (0x02) to management ID 0x3f0
3. Wait for the device to reboot and enter bootloader

## Exiting Bootloader

Implemented via Katapult protocol without relying on DTR toggle:

1. Prime: Send command sequence to initialize communication
2. CONNECT: Establish a session with the bootloader
3. COMPLETE: Tell the bootloader to finish and launch the application

### CAN Mode Exit
1. Send CLEAR_NODE_ID to clear the node
2. Send SET_NODEID to set a new node ID (offset 128)
3. Send CONNECT and COMPLETE via the new node ID

## Device Identification

- Bootloader device names contain katapult or canboot keywords
- stm32 is excluded to avoid false matching with regular IDM devices

---

[← Back to Home](INDEX.html)
