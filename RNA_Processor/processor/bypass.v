module bypass(InstrFD, InstrDX, InstrXM, InstrMW, regAdx, OpXM, WB, Bxm, regBdx, ALUinA, ALUinB, dataMem, A_decode, B_decode, A, B, opALU, PC_dx, PC_xm, PC_mw, WE_wb);
    input[31:0] InstrFD, InstrDX, InstrXM, InstrMW, regAdx, OpXM, WB, Bxm, regBdx, A, B, opALU, PC_dx, PC_xm, PC_mw;
    input WE_wb;
    output[31:0] ALUinA, ALUinB, dataMem, A_decode, B_decode;

    wire[4:0] sw, lw;
    assign sw = 5'b00111;
    assign lw = 5'b01000;

    // ALUinA bypassing
    wire[31:0] intermA, intermA1, intermA2;

    // assign intermA = (InstrDX[21:17] == InstrXM[26:22]) ? OpXM : regAdx;
    // assign intermA1 = (InstrDX[21:17] == InstrMW[26:22]) ? WB : intermA;
    // assign ALUinA = ((InstrDX[21:17] == InstrMW[26:22]) && (InstrDX[21:17] == 5'b0)) ? 32'b0 : intermA1;

    assign intermA = (InstrDX[21:17] == InstrMW[26:22]) ? WB : regAdx;
    assign intermA1 = ((InstrDX[21:17] == InstrMW[26:22]) && (InstrDX[21:17] == 5'b0)) ? 32'b0 : intermA;
    assign intermA2 = ((InstrDX[21:17] == InstrXM[26:22])) ? OpXM: intermA1;
    assign ALUinA = ((InstrDX[21:17] == InstrXM[26:22]) && (InstrDX[21:17] == 5'b0)) ? 32'b0 : intermA1;

    // ALUinB bypassing
    wire[31:0] intermB, intermB1, intermB2;

    // assign intermB = (InstrDX[16:12] == InstrXM[26:22]) ? OpXM : regBdx;
    // assign intermB1 = (InstrDX[16:12] == InstrMW[26:22]) ? WB : intermB;
    // assign ALUinB = ((InstrDX[16:12] == InstrMW[26:22]) && (InstrDX[16:12] == 5'b0)) ? 32'b0 : intermB1;

    assign intermB = ((InstrDX[16:12] == InstrMW[26:22]) || ((InstrDX[31:27] == sw) && (InstrDX[26:22] == InstrMW[26:22]))) ? WB : regBdx;
    assign intermB1 = ((InstrDX[16:12] == InstrMW[26:22]) && (InstrDX[16:12] == 5'b0)) ? 32'b0 : intermB;
    assign intermB2 = (InstrDX[16:12] == InstrXM[26:22]) ? OpXM : intermB1;
    assign ALUinB = ((InstrDX[16:12] == InstrXM[26:22]) && (InstrDX[16:12] == 5'b0)) ? 32'b0 : intermB2;


    // WM bypassing
    wire [4:0] opcodeD, rstatus, r31, bne, jal, jr, bex, setx;
    wire[31:0] bypassD_A, bypassD_A1, bypassD_A2, bypassD_B, bypassD_B1, bypassD_B2, bypassD_B3, bypassD_B4, bypassD_B5, bypassD_B6, bypassD_B7, bypassD_B8;
    assign opcodeD = InstrFD[31:27];
    assign rstatus = 5'd30;
    assign r31 = 5'd31;
    assign bne = 5'b00010;
    assign jal = 5'b00011;
    assign jr = 5'b00100;
    assign bex = 5'b10110;
    assign setx = 5'b10101;


    // assign dataMem = ((WE_wb && (InstrXM[31:27] == sw) && (InstrMW[26:22] == InstrXM[26:22])) || ((InstrXM[31:27] == 5'b00011) && ((InstrMW[26:22] == 5'd31)))) ? WB : Bxm;
    wire[31:0] dataMem1;
    wire write, equalRDs;
    assign writes = (InstrMW[31:27] == 5'd0) || (InstrMW[31:27] == 5'd5) || (InstrMW[31:27] == lw) || (InstrMW[31:27] == setx);
    assign equalRDs = (InstrMW[26:22] == InstrXM[26:22]);
    assign dataMem1 = ((writes && equalRDs) || ((InstrMW[31:27] == 5'd3) && (InstrMW[26:22] == 5'd31))) ? WB : Bxm;
    assign dataMem = (writes && equalRDs && (InstrXM[26:22] == 5'b0)) ? 32'b0 : dataMem1;

    // assign MWinsnUsesRD = (opcode_w == 5'd0 || opcode_w == 5'd5 || opcode_w == 5'd8 || opcode_w == 5'd21);
    //                 //     R instruction        addi                lw                     setx
    // assign eqaul_rds = mwIROut[26:22] == xmIROut[26:22];
    // assign data = ((MWinsnUsesRD && equal_rds) || (opcode_w == 5'd3 && xmIROut[26:22] == 5'd31))? dataWriteBack: xmBout;



    // Bypass into decode
    // From Writeback
    

    wire[31:0] targetDX, targetXM, targetMW;
    assign targetDX[26:0] = InstrDX[26:0];
    assign targetDX[31:27] = 5'b0;
    assign targetXM[26:0] = InstrXM[26:0];
    assign targetXM[31:27] = 5'b0;
    assign targetMW[26:0] = InstrMW[26:0];
    assign targetMW[31:27] = 5'b0;

    wire isbranch;
    assign isbranch = (opcodeD == bne) || (opcodeD == jr) || (opcodeD == bex);

    assign bypassD_A = (InstrFD[21:17] == InstrMW[26:22]) ? WB : A;
    assign bypassD_A1 = (InstrFD[21:17] == InstrXM[26:22]) ? OpXM : bypassD_A;
    assign bypassD_A2 = (InstrFD[21:17] == InstrDX[26:22]) ? opALU : bypassD_A1;
    assign A_decode = (InstrFD[21:17] == 5'b0) ? 32'b0 : bypassD_A2;


    assign bypassD_B = (isbranch && (InstrFD[26:22] == InstrMW[26:22])) ? WB : B;
    assign bypassD_B1 = (isbranch && (InstrFD[26:22] == InstrXM[26:22])) ? OpXM : bypassD_B;
    assign bypassD_B2 = (isbranch && (InstrFD[26:22] == InstrDX[26:22])) ? opALU : bypassD_B1;
    assign bypassD_B8 = (isbranch && (InstrFD[26:22] == 5'b0)) ? 32'b0 : bypassD_B2;
    
    assign bypassD_B3 = ((InstrMW[31:27] == jal) && (InstrFD[26:22] == r31)) ? PC_mw : bypassD_B8;
    assign bypassD_B4 = ((InstrXM[31:27] == jal) && (InstrFD[26:22] == r31)) ? PC_xm : bypassD_B3;
    assign bypassD_B5 = ((InstrDX[31:27] == jal) && (InstrFD[26:22] == r31)) ? PC_dx : bypassD_B4;
    
    assign bypassD_B6 = ((InstrMW[31:27] == setx) && (InstrFD[26:22] == rstatus)) ? targetMW : bypassD_B5;
    assign bypassD_B7 = ((InstrXM[31:27] == setx) && (InstrFD[26:22] == rstatus)) ? targetXM : bypassD_B6;
    assign B_decode = ((InstrDX[31:27] == setx) && (InstrFD[26:22] == rstatus)) ? targetDX : bypassD_B7;
    
endmodule