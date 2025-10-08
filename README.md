# 32-Bit Dadda Multiplier in Verilog HDL
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Language: Verilog](https://img.shields.io/badge/Language-Verilog-blue)]()
[![Build](https://img.shields.io/badge/Simulation-Successful-green)]()
[![Build](https://img.shields.io/badge/Hardware-Pending-yellow)]()
## Overview
This repository contains the hardware design for a 32-bit integer multiplier circuit written in Verilog HDL, using the dadda tree reduction algorithm. This architecture is usually seen in DSP slices, multiplier circuits in general-purpose CPUs and FPGA soft processors. The dadda-tree multiplier is much faster than booth's and shift-add multipliers, while also consuming lesser area and power than wallace-tree and array multipliers, making it a good choice for FPGA soft processors and embedded systems by respecting the constrained available resources while delivering good performance.
## Get Started
The testbench tests the multiplier on various signed/unsigned operands and generates a CSV log file containing columns of operands, expected and obtained results, and error flags. To run the testbench:
```bash
iverilog -o mul_tb.vvp tb/mul_tb.v src/*.v
vvp mul_tb.vvp
```
To visualize the waveforms of various wires, run:
```bash
gtkwave mul_tb.vcd
```