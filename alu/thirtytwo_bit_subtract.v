module thirtytwo_bit_subtract(A, B, S, overflow, isLessThan, isNotEqual);

    input[31:0] A, B;
    output[31:0] S;
    output overflow, isLessThan, isNotEqual;

    wire[31:0] not_B, negative_B;
    wire ovf_ignore, w1;

    myNot n1(B, not_B);
    thirtytwo_bit_CLA addone(not_B, 32'b1, negative_B, ovf_ignore);

    thirtytwo_bit_CLA addit(A, negative_B, S, overflow);

    assign isLessThan = S[31];

    or or1(isNotEqual, S[0], S[1], S[2], S[3], S[4], S[5], S[6], S[7], S[8], S[9], S[10], S[11], S[12], S[13], S[14], S[15], S[16], S[17], S[18], S[19], S[20], S[21], S[22], S[23], S[24], S[25], S[26], S[27], S[28], S[29], S[30], S[31]);
endmodule