`define WHITE 24'hFFFFFF

module SYNC(
	input logic VGA_CLK_IN,
	output logic o_hsync,
	output logic o_vsync,
	output logic VGA_CLK_OUT,
	output logic [7:0] o_red,
	output logic [7:0] o_blue,
	output logic [7:0] o_green,
	output logic [9:0] counter_x = 0,
	output logic [9:0] counter_y = 0,
	output logic [14:0] counter_pixel = 0
);
	reg [7:0] r_red = 0;
	reg [7:0] r_blue = 0;
	reg [7:0] r_green = 0;
	
	always @(posedge VGA_CLK_IN)
		begin 
			if (counter_x < 640)
				counter_x <= counter_x + 1;
			else
				counter_x <= 0;
		end
		
	always @(posedge VGA_CLK_IN)
		begin 
			if (counter_x == 640)
				begin 
					if (counter_y < 480)
						counter_y <= counter_y + 1;
					else
						counter_y <= 0;
				end
		end
		
		always @ (posedge VGA_CLK_IN)
		begin 
			if ((counter_x < 170 || 470 < counter_x) || (counter_y < 90 || 390 < counter_y))
				begin 
					{r_red,r_green,r_blue} <= `WHITE;
				end
			else 
				begin 
					if (counter_pixel < 90000)
						begin
							counter_pixel <= counter_pixel + 1;
						end
					else
						begin
							counter_pixel <= 0;
						end
				end
		end
		

	assign o_hsync = (0 <= counter_x && counter_x < 96) ? 1:0;
	assign o_vsync = (0 <= counter_y && counter_y < 2) ? 1:0;	

	assign VGA_CLK_OUT = VGA_CLK_IN;

	assign o_red = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_red : 8'h00;
	assign o_blue = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_blue : 8'h00;
	assign o_green = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_green : 8'h00;

endmodule

					

		
	
	
	
	
	
	