`timescale 1ns/1ps

module adc_capture_tb;
    reg adc_clk;
    reg [7:0] adc_data;

    wire [7:0] sample;
    wire sample_valid;

    adc_capture dut (
        .adc_clk(adc_clk),
        .adc_data(adc_data),
        .sample(sample),
        .sample_valid(sample_valid)
    );
    //25 mHz clock
    //Period= 40ns
    initial begin
        adc_clk = 0;
        forever #20 adc_clk = ~adc_clk;
    end
    
    initial begin
        adc_data = 8'h00;
        #40 adc_data = 8'h10;
        #40 adc_data = 8'h20;
        #40 adc_data = 8'h30;
        #40 adc_data = 8'h40;
        #40 adc_data = 8'h50;
        #40 adc_data = 8'hA5;
        #40 adc_data = 8'hFF;
        #100;
        $finish;
    end
    initial begin
        $dumpfile("adc_capture.vcd");
        $dumpvars(0, adc_capture_tb);
    end

endmodule