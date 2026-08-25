module daq_system ( //DAQ FPGA subsystem
    input  wire clk,
    input  wire  reset,
    input  wire start//starts acquisition

    input  wire [7:0] adc_data,
    input  wire  tx_ready,
    output wire [7:0] tx_data,
    output wire tx_valid,

    output wire  capture_done,
    output wire  fifo_full,
    output wire  fifo_empty
);

    wire [7:0] captured_sample;
    wire sample_valid;

    wire capture_en;
    wire [7:0] fifo_read_data;
    wirefifo_read_en;

    
    //ADC capture
    adc_capture capture_inst ( //creates a physical instance of your previously defined adc_capture module
        .adc_clk(clk),
        .adc_data(adc_data),
        .sample(captured_sample),
        .sample_valid(sample_valid)
    );

    
    //Capture 8 samples
    acquisition_ctrl #(
        .SAMPLE_COUNT(8)
    ) control_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .capture_en(capture_en),
        .done(capture_done)
    );

    
    //sample FIFO
    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16),//sixteen sample storage positions
        .ADDR_WIDTH(4)
    ) fifo_inst (
        .clk(clk),
        .reset(reset),

        .write_en(capture_en && !fifo_full), //fIFO writes only when acquisition is on and FIFO isnt full
        .write_data(adc_data),
        .read_en(fifo_read_en),
        .read_data(fifo_read_data),
        .full(fifo_full),
        .empty(fifo_empty)
    );
    //Output byte streamer
    stream_tx stream_inst (
        .clk(clk),
        .reset(reset),

        .fifo_data(fifo_read_data),
        .fifo_empty(fifo_empty),
        .fifo_read_en(fifo_read_en),
        .tx_ready(tx_ready),
        .tx_data(tx_data),
        .tx_valid(tx_valid)
    );
endmodule