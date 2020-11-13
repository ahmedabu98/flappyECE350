module bit32_comp(EQ, GT, A, B);
    input [31:0] A, B;
    output EQ, GT;

    wire eq0, gt0, eq1, gt1, eq2, gt2, eq3, gt3;

/*     eight_bit_comp comp3(w0, w1, A[31:24], B[31:24], Eq_ip1, Gt_ip1);
    eight_bit_comp comp2(w2, w3, A[23:16], B[23:16], w0, w1);
    eight_bit_comp comp1(w4, w5, A[15:8], B[15:8], w2, w3);
    eight_bit_comp comp0(Eq_i, Gt_i, A[7:0], B[7:0], w4, w5);
 */
    eight_bit_comp comp3(eq3, gt3, A[31:24], B[31:24], 1'b1, 1'b0);
    eight_bit_comp comp2(eq2, gt2, A[23:16], B[23:16], eq3, gt3);
    eight_bit_comp comp1(eq1, gt1, A[15:8], B[15:8], eq2, gt2);
    eight_bit_comp comp0(EQ, GT, A[7:0], B[7:0], eq1, gt1);
endmodule