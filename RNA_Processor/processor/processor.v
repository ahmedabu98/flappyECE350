/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem lw/sw
    data,                           // O: The data to write to dmem sw
    wren,                           // O: Write enable for dmem sw
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output[31:0] address_imem;
	input[31:0] q_imem;

	// Dmem
	output[31:0] address_dmem, data;
	output wren;
	input[31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output[4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output[31:0] data_writeReg;
	input[31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
    wire[4:0] rstatus;
    assign rstatus = 5'd30;

    wire[31:0] nop;
    assign nop = 32'b0;

    wire isBLT, blt_taken;
    wire mult_stall, any_stall;
    assign mult_stall = mult_or_divX && (~multdiv_resultRDY);
    assign any_stall = staller || mult_stall;

    wire[31:0] ALUinA, ALUinB, dataMem;
    wire staller, bj_taken;

    // ************************ FETCH stage ***********************************************
    // Program counter register
    wire[31:0] PC_in, PC_incremented, PC_branch, PC_new, PC_branch_BLT;
    // assign PC_in = (address_imem != 32'bx) ? PC_new : 32'b0;
    // assign PC_in = PC_in + 32'b1;
    assign PC_in = bj_taken ? PC_branch : PC_incremented;
    wire PC_ovf, ctrl_newPC, branch_type;

    register PC(PC_in, address_imem, ~any_stall, clock, reset);
    adder32 PC_updated(address_imem, 32'b1, PC_incremented, 1'b0, PC_ovf);
    
    assign ctrl_newPC = isBLT ? blt_taken : branch_taken;
    assign PC_branch = isBLT ? PC_branch_BLT : PC_branchD;
    assign PC_new = ctrl_newPC ? PC_branch : PC_incremented;
    assign bj_taken = blt_taken || branch_taken;

    // F/D latch

    wire[31:0] dataFD, PC_fd;
    register regFD(bj_taken ? nop : q_imem, dataFD, ~any_stall, clock, reset);
    register PCfd(PC_incremented, PC_fd, ~any_stall, clock, reset);

    // ************************* DECODE stage ************************************************
    // Setting up the different wires after obtaining instruction
    wire[31:0] PC_branchD, A_decode, B_decode;
    wire mult_or_divD, mult_or_divX, isbranchD, branch_taken;
    decode_stage decode(dataFD, PC_fd, A_decode, B_decode, ctrl_readRegA, ctrl_readRegB, PC_branchD, mult_or_divD, isbranchD, branch_taken);

    // D/X Latches
    wire[31:0] dataDX, regAx, regBx, PC_dx;
    register regDXir((staller || blt_taken) ? nop : dataFD, dataDX, ~mult_stall, clock, reset);
    register registerAdx(A_decode, regAx, ~mult_stall, clock, reset);
    register registerBdx(B_decode, regBx, ~mult_stall, clock, reset);
    register PCdx(PC_fd, PC_dx, ~mult_stall, clock, reset);
    dffe_ref mult_or_divDX(.d(mult_or_divD), .q(mult_or_divX), .en(~mult_stall), .clk(clock), .clr(reset));

    // ******************************** EXECUTE stage, need to add multdiv; ***************************
    // ALU
    wire[31:0] op_X, InstrX, instr_ALUin;
    // assign instr_ALUin = mult_or_divX ? nop : dataDX; // Send nop if operation is mult or div
    execute_stage_ALU execute(dataDX, ALUinA, ALUinB, PC_dx, op_X, InstrX, clock, isBLT, blt_taken, PC_branch_BLT);

    // X/M latch
    wire[31:0] dataXM, regOm, regBm, PC_xm;
    register regXMir(mult_stall ? nop : InstrX, dataXM, 1'b1, clock, reset);
    register registerOxm(op_X, regOm, 1'b1, clock, reset);
    register registerBxm(ALUinB, regBm, 1'b1, clock, reset);
    register PCxm(PC_dx, PC_xm, 1'b1, clock, reset);

    // MultDiv
    wire[31:0] multdiv_result, Instr_MultDiv, Instr_MultDiv_in;
    wire multdiv_exception, multdiv_resultRDY;
    // assign Instr_MultDiv_in = mult_or_divX ? dataDX : nop;
    execute_stage_MultDiv MultDiv(dataDX, ALUinA, ALUinB, clock, multdiv_result, multdiv_resultRDY, Instr_MultDiv, reset);

    // PW latch
    wire[31:0] data_MultDiv, PWir, PW_res;
    wire mult_or_divW, mult_readyW;
    register reg_PWir(Instr_MultDiv, PWir, 1'b1, clock, reset);
    register res_MultDiv(multdiv_result, PW_res, 1'b1, clock, reset);
    dffe_ref mult_or_divPM(.d(mult_or_divX), .q(mult_or_divW), .en(1'b1), .clk(clock), .clr(reset));
    dffe_ref mult_readyPM(.d(multdiv_resultRDY), .q(mult_readyW), .en(1'b1), .clk(clock), .clr(reset));

    // ******************************** MEMORY stage **************************************
    memory_stage memory(dataXM, regOm, dataMem, address_dmem, data, wren);

    // M/W latch
    wire[31:0] dataMW, regOw, regDw, PC_mw;
    register regMWir(dataXM, dataMW, 1'b1, clock, reset);
    register registerOmw(regOm, regOw, 1'b1, clock, reset);
    register registerBmw(q_dmem, regDw, 1'b1, clock, reset);
    register PCmw_reg(PC_xm, PC_mw, 1'b1, clock, reset);

    // ******************************* WRITEBACK stage ****************************************
    writeback_stage writeback(dataMW, PWir, PC_mw, regOw, regDw, PW_res, mult_or_divW, mult_readyW, data_writeReg, ctrl_writeEnable, ctrl_writeReg);

    // ******************************** BYPASS *****************************************************
    // wire[31:0] ALUinA, ALUinB, dataMem;
    bypass bypass_proc(dataFD, dataDX, dataXM, dataMW, regAx, regOm, data_writeReg, regBm, regBx, ALUinA, ALUinB, dataMem, A_decode, B_decode, data_readRegA, data_readRegB, op_X, PC_dx, PC_xm, PC_mw, ctrl_writeEnable);

    // ********************************* STALL **********************************************************
    stall stalling(dataDX, dataFD, staller);

	/* END CODE */

    // Comments
    // Need to insert:
    //     - no ops / stalling
    //     - how to deal with setx
    //     - branches adn jumps

    

endmodule
