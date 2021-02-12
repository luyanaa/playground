`timescale 1ns/100ps
module mc14500_tb;

parameter SYSCLK_PERIOD = 10;
reg SYSCLK;
reg NSYSRESET;

initial begin
    SYSCLK = 1'b0;
    NSYSRESET = 1'b0;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,mc14500_tb);
end

initial begin
    #(SYSCLK_PERIOD *10)
      NSYSRESET = 1'b1;
    #1000
      $stop;
end

always @(SYSCLK)
  #(SYSCLK_PERIOD/2.0) SYSCLK <=!SYSCLK;

mc14500 mc14500_0(
  .clk(SYSCLK),
  .rst_n(NSYSRESET),

);
endmodule