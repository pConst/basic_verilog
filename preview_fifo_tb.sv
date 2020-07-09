//------------------------------------------------------------------------------
// preview_fifo_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for preview_fifo_tb.sv module

`timescale 1ns / 1ps

module preview_fifo_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

logic clk400;
initial begin
  #0 clk400 = 1'b0;
  forever
    #1.25 clk400 = ~clk400;
end

logic clk33;
initial begin
  #0 clk33 = 1'b0;
  forever
    #15.151 clk33 = ~clk33;
end

logic rst;
initial begin
  #0 rst = 1'b0;
  #10.2 rst = 1'b1;
  #5 rst = 1'b0;
end

logic nrst;
assign nrst = ~rst;

logic rst_once;
initial begin
  #0 rst_once = 1'b0;
  #10.2 rst_once = 1'b1;
  #5 rst_once = 1'b0;
end

logic nrst_once;
assign nrst_once = ~rst_once;

logic [31:0] DerivedClocks;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),
  .out( DerivedClocks[31:0] )
);

logic [31:0] E_DerivedClocks;
edge_detect ed1[31:0] (
  .clk( {32{clk200}} ),
  .nrst( {32{nrst_once}} ),
  .in( DerivedClocks[31:0] ),
  .rising( E_DerivedClocks[31:0] ),
  .falling(  ),
  .both(  )
);

logic [31:0] RandomNumber1;
c_rand rng1 (
  .clk( clk200 ),
  .rst( 1'b0 ),
  .reseed( rst_once ),
  .seed_val( DerivedClocks[31:0] ^ (DerivedClocks[31:0] << 1) ),
  .out( RandomNumber1[15:0] )
);

c_rand rng2 (
  .clk( clk200 ),
  .rst( 1'b0 ),
  .reseed( rst_once ),
  .seed_val( DerivedClocks[31:0] ^ (DerivedClocks[31:0] << 2) ),
  .out( RandomNumber1[31:16] )
);

// Module under test ==========================================================

logic wrreg;
logic valid;

preview_fifo #(
  .WIDTH( 16 ),
  .DEPTH( 16 )
) pf (
  .clk( clk200 ),
  .nrst( nrst_once ),

  // input port
  .wrreq( wrreg ),
  .ena( (wrreg && |RandomNumber1[1:0]) ),
  .id0( RandomNumber1[15:0] ),
  .id1( RandomNumber1[31:16] ),

  // output port
  .valid( valid ),
  .shift_req_oh( {3{valid}} &
                  3'b010 ),
                  //RandomNumber1[15:13] ),
  .od0(  ),
  .od1(  )
);


endmodule
