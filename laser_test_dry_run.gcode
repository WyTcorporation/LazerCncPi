; Test G-code for dry-run (no laser)
G21 ; Set units to millimeters
G90 ; Absolute positioning
G0 X0 Y0 F3000 ; Move to origin
G1 X20 F1000 ; Move to X=100
G1 Y20 F1000 ; Move to Y=100
G1 X0 F1000 ; Move to X=0
G1 Y0 F1000 ; Move to Y=0
M5 ; Ensure laser/spindle is off
