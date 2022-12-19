`include "interface.sv"
`include "test.sv"
`include "master.sv"
module testbench;

m_int i_m_int();

test t1(i_m_int);

reg CTRL_CLK;
reg SCLK_PULSE;
reg [7:0] MOSI_data;
reg [7:0] MISO_data;
reg [7:0] master_stash_ptr;

always #1 CTRL_CLK = ~CTRL_CLK;
always #5 SCLK_PULSE = ~SCLK_PULSE;

	master master1 (
		.CTRL_CLK (CTRL_CLK),
		.SCLK_PULSE (SCLK_PULSE),
		.NRST (NRST),
		.ENABLE (ENABLE),
		.MOSI_data (MOSI_data),
		.MISO_data (MISO_data),
		.master_stash_ptr (master_stash_ptr),
		.MISO (MISO),
		.CS (CS),
		.SCLK (SCLK),
		.MOSI (MOSI)
	);

endmodule