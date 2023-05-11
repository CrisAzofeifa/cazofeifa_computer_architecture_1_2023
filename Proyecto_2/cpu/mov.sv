module mov #(parameter n = 32) ( input [n-1:0] b, output [n-1:0] c, output [3:0] banderas);
	
	logic [n-1:0] result;
	
	assign result = b;
	
	assign banderas[3] = 0; 					// Negativo (N)
	assign banderas[2] = result[n-1:0] == 0; 	// Zero (Z)
	assign banderas[1] = 0; 					// Acarreo (C) (Unsigned)
	assign banderas[0] = 0;						// Desbordamiento (V) (Signed)
	
	assign c = result;	
		
endmodule
