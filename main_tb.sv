//------------------------------------------------------------------------------
// main_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Testbench template with basic clocking, reset and random stimulus signals

`timescale 1ns / 1ps

module main_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

logic rst;
initial begin
  #0 rst = 1'b0;
  #10.2 rst = 1'b1;
  #5 rst = 1'b0;
  //#10000;
  forever begin
    #9985 rst = ~rst;
    #5 rst = ~rst;
  end
end

logic nrst;
assign nrst = ~rst;

logic rst_once;
initial begin       // initializing non-X data before PLL starts
  #0 rst_once = 1'b0;
  #10.2 rst_once = 1'b1;
  #5 rst_once = 1'b0;
end
initial begin
  #510.2 rst_once = 1'b1;    // PLL starts at 500ns, clock appears, so doing the reset for modules
  #5 rst_once = 1'b0;
end

logic nrst_once;
assign nrst_once = ~rst_once;

logic [31:0] DerivedClocks;
clk_divider #(
  .WIDTH( 32 )
) CD1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .out( DerivedClocks[31:0] )
);

logic [31:0] E_DerivedClocks;
edge_detect ED1[31:0] (
  .clk( {32{clk200}} ),
  .nrst( {32{nrst_once}} ),
  .in( DerivedClocks[31:0] ),
  .rising( E_DerivedClocks[31:0] ),
  .falling(  ),
  .both(  )
);

logic [15:0] RandomNumber1;
c_rand RNG1 (
  .clk( clk200 ),
  .rst( rst_once ),
  .reseed( 1'b0 ),
  .seed_val( DerivedClocks[31:0] ),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100.2 start = 1'b1;
  #5 start = 1'b0;
end

// Module under test ==========================================================

wire out1,out2;
Main M (    // module under test
  clk200,~clk200,
  rst_once,
  out1,out2   // for compiler not to remove logic
);

endmodule
