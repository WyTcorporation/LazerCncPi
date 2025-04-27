Базове налаштування Raspberry Pi Camera
 
sudo apt install libcamera-tools -y
Тест фото:
libcamera-still -o test.jpg

Тест відео:
libcamera-vid -o test.h264 -t 10000

Відеофіксація роботи лазера під час роботи станка
Для запису робочого процесу в повноцінному вигляді, створи простий Bash-скрипт:
Створи файл record_laser.sh:
```bash
#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="laser_job_$TIMESTAMP.h264"

echo "🔴 Запис почався: $FILENAME"
libcamera-vid -o ~/Videos/$FILENAME --framerate 30 --width 1920 --height 1080

```

Зроби скрипт виконуваним:

```bash
chmod +x record_laser.sh
mkdir ~/Videos
```

Запускай запис через SSH або безпосередньо в терміналі Raspberry Pi:

```bash
./record_laser.sh
```

Робота з CNC.js та запуск першого гравіювання:
Підготуй G-код (через LightBurn, LaserGRBL, Inkscape чи будь-який інший генератор).

Завантаж файл в CNC.js.
Вистав координати та запусти роботу.
Одночасно запусти запис через камеру.

Додаткові рекомендації для зручності роботи:
Підключення через SSH для зручності:
sudo raspi-config → Interface Options → SSH → Enable

Налаштуй Samba для доступу до записаних відео з інших ПК у локальній мережі:
sudo apt install samba samba-common-bin -y
sudo nano /etc/samba/smb.conf

Додай в кінець файлу:
[Videos]
path = /home/pi/Videos
writeable = yes
create mask = 0777
directory mask = 0777
public = yes

Перезапусти Samba:
sudo systemctl restart smbd

sudo apt install libcamera-apps libcamera-tools -y

sudo nano /boot/firmware/config.txt
camera_auto_detect=1
dtoverlay=imx708  # якщо Camera Module 3, або видали цей рядок якщо стара модель

Важливо:
camera_auto_detect=1 включає автоматичне визначення модулів камери.
dtoverlay=imx708 — це для нової Raspberry Pi Camera Module 3. Для стандартних камер (Module V2, HQ) цей рядок не потрібен.

libcamera-hello --list-cameras
Має бути:

Available cameras
-----------------
0 : imx219 [3280x2464] (/base/soc/i2c0mux/i2c@1/imx219@10)

dmesg | grep imx
dmesg | grep cam
vcgencmd get_camera


Зроби скрипт виконуваним:
chmod +x record_laser.sh
mkdir ~/Videos

Запускай запис через SSH або безпосередньо в терміналі Raspberry Pi:

./record_laser.sh

sudo apt update