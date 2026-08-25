module acquisition_ctrl #(  //creates a configurable acquisition controller
    parameter SAMPLE_COUNT = 16
)(
    input wire clk,
    input wire reset,
    input wire start,
    output reg  capture_en,
    output reg  done
);

    reg [7:0] sample_counter;
    always @(posedge clk) begin//controller updates at each rising clock edge
        if (reset) begin
            capture_en <= 1'b0;
            done <= 1'b0;
            sample_counter <= 0;
        end
        else begin
            if (start && !capture_en && !done) begin
                capture_en <= 1'b1;
                sample_counter<= 0;
            end
            if (capture_en) begin
                if (sample_counter == SAMPLE_COUNT - 1) begin //check whether we reached the final sample
                    capture_en <= 1'b0;
                    done <= 1'b1;
                end
                else begin
                    sample_counter <= sample_counter + 1'b1;
                end
            end
        end
    end

endmodule