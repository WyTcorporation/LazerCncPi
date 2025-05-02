Компонент | Кількість | Позначення
Arduino UNO | 1 шт. | GRBL-контролер
CNC Shield v3.0 | 1 шт. | Сумісний з Arduino
Драйвери A4988 | 2 шт. (+1 запасний) | Для двигунів X, Y
Крокові двигуни NEMA17 (42a02c) | 2 шт. (X,Y) | 42a02c
Лазерний модуль NZQB40W-24V | 1 шт. | З Air Assist
Кінцеві вимикачі YL-99 | 2 шт. (X-min, Y-min) | Endstops з LED
Блок живлення 24V, 10-15A (3 виходи) | 1 шт. | 24V DC
Проводи (екрановані для кінцевиків) | комплект | Для підключення
USB-кабель | 1 шт. | Arduino ↔ ПК

💻Програмне забезпечення
✅ GRBL firmware:
Завантаж GRBL прошивку через Arduino IDE:
Посилання на GRBL: github.com/gnea/grbl
Натисни кнопку Code > Download ZIP.
Розпакуй ZIP в зручну теку (наприклад, Documents/Arduino/libraries/grbl)
Відкрий файл config.h в будь-якому редакторі (VS Code, Notepad++, Arduino IDE)

#define HOMING_CYCLE_0 (1<<X_AXIS)  // COREXY COMPATIBLE: First home X
#define HOMING_CYCLE_1 (1<<Y_AXIS)  // COREXY COMPATIBLE: Then home Y

Додати в кінці файлу config.h:
#define DEFAULT_SPINDLE_PWM_FREQ 5000
#define VARIABLE_SPINDLE

Відкрий файл default.h в будь-якому редакторі (VS Code, Notepad++, Arduino IDE)
#define DEFAULT_X_STEPS_PER_MM 80.0
#define DEFAULT_Y_STEPS_PER_MM 80.0
#define DEFAULT_Z_STEPS_PER_MM 80.0
#define DEFAULT_X_MAX_RATE 5000.0
#define DEFAULT_Y_MAX_RATE 5000.0
#define DEFAULT_Z_MAX_RATE 500.0
#define DEFAULT_X_ACCELERATION 100.0
#define DEFAULT_Y_ACCELERATION 100.0
#define DEFAULT_Z_ACCELERATION 100.0
#define DEFAULT_SPINDLE_RPM_MAX 1000.0
#define DEFAULT_SPINDLE_RPM_MIN 0.0
#define DEFAULT_LASER_MODE 1
#define DEFAULT_HARD_LIMIT_ENABLE 1
#define DEFAULT_HOMING_ENABLE 1
#define DEFAULT_HOMING_DIR_MASK 3


Відкрий Arduino IDE → Завантаж GRBL в Arduino UNO.

Встанови будь-яку CNC-програму для керування (напр. Universal Gcode Sender).
✅ Тестування електроніки:
Підключись через USB і перевір, чи рухаються двигуни командами «X10 Y10 Z10» в Gcode Sender.
Перевір напрямок руху, при необхідності поміняй проводи місцями.

⚙️ Схема підключення компонентів:
1️⃣ Arduino UNO + CNC Shield v3.0:
CNC Shield встановлюєш зверху Arduino UNO.

2️⃣ Підключення двигунів через драйвери A4988:
Двигун (вісь) | Підключення (на Shield)
X-axis (NEMA17) | Слот X (A4988)
Y-axis (NEMA17) | Слот Y (A4988)
Виставляєш струм на драйверах A4988:
Рекомендоване значення (Vref): ~0.7–0.8V

3️⃣ Підключення лазерного модуля NZQB40W-24V:
Блок живлення 24V (+) → Лазерний модуль (+24V)
Блок живлення 24V (-) → Лазерний модуль (GND)
CNC Shield SpnEn (PWM) → Лазерний модуль (PWM input)
CNC Shield GND → Лазерний модуль (PWM GND)

4️⃣ Підключення кінцевих вимикачів YL-99:
X min (YL-99):
VCC → Arduino +5V (окремо, на Arduino є вільний контакт 5V)
GND → CNC Shield (X- GND)
OUT → CNC Shield (X- Signal)

X max (YL-99):
VCC → Arduino +5V (окремо, на Arduino є вільний контакт 5V)
GND → CNC Shield (X+ GND)
OUT → CNC Shield (X+ Signal)

Y min (YL-99):
VCC → Arduino +5V (окремо, на Arduino є вільний контакт 5V)
GND → CNC Shield (Y- GND)
OUT → CNC Shield (Y- Signal)

Y max (YL-99):
VCC → Arduino +5V (окремо, на Arduino є вільний контакт 5V)
GND → CNC Shield (Y+ GND)
OUT → CNC Shield (Y+ Signal)

Або

4️⃣ Підключення сухих кінцевих вимикачів:
X min:
GND → CNC Shield (X- GND)
OUT → CNC Shield (X- Signal)

X max:
GND → CNC Shield (X+ GND)
OUT → CNC Shield (X+ Signal)

Y min:
GND → CNC Shield (Y- GND)
OUT → CNC Shield (Y- Signal)

Y max:
GND → CNC Shield (Y+ GND)
OUT → CNC Shield (Y+ Signal)

5️⃣ Живлення системи (24V, 20-25A):
Перевірмо приблизне споживання:
Двигуни (NEMA17): ~2A (максимально, разом)
Лазер NZQB40W-24V: до 3-4A (з запасом)
Raspberry Pi 5: 3А (через LM2593 або LM2596 DC-DC)
Вентилятори та Air Assist: до 1А запас
Загальний максимальний струм ≈ 2 + 4 + 3 + 1 ≈ 10А
З запасом 25%: ~12.5А, тому блок живлення 24V 20-25A чудово підходить і має великий запас.

Лазер = товстий кабель (~1.5 мм²).
Двигуни = середній (~0.5 мм²).
Кінцевики = тонкий (~0.22 мм²).

Три виходи на блоці живлення використовуєш для:
Вихід БЖ | Компонент живлення
1 | CNC Shield (крокові двигуни)
2 | Лазерний модуль (NZQB40W)
3 | Rasberry Pi (через Lm2593)
4 | Запас (наприклад вентилятор, Air Assist або майбутні компоненти)
5 | Arduino UNO живиться через USB від Rasberry Pi.

Як встановити ці налаштування в GRBL:
1️⃣ Відкрий CNC.js або Universal Gcode Sender
Під'єднай Arduino до Raspberry Pi (або ПК) через USB.
Запусти CNC.js (у браузері: http://IP_Raspberry:8000) або Universal Gcode Sender.
2️⃣ Під'єднайся до GRBL (Arduino):
Вибери порт (зазвичай: /dev/ttyACM0 чи /dev/ttyUSB0).
Вибери швидкість передачі: 115200.
Натисни "Connect".
3️⃣ Відкрий консоль (Terminal) в CNC.js або вкладку «Console» в Universal Gcode Sender:
У CNC.js це нижня панель "Console".
В Universal Gcode Sender — вкладка "Console".
4️⃣ Скопіюй та встав такі налаштування в консоль (по черзі, рядок за рядком):

$0=10         ; step pulse, μs
$1=255        ; idle delay, ms (залишає двигуни увімкненими)
$2=0          ; step port invert
$3=0          ; direction invert
$4=0          ; step enable invert
$5=0          ; limit pins invert (NO кінцевики)
$6=0          ; probe pin invert

$10=1         ; status report: MPos
$11=0.010     ; junction deviation, мм
$12=0.002     ; arc tolerance, мм
$13=0         ; report inches
$20=0         ; soft limits (вимкнені)
$21=1         ; hard limits увімкнені
$22=1         ; homing увімкнений
$23=3         ; homing dir X+ Y+
$24=100.000   ; homing seek rate
$25=500.000   ; homing feed rate
$26=250       ; debounce
$27=2.000     ; pull-off
$30=1000      ; max spindle PWM
$31=0         ; min spindle PWM
$32=1         ; laser mode

$100=80.000   ; X steps/mm (GT2 + 20 зубів)
$101=80.000   ; Y steps/mm
$102=80.000   ; Z steps/mm (заглушка)
$110=5000.000 ; X max rate mm/min
$111=5000.000 ; Y max rate mm/min
$112=500.000  ; Z max rate
$120=100.000  ; X acceleration mm/sec^2
$121=100.000  ; Y acceleration mm/sec^2
$122=100.000  ; Z acceleration
$130=350.000  ; X travel mm
$131=350.000  ; Y travel mm
$132=50.000   ; Z travel (заглушка)



Перевірка введених параметрів:
$$

Перевірка роботи лазера через SpnEn:
M3 S500     ; увімкнення лазера на 50% потужності
G1 X50 F500 ; рух осі X на 50 мм
G1 Y50      ; рух осі Y на 50 мм
G1 X0       ; повернення по X на початкову позицію
G1 Y0       ; повернення по Y на початкову позицію
M5          ; вимкнення лазера
або
M3 S500  ; Вмикає лазер (50% потужність)
M5       ; Вимикає лазер


🛠️ Перевірка роботи станка (тестування):
Підключаєш Arduino до ПК.
Запускаєш Universal Gcode Sender.
Виконуєш команду для пошуку нуля (home):
$H

M3 S500
G1 X50 F500
G1 Y50
G1 X0
G1 Y0
M5

Перевір кінцевики:
$X
?
<Idle|MPos:0.000,0.000,0.000|FS:0,0|Pn:X>
Означає, що X кінцевик натиснутий або замкнутий неправильно (якщо без натискання — це помилка!).
Має бути:
<Idle|MPos:0.000,0.000,0.000|FS:0,0>

Тестовий Homing (G-код скрипт)
$X           ; розблокуй
G91          ; відносне позиціювання
G0 X-5 Y-5   ; трохи відійди назад (на всякий випадок)
$H           ; запусти Homing

#define HOMING_CYCLE_0 (1<<X_AXIS)  // Спочатку X
#define HOMING_CYCLE_1 (1<<Y_AXIS)  // Потім Y

defaults.h
#define DEFAULT_HOMING_ENABLE 1
#define DEFAULT_HOMING_DIR_MASK 3 // X+Y+
#define DEFAULT_HARD_LIMIT_ENABLE 1
#define DEFAULT_HOMING_PULLOFF 2.0

