// Define 1 ns as the delay time unit and 100 ps of precision in the waveform
`timescale 1 ns / 100 ps
module thirtytwo_bit_subtract_tb;
	////// 			Module Instantiation 		//////
	// inputs to the module (reg)
	reg[31:0] A, B;
	// outputs of the module (wire)
	wire[31:0] S;
	wire overflow;
    wire isLessThan;
    wire isNotEqual;
	// Instantiate the module to test
	thirtytwo_bit_subtract mySubtract(A, B, S, overflow, isLessThan, isNotEqual);

	////// 			Input Initialization 			//////
	// Initialize the inputs and specify the runtime
	initial begin
		// Initialize the inputs to 0
		A = 1;
		B = 2;
		// Set a time delay, in nanoseconds
		#200;
		// Ends the testbench
		$finish;
	end
	////// 			Input Manipulation 			//////
	// Toggle input A every 10 nanoseconds
	always
		#10 A = A + 1;
	// Toggle input B every 20 nanoseconds
	always
		#15 B = B + 1;
	// Print the inputs and outputs whenever inputs change
	
	////// 			Output Results			 //////
	always @(A, B) begin
		// Small Delay so outputs can stabilize
		#1;
		$display("A:%b, B:%b => S:%b, Overflow:%b, isLessThan:%b, isNotEqual:", A, B, S, overflow, isLessThan, isNotEqual);
	end
endmodule

