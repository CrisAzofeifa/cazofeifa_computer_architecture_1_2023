module multiplexor #(parameter n = 4) (
	input [n-1:0] a, b, c, d, e, f, 
	input [3:0] ss, 
	output [n-1:0] salida
);
	logic [n-1:0] aux;
	
	always_comb begin
		case (ss)
			0:
				aux = a;
			1:
				aux = b;
			2:
				aux = c;
			3:
				aux = d;
			4:
				aux = e;
			5:
				aux = f;
			default:
				aux = 0;
		endcase
	end
	assign salida = aux;
endmodule
