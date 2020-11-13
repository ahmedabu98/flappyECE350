module control(product, operation, Cin);
    input [64:0] product;
    output Cin, operation;

    wire [1:0] LSB;

    assign LSB[1] = product[1];
    assign LSB[0] = product[0];
    xor op(operation, LSB[1], LSB[0]); // 0 if skip, 1 if add/sub
    and AddSub(Cin, operation, LSB[1]); // sets Cin for add or sub

endmodule