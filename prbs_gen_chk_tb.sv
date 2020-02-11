//------------------------------------------------------------------------------
// prbs_gen_chk_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//

`timescale 1ns / 1ps

module prbs_gen_chk_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

// external device "asynchronous" clock
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
  //#10000;
  forever begin
    #9985 rst = ~rst;
    #5 rst = ~rst;
  end
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

logic [15:0] RandomNumber1;
c_rand rng1 (
  .clk( clk200 ),
  .rst( rst_once ),
  .reseed( 1'b0 ),
  .seed_val( DerivedClocks[31:0] ),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #20 start = 1'b0;
end

// Module under test ==========================================================

logic [31:0] d1;
prbs_gen_chk #(
  .WIDTH( 32 ),
  .CHK_MODE( 0 ),
  .INV_PATTERN( 1 ),
  .POLY_LEN( 31 ),
  .POLY_TAP( 28 )
) gen (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .en( 1'b1 ),
  .data_in( {2{RandomNumber1[15:0]}} ),
  .data_out( d1[31:0] )
);

prbs_gen_chk #(
  .WIDTH( 32 ),
  .CHK_MODE( 1 ),
  .INV_PATTERN( 1 ),
  .POLY_LEN( 31 ),
  .POLY_TAP( 28 )
) checker (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .en( 1'b1 ),
  .data_in( d1[31:0] ),
  .data_out(  )
);


endmodule
