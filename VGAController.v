`timescale 1 ms/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
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
    input[31:0] counter,
	output collided,
    output reg [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
	);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/aabua/Documents/ECE350/flappyECE350/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
    reg [9:0] x_topleft=100;
    reg [8:0] y_topleft=240;
	reg[9:0] column1_topleft = 520;
	reg[9:0] column2_topleft = 680;
	reg[9:0] column3_topleft = 840;
	reg[9:0] column4_topleft = 1000;
	reg[9:0] column5_topleft = 360;
	reg[9:0] column6_topleft = 200;
	// reg[9:0] columnY_topleft = 0;
    
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image1.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
    wire[BITS_PER_COLOR-1:0] square_color;
    wire[BITS_PER_COLOR-1:0] column_color;

	assign column_color = 12'd2000;
    assign square_color = 12'd1500;
    
	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
	// Generate square
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	wire [BITS_PER_COLOR-1:0] active_color;
	wire [BITS_PER_COLOR-1:0] color_placeholder;
  
  	wire [7:0] STEP_SIZE = 2;
  	
    wire f,c;
     
    assign f = (((x >= x_topleft) && x <= (x_topleft + 20)) && ((y >= y_topleft) && y <= (y_topleft + 30)));
	assign c = ((((x >= column1_topleft) && x <= (column1_topleft + 50)) && (y<=100 || y>=200)) || (((x >= column2_topleft) && x <= (column2_topleft + 50)) && (y<=300 || y>=400)) || (((x >= column3_topleft) && x <= (column3_topleft + 50)) && (y<=180 || y>=280)) || (((x >= column4_topleft) && x <= (column4_topleft + 50)) && (y<=240 || y>=340)) || (((x >= column5_topleft) && x <= (column5_topleft + 50)) && (y<=300 || y>=400)) || (((x >= column6_topleft) && x <= (column6_topleft + 50)) && (y<=140 || y>=240)));
    reg didCollide = 0;
	reg start = 0;
  	always @(posedge screenEnd)
	begin
        x_topleft <= x_topleft + right*STEP_SIZE - left*STEP_SIZE;
        y_topleft <= y_topleft + down*STEP_SIZE - up*STEP_SIZE;
        
        if(start == 0) begin
            start <= 1;
            #10000;
        end

		else if(	(((x_topleft+20) > column1_topleft && (x_topleft+20)<(column1_topleft+50) || (x_topleft) > column1_topleft && (x_topleft)<(column1_topleft+50)) && (y_topleft<100 || (y_topleft+30)>200)) ||
			(((x_topleft+20) > column2_topleft && (x_topleft+20)<(column2_topleft+50) || (x_topleft) > column2_topleft && (x_topleft)<(column2_topleft+50)) && (y_topleft<300 || (y_topleft+30)>400)) ||
			(((x_topleft+20) > column3_topleft && (x_topleft+20)<(column3_topleft+50) || (x_topleft) > column3_topleft && (x_topleft)<(column3_topleft+50)) && (y_topleft<180 || (y_topleft+30)>280)) ||
			(((x_topleft+20) > column4_topleft && (x_topleft+20)<(column4_topleft+50) || (x_topleft) > column4_topleft && (x_topleft)<(column4_topleft+50)) && (y_topleft<240 || (y_topleft+30)>340)) ||
			(((x_topleft+20) > column5_topleft && (x_topleft+20)<(column5_topleft+50) || (x_topleft) > column5_topleft && (x_topleft)<(column5_topleft+50)) && (y_topleft<300 || (y_topleft+30)>400)) ||
			(((x_topleft+20) > column6_topleft && (x_topleft+20)<(column6_topleft+50) || (x_topleft) > column6_topleft && (x_topleft)<(column6_topleft+50)) && (y_topleft<140 || (y_topleft+30)>240))
			)
		begin
            column1_topleft <= 520;
            column2_topleft <= 680;
            column3_topleft <= 840;
            column4_topleft <= 1000;
            column5_topleft <= 360;
            column6_topleft <= 200;
            x_topleft <= 100;
            y_topleft <= 240;
            start <= 0;
            didCollide <= 1;
		   #10000;
		end
		else begin
            column1_topleft <= column1_topleft - 1;
            column2_topleft <= column2_topleft - 1;
            column3_topleft <= column3_topleft - 1;
            column4_topleft <= column4_topleft - 1;
            column5_topleft <= column5_topleft - 1;
            column6_topleft <= column6_topleft - 1;
            didCollide <= 0;
		end
		#1000;
  	end
	assign color_placeholder = c ? column_color : colorData;
	assign active_color = f ? square_color : color_placeholder;
  
	assign colorOut = active ? active_color : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
	
	// ************************* Counter *************************
	reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [15:0] displayed_number; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter; 
    // always @(posedge clk or posedge reset)
    // begin
    //     if(reset==1 || didCollide == 1)
    //         one_second_counter <= 0;
    //     else begin
    //         if(one_second_counter>=99999999) 
    //              one_second_counter <= 0;
    //         else
    //             one_second_counter <= one_second_counter + 1;
    //     end
    // end 
    // assign one_second_enable = (one_second_counter==99999999)?1:0;
    // always @(posedge clk or posedge reset)
    // begin
    //     if(reset==1 || didCollide == 1)
    //         displayed_number <= 0;
    //     else if(one_second_enable==1)
    //         displayed_number <= displayed_number + 1;
    // end
    // make sure to increment every 100Million cycles
    // For anode refresh rate:
    always @(posedge clk or posedge reset)
    begin 
        if(reset==1 || didCollide == 1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 8'b11110111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = counter/1000;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 8'b11111011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = (counter % 1000)/100;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 8'b11111101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = ((counter % 1000)%100)/10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 8'b11111110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ((counter % 1000)%100)%10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 7'b0000001; // "0"
        endcase
    end
endmodule