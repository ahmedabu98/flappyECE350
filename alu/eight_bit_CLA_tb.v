// Define 1 ns as the delay time unit and 100 ps of precision in the waveform
`timescale 1 ns / 100 ps
module eight_bit_CLA_tb;
	////// 			Module Instantiation 		//////
	// inputs to the module (reg)
	reg[7:0] A, B;
    reg Cin;
	// outputs of the module (wire)
	wire[7:0] S;
    wire Cout;
	wire overflow;
	// Instantiate the module to test
	eight_bit_CLA myCLA(A, B, Cin, S, Cout, overflow);

	////// 			Input Initialization 			//////
	// Initialize the inputs and specify the runtime
	initial begin
		// Initialize the inputs to 0
		A = 130;
		B = 120;
		Cin = 0;
		// Set a time delay, in nanoseconds
		#400;
		// Ends the testbench
		$finish;
	end
	////// 			Input Manipulation 			//////
	// Toggle input A every 10 nanoseconds
	always
		#20 A = A + 1;
	// Toggle input B every 20 nanoseconds
	always
		#40 B = B + 1;
	// Toggle input Cin every 40 nanoseconds
	always
		#10 Cin = ~Cin;
	// Print the inputs and outputs whenever inputs change
	
	////// 			Output Results			 //////
	always @(A, B, Cin) begin
		// Small Delay so outputs can stabilize
		#1;
		$display("A:%b, B:%b, Cin:%b => S:%b, Cout:%b, Overflow:%b", A, B, Cin, S, Cout, overflow);
	end
endmodule

