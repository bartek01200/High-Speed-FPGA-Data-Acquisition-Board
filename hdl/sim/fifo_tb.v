`timescale 1ns/1ps
module fifo_tb;
    reg clk;
    reg reset;
    reg write_en;
    reg [7:0] write_data;

    reg read_en;
    wire [7:0] read_data;
    wire full;
    wire empty;

    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16),
        .ADDR_WIDTH(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .write_data(write_data),
        .read_en(read_en),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    initial begin
        clk = 0;
        forever #20 clk =~clk;
    end

    initial begin
        reset = 1;
        write_en = 0;
        read_en = 0;
        write_data = 0;
        #40;
        reset = 0;
        @(negedge clk);
        write_en = 1;
        write_data = 8'h10;
        @(negedge clk);
        write_data = 8'h20;

        @(negedge clk);
        write_data = 8'h30;
        @(negedge clk);
        write_data = 8'h40;
        @(negedge clk);
        write_en = 0;
        #80;
        @(negedge clk);
        read_en = 1;

        repeat (4)
            @(negedge clk);
        read_en = 0;
        #80;
        $finish;
    end
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);
    end

endmodule