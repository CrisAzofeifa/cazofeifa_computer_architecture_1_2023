module extend (
    input logic [21:0]  Instr,
    input logic [1:0]   ImmSrc,
    output logic [31:0] ExtImm);

    always_comb
        case(ImmSrc)
            // 10-bit unsigned immediate for data-processing
            2'b00: ExtImm = {22'b0, Instr[9:0]};
            // 10-bit unsigned immediate for GET/STR
            2'b01: ExtImm = {22'b0, Instr[9:0]};

            // 24-bit two's complement shifted branch
            2'b10: ExtImm = {{8{Instr[21]}}, Instr[21:0], 2'b00};
            // undefined
            default: ExtImm = 32'bx; 
        endcase

endmodule