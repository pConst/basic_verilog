//------------------------------------------------------------------------------
// pattern_detect_tb.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Testbench template with basic clocking, reset and random stimulus signals

// use this define to make some things differently in simulation
`define SIMULATION yes

`timescale 1ns / 1ps

module pattern_detect_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

// external device "asynchronous" clock
logic clk33a;
initial begin
  #0 clk33a = 1'b0;
  forever
    #7 clk33a = ~clk33a;
end

logic clk33;
//assign clk33 = clk33a;
always @(*) begin
  clk33 = #($urandom_range(0, 2000)*10ps) clk33a;
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

logic [31:0] clk200_div;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),
  .out( clk200_div[31:0] )
);

logic [31:0] clk200_div_rise;
edge_detect ed1[31:0] (
  .clk( {32{clk200}} ),
  .anrst( {32{nrst_once}} ),
  .in( clk200_div[31:0] ),
  .rising( clk200_div_rise[31:0] ),
  .falling(  ),
  .both(  )
);

logic [31:0] rnd_data;
always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    rnd_data[31:0] <= $random( 1 );  // seeding
  end else begin
    rnd_data[31:0] <= $random;
  end
end

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #20 start = 1'b0;
end

//initial begin
//  #1000 $finish;
//end

// Module under test ===========================================================

logic [15:0] detected;
logic [15:0][9:0] detected_mask;

pattern_detect #(
  .DEPTH( 5 ),
  .WIDTH( 2 ),

  .PAT_WIDTH( 7 ),
  .PAT( 7'b1_11_00_11 )
) pd [15:0] (
  .clk( {16{clk200}} ),
  .nrst( {16{nrst_once}} ),
  .ena( '1 ),
  .data( rnd_data[31:0] ),

  .detected( detected[15:0] ),
  .detected_mask( detected_mask )
);


endmodule

