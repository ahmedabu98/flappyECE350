`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, RegFile and Memory elements together.
 * 
 * We will be using our own separate Wrapper.v to test your code. You are allowed to make changes to the Wrapper file for your
 * own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 47 to add the memory file of the test you created using the assembler
 * For example, you would add sample.mem inside of the quotes after assembling sample.s
 *
 **/

module flappy_Wrapper(input clock, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input up,
	input down,
	input right,
	input left,
	output collided,
        output [7:0] Anode_Activate,
        output [6:0] LED_out
        );

    wire rwe, mwe, neg_clock;
    wire[4:0] rd, rs1, rs2;
    wire[31:0] instAddr, instData, 
               rData, regA, regB,
               memAddr, memDataIn, memDataOut;
    
    assign neg_clock = ~clock;

    reg[26:0] one_second_counter;
    wire one_second_clock, neg_one_second_clock;
    wire reset_or_collided;
    assign reset_or_collided = reset || collided;
    always @(posedge clock or posedge reset)
    begin
        if(reset == 1 || collided == 1 || one_second_counter>=99999999)
                one_second_counter <= 0;
        else
                one_second_counter <= one_second_counter + 1;
    end
    //slowed clock
    assign one_second_clock = (one_second_counter>50000000)?1:0;
    assign neg_one_second_clock = ~one_second_clock;
    ///// Main Processing Unit
    processor CPU(.clock(one_second_clock), .reset(reset), 
                  
		  ///// ROM
                  .address_imem(instAddr), .q_imem(instData),
                  
		  ///// Regfile
                  .ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
                  .ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
                  .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
                  
		  ///// RAM
                  .wren(mwe), .address_dmem(memAddr), 
                  .data(memDataIn), .q_dmem(memDataOut)); 
                  
    ///// Instruction Memory (ROM)
    ROM #(.MEMFILE("instructions_RNA.mem")) // Add your memory file here
    InstMem(.clk(neg_one_second_clock), 
            .wEn(1'b0), 
            .addr(instAddr[11:0]), 
            .dataIn(32'b0), 
            .dataOut(instData));
    
    wire[31:0] counter;
    ///// Register File
    regfile RegisterFile(.clock(neg_one_second_clock), 
             .ctrl_writeEnable(rwe), .ctrl_reset(reset_or_collided), 
             .ctrl_writeReg(rd),
             .ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
             .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
             .counter(counter));
             
    ///// Processor Memory (RAM)
    RAM ProcMem(.clk(neg_one_second_clock), 
            .wEn(mwe), 
            .addr(memAddr[11:0]), 
            .dataIn(memDataIn), 
            .dataOut(memDataOut));
    

    VGAController Screen(.clk(clock), .reset(reset),
            .hSync(hSync), .vSync(vSync),
            .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
            .up(up), .down(down), .right(right), .left(left), .counter(counter),
            .collided(collided), .Anode_Activate(Anode_Activate), .LED_out(LED_out));

endmodule
