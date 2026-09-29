`timescale 1ns / 1ps

module tb_road_sign;

    localparam TICK = 4;                 // clocks per step
    localparam STEP_NS = TICK * 8;       // ns per step (8 ns clock)

    reg        clk = 0;
    reg        reset = 0;
    reg  [3:0] btn = 4'b0000;
    wire [3:0] led;
    wire [2:0] rgb_led;

    integer errors = 0;
    integer i;

    road_sign #(.TICK_CYCLES(TICK)) uut (
        .clk     (clk),
        .reset   (reset),
        .btn     (btn),
        .led     (led),
        .rgb_led (rgb_led)
    );

    always #4 clk = ~clk;                // 125 MHz

    reg [3:0] seq_left    [0:5];
    reg [3:0] seq_right   [0:5];
    reg [3:0] seq_warning [0:5];

    initial begin
        seq_left[0]    = 4'b0001; seq_left[1]    = 4'b0010; seq_left[2]    = 4'b0100;
        seq_left[3]    = 4'b1000; seq_left[4]    = 4'b0000; seq_left[5]    = 4'b0000;
        seq_right[0]   = 4'b1000; seq_right[1]   = 4'b0100; seq_right[2]   = 4'b0010;
        seq_right[3]   = 4'b0001; seq_right[4]   = 4'b0000; seq_right[5]   = 4'b0000;
        seq_warning[0] = 4'b1111; seq_warning[1] = 4'b0000; seq_warning[2] = 4'b1111;
        seq_warning[3] = 4'b0000; seq_warning[4] = 4'b1111; seq_warning[5] = 4'b0000;
    end

    
    task press(input [3:0] mask);
        begin
            @(negedge clk); btn = mask;
            repeat (2) @(negedge clk);
            btn = 4'b0000;
        end
    endtask

    

    initial begin
        reset = 1;
        repeat (2) @(negedge clk);
        reset = 0;
       
        press(4'b0001);
        
        press(4'b0010);
        
        press(4'b0100);
        

 
        press(4'b1000);

        press(4'b0010);
        
       
        press(4'b1000);


        press(4'b0100);

        
        press(4'b0001);
        
      
        reset = 1; @(negedge clk); reset = 0; @(negedge clk);

        $finish;
    end

endmodule
