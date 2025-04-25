sudo apt install git build-essential curl -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt-get install npm

# Перевірка Node.js
node -v && npm -v

# Встановлюємо CNC.js
sudo npm install -g cncjs

Автозапуск CNC.js при старті Raspberry Pi:
sudo npm install pm2@latest -g
pm2 startup systemd
pm2 start $(which cncjs) -- --port 8080
pm2 save

http://IP_Raspberry:8000

ls /dev/tty*

Має бути пристрій /dev/ttyACM0 або /dev/ttyUSB0.

У CNC.js вибери відповідний порт (ttyACM0) і GRBL-режим:

Baud rate: 115200

Базове налаштування Raspberry Pi Camera
sudo apt install libcamera-tools -y

libcamera-still -o test.jpg

libcamera-vid -t 10000 -o test.h264