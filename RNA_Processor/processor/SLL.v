module SLL(A, result, shiftamt);
    input [31:0] A;
    input [4:0] shiftamt;
    output [31:0] result;

    wire [31:0] w1, w2, w3, w4;
    wire [31:0] w5, w6, w7, w8, w9;

    SLL16 sl16(A, w5);
    // mux_2_32bits shiftL16(w1, shiftamt[4], A, w5);
    SLL8 sl8(w1, w6);
    // mux_2_32bits shiftL8(w2, shiftamt[3], w1, w6);
    SLL4 sl4(w2, w7);
    // mux_2_32bits shiftL4(w3, shiftamt[2], w2, w7);
    SLL2 sl2(w3, w8);
    // mux_2_32bits shiftL2(w4, shiftamt[1], w3, w8);
    SLL1 sl1(w4, w9);
    // mux_2_32bits shiftL1(result, shiftamt[0], w4, w9);

    mux_2_32bits shiftL16(w1, shiftamt[4], A, w5);
    mux_2_32bits shiftL8(w2, shiftamt[3], w1, w6);
    mux_2_32bits shiftL4(w3, shiftamt[2], w2, w7);
    mux_2_32bits shiftL2(w4, shiftamt[1], w3, w8);
    mux_2_32bits shiftL1(result, shiftamt[0], w4, w9);
endmodule