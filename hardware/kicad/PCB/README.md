##PCB Design Rules
The PCB was routed as a 4-layer board with the following main design rules:

Parameter - Value 
- General signal trace width - 0.20 mm
- FPGA BGA escape trace width - 0.10 mm
- Standard via size - 0.60 mm 
- Standard via drill - 0.30 mm 
- BGA escape via size - 0.40 mm 
- BGA escape via drill - 0.20 mm 
- FPGA BGA pitch - 0.80 mm 
- Board thickness - 1.6 mm 
- Outer copper thickness - 35 µm

-checked with design rules checker-
## Priority zones

![Power Zone Priorities](../kicad/images/priority_zones.png)


Power-zone priority: +3.3VA → +2.5V → +1.1V → +5V → +3.3V. Higher priority zones retain their copper area where zones approach or overlap, helping preserve supply distribution.
