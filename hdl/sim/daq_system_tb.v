`timescale 1ns/1ps
module daq_system_tb;
    reg clk;
    reg reset;
    reg start;

    reg [7:0] adc_data;

    reg tx_ready;
    wire [7:0] tx_data;
    wire tx_valid;
    wire capture_done;
    wire fifo_full;
    wire fifo_empty;

    daq_system dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .adc_data(adc_data),

        .tx_ready(tx_ready),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .capture_done(capture_done),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );
    //25MHz clock
    //40ns period
    initial begin
        clk = 0;
        forever #15.625 clk = ~clk;
    end
    initial begin
        reset    = 1;
        start    = 0;
        adc_data = 8'h10;
        tx_ready = 0;

        #80;

        @(negedge clk);
        reset = 0;

// Start acquisition
        @(negedge clk);
        start = 1;
        @(negedge clk);
        start = 0;

// Subsequent ADC samples
        @(negedge clk); adc_data = 8'h20;
        @(negedge clk); adc_data = 8'h30;
        @(negedge clk); adc_data = 8'h40;
        @(negedge clk); adc_data = 8'h50;
        @(negedge clk); adc_data = 8'h60;
        @(negedge clk); adc_data = 8'h70;
        @(negedge clk); adc_data = 8'h80;
        //Wait until acquisition completes
        wait(capture_done);
        //Give FIFO a couple clocks
        repeat (2)
        @(negedge clk);

        //PC/interface is now ready to accept data
        tx_ready = 1;
        //Allow complete transfer
        #1000;
        $finish;
    end
    initial begin
        $dumpfile("daq_system.vcd");
        $dumpvars(0, daq_system_tb);
    end

endmodule