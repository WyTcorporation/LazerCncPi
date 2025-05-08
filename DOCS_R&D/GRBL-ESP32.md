https://github.com/bdring/Grbl_Esp32

⚙️ Конфігурація Machine.h для GRBL-ESP32
#pragma once
#include "Machines/Default.h"

// Тип шпинделя — лазер
#define SPINDLE_TYPE SpindleType::LASER

// PWM-вихід для лазера
#define LASER_PWM_PIN GPIO_NUM_25
#define LASER_ENABLE_PIN GPIO_NUM_26  // Якщо потрібен окремий пін для увімкнення лазера

// Піни для осі X
#define X_STEP_PIN GPIO_NUM_33
#define X_DIRECTION_PIN GPIO_NUM_32
#define X_LIMIT_PIN GPIO_NUM_34

// Піни для осі Y
#define Y_STEP_PIN GPIO_NUM_27
#define Y_DIRECTION_PIN GPIO_NUM_14
#define Y_LIMIT_PIN GPIO_NUM_35

// Включення кінцевиків
#define USE_X_LIMIT
#define USE_Y_LIMIT

// Включення лазерного режиму
#define USE_LASER

// Частота PWM
#define DEFAULT_SPINDLE_PWM_FREQ 5000  // 5 кГц

// Максимальна та мінімальна потужність лазера
#define SPINDLE_PWM_OFF_VALUE 0
#define SPINDLE_PWM_MIN_VALUE 0
#define SPINDLE_PWM_MAX_VALUE 1000

🔌 Схема підключення
Лазер:
PWM (жовтий) → GPIO25
GND (чорний) → GND ESP32
V+ (червоний) → окреме джерело живлення (наприклад, 12V або 24V)

Кінцевики:
X-кінцевик → GPIO34
Y-кінцевик → GPIO35
Обидва кінцевики підключені через резистори підтягування до 3.3V

🛠️ Налаштування GRBL
Після прошивки ESP32 завантажте GRBL-ESP32 і встановіть наступні параметри:

$32=1       ; Включити лазерний режим
$30=1000    ; Максимальна потужність лазера
$31=0       ; Мінімальна потужність лазера
$100=80     ; Кроки на мм для осі X
$101=80     ; Кроки на мм для осі Y
$110=5000   ; Максимальна швидкість для осі X
$111=5000   ; Максимальна швидкість для осі Y
$120=400    ; Прискорення для осі X
$121=400    ; Прискорення для осі Y

🧪 Тестування
Перевірка кінцевиків:
Відправте команду ? в GRBL-консоль.
Натисніть кінцевик осі X або Y і переконайтеся, що статус змінюється.
Перевірка лазера:
Відправте команду M3 S500 — лазер повинен світитися на 50% потужності.
Відправте команду M5 — лазер повинен вимкнутися.
