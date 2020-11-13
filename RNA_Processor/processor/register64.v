module register64(In, Out, ctrl_writeEnable, clock, clr);
    input [63:0] In;
    input ctrl_writeEnable, clock, clr;
    output [63:0] Out;

    wire writeEnable;
    // and InAndClock(writeEnable, clock, ctrl_writeEnable);
    /////// CHECKING

    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin: loop1
            // dffe_ref bit(Out[i], In[i], clock, writeEnable, clr);
            dffe_ref bit(Out[i], In[i], clock, ctrl_writeEnable, clr);
        end
    endgenerate
endmodule