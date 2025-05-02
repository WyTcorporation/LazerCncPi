import numpy as np
import pandas as pd

# Значення потужності та швидкості
powers = list(range(100, 1100, 100))  # S100 до S1000
speeds = list(range(500, 3500, 500))  # F500 до F3000

# Створення таблиці
matrix = pd.DataFrame(index=[f'S{p}' for p in powers], columns=[f'F{f}' for f in speeds])
matrix[:] = '—'  # заповнюємо порожніми комірками

# Зберігаємо як CSV
matrix.to_csv("laser_test_matrix.csv", encoding="utf-8")
print("✔️ Збережено: laser_test_matrix.csv")


# Функція для створення G-code
def generate_gcode_matrix(powers, speeds, spacing=10):
    gcode = [
        "; Laser Power-Speed Test Matrix",
        "G21 ; mm mode",
        "G90 ; absolute positioning",
        "M3 ; laser on"
    ]
    y = 0
    for s in speeds:
        x = 0
        for p in powers:
            gcode.append(f"G0 X{x} Y{y}")
            gcode.append(f"G1 X{x+spacing} S{p} F{s}")
            x += spacing + 5
        y += 5
    gcode.append("M5 ; laser off")
    gcode.append("G0 X0 Y0 ; return to origin")
    return "\n".join(gcode)

# Генеруємо та зберігаємо G-code
gcode_content = generate_gcode_matrix(powers, speeds)

with open("laser_test_matrix.gcode", "w") as f:
    f.write(gcode_content)

print("✔️ Збережено: laser_test_matrix.gcode")
