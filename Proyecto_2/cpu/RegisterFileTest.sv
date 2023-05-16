module RegisterFileTest;
  logic clk;
  logic [3:0] readAddr1, readAddr2, writeAddr;
  logic writeEnable;
  logic [31:0] writeData;
  logic [31:0] readData1, readData2;
  
  RegisterFile dut (
    .clk(clk),
    .readAddr1(readAddr1),
    .readAddr2(readAddr2),
    .writeAddr(writeAddr),
    .writeEnable(writeEnable),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
  );
	always #25 clk = ~clk;
  initial begin
	clk = 0;
    
    // Inicialización de registros
    dut.registers[0] = 10;
    dut.registers[1] = 20;
    dut.registers[2] = 30;
    dut.registers[3] = 40;
    dut.registers[4] = 50;
    dut.registers[5] = 60;
    dut.registers[6] = 70;
    dut.registers[7] = 80;
    dut.registers[8] = 90;
    
    // Test de lectura
    #10;
    readAddr1 = 4'b0110;
    readAddr2 = 2;
    #10;
	 $display("ReadData1 = %0d, ReadData2 = %0d", readData1, readData2);
    
    // Test de escritura
    writeAddr = 5;
    writeEnable = 1;
    writeData = 100;
    #10;
	 $display("ReadData1 = %0d, ReadData2 = %0d", readData1, readData2);
    
    // Test de lectura después de escritura
    readAddr1 = 5;
    readAddr2 = 2;
    writeEnable = 0;
    #10;
	 $display("ReadData1 = %0d, ReadData2 = %0d", readData1, readData2);
    
  end
  

endmodule





