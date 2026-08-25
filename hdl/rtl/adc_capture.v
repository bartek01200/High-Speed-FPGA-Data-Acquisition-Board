module adc_capture ( //Creates a hardware module called adc_capture
    input wire adc_clk, //Creates a 1-bit clock input
    input wire [7:0] adc_data,//Creates an 8-bit input bus for AD2980

    output reg [7:0] sample,
    output reg sample_valid//Creates a 1-bit signal telling other logic that the sample register has been populated
);

    always @(posedge adc_clk) begin//Every time adc_clk transitions from LOW to HIGH, perform register updates
        sample  <= adc_data;//At every rising edge, copy the current eight ADC bits into sample
        sample_valid<= 1'b1;
    end //Ends the clocked block

endmodule //Ends the adc_capture hardware module.