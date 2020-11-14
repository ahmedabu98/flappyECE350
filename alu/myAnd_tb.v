module myAnd_tb;
	// inputs to the module (wire)
	wire[31:0] A, B;
	// outputs of the module (wire)
	wire[31:0] AnB;

	// Instantiate the module to test
	myAnd ander(A, B, AnB);
	integer i; // Use a 32-Bit integer as the For Loop variable
    integer j;
	// Use the concatenation operator to quickly assign module inputs
	assign A = i; // Cin = i[4], A = i[3:2], B = i[1:0]
    assign B = j;
	initial begin
		for(i = 0; i < 1000; i = i + 10) begin
            for(j = 0; j < 1000; j = j + 10) begin
                // Allow time for the outputs to stabilize
                #20;
                // Display the outputs for the current inputs
                $display("A:%b, B:%b => A_and_B:%b", A, B, AnB);
            end
		end
		// End the testbench
		$finish;
	end
endmodule