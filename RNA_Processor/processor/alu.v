module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:
    wire [31:0] ADDop, SUBop, ANDop, ORop, SLLop, SRAop;
    wire [31:0] Bsub;
    wire CinADD, CinSUB;
    wire overADD, overSUB; // CoutADD, CoutSUB;
    wire isLessThanADD, isLessThanSUB, notEqualADD, notEqualSUB;

    // Check sign of A and B operands
    wire [1:0] check;
    assign check[1]=data_operandA[31];
    assign check[0]=data_operandB[31];
    
    // Check not equal condition and less than condition
    wire equal, GT, isLessThan0;
    bit32_comp comp(equal, GT, data_operandA, data_operandB);
    not NOTequal_noSign(isNotEqual, equal);

    nor notGT(isLessThan0, equal, GT);
    mux_4 LT(isLessThan, check, isLessThan0, 1'b0, 1'b1, isLessThan0);

    // ADD Operation
    assign CinADD = 1'b0;
    adder32 addition(data_operandA, data_operandB, ADDop, CinADD, overADD);

    // SUB Operation
    assign CinSUB = 1'b1;
    // sub Sub(data_operandB, Bsub);
    adder32 substraction(data_operandA, data_operandB, SUBop, CinSUB, overSUB);

    // AND Operation
    AND AndOperation(data_operandA, data_operandB, ANDop);

    // OR Operation
    OR OrOperation(data_operandA, data_operandB, ORop);

    // SLL Operation
    SLL SllOperation(data_operandA, SLLop, ctrl_shiftamt);
    // wire [31:0] check1;
    // mux_2_32bits checker(check1, 1'b1, SLLop, SLLop);

    // SRA Operation
    SRA SraOperation(data_operandA, SRAop, ctrl_shiftamt);

    // Mux with Opcode
    wire [31:0] in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;

    // Deafult state set to 0, obtained for opcode different from the ones provided
    assign in6 = 32'b0;
    assign in7 = 32'b0;
    assign in8 = 32'b0;
    assign in9 = 32'b0;
    assign in10 = 32'b0;
    assign in11 = 32'b0;
    assign in12 = 32'b0;
    assign in13 = 32'b0;
    assign in14 = 32'b0;
    assign in15 = 32'b0;
    assign in16 = 32'b0;
    assign in17 = 32'b0;
    assign in18 = 32'b0;
    assign in19 = 32'b0;
    assign in20 = 32'b0;
    assign in21 = 32'b0;
    assign in22 = 32'b0;
    assign in23 = 32'b0;
    assign in24 = 32'b0;
    assign in25 = 32'b0;
    assign in26 = 32'b0;
    assign in27 = 32'b0;
    assign in28 = 32'b0;
    assign in29 = 32'b0;
    assign in30 = 32'b0;
    assign in31 = 32'b0;

    // Outputs
    mux_32_32bits opcode(data_result, ctrl_ALUopcode, ADDop, SUBop, ANDop, ORop, SLLop, SRAop, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);
    
    mux_2 final_Overflow(overflow, ctrl_ALUopcode[0], overADD, overSUB);
endmodule