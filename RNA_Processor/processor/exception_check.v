module exception_check(Multiplicand, Multiplier, Product, sign_result, exception);

    input [64:0] Product;
    input [31:0] Multiplicand, Multiplier;
    input sign_result;
    output exception;

    wire overInterm1, overInterm2, check_sign, excp_check;

    xor sign_check(check_sign, Product[32], sign_result);
    // assign exception = check_sign;

    nor Over0s(overInterm1, Product[64], Product[63], Product[62], Product[61], Product[60], Product[59], Product[58], Product[57], Product[56], Product[55], Product[54], Product[53], Product[52], Product[51], Product[50], Product[49], Product[48], Product[47], Product[46], Product[45], Product[44], Product[43], Product[42], Product[41], Product[40], Product[39], Product[38], Product[37], Product[36], Product[35], Product[34], Product[33], Product[32]);
    and Over1s(overInterm2, Product[64], Product[63], Product[62], Product[61], Product[60], Product[59], Product[58], Product[57], Product[56], Product[55], Product[54], Product[53], Product[52], Product[51], Product[50], Product[49], Product[48], Product[47], Product[46], Product[45], Product[44], Product[43], Product[42], Product[41], Product[40], Product[39], Product[38], Product[37], Product[36], Product[35], Product[34], Product[33], Product[32]);
    nor data_excp(exception, overInterm1, overInterm2);

endmodule