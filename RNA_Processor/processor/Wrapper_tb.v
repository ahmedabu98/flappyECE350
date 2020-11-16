`timescale 1 ns / 100 ps
module Wrapper_tb();
    reg clock, reset, up, down, right, left;
    wire hSync, vSync, collided;
    wire[3:0] VGA_B, VGA_G, VGA_R;
    wire[7:0] Anode_Activate;
    wire[6:0] LED_out;


    flappy_Wrapper myprocessor(clock, reset, hSync, vSync, VGA_R, VGA_G, VGA_B, 
    up, down, right, left, collided, Anode_Activate, LED_out);

    initial begin
      clock = 0;
      reset = 0;
      up = 0;
      right = 0;
      down = 0;
      left = 0;


      // Set a time delay, in nanoseconds
      #8000;

      // Ends the testbench
      $finish;
    end

    always
        #20 clock = ~clock;
    
    initial begin
      // output filename
      $dumpfile("Wrapper.vcd");
      // Module to capture and what level, 0 means all wires
      $dumpvars(0, Wrapper_tb);
    end
endmodule