module memory_stage(Instruction, Operation, B, address_dmem, data, wren);
    input [31:0] Instruction, Operation, B;
    output [31:0] address_dmem, data;
	output wren;

    wire[4:0] sw, lw, opcode;

    assign opcode = Instruction[31:27];
    assign sw = 5'b00111;
    assign lw = 5'b01000;

    assign data = B;
    assign wren = (opcode == sw);
    
    assign address_dmem = Operation;
    
endmodule