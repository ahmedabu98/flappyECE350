module regfile(
    clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
    data_readRegB, counter
);
    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;

    output [31:0] data_readRegA, data_readRegB, counter;

    // Decode opcodes
    wire [31:0] regA, regB, writeReg;
    decoder_5bits Areg(ctrl_readRegA, regA);
    decoder_5bits Breg(ctrl_readRegB, regB);
    decoder_5bits writeRegister(ctrl_writeReg, writeReg);

    // Initialization of registers?
    // Register 0 value always 32'b0
    wire [31:0] Out0, Out1;
    register register0(32'b0, Out0, 1'b0, clock, ctrl_reset);
    triStateBuff_32 A0(Out0, regA[0], data_readRegA);
    triStateBuff_32 B0(Out0, regB[0], data_readRegB);

    and writeEnableReg1(write_enable[1], ctrl_writeEnable, writeReg[1]);
    register register1(data_writeReg, Out1, write_enable[1], clock, ctrl_reset);
    triStateBuff_32 A1(Out1, regA[1], data_readRegA);
    triStateBuff_32 B1(Out1, regB[1], data_readRegB);
    assign counter = Out1;

    

    wire [31:0] write_enable;
    genvar i;
    generate
        for (i=2; i<32; i=i+1) begin: loop1
            wire[31:0] Out;
            and writeEnable(write_enable[i], ctrl_writeEnable, writeReg[i]);
            register register(data_writeReg, Out, write_enable[i], clock, ctrl_reset);
            triStateBuff_32 A(Out, regA[i], data_readRegA);
            triStateBuff_32 B(Out, regB[i], data_readRegB);
        end
    endgenerate

    // wire [31:0] write_enable;
    // and writeEnable0(write_enable[0], ctrl_writeEnable, writeReg[0]);
    // and writeEnable1(write_enable[1], ctrl_writeEnable, writeReg[1]);
    // and writeEnable2(write_enable[2], ctrl_writeEnable, writeReg[2]);
    // and writeEnable3(write_enable[3], ctrl_writeEnable, writeReg[3]);
    // and writeEnable4(write_enable[4], ctrl_writeEnable, writeReg[4]);
    // and writeEnable5(write_enable[5], ctrl_writeEnable, writeReg[5]);
    // and writeEnable6(write_enable[6], ctrl_writeEnable, writeReg[6]);
    // and writeEnable7(write_enable[7], ctrl_writeEnable, writeReg[7]);
    // and writeEnable8(write_enable[8], ctrl_writeEnable, writeReg[8]);
    // and writeEnable9(write_enable[9], ctrl_writeEnable, writeReg[9]);
    // and writeEnable10(write_enable[10], ctrl_writeEnable, writeReg[10]);
    // and writeEnable11(write_enable[11], ctrl_writeEnable, writeReg[11]);
    // and writeEnable12(write_enable[12], ctrl_writeEnable, writeReg[12]);
    // and writeEnable13(write_enable[13], ctrl_writeEnable, writeReg[13]);
    // and writeEnable14(write_enable[14], ctrl_writeEnable, writeReg[14]);
    // and writeEnable15(write_enable[15], ctrl_writeEnable, writeReg[15]);
    // and writeEnable16(write_enable[16], ctrl_writeEnable, writeReg[16]);
    // and writeEnable17(write_enable[17], ctrl_writeEnable, writeReg[17]);
    // and writeEnable18(write_enable[18], ctrl_writeEnable, writeReg[18]);
    // and writeEnable19(write_enable[19], ctrl_writeEnable, writeReg[19]);
    // and writeEnable20(write_enable[20], ctrl_writeEnable, writeReg[20]);
    // and writeEnable21(write_enable[21], ctrl_writeEnable, writeReg[21]);
    // and writeEnable22(write_enable[22], ctrl_writeEnable, writeReg[22]);
    // and writeEnable23(write_enable[23], ctrl_writeEnable, writeReg[23]);
    // and writeEnable24(write_enable[24], ctrl_writeEnable, writeReg[24]);
    // and writeEnable25(write_enable[25], ctrl_writeEnable, writeReg[25]);
    // and writeEnable26(write_enable[26], ctrl_writeEnable, writeReg[26]);
    // and writeEnable27(write_enable[27], ctrl_writeEnable, writeReg[27]);
    // and writeEnable28(write_enable[28], ctrl_writeEnable, writeReg[28]);
    // and writeEnable29(write_enable[29], ctrl_writeEnable, writeReg[29]);
    // and writeEnable30(write_enable[30], ctrl_writeEnable, writeReg[30]);
    // and writeEnable31(write_enable[31], ctrl_writeEnable, writeReg[31]);
    
    // wire [31:0] Out0, Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9, Out10, Out11, Out12, Out13, Out14, Out15, Out16, Out17, Out18, Out19, Out20, Out21, Out22, Out23, Out24, Out25, Out26, Out27, Out28, Out29, Out30, Out31;

    // register register0(32'b0, Out0, 1'b0, clock, ctrl_reset);
    // register register1(data_writeReg, Out1, ctrl_writeEnable, clock, ctrl_reset);
    // register register2(data_writeReg, Out2, ctrl_writeEnable, clock, ctrl_reset);
    // register register3(data_writeReg, Out3, ctrl_writeEnable, clock, ctrl_reset);
    // register register4(data_writeReg, Out4, ctrl_writeEnable, clock, ctrl_reset);
    // register register5(data_writeReg, Out5, ctrl_writeEnable, clock, ctrl_reset);
    // register register6(data_writeReg, Out6, ctrl_writeEnable, clock, ctrl_reset);
    // register register7(data_writeReg, Out7, ctrl_writeEnable, clock, ctrl_reset);
    // register register8(data_writeReg, Out8, ctrl_writeEnable, clock, ctrl_reset);
    // register register9(data_writeReg, Out9, ctrl_writeEnable, clock, ctrl_reset);
    // register register10(data_writeReg, Out10, ctrl_writeEnable, clock, ctrl_reset);
    // register register11(data_writeReg, Out11, ctrl_writeEnable, clock, ctrl_reset);
    // register register12(data_writeReg, Out12, ctrl_writeEnable, clock, ctrl_reset);
    // register register13(data_writeReg, Out13, ctrl_writeEnable, clock, ctrl_reset);
    // register register14(data_writeReg, Out14, ctrl_writeEnable, clock, ctrl_reset);
    // register register15(data_writeReg, Out15, ctrl_writeEnable, clock, ctrl_reset);
    // register register16(data_writeReg, Out16, ctrl_writeEnable, clock, ctrl_reset);
    // register register17(data_writeReg, Out17, ctrl_writeEnable, clock, ctrl_reset);
    // register register18(data_writeReg, Out18, ctrl_writeEnable, clock, ctrl_reset);
    // register register19(data_writeReg, Out19, ctrl_writeEnable, clock, ctrl_reset);
    // register register20(data_writeReg, Out20, ctrl_writeEnable, clock, ctrl_reset);
    // register register21(data_writeReg, Out21, ctrl_writeEnable, clock, ctrl_reset);
    // register register22(data_writeReg, Out22, ctrl_writeEnable, clock, ctrl_reset);
    // register register23(data_writeReg, Out23, wctrl_writeEnable, clock, ctrl_reset);
    // register register24(data_writeReg, Out24, ctrl_writeEnable, clock, ctrl_reset);
    // register register25(data_writeReg, Out25, ctrl_writeEnable, clock, ctrl_reset);
    // register register26(data_writeReg, Out26, ctrl_writeEnable, clock, ctrl_reset);
    // register register27(data_writeReg, Out27, ctrl_writeEnable, clock, ctrl_reset);
    // register register28(data_writeReg, Out28, ctrl_writeEnable, clock, ctrl_reset);
    // register register29(data_writeReg, Out29, ctrl_writeEnable, clock, ctrl_reset);
    // register register30(data_writeReg, Out30, ctrl_writeEnable, clock, ctrl_reset);
    // register register31(data_writeReg, Out31, ctrl_writeEnable, clock, ctrl_reset);

    // triStateBuff_32 A0(Out0, regA[0], data_readRegA);
    // triStateBuff_32 A1(Out1, regA[1], data_readRegA);
    // triStateBuff_32 A2(Out2, regA[2], data_readRegA);
    // triStateBuff_32 A3(Out3, regA[3], data_readRegA);
    // triStateBuff_32 A4(Out4, regA[4], data_readRegA);
    // triStateBuff_32 A5(Out5, regA[5], data_readRegA);
    // triStateBuff_32 A6(Out6, regA[6], data_readRegA);
    // triStateBuff_32 A7(Out7, regA[7], data_readRegA);
    // triStateBuff_32 A8(Out8, regA[8], data_readRegA);
    // triStateBuff_32 A9(Out9, regA[9], data_readRegA);
    // triStateBuff_32 A10(Out10, regA[10], data_readRegA);
    // triStateBuff_32 A11(Out11, regA[11], data_readRegA);
    // triStateBuff_32 A12(Out12, regA[12], data_readRegA);
    // triStateBuff_32 A13(Out13, regA[13], data_readRegA);
    // triStateBuff_32 A14(Out14, regA[14], data_readRegA);
    // triStateBuff_32 A15(Out15, regA[15], data_readRegA);
    // triStateBuff_32 A16(Out16, regA[16], data_readRegA);
    // triStateBuff_32 A17(Out17, regA[17], data_readRegA);
    // triStateBuff_32 A18(Out18, regA[18], data_readRegA);
    // triStateBuff_32 A19(Out19, regA[19], data_readRegA);
    // triStateBuff_32 A20(Out20, regA[20], data_readRegA);
    // triStateBuff_32 A21(Out21, regA[21], data_readRegA);
    // triStateBuff_32 A22(Out22, regA[22], data_readRegA);
    // triStateBuff_32 A23(Out23, regA[23], data_readRegA);
    // triStateBuff_32 A24(Out24, regA[24], data_readRegA);
    // triStateBuff_32 A25(Out25, regA[25], data_readRegA);
    // triStateBuff_32 A26(Out26, regA[26], data_readRegA);
    // triStateBuff_32 A27(Out27, regA[27], data_readRegA);
    // triStateBuff_32 A28(Out28, regA[28], data_readRegA);
    // triStateBuff_32 A29(Out29, regA[29], data_readRegA);
    // triStateBuff_32 A30(Out30, regA[30], data_readRegA);
    // triStateBuff_32 A31(Out31, regA[31], data_readRegA);

    // triStateBuff_32 B0(Out0, regB[0], data_readRegB);
    // triStateBuff_32 B1(Out1, regB[1], data_readRegB);
    // triStateBuff_32 B2(Out2, regB[2], data_readRegB);
    // triStateBuff_32 B3(Out3, regB[3], data_readRegB);
    // triStateBuff_32 B4(Out4, regB[4], data_readRegB);
    // triStateBuff_32 B5(Out5, regB[5], data_readRegB);
    // triStateBuff_32 B6(Out6, regB[6], data_readRegB);
    // triStateBuff_32 B7(Out7, regB[7], data_readRegB);
    // triStateBuff_32 B8(Out8, regB[8], data_readRegB);
    // triStateBuff_32 B9(Out9, regB[9], data_readRegB);
    // triStateBuff_32 B10(Out10, regB[10], data_readRegB);
    // triStateBuff_32 B11(Out11, regB[11], data_readRegB);
    // triStateBuff_32 B12(Out12, regB[12], data_readRegB);
    // triStateBuff_32 B13(Out13, regB[13], data_readRegB);
    // triStateBuff_32 B14(Out14, regB[14], data_readRegB);
    // triStateBuff_32 B15(Out15, regB[15], data_readRegB);
    // triStateBuff_32 B16(Out16, regB[16], data_readRegB);
    // triStateBuff_32 B17(Out17, regB[17], data_readRegB);
    // triStateBuff_32 B18(Out18, regB[18], data_readRegB);
    // triStateBuff_32 B19(Out19, regB[19], data_readRegB);
    // triStateBuff_32 B20(Out20, regB[20], data_readRegB);
    // triStateBuff_32 B21(Out21, regB[21], data_readRegB);
    // triStateBuff_32 B22(Out22, regB[22], data_readRegB);
    // triStateBuff_32 B23(Out23, regB[23], data_readRegB);
    // triStateBuff_32 B24(Out24, regB[24], data_readRegB);
    // triStateBuff_32 B25(Out25, regB[25], data_readRegB);
    // triStateBuff_32 B26(Out26, regB[26], data_readRegB);
    // triStateBuff_32 B27(Out27, regB[27], data_readRegB);
    // triStateBuff_32 B28(Out28, regB[28], data_readRegB);
    // triStateBuff_32 B29(Out29, regB[29], data_readRegB);
    // triStateBuff_32 B30(Out30, regB[30], data_readRegB);
    // triStateBuff_32 B31(Out31, regB[31], data_readRegB);

endmodule