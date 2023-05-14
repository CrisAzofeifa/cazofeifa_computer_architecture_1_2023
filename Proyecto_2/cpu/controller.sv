module controller (
    input logic             clk, reset,
    input logic  [25:10]    InstrD,
    input logic  [3:0]      ALUFlagsE,
    output logic [1:0]      RegSrcD, ImmSrcD,
    output logic            ALUSrcE, BranchTakenE, 
    output logic [2:0]      ALUControlE,
    output logic            MemWriteM, MemtoRegW, PCSrcW, RegWriteW,
    //hazard interface
    output logic            RegWriteM, MemtoRegE, 
    output logic            PCWrPendingF, 
    input logic             FlushE);

    logic [9:0] controlsD; 
    logic CondExE, ALUOpD; 
    logic [2:0] ALUControlD; 
    logic ALUSrcD; 
    logic MemtoRegD, MemtoRegM; 
    logic RegWriteD, RegWriteE, RegWriteGatedE;
    logic MemWriteD, MemWriteE, MemWriteGatedE;
    logic BranchD, BranchE; 
    logic [1:0] FlagWriteD, FlagWriteE; 
    logic PCSrcD, PCSrcE, PCSrcM; 
    logic [3:0] FlagsE, FlagsNextE, 
    logic       CondE;
    logic       NoWrite;

    // Decode stage 
    // Main Decoder
    always_comb 
        casex(InstrD[24:23]) 
            // data-processing
                    // data-processing immediate
            2'b00:  if (InstrD[22]) controlsD = 10'b0000101001; 
                    // data-processing register
                    else            controlsD = 10'b0000001001;
                    // GET
            2'b10:  if (InstrD[18]) controlsD = 10'b0001111000; 
                    // PUT
                    else            controlsD = 10'b1001110100; 
                    // Branch
            2'b01:                  controlsD = 10'b0110100010;
                    // Unimplemented
            default:                controlsD = 10'bx; 
       endcase 

    assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, 
    MemWriteD, BranchD, ALUOpD} = controlsD; 

    // ALU Decoder
    always_comb 
        if (ALUOpD) begin // which Data-processing Instr? 
            case(InstrD[21:19]) 
                3'b000:     ALUControl = 3'b000;    // ADD
                3'b001:     ALUControl = 3'b010;    // MUL
                3'b010:     ALUControl = 3'b011;    // DIV
                3'b011:     ALUControl = 3'b100;    // MOD
                3'b100:     ALUControl = 3'b101;    // MOV
                3'b101:     ALUControl = 3'b001;    // EQV (SUB)
                default:    ALUControl = 3'bx;      // Unimplemented
            endcase 

            // update flags if S bit is set (C & V only for arithmetic)
            FlagWriteD[1] = InstrD[18];  
            FlagWriteD[0] = InstrD[18] & 
                (ALUControl == 3'b000 | ALUControl == 3'b010 |
                ALUControl == 3'b011 | ALUControl == 3'b100 | ALUControl == 3'b001);

            //TODO: NoWrite
            NoWrite = (ALUControl == 3'b0001);

        end else begin 
            ALUControlD = 3'b00; // perform addition for non-dp instr 
            FlagWriteD = 2'b00; // don't update Flags 
            //TODO: NoWrite
            NoWrite = 1'b0;       // don't update NoWrite
        end

    assign PCSrcD = (((InstrD[17:14] == 4'b1001) & RegWriteD) | BranchD); 

    // Execute stage 
    floprc #(7) flushedregsE(clk, reset, FlushE, {FlagWriteD, BranchD, MemWriteD, RegWriteD, 
    PCSrcD, MemtoRegD}, {FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE}); 
    
    flopr #(4) regsE(clk, reset, {ALUSrcD, ALUControlD}, {ALUSrcE, ALUControlE});
    flopr #(1) condregE(clk, reset, InstrD[25], CondE); 
    flopr #(4) flagsreg(clk, reset, FlagsNextE, FlagsE); 

    // Write and Branch controls are conditional 
    conditional Cond(CondE, FlagsE, ALUFlagsE, FlagWriteE, CondExE, FlagsNextE); 
    assign BranchTakenE = BranchE & CondExE; 
    assign RegWriteGatedE = RegWriteE & ~NoWrite & CondExE; //TODO: NoWrite
    assign MemWriteGatedE = MemWriteE & CondExE; 
    assign PCSrcGatedE = PCSrcE & CondExE; 

    // Memory stage 
    flopr #(4) regsM(clk, reset, {MemWriteGatedE, MemtoRegE, RegWriteGatedE, PCSrcGatedE}, 
    {MemWriteM, MemtoRegM, RegWriteM, PCSrcM}); 

    // Writeback stage 
    flopr #(3) regsW(clk, reset, {MemtoRegM, RegWriteM, PCSrcM}, {MemtoRegW, RegWriteW, PCSrcW});

    // Hazard Prediction 
    assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
endmodule