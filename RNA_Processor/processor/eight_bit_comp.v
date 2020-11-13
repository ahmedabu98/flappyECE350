/* module eight_bit_comp(Eq_i, Gt_i, A, B, Eq_ip1, Gt_ip1);
    input [7:0] A, B;
    input Eq_ip1, Gt_ip1;
    wire Eq_ip1, Gt_ip1;
    output Eq_i, Gt_i;

    // assign Eq_ip1 = 1;
    // assign Gt_ip1 = 0;

    wire w1, w2, w3, w4, w5, w6;

    two_bit_comp comp1(w1, w2, A[7:6], B[7:6], Eq_ip1, Gt_ip1);
    two_bit_comp comp2(w3, w4, A[5:4], B[5:4], w1, w2);
    two_bit_comp comp3(w5, w6, A[3:2], B[3:2], w3, w4);
    two_bit_comp comp4(Eq_i, Gt_i, A[1:0], B[1:0], w5, w6);
endmodule */

module eight_bit_comp(EQ, GT, A, B, EQprev, GTprev);

    input [7:0] A, B;
    input EQprev, GTprev;
    output EQ, GT;
    wire eq1, gt1, eq2, gt2, eq3, gt3;
    //assign EQprev = 1'b1;
    //assign GTprev = 1'b0;
    
    two_bit_comp c3(eq3, gt3,  A[7:6], B[7:6], EQprev, GTprev);
    two_bit_comp c2(eq2, gt2, A[5:4], B[5:4], eq3, gt3);
    two_bit_comp c1(eq1, gt1, A[3:2], B[3:2], eq2, gt2);
    two_bit_comp c0(EQ, GT, A[1:0], B[1:0], eq1, gt1);
endmodule