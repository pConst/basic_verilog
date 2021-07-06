//------------------------------------------------------------------------------
// lifo_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for lifo.sv module
//

`timescale 1ns / 1ps

module lifo_tb();

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


// comment or uncomment to test FWFT and normal fifo modes
//`define TEST_FWFT yes

// comment or uncomment to sweep-test or random test
`define TEST_SWEEP yes

logic full1, empty1;
logic full1_d1, empty1_d1;

logic direction1 = 1'b0;
always_ff @(posedge clk200) begin
  if( ~nrst ) begin
    direction1 <= 1'b0;
  end else begin
    // sweep logic
    if( full1_d1 ) begin
      direction1 <= 1'b1;
    end else if( empty1_d1 ) begin
     direction1 <= 1'b0;
end

    // these signals allow "erroring" requests testing:
    //   - reads from the empty fifo
    //   - writes to the filled fifo
    full1_d1 <= full1;
    empty1_d1 <= empty1;
  end
end

logic [3:0] cnt1;
logic [15:0] data_out1;
lifo #(
`ifdef TEST_FWFT
  .FWFT_MODE( "TRUE" ),
`else
  .FWFT_MODE( "FALSE" ),
`endif
  .DEPTH( 8 ),
  .DATA_W( 16 )
) LF1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

`ifdef TEST_SWEEP
  .w_req( ~direction1 && &RandomNumber1[10] ),
  .w_data( RandomNumber1[15:0] ),

  .r_req( direction1 && &RandomNumber1[10] ),
  .r_data( data_out1[15:0] ),
`else
  .w_req( &RandomNumber1[10:9] ),
  .w_data( RandomNumber1[15:0] ),

  .r_req( &RandomNumber1[8:7] ),
  .r_data( data_out1[15:0] ),
`endif

  .cnt( cnt1[3:0] ),
  .empty( empty1 ),
  .full( full1 )
);


endmodule
