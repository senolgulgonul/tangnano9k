module memory_example(
    input clk,
    output reg [5:0] leds
);

reg [5:0] Address = 6'b0;
localparam WAIT_TIME = 27000000;
reg [31:0] clockCounter = 0;
reg [5:0] Mem [0:11]; // 12 x 6 memory
initial begin
    Mem[0] = 6'b000001;
    Mem[1] = 6'b000010;
    Mem[2] = 6'b000100;
    Mem[3] = 6'b001000;
    Mem[4] = 6'b010000;
    Mem[5] = 6'b100000;
    Mem[6] = 6'b100000;
    Mem[7] = 6'b010000;
    Mem[8] = 6'b001000;
    Mem[9] = 6'b000100;
    Mem[10] = 6'b000010;
    Mem[11] = 6'b000001;
end
always @(posedge clk) begin
    clockCounter <= clockCounter + 1'b1;
    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
        if (Address == 6'd11) begin
            Address <= 6'b0;
        end else begin
            Address <= Address + 1'b1;
        end
        leds <= ~Mem[Address];  // Active low leds
    end
end
endmodule