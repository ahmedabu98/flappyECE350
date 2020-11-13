module writeback_stage(Instruction, Instruction_MultDiv, PC_updated, Operation, Data, multdiv_result, mult_or_div, mult_ready, writeback, ctrl_writeEnable, ctrl_writeReg);
    input [31:0] Instruction, Instruction_MultDiv, PC_updated, Operation, Data, multdiv_result;
    input mult_or_div, mult_ready;
    output [31:0] writeback;
    output [4:0] ctrl_writeReg;
    output ctrl_writeEnable;

    wire[4:0] lw, addi, ALU, setx, jal;
    assign lw = 5'b01000;
    assign ALU = 5'b00000;
    assign addi = 5'b00101;
    assign setx = 5'b10101;
    assign jal = 5'b00011;

    wire[31:0] writeback1, writeback2, writeback3, Instruction_used, target;
    wire [4:0] ctrl_writeReg1, rstatus, r31;
    assign rstatus = 5'd30;
    assign r31 = 5'd31;
    
    assign Instruction_used = (mult_or_div && mult_ready) ? Instruction_MultDiv : Instruction;
    assign target[26:0] = Instruction_used[26:0];
    assign target[31:27] = 5'b0;

    assign writeback1 = (Instruction_used[31:27] == lw) ? Data : Operation;
    assign writeback2 = (mult_or_div && mult_ready) ? multdiv_result : writeback1;
    assign writeback3 = (Instruction_used[31:27] == setx) ? target : writeback2;
    assign writeback = (Instruction_used[31:27] == jal) ? PC_updated : writeback3;

    assign ctrl_writeEnable = ((Instruction_used[31:27] == lw) || (Instruction_used[31:27] == addi) || (Instruction_used[31:27] == ALU) || (Instruction_used[31:27] == setx) || (Instruction_used[31:27] == jal)) ? 1'b1 : 1'b0;
    
    assign ctrl_writeReg1 = (Instruction_used[31:27] == setx) ? rstatus : Instruction_used[26:22];
    assign ctrl_writeReg = (Instruction_used[31:27] == jal) ? r31 : ctrl_writeReg1;
    
endmodule