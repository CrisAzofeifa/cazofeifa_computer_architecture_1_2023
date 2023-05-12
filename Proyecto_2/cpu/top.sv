module top (
    input logic clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic MemWrite);

    logic [31:0] PC, Instr, ReadData;

    // instantiate processor and memories
    ripp processor(clk, reset, PC, Instr, MemWrite, DataAdr,
    WriteData, ReadData);

    imem instmem(PC, Instr);
    dmem datmem(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule 