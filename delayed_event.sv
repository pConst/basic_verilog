//------------------------------------------------------------------------------
// delayed_event.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Module generates delayed pulse one clock width
// Could be useful for initialization or sequencing some tasks
// Could be easily daisy-chained by connecting "after_event" outputs
//   to the subsequent "ena" inputs
//
//  |
//  |___,___,   ,___,___,___,___,___,___,___,___,___,___,___,
//  |   ,   |___|   ,   ,   ,   ,   ,   ,   ,   ,   ,   ,   , nrst
//  |
//  |            <---------- DELAY -------->
//  |                                        ___
//  |___,___,___,___,___,___,___,___,___,___|   |___,___,___, on_event
//  |
//  |           ,___,___,___,___,___,___,___,
//  |___,___,___|   ,   ,   ,   ,   ,   ,   |___,___,___,___, before_event
//  |
//  |___,___,___                             ___,___,___,___,
//  |   ,   ,   |___,___,___,___,___,___,___|   ,   ,   ,   , after_event
//  |
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

delayed_event #(
  .DELAY( 8 )
) de1 (
  .clk( clk ),
  .nrst( nrst ),
  .ena(  ),

  .on_event(  ),        // one clock cycle
  .before_event(  ),
  .after_event(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module delayed_event #( parameter
  DELAY = 32,
  CNTR_WIDTH = $clog2(DELAY)
)(
  input clk,                          // system clock
  input nrst,                         // negative reset
  input ena,                          // enable

  output on_event,                    // one clock cycle
  output before_event,                // event outputs
  output after_event                  // event outputs
);


logic [CNTR_WIDTH-1:0] seq_cntr = CNTR_WIDTH'(DELAY);

logic seq_cntr_is_0;
assign seq_cntr_is_0 = (seq_cntr[CNTR_WIDTH-1:0]=='0);

always_ff @(posedge clk) begin
  if( ~nrst) begin
    seq_cntr[CNTR_WIDTH-1:0] <= DELAY;
  end else begin
    if( ena && ~seq_cntr_is_0 ) begin
      seq_cntr[CNTR_WIDTH-1:0] <= seq_cntr[CNTR_WIDTH-1:0] - 1'b1;
    end
  end // nrst
end

edge_detect cntr_edge (
  .clk( clk ),
  .nrst( 1'b1 ),
  .in( seq_cntr_is_0 ),
  .rising( on_event )
);

assign before_event = ~seq_cntr_is_0;
assign after_event = seq_cntr_is_0;


endmodule

