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
	// calculate counter max value
	localparam COUNTER_MAX_VALUE = CLK_FREQ / TARGET_FREQ;
	// calculate counter max width
	localparam COUNTER_WIDTH = $clog2(COUNTER_MAX_VALUE);
	
	// declare counter register
	reg [COUNTER_WIDTH-1:0] counter_reg;
	
	//counter logic and create tick_enable
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) // reset signal
			counter_reg <= 'd0;

		else begin 
			if (counter_reg === COUNTER_MAX_VALUE - 1)
				counter_reg <= 'd0; //reset counter when reached max value
			else
				counter_reg <= counter_reg + 1'b1; // increase counter
		end
	end
	
	assign tick_enable = (counter_reg == COUNTER_MAX_VALUE - 1);
	
endmodule
