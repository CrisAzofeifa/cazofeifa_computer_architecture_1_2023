module RegisterFile (
    input logic         clk, writeEnable
    input logic [2:0]   readAddr1, readAddr2, writeAddr,
    input logic [31:0]  writeData, r9,
    output logic [31:0] readData1, readData2
);

  logic [31:0] registers [8:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 9 reads PC + 8 instead

  always_ff @(posedge clk) begin
    if (writeEnable) begin
      registers[writeAddr] <= writeData;
    end
  end

  assign readData1 = (readAddr1 == 4'b1001) ? r9 : registers[readAddr1];
  assign readData2 = (readAddr2 == 4'b1001) ? r9 : registers[readAddr2];

endmodule
