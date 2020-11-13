module adder8(A, B, Cin, result, overflow, bigP, bigG);

    // Define inputs, ouptuts and wires
    input [7:0] A, B;
    input Cin;
    output [7:0] result;
    output overflow, bigP, bigG;

    wire [7:0] prop, gen, C;

    // Define generate and propagate functions for carry look-ahead adder
    or Prop0(prop[0], A[0], B[0]);
    and Gen0(gen[0], A[0], B[0]);

    or Prop1(prop[1], A[1], B[1]);
    and Gen1(gen[1], A[1], B[1]);

    or Prop2(prop[2], A[2], B[2]);
    and Gen2(gen[2], A[2], B[2]);

    or Prop3(prop[3], A[3], B[3]);
    and Gen3(gen[3], A[3], B[3]);

    or Prop4(prop[4], A[4], B[4]);
    and Gen4(gen[4], A[4], B[4]);

    or Prop5(prop[5], A[5], B[5]);
    and Gen5(gen[5], A[5], B[5]);

    or Prop6(prop[6], A[6], B[6]);
    and Gen6(gen[6], A[6], B[6]);

    or Prop7(prop[7], A[7], B[7]);
    and Gen7(gen[7], A[7], B[7]);

    // Define carry outs for each bit sum
    wire w0;
    and And0(w0, prop[0], Cin);
    or C0(C[0], w0, gen[0]);

    wire w1, w11;
    and And1(w1, prop[1], prop[0], Cin);
    and And11(w11, prop[1], gen[0]);
    or C1(C[1], gen[1], w1, w11);

    wire w2, w21, w22;
    and And2(w2, prop[2], prop[1], prop[0], Cin);
    and And21(w21, prop[2], prop[1], gen[0]);
    and And22(w22, prop[2], gen[1]);
    or C2(C[2], gen[2], w2, w21, w22);

    wire w3, w31, w32, w33;
    and And3(w3, prop[3], prop[2], prop[1], prop[0], Cin);
    and And31(w31, prop[3], prop[2], prop[1], gen[0]);
    and And32(w32, prop[3], prop[2], gen[1]);
    and And33(w33, prop[3], gen[2]);
    or C3(C[3], gen[3], w3, w31, w32, w33);

    wire w4, w41, w42, w43, w44;
    and And4(w4, prop[4], prop[3], prop[2], prop[1], prop[0], Cin);
    and And41(w41, prop[4], prop[3], prop[2], prop[1], gen[0]);
    and And42(w42, prop[4], prop[3], prop[2], gen[1]);
    and And43(w43, prop[4], prop[3], gen[2]);
    and And44(w44, prop[4], gen[3]);
    or C4(C[4], gen[4], w4, w41, w42, w43, w44);

    wire w5, w51, w52, w53, w54, w55;
    and And5(w5, prop[5], prop[4], prop[3], prop[2], prop[1], prop[0], Cin);
    and And51(w51, prop[5], prop[4], prop[3], prop[2], prop[1], gen[0]);
    and And52(w52, prop[5], prop[4], prop[3], prop[2], gen[1]);
    and And53(w53, prop[5], prop[4], prop[3], gen[2]);
    and And54(w54, prop[5], prop[4], gen[3]);
    and And55(w55, prop[5], gen[4]);
    or C5(C[5], gen[5], w5, w51, w52, w53, w54, w55);


    wire w61, w62, w63, w64, w65, w66;
    and And6(w6, prop[6], prop[5], prop[4], prop[3], prop[2], prop[1], prop[0], Cin);
    and And61(w61, prop[6], prop[5], prop[4], prop[3], prop[2], prop[1], gen[0]);
    and And62(w62, prop[6], prop[5], prop[4], prop[3], prop[2], gen[1]);
    and And63(w63, prop[6], prop[5], prop[4], prop[3], gen[2]);
    and And64(w64, prop[6], prop[5], prop[4], gen[3]);
    and And65(w65, prop[6], prop[5], gen[4]);
    and And66(w66, prop[6], gen[5]);
    or C6(C[6], gen[6], w6, w61, w62, w63, w64, w65, w66);

    wire w7, w71, w72, w73, w74, w75, w76, w77;
    and And7(w7, prop[7], prop[6], prop[5], prop[4], prop[3], prop[2], prop[1], prop[0], Cin);
    and And71(w71, prop[7], prop[6], prop[5], prop[4], prop[3], prop[2], prop[1], gen[0]);
    and And72(w72, prop[7], prop[6], prop[5], prop[4], prop[3], prop[2], gen[1]);
    and And73(w73, prop[7], prop[6], prop[5], prop[4], prop[3], gen[2]);
    and And74(w74, prop[7], prop[6], prop[5], prop[4], gen[3]);
    and And75(w75, prop[7], prop[6], prop[5], gen[4]);
    and And76(w76, prop[7], prop[6], gen[5]);
    and And77(w77, prop[7], gen[6]);
    or C7(C[7], gen[7], w7, w71, w72, w73, w74, w75, w76, w77);

    
    // OUTPUTS
    // Define SUM result
    xor S0(result[0], A[0], B[0], Cin);
    xor S1(result[1], A[1], B[1], C[0]);
    xor S2(result[2], A[2], B[2], C[1]);
    xor S3(result[3], A[3], B[3], C[2]);
    xor S4(result[4], A[4], B[4], C[3]);
    xor S5(result[5], A[5], B[5], C[4]);
    xor S6(result[6], A[6], B[6], C[5]);
    xor S7(result[7], A[7], B[7], C[6]);

    // Define bigP
    and propOut(bigP, prop[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    
    // Define bigG
    wire g0, g1, g2, g3, g4, g5, g6;
    and genOut0(g0, gen[0], prop[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and genOut1(g1, gen[1], prop[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and genOut2(g2, gen[2], prop[3], prop[4], prop[5], prop[6], prop[7]);
    and genOut3(g3, gen[3], prop[4], prop[5], prop[6], prop[7]);
    and genOut4(g4, gen[4], prop[5], prop[6], prop[7]);
    and genOut5(g5, gen[5], prop[6], prop[7]);
    and genOut6(g6, gen[6], prop[7]);
    or genOut(bigG, gen[7], g6, g5, g4, g3, g2, g1, g0);

    // Define Overflow
    xor Over(overflow, C[7], C[6]);

endmodule