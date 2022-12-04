module main (
    input CLK,
    input NRST, // neg reset
    
    output PLACEHOLDER // mayhaps leds
);

wire SCLK_PULSE;
wire CTRL_CLK;

Gowin_rPLL clk_domains(
    .clkout(SCLK_PULSE), // output 20.25 Mhz from divider
    .clkoutd(CTRL_CLK), // output 324 MHz from multiplier
    .clkin(CLK) // input 27 MHz GLOBAL
);

master master(
    .CTRL_CLK (CTRL_CLK),
    .SCLK_PULSE (SCLK_PULSE),
    .NRST (NRST),
    .MOSI_data (MOSI_data),
    .MISO_data (MOSI_data),
    .stash_ptr (stash_ptr),
    .MISO (MISO),
    .CS (CS),
    .SCLK (SCLK),
    .MOSI (MOSI)
);

endmodule