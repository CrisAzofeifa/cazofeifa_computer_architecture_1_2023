module RegisterFile (
  input wire clk,
  input wire [2:0] readAddr1, readAddr2,
  input wire [2:0] writeAddr,
  input wire writeEnable,
  input wire [31:0] writeData,
  output reg [31:0] readData1, readData2
);

  reg [31:0] registers [8:0];

  always_ff @(posedge clk) begin
    if (writeEnable) begin
      registers[writeAddr] <= writeData;
    end
  end
  assign readData1 = registers[readAddr1];
  assign readData2 = registers[readAddr2];

endmodule
