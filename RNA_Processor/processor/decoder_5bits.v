module decoder_5bits(opcode, out);
    input [4:0] opcode;
    output [31:0] out;

    wire in0, in1, in2, in3, in4;
    wire not0, not1, not2, not3, not4;

    assign in0 = opcode[0];
    assign in1 = opcode[1];
    assign in2 = opcode[2];
    assign in3 = opcode[3];
    assign in4 = opcode[4];

    not Not0(not0, opcode[0]);
    not Not1(not1, opcode[1]);
    not Not2(not2, opcode[2]);
    not Not3(not3, opcode[3]);
    not Not4(not4, opcode[4]);

    and Out0(out[0], not4, not3, not2, not1, not0);
    and Out1(out[1], not4, not3, not2, not1, in0);
    and Out2(out[2], not4, not3, not2, in1, not0);
    and Out3(out[3], not4, not3, not2, in1, in0);
    and Out4(out[4], not4, not3, in2, not1, not0);
    and Out5(out[5], not4, not3, in2, not1, in0);
    and Out6(out[6], not4, not3, in2, in1, not0);
    and Out7(out[7], not4, not3, in2, in1, in0);
    and Out8(out[8], not4, in3, not2, not1, not0);
    and Out9(out[9], not4, in3, not2, not1, in0);
    and Out10(out[10], not4, in3, not2, in1, not0);
    and Out11(out[11], not4, in3, not2, in1, in0);
    and Out12(out[12], not4, in3, in2, not1, not0);
    and Out13(out[13], not4, in3, in2, not1, in0);
    and Out14(out[14], not4, in3, in2, in1, not0);
    and Out15(out[15], not4, in3, in2, in1, in0);
    and Out16(out[16], in4, not3, not2, not1, not0);
    and Out17(out[17], in4, not3, not2, not1, in0);
    and Out18(out[18], in4, not3, not2, in1, not0);
    and Out19(out[19], in4, not3, not2, in1, in0);
    and Out20(out[20], in4, not3, in2, not1, not0);
    and Out21(out[21], in4, not3, in2, not1, in0);
    and Out22(out[22], in4, not3, in2, in1, not0);
    and Out23(out[23], in4, not3, in2, in1, in0);
    and Out24(out[24], in4, in3, not2, not1, not0);
    and Out25(out[25], in4, in3, not2, not1, in0);
    and Out26(out[26], in4, in3, not2, in1, not0);
    and Out27(out[27], in4, in3, not2, in1, in0);
    and Out28(out[28], in4, in3, in2, not1, not0);
    and Out29(out[29], in4, in3, in2, not1, in0);
    and Out30(out[30], in4, in3, in2, in1, not0);
    and Out31(out[31], in4, in3, in2, in1, in0);

endmodule