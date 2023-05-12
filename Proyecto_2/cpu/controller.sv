module controller (
    input logic             clk, reset,
    input logic  [25:10]    Instr,
    input logic  [3:0]      ALUFlags,
    output logic [1:0]      RegSrc, ImmSrc,
    output logic [2:0]      ALUControl,
    output logic            RegWrite, ALUSrc, MemWrite, MemtoReg, PCSrc
);

    logic [1:0] FlagW;
    logic       PCS, RegW, MemW, NoWrite;

    decoder dec(Instr[24:23], Instr[22:18], Instr[17:14],
                FlagW, PCS, RegW, MemW,
                MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl, NoWrite);

    condlogic cl(clk, reset, Instr[25], NoWrite,
                ALUFlags, FlagW, PCS, RegW, MemW,
                PCSrc, RegWrite, MemWrite);

endmodule