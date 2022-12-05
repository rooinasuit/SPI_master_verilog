module main (
    input CLK,
    input NRST, // neg reset
    
    output PLACEHOLDER // mayhaps leds
);

wire CTRL_CLK;
wire SCLK_PULSE;

wire CS;
wire SCLK;
wire MOSI;
wire MISO;

Gowin_rPLL clk_domains_full(
    .clkout(SCLK_PULSE), // output 20.25 Mhz from divider
    .clkoutd(CTRL_CLK), // output 324 MHz from multiplier (just high enough, could've been 100M)
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

slave slave1 (
    .CTRL_CLK (CTRL_CLK),
    .SCLK_PULSE (SCLK_PULSE),
    .NRST (NRST),
    .CS (CS),
    .SCLK (SCLK),
    .SDI (MOSI),
    .SDO (MISO)
);
endmodule