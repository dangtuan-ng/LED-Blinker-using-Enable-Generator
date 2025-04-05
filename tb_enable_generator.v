`timescale 1ns/1ps  // Định nghĩa đơn vị thời gian cho mô phỏng

module tb_enable_generator;
    // Khai báo tham số
    parameter CLK_FREQ = 100;        // 100Hz thay vì 50MHz
    parameter TARGET_FREQ = 10;      // 10Hz để tạo ra xung tick_enable
    
    // Khai báo tín hiệu
    reg sys_clk;
    reg sys_rst_n;
    wire tick_enable;
    
    // Khởi tạo DUT (Device Under Test)
    enable_generator #(
        .CLK_FREQ(CLK_FREQ),
        .TARGET_FREQ(TARGET_FREQ)
    ) dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .tick_enable(tick_enable)
    );
    
    // Tạo tín hiệu clock - chu kỳ 10ns (100Hz)
    always begin
        #5 sys_clk = ~sys_clk;    // Half period = 5ns
    end
    
    // Biến kiểm tra
    integer tick_count = 0;
    integer clock_cycles = 0;
    
    // Đếm số xung tick_enable
    always @(posedge sys_clk) begin
		if (sys_rst_n) begin // only count when no reset
			clock_cycles = clock_cycles + 1;
			if (tick_enable)
				tick_count = tick_count + 1;
		end
    end
    // Quy trình kiểm tra
    initial begin
        // Khởi tạo tín hiệu
        sys_clk = 0;
        sys_rst_n = 0;
        
        // Giữ reset trong 20ns
        #20;
        sys_rst_n = 1;
        
        // Chạy mô phỏng trong 300ns (đủ để thấy nhiều xung tick_enable)
        #300;
        
        // Kiểm tra lại tần số xung tick_enable
        $display("Clock cycles: %d", clock_cycles);
        $display("Tick count: %d", tick_count);
        $display("Expected frequency: %0d Hz", TARGET_FREQ);
        $display("Actual frequency: %0f Hz", tick_count * CLK_FREQ * 1.0 / clock_cycles);
        
        if (tick_count > 0 && 
            (tick_count * CLK_FREQ * 1.0 / clock_cycles) > 0.95 * TARGET_FREQ &&
            (tick_count * CLK_FREQ * 1.0 / clock_cycles) < 1.05 * TARGET_FREQ) begin
            $display("Test PASSED!");
        end else begin
            $display("Test FAILED!");
        end
        
        // Kết thúc mô phỏng
        $finish;
    end
    
    // Tạo file VCD để xem sóng
    initial begin
        $dumpfile("tb_enable_generator.vcd");
        $dumpvars(0, tb_enable_generator);
    end
    
endmodule