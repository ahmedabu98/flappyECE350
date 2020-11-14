// Define 1 ns as the delay time unit and 100 ps of precision in the waveform
`timescale 1 ns / 100 ps
module sll_tb;
	////// 			Module Instantiation 		//////
	// inputs to the module (reg)
	reg[31:0] A;
    reg[4:0] shiftamt;
	// outputs of the module (wire)
	wire[31:0] shiftedA;
	// Instantiate the module to test
	sll mySll(A, shiftamt, shiftedA);

	////// 			Input Initialization 			//////
	// Initialize the inputs and specify the runtime
	initial begin
		// Initialize the inputs to 0
		A = 2947483648;
        shiftamt = 1;
		// Set a time delay, in nanoseconds
		#150;
		// Ends the testbench
		$finish;
	end
	////// 			Input Manipulation 			//////
	// Toggle input A every 10 nanoseconds
	always
		#10 shiftamt = shiftamt + 1;
	// Print the inputs and outputs whenever inputs change
	
	////// 			Output Results			 //////
	always @(shiftamt) begin
		// Small Delay so outputs can stabilize
		#1;
		$display("A:%b => shiftedA:%b", A, shiftedA);
	end
endmodule

