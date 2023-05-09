module ALUTest;
    reg [31:0] a, b;
    reg [3:0] op;
    wire [31:0] result;
    wire zero, overflow, sign;
    
    ALU alu(.a(a), .b(b), .op(op), .result(result), .zero(zero), .overflow(overflow), .sign(sign));
    
    initial begin

        a = 10;
        b = 20;
        op = 3'b000;
        #10;
		  $display("SUMA");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        

        a = 10;
        b = 30;
        op = 3'b001;
        #10;
		  $display("RESTA");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        

        a = 5;
        b = 0;
        op = 3'b010;
        #10;
		  $display("MULTIPLICACION");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);

        a = 25;
        b = 5;
        op = 3'b011;
        #10;
		  $display("DIVISION");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        

        a = 30;
        b = 7;
        op = 3'b100;
        #10;
		  $display("MODULO");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        
  
        a = -15;
        b = -20;
        op = 3'b000;
        #10;
		  $display("SUMA");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        
        a = 50;
        b = 25;
        op = 3'b001;
        #10;
		  $display("RESTA");
        $display("a: %d, b: %d, Resultado: %d, Zero: %b, Overflow: %b, Sign: %b", a, b, result, zero, overflow, sign);
        
        
    end
endmodule

