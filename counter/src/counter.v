module counter
(
    input clk,
    output [5:0] led
);

localparam WAIT_TIME = 27000000;
reg [5:0] ledCounter = 0;
reg [31:0] clockCounter = 0;

always @(posedge clk) begin
    clockCounter <= clockCounter + 1;
    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
        ledCounter <= ledCounter + 1;
    end
end

assign led = ~ledCounter;
endmodule