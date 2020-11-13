module multiplication(Multiplicand, Multiplier, ctrl_MULT, clock, mult_or_div, Out, exception, ready);
    input [31:0] Multiplicand, Multiplier;
    input ctrl_MULT, clock, mult_or_div;
    output [31:0] Out;
    output exception, ready;

    wire [32:0] regA, regB, multiplicand_inv, multiplier_inv;

    wire [64:0] prodInit, Product, bef_shift, add_sub, shifted, interm3;
    wire sign_result, operation, Cin, overflow, overflow1, neg_clock;

    xor result_sign(sign_result, Multiplicand[31], Multiplier[31]);

    // Check for multiplication by 1
    genvar i;
    generate
            for(i=0; i<32; i=i+1) begin: loop1
                not inv_multiplicand(multiplicand_inv[i], Multiplicand[i]);
                not inv_multiplier(multiplier_inv[i], Multiplier[i]);
            end
    endgenerate

    wire [1:0] select;
    and multiplicand1(select[1], Multiplicand[0], multiplicand_inv[1], multiplicand_inv[2], multiplicand_inv[3], multiplicand_inv[4], multiplicand_inv[5], multiplicand_inv[6], multiplicand_inv[7], multiplicand_inv[8], multiplicand_inv[9], multiplicand_inv[10], multiplicand_inv[11], multiplicand_inv[12], multiplicand_inv[13], multiplicand_inv[14], multiplicand_inv[15], multiplicand_inv[16], multiplicand_inv[17], multiplicand_inv[18], multiplicand_inv[19], multiplicand_inv[20], multiplicand_inv[21], multiplicand_inv[22], multiplicand_inv[23], multiplicand_inv[24], multiplicand_inv[25], multiplicand_inv[26], multiplicand_inv[27], multiplicand_inv[28], multiplicand_inv[29], multiplicand_inv[30], multiplicand_inv[31]);
    and multiplier1(select[0], Multiplier[0], multiplier_inv[1], multiplier_inv[2], multiplier_inv[3], multiplier_inv[4], multiplier_inv[5], multiplier_inv[6], multiplier_inv[7], multiplier_inv[8], multiplier_inv[9], multiplier_inv[10], multiplier_inv[11], multiplier_inv[12], multiplier_inv[13], multiplier_inv[14], multiplier_inv[15], multiplier_inv[16], multiplier_inv[17], multiplier_inv[18], multiplier_inv[19], multiplier_inv[20], multiplier_inv[21], multiplier_inv[22], multiplier_inv[23], multiplier_inv[24], multiplier_inv[25], multiplier_inv[26], multiplier_inv[27], multiplier_inv[28], multiplier_inv[29], multiplier_inv[30], multiplier_inv[31]);

    // Check multiplication by -1
    wire Multiplicand_neg1, Multiplier_neg1, both_neg1;
    and multiplicand_neg1(Multiplicand_neg1, Multiplicand[0], Multiplicand[1], Multiplicand[2], Multiplicand[3], Multiplicand[4], Multiplicand[5], Multiplicand[6], Multiplicand[7], Multiplicand[8], Multiplicand[9], Multiplicand[10], Multiplicand[11], Multiplicand[12], Multiplicand[13], Multiplicand[14], Multiplicand[15], Multiplicand[16], Multiplicand[17], Multiplicand[18], Multiplicand[19], Multiplicand[20], Multiplicand[21], Multiplicand[22], Multiplicand[23], Multiplicand[24], Multiplicand[25], Multiplicand[26], Multiplicand[27], Multiplicand[28], Multiplicand[29], Multiplicand[30], Multiplicand[31]);
    and multiplier_neg1(Multiplier_neg1, Multiplier[0], Multiplier[1], Multiplier[2], Multiplier[3], Multiplier[4], Multiplier[5], Multiplier[6], Multiplier[7], Multiplier[8], Multiplier[9], Multiplier[10], Multiplier[11], Multiplier[12], Multiplier[13], Multiplier[14], Multiplier[15], Multiplier[16], Multiplier[17], Multiplier[18], Multiplier[19], Multiplier[20], Multiplier[21], Multiplier[22], Multiplier[23], Multiplier[24], Multiplier[25], Multiplier[26], Multiplier[27], Multiplier[28], Multiplier[29], Multiplier[30], Multiplier[31]);
    and both_minus1(both_neg1, Multiplicand_neg1, Multiplier_neg1);

    // Check if any of the numbers is largest negative number
    wire largeA, largeB;
    and neg_largeA(largeA, Multiplicand[31], multiplicand_inv[30], multiplicand_inv[29], multiplicand_inv[28], multiplicand_inv[27], multiplicand_inv[26], multiplicand_inv[25], multiplicand_inv[24], multiplicand_inv[23], multiplicand_inv[22], multiplicand_inv[21], multiplicand_inv[20], multiplicand_inv[19], multiplicand_inv[18], multiplicand_inv[17], multiplicand_inv[16], multiplicand_inv[15], multiplicand_inv[14], multiplicand_inv[13], multiplicand_inv[12], multiplicand_inv[11], multiplicand_inv[10], multiplicand_inv[9], multiplicand_inv[8], multiplicand_inv[7], multiplicand_inv[6], multiplicand_inv[5], multiplicand_inv[4], multiplicand_inv[3], multiplicand_inv[2], multiplicand_inv[1], multiplicand_inv[0]);
    and neg_largeB(largeB, Multiplier[31], multiplier_inv[30], multiplier_inv[29], multiplier_inv[28], multiplier_inv[27], multiplier_inv[26], multiplier_inv[25], multiplier_inv[24], multiplier_inv[23], multiplier_inv[22], multiplier_inv[21], multiplier_inv[20], multiplier_inv[19], multiplier_inv[18], multiplier_inv[17], multiplier_inv[16], multiplier_inv[15], multiplier_inv[14], multiplier_inv[13], multiplier_inv[12], multiplier_inv[11], multiplier_inv[10], multiplier_inv[9], multiplier_inv[8], multiplier_inv[7], multiplier_inv[6], multiplier_inv[5], multiplier_inv[4], multiplier_inv[3], multiplier_inv[2], multiplier_inv[1], multiplier_inv[0]);

    // Hardcoding -2^32 x -1
    wire unary_ovfA, unary_ovfB, hardcoded_op;
    and special_ovfA(unary_ovfA, largeA, Multiplier_neg1);
    and special_ovfB(unary_ovfB, largeB, Multiplicand_neg1);
    or op_hardcoded(hardcoded_op, unary_ovfA, unary_ovfB);

    assign prodInit[64:33] = 32'b0;
    assign prodInit[32:1] = Multiplier;
    assign prodInit[0] = 1'b0;

    not invClock(neg_clock, clock);
    wire WE, not_ready;
    not neg_ready(not_ready, WE);

    assign interm3 = ctrl_MULT ? prodInit : shifted;
    register65 prod(interm3, Product, not_ready, clock, 1'b0);
    // register65 prod(interm3, Product, not_ready, clock, 1'b0); // Settings with counter that gave 72 on AG350
    // need negative clock for testbecnh

    control checkOp(Product, operation, Cin);
    adder32 add(Product[64:33], Multiplicand, add_sub[64:33], Cin, overflow); // do add or sub
    assign add_sub[32:0] = Product[32:0];
    assign bef_shift = operation? add_sub : Product; // does add/sub (based on previous line) or nothing
    SRA1_mult sr(bef_shift, shifted); // arithmetic shift right

    wire [5:0] counter;
    // counter cycles(ctrl_MULT, clock, ctrl_MULT, mult_or_div, ready, WE);
    counter2 cycles(clock, ctrl_MULT, mult_or_div, ready, WE, counter);
    // counter2 cycles(clock, ready, mult_or_div, ready, WE, counter);
    // counter3 cycles(ctrl_MULT, clock, ready, WE);

    mux_4_32bits Result_mux(Out, select, Product[32:1], Multiplicand, Multiplier, 32'b1);

    wire excp_check, excp_pos_neg, no_excp1, no_excp, excp_final, check_sign;
    
    exception_check check_excp(Multiplicand, Multiplier, Product, sign_result, excp_check);
    assign excp_final = hardcoded_op ? 1'b1 : excp_check;
    
    or excp_no(no_excp, select[1], select[0]);
    
    assign exception = no_excp ? 1'b0 : excp_final;
    
    // nor all upper bits, is true when all are 0
    // and all upper bits, true when all are 1
    // nor above two, meaning not all are 0 and not all are 1
endmodule