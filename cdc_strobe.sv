//--------------------------------------------------------------------------------
// cdc_strobe.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Clock crossing setup for single-pulse strobes
// CDC stands for "clock data crossing"
//
// This is a simplest form of strobe CDC circuit. Good enough for rare single
//   strobe events. This module does NOT support close-standing strobes,
//   placed in adjacent lock cycles
//
// Don`t forget to write false_path constraints for all your synchronizers
//   The best way to do it - is to mark all synchonizer delay.sv instances
//   with "_SYNC_ATTR" suffix. After that, just one constraint is required:
//
// For Quartus:
// set_false_path -to [get_registers {*delay:*_SYNC_ATTR*|data[1]*}]
//
// For Vivado:
// set_false_path -to [get_cells -hier -filter {NAME =~ *_SYNC_ATTR/data_reg[1]*}]
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

cdc_strobe CS [7:0] (
  .clk1_i( {8{clk1}} ),
  .nrst1_i( {8{1'b1}} ),
  .strb1_i( input_strobes[7:0] ),

  .clk2_i( {8{clk2}} ),
  .strb2_o( output_strobes[7:0] )
);

--- INSTANTIATION TEMPLATE END ---*/


module cdc_strobe #( parameter
  PRE_STRETCH( 2 )      // number of cycles to stretch input strobe
)(
  input clk1_i,         // clock domain 1 clock
  input nrst1_i,        // clock domain 1 reset (inversed)
  input strb1_i,        // clock domain 1 strobe

  input clk2_i,         // clock domain 2 clock
  output strb2_o        // clock domain 2 strobe
);

// This signal should be at_least(!!!) one clk2_i period long
// Preliminary stretching is usually nessesary, unless you are crossing
//   to essentialy high-frequency clock clk2_i, that is > 2*clk1_i
logic strb1_stretched;

pulse_stretch #(
  .WIDTH( PRE_STRETCH ),
  .USE_CNTR( 0 )
) stretch_strb1 (
  .clk( clk1_i ),
  .nrst( nrst1_i ),
  .in( strb1_i ),
  .out( strb1_stretched )
);

// This is a synchronized signal in clk2_i clock domain,
//   but no guarantee, that it is one-cycle-high
logic strb2_stretched;

delay #(
    .LENGTH( 2 ),
    .WIDTH( 1 ),
    .TYPE( "CELLS" ),
    .REGISTER_OUTPUTS( "FALSE" )
) delay_strb1_SYNC_ATTR (
    .clk( clk2_i ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),

    .in( strb1_stretched ),
    .out( strb2_stretched )
);

edge_detect ed_strb2 (
  .clk( clk2_i ),
  .nrst( 1'b1 ),
  .in( strb2_stretched ),
  .rising( strb2_o ),      // and now the signal is definitely one-cycle-high
  .falling(  ),
  .both(  )
);

endmodule

