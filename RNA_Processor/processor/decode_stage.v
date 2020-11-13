module decode_stage(Instruction, PC_updated, A, B, regA, regB, PC_branch, multdiv, isbranch, branch_taken);
    input [31:0] Instruction, PC_updated, A, B;
    output [31:0] PC_branch;
    output [4:0] regA, regB;
    output multdiv;
    output isbranch, branch_taken;

    wire [4:0] opcode, ALU_opcode, rstatus, regB1, j, bne, jal, jr, blt, bex, r31;
    assign opcode = Instruction[31:27];
    assign ALU_opcode = Instruction[6:2];
    assign rstatus = 5'd30;
    assign r31 = 5'd31;
    assign j = 5'b00001;
    assign bne = 5'b00010;
    assign jal = 5'b00011;
    assign jr = 5'b00100;
    assign blt = 5'b00110;
    assign bex = 5'b10110;
    

    // By design, assign rs to regA and rt/rd to regB
    // assign regA = (opcode == bex) ? rstatus : Instruction[21:17];
    assign regA = Instruction[21:17];
    assign regB1 = (opcode == 5'b0) ? Instruction[16:12] : Instruction[26:22];
    assign regB = (opcode == bex) ? rstatus : regB1;

    // MultDiv
    wire [4:0] mult, div;
    assign mult = 5'b00110;
    assign div = 5'b00111;
    assign multdiv = ((opcode == 5'b0) && ((ALU_opcode == mult) || (ALU_opcode == div))) ? 1'b1 : 1'b0;

    // Fast branches
    // Branch and jumps that modify PC, take everything into account except for blt (taken care of in execute stage)
    assign isbranch = (opcode == j) || (opcode == bne) || (opcode == jal) || (opcode == jr) || (opcode == bex);

    wire[31:0] Immediate, target, bne_blt_branch;
    wire ovf;
    sx16 imm_sx(Instruction[16:0], Immediate);
    adder32 PC_bne(PC_updated, Immediate, bne_blt_branch, 1'b0, ovf);
    
    assign target[26:0] = Instruction[26:0];
    assign target[31:27] = 5'b0;

    wire[31:0] PC_branch1;
    assign PC_branch1 = ((opcode == j) || (opcode == jal) || (opcode == bex)) ? target : B;
    assign PC_branch = (opcode == bne) ? bne_blt_branch : PC_branch1;

    assign branch_taken = (opcode == j) || ((opcode == bne) && (A != B)) || (opcode == jal) || (opcode == jr) || ((opcode == bex) && (B != 32'b0));

endmodule