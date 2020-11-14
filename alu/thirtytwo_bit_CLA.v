module thirtytwo_bit_CLA(A, B, S, overflow);

    input[31:0] A, B;
    output[31:0] S;
    output overflow;

    wire ovf1, ovf2, ovf3;
    wire Cin1, Cin2, Cin3, Cin4;

    eight_bit_CLA cla1(A[7:0], B[7:0], 1'b0, S[7:0], Cin1, ovf1);
    eight_bit_CLA cla2(A[15:8], B[15:8], Cin1, S[15:8], Cin2, ovf2);
    eight_bit_CLA cla3(A[23:16], B[23:16], Cin2, S[23:16], Cin3, ovf3);
    eight_bit_CLA cla4(A[31:24], B[31:24], Cin3, S[31:24], Cin4, overflow);

endmodule