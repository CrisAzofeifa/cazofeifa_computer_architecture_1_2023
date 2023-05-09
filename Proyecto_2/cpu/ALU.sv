module ALU(input logic [31:0] a, b, input logic [3:0] op, output logic [31:0] result, output logic zero, overflow, sign);
    logic [31:0] sum, res, mul, divi, modu;
    
    suma add(.a(a), .b(b), .result(sum));
    resta sub(.a(a), .b(b), .result(res));
    multiplicacion mult(.a(a), .b(b), .result(mul));
    division div(.a(a), .b(b), .result(divi));
    modulo mod(.a(a), .b(b), .result(modu));
    
    multiplexor mux(.a(sum), .b(res), .c(mul), .d(divi), .e(modu), .sel(op), .result(result));
	 Flags flags(.a(a), .b(b), .op(op), .result(result), .zero(zero), .overflow(overflow), .sign(sign));
    
    
endmodule
