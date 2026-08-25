module stream_tx ( //transmitter module
    input  wire clk,
    input  wire reset,

    input  wire [7:0] fifo_data,
    input  wire fifo_empty,

    output reg fifo_read_en, //the transmitter raises this when it wants the FIFO to provide its next byte
    input  wire tx_ready,
    output reg  [7:0] tx_data,
    output reg tx_valid
);
    //these define three numeric states
    localparam IDLE = 2'd0;
    localparam WAIT_FIFO = 2'd1;
    localparam SEND = 2'd2;

    reg [1:0] state;//two-bit register storing which state the transmitter is currently in

    always @(posedge clk) begin
        if (reset) begin
            state<= IDLE;
            fifo_read_en <= 1'b0;
            tx_data <= 8'h00;
            tx_valid <= 1'b0;
        end
        else begin
            fifo_read_en <= 1'b0;
            tx_valid<= 1'b0;

            case (state)

                IDLE: begin //transmitter isnt currently doing anything
                    if (!fifo_empty && tx_ready) begin //begin transfer only if this occurs FIFO contains data and reciever is ready
                        fifo_read_en <= 1'b1;
                        state <= WAIT_FIFO;
                    end
                end
                WAIT_FIFO: begin
                    //Give synchronous FIFO one clock
                    //to update fifo_data
                    state <= SEND;
                end
                SEND: begin
                    tx_data  <= fifo_data;//copy the now valid FIFO byte onto the transmitter output
                    tx_valid <= 1'b1;//tx_valid is valid in this cycle
                    state    <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule