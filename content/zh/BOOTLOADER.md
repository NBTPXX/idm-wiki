# Bootloader 管理

IDM 传感器使用 Katapult（原 CanBoot）作为 bootloader。

## Bootloader 协议

Katapult 使用自定义二进制协议：

| 参数 | 值 |
|------|-----|
| 包头 | \x01\x88 |
| 包尾 | \x99\x03 |
| CRC | CRC16-CCITT |
| 波特率 | 250000 |

### 协议命令

| 命令 | 代码 | 说明 |
|------|------|------|
| CONNECT | 0x11 | 连接 bootloader |
| COMPLETE | 0x15 | 完成并退出 bootloader |
| GET_CANBUS_ID | 0x16 | 获取 CAN ID |
| SEND_BLOCK | 0x12 | 发送数据块 |
| REQUEST_BLOCK | 0x14 | 请求数据块 |
| SEND_EOF | 0x13 | 传输结束 |

### CAN 管理命令

| 命令 | 代码 | 说明 |
|------|------|------|
| QUERY_UNASSIGNED | 0x00 | 查询未分配节点 |
| SET_NODEID | 0x11 | 设置节点 ID |
| CLEAR_NODE_ID | 0x12 | 清除节点 ID |
| KLIPPER_REBOOT | 0x02 | 重启进入 BL |

## 进入 Bootloader

### USB 模式
通过调用 flash_usb.enter_bootloader() 发送命令使设备重启进入 bootloader。

### CAN 模式
使用 socket.PF_CAN 原生 CAN 传输：
1. 创建 CAN socket 并绑定接口（如 can0）
2. 向管理 ID 0x3f0 发送 KLIPPER_REBOOT_CMD (0x02)
3. 等待设备重启并进入 bootloader

## 退出 Bootloader

通过 Katapult 协议实现，不依赖 DTR 切换：

1. Prime：发送命令序列初始化通信
2. CONNECT：建立与 bootloader 的会话
3. COMPLETE：告知 bootloader 完成，启动应用程序

### CAN 模式退出
1. 发送 CLEAR_NODE_ID 清除节点
2. 发送 SET_NODEID 设置新节点 ID（偏移 128）
3. 通过新节点 ID 发送 CONNECT 和 COMPLETE

## 设备识别

- Bootloader 设备名称含 katapult 或 canboot 关键词
- 已排除 stm32 以避免误匹配普通 IDM 设备

---

[← 返回首页](INDEX.html)
