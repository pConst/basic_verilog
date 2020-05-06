//------------------------------------------------------------------------------
// pwm_modulator.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Pulse width modulation (PWM) generator module
//
// - expecting 8-bit control signal input by default
// - system clock is 100 MHz by default
// - PWM clock is 1.5KHz by default
//
// - see also pdm_modulator.sv for pulse density modulation generator


/* --- INSTANTIATION TEMPLATE BEGIN ---

pwm_modulator #(
  .PWM_PERIOD_DIV( 16 )              // 100MHz/2^16= ~1.526 KHz
  .MOD_WIDTH( 8 )                    // from 0 to 255
) pwm1 (
  .clk( clk ),
  .nrst( nrst ),

  .control(  ),
  .pwm_out(  ),

  .start_strobe(  ),
  .busy(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module pwm_modulator #( parameter
  CLK_HZ = 100_000_000,
  PWM_PERIOD_DIV = 16,                // must be > MOD_WIDTH
  PWM_PERIOD_HZ = CLK_HZ / (2**PWM_PERIOD_DIV),

  MOD_WIDTH = 8                       // modulation bitness
)(
  input clk,                          // system clock
  input nrst,                         // negative reset

  input [MOD_WIDTH-1:0] mod_setpoint, // modulation setpoint
  output pwm_out,                     // active HIGH output

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


// optional setpoint inversion
logic [MOD_WIDTH-1:0] mod_setpoint_inv;
assign mod_setpoint_inv[MOD_WIDTH-1:0] = {MOD_WIDTH{1'b1}} - mod_setpoint[MOD_WIDTH-1:0];


// pulse generator
pulse_gen #(
  .CNTR_WIDTH( MOD_WIDTH+1 )
) pg1 (
  .clk( div_clk[(PWM_PERIOD_DIV-1)-MOD_WIDTH] ),
  .nrst( nrst ),

  .start( 1'b1 ),
  .cntr_max( {1'b0, {MOD_WIDTH{1'b1}} } ),
  .cntr_low( {1'b0, mod_setpoint_inv[MOD_WIDTH-1:0] } ),

  .pulse_out( pwm_out ),

  .start_strobe( start_strobe ),
  .busy( busy )
);


endmodule

