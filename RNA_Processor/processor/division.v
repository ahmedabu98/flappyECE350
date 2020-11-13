module division(Dividend, Divisor, ctrl_DIV, clock, mult_or_div, Quotient, Remainder, exception, ready);
    input [31:0] Dividend, Divisor;
    input ctrl_DIV, clock, mult_or_div;

    output [31:0] Quotient, Remainder;
    output exception, ready;

    // Check for exception: division by 0
    // nor returns true when all inputs are 0
    nor(exception, Divisor[0], Divisor[1], Divisor[2], Divisor[3], Divisor[4], Divisor[5], Divisor[6], Divisor[7], Divisor[8], Divisor[9], Divisor[10], Divisor[11], Divisor[12], Divisor[13], Divisor[14], Divisor[15], Divisor[16], Divisor[17], Divisor[18], Divisor[19], Divisor[20], Divisor[21], Divisor[22], Divisor[23], Divisor[24], Divisor[25], Divisor[26], Divisor[27], Divisor[28], Divisor[29], Divisor[30], Divisor[31]);

    // Check for result = -1;
    wire [31:0] zero;
    wire opp_sign, zero_ovf;
    adder32 add_zero(Dividend, Divisor, zero, 1'b0, zero_ovf);
    nor sign_opp(opp_sign, zero[0], zero[1], zero[2], zero[3], zero[4], zero[5], zero[6], zero[7], zero[8], zero[9], zero[10], zero[11], zero[12], zero[13], zero[14], zero[15], zero[16], zero[17], zero[18], zero[19], zero[20], zero[21], zero[22], zero[23], zero[24], zero[25], zero[26], zero[27], zero[28], zero[29], zero[30], zero[31]);

    wire [63:0] init_Remainder, reg_input, divided, trial_shift, after_op;
    wire [31:0] adj_Dividend, adj_Divisor;

    wire sign_result, ovf, ovf1, overflow, MSB_befOp, Cin_add, MSB_afterOp, neg_clock;

    xor result_sign(sign_result, Dividend[31], Divisor[31]);
    
    adder32 Dividend_adj(32'b0, Dividend, adj_Dividend, Dividend[31], ovf);
    adder32 Divisor_adj(32'b0, Divisor, adj_Divisor, Divisor[31], ovf1);

    assign init_Remainder[63:32] = 32'b0;
    assign init_Remainder[31:0] = adj_Dividend;

    not invClock(neg_clock, clock);

    wire WE, not_ready;
    not ready_inv(not_ready, WE);

    assign reg_input = ctrl_DIV ? init_Remainder : after_op;
    register64 div(reg_input, divided, not_ready, clock, 1'b0);
    // register64 div(reg_input, divided, 1'b1, clock, ctrl_DIV); // Seetings with counter that gave 72 in AG350
    // Need inverted clock for tb

    assign MSB_befOp = divided[63];
    SLL1_div sl_trial(divided, trial_shift);
    not CinAdd(Cin_add, MSB_befOp);
    
    adder32 op_trial(trial_shift[63:32], adj_Divisor, after_op[63:32], Cin_add, overflow);
    assign after_op[31:1] = trial_shift[31:1];

    assign MSB_afterOp = after_op[63];
    assign after_op[0] = MSB_afterOp ? 1'b0 : 1'b1;

    // counter cycles(ctrl_DIV, clock, ctrl_DIV, mult_or_div, ready, WE);
    wire [5:0] counter;
    counter2 cycles(clock, ctrl_DIV, mult_or_div, ready, WE, counter);
    // counter3 cycles(ctrl_DIV, clock, ready, WE);

    wire [31:0] Quot1, Quot2;
    wire quot_ovf, quot_ovf1;
    adder32 quot(32'b0, divided[31:0], Quot1, sign_result, quot_ovf);
    adder32 resultNegOne(32'b0, 32'b1, Quot2, 1'b1, quot_ovf1);
    assign Quotient = opp_sign ? Quot2 : Quot1;
    assign Remainder = divided[63:32];   

endmodule