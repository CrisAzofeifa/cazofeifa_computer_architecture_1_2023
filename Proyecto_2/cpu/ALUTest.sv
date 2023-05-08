module ALUTest;
    logic [31:0] a, b, result;
    logic [2:0] op;
    
    ALU alu(.a(a), .b(b), .op(op), .result(result));
    
    initial begin
        a = 20;
        b = 3;
        
        op = 3'b000;  // Suma
        #10;
        $display("SUMA");
        $display("a = %d, b = %d", a, b);
        $display("Resultado: %d", result);
        
        op = 3'b001;  // Resta
        #10;
        $display("RESTA");
        $display("a = %d, b = %d", a, b);
        $display("Resultado: %d", result);
        
        op = 3'b010;  // Multiplicación
        #10;
        $display("MULTIPLICACION");
        $display("a = %d, b = %d", a, b);
        $display("Resultado: %d", result);
        
        op = 3'b011;  // División
        #10;
        $display("DIVISION");
        $display("a = %d, b = %d", a, b);
        $display("Resultado: %d", result);
		  
        op = 3'b100;  // Módulo
        #10;
        $display("MODULO");
        $display("a = %d, b = %d", a, b);
        $display("Resultado: %d", result);
        
        // Finalizar la simulación
        #10;
        $finish;
    end
endmodule
