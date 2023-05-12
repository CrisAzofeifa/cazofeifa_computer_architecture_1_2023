module testMemoryRom;
	logic [31:0] PC;
	logic [31:0] Instr;
	
	imem memory(PC, Instr);
	
	initial begin
		PC = 32'b0;
		#10
		$display(Instr);
	end
	
endmodule