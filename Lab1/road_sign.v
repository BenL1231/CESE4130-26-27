module road_sign(
    input wire clk,
    input wire reset,
    input wire [3:0] btn,
    output reg [3:0] led,
    output reg [2:0] rgb_led
);

    parameter s0 = 3'b000,
              s1 = 3'b001,
              s2 = 3'b010,
              s3 = 3'b011,
              s4 = 3'b100,
              s5 = 3'b101;

    parameter idle    = 2'b00,
              warning = 2'b01,
              right   = 2'b10,
              left    = 2'b11;

    reg [2:0] state, next_state;
    reg [1:0] mode, next_mode;

    always @(posedge clk) begin
        if (reset)
            mode <= idle;
        else
            mode <= next_mode;
    end

    always @(*) begin
        next_mode = mode;
        case (mode)
            idle: begin
                if      (btn[0]) next_mode = left;
                else if (btn[1]) next_mode = right;
                else if (btn[2]) next_mode = warning;
            end

            left, right, warning: begin
                if (btn[3]) next_mode = idle;
            end

            default: next_mode = idle;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= s0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            s0: next_state = s1;
            s1: next_state = s2;
            s2: next_state = s3;
            s3: next_state = s4;
            s4: next_state = s5;
            s5: next_state = s0;
            default: next_state = s0;
        endcase
    end

    always @(*) begin
        case (mode)
            idle:    rgb_led = 3'b000;
            left:    rgb_led = 3'b100;
            right:   rgb_led = 3'b010;
            warning: rgb_led = 3'b001;
            default: rgb_led = 3'b000;
        endcase
    end

    always @(*) begin
        case (mode)
            idle: led = 4'b0000;

            left: begin
                case (state)
                    s0: led = 4'b0000; 
                    s1: led = 4'b0001;  
                    s2: led = 4'b0011; 
                    s3: led = 4'b0110; 
                    s4: led = 4'b1100; 
                    s5: led = 4'b1000; 
                    default: led = 4'b0000;
                endcase
            end

            right: begin
                case (state)
                    s0: led = 4'b0000;  
                    s1: led = 4'b1000; 
                    s2: led = 4'b1100; 
                    s3: led = 4'b0110;  
                    s4: led = 4'b0011; 
                    s5: led = 4'b0001;
                    default: led = 4'b0000;
                endcase
            end

            warning: begin
                case (state)
                    s0, s2, s4: led = 4'b1111;
                    s1, s3, s5: led = 4'b0000;
                    default:    led = 4'b0000;
                endcase
            end

            default: led = 4'b0000;
        endcase
    end

endmodule
