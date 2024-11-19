module counter
(
    input clk,
    input reset,  // Active low reset
    input data,   // Active low data
    output reg [5:0] led  // Active low led
);

localparam WAIT_TIME = 27000000;
reg [31:0] clockCounter = 0;

always @(posedge clk or negedge reset) begin
    if (!reset) begin  // Reset is active low
        clockCounter <= 0;
        led <= 6'b111111;  // Active low reset value
    end else begin
        clockCounter <= clockCounter + 1;
        if (clockCounter == WAIT_TIME) begin
            clockCounter <= 0;
            led <= {led[4:0], ~data};  // Shift in the inverted value of data
        end
    end
end

endmodule