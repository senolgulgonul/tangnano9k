module blinkled
(
    input clk,
    output reg [5:0]  leds
);
localparam WAIT_TIME = 27000000;
reg [31:0] clockCounter = 0;

always @(posedge clk) begin

    clockCounter <= clockCounter + 1;

    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
        leds=~leds;
    end //if
end  //always

endmodule