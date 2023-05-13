module testVGA();
	
	logic CLK50MHZ;
	logic CLK25MHZ;
	logic VGA_HS;
	logic VGA_VS;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic VGA_CLK_OUT;
	logic [7:0] VGA_B;
	
	
VGATB controlador(CLK50MHZ,
					VGA_HS,
					VGA_VS,
					VGA_CLK_OUT,
					VGA_R,
					VGA_G,
					VGA_B,
					CLK25MHZ
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