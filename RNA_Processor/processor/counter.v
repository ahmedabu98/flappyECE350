module counter(contrl_mult, clock, reset, mult_or_div, ready, WE);
    input contrl_mult, clock, reset, mult_or_div;
    output ready, WE;

    wire [34:0] cycle;

    dffe_ref cycle_ref(cycle[0], contrl_mult, clock, 1'b1, 1'b0);

    genvar i;
    generate
            for(i=1; i<35; i=i+1) begin: loop1
                dffe_ref cycles(cycle[i], cycle[i-1], clock, 1'b1, reset);
            end
    endgenerate

    assign ready = mult_or_div? cycle[32] : cycle[33]; // 32 for multiplication, 33 for division, UPDATE: now need 33 for both
    assign WE = mult_or_div? cycle[33] : cycle[34];
    // assign ready = cycle[33];
    // assign WE = cycle[33];
endmodule