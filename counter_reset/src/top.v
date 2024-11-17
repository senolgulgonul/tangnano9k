module counter
(
    input clk,
    input reset,  // Active low reset
    output [5:0] led
);

localparam WAIT_TIME = 27000000;
reg [5:0] ledCounter = 0;
reg [31:0] clockCounter = 0;

always @(posedge clk or negedge reset) begin
    if (!reset) begin  // Reset is active low
        clockCounter <= 0;
        ledCounter <= 0;
    end else begin
        clockCounter <= clockCounter + 1;
        if (clockCounter == WAIT_TIME) begin
            clockCounter <= 0;
            ledCounter <= ledCounter + 1;
        end
    end
end

assign led = ~ledCounter;
endmodule