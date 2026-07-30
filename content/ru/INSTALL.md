# Руководство по установке

## Требования

- Хост с Klipper: Raspberry Pi, Orange Pi, Debian/Ubuntu и другие
- Python 3.7 или новее
- pyserial, установленный через pip или поставляемый с Klipper

## Получение исходного кода

```bash
# Gitee
git clone https://gitee.com/NBTP/idm-documents.git

# Зеркало GitHub
git clone https://github.com/NBTPXX/idm-documents.git
```

## Способы установки

### Установка одной командой

```bash
cd ~/idm-documents/flash_web
./install.sh
```

Скрипт настраивает права исполнения, Moonraker update_manager, управляемые сервисы, автоматический запуск systemd и веб-службу на порту `8888`.

### Временный ручной запуск

```bash
cd ~/idm-documents/flash_web
python3 server.py
```

## Проверка установки

```bash
curl http://<printer-ip>:8888/api/env
```

Откройте в браузере `http://<printer-ip>:8888`.

## Удаление

```bash
cd ~/idm-documents/flash_web
./uninstall.sh
```

---

[Вернуться на главную](INDEX.html)
