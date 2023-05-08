module muxALU #(parameter N=5)(input[3:0] select, input[N-1:0] a,b,c,d,e, output logic[N-1:0] out);
	always_comb begin
		case(select)
			4'b0000: out=a;
			4'b0001: out=b;
			4'b0010: out=c;
			4'b0011: out=d;
			4'b0100: out=e;
		endcase 
	end
endmodule 