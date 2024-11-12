module conditional_assign(
    input wire a,          // 1-bit input
    output reg [5:0] b     // 6-bit output
);

    always @* begin
        if (a == 0)
            b = 6'b000000;
        else
            b = 6'b111111;
    end

endmodule
