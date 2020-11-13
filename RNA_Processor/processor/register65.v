module register65(In, Out, ctrl_writeEnable, clock, clr);
    input [64:0] In;
    input ctrl_writeEnable, clock, clr;
    output [64:0] Out;

    wire writeEnable;
    // and InAndClock(writeEnable, clock, ctrl_writeEnable);
    /////// CHECKING

    genvar i;
    generate
        for (i=0; i<65; i=i+1) begin: loop1
            // dffe_ref bit(Out[i], In[i], clock, writeEnable, clr);
            dffe_ref bit(Out[i], In[i], clock, ctrl_writeEnable, clr);
        end
    endgenerate
endmodule