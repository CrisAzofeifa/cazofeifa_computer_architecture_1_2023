module imem (
    input logic [31:0] a,
    output logic [31:0] rd);

    logic [31:0] ROM[63:0];

    initial
        $readmemh("instructions.dat", ROM);

    assign rd = ROM[a[31:2]]; // word aligned

endmodule