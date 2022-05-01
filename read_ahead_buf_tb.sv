//------------------------------------------------------------------------------
// ead_ahead_buf_tb.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for read_ahead_buf.sv module
//

`timescale 1ns / 1ps

module read_ahead_buf_tb();

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
  #10.5 rst_once = 1'b1;
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

//`define TEST_SWEEP yes


logic full1, empty1;

logic direction1 = 1'b0;
logic [7:0] seq_cntr = '0;

always_ff @(posedge clk200) begin
  if( ~nrst ) begin
    direction1 <= 1'b0;

    seq_cntr[7:0] <= '0;
  end else begin
    // sweep logic
    if( full1 ) begin
      direction1 <= 1'b1;
    end else if( empty1 ) begin
      direction1 <= 1'b0;
    end

    seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
  end
end


logic fifo_r_req;
logic [15:0] fifo_r_data;
logic fifo_empty1;
logic [3:0] fifo_cnt;

fifo_single_clock_reg_v1 #(
  .FWFT_MODE( "TRUE" ),
  .DEPTH( 32 ),
  .DATA_W( 16 ),

  // optional initialization
  .USE_INIT_FILE( "FALSE" ),
  .INIT_CNT( 0 )
) FF1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

`ifdef TEST_SWEEP
  .w_req( ~direction1 && &RandomNumber1[10] ),
  .w_data( RandomNumber1[15:0] ),
`else
  .w_req( &RandomNumber1[10:9] ),
  .w_data( RandomNumber1[15:0] ),

`endif

  .r_req( fifo_r_req ),
  .r_data( fifo_r_data[15:0] ),

  .cnt( fifo_cnt[3:0] ),
  .empty( fifo_empty1 ),
  .full( full1 )
);


logic [15:0] buf_r_data_d1;
logic buf_empty1_d1;

logic [15:0] buf_r_data;
read_ahead_buf #(
  .DATA_W( 16 )
) M (
  .clk( clk200 ),
  .anrst( nrst_once ),

  .fifo_r_req( fifo_r_req ),
  .fifo_r_data( fifo_r_data[15:0] ),

  .fifo_empty( fifo_empty1 ),

`ifdef TEST_SWEEP
  .r_req( direction1 && &RandomNumber1[10] ),
  .r_data( buf_r_data[15:0] ),
`else
  .r_req( &RandomNumber1[8:7] && ~buf_empty1_d1 ),
  .r_data( buf_r_data[15:0] ),
`endif
  .empty( empty1 )
);


always_ff @(posedge clk200 or negedge nrst_once) begin
  if( ~nrst_once ) begin
    buf_r_data_d1[15:0] <= '0;
    buf_empty1_d1 <= 1'b0;
  end else begin
    buf_r_data_d1[15:0] <= buf_r_data[15:0];
    buf_empty1_d1 <= empty1;
  end
end

//==============================================================================

logic [15:0] check_r_data;
logic check_empty1;

fifo_single_clock_reg_v1 #(
  .FWFT_MODE( "TRUE" ),
  .DEPTH( 33 ),                      // !!!!!!!! buffer adds effecive +1 depth
  .DATA_W( 16 ),

  // optional initialization
  .USE_INIT_FILE( "FALSE" ),
  .INIT_CNT( 0 )
) CHECK_FF1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

`ifdef TEST_SWEEP
  .w_req( ~direction1 && &RandomNumber1[10] ),
  .w_data( RandomNumber1[15:0] ),
`else
  .w_req( &RandomNumber1[10:9] ),
  .w_data( RandomNumber1[15:0] ),

`endif

`ifdef TEST_SWEEP
  .r_req( direction1 && &RandomNumber1[10] ),
  .r_data( check_r_data[15:0] ),
`else
  .r_req( &RandomNumber1[8:7] && ~buf_empty1_d1 ), // mimic buf timings
  .r_data( check_r_data[15:0] ),
`endif

  .cnt(  ),
  .empty( check_empty1 ),
  .full(  )
);

logic outputs_equal;
assign outputs_equal = ( check_r_data[15:0] == buf_r_data_d1[15:0] ) ||
                       ( fifo_cnt[3:0] <= 4'b1 );
/*`ifdef TEST_FWFT
                       // scipping minor discontinuity
                       // seems like altera`s fifo has some additional buffering???
                       ( cnt1[3:0] == 1 && data_out1[15:0] != data_out2[15:0] );
`else
                       1'b0;
`endif*/

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

