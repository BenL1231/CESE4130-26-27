`timescale 1ns / 1ps

module LFSR (
    input wire clk,
    input wire reset,
    input wire [5:0] seed,
    output reg [5:0] lfsr_out,
    output reg [7:0] cycle_counter,
    output wire repetition
);

    wire feedback;
    assign feedback = lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[2];

    assign repetition = (lfsr_out == seed) && (cycle_counter > 0);

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 8'd0;
            lfsr_out <= seed;
        end else begin
            if (!repetition) begin
                lfsr_out <= {lfsr_out[4:0], feedback};
                cycle_counter <= cycle_counter + 1;
            end
        end
    end

endmodule