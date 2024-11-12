module and_gate_primitive(
    input wire a, b,  // 1-bit inputs
    output wire out   // 1-bit output
);

    // Using the AND gate primitive
    and u1 (out, a, b);

endmodule
