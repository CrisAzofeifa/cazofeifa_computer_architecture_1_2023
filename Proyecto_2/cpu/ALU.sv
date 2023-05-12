module ALU #(parameter n = 32)(input [n-1:0] a, b, output [n-1:0] rs, rr, rm, rd, rmod, rmov, 
										output [3:0] fs, fr, fd, fm, fmod, fmov);

	logic [n-1:0] rauxs, rauxr, rauxm, rauxd, rauxmod, rauxmov;
	logic [3:0] auxfs, auxfr, auxfd, auxfm, auxfmod, auxfmov;
	
	suma #(32) sum (a, b, rauxs, auxfs);
	resta #(32) rest (a, b, rauxr, auxfr);
	multiplicacion #(32) multi (a, b, rauxm, auxfd);
	division #(32) div (a, b, rauxd, auxfm);
	modulo #(32) mod (a, b, rauxmod, auxfmod);
	mov #(32) mov1 ( b, rauxmov, auxfmov);
	
	assign rs = rauxs; 
	assign rr = rauxr;
	assign rm = rauxm;
	assign rd = rauxd;
	assign rmod = rauxmod;
	assign rmov = rauxmov;
	
	assign fs = auxfs;
	assign fr = auxfr;
	assign fd = auxfd;
	assign fm = auxfm;
	assign fmod = auxfmod;
	assign fmov = auxfmov;
	
endmodule