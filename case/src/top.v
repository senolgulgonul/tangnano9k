module conditional_assign_case(
    input wire a,          // 1-bit input
    output reg [5:0] b     // 6-bit output
);

    always @* begin
        case (a)
            1'b0: b = 6'b000000;
            1'b1: b = 6'b111111;
            default: b = 6'b000000;  // Optional default case for completeness
        endcase
    end

endmodule
