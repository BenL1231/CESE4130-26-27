`timescale 1ns / 1ps


module encoder (
    input wire reset, // Reset pin
    input wire clk,   // Clock signal
    input wire A,     // Button A input
    input wire B,     // Button B input
    output reg [3:0] EncOut  // 4-bit Gray code output
    );
    reg A_prev = 4'd0;
    reg B_prev = 4'd0;
    reg [3:0] counter = 0;
    wire A_pressed = A & ~A_prev;
    wire B_pressed = B & ~B_prev;
    
    always @(posedge clk) begin
        A_prev <= A;
        B_prev <= B;
        
        if(reset) begin
            counter = 0;
            A_prev <= 0;
            A_prev <= 0;
            EncOut <= 0; 
        end else begin
            if(A_pressed) begin
               counter <= counter +4'd1;
            end
            if (B_pressed) begin
                counter <= counter - 4'd1;
            end
        end
        case(counter[3:0])
            4'b1001 : EncOut = 4'b0001;
            4'b1101 : EncOut = 4'b0011;
            4'b1100 : EncOut = 4'b0010;
            4'b1110 : EncOut = 4'b0110;
            4'b0110 : EncOut = 4'b0100;
            4'b0111 : EncOut = 4'b1100;
            4'b1111 : EncOut = 4'b1000;
            4'b1011 : EncOut = 4'b1001;
            default: EncOut = 4'b0000;
        
        endcase 
     end
     //always @(*) begin
        //EncOut = counter;
     //end
endmodule
    
