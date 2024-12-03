module uart_rx_leds (
    input wire clk,
    input wire nreset,
    input wire rx, // UART receive pin
    output reg [5:0] leds // Active low LEDs
);
    parameter CLK_FREQ = 27000000; // 27 MHz
    parameter BAUD_RATE = 115200;
    parameter integer BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter;
    reg [3:0] bit_counter;
    reg [9:0] shift_reg;
    reg receiving;
    reg [7:0] rx_data;
    reg rx_prev =1; // Register to store the previous state of rx

    always @(posedge clk or negedge nreset) begin
        if (!nreset) begin
            baud_counter <= 0;
            bit_counter <= 0;
            shift_reg <= 0;
            receiving <= 0;
            rx_data <= 8'b0;
            leds <= 6'b000000; // Turn on all LEDs (active low)
            rx_prev <= 1; // Initialize to idle state (high)
        end else begin
            rx_prev <= rx; // Update previous state of rx
            if (!receiving && rx_prev && !rx) begin // Detect negative edge of rx (start bit)
                receiving <= 1;
                baud_counter <= BAUD_DIV / 2; // Start counting to the middle of the start bit
                bit_counter <= 0;
            end else if (receiving) begin
                if (baud_counter == BAUD_DIV - 1) begin
                    baud_counter <= 0;
                    if (bit_counter == 10) begin // All bits received
                        receiving <= 0;
                        if (shift_reg[0] == 0 && shift_reg[9] == 1) begin // Valid start and stop bits
                            rx_data <= shift_reg[8:1]; // Extract data bits
                        end
                    end else begin
                        shift_reg <= {rx, shift_reg[9:1]}; // Shift in the received bit
                        bit_counter <= bit_counter + 1;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end

            // LED control logic
            case (rx_data)
                8'b00110000: leds <= 6'b111110; // '0'
                8'b00110001: leds <= 6'b111100; // '1'
                // Add more cases as needed
            endcase
        end
    end
endmodule