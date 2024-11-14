`timescale 1ns/10ps
 
module testbench2;
 
  reg clk, reset, enable;
  wire [3:0] out;

  fsm_ringcounter4 select_col(clk, reset, enable, out);

  initial begin
      clk = 0;
      reset = 1;
      enable = 0;
  end

  always
      #5 clk = ~clk;

  initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars(1);

      #17 reset = 0;
      #10 enable = 1;

      #200 $finish;
  end
 
endmodule