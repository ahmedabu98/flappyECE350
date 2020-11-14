// Define 1 ns as the delay time unit and 100 ps of precision in the waveform
`timescale 1 ns / 100 ps
module decoder_tb;
	////// 			Module Instantiation 		//////
	// inputs to the module (reg)
	reg[4:0] rd;
    reg WE;
	// outputs of the module (wire)
    wire[31:0] out;
	// Instantiate the module to test
	decoder myDec(rd, WE, out);

	////// 			Input Initialization 			//////
	// Initialize the inputs and specify the runtime
	initial begin
		// Initialize the inputs to 0
		rd = 0;
		WE = 0;
		// Set a time delay, in nanoseconds
		#200;
		// Ends the testbench
		$finish;
	end
	////// 			Input Manipulation 			//////
	// Toggle input A every 10 nanoseconds
	always
		#10 rd = rd + 1;
	// Toggle input B every 20 nanoseconds
	always
		#20 WE = ~WE;
	// Print the inputs and outputs whenever inputs change
	
	////// 			Output Results			 //////
	always @(rd, WE) begin
		// Small Delay so outputs can stabilize
		#1;
		$display("A:%b, WE:%b => out:%b", rd, WE, out);
	end
endmodule

