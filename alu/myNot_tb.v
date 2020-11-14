module myNot_tb;
	// inputs to the module (wire)
	wire[31:0] A;
	// outputs of the module (wire)
	wire[31:0] nA;

	// Instantiate the module to test
	myNot notter(A, nA);
	integer i; // Use a 32-Bit integer as the For Loop variable
	// Use the concatenation operator to quickly assign module inputs
	assign A = i; // Cin = i[4], A = i[3:2], B = i[1:0]
	initial begin
		for(i = 0; i < 1000; i = i + 10) begin
            // Allow time for the outputs to stabilize
            #20;
            // Display the outputs for the current inputs
            $display("A:%b => Not_A:%b", A, nA);
		end
		// End the testbench
		$finish;
	end
endmodule