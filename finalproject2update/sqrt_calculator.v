module sqrt_calculator(
    input clk,
    input rst,
    input start,                 // Start signal for square root calculation
    input [31:0] value,          // Input value to find the square root of
    output reg done,             // Signal to indicate completion
    output reg [15:0] root       // Square root of the input value
);

    // State definitions
    localparam IDLE = 2'b00,
               INIT = 2'b01,
               CALC = 2'b10,
               DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [31:0] approx, next_approx;
    integer i;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State machine logic
    always @(*) begin
        case (state)
            IDLE: begin
                done = 0;
                root = 0;
                if (start) next_state = INIT;
                else       next_state = IDLE;
            end
            INIT: begin
                approx = value >> 1; // Initial approximation
                i = 0;
                next_state = CALC;
            end
            CALC: begin
                if (i < 16) begin
                    next_approx = (approx + value / approx) >> 1;
                    approx = next_approx;
                    i = i + 1;
                    next_state = CALC;
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                root = approx[15:0]; // Final approximation
                done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
