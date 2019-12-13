//------------------------------------------------------------------------------
// delay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Static Delay for arbitrary signal
// Another equivalent names for this module:
//          conveyor.sv
//          synchronizer.sv
//
// Tip for Xilinx-based implementations: Leave nrst=1'b1 and ena=1'b1 on
// purpose of inferring Xilinx`s SRL16E/SRL32E primitives
//
//
// CAUTION: delay module is widely used for synchronizing signals across clock
//   domains. To automatically exclude input data paths from timing analisys
//   set_false_path SDC constraint is integrated into this module. Applicable
//   only to Intel/Altera Quartus IDE. Xilinx users still should write the
//   constraints manually
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

delay #(
    .LENGTH( 2 )
) S1 (
    .clk( clk ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),
    .in(  ),
    .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module delay #( parameter
  LENGTH = 2    // delay/synchronizer chain length
                // default length for synchronizer chain is 2
)(
  input clk,
  input nrst,
  input ena,
  input in,
  output out
);

generate

  if ( LENGTH == 0 ) begin
    assign out = in;
  end else if( LENGTH == 1 ) begin

    logic data = 0;
    always_ff @(posedge clk) begin
      if (~nrst) begin
        data <= 0;
      end else if (ena) begin
        data <= in;
      end
    end
    assign out = data;

  end else begin

    logic [LENGTH:1] data = 0;
    always_ff @(posedge clk) begin
      if (~nrst) begin
        data[LENGTH:1] <= 0;
      end else if (ena) begin
        data[LENGTH:1] <= {data[LENGTH-1:1],in};
      end
    end
    assign out = data[LENGTH];

  end // if

endgenerate

endmodule
