module simple_cpu (
    input clk,
    input reset_n, // Active low reset
    output reg [3:0] leds // Active low LEDs
);

    reg [5:0] pc; // Program counter
    reg [3:0] regA; // Register A
    reg [3:0] regB; // Register B
    reg [15:0] instruction_memory [0:31]; // Memory to store instructions
    reg [15:0] instruction; // Current instruction
    reg [2:0] state; // FSM state
    integer i; // Loop variable

    // State encoding
    localparam FETCH = 3'b000,
               DECODE = 3'b001,
               EXECUTE = 3'b010;

    // Instruction encoding
    localparam NOP = 4'b0000,
               LOADA = 4'b0001,
               LOADB = 4'b0010,
               ADD = 4'b0011,
               SUB = 4'b0100;

    // Initialize instruction memory (example instructions)
    initial begin
        instruction_memory[0] = {LOADA, 12'b000000001111}; // LOADA 15
        instruction_memory[1] = {LOADB, 12'b000000000010}; // LOADB 2
        instruction_memory[2] = {ADD, 12'b000000000000};   // ADD
        instruction_memory[3] = {LOADB, 12'b000000000110}; // LOADB 6
        instruction_memory[4] = {SUB, 12'b000000000000};   // SUB
        // Fill the rest of the memory with NOPs
        for (i = 5; i < 32; i = i + 1) begin
            instruction_memory[i] = {NOP, 12'b000000000000};
        end
    end

    // FSM for fetch, decode, execute
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= FETCH;
            pc <= 0;
            regA <= 0;
            regB <= 0;
            leds <= 4'b1111; // LEDs off (active low)
        end else begin
            case (state)
                FETCH: begin
                    if (pc < 32) begin
                        instruction <= instruction_memory[pc];
                        pc <= pc + 1;
                        state <= DECODE;
                    end
                end
                DECODE: begin
                    state <= EXECUTE;
                end
                EXECUTE: begin
                    case (instruction[15:12])
                        NOP: ; // No operation
                        LOADA: regA <= instruction[3:0];
                        LOADB: regB <= instruction[3:0];
                        ADD: regA <= regA + regB;
                        SUB: regA <= regA - regB;
                    endcase
                    leds <= ~regA; // Update LEDs (active low)
                    state <= FETCH;
                end
            endcase
        end
    end
endmodule