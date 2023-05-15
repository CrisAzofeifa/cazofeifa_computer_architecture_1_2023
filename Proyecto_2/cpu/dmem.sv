module dmem ( 
    input logic clk, we,
    input logic [31:0] a, wd,
    output logic [31:0] rd);

    logic [31:0] RAM[90024:0];

    assign rd = RAM[a[31:0]]; // word aligned

	initial begin
	    $readmemh("DataMemInit.mif", RAM);
	end

    always_ff @(posedge clk)
        if (we) RAM[a[31:0]] <= wd;
    
endmodule