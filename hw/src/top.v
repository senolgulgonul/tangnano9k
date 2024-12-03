module blinkled
(
    input clk,
    output reg [5:0]  leds,
output reg pin32
);
localparam WAIT_TIME = 2700000;
reg [31:0] clockCounter = 0;

always @(posedge clk) begin

    clockCounter <= clockCounter + 1;

    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
        leds=~leds;
        pin32 <= ~pin32;
    end //if
end  //always

endmodule