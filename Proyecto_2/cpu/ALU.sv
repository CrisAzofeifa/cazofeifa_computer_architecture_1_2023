module ALU(input logic [31:0] a, input logic [31:0] b, input logic [1:0] op, output logic [31:0] result);
    logic [31:0] sum, res, mul, divi, modu;
    
    suma add(.a(a), .b(b), .result(sum));
    resta sub(.a(a), .b(b), .result(res));
    multiplicacion mult(.a(a), .b(b), .result(mul));
    division div(.a(a), .b(b), .result(divi));
    modulo mod(.a(a), .b(b), .result(modu));
    
    multiplexor mux(.a(sum), .b(res), .c(mul), .d(divi), .e(modu), .sel(op), .result(result));
    
endmodule
