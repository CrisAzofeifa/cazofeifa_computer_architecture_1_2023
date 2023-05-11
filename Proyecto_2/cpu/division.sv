module division #(parameter n = 4) ( input [n-1:0] a, b, output [n-1:0] c, output [3:0] banderas);
	
	logic [n:0] result;
	
	assign result = a / b;
	
	assign banderas[3] = 0;			 			// Negativo (N)
	assign banderas[2] = result[n-1:0] == 0; 	// Zero (Z)
	assign banderas[1] = 0;			 			// Acarreo (C) (Unsigned)
	assign banderas[0] = 0;				// Desbordamiento (V) (Signed)
	
	assign c = result;	
		
endmodule