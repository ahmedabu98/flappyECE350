/* module two_bit_comp(Eq_i, Gt_i, A, B, Eq_ip1, Gt_ip1);
    input [1:0] A, B;
    input Eq_ip1, Gt_ip1;
    output Eq_i, Gt_i;
    wire [2:0] select;
    wire w2, w3;
    wire i0, i1, i2, i3, i4, i5, i6, i7;
    wire i8, i9, i10, i11, i12, i13, i14, i15;
    wire Gt_not, B0_not, Eq_not;
    assign select[2:1]=A;
    assign select[0]=B[1];

    // Define the complements
    not(Gt_not, Gt_ip1);
    not(B0_not, B[0]);
    not(Eq_not, Eq_ip1);

    // Mux for EQ(i)
    and(i0, Eq_ip1, Gt_not, B0_not);
    assign i1 = 1'b0;
    and(i2, Eq_ip1, Gt_not, B[0]);
    assign i3 = 1'b0;
    assign i4 = 1'b0;
    and(i5, Eq_ip1, Gt_not, B0_not);
    assign i6 = 1'b0;
    and(i7, Eq_ip1, Gt_not, B[0]);

    mux_8 eq_i(Eq_i, select[2:0], i0, i1, i2, i3, i4, i5, i6, i7);

    // Mux for GT(i)
    assign i8 = 1'b0;
    assign i9 = 1'b0;
    and(i10, Eq_ip1, Gt_not, B0_not);
    assign i11 = 1'b0;
    and(i12, Eq_ip1, Gt_not);
    assign i13 = 1'b0;
    and(i14, Eq_ip1, Gt_not);
    and(i15, Eq_ip1, Gt_not, B0_not);

    mux_8 gt_mux(w2, select[2:0], i8, i9, i10, i11, i12, i13, i14, i15);

    and(w3, E_not, Gt_ip1);

    or(Gt_i, w2, w3);
endmodule */

module two_bit_comp(EQ, GT, A, B, EQprev, GTprev);

	input [1:0] A, B;
	input EQprev, GTprev;
	output EQ, GT;
	wire[2:0] select;
	assign select[2:1] = A;
	assign select[0] = B[1];

	wire nB0, w1, w2, w3, w4, nGTprev, nEQprev;
/*     wire [1:0] check;
    assign check[1]=A[1];
    assign check[0]=B[1];
    wire checkSign, GTnoSign; */

	not n1(nGTprev, GTprev);
	not n2(nEQprev, EQprev);
	not n3(nB0, B[0]);

	mux_8 EQcombs(w1, select, nB0, 1'b0, B[0], 1'b0, 1'b0, nB0, 1'b0, B[0]);
	mux_8 GTcombs(w2, select, 1'b0, 1'b0, nB0, 1'b0, 1'b1, 1'b0, 1'b1, nB0);
	// EQ
	and EQoutput(EQ, EQprev, nGTprev, w1);

	// GT
	and a1(w3, EQprev, nGTprev, w2);
	and a2(w4, nEQprev, GTprev);
    // mux_4 GTcheck(checkSign, check, 1'b0, 1'b1, 1'b0, 1'b0);
	// or GToutNoSign(GTnoSign, w3, w4);
    // mux_2 GToutput(GT, checkSign, GTnoSign, checkSign);
    or GToutput(GT, w3, w4);
endmodule