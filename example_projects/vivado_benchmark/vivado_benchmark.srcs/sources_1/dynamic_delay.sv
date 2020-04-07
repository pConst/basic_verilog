//--------------------------------------------------------------------------------
// dynamic_delay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Dynamic delay for arbitrary signal
//
//  CAUTION: The module intentionally does NOT implement error handling when
//           LENGTH is not a multiple of 2. Please handle "out of range"
//           checks externally.


/* --- INSTANTIATION TEMPLATE BEGIN ---

dynamic_delay #(
  .LENGTH( 8 )
  //.SEL_W( 3 )
) DD1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),
  .in(  ),
  .sel(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module dynamic_delay #( parameter
  LENGTH = 8,               // maximum delay chain width
  SEL_W = $clog2(LENGTH)    // output selector width
)(
  input clk,
  input nrst,
  input ena,
  input in,
  input [SEL_W-1:0] sel,     // output selector
  output logic out
);

logic [(LENGTH-1):0] data = 0;

integer i;
always_ff @(posedge clk) begin
  if (~nrst) begin
    data[(LENGTH-1):0] <= 0;
    out <= 0;
  end else if (ena) begin
    data[0] <= in;
    for (i=1; i<LENGTH; i=i+1) begin
      data[i] <= data[i-1];
    end
    out <= data[sel[SEL_W-1:0]];
  end
end

endmodule
