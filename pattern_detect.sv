//------------------------------------------------------------------------------
// pattern_detect.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Detects data pattern specified by the provided PAT parameter
//
// Features capturing WIDTH bits simultaneously in case your data
// comes in parallel, like in QSPI interface, for example
//
// Detects pattern in any possible bit position, supposing that input data
// is an unaligned bit stream
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

pattern_detect #(
  .DEPTH( 2 ),
  .WIDTH( 16 ),

  // pattern parameters
  .PAT_WIDTH( 5 ),           // must be less than DEPTH*WIDTH
  .PAT( 5'b10011 )
) PD1 (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .data( data[4:0] ),

  .detected_pos(  )
  .detected(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module pattern_detect #( parameter
  DEPTH = 2,
  WIDTH = 16,

  PAT_WIDTH = 5,          // must be less than DEPTH*WIDTH
  bit [PAT_WIDTH-1:0] PAT = '1
)(
  input clk,
  input nrst,

  input ena,
  input [WIDTH-1:0] data,

  output logic detected,
  output logic [DEPTH*WIDTH-1:0] detected_mask
);

  logic [DEPTH*WIDTH-1:0] sample_buf = '0;
  logic [DEPTH*WIDTH-1:0] ena_buf = '0;
  always @ (posedge clk) begin
    if( ~nrst ) begin
      sample_buf[DEPTH*WIDTH-1:0] <= {DEPTH*WIDTH{1'b0}};
      ena_buf[DEPTH*WIDTH-1:0] <= {DEPTH*WIDTH{1'b0}};
    end else begin
      sample_buf[DEPTH*WIDTH-1:0] <= {sample_buf[DEPTH*WIDTH-WIDTH-1:0],
                                      data[WIDTH-1:0]};
      ena_buf[DEPTH*WIDTH-1:0] <= {ena_buf[DEPTH*WIDTH-WIDTH-1:0],
                                  {WIDTH{ena}} };
    end
  end

  always_comb begin
    integer i;

    detected_mask[DEPTH*WIDTH-1:0] = '0;
    for( i=0; i<(DEPTH*WIDTH-PAT_WIDTH); i++ ) begin
      if( sample_buf[i+:PAT_WIDTH] == PAT[PAT_WIDTH-1:0] &&
          ena_buf[i+:PAT_WIDTH]) begin
        detected_mask[i] = 1'b1;
      end
    end
    detected = |detected_mask[DEPTH*WIDTH-1:0];
  end

endmodule

