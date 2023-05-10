module decoder (
    input logic  [1:0]  Op, 
    input logic  [4:0]  Funct,
    input logic  [3:0]  Rd,
    output logic [1:0]  FlagW,
    output logic        PCS, RegW, MemW, MemtoReg, ALUSrc,
    output logic [1:0]  ImmSrc, RegSrc, 
    output logic [2:0]  ALUControl,
    output logic        NoWrite
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
    always_comb
    if (ALUOp) begin            // which DP instruction?
        case(Funct[3:1])
            3'b000:     ALUControl = 3'b000;    // ADD
            3'b001:     ALUControl = 3'b010;    // MUL
            3'b010:     ALUControl = 3'b011;    // DIV
            3'b011:     ALUControl = 3'b100;    // MOD
            3'b100:     ALUControl = 3'b101;    // MOV
            3'b101:     ALUControl = 3'b001;    // EQV (SUB)
            default:    ALUControl = 3'bx;      // Unimplemented
        endcase

        // update flags if S bit is set (C & V only for arithmetic)
        FlagW[1] = Funct[0];
        FlagW[0] = Funct[0] & 
            (ALUControl == 3'b000 | ALUControl == 3'b010 | ALUControl == 3'b011 |
             ALUControl == 3'b100 | ALUControl == 3'b001);
        
        NoWrite = (ALUControl == 3'b0001);

    end 
    else begin
        ALUControl = 3'b000; // add for non-DP instructions
        FlagW = 3'b000;       // don't update Flags
        NoWrite = 1'b0;       // don't update NoWrite
    end

    // PC Logic
    assign PCS = ((Rd == 4'b1001) & RegW) | Branch;

endmodule