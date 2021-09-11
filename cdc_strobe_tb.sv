//------------------------------------------------------------------------------
// moving_average_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for cdc_strobe.sv module
//

`timescale 1ns / 1ps

module cdc_strobe_tb();

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
  clk33 = #($urandom_range(0, 2000)*1ps) clk33a;
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
  .clk(clk200),
  .rst(rst_once),
  .reseed(1'b0),
  .seed_val(DerivedClocks[31:0]),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #20 start = 1'b0;
end

// Module under test ==========================================================

logic strb1s;
assign strb1s = |RandomNumber1[2:1];

/*logic strb1s = 1'b0;
always_ff @(posedge clk200) begin
  strb1s <= ~strb1s;
end
*/
logic strb1;
edge_detect ed_strb1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .in( strb1s ),
  .rising( strb1 ),
  .falling(  ),
  .both(  )
);

logic strb2;
cdc_strobe M (
  .arst( 1'b0 ),

  .clk1( clk200 ),
  .nrst1( nrst_once ),
  .strb1( strb1 ),

  .clk2( clk33 ),
  .nrst2( 1'b1 ),
  .strb2( strb2 )
);

logic [7:0] strb1_cntr = '0;
always_ff @(posedge clk200) begin
  if( strb1 ) begin
    strb1_cntr[7:0] <= strb1_cntr[7:0] + 1'b1;
  end
end

logic [7:0] strb2_cntr = '0;
always_ff @(posedge clk33) begin
  if( strb2 ) begin
    strb2_cntr[7:0] <= strb2_cntr[7:0] + 1'b1;
  end
end

endmodule
