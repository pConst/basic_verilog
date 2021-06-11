//--------------------------------------------------------------------------------
// cdc_data.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Standard two-stage synchronizer
// CDC stands for "clock data crossing"
//
// In fact, this madule is just a wrapper for dalay.sv
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

cdc_data CD [31:0] (
  .clk( {32{clk}} ),
  .nrst( {32{1'b1}} ),
  .d( ext_data[31:0] ),
  .q( synchronized_data[31:0] )
);

--- INSTANTIATION TEMPLATE END ---*/


module cdc_data(
  input clk,
  input nrst,
  input d,
  output q
);

delay #(
    .LENGTH( 2 ),
    .WIDTH( 1 ),
    .TYPE( "CELLS" ),
    .REGISTER_OUTPUTS( "FALSE" )
) data_SYNC_ATTR (
    .clk( clk ),
    .nrst( nrst ),
    .ena( 1'b1 ),

    .in( d ),
    .out( q )
);

endmodule

