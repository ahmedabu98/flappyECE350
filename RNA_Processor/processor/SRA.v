module SRA(A, result, shiftamt);
    input [31:0] A;
    input [4:0] shiftamt;
    output [31:0] result;

    wire [31:0] w1, w2, w3, w4;
    wire [31:0] w5, w6, w7, w8, w9;

    SRA16 sr16(A, w5);
    mux_2_32bits shiftR16(w1, shiftamt[4], A, w5);

    SRA8 sr8(w1, w6);
    mux_2_32bits shiftR8(w2, shiftamt[3], w1, w6);

    SRA4 sr4(w2, w7); /////////////// ERROR HAPPENING AT THIS POINT BU CANT TELL WHY
    mux_2_32bits shiftR4(w3, shiftamt[2], w2, w7);

    SRA2 sr2(w3, w8);
    mux_2_32bits shiftR2(w4, shiftamt[1], w3, w8);

    SRA1 sr1(w4, w9);
    mux_2_32bits shiftR1(result, shiftamt[0], w4, w9);

/*     mux_2_32bits shiftR16(w1, shiftamt[4], A, w5);
    mux_2_32bits shiftR8(w2, shiftamt[3], w1, w6);
    mux_2_32bits shiftR4(w3, shiftamt[2], w2, w7);
    mux_2_32bits shiftR2(w4, shiftamt[1], w3, w8);
    mux_2_32bits shiftR1(result, shiftamt[0], w4, w9); */
endmodule