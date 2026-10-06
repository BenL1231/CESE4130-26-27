`timescale 1ns / 1ps

module road_sign(
    input wire clk,       // Clock signal
    input wire reset,     // Reset signal
    input wire [3:0] btn, // 4-bit input register
    output reg [3:0] led, // 4-bit output register
    output reg [2:0] rgb_led
);

    parameter TICK_CYCLES = 62_500_000;

    parameter idle    = 2'b00,
              left    = 2'b01,
              right   = 2 me10,
              warning = 2'b11;

    reg [1:0] mode, next_mode;
    wire [3:0] led_l, led_r, led_w;

    // Clock Divider Logic
    reg [31:0] tick_cnt;
    wire tick = (tick_cnt == TICK_CYCLES - 1);

    always @(posedge clk) begin
        if (reset || tick)
            tick_cnt <= 32'd0;
        else
            tick_cnt <= tick_cnt + 32'd1;
    end

    // Sequential State Register
    always @(posedge clk) begin
        if (reset)
            mode <= idle;
        else
            mode <= next_mode;
    end

    // Next State Logic
    always @(*) begin
        next_mode = mode;
        case (mode)
            idle: begin
                if (btn[0])      next_mode = left;
                else if (btn[1]) next_mode = right;
                else if (btn[2]) next_mode = warning;
            end
            left, right, warning: begin
                if (btn[3])      next_mode = idle;
            end
            default: next_mode = idle;
        endcase
    end

    // Submodule Instantiations (Pass tick signal)
    left l (
        .clk(clk),
        .tick(tick),
        .reset(reset || (mode != left)),
        .led(led_l)
    );

    right r (
        .clk(clk),
        .tick(tick),
        .reset(reset || (mode != right)),
        .led(led_r)
    );

    warning w (
        .clk(clk),
        .tick(tick),
        .reset(reset || (mode != warning)),
        .led(led_w)
    );

    // LED Output Multiplexer with default state handling
    always @(*) begin
        case (mode)
            left:    begin led = led_l; rgb_led = 3'b010; end // Green
            right:   begin led = led_r; rgb_led = 3'b100; end // Red
            warning: begin led = led_w; rgb_led = 3'b110; end // Yellow
            default: begin led = 4'b0000; rgb_led = 3'b001; end // Blue
        endcase
    end

endmodule
