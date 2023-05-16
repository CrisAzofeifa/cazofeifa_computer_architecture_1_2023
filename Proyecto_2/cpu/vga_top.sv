module vga_top
	(
		input logic rst,
		input logic [23:0] memPx,
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
	
	logic [23:0] px;

   always @(posedge clk50MHz) begin
        case(rst)
            1'b0: px <= memPx;
        endcase
            //1'bx: px <= 1'bx;
   end
	
	clockDivider clock_convertor(clk50MHz, vga_clk);
	
	SYNC sync(px, vga_clk, vga_hsync, vga_vsync, clk25MHz,
                vga_red, vga_green, vga_blue, px_addr);
	
endmodule