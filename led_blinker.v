//====================================================
// Module: led_blinker
// Description: Toggle LED on/off based on tick_enable signal
//====================================================
module led_blinker (
	input sys_clk,
	input sys_rst_n,
	input tick_enable,
	output reg led
);
	
	// toggle LED logic
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
			led <= 1'b0; // initial LED state when reset (off)
		else begin
			if (tick_enable)
				led <= ~led;
			// no need 'else' because led is a register, it saves past value
		end
	end

endmodule
