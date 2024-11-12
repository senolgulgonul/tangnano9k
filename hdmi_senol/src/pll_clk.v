module pll(
    input wire clk_in,     // 27 MHz input clock
    output wire clk_out    // 148.5 MHz output clock
);

    // Use the Gowin FPGA PLL IP to configure
    // Instantiate the PLL with appropriate parameters

    Gowin_rPLL your_instance_name(
        .clkout(clkout), //output clkout
        .clkin(clkin) //input clkin
    );

    defparam Gowin_PLL_inst.FCLKIN = "27";
    defparam Gowin_PLL_inst.FCLKOUT = "148.5";

endmodule
