module main (
    input CLK,
    input NRST, // neg reset
    input ENABLE,

    output PLACEHOLDER // mayhaps leds
);

wire CTRL_CLK;
wire SCLK_PULSE;

wire CS;
wire SCLK;
wire MOSI;
wire MISO;

wire [7:0] MOSI_data;
wire [7:0] MISO_data;
wire [7:0] stash_ptr;

wire [7:0] SDO_data;
wire [7:0] slava_data_ptr;

Gowin_rPLL clk_domains_full(
    .clkout(SCLK_PULSE), // output 20.25 Mhz from divider
    .clkoutd(CTRL_CLK), // output 324 MHz from multiplier (just high enough, could've been 100M)
    .clkin(CLK) // input 27 MHz GLOBAL
);

master master(
    .CTRL_CLK (CTRL_CLK),
    .SCLK_PULSE (SCLK_PULSE),
    .NRST (NRST),
    .ENABLE (ENABLE),
    .MOSI_data (MOSI_data),
    .MISO_data (MISO_data),
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
    .SDO_data (SDO_data),
    .slave_data_ptr (slave_data_ptr),
    .CS (CS),
    .SCLK (SCLK),
    .SDI (MOSI),
    .SDO (MISO)
);
endmodule