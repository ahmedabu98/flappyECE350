module isCollided(
    // input x_square, 
    // input y_square, 
    // input col1x, 
    // input col1y, 
    // input col2x, 
    // input col2y, 
    // input col3x, 
    // input col3y, 
    // input col4x, 
    // input col4y, 
    // input col5x, 
    // input col5y, 
    // input col6x, 
    // input col6y, 
    input f,
    input c,
    output reg didCollide);

    always @(*) begin
        if(f&&c)
            didCollide = 1;
        else
            didCollide = 0;
    end
endmodule