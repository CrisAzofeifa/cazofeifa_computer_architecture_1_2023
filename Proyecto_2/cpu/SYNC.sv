`define WHITE 24'hFFFFFF
`define BLACK 24'h000000
`define LIGHTBLUE 24'h10A6ED

module SYNC (
	input logic [7:0] memPx,
	input logic         VGA_CLK_IN,
	output logic        o_hsync,
	output logic        o_vsync,
	output logic        VGA_CLK_OUT,
	output logic [7:0]  o_red,
   output logic [7:0]  o_green,
	output logic [7:0]  o_blue,
	output logic [31:0] px_addr
	);

   localparam h_border_left = 145;	
	localparam h_border_right = 783;
	localparam v_border_up = 36;
	localparam v_border_down= 515;

    // ------- Variables internas --------
	reg [9:0] counter_x = 0; // horizontal counter
	reg [9:0] counter_y = 0; // vertical counter

	reg [7:0] r_red = 0;
   reg [7:0] r_green = 0;
	reg [7:0] r_blue = 0;
	
	reg [31:0] pixel_pos = 24;

    // ------- Counters --------
	always @(posedge VGA_CLK_IN) // horizontal counter
		begin 
			if (counter_x < 799)
				counter_x <= counter_x + 1; // including borders
			else
				counter_x <= 0;
		end
		
	always @(posedge VGA_CLK_IN) // vertical counter
		begin 
			if (counter_x == 799)
				begin 
					if (counter_y < 525)
						counter_y <= counter_y + 1;
					else
						counter_y <= 0;
				end
		end
		
        // ------- Pattern -------
		always @ (posedge VGA_CLK_IN)
		begin 
			if ((counter_x > 200 && counter_x < 500) && (counter_y > 100 && counter_y < 400))
				begin 
						if(pixel_pos < 90025) begin
						  pixel_pos <= pixel_pos + 1;
						end
						else begin
							pixel_pos <= 25;
						end
						{r_red, r_green, r_blue} <= memPx;
				end
			else 
				{r_red, r_green, r_blue} <= `LIGHTBLUE;
		end
	
	assign px_addr = pixel_pos;
	
	// Hsync and Vsync
	assign o_hsync = (counter_x > 0 && counter_x < 96) ? 1 : 0; // hsync for 96 counts
	assign o_vsync = (counter_y >= 0 && counter_y < 2) ? 1 : 0; // vsync for 2 counts

	assign VGA_CLK_OUT = VGA_CLK_IN;

	// Color outputs (on/off)
	assign o_red = (counter_x >= h_border_left && counter_x <= h_border_right && counter_y >= v_border_up && counter_y <= v_border_down) ? r_red : 8'h00;
	assign o_green = (counter_x >= h_border_left && counter_x <= h_border_right && counter_y >= v_border_up && counter_y <= v_border_down) ? r_green : 8'h00;
	assign o_blue = (counter_x >= h_border_left && counter_x <= h_border_right && counter_y >= v_border_up && counter_y <= v_border_down) ? r_blue : 8'h00;

endmodule
