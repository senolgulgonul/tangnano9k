module decoder_2to4 (
    input wire button3,
    input wire button4,
    output reg [3:0] led
);

always @(*) begin
    case ({~button4, ~button3}) // Invert the inputs since they are active low
        2'b00: led = 4'b1110; // Active low output
        2'b01: led = 4'b1101;
        2'b10: led = 4'b1011;
        2'b11: led = 4'b0111;
        default: led = 4'b1111; // All LEDs off
    endcase
end
endmodule