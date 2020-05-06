//------------------------------------------------------------------------------
// pdm_modulator.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Pulse density modulation (PDM) generator module
//
// - expecting 8-bit control signal input by default
// - system clock is 100 MHz by default
//
// - see also pwm_modulator.sv for pulse width modulation generator


/* --- INSTANTIATION TEMPLATE BEGIN ---

pdm_modulator #(
  .PDM_PERIOD_DIV( 9 )
  .MOD_WIDTH( 8 )                    // from 0 to 255
) pdm1 (
  .clk( clk ),
  .nrst( nrst ),

  .control(  ),
  .pdm_out(  ),

  .start_strobe(  ),
  .busy(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module pdm_modulator #( parameter
  CLK_HZ = 100_000_000,
  PDM_PERIOD_DIV = 16,                // must be > MOD_WIDTH
  PDM_MIN_PERIOD_HZ = CLK_HZ / (2**PDM_PERIOD_DIV) * (0+2),    // two PDM clock cycles
  PDM_MAX_PERIOD_HZ = CLK_HZ / (2**PDM_PERIOD_DIV) * (256+2),

  MOD_WIDTH = 8                       // modulation bitness
)(
  input clk,                          // system clock
  input nrst,                         // negative reset

  input [MOD_WIDTH-1:0] mod_setpoint, // modulation setpoint
  output pdm_out,                     // active HIGH output

  // status outputs
  output start_strobe,                // period start strobe
  output busy                         // busy output
);


// period generator
logic [31:0] div_clk;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .out( div_clk[31:0] )
);


// pulse generator
pulse_gen #(
  .CNTR_WIDTH( MOD_WIDTH+1 )
) pg1 (
  .clk( div_clk[(PDM_PERIOD_DIV-1)-MOD_WIDTH] ),
  .nrst( nrst ),

  .start( 1'b1 ),
  .cntr_max( mod_setpoint[MOD_WIDTH-1:0]+2 ),
  .cntr_low( 1 ),

  .pulse_out( pdm_out ),

  .start_strobe( start_strobe ),
  .busy( busy )
);


endmodule

