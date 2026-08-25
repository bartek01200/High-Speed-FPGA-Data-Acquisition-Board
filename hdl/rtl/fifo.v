module fifo #( //The "#(" means it has configurable parameters
    parameter DATA_WIDTH = 8,//Sets the default data width to 8 bits.
    parameter DEPTH = 16, //Sets the FIFO to 16 storage locations.
    parameter ADDR_WIDTH = 4 //Four bits are required to address 16 positions 0000 = 0 and 1111 = 15 thus 16 in total
)(
    input  wire clk,
    input  wire reset,

    input  wire write_en,
    input  wire [DATA_WIDTH-1:0] write_data,//Data entering the FIFO

    input  wire read_en,//Requests a FIFO read
    output reg  [DATA_WIDTH-1:0] read_data,

    output wire full, //if full = 1 this means no more samples will be written
    output wire empty//if empty nothing can be read
);

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];//It creates the FIFO's actual storage
    reg [ADDR_WIDTH-1:0] write_ptr = 0;//creates write pointer
    reg [ADDR_WIDTH-1:0] read_ptr  = 0;//creates a read pointer 

    reg [ADDR_WIDTH:0] count = 0;//stores how many iterms are in the FIFO 
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk) begin//all FIFO operations occur on the rising clock edge
        if (reset) begin//reset has priority
            write_ptr <= 0;//Next write will begin at location 0 and others will be at 0 too
            read_ptr  <= 0;
            count     <= 0;
            read_data <= 0;
        end
        else begin//if reset isnt active, normal FIFO operation occurs
            if (write_en && !full) begin //this protects against writing beyond the FIFO capacity
                memory[write_ptr] <=write_data;//store write_data in whatever location write_ptr currently selects
                write_ptr <= write_ptr+ 1'b1;
            end

            if (read_en && !empty) begin
                read_data <= memory[read_ptr];
                read_ptr <= read_ptr+ 1'b1;
            end

            case ({
                write_en&& !full,
                read_en&& !empty
            })

                2'b10: count<= count+ 1'b1;
                2'b01: count <= count - 1'b1;//Read without write:

                default: count <=count;
            endcase
        end
    end

endmodule