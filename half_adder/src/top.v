module half_adder(
    input wire a, b,        // 1-bit inputs
    output wire sum, carry  // 1-bit outputs
);

    // Sum is the XOR of the inputs
    assign sum = ~(~a ^ ~b);

    // Carry is the AND of the inputs
    assign carry = ~(~a & ~b);

endmodule
