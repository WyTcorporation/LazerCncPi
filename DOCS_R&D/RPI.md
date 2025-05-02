📌 1. Підготовка Raspberry Pi 5
🛠️ Що потрібно:
Raspberry Pi OS (64-bit) завантажити

SSD 1TB (швидкий та надійний накопичувач)

Оригінальна Raspberry Pi Camera Module або аналогічна камера USB/Webcam

🔧 Базове налаштування ОС Raspberry Pi:
Запиши образ Raspberry Pi OS на SSD за допомогою Raspberry Pi Imager.

Підключи SSD до Raspberry Pi 5, запусти Pi та онови систему:

sudo apt update && sudo apt upgrade -y
sudo raspi-config  # для базових налаштувань (SSH, Wi-Fi, камера)

Активуй Camera Module:
sudo raspi-config → Interface Options → Camera → Enable
sudo reboot

📌 2. Встановлення програмного забезпечення для керування лазерним станком
Найкращий варіант для твого GRBL-станка:

🔥 CNC.js
CNC.js — це веб-додаток з дружнім інтерфейсом для керування CNC, лазером і 3D-принтером. 
Працює з GRBL, має підтримку камери, веб-інтерфейс і чудово інтегрується з Raspberry Pi.

📌 Встановлення CNC.js на Raspberry Pi 5:
sudo apt install git build-essential curl -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y

# Перевірка Node.js
node -v && npm -v

# Встановлюємо CNC.js
sudo npm install -g cncjs

Автозапуск CNC.js при старті Raspberry Pi:

sudo npm install pm2@latest -g
pm2 startup systemd
pm2 start $(which cncjs) -- --port 8000
pm2 save

Перевір доступ через браузер на Raspberry Pi IP:
http://<IP-адреса-Raspberry-Pi>:8000

📌 3. Підключення Raspberry Pi до Arduino UNO (GRBL):
Підключи Arduino з CNC Shield через USB-порт Raspberry Pi.

Перевір, чи Raspberry Pi бачить Arduino:
ls /dev/tty*

Має бути пристрій /dev/ttyACM0 або /dev/ttyUSB0.
У CNC.js вибери відповідний порт (ttyACM0) і GRBL-режим:
Baud rate: 115200

