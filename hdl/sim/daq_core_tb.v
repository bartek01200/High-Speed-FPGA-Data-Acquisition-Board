`timescale 1ns/1ps
module daq_core_tb;
    reg clk;
    reg reset;

    reg [7:0] adc_data;
    reg fifo_read_en;
    wire [7:0] fifo_read_data;
    wire fifo_empty;
    wire fifo_full;
    daq_core dut (
        .clk(clk),
        .reset(reset),
        .adc_data(adc_data),
        .fifo_read_en(fifo_read_en),
        .fifo_read_data(fifo_read_data),
        .fifo_empty(fifo_empty),
        .fifo_full(fifo_full)
    );
    //25 MHz clock
    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end
    initial begin
        reset = 1;
        adc_data = 8'h00;
        fifo_read_en = 0;

        #40;
        reset = 0;
        // Simulated ADC samples
        @(negedge clk); adc_data = 8'h10;
        @(negedge clk); adc_data = 8'h20;
        @(negedge clk); adc_data = 8'h30;
        @(negedge clk); adc_data = 8'h40;
        @(negedge clk); adc_data = 8'h50;
        @(negedge clk); adc_data = 8'h60;
        // Stop changing ADC input
        @(negedge clk);
        adc_data = 8'h60;
        // Wait
        #80;
        // Read samples back
        fifo_read_en = 1;

        repeat (8)
            @(negedge clk);
        fifo_read_en = 0;
        #100;
        $finish;
    end
    initial begin
        $dumpfile("daq_core.vcd");
        $dumpvars(0, daq_core_tb);
    end

endmodule