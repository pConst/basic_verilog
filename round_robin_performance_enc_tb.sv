//------------------------------------------------------------------------------
// round_robin_performance_enc_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for round_robin_performance_enc.sv module
//

`timescale 1ns / 1ps

module round_robin_performance_enc_tb();

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

`define WIDTH_W  3
`define WIDTH    (2**`WIDTH_W)

logic [`WIDTH-1:0] pos;
bin2pos #(
  .BIN_WIDTH( `WIDTH_W )
) BP1 (
  .bin( RandomNumber1[`WIDTH_W-1:0] ),
  .pos( pos[`WIDTH-1:0] )
);

round_robin_performance_enc #(
  .WIDTH( `WIDTH )
) RE1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .id( RandomNumber1[`WIDTH-1:0] ), //pos[`WIDTH-1:0] ),
  .od_valid(  ),
  .od_filt(  ),
  .od_bin(  )
);


endmodule
