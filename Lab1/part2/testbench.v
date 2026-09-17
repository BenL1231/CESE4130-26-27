`timescale 1ns / 1ps



module testbench;
    reg clk;
    reg     reset;
    reg     A;
    reg B;
    wire [3:0] EncOut;

    encoder uut(
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .EncOut(EncOut)
    );   
    
    initial begin
        clk =0;
        forever #5 clk = ~clk;
    end
    
    
    initial begin
        reset =1;
        A = 0;
        B = 0;
            
        #10
        reset =0;
        
        #10 A = 1;
        #10 A = 0;
        #10 A = 1;
        #10 A = 0;
        //#10 B = 1;
        //#10 B = 0;
        #10 A = 1;
        #10 A = 0;
        #10 A = 1;
        #10 A = 0;
        #10 A = 1;
        #10 A = 0;    
        #50; // Wait and finish
        $finish;
            
    end
    
endmodule
