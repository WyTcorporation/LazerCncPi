🔧 Інструкція: Як запустити Laser CNC на ESP32 з FluidNC (через PlatformIO)
🧰 Що потрібно:
ESP32 (наприклад, ESP-WROOM-32)

Два драйвери A4988 або інші

Крокові двигуни NEMA17

PWM лазер (0–5V TTL, наприклад AENBUSLM 40W)

Кінцевики: X+ та Y+

Плата живлення 24V

Комп’ютер з встановленим VS Code та PlatformIO

1️⃣ Установка PlatformIO
Якщо ще не встановлено:

bash
Копировать
Редактировать
pipx install platformio
або:

bash
Копировать
Редактировать
python3 -m pip install --user platformio
І перезапусти VS Code.

2️⃣ Клонування або створення проекту
Створи папку, всередині VS Code → PlatformIO: New Project:

Назва: LaserESP32

Платформа: esp32dev

Framework: Arduino

Нажми Finish

3️⃣ Додай прошивку FluidNC
🔸 Клонуй або завантаж FluidNC

bash
Копировать
Редактировать
git clone https://github.com/bdring/FluidNC
Копіюй вміст у створений проєкт LaserESP32.

4️⃣ Додай файл Machine.h
У папку src/ створи файл:
laser_esp32_v1.h

І додай цей вміст:

cpp
Копировать
Редактировать
#pragma once
#define MACHINE_NAME "Laser_ESP32_V1"
#define SPINDLE_TYPE            SpindleType::LASER
#define LASER_OUTPUT_PIN        GPIO_NUM_25
#define X_STEP_PIN              GPIO_NUM_12
#define X_DIRECTION_PIN         GPIO_NUM_26
#define Y_STEP_PIN              GPIO_NUM_14
#define Y_DIRECTION_PIN         GPIO_NUM_27
#define X_LIMIT_PIN             GPIO_NUM_32
#define Y_LIMIT_PIN             GPIO_NUM_33
#define STEPPERS_DISABLE_PIN    GPIO_NUM_13
#define DEFAULT_STEP_PULSE_MICROSECONDS     3
#define DEFAULT_STEPPER_IDLE_LOCK_TIME      255
#define DEFAULT_STEPPING_INVERT_MASK        0
#define DEFAULT_DIRECTION_INVERT_MASK       0
#define DEFAULT_INVERT_ST_ENABLE            0
#define DEFAULT_INVERT_LIMIT_PINS           0
#define DEFAULT_HARD_LIMIT_ENABLE           1
#define DEFAULT_HOMING_ENABLE               1
#define DEFAULT_HOMING_DIR_MASK             0b11
#define DEFAULT_HOMING_FEED_RATE            100.0
#define DEFAULT_HOMING_SEEK_RATE            500.0
#define DEFAULT_HOMING_DEBOUNCE_DELAY       250
#define DEFAULT_HOMING_PULLOFF              2.0
#define DEFAULT_LASER_MODE                  1
#define DEFAULT_X_STEPS_PER_MM              80.0
#define DEFAULT_Y_STEPS_PER_MM              80.0
#define DEFAULT_X_MAX_RATE                  5000.0
#define DEFAULT_Y_MAX_RATE                  5000.0
#define DEFAULT_X_ACCELERATION              100.0
#define DEFAULT_Y_ACCELERATION              100.0
#define DEFAULT_X_MAX_TRAVEL                350.0
#define DEFAULT_Y_MAX_TRAVEL                350.0
#define DEFAULT_SPINDLE_RPM_MAX             1000.0
#define DEFAULT_SPINDLE_RPM_MIN             0.0
#define DEFAULT_STATUS_REPORT_MASK          1
5️⃣ Додай конфіг config.yaml (для Web інтерфейсу)
yaml
Копировать
Редактировать
board: esp32dev
name: laser_cnc
wifi:
  mode: sta
  ssid: "ТВОЯ_МЕРЕЖА"
  password: "ТВІЙ_ПАРОЛЬ"

stepper_x:
  step_pin: GPIO12
  dir_pin: GPIO26
  steps_per_mm: 80
  max_rate_mm_per_min: 5000
  acceleration_mm_per_sec2: 100

stepper_y:
  step_pin: GPIO14
  dir_pin: GPIO27
  steps_per_mm: 80
  max_rate_mm_per_min: 5000
  acceleration_mm_per_sec2: 100

laser:
  pwm_hz: 5000
  output_pin: GPIO25
  s_value_max: 1000
  s_value_min: 0

axes:
  count: 2
6️⃣ Підключи свою схему:
GPIO12 — Step X

GPIO26 — Dir X

GPIO14 — Step Y

GPIO27 — Dir Y

GPIO25 — PWM (на лазерний модуль)

GPIO32 — X+ кінцевик

GPIO33 — Y+ кінцевик

GND — загальна земля

24V — на драйвери та лазер

7️⃣ Компіляція та прошивка
bash
Копировать
Редактировать
pio run -t upload
або натисни в PlatformIO іконку «🡱» (Upload)

8️⃣ Користуйся WebUI:
Після прошивки підключись до тієї ж Wi-Fi мережі

У логах буде IP адреса ESP32

Перейди на нього через браузер → отримаєш панель керування CNC
(можеш рухати осі, запускати G-коди)

Підключення до Wi-Fi ESP32
SSID: GRBL_ESP32 або подібний.

Пароль: 12345678.

Відкриття WebUI
Введи в браузері: http://192.168.0.1.

Якщо WebUI не завантажується, можливо, потрібно завантажити інтерфейс вручну.


Конвертор рівнів 5V — 3.3V двоспрямований 4-канальний IIC I2C (Logic Level Converter Bi-Directional Module)

Для підвиження логіки ESP32 -> Laser

 Підключення для PWM з ESP32 до лазера:
Конвертер	Підключити до
LV	3.3V на ESP32
GND	GND на ESP32 і також до GND живлення лазера
HV	5V (з того ж джерела, що й лазер, або стабільне 5V)
LV1	GPIO16 з ESP32 (це твій PWM сигнал)
HV1	PWM/TTL IN лазера
Інші канали (LV2–4/HV2–4) не використовуються.
Схематично:
ESP32           Конвертер            Лазер
GPIO16  ─────>  LV1 ───────> HV1 ─────> TTL/PWM IN
3.3V    ─────>  LV
GND     ─────>  GND ─────────────┐
                               └─> GND Лазера
5V (блок живлення) ────> HV

Перевірити мультиметром:
Якщо мультиметр має режим усереднення напруги:
M3 S500 → ~2.5 В
M3 S250 → ~1.25 В
M3 S1000 → 5.0 В
M3 S0 → 0 В