module clockdivider (
    input wire clk,
    output wire out1
);
reg [3:0] c1 = 4'b0;
always @(posedge clk) begin
        c1 <= c1 + 1'b1;
end
assign out1 = c1[3];  // Simplified output assignment 27MHz/16
endmodule