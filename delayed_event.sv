//------------------------------------------------------------------------------
// delayed_event.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Module generates delayed pulse one clock width
//
// - Could be useful for initialization or sequencing some tasks
// - Could be easily daisy-chained by connecting "after_event" outputs
//   to the subsequent "ena" inputs
// - Only one event can be triggered after every reset
// - Delay operation could be suspended by setting ena to 0 at any time


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
  DELAY = 32
)(
  input clk,                          // system clock
  input nrst,                         // negative reset
  input ena,                          // enable

  output on_event,                    // one clock cycle
  output before_event,                // event outputs
  output after_event                  // event outputs
);


  localparam CNTR_W = $clog2(DELAY+1);

  generate
    //==========================================================================
    if ( DELAY == 0 ) begin

      logic ena_rise;
      edge_detect event_edge (
        .clk( clk ),
        .anrst( nrst ),
        .in( ena ),
        .rising( ena_rise )
      );

      assign on_event = ena_rise;
      assign before_event = 1'b0;
      assign after_event = 1'b1;

    //==========================================================================
    end else if ( DELAY == 1 ) begin

      logic ena_d1 = 1'b0;
      always_ff @(posedge clk) begin
        if( ~nrst ) begin
          ena_d1 <= 1'b0;
        end else begin
          ena_d1 <= ena;
        end
      end

      logic ena_rise;
      edge_detect event_edge (
        .clk( clk ),
        .anrst( nrst ),
        .in( ena_d1 ),
        .rising( ena_rise )
      );

      logic got_ena = 1'b0;
      always_ff @(posedge clk) begin
        if( ~nrst ) begin
          got_ena <= 1'b0;
        end if( on_event ) begin
          got_ena <= 1'b1;
        end
      end

      assign on_event = ena_rise;
      assign before_event = !got_ena && !ena_rise;
      assign after_event = got_ena || ena_rise;

    //==========================================================================
    end else begin

      logic [CNTR_W-1:0] seq_cntr = CNTR_W'(DELAY);

      logic seq_cntr_is_0;
      assign seq_cntr_is_0 = (seq_cntr[CNTR_W-1:0]=='0);

      always_ff @(posedge clk) begin
        if( ~nrst) begin
          seq_cntr[CNTR_W-1:0] <= CNTR_W'(DELAY);
        end else begin
          if( ena && ~seq_cntr_is_0 ) begin
            seq_cntr[CNTR_W-1:0] <= seq_cntr[CNTR_W-1:0] - 1'b1;
          end
        end // nrst
      end

      edge_detect event_edge (
        .clk( clk ),
        .anrst( 1'b1 ),
        .in( seq_cntr_is_0 ),
        .rising( on_event )
      );

      assign before_event = ~seq_cntr_is_0;
      assign after_event = seq_cntr_is_0;

    end
  endgenerate

endmodule

