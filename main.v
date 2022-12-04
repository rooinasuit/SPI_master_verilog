module main (
    input CLK,
    input NRST, // neg reset
    
    output PLACEHOLDER // mayhaps leds
);

wire SCLK_PULSE;
wire CTRL_CLK;

/*
Gowin_rPLL clk_domains_full(
    .clkout(SCLK_PULSE), // output 20.25 Mhz from divider
    .clkoutd(CTRL_CLK), // output 324 MHz from multiplier (just high enough, could've been 100M)
    .clkin(CLK) // input 27 MHz GLOBAL
); */

clock_domains clk_domains_lite(
    .CLK (CLK), 
    .NRST (NRST),
    .CTRL_CLK (CTRL_CLK), // 1 MHz
    .SCLK_PULSE (SCLK_PULSE) // 1kHz
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