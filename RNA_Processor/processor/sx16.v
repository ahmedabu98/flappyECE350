module sx16(In, Out);
    input [16:0] In;
    output [31:0] Out;

    assign Out[16:0] = In;

    genvar i;
    generate
        for (i=17; i<32; i=i+1) begin: loop1
            assign Out[i] = In[16];
        end
    endgenerate
endmodule