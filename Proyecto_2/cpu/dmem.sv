module dmem ( 
    input logic clk, we,
    input logic [31:0] a, a1, wd,
    output logic [31:0] rd, rd2);

    logic [31:0] RAM[90024:0];

    assign rd = RAM[a[31:0]]; // word aligned
	 assign rd2 = RAM[a1[31:0]]; // word aligned
	 
	 initial begin
		$readmemh("DataMemInit.mif", RAM);
	 end

    always_ff @(posedge clk)
        if (we) RAM[a[31:0]] <= wd;
    
endmodule