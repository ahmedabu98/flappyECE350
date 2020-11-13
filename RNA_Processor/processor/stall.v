module stall(InstrDX, InstrFD, stall);
    input[31:0] InstrDX, InstrFD;
    output stall;

    wire[4:0] sw, lw;
    assign sw = 5'b00111;
    assign lw = 5'b01000;

    assign stall = (InstrDX[31:27] == lw) && ((InstrFD[21:17] == InstrDX[26:22]) || ((InstrFD[16:12] == InstrDX[26:22]) && (InstrFD[31:27] != sw)));
endmodule