# Seven-Segment Display Counter – Verilog Implementation

A four-digit up/down counter built in Verilog for ELEC 2607 Lab 4.  
Implements increment, decrement, load, and reset functions using the Nexys A7 FPGA’s seven-segment display.

---

## Overview
The design uses a 100 MHz clock divided to drive four multiplexed seven-segment digits.  
Button inputs control counter behavior, while switch inputs load custom BCD values.  
The `binary_to_seven_segment` module converts 4-bit BCD to segment codes.

---

## Inputs / Outputs
**Inputs**
- `CLK100MHZ` – Main clock  
- `BTNU` – Increment  
- `BTND` – Decrement  
- `BTNL` – Load from switches  
- `BTNR` – Reset  
- `SW[15:0]` – Switch input for manual load  

**Outputs**
- `CA–CG` – Segment control lines  
- `AN[7:0]` – Active-low digit enables  

---

## Files
| File | Description |
|------|--------------|
| `src/seven_segment_controller.v` | Main control logic for display and counter |
| `src/binary_to_seven_segment.v` | Converts 4-bit values to seven-segment patterns |
| `docs/ELEC2607_Lab4_Report.pdf` | Full lab report |

---

## Simulation / Synthesis
1. Add both `.v` files in Vivado or ModelSim.  
2. Run behavioral simulation to verify increment/decrement and load/reset operations.  
3. Synthesize and program to the Nexys A7 board.

---

## Author
**Dumany Lombe**  
Carleton University – Electrical Engineering
