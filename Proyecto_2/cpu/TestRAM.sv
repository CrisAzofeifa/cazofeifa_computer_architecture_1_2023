module TestRAM;

	logic [31:0] address, address2;
	logic clk;
	logic [31:0] data;
	logic wren;
	logic [31:0] q1, q2;

	dmem datmem(clk, wren, address, address2, data, q1, q2);
	 
	  
	always begin
		clk = 0;
		clk <= 1; #5; clk <= 0; #5;
		
		address = 0;
		$display("Data en 0 %h", q1);
		
		address2 = 25;
		$display("Data en 25 %h", q2);
		
		#15;
		
		address = 5;
		$display("Data en 5 %h", q1);
		
		address2 = 9005;
		$display("Data en 9005 %h", q2);
		
		#15;
		
		
		
	end
	
	
endmodule