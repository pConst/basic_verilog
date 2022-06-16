//------------------------------------------------------------------------------
// pattern_detect.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Detects data pattern specified by the provided PATTERN
//
// Features capturing WIDTH bits simultaneously in case your data
// comes in parallel, like in QSPI interface, for example.
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

pattern_detect #(
  .DEPTH( 2 ),
  .WIDTH( 5 ),
  .PATTERN( 10'b11111_10011 )
) PD1 (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .data( data[4:0] ),
  .detected(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module pattern_detect #( parameter
  DEPTH = 1,
  WIDTH = 1,
  logic [DEPTH*WIDTH-1:0] PATTERN = '0
)(
  input clk,
  input nrst,

  input ena,
  input [WIDTH-1:0] data,

  output detected
);

  logic [DEPTH*WIDTH-1:0] samples = '0;
  always @ (posedge clk) begin
    if( ~nrst ) begin
      samples[DEPTH*WIDTH-1:0] <= '0;
    end else if( ena ) begin
      samples[DEPTH*WIDTH-1:0] <= {samples[DEPTH*WIDTH-WIDTH-1:0],data[WIDTH-1:0]};
    end
  end

  assign detected = (samples[DEPTH*WIDTH-1:0] == PATTERN[DEPTH*WIDTH-1:0]);

endmodule

