`timescale 1ns / 1ps

module testbench();

    // Testbench Signals
    reg clk;
    reg reset;
    reg [3:0] btn;

    wire [3:0] led;
    wire [2:0] rgb_led;

    // Clock Period Definition (10ns = 100MHz / adjust as needed)
    localparam CLK_PERIOD = 10;

    // Instantiate Unit Under Test (UUT)
    road_sign uut (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .led(led),
        .rgb_led(rgb_led)
    );

    // Clock Generation
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Test Sequence
    initial begin
        // Initialize Signals
        clk   = 0;
        reset = 1;
        btn   = 4'b0000;

        // Apply Global Reset
        #(CLK_PERIOD * 5);
        reset = 0;
        #(CLK_PERIOD * 2);

        // -------------------------------------------------------------
        // TEST 1: Enter Point-Left Mode (BTN0)
        // -------------------------------------------------------------
        $display("[%0t ns] Pressing BTN0 -> Transition to Point-Left Mode", $time);
        btn = 4'b0001; // Press BTN0
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button

        // Run through multiple internal submodule clock cycles to observe LED pattern
        #(CLK_PERIOD * 12);

        // Return to Idle Mode (BTN3)
        $display("[%0t ns] Pressing BTN3 -> Transition back to Idle Mode", $time);
        btn = 4'b1000; // Press BTN3
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button
        #(CLK_PERIOD * 4);

        // -------------------------------------------------------------
        // TEST 2: Enter Point-Right Mode (BTN1)
        // -------------------------------------------------------------
        $display("[%0t ns] Pressing BTN1 -> Transition to Point-Right Mode", $time);
        btn = 4'b0010; // Press BTN1
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button

        #(CLK_PERIOD * 12);

        // Return to Idle Mode (BTN3)
        $display("[%0t ns] Pressing BTN3 -> Transition back to Idle Mode", $time);
        btn = 4'b1000; // Press BTN3
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button
        #(CLK_PERIOD * 4);

        // -------------------------------------------------------------
        // TEST 3: Enter Warning Mode (BTN2)
        // -------------------------------------------------------------
        $display("[%0t ns] Pressing BTN2 -> Transition to Warning Mode", $time);
        btn = 4'b0100; // Press BTN2
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button

        #(CLK_PERIOD * 10);

        // Return to Idle Mode (BTN3)
        $display("[%0t ns] Pressing BTN3 -> Transition back to Idle Mode", $time);
        btn = 4'b1000; // Press BTN3
        #(CLK_PERIOD * 2);
        btn = 4'b0000; // Release Button
        #(CLK_PERIOD * 4);

        // -------------------------------------------------------------
        // TEST 4: Safe State Constraint (Direct cross-mode transition check)
        // Attempt to press BTN0 while in Warning Mode (should be ignored)
        // -------------------------------------------------------------
        $display("[%0t ns] Testing Safe State Rule: Trying to go straight to Left Mode from Idle...", $time);
        btn = 4'b0001; // Go to Left Mode
        #(CLK_PERIOD * 2);
        btn = 4'b0000;
        #(CLK_PERIOD * 2);

        $display("[%0t ns] Pressing BTN1 while in Left Mode (Should remain in Left Mode)", $time);
        btn = 4'b0010; // Try to switch to Right directly
        #(CLK_PERIOD * 4);
        btn = 4'b0000;

        // Reset back to Idle properly
        btn = 4'b1000;
        #(CLK_PERIOD * 2);
        btn = 4'b0000;
        #(CLK_PERIOD * 4);

        $display("[%0t ns] Simulation Complete!", $time);
        $finish;
    end

    // Monitor Output Transitions in Console
    initial begin
        $monitor("Time = %0t ns | Reset = %b | BTN = %b | LED = %b | RGB_LED = %b", 
                 $time, reset, btn, led, rgb_led);
    end

endmodule