//====================================================
// Module: top_blinky
// Description: Top module, connect enable_generator and led_blinker
//====================================================
module top_blinky (
	input clk_in,
	input reset_in_n,
	output led_out
);

localparam SYS_CLK_FREQ = 27_000_000;
localparam BLINK_FREQ = 1;
localparam ENABLE_FREQ = BLINK_FREQ*2;

wire enable_signal;

// instantiate enable_generator
enable_generator #(
	.CLK_FREQ (SYS_CLK_FREQ),
	.TARGET_FREQ (ENABLE_FREQ)
)(
	.sys_clk (clk_in),
	.sys_rst_n (reset_in_n),
	.tick_enable (enable_signal)
);

// instantiate led_blinker
led_blinker (
	.sys_clk (clk_in),
	.sys_rst_n (reset_in_n),
	.tick_enable (enable_signal),
	.led (led_out)
);

endmodule