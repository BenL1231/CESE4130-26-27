`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.09.2024 15:11:11
// Design Name:
// Module Name: async_en_decode
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module async_en_decode(
    input wire reset,
    input wire prog_select,
    input wire [2:0] bin_rot,
    input wire [3:0] gray_rot,
    output reg [3:0] led
    );
    // led was 3:0 cahnge to 2:0
    //write code here
    always@(*) begin
        if (reset) begin
        led = 0;
        end
        else begin
            if (prog_select) begin
                led[3] = 0;
                led[2:0] = ~bin_rot[2:0];
            end
            else begin
            //grey
            case(gray_rot[3:0])
                4'b1001 : led = 4'b1000;
                4'b1101 : led = 4'b1100;
                4'b1100 : led = 4'b0100;
                4'b1110 : led = 4'b0110;
                4'b0110 : led = 4'0010;
                4'b0111 : led = 4'0011;
                4'b1111 : led = 4'b0001;
                4'b1011 : led = 4'b1001;
                default: begin end
            endcase
               
         end
      end
    end
   
   
   
   
   
   
Endmodule
