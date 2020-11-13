module adder32(A, Bin, result, Cin, overflow);
    input [31:0] A, Bin;
    input Cin;
    output [31:0] result;
    output overflow;
    wire Cout;
    wire [31:0] Bsub, B;

    sub Binterm(Bin, Bsub);
    assign B = Cin ? Bsub : Bin;

    wire CinS1, CinS2, CinS3;
    wire ov0, ov1, ov2, ov3;
    wire P0, G0, P1, G1, P2, G2, P3, G3;   

    adder8 S0(A[7:0], B[7:0], Cin, result[7:0], ov0, P0, G0);
    wire w00;
    and PropS00(w00, P0, Cin);
    or cinS1(CinS1, G0, w00);

    adder8 S1(A[15:8], B[15:8], CinS1, result[15:8], ov1, P1, G1);
    wire w11, w12;
    and  PropS11(w11, P1, P0, Cin);
    and PropS12(w12, P1, G0);
    or cinS2(CinS2, G1, w11, w12);

    adder8 S2(A[23:16], B[23:16], CinS2, result[23:16], ov2, P2, G2);
    wire w21, w22, w23;
    and  PropS21(w21, P2, P1, P0, Cin);
    and PropS22(w22, P2, P1, G0);
    and PropS23(w23, P2, G1);
    or cinS3(CinS3, G2, w21, w22, w23);


    adder8 S3(A[31:24], B[31:24], CinS3, result[31:24], ov3, P3, G3);
    wire w31, w32, w33, w34;
    and  PropS31(w31, P3, P2, P1, P0, Cin);
    and PropS32(w32, P3, P2, P1, G0);
    and PropS33(w33, P3, P2, G1);
    and PropS34(w34, P3, G2);
    or cinS4(Cout, G3, w31, w32, w33, w34);

    assign overflow = ov3;
endmodule