module condcheck (
    input logic       Cond,
    input logic [3:0] Flags,
    output logic CondEx);

    logic neg, zero, carry, overflow, ge;

    assign {neg, zero, carry, overflow} = Flags;

    always_comb
        case(Cond)
            1'b1:    CondEx = zero; // EQ
            1'b0:    CondEx = 1'b1; // Always
            default: CondEx = 1'bx; // undefined
    endcase

endmodule