# Hardware Design

This folder contains the hardware design files for the high Speed FPGA Data Acquisition Board.

The board was designed around a Lattice ECP5 FPGA and Analog Devices AD9280 8-bit ADC, with analogue signal conditioning, multi rail power regulation, FPGA configuration circuitry and parallel ADC-to-FPGA routing implemented on a custom 4-layer PCB.

## Main Components
- **FPGA:** Lattice  LFE5U-12F-6BG256C
- **ADC:** Analog Devices  AD9280ARSZRL — 8-bit ADC, rated up to 32 MSPS
- **Analogue Amplifier:** OPA836
- **Configuration Flash:** W25Q128JVS
- **System Oscillator:** 25 MHz ECS-2520MV oscillator
- **3.3 V Regulator:** TLV62569
- **1.1 V FPGA Core Regulator:** TLV62569
- **2.5 V Regulator:** LT1963
- **Programming Interface:** JTAG
- **Power Input:** USB-C

## PCB Stack-Up
The board uses a 4-layer stack-up:

 Layer - Purpose 
 F.Cu  - Components and primary signal routing 
 In1.Cu  -Continuous ground plane 
 In2.Cu  -Power distribution 
 B.Cu -Secondary signal routing 

A continuous ground plane was used directly beneath the main signal layers to provide short return current paths and reduce signal loop area.

The internal power layer distributes the FPGA core, auxiliary, digital and analogue supply rails.

## Power Architecture
The board generates several supply rails from the USB-C 5 V input:

- 5 V — main input supply
- .3 V — FPGA I/O and digital circuitry
- 3.3 VA — filtered analogue supply
- 2.5 V — FPGA auxiliary supply
  - 1.1 V — FPGA core supply

Ferrite bead filtering is used to separate sensitive analogue supply sections from the main digital power network.

Local decoupling capacitors are positioned around the FPGA, ADC and supporting ICs to provide high-frequency current locally and reduce supply noise.

## ADC to FPGA Interface

The AD9280 presents each conversion to the FPGA through an 8-bit parallel digital bus.

 ADC Data - FPGA Ball 

- D0  - A2 
- D1  - B3 
- D2  - A3 
- D3  - A4 
- D4  - E4 
- D5  - D4 
- D6  - C4 
- D7  - B4 

This parallel interface allows the FPGA to capture the complete 8-bit ADC output on each sampling clock.

##Clocking
The board contains a **25 MHz oscillator** connected to FPGA ball E7.

`E7` is the physical BGA connection through which the clock signal enters the FPGA.

The clock provides the timing reference used by the FPGA logic and ADC acquisition system.

- The AD9280 itself is rated for operation up to 32 MSPS. The current PCB uses a 25 MHz onboard oscillator, so operation of the physical board at 32 MSPS would require an appropriate clock-source revision.

##FPGA Configuration

The hardware includes:
- JTAG programming interface
- External SPI configuration flash
- FPGA configuration support circuitry

The JTAG interface allows direct FPGA programming and debugging, while the external flash provides non volatile storage for FPGA configuration data.

## PCB Layout Considerations
The layout was designed with consideration for:
- Continuous signal return paths
- Short ADC-to-FPGA parallel routes
- Local decoupling
- Separation of analogue and digital power distribution
- FPGA BGA escape routing
- Dedicated internal ground plane
- Multi rail FPGA power requirements
- Short switching regulator current loops

##PCB Renders
### Front
![Front PCB](docs/images/front_pcb_new.pn

### Back
![Back PCB](docs/images/Back_of_pcb.png)

##Design Status
The schematic and PCB layout have been completed and PCB design rule checks were performed.

The board has not been physically fabricated or electrically validated, therefore hardware performance measurements are outside the scope of the current project.
