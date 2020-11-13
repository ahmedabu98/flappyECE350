module execute_stage_MultDiv(Instruction, A, B, clock, multdiv_result, multdiv_resultRDY, Instr_Out, reset);
    input[31:0] Instruction, A, B;
    input clock, reset;
    output[31:0] multdiv_result, Instr_Out;
    output multdiv_resultRDY;

    wire[4:0] opcode, ALU_opcode;
    assign opcode = Instruction[31:27];
    assign ALU_opcode = Instruction[6:2];

    wire multdiv_exception;

    wire [4:0] mult, div;
    assign mult = 5'b00110;
    assign div = 5'b00111;

    wire ctrl_MULT, ctrl_DIV;
    wire count_ready, WE_count, reset_counter;
    wire [5:0] counter;

    wire running, multip, divis, multiplying, dividing;

    dffe_ref run(running, ((ALU_opcode == mult) || (ALU_opcode == div) && (opcode == 5'd0)), clock, 1'b1, reset);
    
    assign multip = (opcode == 5'b0) && (ALU_opcode == mult);
    assign divis = (opcode == 5'b0) && (ALU_opcode == div);

    dffe_ref mult_dff(multiplying, multip, clock, 1'b1, multdiv_resultRDY);
    dffe_ref div_dff(dividing, divis, clock, 1'b1, multdiv_resultRDY);

    assign ctrl_MULT = (~multiplying) && (~multdiv_resultRDY) && multip;
    assign ctrl_DIV = (~dividing) && (~multdiv_resultRDY) && divis;

    wire[31:0] multdiv_resultX;
    multdiv mult_div(A, B, ctrl_MULT, ctrl_DIV, clock, multdiv_resultX, multdiv_exception, multdiv_resultRDY);

    wire[31:0] new_Instr, mult_excp, div_excp;

    assign mult_excp = 32'b10101000000000000000000000000100;
    assign div_excp = 32'b10101000000000000000000000000101;

    assign new_Instr = (ALU_opcode == mult) ? mult_excp : div_excp;
    assign Instr_Out = multdiv_exception ? new_Instr : Instruction;

    wire[31:0] multdiv_result_excp;
    assign multdiv_result_excp = (ALU_opcode == mult) ? 32'd4 : 32'd5;
    assign multdiv_result = multdiv_exception ? multdiv_result_excp : multdiv_resultX;

endmodule