`timescale 1ns / 1ps



module left(
input wire clk,
input wire reset,
input wire btnON,
output reg [3:0] led
);

parameter     s1 = 4'b0000,
              s2 = 4'b0001,
              s3 = 4'b0011,
              s4 = 4'b0110,
              s5 = 4'b1100,
              s6 = 4'b1000;
              
reg [3:0] state, next_state;

    always @(posedge clk) begin
        if (reset || !btnON)
            state <= s1;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case (state)
            s1: next_state = s2;
            s2: next_state = s3;
            s3: next_state = s4;
            s4: next_state = s5;
            s5: next_state = s6;
            s6: next_state = s1;
        endcase
    end
    
    
    always @(*) begin
        if (btnON)
            led = state;
        else
            led = 0;
    end

    
endmodule
