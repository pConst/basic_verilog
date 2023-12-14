//------------------------------------------------------------------------------
// freq_meter.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// frequency meter counts how many periods of test clock happen within
// a given large time base.
// Frequency value in MHz is proportional to system clock as readout/timebase
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

freq_meter fm1 (
  .clk( clk ),  // 62.5 MHz expected
  .nrst( nrst ),

  .test_clk(  ),
  .test_ena(  ),

  .readout(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module freq_meter (
  input clk,                  // system clock, 62.5 MHz expected
  input nrst,                 // reset (inversed)

  input test_clk,             // signal to count
  input test_ena,             // enable counting signal (in test_clk domain)

  output [31:0] readout = '0  // number of test_clk complete cycles per
);                            // 1073741,824 mks time base


  logic [31:0] clk_div;
  clk_divider #(
    .WIDTH( 32 )
  ) sys_cd (
    .clk( clk ),
    .nrst( nrst ),
    .ena( 1'b1 ),
    .out(  )
  );

  // synchronizing into test frequency time domain
  logic start_new_count;

  delay #(
      .LENGTH( 2 ),
      .WIDTH( 1 )
  ) sstart_new_count_d_SYNC_ATTR (
      .clk( test_clk ),
      .nrst( 1'b1 ),
      .ena( 1'b1 ),
      .in( clk_div[15] ),  // defines the timebase
      .out( start_new_count )
  );

  // detecting rising edge of start condition
  logic start_new_count_rise;

  edge_detect start_new_count_ed (
    .clk( test_clk ),
    .nrst( 1'b1 ),
    .in( start_new_count ),
    .rising( start_new_count_rise ),
    .falling(  ),
    .both(  )
  );

  logic [31:0] cntr_tc = 31'b1;

  logic [31:0] readout_tc = '0;
  logic        readout_tc_valid = 1'b0;

  always_ff @(posedge test_clk) begin
    if( start_new_count_rise ) begin

      // every counter refreshes approx. once in a second and holds a value of
      // test freq complete periods over 1073741,824 mks
      readout_tc[31:0] <= cntr_tc[31:0];
      readout_tc_valid <= 1'b1;

      cntr_tc[31:0] <= 1;
    end else if( test_ena ) begin
      readout_tc_valid <= 1'b0;

      cntr_tc[31:0] <= cntr_tc[31:0] + 1'b1;
    end
  end

  // synchronizing back into clk time domain
  logic readout_valid;
  cdc_strobe readout_valid_tc_cdc (
    .arst( 1'b0 ),

    .clk1( test_clk ),
    .nrst1( 1'b1 ),
    .strb1( readout_tc_valid ),

    .clk2( clk ),
    .nrst2( nrst ),
    .strb2( readout_valid )
  );


  always_ff @(posedge clk) begin
    if( ~nrst ) begin
      readout[31:0] <= '0;
    end else begin
      if( readout_valid ) begin
        readout[31:0] <= readout_tc[31:0];
      end
    end
  end

endmodule

