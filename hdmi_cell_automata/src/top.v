module HDMI_automata(
    input clk,  // 27MHz
    output [2:0] TMDSp,
    output [2:0] TMDSn,
    output TMDSp_clock,
    output TMDSn_clock
);

// rpll generates 5x27 = 135 MHz
    wire clk_TMDS; 

    Gowin_rPLL pllInstance(
        .clkout(clk_TMDS),   //5x27=135 MHz tdms data clock for 10 bits
        .clkin(clk)      //27MHz   tang nano internal clock
    );


// pixel counters from fpga4fun
reg [31:0] CounterX, CounterY;
reg hSync, vSync, DrawArea;
reg [31:0] frameCounter ;  // Counter to create movement

always @(posedge clk) begin
    DrawArea <= (CounterX < 640) && (CounterY < 480);
    CounterX <= (CounterX == 799) ? 0 : CounterX + 1;
    if (CounterX == 799) CounterY <= (CounterY == 524) ? 0 : CounterY + 1;
    if (CounterX == 799 && CounterY == 524) frameCounter <= frameCounter + 1;  // Increment frame counter at the end of each frame
    hSync <= (CounterX >= 656) && (CounterX < 752);
    vSync <= (CounterY >= 490) && (CounterY < 492);
end

//////////////////

// Initialize the first line with only the 240th bit set to 1 using concatenation
reg [639:0] first_line = {319'b0, 1'b1, 320'b0};

// Generate subsequent lines based on rule 30
reg [639:0] current_line, next_line;
reg initialized = 0; // Flag to check if initialization is done

always @(posedge clk) begin
    if (!initialized) begin
        current_line <= first_line;
        initialized <= 1;
    end else if (CounterX == 0) begin
        current_line <= next_line;
    end 

    if (CounterX < 640) begin


        // Apply rule 30 with boundary checks
        if (CounterX == 0) begin
            next_line[CounterX] <= current_line[639] ^ (current_line[CounterX] | current_line[CounterX+1]);
        end else if (CounterX == 639) begin
            next_line[CounterX] <= current_line[CounterX-1] ^ (current_line[CounterX] | current_line[0]);
        end else begin
            next_line[CounterX] <= current_line[CounterX-1] ^ (current_line[CounterX] | current_line[CounterX+1]);
        end
//
/* Apply rule 90 with boundary checks
        if (CounterX == 0) begin
            next_line[CounterX] <= current_line[639] ^ current_line[CounterX+1];
        end else if (CounterX == 639) begin
            next_line[CounterX] <= current_line[CounterX-1] ^ current_line[0];
        end else begin
            next_line[CounterX] <= current_line[CounterX-1] ^ current_line[CounterX+1];
        end
*/
        /* Apply rule 110 with boundary checks
        if (CounterX == 0) begin
            next_line[CounterX] <= (current_line[639] & current_line[CounterX]) | (current_line[CounterX] & ~current_line[CounterX+1]) | (~current_line[639] & current_line[CounterX+1]);
        end else if (CounterX == 639) begin
            next_line[CounterX] <= (current_line[CounterX-1] & current_line[CounterX]) | (current_line[CounterX] & ~current_line[0]) | (~current_line[CounterX-1] & current_line[0]);
        end else begin
            next_line[CounterX] <= (current_line[CounterX-1] & current_line[CounterX]) | (current_line[CounterX] & ~current_line[CounterX+1]) | (~current_line[CounterX-1] & current_line[CounterX+1]);
        end
*/    

        /* Apply rule 105 with boundary checks
        if (CounterX == 0) begin
            next_line[CounterX] <= current_line[639] ^ current_line[CounterX] ^ current_line[CounterX+1];
        end else if (CounterX == 639) begin
            next_line[CounterX] <= current_line[CounterX-1] ^ current_line[CounterX] ^ current_line[0];
        end else begin
            next_line[CounterX] <= current_line[CounterX-1] ^ current_line[CounterX] ^ current_line[CounterX+1];
        end
*/
    end
end

// Assign colors based on the current line
wire [7:0] red = {8{current_line[CounterX]}};
wire [7:0] green = {8{current_line[CounterX]}};
wire [7:0] blue = {8{current_line[CounterX]}};
   

////////////////////////
// Generate a gradient pattern
//wire [7:0] red = CounterX[7:0];
//wire [7:0] green = CounterY[7:0];
//wire [7:0] blue = (CounterX[7:0] ^ CounterY[7:0]);
////////////////

// TMDS encoding from fpga4fun
    wire [9:0] TMDS_red, TMDS_green, TMDS_blue;
    TMDS_encoder encode_R(.clk(clk), .VD(red), .CD(2'b00), .VDE(DrawArea), .TMDS(TMDS_red));
    TMDS_encoder encode_G(.clk(clk), .VD(green), .CD(2'b00), .VDE(DrawArea), .TMDS(TMDS_green));
    TMDS_encoder encode_B(.clk(clk), .VD(blue), .CD({vSync, hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));

    wire TMDS_shift_red, TMDS_shift_green, TMDS_shift_blue;

OSER10 blue_oser10( 
.Q(TMDS_shift_blue),.D0(TMDS_blue[0]),.D1(TMDS_blue[1]),.D2(TMDS_blue[2]),.D3(TMDS_blue[3]),.D4(TMDS_blue[4]),
.D5(TMDS_blue[5]),.D6(TMDS_blue[6]),.D7(TMDS_blue[7]),.D8(TMDS_blue[8]),.D9(TMDS_blue[9]),  
.PCLK(clk),  
.FCLK(clk_TMDS), 
.RESET(1'b0) 
); 

OSER10 green_oser10( 
.Q(TMDS_shift_green),.D0(TMDS_green[0]),.D1(TMDS_green[1]),.D2(TMDS_green[2]),.D3(TMDS_green[3]),.D4(TMDS_green[4]),
.D5(TMDS_green[5]),.D6(TMDS_green[6]),.D7(TMDS_green[7]),.D8(TMDS_green[8]),.D9(TMDS_green[9]),  
.PCLK(clk),  
.FCLK(clk_TMDS), 
.RESET(1'b0) 
);

OSER10 red_oser10( 
.Q(TMDS_shift_red),.D0(TMDS_red[0]),.D1(TMDS_red[1]),.D2(TMDS_red[2]),.D3(TMDS_red[3]),.D4(TMDS_red[4]),
.D5(TMDS_red[5]),.D6(TMDS_red[6]),.D7(TMDS_red[7]),.D8(TMDS_red[8]),.D9(TMDS_red[9]),  
.PCLK(clk),  
.FCLK(clk_TMDS), 
.RESET(1'b0) 
); 

 
// Generate differential pairs using ELVDS_OBUF
    ELVDS_OBUF tmds_bufds [3:0] (
        .I({clk, TMDS_shift_blue, TMDS_shift_green, TMDS_shift_red}),
        .O({TMDSp_clock, TMDSp[0], TMDSp[1], TMDSp[2]}),
        .OB({TMDSn_clock, TMDSn[0], TMDSn[1], TMDSn[2]})
    );

endmodule

// TMDS encoding from fpga4fun
module TMDS_encoder(
    input clk,
    input [7:0] VD,  // video data (red, green or blue)
    input [1:0] CD,  // control data
    input VDE,  // video data enable, to choose between CD (when VDE=0) and VD (when VDE=1)
    output reg [9:0] TMDS = 0
);

    wire [3:0] Nb1s = VD[0] + VD[1] + VD[2] + VD[3] + VD[4] + VD[5] + VD[6] + VD[7];
    wire XNOR = (Nb1s > 4'd4) || (Nb1s == 4'd4 && VD[0] == 1'b0);
    wire [8:0] q_m = {~XNOR, q_m[6:0] ^ VD[7:1] ^ {7{XNOR}}, VD[0]};

    reg [3:0] balance_acc = 0;
    wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
    wire balance_sign_eq = (balance[3] == balance_acc[3]);
    wire invert_q_m = (balance == 0 || balance_acc == 0) ? ~q_m[8] : balance_sign_eq;
    wire [3:0] balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance == 0 || balance_acc == 0));
    wire [3:0] balance_acc_new = invert_q_m ? balance_acc - balance_acc_inc : balance_acc + balance_acc_inc;
    wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
    wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

    always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
    always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule
