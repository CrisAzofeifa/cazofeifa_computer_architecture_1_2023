module syncTB();
	
	logic CLK50MHZ;
	logic CLK25MHZ;
	logic VGA_HS;
	logic VGA_VS;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic VGA_CLK_OUT;
	logic [7:0] VGA_B;
	reg [9:0] counter_x = 0;
	reg [9:0] counter_y = 0;
	reg [14:0] counter_pixel = 0;
	
SYNC controlador(CLK25MHZ,
					VGA_HS,
					VGA_VS,
					VGA_CLK_OUT,
					VGA_R,
					VGA_B,
					VGA_G,
					counter_x,
					counter_y,
					counter_pixel
					);

initial begin 
	CLK50MHZ = 0;
	CLK25MHZ = 0;
	
end

always begin 
	
	CLK50MHZ =~CLK50MHZ;#50;

end

always begin 
	CLK25MHZ =~CLK25MHZ;#100;
end

endmodule