//------------------------------------------------------------------------------
// soft_latch_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for soft_latch.sv module
//

`timescale 1ns / 1ps

module soft_latch_tb();

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

logic set;
assign set = &RandomNumber1[14:12];

logic ret;
assign ret = &RandomNumber1[11:9];

// verilog hardvare latch
logic [15:0] data1;
always_latch begin
  if( ret ) begin
    data1[15:0] <= '0;
  end else if( set ) begin
    data1[15:0] <= RandomNumber1[15:0];
  end
end

// soft_latch prototype
logic [15:0] data2;
set_reset_comb SR [15:0] (
  .clk( {16{clk200}} ),
  .nrst( {16{1'b1}} ),
  .s( {16{set}} & RandomNumber1[15:0] ),      //set
  .r( ({16{set}} & ~RandomNumber1[15:0]) | {16{ret}} ),     //rst
  .q( data2[15:0] ),
  .nq(  )
);

// genuine soft_latch instance
logic [15:0] data3;
soft_latch #(
  .WIDTH( 16 )
) SL1 (
  .clk( clk200 ),
  .nrst( ~ret ),
  .latch( set ),
  .in( RandomNumber1[15:0] ),
  .out( data3[15:0] )
);

//==============================================================================

logic outputs_equal;
assign outputs_equal = ( data1[15:0] == data2[15:0] ) &&
                       ( data1[15:0] == data3[15:0] );

logic success = 1'b1;
always_ff @(posedge clk200) begin
  if( ~nrst ) begin
    success <= 1'b1;
  end else begin
    if( ~outputs_equal ) begin
      success <= 1'b0;
    end
  end
end

endmodule
