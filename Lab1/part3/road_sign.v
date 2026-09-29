`timescale 1ns / 1ps



module road_sign(
    input wire clk,      // Clock signal
    input wire reset,    // Reset signal to restart the FSM
    input wire [3:0] btn, // 4-bit input register
    output reg [3:0] led, // 4-bit output register
    output reg [2:0] rgb_led
    );

    parameter TICK_CYCLES = 62_500_000;
    localparam [1:0] MODE_IDLE    = 2'd0,
                     MODE_LEFT    = 2'd1,
                     MODE_RIGHT   = 2'd2,
                     MODE_WARNING = 2'd3;

    localparam [2:0] S0 = 3'd0,
                     S1 = 3'd1,
                     S2 = 3'd2,
                     S3 = 3'd3,
                     S4 = 3'd4,
                     S5 = 3'd5;

    localparam [2:0] RGB_OFF    = 3'b000,
                     RGB_BLUE   = 3'b001,
                     RGB_GREEN  = 3'b010,
                     RGB_RED    = 3'b100,
                     RGB_YELLOW = 3'b110;

    reg [1:0]  mode,      mode_next;
    reg [2:0]  step,      step_next;
    reg [31:0] tick_cnt;
    wire       tick;


    assign tick = (tick_cnt == TICK_CYCLES - 1);

    always @(posedge clk) begin
        if (reset || tick) begin
            tick_cnt <= 32'd0;
        end else begin
            tick_cnt <= tick_cnt + 32'd1;
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            mode <= MODE_IDLE;
        end else begin
            mode <= mode_next;
        end
    end

    always @(*) begin
        mode_next = mode;                       
        case (mode)
            MODE_IDLE: begin                    
                if (btn[3]) begin
                    mode_next = MODE_IDLE;
                end else if (btn[0]) begin
                    mode_next = MODE_LEFT;
                end else if (btn[1]) begin
                    mode_next = MODE_RIGHT;
                end else if (btn[2]) begin
                    mode_next = MODE_WARNING;
                end
            end
            MODE_LEFT, MODE_RIGHT, MODE_WARNING: begin
                if (btn[3]) begin               
                    mode_next = MODE_IDLE;
                end
            end
            default: begin
                mode_next = MODE_IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            step <= S0;
        end else if (tick) begin
            step <= step_next;
        end
    end


    always @(*) begin
        case (step)
            S0:      step_next = S1;
            S1:      step_next = S2;
            S2:      step_next = S3;
            S3:      step_next = S4;
            S4:      step_next = S5;
            S5:      step_next = S0;
            default: step_next = S0;
        endcase
    end

    always @(*) begin
        case (mode)
            MODE_LEFT: begin
                case (step)
                    S0:      led = 4'b0000;
                    S1:      led = 4'b0001;
                    S2:      led = 4'b0011;
                    S3:      led = 4'b0110;
                    S4:      led = 4'b1100;
                    S5:      led = 4'b1000;
                    default: led = 4'b0000;     
                endcase
            end
            MODE_RIGHT: begin
                case (step)
                    S0:      led = 4'b0000;
                    S1:      led = 4'b1000;
                    S2:      led = 4'b1100;
                    S3:      led = 4'b0110;
                    S4:      led = 4'b0001;
                    default: led = 4'b0000;     
                endcase
            end
            MODE_WARNING: begin
                case (step)
                    S0: led = 4'b0000;  
                    S1: led = 4'b1100;
                    S2: led = 4'b0011;
                    default:    led = 4'b0000;
                endcase
            end
            default: begin                      
                led = 4'b0000;
            end
        endcase
    end

    always @(*) begin
        case (mode)
            MODE_LEFT:    rgb_led = RGB_GREEN;
            MODE_RIGHT:   rgb_led = RGB_RED;
            MODE_WARNING: rgb_led = RGB_YELLOW;
            default:      rgb_led = RGB_BLUE;   
        endcase
    end

endmodule
