module register(In, Out, ctrl_writeEnable, clock, clr);
    input [31:0] In;
    input ctrl_writeEnable, clock, clr;
    output [31:0] Out;

    // wire writeEnable;
    // and InAndClock(writeEnable, clock, ctrl_writeEnable);

    // // Writing to register
    // dffe_ref bit0(Out[0], In[0], clock, writeEnable, clr);
    // dffe_ref bit1(Out[1], In[1], clock, writeEnable, clr);
    // dffe_ref bit2(Out[2], In[2], clock, writeEnable, clr);
    // dffe_ref bit3(Out[3], In[3], clock, writeEnable, clr);
    // dffe_ref bit4(Out[4], In[4], clock, writeEnable, clr);
    // dffe_ref bit5(Out[5], In[5], clock, writeEnable, clr);
    // dffe_ref bit6(Out[6], In[6], clock, writeEnable, clr);
    // dffe_ref bit7(Out[7], In[7], clock, writeEnable, clr);
    // dffe_ref bit8(Out[8], In[8], clock, writeEnable, clr);
    // dffe_ref bit9(Out[9], In[9], clock, writeEnable, clr);
    // dffe_ref bit10(Out[10], In[10], clock, writeEnable, clr);
    // dffe_ref bit11(Out[11], In[11], clock, writeEnable, clr);
    // dffe_ref bit12(Out[12], In[12], clock, writeEnable, clr);
    // dffe_ref bit13(Out[13], In[13], clock, writeEnable, clr);
    // dffe_ref bit14(Out[14], In[14], clock, writeEnable, clr);
    // dffe_ref bit15(Out[15], In[15], clock, writeEnable, clr);
    // dffe_ref bit16(Out[16], In[16], clock, writeEnable, clr);
    // dffe_ref bit17(Out[17], In[17], clock, writeEnable, clr);
    // dffe_ref bit18(Out[18], In[18], clock, writeEnable, clr);
    // dffe_ref bit19(Out[19], In[19], clock, writeEnable, clr);
    // dffe_ref bit20(Out[20], In[20], clock, writeEnable, clr);
    // dffe_ref bit21(Out[21], In[21], clock, writeEnable, clr);
    // dffe_ref bit22(Out[22], In[22], clock, writeEnable, clr);
    // dffe_ref bit23(Out[23], In[23], clock, writeEnable, clr);
    // dffe_ref bit24(Out[24], In[24], clock, writeEnable, clr);
    // dffe_ref bit25(Out[25], In[25], clock, writeEnable, clr);
    // dffe_ref bit26(Out[26], In[26], clock, writeEnable, clr);
    // dffe_ref bit27(Out[27], In[27], clock, writeEnable, clr);
    // dffe_ref bit28(Out[28], In[28], clock, writeEnable, clr);
    // dffe_ref bit29(Out[29], In[29], clock, writeEnable, clr);
    // dffe_ref bit30(Out[30], In[30], clock, writeEnable, clr);
    // dffe_ref bit31(Out[31], In[31], clock, writeEnable, clr);

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin: loop1
            dffe_ref bit(Out[i], In[i], clock, ctrl_writeEnable, clr);
        end
    endgenerate


endmodule