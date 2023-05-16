module ALUTest;
    reg [31:0] a, b;
    reg [2:0] op;
    wire [31:0] result;
	reg [3:0] flags;
    
    ALUTopLevel #(32) alu(.a(a), .b(b), .ALUControl(op), .resultado(result), .flagsResult(flags));
    
    initial begin

        a = 10;
        b = 20;
        op = 3'b000;
        #10;
		  $display("SUMA");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
        

        a = 10;
        b = 30;
        op = 3'b001;
        #10;
		  $display("RESTA");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
        

        a = 5;
        b = 0;
        op = 3'b010;
        #10;
		  $display("MULTIPLICACION");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);

        a = 25;
        b = 5;
        op = 3'b011;
        #10;
		  $display("DIVISION");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
        

        a = 30;
        b = 7;
        op = 3'b100;
        #10;
		  $display("MODULO");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
        
  
        a = -15;
        b = -20;
        op = 3'b000;
        #10;
		  $display("SUMA");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
		  
        a = 50;
        b = 25;
        op = 3'b001;
        #10;
		  $display("RESTA");
        $display("a: %d, b: %d, Resultado: %d, Overflow: %b, Carry: %b, Zero: %b, Sign: %b", a, b, result, flags[0], flags[1], flags[2], flags[3]);
        
        
    end
endmodule

