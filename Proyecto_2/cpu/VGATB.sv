module VGATB
(
	input logic clk,
	output logic o_hsync,
	output logic o_vsync,
	output logic VGA_CLK_OUT,
	output logic [7:0] o_red,
	output logic [7:0] o_green,	
	output logic [7:0] o_blue, 
	input logic clk_25,
	output logic counter_x,
	output logic counter_y
 );

	//clockDivider clockdiv(clk, clk_out);
	SYNC sync1(clk_25, o_hsync, o_vsync, VGA_CLK_OUT, o_red, o_blue, o_green);


endmodule 