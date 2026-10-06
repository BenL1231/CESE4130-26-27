module warning(
    input wire clk,
    input wire tick,
    input wire reset,
    output reg [3:0] led
);
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 2'd0;
        else if (tick) begin
            if (state == 2'd2)
                state <= 2'd0;
            else
                state <= state + 1'b1;
        end
    end

    always @(*) begin
        case (state)
            2'd0: led = 4'b0000;
            2'd1: led = 4'b1100;
            2'd2: led = 4'b0011;
            default: led = 4'b0000;
        endcase
    end
endmodule
