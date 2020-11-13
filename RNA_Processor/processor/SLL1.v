module SLL1(In, Out);

    input [31:0] In;
    output [31:0] Out;

    assign Out[0] = 1'b0;

    genvar i;
    generate
        for (i=1; i<32; i=i+1) begin: loop1
            assign Out[i] = In[i-1];
        end
    endgenerate

endmodule