module execute_stage_ALU(Instruction, A, B, PC_updated, op, Instr_Out, clock, isBLT, blt_taken, blt_branch);

    input [31:0] Instruction, A, B, PC_updated;
    output [31:0] op, Instr_Out, blt_branch;
    input clock;
    output isBLT, blt_taken;

    wire isNotEqualX, isLessThanX, overflowX;
    wire [4:0] opcode, ALU_opcode, ALU_opcode_in, shamt, setx, addi, blt, sw, lw;
    wire [31:0] Immediate, ALU_Bin, ALU_Bin1, op_ALU, op_MultDiv;

    assign opcode = Instruction[31:27];
    assign ALU_opcode = Instruction[6:2];
    assign shamt = Instruction[11:7];

    assign blt = 5'b00110;
    assign setx = 5'b10101;
    assign addi = 5'b00101;
    assign isBLT = (opcode == blt);
    assign sw = 5'b00111;
    assign lw = 5'b01000;

    wire[31:0] target;
    assign target[31:5] = Instruction[26:0];
    assign target[4:0] = 5'b0;

    sx16 imm_sx(Instruction[16:0], Immediate);

    // ALU
    assign ALU_Bin = ((opcode == 5'b0) || isBLT) ? B : Immediate;
    assign ALU_opcode_in = ((opcode == addi) || (opcode == lw) || (opcode == sw))  ? 5'b0 : ALU_opcode;

    wire[31:0] opALU;
    alu op_execute(A, ALU_Bin, ALU_opcode_in, shamt, opALU, isNotEqualX, isLessThanX, overflowX);

    wire[31:0] new_Instr, new_Instr_ALU, add_ovf, sub_ovf, addi_ovf;

    assign add_ovf = 32'b10101000000000000000000000000001;
    assign sub_ovf = 32'b10101000000000000000000000000011;
    assign addi_ovf = 32'b10101000000000000000000000000010;

    assign new_Instr_ALU = ALU_opcode[0] ? sub_ovf : add_ovf;
    assign new_Instr = (opcode == 5'b00101) ? addi_ovf : new_Instr_ALU;

    assign Instr_Out = overflowX ? new_Instr : Instruction;

    wire[31:0] res_interm, new_res;
    assign res_interm = ALU_opcode[0] ? 32'd3 : 32'd1;
    assign new_res = (opcode == 5'b00101) ? 32'd2: res_interm;

    wire[31:0] opX, opX1;
    
    assign op = overflowX ? new_res : opALU;

    assign blt_taken = isBLT && (~isLessThanX);

    wire ovf_blt;
    adder32 PC_blt(PC_updated, Immediate, blt_branch, 1'b0, ovf_blt);

endmodule