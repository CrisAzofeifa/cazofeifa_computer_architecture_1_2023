module conditional (
    input logic        Cond, 
    input logic [3:0]  Flags, 
    input logic [3:0]  ALUFlags, 
    input logic [1:0]  FlagsWrite, 
    output logic       CondEx, 
    output logic [3:0] FlagsNext); 

    logic zero; 
    assign zero = Flags[2];

    always_comb
        case(Cond)
            1'b1:    CondEx = zero; // EQ
            1'b0:    CondEx = 1'b1; // Always
            default: CondEx = 1'bx; // undefined
    endcase

    assign FlagsNext[3:2] = (FlagsWrite[1] & CondEx) ? ALUFlags[3:2] : Flags[3:2]; 
    assign FlagsNext[1:0] = (FlagsWrite[0] & CondEx) ? ALUFlags[1:0] : Flags[1:0]; 

endmodule