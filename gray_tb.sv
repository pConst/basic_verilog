//------------------------------------------------------------------------------
// gray_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for bin2gray and gray2bin module


`timescale 1ns / 1ps

module gray_tb();

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

`define WIDTH 32

logic [`WIDTH-1:0] bin = 0;

always_ff @(posedge clk200) begin
  if(~nrst_once) begin
    bin[`WIDTH-1:0] <= 0;
  end else begin
    bin[`WIDTH-1:0] <= bin[`WIDTH-1:0] + 1'b1;
  end
end

logic [`WIDTH-1:0] gray;
bin2gray #(
  .WIDTH( `WIDTH )
) BG1 (
  .bin_in( bin[`WIDTH-1:0] ),
  .gray_out( gray[`WIDTH-1:0] )
);

logic [`WIDTH-1:0] bin2;
gray2bin #(
  .WIDTH( `WIDTH )
) GB1 (
  .gray_in( gray[`WIDTH-1:0] ),
  .bin_out( bin2[`WIDTH-1:0] )
);

//assert property
//  (bin[`WIDTH-1:0] == bin2[`WIDTH-1:0])
//else $error("It's gone wrong");

endmodule
