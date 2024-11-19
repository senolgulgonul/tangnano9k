module fsm_example (
    input wire button3,
    input wire button4,
    output reg led,
    input wire clk
);

// State parameters
parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

reg [2:0] state = IDLE;


always @(posedge clk) begin
    
  
    case (state)
        IDLE: begin
            led = 1'b1; // Ensure LED is OFF in IDLE state
            if (~button3) // Check if button3 is pressed (active low)
                state = S1;
        end
        S1: begin
            if (button3) // Check if button3 is released (active high)
                state = S2;

        end
        S2: begin
            if (~button4) // Check if button4 is pressed (active low)
                state = S3;

        end
        S3: begin
            if (button4) // Check if button4 is released (active high)
                state = S4;

        end
        S4: begin
            led = 1'b0; // LED ON (active low)
            if (~button3 || ~button4) // Return to IDLE if any button is pressed
                state = IDLE;
        end
    endcase
end

endmodule