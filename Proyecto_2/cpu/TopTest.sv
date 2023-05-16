module TopTest;
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;
	 logic q;
    // instantiate device to be tested
    top dut(clk, reset, WriteData, DataAdr, MemWrite);

	
        
    // initialize test
   initial begin
        reset <= 1; # 5; reset <= 0;  
   end
	 
	  
	always begin
		 clk <= 1; #5; clk <= 0; #5;
	end

    // generate clock to sequence tests
    
	// check that 7 gets written to address 0x64
	// at end of program
		always @(negedge clk) begin
			if (MemWrite == 0) q <=0; #15;
		end

endmodule