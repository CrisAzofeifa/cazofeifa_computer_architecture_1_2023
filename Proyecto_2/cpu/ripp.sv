module ripp (
    input logic         clk, reset,
    output logic [31:0] PC,
    input logic  [31:0] Instr,
    output logic        MemWrite,
    output logic [31:0] ALUResult, WriteData,
    input logic  [31:0] ReadData);

    logic [3:0] ALUFlags;
    logic       RegWrite, ALUSrc, MemtoReg, PCSrc;
    logic [1:0] RegSrc, ImmSrc;
    logic [2:0] ALUControl;

    controller c(clk, reset, Instr[25:10], ALUFlags, 
                RegSrc, ImmSrc, ALUControl, RegWrite,
                ALUSrc, MemWrite, MemtoReg, PCSrc);

    datapath dp(clk, reset,
            RegSrc, RegWrite, ImmSrc,
            ALUSrc, ALUControl,
            MemtoReg, PCSrc,
            ALUFlags, PC, Instr,
            ALUResult, WriteData, ReadData);

endmodule