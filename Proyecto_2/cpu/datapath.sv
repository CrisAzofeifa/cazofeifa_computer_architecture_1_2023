module datapath (
    input logic         clk, reset,
    input logic  [1:0]  RegSrc,
    input logic         RegWrite,
    input logic  [1:0]  ImmSrc,
    input logic         ALUSrc,
    input logic  [2:0]  ALUControl,
    input logic         MemtoReg,
    input logic         PCSrc,
    output logic [3:0]  ALUFlags,
    output logic [31:0] PC,
    input logic  [31:0] Instr,
    output logic [31:0] ALUResult, WriteData,
    input logic  [31:0] ReadData);

    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [3:0]  RA1, RA2;

    // next PC logic
    mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

    // register file logic
    mux2 #(4) ra1mux(Instr[13:10], 4'b1001, RegSrc[0], RA1);
    mux2 #(4) ra2mux(Instr[3:0], Instr[17:14], RegSrc[1], RA2);

    RegisterFile rf(clk, RegWrite, RA1, RA2,
                Instr[17:14], Result, PCPlus8,
                SrcA, WriteData);

    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    extend ext(Instr[21:0], ImmSrc, ExtImm);

    // ALU logic
    mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
    ALUTopLevel #(32) alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

endmodule