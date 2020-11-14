module eight_bit_CLA(A, B, Cin, S, Cout, overflow);

    input[7:0] A, B;
    input Cin;
    output[7:0] S;
    output Cout;
    output overflow;

    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire c1, c2, c3, c4, c5, c6, c7;
    wire v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28;
    wire w1, w2, w3, w4, w5, w6, w7, w8;
    wire P, G;


    // compute all gi and pi
    // gi = xi*yi
    // pi = xi + yi
    and a0(g0, A[0], B[0]);
    and a1(g1, A[1], B[1]);
    and a2(g2, A[2], B[2]);
    and a3(g3, A[3], B[3]);
    and a4(g4, A[4], B[4]);
    and a5(g5, A[5], B[5]);
    and a6(g6, A[6], B[6]);
    and a7(g7, A[7], B[7]);
    or b0(p0, A[0], B[0]);
    or b1(p1, A[1], B[1]);
    or b2(p2, A[2], B[2]);
    or b3(p3, A[3], B[3]);
    or b4(p4, A[4], B[4]);
    or b5(p5, A[5], B[5]);
    or b6(p6, A[6], B[6]);
    or b7(p7, A[7], B[7]);

    // compute carries and sums
    // S[0]
    xor xor_1(S[0], A[0], B[0], Cin);

    // c1, S[1]
    and and_1(v1, p0, Cin);
    or or_1(c1, g0, v1);
    xor xor_2(S[1], A[1], B[1], c1);

    // c2, S[2]
    and and_2(v2, p1, p0, Cin);
    and and_3(v3, p1, g0);
    or or_2(c2, g1, v2, v3);
    xor xor_3(S[2], A[2], B[2], c2);

    // c3, S[3]
    and and_4(v4, p2, p1, p0, Cin);
    and and_5(v5, p2, p1, g0);
    and and_6(v6, p2, g1);
    or or_3(c3, g2, v4, v5, v6);
    xor xor_4(S[3], A[3], B[3], c3);

    // c4, S[4]
    and and_7(v7, p3, p2, p1, p0, Cin);
    and and_8(v8, p3, p2, p1, g0);
    and and_9(v9, p3, p2, g1);
    and and_10(v10, p3, g2);
    or or_4(c4, g3, v7, v8, v9, v10);
    xor xor_5(S[4], A[4], B[4], c4);

    // c5, S[5]
    and and_11(v11, p4, p3, p2, p1, p0, Cin);
    and and_12(v12, p4, p3, p2, p1, g0);
    and and_13(v13, p4, p3, p2, g1);
    and and_14(v14, p4, p3, g2);
    and and_15(v15, p4, g3);
    or or_5(c5, g4, v11, v12, v13, v14, v15);
    xor xor_6(S[5], A[5], B[5], c5);

    // c6, S[6]
    and and_16(v16, p5, p4, p3, p2, p1, p0, Cin);
    and and_17(v17, p5, p4, p3, p2, p1, g0);
    and and_18(v18, p5, p4, p3, p2, g1);
    and and_19(v19, p5, p4, p3, g2);
    and and_20(v20, p5, p4, g3);
    and and_21(v21, p5, g4);
    or or_6(c6, g5, v16, v17, v18, v19, v20, v21);
    xor xor_7(S[6], A[6], B[6], c6);

    // c7, S[7]
    and and_22(v22, p6, p5, p4, p3, p2, p1, p0, Cin);
    and and_23(v23, p6, p5, p4, p3, p2, p1, g0);
    and and_24(v24, p6, p5, p4, p3, p2, g1);
    and and_25(v25, p6, p5, p4, p3, g2);
    and and_26(v26, p6, p5, p4, g3);
    and and_27(v27, p6, p5, g4);
    and and_28(v28, p6, g5);
    or or_7(c7, g6, v22, v23, v24, v25, v26, v27, v28);
    xor xor_8(S[7], A[7], B[7], c7);

    // Find and output Cout

    // find P
    and and_29(P, p7, p6, p5, p4, p3, p2, p1, p0);
    // find G
    and and_30(w1, p7, g6);
    and and_31(w2, p7, p6, g5);
    and and_32(w3, p7, p6, p5, g4);
    and and_33(w4, p7, p6, p5, p4, g3);
    and and_34(w5, p7, p6, p5, p4, p3, g2);
    and and_35(w6, p7, p6, p5, p4, p3, p2, g1);
    and and_36(w7, p7, p6, p5, p4, p3, p2, p1, g0);
    or or_8(G, g7, w1, w2, w3, w4, w5, w6, w7);
    // Cout:
    and and_37(w8, P, Cin);
    or or_9(Cout, w8, G);

    xor ovf(overflow, c7, Cout);

endmodule