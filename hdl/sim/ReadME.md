#HDL simulation

The RTL was verified using Icarus Verliog and GTKWave

Verification order:
- adc_capture_tb.v - ADC input capture

- fifo_tb.v - FIFO write/read behaviour

- daq_core_tb.v - integrated ADC capture and buffering

- daq_system_tb.v = complete acquistion and streamed readout

  final system simulation used a 32Mhz clock verified:

  0x10 -> 0x20 -> 0x30 -> 0x40 -> 0x50 -> 0x60 -> 0x70 -> 0x80
