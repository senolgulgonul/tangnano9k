module gw_gao(
    clk,
    \leds[5] ,
    \leds[4] ,
    \leds[3] ,
    \leds[2] ,
    \leds[1] ,
    \leds[0] ,
    \clockCounter[23] ,
    \clockCounter[22] ,
    \clockCounter[21] ,
    \clockCounter[20] ,
    \clockCounter[19] ,
    \clockCounter[18] ,
    \clockCounter[17] ,
    \clockCounter[16] ,
    \clockCounter[15] ,
    \clockCounter[14] ,
    \clockCounter[13] ,
    \clockCounter[12] ,
    \clockCounter[11] ,
    \clockCounter[10] ,
    \clockCounter[9] ,
    \clockCounter[8] ,
    \clockCounter[7] ,
    \clockCounter[6] ,
    \clockCounter[5] ,
    \clockCounter[4] ,
    \clockCounter[3] ,
    \clockCounter[2] ,
    \clockCounter[1] ,
    \clockCounter[0] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input clk;
input \leds[5] ;
input \leds[4] ;
input \leds[3] ;
input \leds[2] ;
input \leds[1] ;
input \leds[0] ;
input \clockCounter[23] ;
input \clockCounter[22] ;
input \clockCounter[21] ;
input \clockCounter[20] ;
input \clockCounter[19] ;
input \clockCounter[18] ;
input \clockCounter[17] ;
input \clockCounter[16] ;
input \clockCounter[15] ;
input \clockCounter[14] ;
input \clockCounter[13] ;
input \clockCounter[12] ;
input \clockCounter[11] ;
input \clockCounter[10] ;
input \clockCounter[9] ;
input \clockCounter[8] ;
input \clockCounter[7] ;
input \clockCounter[6] ;
input \clockCounter[5] ;
input \clockCounter[4] ;
input \clockCounter[3] ;
input \clockCounter[2] ;
input \clockCounter[1] ;
input \clockCounter[0] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire clk;
wire \leds[5] ;
wire \leds[4] ;
wire \leds[3] ;
wire \leds[2] ;
wire \leds[1] ;
wire \leds[0] ;
wire \clockCounter[23] ;
wire \clockCounter[22] ;
wire \clockCounter[21] ;
wire \clockCounter[20] ;
wire \clockCounter[19] ;
wire \clockCounter[18] ;
wire \clockCounter[17] ;
wire \clockCounter[16] ;
wire \clockCounter[15] ;
wire \clockCounter[14] ;
wire \clockCounter[13] ;
wire \clockCounter[12] ;
wire \clockCounter[11] ;
wire \clockCounter[10] ;
wire \clockCounter[9] ;
wire \clockCounter[8] ;
wire \clockCounter[7] ;
wire \clockCounter[6] ;
wire \clockCounter[5] ;
wire \clockCounter[4] ;
wire \clockCounter[3] ;
wire \clockCounter[2] ;
wire \clockCounter[1] ;
wire \clockCounter[0] ;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({clk,\leds[5] ,\leds[4] ,\leds[3] ,\leds[2] ,\leds[1] ,\leds[0] ,\clockCounter[23] ,\clockCounter[22] ,\clockCounter[21] ,\clockCounter[20] ,\clockCounter[19] ,\clockCounter[18] ,\clockCounter[17] ,\clockCounter[16] ,\clockCounter[15] ,\clockCounter[14] ,\clockCounter[13] ,\clockCounter[12] ,\clockCounter[11] ,\clockCounter[10] ,\clockCounter[9] ,\clockCounter[8] ,\clockCounter[7] ,\clockCounter[6] ,\clockCounter[5] ,\clockCounter[4] ,\clockCounter[3] ,\clockCounter[2] ,\clockCounter[1] ,\clockCounter[0] }),
    .clk_i(clk)
);

endmodule
