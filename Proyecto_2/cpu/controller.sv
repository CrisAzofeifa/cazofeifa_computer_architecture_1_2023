module controller (
    input logic             clk, reset,
    input logic  [31:12]    Instr,
    input logic  [3:0]      ALUFlags,
    output logic [1:0]      RegSrc, ImmSrc,
    output logic [1:0]      ALUControl,
    output logic            RegWrite, ALUSrc, MemWrite, MemtoReg, PCSrc
);

    logic [1:0] FlagW;
    logic       PCS, RegW, MemW;

    decoder dec(Instr[27:26], Instr[25:20], Instr[15:12],
                FlagW, PCS, RegW, MemW,
                MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

    condlogic cl(clk, reset, Instr[31:28], NoWrite,
                ALUFlags, FlagW, PCS, RegW, MemW,
                PCSrc, RegWrite, MemWrite);

endmodule