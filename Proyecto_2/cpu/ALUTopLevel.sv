module ALUTopLevel #(parameter n = 32) (input [n-1:0] a,b, input [2:0] ALUControl, output [n-1:0] resultado, output [3:0] flagsResult);
	
	logic [n-1:0] rs, rr, rm, rd, rmod, rmov;
	logic [3:0] fs, fr, fm, fd, fmod, fmov;
	
	ALU #(32) aluCalcu(a, b, rs, rr, rm, rd, rmod, rmov, fs, fr, fm, fd, fmod, fmov);
	multiplexor #(32) muxCalcu(rs, rr, rm, rd, rmod, rmov, ALUControl, resultado);
	multiplexor #(4) muxFlags(fs, fr, fm, fd, fmod, fmov, ALUControl, flagsResult);
	

endmodule
