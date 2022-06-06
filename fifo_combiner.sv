//------------------------------------------------------------------------------
// fifo_combiner.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Combines / accumulates data words from multiple FIFOs to a single output FIFO.
//  Features three different element enumeration strategies.
//  Reads if ANY input FIFO has data.
//
//  See also fifo_operator.sv
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

fifo_combiner #(
  .WIDTH( 2 ),
  .ENCODER_MODE( "ROUND_ROBIN" ),
  .FWFT_MODE( "TRUE" ),
  .DATA_W( 32 )
) FC1 (
  .clk(  ),
  .nrst(  ),

  .r_empty(  ),
  .r_req(  ),
  .r_data(  ),

  .w_full(  ),  // connect to "almost_full" if FWFT_MODE="FALSE"
  .w_req(  ),
  .w_data(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module fifo_combiner #( parameter

  WIDTH = 2,                     // number of input fifo ports to combine
  WIDTH_W = clogb2(WIDTH),       // input port index width
  ENCODER_MODE = "ROUND_ROBIN",  // "ROUND_ROBIN", "ROUND_ROBIN_PERFORMANCE" or "PRIORITY"
  FWFT_MODE = "TRUE",            // "TRUE"  - first word fall-trrough" mode
                                 // "FALSE" - normal fifo mode
  DATA_W = 32                    // data field width
)(

  input clk,                     // clock
  input nrst,                    // inverted reset

  // input ports
  input [WIDTH-1:0] r_empty,
  output [WIDTH-1:0] r_req,
  input [WIDTH-1:0][DATA_W-1:0] r_data,

  // output port
  input w_full,
  output logic w_req,
  output logic [DATA_W-1:0] w_data
);


  logic enc_valid;
  logic [WIDTH-1:0] enc_filt;
  logic [WIDTH_W-1:0] enc_bin;

  logic [WIDTH-1:0] r_empty_rev;
  reverse_vector #(
    .WIDTH( WIDTH )         // WIDTH must be >=2
  ) empty_rev (
    .in( r_empty[WIDTH-1:0] ),
    .out( r_empty_rev[WIDTH-1:0] )
  );

  generate
    if( ENCODER_MODE == "ROUND_ROBIN" ) begin
      round_robin_enc #(
        .WIDTH( WIDTH )
      ) rr_enc (
        .clk( clk ),
        .nrst( nrst ),
        .id( ~r_empty[WIDTH-1:0] ),
        .od_valid( enc_valid ),
        .od_filt( enc_filt[WIDTH-1:0] ),
        .od_bin( enc_bin[WIDTH_W-1:0] )
      );
    end else if( ENCODER_MODE == "ROUND_ROBIN_PERFORMANCE" ) begin
      round_robin_performance_enc #(
        .WIDTH( WIDTH )
      ) rr_perf_enc (
        .clk( clk ),                  // !!
        .nrst( nrst ),
        .id(~r_empty[WIDTH-1:0] ),
        .od_valid( enc_valid ),
        .od_filt( enc_filt[WIDTH-1:0] ),
        .od_bin( enc_bin[WIDTH_W-1:0] )
      );
    end else if( ENCODER_MODE == "PRIORITY" ) begin
      priority_enc #(
        .WIDTH( WIDTH )   // WIDTH must be >=2
      ) pri_enc (
        .id( ~r_empty[WIDTH-1:0] ),
        .od_valid( enc_valid ),
        .od_filt( enc_filt[WIDTH-1:0] ),
        .od_bin( enc_bin[WIDTH_W-1:0] )
      );
    end // ENCODER_MODE
  endgenerate


  logic r_valid;
  assign r_valid = enc_valid && ~w_full;

  assign r_req[WIDTH-1:0] = {WIDTH{r_valid}} &&
                               enc_filt[WIDTH-1:0];

  // buffering read data
  logic r_valid_d1 = 1'b0;
  logic [WIDTH_W-1:0] enc_bin_d1;
  logic [WIDTH-1:0][DATA_W-1:0] r_data_d1 = '0;
  always_ff @(posedge clk) begin
    if ( ~nrst ) begin
      r_valid_d1 <= 1'b0;
      enc_bin_d1[WIDTH_W-1:0] <= '0;
      r_data_d1[WIDTH-1:0] <= '0;
    end else begin
      r_valid_d1 <= r_valid;
      enc_bin_d1[WIDTH_W-1:0] <= enc_bin[WIDTH_W-1:0];
      r_data_d1[WIDTH-1:0] <= r_data[WIDTH-1:0];
    end
  end

  // routing data to write port
  generate
    if( FWFT_MODE == "TRUE" ) begin

      always_comb begin
        if ( ~nrst ) begin
          w_req = 1'b0;
          w_data[DATA_W-1:0] = '0;
        end else begin
          if( r_valid ) begin
            w_req = 1'b1;
            w_data[DATA_W-1:0] = r_data[enc_bin[WIDTH_W-1:0]][DATA_W-1:0];
          end else begin
            w_req = 1'b0;
            w_data[DATA_W-1:0] = '0;
          end
        end
      end

    end else if( FWFT_MODE == "FALSE" ) begin

      always_comb begin
        if ( ~nrst ) begin
          w_req = 1'b0;
          w_data[DATA_W-1:0] = '0;
        end else begin
          if( r_valid_d1 ) begin
            w_req = 1'b1;
            w_data[DATA_W-1:0] = r_data_d1[enc_bin_d1[WIDTH_W-1:0]][DATA_W-1:0];
          end else begin
            w_req = 1'b0;
            w_data[DATA_W-1:0] = '0;
          end
        end
      end

    end // FWFT_MODE
  endgenerate

  `include "clogb2.svh"

endmodule

