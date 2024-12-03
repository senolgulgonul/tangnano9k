module top (
input clkin,
output clkout
);
    Gowin_rPLL your_instance_name(
        .clkout(clkout), //output clkout
        .clkin(clkin) //input clkin
    );
endmodule
