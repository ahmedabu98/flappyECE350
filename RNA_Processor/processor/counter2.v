module counter2(clock, clr, mult_or_div, ready, WE, counter);
    input clock, clr, mult_or_div;
    output ready, WE;
    output [5:0] counter;

    wire [5:0] cycle, inv_cycle;
    
    not inv_cycle0(inv_cycle[0], cycle[0]);
    not inv_cycle1(inv_cycle[1], cycle[1]);
    not inv_cycle2(inv_cycle[2], cycle[2]);
    not inv_cycle3(inv_cycle[3], cycle[3]);
    not inv_cycle4(inv_cycle[4], cycle[4]);
    not inv_cycle5(inv_cycle[5], cycle[5]);


    dffe_ref bit0(cycle[0], inv_cycle[0], clock, 1'b1, clr);

    wire and1, and11, d1;
    and And1(and1, inv_cycle[1], cycle[0]);
    and And11(and11, cycle[1], inv_cycle[0]);
    or Or1(d1, and1, and11);
    dffe_ref bit1(cycle[1], d1, clock, 1'b1, clr);

    wire nand2, and2, and21, and22, d2;
    nand Nand2(nand2, cycle[1], cycle[0]);
    and And2(and2, nand2, cycle[2]);
    and And21(and21, cycle[1], cycle[0]);
    and And22(and22, and21, inv_cycle[2]);
    or Or2(d2, and2, and22);
    dffe_ref bit2(cycle[2], d2, clock, 1'b1, clr);

    wire nand3, and3, and31, and32, d3;
    nand Nand3(nand3, cycle[2], cycle[1], cycle[0]);
    and And3(and3, nand3, cycle[3]);
    and And31(and31, cycle[2], cycle[1], cycle[0]);
    and And32(and32, and31, inv_cycle[3]);
    or Or3(d3, and3, and32);
    dffe_ref bit3(cycle[3], d3, clock, 1'b1, clr);

    wire nand4, and4, and41, and42, d4;
    nand Nand4(nand4, cycle[3], cycle[2], cycle[1], cycle[0]);
    and And4(and4, nand4, cycle[4]);
    and And41(and41, cycle[3], cycle[2], cycle[1], cycle[0]);
    and And42(and42, and41, inv_cycle[4]);
    or Or4(d4, and4, and42);
    dffe_ref bit4(cycle[4], d4, clock, 1'b1, clr);

    wire nand5, and5, and51, and52, d5;
    nand Nand5(nand5, cycle[4], cycle[3], cycle[2], cycle[1], cycle[0]);
    and And5(and5, nand5, cycle[5]);
    and And51(and51, cycle[4], cycle[3], cycle[2], cycle[1], cycle[0]);
    and And52(and52, and51, inv_cycle[5]);
    or Or5(d5, and5, and52);
    dffe_ref bit5(cycle[5], d5, clock, 1'b1, clr);

    // need 33 cycles for division on tb (remember to clock registers on neg edge!)
    // need 33 cycles for multiplication tb (remember to clock registers on neg edge!)

    wire cycle33, cycle34, WEm, WEd;
    or flag33(cycle33, cycle[4], cycle[3], cycle[2], cycle[1], cycle[0]);
    and ready_flagM(WE, cycle[5], cycle33);

    assign ready = mult_or_div ? cycle[5] : cycle[5]; // & cycle[0];
   
    assign counter = cycle;
endmodule