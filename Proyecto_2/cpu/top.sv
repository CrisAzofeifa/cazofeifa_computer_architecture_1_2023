module top (
    input logic clk, reset,
    output logic [31:0] WriteDataM, DataAdrM,
    output logic MemWriteM);

    logic [31:0] PCF, InstrF, ReadDataM;

    // instantiate processor and memories
    ripp processor(clk, reset, PCF, InstrF, MemWriteM, DataAdrM,
    WriteDataM, ReadDataM);

    imem instmem(PCF, InstrF);
	 
	 dmem datmem(clk, MemWriteM, DataAdrM, WriteDataM, ReadDataM);
	 
    //LUTMemory datmem(DataAdrM[5:0], clk, WriteDataM, MemWriteM, ReadDataM);

endmodule 