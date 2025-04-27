sudo apt update
sudo apt full-upgrade -y
sudo reboot

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

sudo nano /boot/firmware/config.txt
camera_auto_detect=1
dtoverlay=imx708  # якщо Camera Module 3, або видали цей рядок якщо стара модель
Важливо:

camera_auto_detect=1 включає автоматичне визначення модулів камери.

dtoverlay=imx708 — це для нової Raspberry Pi Camera Module 3. Для стандартних камер (Module V2, HQ) цей рядок не потрібен.

libcamera-hello --list-cameras


Зроби скрипт виконуваним:
chmod +x record_laser.sh
mkdir ~/Videos

Запускай запис через SSH або безпосередньо в терміналі Raspberry Pi:

./record_laser.sh

sudo apt update


ALARM:6 (Homing fail)
[MSG:Check Limits]

⚠️ Можливі причини і рішення:
✅ 1. Кінцеві вимикачі не спрацьовують
Перевір фізично, чи працюють кінцевики (YL-99):

На платі YL-99 є світлодіод, який повинен загорітися при натисканні вимикача.

Натисни вручну кінцевики (X-min, Y-min) і переконайся, що світлодіод загоряється.

Якщо світлодіод не горить:

Перевір живлення (VCC → 5V Arduino).

Перевір GND-підключення.

Перевір контакт OUT до CNC Shield.

✅ 2. Переплутані контакти кінцевиків на CNC Shield
Правильно підключення таке:


Кінцевик | VCC | GND | OUT
X min | Arduino 5V | CNC Shield X- GND | CNC Shield X- Signal
Y min | Arduino 5V | CNC Shield Y- GND | CNC Shield Y- Signal

✅ 3. Homing рухається не в той бік
Під час процедури Homing (команда $H) станок рухається до кінцевиків. Якщо він рухається не до кінцевиків, тоді напрямок треба інвертувати.

Для цього використовуються параметри GRBL:
$23=3 ; зараз X+, Y+
Значення | Напрямок Homing
$23=0 | X-, Y-
$23=1 | X+, Y-
$23=2 | X-, Y+
$23=3 | X+, Y+

Тестуй кожен варіант:
$23=0
$H
якщо ні — наступний ($23=1, $23=2), поки не знайдеш правильний напрямок.

Занадто короткий час або дистанція пошуку нуля
GRBL має параметри для пошуку кінцевиків:

$24=25.000  ; Швидкість homing (мм/хв, повільний пошук)
$25=500.000 ; Швидкість homing (мм/хв, швидкий пошук)
$27=5.000   ; Відступ від кінцевиків після пошуку (мм)

Збільш трохи $27 (наприклад до 10 мм):
$27=10.000

Перезапусти Homing:
$H

Тимчасове вимкнення homing (на час тесту)
$22=0
Після перезапуску розблокуй GRBL:
$X
Перевір рух осей вручну:
G91      ; відносне позиціювання
G1 X10   ; рух 10 мм вправо по X
G1 Y10   ; рух 10 мм вперед по Y
