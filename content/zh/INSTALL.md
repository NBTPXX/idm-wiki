# 安装指南

## 环境要求

- 运行 Klipper 的上位机（树莓派、香橙派等，Debian/Ubuntu 系统）
- Python 3.7+
- pyserial（通过 pip 安装或随 Klipper 安装）

## 获取源码

```bash
# Gitee（主仓库）
git clone https://gitee.com/NBTP/idm-documents.git

# GitHub（镜像，自动同步）
git clone https://github.com/NBTPXX/idm-documents.git
```

## 一键安装

```bash
cd ~/idm-documents/flash_web
./install.sh
```

安装脚本会自动完成：

1. 设置可执行权限
2. 配置 Moonraker update_manager（支持在线更新）
3. 添加 managed_services 配置
4. 安装 systemd 服务并设为开机自启
5. 启动 Web 服务（端口 8888）

## 手动启动

```bash
cd ~/idm-documents/flash_web
python3 server.py
```

## 验证安装

```bash
curl http://<打印机IP>:8888/api/env
```

## 访问 Web 界面

浏览器打开：`http://<打印机IP>:8888`

## 卸载

```bash
cd ~/idm-documents/flash_web
./uninstall.sh
```

---

[← 返回首页](INDEX.html)
