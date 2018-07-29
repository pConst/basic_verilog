//--------------------------------------------------------------------------------
// EdgeDetect.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Variable width edge detector
//  One tick propagation time


/* --- INSTANTIATION TEMPLATE BEGIN ---

EdgeDetect #(
  .WIDTH( 32 )
) ED1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .in(  ),
  .rising(  ),
  .falling(  ),
  .both(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module EdgeDetect #(
  WIDTH = 1
)(
  input clk,
  input nrst,

  input [(WIDTH-1):0] in,
  output logic [(WIDTH-1):0] rising = 0,
  output logic [(WIDTH-1):0] falling = 0,
  output [(WIDTH-1):0] both
);


logic [(WIDTH-1):0] in_prev = 0;

always_ff @(posedge clk) begin
	if ( ~nrst ) begin
	  in_prev <= 0;
		rising <= 0;
		falling <= 0;
	end
	else begin
		in_prev <= in;
    rising[(WIDTH-1):0] <= in[(WIDTH-1):0] & ~in_prev[(WIDTH-1):0];
    falling[(WIDTH-1):0] <= ~in[(WIDTH-1):0] & in_prev[(WIDTH-1):0];
	end
end

assign both[(WIDTH-1):0] = rising[(WIDTH-1):0] | falling[(WIDTH-1):0];

endmodule
