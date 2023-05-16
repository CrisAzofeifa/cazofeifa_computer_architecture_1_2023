module top (
    input logic  clk, reset,
    output logic clk25MHz,
    output logic vga_hsync,
	output logic vga_vsync,
	output logic [7:0] vga_red,
	output logic [7:0] vga_green,
	output logic [7:0] vga_blue);

    logic        MemWriteM;
    logic [31:0] PCF, InstrF, ReadDataM, WriteDataM, DataAdrM, px_data, address2;
    logic       clock;

    // instantiate processor and memories
    ripp processor(clk, reset, PCF, InstrF, MemWriteM, DataAdrM,
    WriteDataM, ReadDataM);

    imem instmem(PCF, InstrF);
	 
	dmem datmem(clk, MemWriteM, DataAdrM, address2, WriteDataM, ReadDataM, px_data);
    
    vga_top vga(px_data[23:0], clk, clk25MHz, vga_hsync, vga_vsync, 
                vga_red, vga_green, vga_blue, address2);

endmodule 