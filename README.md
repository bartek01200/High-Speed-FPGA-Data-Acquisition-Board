# ECP5 FPGA High Speed Data Acquisition System
A custom 4-layer mixed signal data acquisition PCB designed around a Lattice ECP5 FPGA and an analog devices AD9280 8 bit, 32 MSPS ADC.

The system combines analogue signal conditioning, multi rail power regulation, FPGA configuration circuitry and an 8-bit parallel ADC interface with a modular verilog acquisition pipeline for sample capture, FIFO buffering, acquisition control and streamed readout.

## Key Features:
- Lattice ECP5 LFE5U-12F-6BG256C FPGA
- Analog Devices AD9280 8 bit, 32 MSPS ADC
- Custom 4-layer mixed-signal PCB
- OPA836 analogue signal conditioning
- 1.1 V, 2.5 V and 3.3 V power rails
- 8-bit parallel ADC-to-FPGA interface
- FPGA configuration flash and JTAG programming interface
- Verilog ADC capture, FIFO buffering and acquisition control
- FSM-based buffered readout
- HDL simulation using Icarus Verilog and GTKWave
- FPGA synthesis using Yosys
- ECP5 place and route using nextpnr
- 32 MHz FPGA timing target successfully met

##Key metrics include:
The FPGA datapath handles a theoretical raw ADC input rate of 256 Mbit/s(32 MB/s), uses a 16-byte FIFO
,and met a 32MHz timing,using only 58 LUTs and 44 flip flop.

## Front PCB
![Front PCB](docs/images/front_pcb_new.png)


## Back PCB
![Back PCB](docs/images/Back_of_pcb.png)

## Hardware Build Disclaimer
This project was intended to be physically assembled and tested. However, Mouser cancelled the component order before shipment due to complience issues.I later found that all analog devices needed customer verification which i was not aware of, this included critical parts such as the AD9280 ADC and LT1963 2.5 V regulator.

As a result, the project was completed through PCB design, HDL simulation, synthesis and timing verification rather than physical hardware testing.

AI usage: Used AI for command line guidance and toolchain troubleshooting. All PCB design, HDL implementation, integration, simulation, and project documentation were completed by me.

