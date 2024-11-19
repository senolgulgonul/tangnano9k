module uart_tx (
    input wire clk,
    output reg tx
);

    parameter CLK_FREQ = 27000000; // 27 MHz
    parameter BAUD_RATE = 115200;
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_data = 10'b1_01000001_0; // Start bit, 'A', Stop bit

    always @(posedge clk) begin
        if (clk_count < BIT_PERIOD - 1) begin
            clk_count <= clk_count + 1;
        end else begin
            clk_count <= 0;
            bit_index <= bit_index + 1;
            if (bit_index < 10) begin
                tx <= tx_data[bit_index];
            end else begin
                bit_index <= 0;
                tx <= 1; // Idle state
            end
        end
    end
endmodule