module multiplexor(input logic [31:0] a, b, c, d, e,  input logic [1:0] sel, output logic [31:0] result);
    assign result = (sel == 3'b000) ? a : (sel == 3'b001) ? b : (sel == 3'b010) ? c : (sel == 3'b011) ? d : (sel == 3'b100) ? e : 0;
endmodule