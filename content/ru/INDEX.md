# Руководство пользователя IDM Flash Web

IDM Flash Web — браузерный инструмент прошивки датчиков IDM для 3D-принтеров. Поддерживаются подключения CAN, USB Serial и DFU.

![Главный интерфейс](../images/main-ui.svg)

## Содержание

- [Руководство по установке](INSTALL.html)
- [Интеграция с Moonraker](MOONRAKER.html)
- [Прошивка через CAN](CAN_FLASH.html)
- [Прошивка через USB](USB_FLASH.html)
- [Прошивка в режиме DFU](DFU_FLASH.html)

## Поддерживаемые режимы

| Режим | Сценарий | Подключение |
|------|----------|------------|
| CAN | Устройства на шине CAN | CAN socket |
| USB | Устройства с USB Serial | Serial (Katapult) |
| DFU | Устройства в режиме USB DFU | dfu-util |

## Быстрый старт

1. Запустите IDM Flash Web по [руководству по установке](INSTALL.html)
2. Подключите принтер к хосту
3. Откройте `http://<printer-ip>:8888`
4. Выберите CAN, USB или DFU по типу подключения
5. Выберите файл прошивки и начните прошивку

---

[Инструмент IDM Flash Web](http://localhost:8888)
