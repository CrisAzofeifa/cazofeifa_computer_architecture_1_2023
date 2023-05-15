module vga_top
	(
		input logic [7:0] memPx,
		input logic clk50MHz,
		output logic clk25MHz, 
		output logic vga_hsync,
		output logic vga_vsync,
		output logic [7:0] vga_red,
		output logic [7:0] vga_green,
		output logic [7:0] vga_blue,
		output logic [31:0] px_addr
		
	);
	
	logic vga_clk;
	
	clockDivider clock_convertor(clk50MHz, vga_clk);
	
	SYNC sync(memPX, vga_clk, vga_hsync, vga_vsync, clk25MHz,
                vga_red, vga_green, vga_blue, px_addr);
	
endmodule