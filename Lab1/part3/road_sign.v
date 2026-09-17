`timescale 1ns / 1ps

module road_sign(
    input wire clk,       // Clock signal
    input wire reset,     // Reset signal to restart the FSM
    input wire [3:0] btn, // 4-bit input register (btn[0], btn[1], btn[2], btn[3])
    output reg [3:0] led, // 4-bit output register
    output reg [2:0] rgb_led
);

    parameter idle    = 2'b00,
              warning = 2'b01,
              right   = 2'b10,
              left    = 2'b11;

    reg [1:0] mode, next_mode;
    reg enableL, enableR, enableW;

    wire [3:0] led_l, led_r, led_w;

    // Submodule Instantiations with isolated output wires
    left l (
        .clk(clk),
        .reset(reset),
        .btnON(enableL),
        .led(led_l)
    );

    right r (
        .clk(clk),
        .reset(reset),
        .btnON(enableR),
        .led(led_r)
    );

    warning w (
        .clk(clk),
        .reset(reset),
        .btnON(enableW),
        .led(led_w)
    );

    // Sequential State Register
    always @(posedge clk) begin
        if (reset)
            mode <= idle;
        else
            mode <= next_mode;
    end

    // Next State Logic
    always @(*) begin
        next_mode = mode; // Default stay in current state
        case (mode)
            idle: begin
                if (btn[0])      next_mode = left;
                else if (btn[1]) next_mode = right;
                else if (btn[2]) next_mode = warning;
            end

            left, right, warning: begin
                if (btn[3])      next_mode = idle; // Fixed index from btn[4] to btn[3]
            end

            default: next_mode = idle;
        endcase
    end

    // Output Enable Control Logic
    always @(*) begin
        enableL = 1'b0;
        enableR = 1'b0;
        enableW = 1'b0;

        case (mode)
            left:    enableL = 1'b1;
            right:   enableR = 1'b1;
            warning: enableW = 1'b1;
        endcase
    end

    // LED Output Multiplexer
    always @(*) begin
        case (mode)
            left:    begin led = led_l; rgb_led = 3'b001; end
            right:   begin led = led_r; rgb_led = 3'b010; end
            warning: begin led = led_w; rgb_led = 3'b100; end
        endcase
    end

endmodule