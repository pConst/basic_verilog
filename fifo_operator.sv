//------------------------------------------------------------------------------
// fifo_operator.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Performs custom operation on data words from multiple FIFOs and stores
//  result to a single output FIFO.
//  Reads only if ALL input FIFOs have data.
//  Source code could be easily adapted to apply any operator on input data.
//
//  See also fifo_combiner.sv
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

fifo_operator #(
  .WIDTH( 2 ),
  .FWFT_MODE( "TRUE" ),
  .DATA_W( 32 )
) FO1 (
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

module fifo_operator #( parameter

  WIDTH = 2,                     // number of input fifo ports to opeate on
  WIDTH_W = clogb2(WIDTH),       // input port index width
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


  logic r_valid;
  assign r_valid = ~|r_empty && ~w_full;

  assign r_req[WIDTH-1:0] = {WIDTH{r_valid}};

  // buffering read data
  logic r_valid_d1 = 1'b0;
  logic [WIDTH-1:0][DATA_W-1:0] r_data_d1 = '0;
  always_ff @(posedge clk) begin
    if ( ~nrst ) begin
      r_valid_d1 <= 1'b0;
      r_data_d1[WIDTH-1:0] <= '0;
    end else begin
      r_valid_d1 <= r_valid;
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
            w_data[DATA_W-1:0] = operator(r_data);
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
            w_data[DATA_W-1:0] = operator(r_data_d1);
          end else begin
            w_req = 1'b0;
            w_data[DATA_W-1:0] = '0;
          end
        end
      end

    end // FWFT_MODE
  endgenerate

  // bitwize OR operator, as an example
  function [DATA_W-1:0] operator (
    input [WIDTH-1:0][DATA_W-1:0] data
  );
    integer i;
    operator[DATA_W-1:0] = '0;
    for( i=0; i<WIDTH; i=i+1 ) begin
      operator[DATA_W-1:0] = operator[DATA_W-1:0] | data[i];
    end
  endfunction

  `include "clogb2.svh"

endmodule

