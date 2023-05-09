module Flags(input logic [31:0] a, b, input logic [3:0] op, input logic [31:0] result, output logic zero, overflow, sign);
    always @(*) begin
        zero = (result == 0);
        sign = result[31];
        case(op)
            3'b000: begin // Suma
                overflow = (a[31] == b[31] && result[31] != a[31]) ? 1'b1 : 1'b0;
            end
				3'b001: begin //Resta
                overflow = (a[31] == b[31] && result[31] != a[31]) ? 1'b1 : 1'b0;
            end
            3'b010: begin // Multiplicación
                overflow = (result[31:0] != result[31]) ? 1'b1 : 1'b0;
            end
            default: overflow = 1'b0;
        endcase
        
        
    end
endmodule