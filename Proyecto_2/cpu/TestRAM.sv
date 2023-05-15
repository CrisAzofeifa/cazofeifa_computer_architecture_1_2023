module TestRAM;

	logic [31:0] address;
	logic clk;
	logic [31:0] data;
	logic wren;
	logic [31:0]q;

	dmem datmem(address, clk, data, wren, q);
	 
	  
	always begin
		clk = 0;
		clk <= 1; #5; clk <= 0; #5;
	end
	
	always @(posedge clk) begin
	
		address = 0;
		wren = 0;
		data = 0;
		$display("Data en 0 %d", q);
		#15;
		
		address = 10;
		wren = 0;
		data = 0;
		$display("Data en 10 %d", q);
		#15;
		
		
		address = 3;
		wren = 0;
		data = 0;
		$display("Data en 3 %d", q);
		#15;
	
	end
	
	
endmodule