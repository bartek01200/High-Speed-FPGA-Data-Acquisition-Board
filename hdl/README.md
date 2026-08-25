## FPGA HDL

This folder contains the Verilog implementation and simulation files for the FPGA data-acquisition path.
The design targets the Lattice ECP5`LFE5U-12F-6BG256C and implements an acquisition pipeline for the 8-bit parallel output of the AD9280 ADC.

## HDL Architecture
The FPGA datapath is divided into four main modules:

### adc_capture.v
Registers the incoming 8-bit ADC data on the sampling clock edge.
This provides a stable representation of each ADC sample inside the FPGA.

### `fifo.v`
Implements a synchronous FIFO used to buffer ADC samples.
The FIFO separates sample acquisition from readout so that acquired data can be stored before being transferred to the output interface.

It contains:
- sample memory
- write pointer
- read pointer
- occupancy counter
- full and empty status signals

### acquisition_ctrl.v
Controls when sampling begins and ends.

A start input begins an acquisition and the controller counts the required number of samples before disabling capture and asserting done.

### stream_tx.v
Reads samples from the FIFO and presents them through an 8-bit valid/ready streaming interface.
A three-state finite state machine is used:

IDLE → WAIT_FIFO → SEND

The WAIT_FIFO state accounts for the synchronous read latency of the FIFO before asserting tx_valid.

### daq_system.v
Top-level integration of the acquisition system.

The overall logic chain is:
ADC Data → Capture / Acquisition Control → FIFO → Stream Controller → Output

##Simulation
Icarus Verilog was used to simulate the HDL and GTKWave was used to inspect the resulting waveforms.

Individual modules were tested before integrating the complete system.
The final system test used the following sample sequence:
0x10 → 0x20 → 0x30 → 0x40 → 0x50 → 0x60 → 0x70 → 0x80

The same sequence was observed at the streamed output with no missing or reordered samples.


## Debugging and Design Changes


### FIFO Read Latency
The original streaming logic attempted to transmit FIFO data during the same cycle that a read was requested.
Because the FIFO uses synchronous reads, the requested value is not available until the following clock cycle.

The transmitter was therefore redesigned using:
IDLE → WAIT_FIFO → SEND
This ensures that the FIFO output is valid before transmission.

### ADC Pipeline Alignment
During integration, a one-clock offset was observed between the registered ADC sample and the FIFO write operation.

This occurred because non-blocking assignments update registers after the active clock event.

For the final simplified acquisition path, the FIFO write data was aligned directly with the ADC input bus while the registered sample remained available for monitoring and verification.

## 32 MHz Verification
The full acquisition datapath was simulated using a 31.25 ns clock period, corresponding to 32 MHz.
The complete sample sequence remained correct during the 32 MHz simulation.

The RTL was then:
- synthesized using Yosys
- placed and routed using nextpnr-ecp5
- timing analysed against a 32 MHz target
- packaged into an ECP5 bitstream using ecppack

The placed-and-routed design reported:
PASS at 32.00 MHz

with an internal maximum clock frequency of approximately:
233.54 MHz

The 233.54 MHz value represents the timing capability of the analysed internal FPGA paths and is not the sampling rate of the complete mixed-signal system.

## Physical Constraints
The PCB clock is connected to FPGA ball `E7`.
The AD9280 parallel data bus is mapped as follows:

 ADC ECP5 Ball 
- D0 - A2 
- D1 - B3 
- D2 - A3 
- D3 - A4 
- D4 - E4 
- D5 - D4 
- D6 - C4 
- D7 - B4 

Some simulation-oriented top-level interfaces were left physically unconstrained during timing analysis because the PCB was not assembled.

## Tools
- Verilog
- OSS CAD Suite
- Icarus Verilog
- GTKWave
- Yosys
- nextpnr-ecp5
- Project Trellis /ecppack

## Status
Completed:
- ADC capture logic
- FIFO buffering
- acquisition control
- streamed FIFO readout
- module level simulation
- full system simulation
- 32 MHz simulation
- ECP5 synthesis
- place and route
- 32 MHz timing verification
- bitstream generation

Not physically verified due to the board not being assembled.
