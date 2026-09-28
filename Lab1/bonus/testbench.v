`timescale 1ns / 1ps

module testbench();

    reg clk;
    reg reset;
    reg [5:0] seed;

    wire [5:0] lfsr_out;
    wire [7:0] cycle_counter;
    wire repetition;

    LFSR uut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .lfsr_out(lfsr_out),
        .cycle_counter(cycle_counter),
        .repetition(repetition)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 0;
        seed = 6'b00_0000;

        
        seed = 6'b01_1001;
        reset = 1;
        #10;
        reset = 0;
        wait(repetition);
        #10;

        
        seed = 6'b10_1001;
        reset = 1;
        #10;
        reset = 0;
        wait(repetition);
        #10;

        
        seed = 6'b00_0000;
        reset = 1;
        #10;
        reset = 0;
        #30;

        
        $finish;
    end

    

endmodule
