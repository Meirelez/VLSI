# 8×8 Benes Multi-Stage Interconnection Network (VLSI)

This repository contains the design, simulation and validation tools for an 8×8 Benes multi-stage interconnection network implemented at transistor level.

The project was developed for the VLSI Circuits course and focuses on layout optimization, delay characterization and exhaustive functional validation through automated simulation.

---

## Project Overview

The module implements an 8×8 Benes interconnection network composed of 2×2 butterfly switching blocks built with CMOS transmission gates. Any input can be routed to any output through multiple possible paths, controlled by 20 configuration bits.

<img width="980" height="676" alt="image" src="https://github.com/user-attachments/assets/671a81a1-653d-4919-8ccb-66b483b69e84" />

## Simulation and Validation

Due to the large number of possible configurations, an automated validation system was developed:

### Python Script
`netlist.py`
- Generates thousands of netlists with different control and input combinations
- Creates measurement specification files

### Bash Script
`scriptx6.sh`
- Executes Spectre simulations automatically
- Collects delay results

### Spectre Files
- `8x8_tb_exc_netlist_2.scs` – extracted netlist
- `X0teste.mdl` – measurement definition file

Each simulation validates both functional correctness and propagation delay.

### PDF File
- `PCVLSI.pdf` – The complete technical report describing the design, layout, simulation methodology, and validation results.

---



