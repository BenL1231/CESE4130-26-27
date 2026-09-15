`timescale 1ns / 1ps
module testbench;
reg reset;
reg [2:0] bin_rot;
wire [3:0] led;
 reg prog_select;
 reg [3:0] gray_rot;


async_en_decode uut ( // Instantiate the unit under test
.reset(reset),
.bin_rot(bin_rot),
.led(led),
.prog_select(prog_select),
.gray_rot(gray_rot)
);


    initial begin // Stimulus block
        reset = 1; // Initialize inputs
        bin_rot = 0;
        gray_rot = 0;
        prog_select = 0;
        #10;
        reset = 0;
        prog_select = 1;
        #10;
       
        #10 bin_rot = 3'b001; // Test inputs
        #10 bin_rot = 3'b010;
        reset = 1;
        #10 bin_rot = 3'b110;
        reset = 0;
        #10 bin_rot = 3'b100;
        #10 bin_rot = 3'b111;
        prog_select = 0;
        #10 gray_rot = 4'b1000;
        #10 gray_rot = 4'b0001;
        #10 gray_rot = 4'b1001;
        #10 gray_rot = 4'b0011;
        reset = 1;
        #10 gray_rot = 4'b0110;
        reset = 0;
        #10 gray_rot = 4'b1100;
        #50; // Wait and finish
        $finish;
    end
endmodule
