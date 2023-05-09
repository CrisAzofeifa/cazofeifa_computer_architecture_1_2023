module decoder (
    input logic  [1:0]  Op, 
    input logic  [4:0]  Funct,
    input logic  [3:0]  Rd,
    output logic [1:0]  FlagW,
    output logic        PCS, RegW, MemW, MemtoReg, ALUSrc,
    output logic [1:0]  ImmSrc, RegSrc, ALUControl
);

    logic [9:0] controls;
    logic       Branch, ALUOp;

    // Main Decoder
    always_comb 
        casex(Op)
                                  // Data-processing immediate
            2'b00: if (Funct[4])  controls = 10'b0000101001;
                                  // Data-processing register
                   else           controls = 10'b0000001001;
                                  // Branch
            2'b01:                controls = 10'b0110100010;
                                  // GET
            2'b10: if (Funct[0])  controls = 10'b0001111000;   
                                  // STR
                   else           controls = 10'b1001110100;
                                  // Unimplemented
            default:              controls = 10'bx;
        endcase

    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;                       

    // ALU Decoder

endmodule