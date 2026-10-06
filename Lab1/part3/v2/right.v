module right(
    input wire clk,
    input wire tick,
    input wire reset,
    output reg [3:0] led
);
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else if (tick) begin
            if (state == 3'd5)
                state <= 3'd0;
            else
                state <= state + 1'b1;
        end
    end

    always @(*) begin
        case (state)
            3'd0: led = 4'b0000;
            3'd1: led = 4'b1000;
            3'd2: led = 4'b1100;
            3'd3: led = 4'b0110;
            3'd4: led = 4'b0001;
            3'd5: led = 4'b0000;
            default: led = 4'b0000;
        endcase
    end
endmodule
