//------------------------------------------------------------------------------
// fifo_single_clock_ram_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for fifo_single_clock_ram.sv module
//

`timescale 1ns / 1ps

module fifo_single_clock_ram_tb();

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
//`define TEST_SWEEP yes

// comment or uncomment to use bare scfifo or quartus wizard-generated wrappers
//`define BARE_SCFIFO yes

// initialization is not supported for Altera fifo
//`define TEST_INIT yes

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
fifo_single_clock_ram #(
`ifdef TEST_FWFT
  .FWFT_MODE( "TRUE" ),
`else
  .FWFT_MODE( "FALSE" ),
`endif
  .DEPTH( 8 ),
  .DATA_W( 16 ),

  .RAM_STYLE( "logic" )

`ifdef TEST_INIT
  ,
  // optional initialization
  .INIT_FILE( "fifo_single_clock_ram_init.mem" ),
  .INIT_CNT( 10 )
`endif
) FF1 (
  .clk( clk200 ),
`ifdef TEST_INIT
  .nrst( 1'b1 ),
`else
  .nrst( nrst_once ),
`endif

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



logic full2, empty2;
logic full2_d1, empty2_d1;

logic direction2 = 1'b0;
always_ff @(posedge clk200) begin
  if( ~nrst ) begin
    direction2 <= 1'b0;
  end else begin
    // sweep logic
    if( full2_d1 ) begin
      direction2 <= 1'b1;
    end else if( empty2_d1 ) begin
     direction2 <= 1'b0;
    end

    // these signals allow "erroring" requests testing:
    //   - reads from the empty fifo
    //   - writes to the filled fifo
    full2_d1 <= full2;
    empty2_d1 <= empty2;
  end
end

//==============================================================================

logic [15:0] data_out2;
`ifdef BARE_SCFIFO

  SCFIFO #(
    .LPM_WIDTH( 16 ),
    .LPM_NUMWORDS( 8 ),
    .LPM_WIDTHU( $clog2(8) ), /// CEIL(LOG2(LPM_NUMWORDS)),

  `ifdef TEST_FWFT
    .LPM_SHOWAHEAD( "ON" ),
  `else
    .LPM_SHOWAHEAD( "OFF" ),
  `endif
    .UNDERFLOW_CHECKING( "ON" ),
    .OVERFLOW_CHECKING( "ON" ),
    .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
    .ADD_RAM_OUTPUT_REGISTER( "OFF" ),

    .ALMOST_FULL_VALUE( 0 ),
    .ALMOST_EMPTY_VALUE( 0 ),
    .ENABLE_ECC( "FALSE" )

    //.USE_EAB( "ON" ),
    //.MAXIMIZE_SPEED( 5 ),
    //.DEVICE_FAMILY( "CYCLONE V" ),
    //.OPTIMIZE_FOR_SPEED( 5 ),
    //.CBXI_PARAMETER( "NOTHING" )
  ) FF2 (
    .clock( clk200 ),
    .aclr( 1'b0 ),
    .sclr( ~nrst_once ),

  `ifdef TEST_SWEEP
    .wrreq( ~direction1 && &RandomNumber1[10] ),
    .data( RandomNumber1[15:0] ),

    .rdreq( direction1 && &RandomNumber1[10] ),
    .q( data_out2[15:0] ),
  `else
    .wrreq( &RandomNumber1[10:9] ),
    .data( RandomNumber1[15:0] ),

    .rdreq( &RandomNumber1[8:7] ),
    .q( data_out2[15:0] ),
  `endif

    .empty( empty2 ),
    .full( full2 ),

    .almost_empty(  ),
    .almost_full(  ),
    .usedw(  ),

    .eccstatus(  )
  );

`else

  `ifdef TEST_FWFT
  altera_fifo FF2 (
  `else
  altera_fifo_normal FF2 (
  `endif
    .clock ( clk200 ),

  `ifdef TEST_SWEEP
    .wrreq( ~direction1 && &RandomNumber1[10] ),
    .data( RandomNumber1[15:0] ),

    .rdreq( direction1 && &RandomNumber1[10] ),
    .q( data_out2[15:0] ),
  `else
    .wrreq( &RandomNumber1[10:9] ),
    .data( RandomNumber1[15:0] ),

    .rdreq( &RandomNumber1[8:7] ),
    .q( data_out2[15:0] ),
  `endif

    .empty ( empty2 ),
    .full ( full2 ),
    .usedw (  )
  );

`endif

//==============================================================================

logic outputs_equal;
assign outputs_equal = ( data_out1[15:0] == data_out2[15:0] ) ||
`ifdef TEST_FWFT
                       // scipping minor discontinuity
                       // seems like altera`s fifo has some additional buffering???
                       ( cnt1[3:0] == 1 && data_out1[15:0] != data_out2[15:0] );
`else
                       1'b0;
`endif

logic empty_equal;
assign empty_equal = ( empty1 == empty2 );

logic full_equal;
assign full_equal = ( full1 == full2 );

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

// this condition is being processed differently by altera`s scfifo and
//   the custom fifo implementation
logic test_cond;
assign test_cond = empty1 && &RandomNumber1[10:9] && &RandomNumber1[8:7];

endmodule
