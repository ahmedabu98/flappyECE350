module counter3(start, clock, ready, WE);
    input start, clock;
    output ready, WE;

    wire [31:0] cycle, reg_input, next_cycle, added;
    wire ovf;

    assign reg_input = start ? 32'b0 : added;

    register32 cycles(reg_input, cycle, 1'b1, clock, 1'b0);
    adder32 cycle_next(cycle, 32'b1, added, 1'b0, ovf);

    assign ready = cycle[5] & cycle[0];
    assign WE = cycle[5] & (cycle[4] || cycle[3] || cycle[2] || cycle[1] || cycle[0]);

endmodule