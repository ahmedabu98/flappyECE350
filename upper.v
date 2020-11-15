module upper(
    input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	// inout ps2_clk,
	// inout ps2_data,
	input up,
	input down,
	input right,
	input left,
	output didCollide);

    wire f, c;
	wire collided;
	assign collided = didCollide;
    VGAController myVGA(clk, reset, hSync, vSync, VGA_R, VGA_G, VGA_B, up, down, right, left, f, c, collided);
    
    isCollided myCollision(f, c, didCollide);

endmodule