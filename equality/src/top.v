module button_comparator (
    input wire button3,
    input wire button4,
    output reg led
);

always @(*) begin
    if (~button3 == ~button4) // Check if the active low inputs are equal
        led = 1'b0; // LED ON (active low)
    else
        led = 1'b1; // LED OFF (active low)
end

endmodule