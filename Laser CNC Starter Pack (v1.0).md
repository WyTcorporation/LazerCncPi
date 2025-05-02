# Laser CNC Starter Pack (v1.0)

Повна інструкція зі збору та налаштування лазерного CNC-станка на Raspberry Pi 5 + Arduino UNO (GRBL) + CNC Shield 3.0.

---

## 📆 Загальна специфікація

* **Плата керування**: Arduino Uno + CNC Shield v3.0
* **Прошивка**: GRBL 1.1h
* **Крокові двигуни**: NEMA17 17HS4401 1.7A (X, Y)
* **Драйвери**: A4988 (2 шт.)
* **Ремінь**: GT2 6mm, 1.25м, з сталевими нитками
* **Шків**: GT2 20T 5mm
* **Кінцевики**: X+, Y+ (NO, сухий контакт)
* **Лазер**: AENBUSLM 40W 24V PWM/TTL
* **Блок живлення**: 24V, 25A
* **PWM пін**: Z+ (D11)
* **Робоча область**: 350mm x 350mm

---

## ⚖️ Налаштування GRBL

### GRBL Settings

```ini
$0=10
$1=255
$2=0
$3=0
$4=0
$5=0
$6=0

$10=1
$11=0.010
$12=0.002
$13=0
$20=0
$21=1
$22=1
$23=3
$24=100.000
$25=500.000
$26=250
$27=2.000
$30=1000
$31=0
$32=1

$100=80.000
$101=80.000
$102=80.000
$110=5000.000
$111=5000.000
$112=500.000
$120=100.000
$121=100.000
$122=100.000
$130=350.000
$131=350.000
$132=50.000
```

> Додатково в `config.h` прошивки:

```c
#define DEFAULT_SPINDLE_PWM_FREQ 5000
#define VARIABLE_SPINDLE
#define HOMING_CYCLE_0 (1<<X_AXIS)
#define HOMING_CYCLE_1 (1<<Y_AXIS)
```

---

## 🌟 CNCjs на Raspberry Pi 5

### 1. Встановлення CNCjs

```bash
sudo apt update && sudo apt install -y build-essential
sudo npm install -g cncjs --unsafe-perm
```

### 2. Автозапуск

```bash
sudo nano /etc/systemd/system/cncjs.service
```

```ini
[Unit]
Description=CNCjs
[Service]
ExecStart=/usr/bin/cncjs -p 8000
Restart=always
User=pi
[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reexec
sudo systemctl enable cncjs.service
sudo systemctl start cncjs
```

---

## 💻 Inkscape + G-code Tools (для SVG → G-code)

### 1. Встановлення

```bash
sudo apt install inkscape
```

### 2. Плагіни (G-code Tools, J Tech Photonics Laser Tool)

* Скачати: [https://jtechphotonics.com/?page\_id=1980](https://jtechphotonics.com/?page_id=1980)
* Копіювати до: `~/.config/inkscape/extensions`

### 3. Налаштування

* Встановити `Tool Diameter`, `Laser Power`, `Feedrate`
* Експорт: **gcode (.gcode)**

---

## 🧱 FlatCAM (для виготовлення PCB)

### 1. Встановлення FlatCAM Beta на Ubuntu 24

```bash
sudo apt install python3-pyqt5 python3-vispy python3-shapely python3-matplotlib
wget https://bitbucket.org/jpcgt/flatcam/downloads/FlatCAM_beta_8.995.zip
unzip -d FlatCAM FlatCAM_beta_8.995.zip
cd FlatCAM
python3 FlatCAM.py
```

### 2. Налаштування проекту:

* Образ Gerber файлів
* Згенерувати **Geometry**, потім **G-code** (Isolation, Drilling)

---

## ⚡️ Електросхема (CNC Shield v3.0)

```
[ Laser PWM (жовтий) ] ---> Z+ (D11)
[ Laser GND (чорний) ] ---> GND поруч
[ Laser 24V (червоний) ] ---> блок живлення 24V

[ X кінцевик NO ] ---> Signal - NO, GND - COM
[ Y кінцевик NO ] ---> Signal - NO, GND - COM

[ A4988 X/Y ] ---> налаштувати струм через Vref
[ Степпери NEMA17 ] ---> стандартне підключення (4 pin)
[ БЖ 24V 25A ] ---> VIN CNC Shield + Laser Power
```

> *Не з'єднувати GND лазера та PWM, якщо на борту є окремий драйвер!*

---

## 🎓 Команди перевірки роботи

```gcode
$X ; Розблокування
$H ; Хоуминг

G91
G1 X10 F100 S0    ; 0V
G1 X10 F100 S500  ; ~2.5V
G1 X10 F100 S1000 ; ~5V
M5                ; вимкнення лазеру
```

---

## 🏒 Додатково

* *LightBurn* не підтримує Ubuntu 24 без Wine
* Вибрати точку G54 самостійно ("Zero All Axis")
* PID-контроль лазера не підтримується GRBL

---

## 🌟 План оновлень

* Перехід на **ESP32 + GRBL-ESP32**
* Qt6 GUI з камерою, автозахистом, режимом попереднього перегляду
* Підтримка 3+ камер
* Облік матеріалів, температура, журнал робіт

---

> Стан проекту: **Готова перша версія** ✅

---

Готовий до публічного показу та поширення. Редагувати через GitHub Pages, Notion, або README.md в проекті.
