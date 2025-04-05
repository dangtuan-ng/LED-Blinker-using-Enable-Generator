//====================================================
// Module: enable_generator
// Description: Create a 'tick_enable' signal with desired frequency
//====================================================
module enable_generator #(
	parameter CLK_FREQ = 50_000_000,
	parameter TARGET_FREQ = 2
)(
	input sys_clk,
	input sys_rst_n,
	output tick_enable
);
	// Calculate counter max value (integer division)
	localparam COUNTER_MAX_VALUE = CLK_FREQ / TARGET_FREQ;
	
	// Calculate counter max width
	localparam COUNTER_WIDTH = $clog2(COUNTER_MAX_VALUE);
	
	// Declare counter register
	reg [COUNTER_WIDTH-1:0] counter_reg;
	
	// Counter logic with precise tick generation
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			// Reset counter and state
			counter_reg <= 'd0;
		end
		else begin
			// Increment or reset counter
			if (counter_reg == COUNTER_MAX_VALUE - 1)
				counter_reg <= 'd0;
			else
				counter_reg <= counter_reg + 1'b1;
		end
	end
	
	// Generate tick enable signal at exactly the right moment
	assign tick_enable = (counter_reg == COUNTER_MAX_VALUE - 1);
	
endmodule