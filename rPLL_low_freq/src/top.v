module top (
output clkout,
output clkoutd,
input clkin
);

    Gowin_rPLL your_instance_name(
        .clkout(clkout), //output clkout
        .clkoutd(clkoutd), //output clkoutd
        .clkin(clkin) //input clkin
    );

endmodule